{ inputs, pkgs, ... }:
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 6;
    };
  };
  theme.wuespace-plymouth.enable = true;
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "vt.global_cursor_default=0"
    "usbcore.old_scheme_first=1"
    "usbcore.use_both_schemes=y"
    # Silence systemd stage 1 (replaces the removed boot.initrd.verbose = false)
    "rd.systemd.show_status=auto"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  # systemd initrd is now the only (default) stage 1; no option needed.
}
