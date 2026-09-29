{ lib, pkgs, userSettings, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/proxmox-vm.nix
    ../../modules/1password.nix
    ../../modules/sshkeys.nix
    (import ../../modules/docker.nix {
      storageDriver = null;
      inherit pkgs userSettings lib;
    })
  ];

  services.tailscale.enable = false;

  system.stateVersion = "26.05";
}
