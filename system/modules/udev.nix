{ pkgs, ... }:
{
# Udev rules
  services.udev = {
    packages = [ pkgs.stlink pkgs.libmtp pkgs.mixxx ];
    extraRules = ''
      			SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666", GROUP="plugdev"
      		''; # 1. jumper t-lite (if you add more, just duplicate the line, no seperators)
  };
}
