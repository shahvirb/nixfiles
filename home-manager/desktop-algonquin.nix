{pkgs, ... }:
{
  home.packages = with pkgs; [
    gh
    git-filter-repo
    popsicle # For making bootable USBs
    sqlitebrowser
    zoom-us
  ] ++ unstablePackages;
}
