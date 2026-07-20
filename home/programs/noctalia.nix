{ lib, pkgs, ... }:
{
  # 1. Renamed to match the v5 native runtime package
  programs.noctalia = {
    enable = true;
    settings = {
      
      # 2. Relocated shell-specific attributes
      shell = {
        appIconColorize = true;
        animationSpeed = 1.5;
        radiusRatio = 0.2; 
      };

      # 3. Bar handles placement ONLY via list arrays
      bar = {
        thickness = 32; # v5 scale layout replacing 'density = compact'
        position = "top";
        showCapsule = false;
        left = [ "ControlCenter" "Network" "Bluetooth" ];
        center = [ "Workspace" ];
        right = [ "Tray" "Battery" "Clock" ];
      };

      # 3. All individual widget configuration goes here
      widget = {
        ControlCenter = {
          useDistroLogo = true;
        };
        Workspace = {
          style = "regular";
          display = "none"; # replaces labelMode = "none"
        };
        Tray = {
          drawerEnabled = false; # the key you were looking for earlier!
        };
        Battery = {
          alwaysShowPercentage = false;
          warningThreshold = 30;
        };
        Clock = {
          format = "{:%H:%M}"; # 4. Updated strftime block syntax
          useMonospacedFont = true;
          usePrimaryColor = true;
        };
      };

      dock = {
        enabled = false;
      };

      theme = {
        mode = "dark";
        #source = "builtin";
        #builtin = "Catppuccin";
      };

      location = {
        monthBeforeDay = false;
        name = "Würzburg, Germany";
        showWeekNumberInCalendar = true;
        firstDayOfWeek = 0;
      };

      launcher = {
        terminalCommand = "kitty -e";
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/simon/Pictures/Wallpapers/nixos_wallpaper_rainbow.png";
      };
    };
  };
}
