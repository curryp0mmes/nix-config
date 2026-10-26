{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yosys
    surfer
    icestorm
    netlistsvg
    svgo
  ];
}
