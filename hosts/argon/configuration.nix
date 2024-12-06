{ pkgs, modulesPath, ... }:
let
  HOST_TYPE = "lxc";
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz}/nixos")
    ../../modules/common.nix
    ../../modules/1password.nix
    ../../modules/sshkeys.nix
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
    password = "root";
    uid = 1000;
  };

  home-manager = {
    users.shahvirb = {
      imports = [
        ../../home-manager/shahvirb.nix
        ../../home-manager/argon.nix
      ];
    };

    extraSpecialArgs = {
      hostType = HOST_TYPE;
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
