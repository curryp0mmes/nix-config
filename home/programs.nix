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

  bambu-studio = pkgs.callPackage ./programs/bambu-studio.nix { };

  playwright-mcp = pkgs.writeShellScriptBin "playwright-mcp" ''
    exec ${pkgs.nodejs_24}/bin/npx -y @playwright/mcp@latest --executable-path ${pkgs.chromium}/bin/chromium "$@"
  '';
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
    stablePkgs.freecad
    orca-slicer
    bambu-studio
    #kdePackages.kdenlive
    discord
    kicad
    kdePackages.okular
    gimp3-with-plugins
    #    affinity-v3
    vlc
    mpv
    vscode
    dolphin-emu
    onlyoffice-desktopeditors
    obsidian
    jellyfin-media-player
    betaflight-configurator
    telegram-desktop
    signal-desktop
    #stablePkgs."saleae-logic-2"
    saleae-logic-2
    easyroam-connect-desktop
    gnuradio
    kdePackages.glaxnimate
    inkscape


### audio and DAW
    vital
    zrythm
    mixxx


### cli tools
    python314
    python314Packages.pip
    borgbackup
    simple-mtpfs
    go-mtpfs
    udiskie
    nmap
    tldr
    speedtest-cli
    wiremix
    bluetuith
    gh
    glib
    sshfs


### lazyvim stuff
    lazygit
    stylua
    fd
    ripunzip
    nodejs_24
    ffmpeg


### libraries
    python313Packages.libxml2
    python313Packages.libxslt
    zlib


### AI stuff
    antigravity-cli
    copilot-language-server
    playwright-mcp
    chromium
    claude-code
  ];
}
