{ config, lib, pkgs, hostType, ... }:
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
    armcord
    git-credential-oauth
    joplin-desktop
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
        wget
      ];

      home.stateVersion = "23.11";

      programs.bash = {
        enable = true;
        shellAliases = {
          nrbb = "sudo nixos-rebuild boot";
          nrbs = "sudo nixos-rebuild switch";
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
    (mkIf (hostType == "graphical") {
      home.packages = with pkgs; [
        firefox
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
      };
    })
  ];
}