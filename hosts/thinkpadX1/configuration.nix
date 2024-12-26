{ lib, pkgs, modulesPath, systemSettings, userSettings, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    ./hardware-configuration.nix
    ../../modules/1password.nix
    ../../modules/common.nix
    ../../modules/gnome-system.nix
    ../../modules/gnome-rdp.nix
    ../../modules/smb-openmediavault-mediaauthor.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
