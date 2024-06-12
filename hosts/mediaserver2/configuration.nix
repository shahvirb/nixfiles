{ pkgs, modulesPath, ... }:
let
  HOST_TYPE = "lxc";
in
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz}/nixos")
    ../../modules/common.nix
  ];

  my-common.hostType = HOST_TYPE;

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  users.users.shahvirb = {
    description  = "shahvir";
    extraGroups  = [ "wheel" "networkmanager" "docker"];
    isNormalUser  = true;
    openssh.authorizedKeys.keys  = [
      "***REMOVED***"
      "***REMOVED***"
    ];
    password = "root";
    uid = 1000;
  };

  home-manager = {
    users.shahvirb = {
      imports = [
        ../../home-manager/shahvirb.nix
        ../../home-manager/mediaserver2.nix
        ../../home-manager/python.nix
      ];
    };

    extraSpecialArgs = {
      hostType = HOST_TYPE;
    };
  };

  # This is a container so we need to use userspace networking mode https://nixos.wiki/wiki/Tailscale
  services.tailscale.interfaceName = "userspace-networking";

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
