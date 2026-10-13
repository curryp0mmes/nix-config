{
  pkgs,
  lib,
  inputs,
  config,
  osConfig,
  ...
}:
let
  createSymlink =
    localPath: config.lib.file.mkOutOfStoreSymlink "/home/simon/nix/home/configs/${localPath}";
in
{
  imports = [
    ./programs/shell.nix # Manages Zsh, Kitty, starship and zoxide
    ./aliases.nix # Shell aliases
    ./programs.nix # Home Manager packages
    ./programs/nixvim.nix
    inputs.noctalia.homeModules.default
    ./programs/noctalia.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "simon";
  home.homeDirectory = "/home/simon";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "simonausbs@gmail.com";
        name = "Simon";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.rbw = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    profiles = {
      simon = {
        # bookmarks, extensions, search engines...
      };
    };
    configPath = ".mozilla/firefox";
  };


  # Call noctalia lock on lid close
  # services.swayidle = {
  #   enable = true;
  #   systemdTarget = "niri-session.target"; # Ensures it starts only when Niri is active
  #   events = {
  #     "before-sleep" = "noctalia-shell ipc call lockScreen lock";
  #     "lock" = "noctalia-shell ipc call lockScreen lock";
  #   };
  # };

  # automatic disk mounting
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    settings = {
        program_options = {
            file_manager = "${pkgs.yazi}/bin/yazi";
            post_mount_command = "ln -s '{mount_path}' '/mnt/{device_presentation}'";
            post_unmount_command = "rm '/mnt/{device_presentation}'";
        };
    };
  };

  # OnlyOffice ignores fontconfig and won't follow symlinks into the store,
  # so copy the system fonts into ~/.local/share/fonts
  home.activation.onlyofficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dir="$HOME/.local/share/fonts/nix"
    rm -rf "$dir"
    mkdir -p "$dir"
    for pkg in ${lib.concatStringsSep " " (lib.unique (map toString osConfig.fonts.packages))}; do
      [ -d "$pkg/share/fonts" ] && find -L "$pkg/share/fonts" -type f \
        \( -iname '*.ttf' -o -iname '*.otf' -o -iname '*.ttc' \) \
        -exec cp -f {} "$dir/" \;
    done
    chmod -R u+w "$dir"
    # force OnlyOffice to rebuild its font cache
    rm -rf "$HOME/.local/share/onlyoffice/desktopeditors/data/fonts"
  '';

  # playerctl
  services.playerctld.enable = true;

  # kdeconnect
  services.kdeconnect = {
    enable = true;
  };

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.wlrobs
      #pkgs.obs-studio-plugins.obs-shaderfilter
    ];
  };

  stylix.targets.neovim.enable = true;
  stylix.targets.firefox = {
    profileNames = [ "simon" ];
    enable = true;
  };
  #gtk.gtk4.theme = config.gtk.theme;
  xdg.desktopEntries.yazi = {
    name = "Yazi";
    genericName = "File Manager";
    comment = "Blazing fast terminal file manager";
    exec = "kitty yazi %u";
    icon = "yazi";
    terminal = false;
    mimeType = [ "inode/directory" ];
    categories = [ "System" "FileManager" "ConsoleOnly" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
      "application/pdf" = [ "okularApplication_pdf.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/discord-455712169795780630" = [ "discord-455712169795780630.desktop" ];
      "x-scheme-handler/rpi-imager" = [ "com.raspberrypi.rpi-imager-uri-handler.desktop" ];
    };
  };

  home.file = {
    # ".config" = {
    #   source = ./configs;
    #   recursive = true;
    # };
    ".config/fastfetch" = {
      source = createSymlink "fastfetch";
      recursive = true;
    };
    ".config/mako" = {
      source = createSymlink "mako";
      recursive = true;
    };
    ".config/niri" = {
      source = createSymlink "niri";
      recursive = true;
    };
    ".config/wpaperd" = {
      source = createSymlink "wpaperd";
      recursive = true;
    };
    ".config/yazi" = {
      source = createSymlink "yazi";
      recursive = true;
    };
    ".config/opencode" = {
      source = createSymlink "opencode";
      recursive = true;
    };
  };

  # variables and path only sourced in shell and NOT sourced in Hyprland
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # PATH env var
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
