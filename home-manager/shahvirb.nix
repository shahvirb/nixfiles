{ config, lib, pkgs, systemSettings, userSettings, ... }:
with lib;
{
  config = mkMerge [
    {
      home.packages = with pkgs; [
        dig
        gh
        micro
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
          nrbb = "sudo nixos-rebuild boot";
          nrbs = "sudo nixos-rebuild switch";
          nrbsu = "sudo nix-channel --update && sudo nixos-rebuild switch --upgrade";
        };
      };

      programs.git = {
        enable = true;
        # extraConfig = {
        #   credential.helper = "oauth";
        # };
        userName = userSettings.gitUserName;
        userEmail = userSettings.gitUserEmail;
      };

      programs.home-manager.enable = true;

      nixpkgs.config.allowUnfree = true;
    }
    (mkIf (systemSettings.profile == "graphical") {
      home.packages = with pkgs; [
        brave
        git-credential-oauth
        google-chrome
        joplin-desktop
        legcord
        protonvpn-gui
        spotify
        sublime4
        vscode
      ];

      home.sessionVariables = {
        TERMINAL = "alacritty";
      };

      programs.alacritty.enable = true;
      # Also read https://discourse.nixos.org/t/any-nix-darwin-nushell-users/37778

      programs.git.extraConfig = {
        credential.helper = "oauth";
      };
      
      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          pane_frames = false;
          session_serialization = false;
          ui.pane_frames.hide_session_name = true;
        };
      };
    })
  ];
}