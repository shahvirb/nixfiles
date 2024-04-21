{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-panel
    gnomeExtensions.gtile
    gnomeExtensions.vitals
  ];
}