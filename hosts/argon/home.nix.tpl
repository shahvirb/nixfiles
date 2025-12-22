{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    ../../home-manager/talosctl.nix
  ];

  home.packages = with pkgs; [
    komodo
    openssl
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/utils"
  ];

  home.sessionVariables = {
    OP_SERVICE_ACCOUNT_TOKEN = "op://Dev - Home Lab/argon 1Password CLI service account/password";
  };
  
  home.stateVersion = "23.11";
}
