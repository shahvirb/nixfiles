# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Do this first because the nixos-hardware.git nvidia import below needs it
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/intel"
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz}/nixos")
      ../../modules/1password.nix 
      ../../modules/common.nix
      ../../modules/gnome-system.nix
    ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mediapc-vgke"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.shahvirb = {
    isNormalUser = true;
    description = "shahvir";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.shahvirb = {
    imports = [
      ../../home-manager/shahvirb.nix
      ../../home-manager/firefox.nix
      ../../home-manager/gnome.nix
      ../../home-manager/mediapc.nix
    ];


    services.my-gnome.enableDashToPanel = false;
  };


  services.samba = {
    enable = true;
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "shahvirb";

  services.openssh.enable = true;
  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}