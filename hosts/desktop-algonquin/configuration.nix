{ config, pkgs, ... }:

{
  # Do this first because the nixos-hardware.git nvidia import below needs it
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/amd"
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/amd/pstate.nix"
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/gpu/nvidia"
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz}/nixos")
      ../../modules/common.nix
      ../../modules/gnome-system.nix
    ];

  boot.loader = {
    grub = {
      device = "/dev/sdb";
      efiSupport = true;
      enable = true;
      extraEntries = ''
        menuentry 'Windows' {
          search.fs_uuid 8EE2-3BF6
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        menuentry 'Windows (/dev/nvme0n1p2)' --class windows --class os $menuentry_id_option 'osprober-efi-8EE2-3BF6' {
             insmod part_gpt
             insmod fat
             search --no-floppy --fs-uuid --set=root 8EE2-3BF6
             chainloader /EFI/Microsoft/Boot/bootmgfw.efi
         }
      '';
      # Disable os prober on this machine because it picks up the wrong windows install
      # useOSProber = true;
    };
  };

  networking.hostName = "desktop-algonquin"; # Define your hostname.

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

  services.openssh.enable = false;
  services.tailscale.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
