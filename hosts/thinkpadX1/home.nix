{pkgs, ... }:
{
  imports = [
    ../../home-manager/firefox.nix
    ../../home-manager/gnome.nix
    ../../home-manager/python.nix
    ../../home-manager/common.nix
    ../../home-manager/talosctl.nix
  ];

  home.packages = with pkgs; [
    gh
    git-filter-repo
    popsicle # For making bootable USBs
    steam
    roomeqwizard
  ];

  home.stateVersion = "23.11";
}
