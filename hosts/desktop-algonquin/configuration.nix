{ lib, pkgs, modulesPath, systemSettings, userSettings, inputs, ... }:
{
  # Do this first because the nixos-hardware.git nvidia import below needs it
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    "${inputs.repo-9999years-nix-config}/modules/usb-wakeup-disable.nix"
    ./hardware-configuration.nix
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

  hardware.nvidia = {
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    open = false;
    nvidiaSettings = true;
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
