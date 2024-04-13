{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pipx
    poetry
    python3
  ];
}