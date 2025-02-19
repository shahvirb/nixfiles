{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/firefox.nix
    ../../home-manager/gnome.nix
    ../../home-manager/python.nix
    ../../home-manager/talosctl.nix
  ];

  home.packages = with pkgs; [
    gh
    git-filter-repo
    popsicle # For making bootable USBs
    sqlitebrowser
    zoom-us
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.stateVersion = "23.11";
}
