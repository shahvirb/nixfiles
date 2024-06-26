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

  users.groups = {
    mediaauthor = {
      gid = 1000;
    };
  };

  users.users.shahvirb = {
    description  = "shahvir";
    extraGroups  = [ "wheel" "networkmanager" "docker" "mediaauthor"];
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
        ../../home-manager/vuetorrent.nix
      ];
    };

    extraSpecialArgs = {
      hostType = HOST_TYPE;
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
