# https://nixos.wiki/wiki/1Password
{config, lib, systemSettings, userSettings, ... }:
with lib;
{
  config = mkMerge [
    {
      programs._1password.enable = true;

      home-manager.users.${userSettings.username} = import (./. + "../../home-manager/1password.nix");
    }
    (mkIf (systemSettings.profile == "graphical") {
      programs._1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = [ "${userSettings.username}" ];
      };
      
      # We'll rely on autostart in home-manager/1password.nix to always start it on logon
      xdg.autostart.enable = true;
    })
  ];
}