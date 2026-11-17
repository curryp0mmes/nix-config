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

  playwright-mcp =pkgs.writeShellScriptBin "playwright-mcp" ''
    exec ${pkgs.nodejs_24}/bin/npx -y @playwright/mcp@latest --executable-path ${pkgs.chromium}/bin/chromium "$@"
  '';

  # gqrx hangs before showing a window: libgnuradio-network exports weak boost.asio
  # epoll_reactor symbols that clash with libuhd's inlined copies (boost 1.91),
  # deadlocking UHD device discovery. Loading libuhd first avoids the mixup.
  gqrx = pkgs.gqrx.overrideAttrs (old: {
    qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
      "--prefix LD_PRELOAD : ${pkgs.gnuradioMinimal.unwrapped.uhd}/lib/libuhd.so"
    ];
  });

  jlcone = pkgs.callPackage ./programs/jlcone.nix { };

  # zstd-sys probes pkg-config for libzstd, but nixpkgs doesn't provide it
  ripunzip = pkgs.ripunzip.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.zstd ];
  });
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
    keepassxc
    thunderbird
    simple-scan
    sdrangel
    gqrx
    stablePkgs.freecad
    orca-slicer
    #kdePackages.kdenlive
    discord
    kicad
    jlcone
    kdePackages.okular
    # gimp-with-plugins
    gimp
    #    affinity-v3
    vlc
    mpv
    vscode
    onlyoffice-desktopeditors
    obsidian
    jellyfin-media-player
    betaflight-configurator
    telegram-desktop
    signal-desktop
    #stablePkgs."saleae-logic-2"
    saleae-logic-2
    easyroam-connect-desktop
    kdePackages.glaxnimate
    #inkscape
    cinny-desktop


### audio and DAW
    vital
    #zrythm
    mixxx


### cli tools
    python314
    python314Packages.pip
    borgbackup
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
    natscli

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
    claude-agent-acp
  ];
}
