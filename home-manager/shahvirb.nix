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

  unstablePackages = with pkgsUnstable; [
    discord
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
        extraConfig = {
          credential.helper = "oauth";
        };
        userName = "Shahvir Buhariwalla";
        userEmail = "shahvirb@gmail.com";
      };

      programs.home-manager.enable = true;

      nixpkgs.config.allowUnfree = true;
    }
    (mkIf (hostType == "graphical") {
      home.packages = with pkgs; [
        firefox
        git
        wget
      ] ++ unstablePackages;

      home.sessionVariables = {
        TERMINAL = "alacritty";
      };

      programs.alacritty.enable = true;
      # Also read https://discourse.nixos.org/t/any-nix-darwin-nushell-users/37778

      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
      };
    })
  ];
}