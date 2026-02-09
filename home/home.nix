{ pkgs, inputs, config, ... }:
let
  createSymlink = localPath:
    config.lib.file.mkOutOfStoreSymlink "/home/simon/nix/home/configs/${localPath}";
in
{
  imports = [
    ./programs/shell.nix # Manages Zsh, Kitty, starship and zoxide
    ./aliases.nix # Shell aliases
    ./programs.nix # Home Manager packages
    inputs.walker.homeManagerModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "simon";
  home.homeDirectory = "/home/simon";

  programs.git = {
    enable = true;
    settings.user = {
      email = "simonausbs@gmail.com";
      name = "Simon";
    };
  };

  programs.firefox = {
    enable = true;
    profiles = {
      simon = {
        # bookmarks, extensions, search engines...
      };
    };
  };

  # automatic disk mounting
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  # playerctl
  services.playerctld.enable = true;

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
    ];
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraPackages = with pkgs;
      [
        pyright
        basedpyright
        lua-language-server
        stylua
        ripgrep
        beancount-language-server
        gopls
        go
        nil
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        marksman
        ruff
        lua51Packages.tiktoken_core
        gnumake
        python3Packages.jedi-language-server
      ];
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
  };
  # Prevent styling since i am using lazyvim
  stylix.targets.neovim.enable = false;
  stylix.targets.firefox = {
    profileNames = [ "simon" ];
    enable = true;
  };
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "application/pdf" = [ "okular.desktop" ]; # Or "firefox.desktop"
  #   };
  # };

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "simonswalk";
      placeholders."default" = { input = "Search"; list = "Example"; };
      providers.prefixes = [
        {provider = "websearch"; prefix = "+";}
        {provider = "providerlist"; prefix = "_";}
      ];
      keybinds.quick_activate = ["F1" "F2" "F3"];
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
    ".config/nvim" = {
      source = createSymlink "nvim";
      recursive = true;
    };
    ".config/walker/themes" = {
      source = createSymlink "walker/themes";
      recursive = true;
    };
    ".config/waybar" = {
      source = createSymlink "waybar";
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
