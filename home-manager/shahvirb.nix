{ config, pkgs, ... }:

{
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    discord
    firefox
    git-credential-oauth
    spotify
    sublime4
    vscode
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      nrbb = "sudo nixos-rebuild boot";
      nrbs = "sudo nixos-rebuild switch";
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "oauth";
    };
    userName = "Shahvir Buhariwalla";
    userEmail = "shahvirb@gmail.com";
  };

  programs.home-manager.enable = true;

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