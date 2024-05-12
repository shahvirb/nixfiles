{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;  # Ensure unfree packages are allowed in this import
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  unstablePackages = with pkgsUnstable; [
    kodi
    plex-media-player
    vlc
  ];
in
{
  home.packages = with pkgs; [
    cifs-utils
  ] ++ unstablePackages;
}