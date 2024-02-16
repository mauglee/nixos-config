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
        inputs.agenix.nixosModules.default
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
          modules = [ ./hosts/${hostname}/configuration.nix ] ++ commonModules;
      };
      virtunix = makeSystem "virtunix";
      probook = makeSystem "probook";
    in
    {
      nixosConfigurations = {
        inherit virtunix probook;
      };
    };
}
