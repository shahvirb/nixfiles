{ config, pkgs, ... }:
let
  HOST_TYPE = "graphical";
in
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
      ../../modules/1password.nix
      ../../modules/common.nix
      ../../modules/gnome-system.nix
      "${builtins.fetchGit { url = "https://github.com/9999years/nix-config.git"; }}/modules/usb-wakeup-disable.nix"
    ];

  my-common.hostType = HOST_TYPE;

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
      ../../home-manager/1password.nix
      ../../home-manager/shahvirb.nix
      ../../home-manager/firefox.nix
      ../../home-manager/gnome.nix
      ../../home-manager/python.nix
    ];

    extraSpecialArgs = {
      hostType = HOST_TYPE;
    };
  };

  # Don't let USB devices wake the computer from sleep.
  # To list all USB devices run nix-shell -p usbutils --run lsusb
  hardware.usb.wakeupDisabled = [
    {
      # Topre Corporation LEO 98Keyboard
      vendor = "0853";
      product = "0138";
    }
    {
      # Logitech, Inc. Lightspeed Receiver
      vendor = "046d";
      product = "c539";
    }
    {
      # INSTANT USB GAMING MOUSE
      vendor = "30fa";
      product = "1340";
    }
  ];

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
