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

  # users.groups = {
  #   mediaauthor = {
  #     gid = 1000;
  #   };
  # };
  # users.users.${userSettings.username}.extraGroups = [ "mediaauthor" ];

  networking.firewall = {
    allowedTCPPorts = [ 
      # Plex
      6789 8087 8443 8843 8880 
      # Frigate
      8971 8554 8555 
    ];
    allowedUDPPorts = [ 
      # Plex
      1900 3478 5514 10001 
      # Frigate
      8555 
    ];
  };

  system.stateVersion = "23.11";
}
