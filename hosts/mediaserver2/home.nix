{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    # ../../home-manager/vuetorrent.nix
  ];

  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];

  home.stateVersion = "23.11";
}
