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

  # For the Unifi controller
  networking.firewall = {
    allowedTCPPorts = [ 6789 8080 8081 8443 8843 8880 ];
    allowedUDPPorts = [ 3478 10001 ];
  };

  system.stateVersion = "23.11";
}
