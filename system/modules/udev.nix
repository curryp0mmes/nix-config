{ pkgs, ... }:
{
  # Udev rules
  services.udev = {
    packages = [
      pkgs.stlink
      pkgs.libmtp
      pkgs.mixxx
    ];
    extraRules = ''
      			SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666", GROUP="plugdev"

            SUBSYSTEM=="power_supply", KERNEL=="BAT0", \
              RUN+="${pkgs.coreutils}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
              RUN+="${pkgs.coreutils}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
            SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"

        ### Rover praktikum
            SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTHJPYW1", SYMLINK+="VMC"
            SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTHJRKHP", SYMLINK+="xsens"
            SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="FTGSEMAV", SYMLINK+="VMC"
            SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", ATTR{serial}=="662080015707", SYMLINK+="EPOS2R", GROUP="users", MODE="0666"
            SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", ATTR{serial}=="662080015698", SYMLINK+="EPOS2L", GROUP="users", MODE="0666"
            
            SUBSYSTEM=="usb", ATTR{idVendor}=="24e7", ATTR{idProduct}=="3b01", SYMLINK+="EPOS4", GROUP="users", MODE="0666"
            
            # ftdi rule for EPOS4 70/15 
            SUBSYSTEMS=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="a8b0", GROUP="users", MODE="0666"
      		'';
    # 1. jumper t-lite
    # 2. charge control
    # 3. slaeae logic
  };

  hardware.saleae-logic.enable = true;
}
