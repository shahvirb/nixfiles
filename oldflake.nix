{
  description = "System configuration flake";

  outputs = { self, nixpkgs, ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "argon"; # hostname
        # profile = "personal"; # select a profile defined from my profiles directory
        # timezone = "America/Chicago"; # select timezone
        # locale = "en_US.UTF-8"; # select locale
        # bootMode = "uefi"; # uefi or bios
        # bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        # grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ("./hosts" + ("/" + systemSettings.hostname) + "/configuration.nix")
          ];
          # specialArgs = {
          #   # pass config variables from above
          #   inherit pkgs-stable;
          #   inherit systemSettings;
          #   inherit userSettings;
          #   inherit inputs;
          # };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}