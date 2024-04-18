{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # This is needed for gnomeExtensions.appindicator
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}