{ pkgs, inputs, ... }:
{
  imports = [
    ../../home-manager/ai-tools.nix
    ../../home-manager/common.nix
    ../../home-manager/talosctl.nix
    # ../../home-manager/komodo-periphery.nix
    ../../home-manager/python.nix
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.stateVersion = "23.11";
}
