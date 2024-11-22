{ config, pkgs, ... }:
let
  HOST_TYPE = "graphical";
in
{
  # Do this first because the nixos-hardware.git nvidia import below needs it
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/intel"
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz}/nixos")
      ../../modules/1password.nix  
      ../../modules/common.nix
      ../../modules/gnome-system.nix
      ../../modules/smb-openmediavault-mediaauthor.nix
    ];
  
  my-common.hostType = HOST_TYPE;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mediapc-vgke"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  users.users.shahvirb = {
    isNormalUser = true;
    description = "shahvir";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    users.shahvirb = {
      imports = [
        ../../home-manager/1password.nix
        ../../home-manager/shahvirb.nix
        ../../home-manager/firefox.nix
        ../../home-manager/gnome.nix
        ../../home-manager/mediapc.nix
      ];
      services.my-gnome.enableDashToPanel = false;
    };

    extraSpecialArgs = {
      hostType = HOST_TYPE;
    };
  };

  # # Enable Flatpak
  # programs.flatpak.enable = true;

  # # Add the Flathub repository
  # programs.flatpak.repositories = {
  #   flathub = {
  #     url = "https://flathub.org/repo/flathub.flatpakrepo";
  #   };
  # };

  # # Install applications
  # programs.flatpak.packages = [
  #   "com.parsecgaming.parsec"
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
