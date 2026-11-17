{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/virtualisation.nix
    ./modules/udev.nix
    ./modules/limesdr
    ./modules/firewall.nix
    ./modules/vm.nix
    ./modules/niri.nix
    ./modules/keyring.nix
    ./modules/greetd-autologin.nix
    ./modules/stylix.nix
  ];
  # most current kernel package
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # force loading the custom driver at boot
  boot.kernelModules = [
    "binder_linux"
    "ashmem_linux"
    "r8168"
  ];

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
