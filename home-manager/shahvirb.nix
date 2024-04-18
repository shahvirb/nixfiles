{ config, pkgs, ... }:

{
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    discord
    firefox
    git-credential-oauth
    joplin-desktop
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
}