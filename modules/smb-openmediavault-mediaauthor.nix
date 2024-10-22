{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.samba4Full ];
  fileSystems."/mnt/Media" = {
    device = "//openmediavault/Media";
    fsType = "cifs";
    options = ["_netdev,credentials=/etc/nixos/omv-mediaauthor.secrets,vers=3.1.1,uid=1000,gid=1000,noauto,x-systemd.automount,x-systemd.idle-timeout=3600"];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
  };
}