{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/sshkeys.nix
  ];

  networking.useDHCP = true;

  services.qemuGuest.enable = true;

  boot.loader.grub.device = "/dev/vda";

  system.stateVersion = "26.05";
}
