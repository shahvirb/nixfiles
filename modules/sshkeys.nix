{userSettings, ... }:

{
  services.openssh.enable = true;
  
  users.users.${userSettings.username} = {
    openssh.authorizedKeys.keys  = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsjAWYBHRoIcKEIfVw24wpbf28HGY0/EfTBoW4Eotcz"
    ];
  };
}