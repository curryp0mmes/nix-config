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
    stablePkgs.freecad
    orca-slicer
    #kdePackages.kdenlive
    discord
    kicad
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

  # SolidCraft (flatpak) runs the ACP agent inside its sandbox (it needs the
  # bundled solidcraft-cli MCP server), so expose the nix store and claude login
  home.file.".local/share/flatpak-bin/claude-agent-acp" = {
    executable = true;
    text = ''
      #!/bin/sh
      exec ${pkgs.claude-agent-acp}/bin/claude-agent-acp "$@"
    '';
  };
  xdg.dataFile."flatpak/overrides/ai.storyteller.solidcraft".text = ''
    [Context]
    shared=network;
    filesystems=/nix/store:ro;~/.local/share/flatpak-bin:ro;~/.claude;~/.claude.json;

    [Environment]
    PATH=/app/bin:/usr/bin:/home/simon/.local/share/flatpak-bin
  '';
}
