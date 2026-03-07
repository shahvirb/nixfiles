{ pkgs, inputs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/komodo-periphery.nix
    ../../home-manager/talosctl.nix
    ../../home-manager/ai-tools.nix
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.stateVersion = "23.11";
}
