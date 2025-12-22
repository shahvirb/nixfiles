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
  
  systemd.user.services.komodo-periphery = {
    Unit = {
      Description = "Start komodo periphery";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "komodo-periphery" ''
        ${pkgs.komodo}/bin/periphery --config-path /etc/nixos/hosts/argon/periphery/
      ''}";
    };
  };

  home.stateVersion = "23.11";
}
