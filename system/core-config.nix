{ inputs, pkgs, ... }:
{
  imports = [
    #./modules/uutils.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "simon"
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-substituters = [ "https://noctalia.cachix.org" "https://cache.forall.systems" ];
      extra-trusted-public-keys = [ 
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI=" 
      ];
    };

    # gc = {  # Nix Garbage Collector
    # 	automatic = true;
    # 	dates = "weekly";
    # 	options = "--delete-older-than 14d";
    # };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.overlays = [
    inputs.affinity-nix.overlays.default
    (final: prev: {
      chakra-petch = final.callPackage ./modules/chakra-petch-font.nix { };
      maven-pro = final.callPackage ./modules/maven-pro-font.nix { };
    })
  ];
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 3";
  };

  # Enable networking
  networking.networkmanager = {
    enable = true;

    unmanaged = [
      "interface-name:wlp0s20f0u*"
      "interface-name:wlp8s0f4u*"
    ];
    plugins = [ pkgs.networkmanager-openconnect ];
  };
  networking.firewall.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  ''; # temp bluetooth fix?

  hardware.rtl-sdr.enable = true;

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
      "battery_ctl"
      "storage"
      "disk"
      "scanner"
      "lp"
      "plugdev"
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
    wl-clipboard
    wl-clip-persist
    ripgrep
    usbutils
    mako
    systemd
    openconnect
    ntfs3g
    (rpi-imager.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/share/applications/*.desktop \
          --replace "Exec=rpi-imager" "Exec=pkexec rpi-imager"
      '';
    }))
    libxcb-cursor
    kdePackages.polkit-kde-agent-1
    libfido2
    pynitrokey
  ];
  services.flatpak.enable = true;

  #important upgrade
  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
  };
  # Polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") == "${pkgs.rpi-imager}/bin/rpi-imager" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

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

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      # Prevent crash due to missing kvantum theme engine in the agent's closure
      UnsetEnvironment = "QT_STYLE_OVERRIDE";
    };
  };

  # ... rest of file

  # printing
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin pkgs.samsung-unified-linux-driver ];
  hardware.sane = {
    enable = true; #scanner support
    extraBackends = [ pkgs.samsung-unified-linux-driver ];
  };
  # ipp everywhere (also for printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
