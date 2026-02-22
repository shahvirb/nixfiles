{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/komodo-periphery.nix
    ../../home-manager/gemini-cli.nix
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];

  home.stateVersion = "23.11";
}
