{pkgs, ... }:
{
  # environment.systemPackages = [ pkgs.sambaFull ];
  fileSystems."/mnt/Media" = {
    device = "//openmediavault/Media";
    fsType = "cifs";
    options = ["_netdev,credentials=/etc/nixos/omv-mediaauthor.secrets,vers=3.1.1,uid=1000,gid=1000,noauto,x-systemd.automount,x-systemd.idle-timeout=3600"];
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings.global.security = "user";
    package = pkgs.sambaFull.override {
      # Workaround for https://github.com/NixOS/nixpkgs/issues/359723
      enableCephFS = false;
    };
  };
}