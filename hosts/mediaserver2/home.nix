{pkgs, ... }:
{
  imports = [
    ../../home-manager/1password.nix
    ../../home-manager/shahvirb.nix
    ../../home-manager/vuetorrent.nix
  ];

  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];

  home.stateVersion = "23.11";
}
