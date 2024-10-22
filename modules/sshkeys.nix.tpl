{ config, pkgs, ... }:

{
  services.openssh.enable = true;
  
  users.users.shahvirb = {
    openssh.authorizedKeys.keys  = [
      "op://Dev - Home Lab/my homelab primary key/public key"
    ];
  };
}