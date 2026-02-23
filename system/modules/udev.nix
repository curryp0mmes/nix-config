{ pkgs, ... }:
{
# Udev rules
  services.udev = {
    packages = [ pkgs.stlink pkgs.libmtp pkgs.mixxx ];
    extraRules = ''
      			SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666", GROUP="plugdev"

            SUBSYSTEM=="power_supply", KERNEL=="BAT0", \
              RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
              RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
            SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"
      		''; 
# 1. jumper t-lite
# 2. charge control
# 3. slaeae logic
  };

  hardware.saleae-logic.enable = true;
}
