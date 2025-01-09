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
          nrbb = "sudo nixos-rebuild boot --flake path:/etc/nixos";
          nrbs = "sudo nixos-rebuild switch --flake path:/etc/nixos";
          nrbsu = "sudo nix flake update && sudo nixos-rebuild boot --flake path:/etc/nixos";
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
        libreoffice-qt
        protonvpn-gui
        spotify
        sublime4
        tilix
        vscode
      ];

      programs.git.extraConfig = {
        credential.helper = "oauth";
      };
    })
  ];
}