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

  # for steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  system.stateVersion = "23.11";
}
