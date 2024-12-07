{ lib, pkgs, modulesPath, systemSettings, userSettings, ... }:
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
    ( import ../../modules/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
  ];

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  home-manager = {
    users.${userSettings.username} = {
      imports = [
        ../../home-manager/shahvirb.nix
        ./home.nix
      ];
    };

    extraSpecialArgs = {
      # pass config variables from above
      # inherit pkgs-stable;
      inherit systemSettings;
      inherit userSettings;
      # inherit inputs;
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}