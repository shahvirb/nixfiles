{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
in
{
  home.packages = [
    pkgs-unstable.gemini-cli
    pkgs-unstable.opencode
    pkgs.nodejs

  ];
}
