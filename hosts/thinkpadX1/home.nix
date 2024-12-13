{pkgs, ... }:
{
  imports = [
    ../../home-manager/1password.nix
    ../../home-manager/firefox.nix
    ../../home-manager/gnome.nix
    ../../home-manager/python.nix
    ../../home-manager/common.nix
  ];

  home.packages = with pkgs; [
    gh
    git-filter-repo
    popsicle # For making bootable USBs
    roomeqwizard
  ];

  home.stateVersion = "23.11";
}
