{ config, lib, pkgs, systemSettings, userSettings, ... }:
with lib;
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;  # Ensure unfree packages are allowed in this import
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  unstablePackagesGraphical = with pkgsUnstable; [
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
in
{
  config = mkMerge [
    {
      home.packages = with pkgs; [
        dig
        gh
        micro
        wget
      ];

      home.stateVersion = "23.11";

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
        userName = "Shahvir Buhariwalla";
        userEmail = "shahvirb@gmail.com";
      };

      programs.home-manager.enable = true;

      nixpkgs.config.allowUnfree = true;
    }
    (mkIf (systemSettings.profile == "graphical") {
      home.packages = with pkgs; [
      ] ++ unstablePackagesGraphical;

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