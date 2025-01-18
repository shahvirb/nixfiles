{ lib, pkgs, modulesPath, systemSettings, userSettings, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/common.nix
    ../../modules/1password.nix
    ../../modules/sshkeys.nix
    ( import ../../modules/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
  ];

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  # For the Unifi network docker container
  networking.firewall = {
    allowedTCPPorts = [ 6789 8080 8443 8843 8880 ];
    allowedUDPPorts = [ 1900 3478 5514 10001 ];
  };

  system.stateVersion = "23.11";
}
