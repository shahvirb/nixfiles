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
}