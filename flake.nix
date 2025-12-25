{
  description = "System setup flake";

  outputs = inputs@{ self, ... }:
    let
      systemSettings = import ./systemSettings.nix;

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "shahvirb"; # username on the system
        name = "Shahvir"; # name/identifier on the system
        email = "shahvirb@gmail.com";
        gitUserName = "shahvirb";
        gitUserEmail = "shahvirb@gmail.com";
        homeDirectory = "/home/shahvirb";
      };

      # configure pkgs
      # use nixpkgs if running a server (lxc profile)
      # otherwise use nixos-unstable nixpkgs
      pkgs = (if (systemSettings.profile == "lxc")
              then
                pkgs-stable
              else
                (import inputs.nixpkgs-unstable {
                  system = systemSettings.system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                }));

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      # configure lib
      # use nixpkgs if running a server (lxc profile)
      # otherwise use patched nixos-unstable nixpkgs
      lib = (if (systemSettings.profile == "lxc")
             then
               inputs.nixpkgs-stable.lib
             else
               inputs.nixpkgs-unstable.lib);

      # use home-manager-stable if running a server (lxc profile)
      # otherwise use home-manager-unstable
      home-manager = (if (systemSettings.profile == "lxc")
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);
    in {
      nixosConfigurations = {
        "${systemSettings.hostname}" = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/hosts/${systemSettings.hostname}/configuration.nix")

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userSettings.username} = import (./. + "/hosts/${systemSettings.hostname}/home.nix");

              home-manager.extraSpecialArgs = {
                inherit pkgs-stable;
                inherit systemSettings;
                inherit userSettings;
                inherit inputs;
              };
            }

          ];
          specialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
    };

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-25.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    repo-9999years-nix-config = {
      url = "github:9999years/nix-config";
      flake = false; # Treat it as a raw Git repository, not a flake
    };
  };
}
