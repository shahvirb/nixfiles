{pkgs, ... }:
{
  home.packages = with pkgs; [
    talosctl
    kubectl
  ];
}