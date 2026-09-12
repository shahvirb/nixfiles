{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/ai-tools.nix
    ../../home-manager/python.nix
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];

  home.stateVersion = "23.11";
}
