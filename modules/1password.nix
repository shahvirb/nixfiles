# https://nixos.wiki/wiki/1Password
{userSettings, ... }:
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "${userSettings.username}" ];
    # TODO this should not be a hardcoded username
  };
}