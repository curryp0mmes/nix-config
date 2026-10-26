{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./modules/virtualisation.nix
    ./modules/udev.nix
    ./modules/firewall.nix
    ./modules/easyroam.nix
    #./modules/nvidia.nix
    ./modules/vm.nix
    ./modules/niri.nix
    ./modules/keyring.nix
    ./modules/greetd-autologin.nix
    ./modules/stylix.nix
  ];
  # most current kernel package
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # wifibroadcast drivers come from inputs.wfb-rs.nixosModules.default
  boot.extraModulePackages = [
    #  (config.boot.kernelPackages.callPackage ./modules/rtl8812au_aircrack.nix { })
    #  config.boot.kernelPackages.rtl88xxau-aircrack
    config.boot.kernelPackages.v4l2loopback # virtual cam srcs
    # nixpkgs' r8168 copies the .ko by hand, so it misses the kmodigest
    # signature/.ko.cer the module aggregator now requires; sign before compressing
    (config.boot.kernelPackages.r8168.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.buildPackages.kmodigest ];
      installPhase =
        let
          modDestDir = "$out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/r8168";
        in
        ''
          mkdir -p ${modDestDir}
          find . -name '*.ko' -exec cp --parents '{}' ${modDestDir} \;
          find ${modDestDir} -name '*.ko' -exec kmodigest '{}' \;
          find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;
        '';
    }))
  ];
  # force loading the custom driver at boot
  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
    "novalpdrv"
    "r8168"
  ];
  #boot.kernelModules = [ "novalpdrv" "88XXau_wfb" "8733bu" "r8168"];
  #boot.kernelModules = [ "rtl8812au" ];

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # disk services
  services.udisks2.enable = true;

  services.fwupd.enable = true;
  services.upower.enable = true;
  services.tuned.enable = true;
  services.tlp.enable = false;

  # Add a rule to allow setting power threshholds
  systemd.tmpfiles.rules = [
    "f /sys/class/power_supply/BAT0/charge_control_end_threshold 0664 root battery_ctl - -"
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.kdeconnect.enable = true;

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
    orbitron
    chakra-petch
    maven-pro
    roboto
  ];
}
