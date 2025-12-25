{pkgs, ... }:
{
  home.packages = with pkgs; [
    komodo
    openssl
  ];

  home.sessionVariables = {
    OP_SERVICE_ACCOUNT_TOKEN = "op://Dev - Home Lab/nixos 1Password CLI service account/password";
  };
  
  systemd.user.services.komodo-periphery = {
    Unit = {
      Description = "Start komodo periphery";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "/bin/sh -lc \"${pkgs.komodo}/bin/periphery --config-path /etc/nixos/hosts/$HOSTNAME/periphery/\"";
      Environment = [
        "HOME=/home/shahvirb"
      ];
    };
  };
}
