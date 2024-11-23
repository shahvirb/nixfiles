{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.my-gnome;
in
{
  options.services.my-gnome = {
    enableDashToPanel = mkEnableOption "Enable dash-to-panel gnome extension";
  };

  config = {
    services.my-gnome.enableDashToPanel = mkDefault true;

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
        ] ++ (if cfg.enableDashToPanel then ["dash-to-panel@jderose9.github.com"] else []);
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vscode/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vscode-nixos/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser" = {
        binding = "<Ctrl><Alt>t";
        command = "brave";
        name = "Launch Browser";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Ctrl><Alt>t";
        command = "alacritty";
        name = "Launch Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vscode" = {
        binding = "<Ctrl><Alt>v";
        command = "code";
        name = "Launch VSCode";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vscode-nixos" = {
        binding = "<Ctrl><Alt>n";
        command = "code /etc/nixos";
        name = "Launch VSCode /etc/nixos";
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
    ] ++ (if cfg.enableDashToPanel then [gnomeExtensions.dash-to-panel] else []);
  };
}
