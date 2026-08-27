{pkgs, ... }:
{
  imports = [
    ../../home-manager/common.nix
    # ../../home-manager/komodo-periphery.nix
    ../../home-manager/ai-tools.nix
    ../../home-manager/python.nix
  ];

  home.sessionPath = [
    "/home/shahvirb/gitsource/mediaserver2/utils"
  ];

  systemd.user.services.dispatcharr-fix-channels = {
    Unit = {
      Description = "Dispatcharr fix channels - InfinityTV headless";
    };
    Service = {
      Type = "oneshot";
      WorkingDirectory = "/home/shahvirb/gitsource/dispatcharr-fix-channels";
      Environment = [
        "PATH=/etc/profiles/per-user/shahvirb/bin:/usr/local/bin:/usr/bin:/bin"
      ];
      ExecStart = "/run/current-system/sw/bin/bash /home/shahvirb/gitsource/dispatcharr-fix-channels/cron_infinitytv_headless.sh";
      StandardOutput = "append:/tmp/dispatcharr-fix-channels.log";
      StandardError = "append:/tmp/dispatcharr-fix-channels.log";
    };
  };

  systemd.user.timers.dispatcharr-fix-channels = {
    Unit = {
      Description = "Run dispatcharr-fix-channels every Friday at 10:00 AM";
    };
    Timer = {
      OnCalendar = "Fri *-*-* 10:00:00";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  home.stateVersion = "23.11";
}
