{ pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  environment.systemPackages = [
    pkgs.git
    pkgs.git-credential-oauth
  ];

  # This is needed for VSCode remote support. Read: https://nixos.wiki/wiki/Visual_Studio_Code
  programs.nix-ld.enable = true;

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
