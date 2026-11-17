{ config, pkgs, ... }:
let
  limesuiteng-src = pkgs.fetchFromGitHub {
    owner = "myriadrf";
    repo = "LimeSuiteNG";
    rev = "5bc2d182d868dbbc5c85f50526c6b6d0b8f55c00"; # develop, 2026-10-02
    hash = "sha256-1620FY1uYWnix4IxEqwrBGfAhcjedu+HS1pYtt8Bpqk=";
  };
in
{
  # Kernel module, only needed for PCIe devices (X3 / XTRX / X8)
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./limepcie.nix { src = limesuiteng-src; })
  ];
  boot.kernelModules = [ "limepcie" ];

  # udev rules for USB and PCIe devices
  services.udev.packages = [
    (pkgs.runCommand "limesuiteng-udev" { } ''
      install -Dm444 -t $out/lib/udev/rules.d ${limesuiteng-src}/udev-rules/*.rules
    '')
  ];
}
