{ config, lib, pkgs, systemSettings, userSettings, ... }:
with lib;
{
  config = mkMerge [
    {
      i18n.defaultLocale = systemSettings.locale;
      i18n.extraLocaleSettings = {
        LC_ADDRESS = systemSettings.locale;
        LC_IDENTIFICATION = systemSettings.locale;
        LC_MEASUREMENT = systemSettings.locale;
        LC_MONETARY = systemSettings.locale;
        LC_NAME = systemSettings.locale;
        LC_NUMERIC = systemSettings.locale;
        LC_PAPER = systemSettings.locale;
        LC_TELEPHONE = systemSettings.locale;
        LC_TIME = systemSettings.locale;
      };

      nix = {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };

      time.timeZone = systemSettings.timezone;

      # This is needed for VSCode remote support. Read: https://nixos.wiki/wiki/Visual_Studio_Code
      programs.nix-ld.enable = true;

      services.openssh.enable = mkDefault true;
      services.tailscale.enable = mkDefault true;

      users.users.${userSettings.username} = {
        description  = userSettings.name;
        extraGroups  = [ "wheel" "networkmanager"];
        isNormalUser  = true;
        password = "root";
        uid = 1000;
      };
    }
    (mkIf (systemSettings.profile == "graphical") {
      networking.networkmanager.enable = true;

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
    (mkIf (systemSettings.profile == "lxc") {
      # This is a container so we need to use userspace networking mode https://nixos.wiki/wiki/Tailscale
      services.tailscale.interfaceName = "userspace-networking";
    })
  ];
}
