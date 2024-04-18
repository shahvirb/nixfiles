{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "http://helium:8992";
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";

          # "widget.use-xdg-desktop-portal.file-picker" = 1;
          "browser.aboutConfig.showWarning" = false;
          # "browser.compactmode.show" = true;
          "browser.cache.disk.enable" = false; # Be kind to hard drive

          # "widget.disable-workspace-management" = true;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
        };
      };
    };
  };
}