{ ...}:

{
  home.file.".config/1Password/ssh/agent.toml".text = ''
    # https://developer.1password.com/docs/ssh/agent/config
    [[ssh-keys]]
    vault = "Dev - Home Lab"
  '';

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  # Autostart 1Password GUI on login
  home.file.".config/autostart/1password.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=1Password
    Exec=1password
    Icon=1password
    Comment=Password Manager
    X-GNOME-Autostart-enabled=true
  '';
}