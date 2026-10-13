{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # Lanzaboote replaces the systemd-boot installer: it installs a signed systemd-boot
  # and signed kernels/initrds so the machine boots with Secure Boot enabled.
  # Check signatures with `sudo sbctl verify`, status with `bootctl status`.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    # creates the keys in /var/lib/sbctl on first activation
    autoGenerateKeys.enable = true;
    # systemd-boot enrolls the keys (plus Microsoft's, needed for Windows and
    # option ROMs) as soon as the firmware is put into Setup Mode
    autoEnrollKeys.enable = true;
    # editing the kernel command line at the boot menu would sidestep Secure Boot
    settings.editor = false;
    # generations built before lanzaboote fall back to "lanzaboote", keep new ones sorting with them
    sortKey = "lanzaboote";
  };

  environment.systemPackages = [ pkgs.sbctl ];
}
