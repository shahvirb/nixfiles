{ config, pkgs, enableDashToPanel ? true, ... }:

{
  # Read https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/ for a good procedure on dconf watch
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "gTile@vibou"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
      ] ++ (if enableDashToPanel then["dash-to-panel@jderose9.github.com"] else []);
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
  };

  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.gtile
    gnomeExtensions.vitals
  ] ++ (if enableDashToPanel then [gnomeExtensions.dash-to-panel] else []);
}