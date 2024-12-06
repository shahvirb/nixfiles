{ config, pkgs, userSettings, ... }:

{
  services.openssh.enable = true;
  
  users.users.${userSettings.username} = {
    openssh.authorizedKeys.keys  = [
      "op://Dev - Home Lab/my homelab primary key/public key"
    ];
  };
}