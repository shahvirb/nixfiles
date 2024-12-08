{pkgs, ... }:
{
  imports = [
    ../../home-manager/shahvirb.nix
  ];

  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.stateVersion = "23.11";
}
