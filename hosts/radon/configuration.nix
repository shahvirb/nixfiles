{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/proxmox-vm.nix
    # ../../modules/sshkeys.nix
  ];

  services.tailscale.enable = false;

  system.stateVersion = "26.05";
}
