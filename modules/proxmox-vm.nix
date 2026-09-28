{ ... }:
{
  # Network
  # Cloud-init provides the VM's network configuration.
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  services.cloud-init = {
    enable = true;
    network.enable = true;
  };
  services.resolved.enable = true;

  # QEMU guest
  services.qemuGuest.enable = true;

  # Boot and filesystem
  boot.kernelParams = [ "console=ttyS0" ];
  boot.loader.grub.device = "/dev/vda";

  # Grow a partitioned root disk after Proxmox expands virtio0 with qm disk
  # resize. The service runs on every boot but is a no-op once fully grown.
  boot.growPartition = true;
  fileSystems."/".options = [ "x-systemd.growfs" ]; 
}
