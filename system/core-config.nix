{ inputs, pkgs, ... }:
{
  imports = [
    #./modules/uutils.nix
  ];

  nix = {
  	settings = {
      experimental-features = [ "nix-command" "flakes" ];
  	  auto-optimise-store = true;
      trusted-users = [ "root" "simon" ];
    };

  	# gc = {  # Nix Garbage Collector
  	# 	automatic = true;
  	# 	dates = "weekly";
  	# 	options = "--delete-older-than 14d";
  	# };
  };

  nixpkgs.config.allowUnfree = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 3";
  };

  # Enable networking
  networking.networkmanager = {
    enable = true;

    unmanaged = [ "interface-name:wlp0s20f0u*" "interface-name:wlp8s0f3u*" ];
  };
  networking.firewall.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable ZSH
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’ (in device/<hostname>.nix file)
  users.users.simon = {
    isNormalUser = true;
    description = "Simon";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "audio"
      "docker"
    ];
  };
  # users.mutableUsers = false;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    devenv
    btop
    eza
    nixfmt
    fastfetch
    git
    wl-clipboard-rs
    ripgrep
    usbutils
    mako
    systemd
    openconnect
  ];

  #important upgrade
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
  };

  # pipewire audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.gvfs.enable = true;

  systemd.user.services.a2jmidid = {
    description = "ALSA to JACK MIDI bridge";
    serviceConfig = {
      ExecStart = "${pkgs.a2jmidid}/bin/a2jmidid -e";
    };
    wantedBy = [ "default.target" ];
  };

  # printing
  services.printing.enable = true;

  # ipp everywhere (also for printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
