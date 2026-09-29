{ ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/ai-tools.nix
    ../../home-manager/python.nix
  ];

  home.stateVersion = "26.05";
}
