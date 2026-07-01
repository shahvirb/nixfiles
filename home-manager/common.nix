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
        initExtra = ''
          nixclean() {
            sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than "$1"
            sudo nix-collect-garbage --delete-older-than "$1"
          }
        '';
        shellAliases = {
          nrbb = "sudo nixos-rebuild boot --flake path:/etc/nixos#$(hostname) --impure";
          nrbs = "sudo nixos-rebuild switch --flake path:/etc/nixos#$(hostname) --impure";
          nrbsu = "sudo nix flake update && sudo nixos-rebuild boot --flake path:/etc/nixos#$(hostname) --impure";
          nfu = "nix flake update";
        };
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