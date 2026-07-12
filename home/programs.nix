{ pkgs, inputs, ... }:
let
  # unstablePkgs = import inputs.nixpkgs_unstable {
  #   system = pkgs.stdenv.hostPlatform.system;
  #   config.allowUnfree = true;
  # };

  stablePkgs = import inputs.nixpkgs_stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  cursor3 = pkgs.callPackage ./programs/cursor.nix { };
  antigravity = pkgs.callPackage ./programs/antigravity.nix { };
  bambu-studio = pkgs.callPackage ./programs/bambu-studio.nix { };
in
{
  home.packages = with pkgs; [
    nix-output-monitor # for 'nh'

### Base OS stuff
    brightnessctl
    libnotify # for notify-send
    wlr-randr
    
### Desktop Apps
    networkmanagerapplet
    #davinci-resolve
    nwg-displays
    prismlauncher
    keepassxc
    thunderbird
    simple-scan
    gqrx
    #freecad
    orca-slicer
    bambu-studio
    #kdePackages.kdenlive
    discord
    kicad
    kdePackages.okular
    gimp3-with-plugins
    affinity-v3
    vlc
    mpv
    vscode
    dolphin-emu
    onlyoffice-desktopeditors
    obsidian
    jellyfin-media-player
    betaflight-configurator
    telegram-desktop
    #stablePkgs."saleae-logic-2"
    saleae-logic-2


### audio and DAW
    vital
    zrythm
    mixxx


### cli tools
    python313
    python313Packages.pip
    borgbackup
    simple-mtpfs
    jmtpfs
    udiskie
    nmap
    tldr
    speedtest-cli
    wiremix
    bluetuith


### lazyvim stuff
    lazygit
    stylua
    fd
    ripunzip
    fzf
    nodejs_24
    ffmpeg_7-full


### libraries
    python313Packages.libxml2
    python313Packages.libxslt
    zlib

### AI stuff
    cursor3
    antigravity
    antigravity-cli
  ];
}
