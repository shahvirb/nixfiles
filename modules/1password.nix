# https://nixos.wiki/wiki/1Password
{userSettings, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "${userSettings.username}" ];
  };

  # We'll rely on autostart in home-manager/1password.nix to always start it on logon
  xdg.autostart.enable = true;
}