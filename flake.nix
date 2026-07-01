{
  description = "System setup flake";

  outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, ... }:
    let
      userSettings = rec {
        username = "shahvirb"; # username on the system
        name = "Shahvir"; # name/identifier on the system
        email = "shahvirb@gmail.com";
        gitUserName = "shahvirb";
        gitUserEmail = "shahvirb@gmail.com";
        homeDirectory = "/home/shahvirb";
      };

      source = builtins.path {
        path = /etc/nixos;
        name = "source";
        filter = path: type:
          let base = baseNameOf path;
          in base != ".git";
      };

      mkHost = hostname:
        let
          hostSettings = import (source + "/hosts/${hostname}/systemSettings.nix");

          isStable = hostSettings.profile == "lxc";

          pkgs-stable = import nixpkgs-stable {
            system = hostSettings.system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
          };

          pkgs = if isStable then pkgs-stable else
            import nixpkgs-unstable {
              system = hostSettings.system;
              config = {
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
              };
            };

          lib = if isStable then nixpkgs-stable.lib else nixpkgs-unstable.lib;

          hm = if isStable then home-manager-stable else home-manager-unstable;
        in
          lib.nixosSystem {
            system = hostSettings.system;
            modules = [
              (source + "/hosts/${hostname}/configuration.nix")
              hm.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${userSettings.username} = import (source + "/hosts/${hostname}/home.nix");
                home-manager.extraSpecialArgs = {
                  inherit pkgs-stable;
                  systemSettings = hostSettings;
                  inherit userSettings;
                  inherit inputs;
                };
              }
            ];
            specialArgs = {
              inherit pkgs-stable;
              systemSettings = hostSettings;
              inherit userSettings;
              inherit inputs;
            };
          };

      hostDirs = builtins.attrNames (builtins.readDir (source + "/hosts"));
    in {
      nixosConfigurations = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = mkHost hostname;
      }) hostDirs);
    };

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-26.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    repo-9999years-nix-config = {
      url = "github:9999years/nix-config";
      flake = false; # Treat it as a raw Git repository, not a flake
    };
  };
}
