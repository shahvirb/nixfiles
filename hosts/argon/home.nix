{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/talosctl.nix
  ];

  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.stateVersion = "23.11";
}
