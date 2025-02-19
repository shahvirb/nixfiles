{ config, pkgs, ... }:

{
  config = {

    # Read https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/ for a good procedure on dconf watch
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        # Run "gnome-extensions list" for a list
        enabled-extensions = [
          "paperwm@paperwm.github.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "Vitals@CoreCoding.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
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
        binding = "<Ctrl><Alt>b";
        command = "brave";
        name = "Launch Browser";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
        binding = "<Ctrl><Alt>t";
        command = "tilix";
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

      # For independent monitor display scaling as per https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/17
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
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
      gnome-tweaks
      gnomeExtensions.gtile
      gnomeExtensions.vitals
      gnomeExtensions.paperwm
    ];
  };
}
