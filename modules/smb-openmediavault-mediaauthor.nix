{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.samba4Full ];
  fileSystems."/mnt/Media" = {
    device = "//openmediavault/Media";
    fsType = "cifs";
    # options = let
    #   automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    # in ["${automount_opts},credentials=/etc/nixos/omv-mediaauthor.secrets,vers=3.1.1,uid=1000,gid=1000"];
    options = ["_netdev,***REMOVED***,password=***REMOVED***,vers=3.1.1,uid=1000,gid=1000,noauto,x-systemd.automount,x-systemd.idle-timeout=3600"];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
  };
}