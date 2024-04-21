{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz}/nixos")
      ../../modules/common.nix
      ../../modules/gnome-system.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "thinkpadX1"; # Define your hostname.

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
      ../../home-manager/python.nix
      # ../../home-manager/hyprland.nix
    ];
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
