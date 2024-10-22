{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;  # Ensure unfree packages are allowed in this import
    };
  };

  unstablePackages = with pkgsUnstable; [
  ];
in
{
  home.packages = with pkgs; [
  ] ++ unstablePackages;

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];
}
