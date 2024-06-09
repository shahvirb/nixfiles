{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my-common;
in
{
  options.my-common = {
    hostType = mkOption {
      type = types.enum [ "lxc" "graphical" ];
      default = "graphical";
      description = "Type of host: either 'lxc' or 'graphical'.";
    };
  };

  config = mkMerge [
    {
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      time.timeZone = "America/Chicago";

      # This is needed for VSCode remote support. Read: https://nixos.wiki/wiki/Visual_Studio_Code
      programs.nix-ld.enable = true;

      services.openssh.enable = mkDefault true;
      services.tailscale.enable = mkDefault true;
    }
    (mkIf (cfg.hostType == "graphical") {
      networking.networkmanager.enable = true;

      nix.extraOptions = ''
        experimental-features = nix-command
      '';

      # Disable if printing is not needed
      services.printing.enable = true;

      # Sound
      sound.enable = true;
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })
  ];
}
