{ config, lib, pkgs, systemSettings, userSettings, ... }:
with lib;
{
  config = mkMerge [
    {
      home.username = userSettings.username;
      home.homeDirectory = userSettings.homeDirectory;
      
      home.packages = with pkgs; [
        dig
        gh
        micro
        uv
        wget
      ];

      programs.bash = {
        enable = true;
        bashrcExtra = ''
          [ -f /etc/nixos/op-service-account.secrets ] && source /etc/nixos/op-service-account.secrets
        '';
        initExtra = ''
          nixclean() {
            sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than "$1"
            sudo nix-collect-garbage --delete-older-than "$1"
          }
        '';
      };

      programs.git = {
        enable = true;
        # extraConfig = {
        #   credential.helper = "oauth";
        # };
        settings = {
          user.name = userSettings.gitUserName;
          user.email = userSettings.gitUserEmail;
        };
      };

      programs.home-manager.enable = true;
    }
    (mkIf (systemSettings.profile == "graphical") {
      home.packages = with pkgs; [
        brave
        git-credential-oauth
        google-chrome
        joplin-desktop
        legcord
        libreoffice-qt
        protonvpn-gui
        spotify
        sublime4
        tilix
        vscode
      ];

      programs.git.settings = {
        credential.helper = "oauth";
      };
    })
  ];
}
