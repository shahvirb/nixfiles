{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gh
    popsicle # For making bootable USBs
    roomeqwizard
  ];
}
