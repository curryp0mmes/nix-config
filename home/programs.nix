{ pkgs, inputs, ... }:
let
  unstablePkgs = import inputs.nixpkgs_unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  cursor3 = pkgs.callPackage ./programs/cursor.nix {};
  antigravity = pkgs.callPackage ./programs/antigravity.nix {};
in
{
  home.packages = with pkgs; [
    nix-output-monitor # for 'nh'

    # Desktop manager
    wpaperd
    # Base OS stuff
    brightnessctl
    libnotify # for notify-send
    networkmanagerapplet
    #davinci-resolve
    wlr-randr
    nwg-displays
    parsec-bin
    prismlauncher
    keepassxc
     
    #audio and DAW
    vital
    zrythm
    jellyfin-media-player

    python313
    python313Packages.pip
    pipx
    # cli tools
    borgbackup
    simple-mtpfs
    jmtpfs
    udiskie
    nmap
    tldr
    cmake
    ninja
    #lazyvim stuff
    lazygit
    stylua
    fd
    ripunzip
    fzf
    nodejs_24
    ffmpeg_7-full
    freecad 
    gqrx

    #libraries
    python313Packages.libxml2
    python313Packages.libxslt
    zlib
    # general programs
    orca-slicer
    # kdePackages.kdenlive
    discord
    unstablePkgs.kicad
    wiremix
    bluetuith
    kdePackages.okular
    gimp3-with-plugins
    affinity-v3
    vlc
    vscode

    # AI stuff
    cursor3
    antigravity
    unstablePkgs.gemini-cli
    zed-editor
    onlyoffice-desktopeditors
    obsidian
    mixxx
    betaflight-configurator
    rpi-imager
    telegram-desktop
    #stablePkgs."saleae-logic-2"
    saleae-logic-2

    (texlive.withPackages (ps: with ps; [
      scheme-gust darkmode latexmk eurosym makecell csquotes titlesec xstring
    ]))
  ];
}
