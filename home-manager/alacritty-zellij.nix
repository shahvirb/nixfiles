{ pkgs, ... }:

{
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
  
  programs.alacritty.enable = true;
  # Also read https://discourse.nixos.org/t/any-nix-darwin-nushell-users/37778

  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      pane_frames = false;
      session_serialization = false;
      ui.pane_frames.hide_session_name = true;
    };
  };
}