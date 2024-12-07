{pkgs, ... }:
let
  vtOverlay = builtins.fetchGit "https://git.kempkens.io/daniel/nix-overlay.git";
  vuetorrent = import "${vtOverlay}/packages/vuetorrent.nix" {
    inherit pkgs;
    lib = pkgs.lib;
  };
in
{
  home.packages = with pkgs; [
    vuetorrent
  ];

  systemd.user.tmpfiles.rules = [
    "L ${config.home.homeDirectory}/vuetorrent - - - - ${vuetorrent}/share/public"
  ];
}