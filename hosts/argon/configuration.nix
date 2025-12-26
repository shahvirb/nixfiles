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

  networking.firewall = lib.mkMerge [
    { # homepage
      allowedTCPPorts = [ 8992 ];
    }
    { # komodo periphery
      allowedTCPPorts = [ 8120 ];
    }
    { # tandoor
      allowedTCPPorts = [ 8014 ];
    }
    { # unifi controller
      allowedTCPPorts = [ 6789 8087 8443 8843 8880 ];
      allowedUDPPorts = [ 1900 3478 5514 10001 ];
    }
    { # netalertx
      allowedTCPPorts = [ 20211 ];
    }
  ];

  system.stateVersion = "23.11";
}
