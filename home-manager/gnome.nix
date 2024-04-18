{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.gtile
    gnomeExtensions.vitals
  ];
}