{ inputs, pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 6;
    };
  };
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [ "quiet" "splash" "vt.global_cursor_default=0" "usbcore.old_scheme_first=1" "usbcore.use_both_schemes=y" ];
  boot.initrd.systemd.enable = true;
  boot.initrd.verbose = false;
}
