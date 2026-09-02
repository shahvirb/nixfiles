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

  networking.firewall = lib.mkMerge [
    { # Dispatcharr
      allowedTCPPorts = [ 9191 ];
    }
    { # komodo-periphery
      allowedTCPPorts = [ 8120 ];
    }
    { # Frigate
      allowedTCPPorts = [ 8554 8555 8971 ];
      allowedUDPPorts = [ 8555 ];
    }
    { # Plex
      allowedTCPPorts = [ 6789 8087 8443 8843 8880 ];
      allowedUDPPorts = [ 1900 3478 5514 10001 ];
    }
    { # qbittorrent
      allowedTCPPorts = [ 8099 ];
    }
    { # CodeNomad
      allowedTCPPorts = [ 9898 ];
    }
  ];

  systemd.services.dispatcharr-fix-channels = {
    description = "Dispatcharr fix channels - Cron Job";
    path = [
      "/etc/profiles/per-user/shahvirb"
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "shahvirb";
      WorkingDirectory = "/home/shahvirb/gitsource/dispatcharr-fix-channels";
      ExecStart = "/home/shahvirb/gitsource/dispatcharr-fix-channels/cron_infinitytv_headless.sh";
    };
  };

  systemd.timers.dispatcharr-fix-channels = {
    description = "Run dispatcharr-fix-channels weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Fri *-*-* 10:00:00";
      Persistent = true;
    };
  };

  system.stateVersion = "23.11";
}
