{ config, pkgs, inputs, ... }:
{
  imports = [
    ./modules/virtualisation.nix
    ./modules/udev.nix
    ./modules/firewall.nix
    ./modules/easyroam.nix
    #./modules/nvidia.nix
    ./modules/vm.nix
    #./modules/hyprland.nix
    ./modules/niri.nix
    ./modules/keyring.nix
    ./modules/stylix.nix
  ];
  # most current kernel package
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Configure wifibroadcast drivers
  boot.blacklistedKernelModules = [ "rtw88_8812au" "r8169" ];
  boot.extraModulePackages = [
  #  (config.boot.kernelPackages.callPackage ./modules/rtl8731bu_libc.nix { })
  #  (config.boot.kernelPackages.callPackage ./modules/rtl8812au_openipc.nix { })
  #  (config.boot.kernelPackages.callPackage ../modules/rtl8812au_aircrack.nix { })
  #  config.boot.kernelPackages.rtl88xxau-aircrack
    config.boot.kernelPackages.v4l2loopback # virtual cam srcs
    config.boot.kernelPackages.r8168
  ];
  # force loading the custom driver at boot
  boot.kernelModules = [ "novalpdrv" "r8168"];
  #boot.kernelModules = [ "novalpdrv" "88XXau_wfb" "8733bu" "r8168"];
  #boot.kernelModules = [ "rtl8812au" ];

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # disk services
  services.udisks2.enable = true;

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "zsh -lc 'niri-session'";
        # command = "zsh -lc 'mkdir -p ~/.local/share/hypr && Hyprland >~/.local/share/hypr/hyprland.log 2>&1'";
        user = "simon";
      };
      default_session = initial_session;
    };
  };

  services.fwupd.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;
  services.tlp.enable = false;
  
  # Add a rule to allow setting power threshholds
  systemd.tmpfiles.rules = [
    "f /sys/class/power_supply/BAT0/charge_control_end_threshold 0664 root battery_ctl - -"
  ];

  # steam must be installed globally
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     # CPU Performance Settings (Balance power and speed)
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
  #
  #     # BATTERY CARE (ThinkPad Specific)
  #     # Stops charging at 80% to preserve battery health.
  #     # Set to 100 if you need full capacity for a trip.
  #     START_CHARGE_THRESH_BAT0 = 95;
  #     STOP_CHARGE_THRESH_BAT0 = 100;
  #
  #     CPU_BOOST_ON_AC = 1; # 1 = Enable, 0 = Disable
  #
  #     # ETHERNET FIX (Keep your card awake!)
  #     # This prevents TLP from cutting power to your Realtek card
  #     RUNTIME_PM_DRIVER_DENYLIST = "r8169 r8168";
  #   };
  # };

  # system wide font installations
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
  ];
}
