{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;  # Ensure unfree packages are allowed in this import
    };
  };

  unstablePackages = with pkgsUnstable; [
    brave
    zoom-us
  ];
in
{
  home.packages = with pkgs; [
    gh
    popsicle # For making bootable USBs
  ] ++ unstablePackages;
}
