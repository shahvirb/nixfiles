{ pkgs, modulesPath, userSettings, ... }:
let
  HOST_TYPE = "lxc";
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    (import "${builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
      sha256 = "00wp0s9b5nm5rsbwpc1wzfrkyxxmqjwsc1kcibjdbfkh69arcpsn";
    }}/nixos")
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

  users.users.${userSettings.username} = {
    description  = userSettings.name;
    extraGroups  = [ "wheel" "networkmanager" "docker"];
    isNormalUser  = true;
    password = "root";
    uid = 1000;
  };

  home-manager = {
    users.${userSettings.username} = {
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
