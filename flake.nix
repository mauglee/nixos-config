{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    homeManager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs = inputs:
    let
      identity = import ./identity;
      systemSettings = import ./system-settings;
      system = systemSettings.system;
      specialArgs = {
        inherit identity systemSettings;
      };
      commonModules = [
        ./configuration-common.nix
        inputs.agenix.nixosModules.age
        { environment.systemPackages = [ inputs.agenix.packages.${system}.default ]; }
        inputs.homeManager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${identity.username} = import ./home-manager;
            extraSpecialArgs = {
              inherit identity systemSettings;
            };
          };
        }
        {
          environment.variables = {
            EDITOR = systemSettings.defaultEditor;
          };
        }
      ];
      makeSystem = hostname: inputs.nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./hosts/${hostname}/configuration.nix
          ] ++ commonModules;
      };
      hostnames = builtins.attrNames (inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./hosts));
      nixosConfigurations = inputs.nixpkgs.lib.genAttrs hostnames ( hostname: makeSystem hostname );
    in
    {
      inherit nixosConfigurations;
    };
}
