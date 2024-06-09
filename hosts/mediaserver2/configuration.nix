{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/common.nix
  ];

  my-common.hostType = "lxc";

  environment.systemPackages = [
    pkgs.git
    pkgs.git-credential-oauth
  ];

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  users.users.shahvirb = {
    description  = "shahvir";
    extraGroups  = [ "wheel" "networkmanager" ];
    isNormalUser  = true;
    openssh.authorizedKeys.keys  = [ "***REMOVED***" ];
    password = "root";
    uid = 1000;
  };

  system.stateVersion = "23.11";
}
