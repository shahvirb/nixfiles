{ lib, pkgs, modulesPath, systemSettings, userSettings, ... }:
{
  # Do this first because the nixos-hardware.git nvidia import below needs it
  nixpkgs.config.allowUnfree = true;

  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/amd"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/cpu/amd/pstate.nix"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/gpu/nvidia"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    ./hardware-configuration.nix
    "${builtins.fetchGit { url = "https://github.com/9999years/nix-config.git"; }}/modules/usb-wakeup-disable.nix"
    ../../modules/1password.nix
    ../../modules/common.nix
    ../../modules/gnome-system.nix
    ../../modules/smb-openmediavault-mediaauthor.nix
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

  services.openssh.enable = false;

  system.stateVersion = "23.11";
}
