{ inputs, pkgs, lib, ... }:
{
  # Enable niri
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    qt6Packages.qt6ct
    yazi
  ];

  # Provide a tiny callable that termfilechooser uses
  environment.etc."yazi-file-chooser.sh".source = pkgs.writeShellScript "yazi-file-chooser" ''
  #!/usr/bin/env bash
  DIR="''${1:-$PWD}"

  # Run Yazi in picker mode and print result
  FILE=$(yazi "''${DIR}")

  # termfilechooser expects path to stdout
  [ -n "''${FILE}" ] && printf '%s\n' "''${FILE}"
'';

  # Enable Hyprlock
  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };
 
  # Enable waybar
  programs.waybar.enable = true;

  services.dbus.enable = true;
 
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk # Fallback
    ];
    config = {
      # Configuration specific to the 'niri' session
      niri = {
        # 1. Use termfilechooser specifically for opening/saving files
        "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
 
        # 2. Use GNOME specifically for Screencast and Screenshot
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
 
        # 3. Fallback for everything else (Secrets, Settings, etc.)
        default = lib.mkDefault "gnome";
      };
    };
  };

  xdg.mime = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
      };
  };
  environment.variables.TERMFILECHOOSER = "/etc/yazi-file-chooser.sh";

  # environment.etc."xdg-desktop-portal/niri-portals.conf".text = ''
  #   [preferred]
  #   default=gtk
  #   org.freedesktop.impl.portal.FileChooser=termfilechooser
  # '';
}
