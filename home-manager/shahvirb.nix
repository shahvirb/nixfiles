{ config, pkgs, ... }:
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
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    firefox
    git
    wget
  ] ++ unstablePackages;

  nixpkgs.config.allowUnfree = true;

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
}