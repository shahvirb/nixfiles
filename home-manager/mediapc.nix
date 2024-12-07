{pkgs, ... }:

{
  home.packages = with pkgs; [
    kodi
    plex-media-player
    vlc
  ];
}
