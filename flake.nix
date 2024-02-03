{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    homeManager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      identity = import ./identity;
      systemSettings = import ./system-settings;
      system = systemSettings.system;
    in
    {
      nixosConfigurations = {
        probook = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
          	inherit identity;
          	inherit systemSettings;
          };
          modules = [
            ./configuration.nix
            inputs.homeManager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${identity.username} = import ./home-manager;
                extraSpecialArgs = {
                	inherit identity;
                	inherit systemSettings;
                };
              };
            }
            {
            	environment.variables = {
            		EDITOR = systemSettings.defaultEditor;
            	};
            }
          ];
        };
      };
    };
}
