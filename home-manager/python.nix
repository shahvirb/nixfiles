{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pipx.overridePythonAttrs (_: { doCheck = false; }))
    poetry
    python3
  ];
}