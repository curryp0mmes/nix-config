{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    nix-output-monitor # for 'nh'

    # Desktop manager
    wpaperd
    # Base OS stuff
    rofi-unwrapped
    brightnessctl
    libnotify # for notify-send
    networkmanagerapplet
    #davinci-resolve
    wlr-randr
    nwg-displays
    parsec-bin
    prismlauncher
     
    #audio and DAW
    vital
    zrythm
    jellyfin-media-player

    wallust # wallpaper stuff

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

    #libraries
    python313Packages.libxml2
    python313Packages.libxslt
    zlib
    # general programs
    orca-slicer
    kdePackages.kdenlive
    discord
    mpv
    pavucontrol
    kicad
    kdePackages.okular
    gimp3-with-plugins
    inputs.affinity-nix.packages.${pkgs.system}.v3
    vlc
    vscode
    code-cursor
    onlyoffice-desktopeditors
    obsidian
    mixxx
    betaflight-configurator
    rpi-imager
    telegram-desktop

    (texlive.withPackages (ps: with ps; [
      scheme-gust darkmode latexmk eurosym makecell csquotes titlesec xstring
    ]))
  ];
}
