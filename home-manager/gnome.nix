{ config, pkgs, ... }:

{
  # Read https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/ for a good procedure on dconf watch
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-panel@jderose9.github.com"
        "gTile@vibou"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
      ];
    };
  };

  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-panel
    gnomeExtensions.gtile
    gnomeExtensions.vitals
  ];
}