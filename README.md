# NixOS Configuration

Personal NixOS configuration using flakes and home-manager for reproducible system management.

## Structure

```
.
├── flake.nix           # Main flake configuration
├── home/               # Home-manager configurations
│   ├── home.nix       # User environment setup
│   ├── programs.nix   # Application packages
│   ├── configs/       # Dotfiles (get symlinked)
│   └── programs/      # Program-specific configs
└── system/            # System-level configurations
    ├── core-config.nix      # Base system settings
    ├── desktop-config.nix   # Desktop environment
    └── devices/             # Hardware-specific configs
```

## Key Components

### Window Manager
- niri (scrolling window manager)
- waybar (status bar)
- walker (application launcher)
- mako (notification daemon)

### Terminal Environment
- kitty (terminal emulator)
- zsh (shell)
- starship (prompt)
- zoxide (directory jumping)

### Development Tools
- neovim (with LazyVim)
- direnv for project environments
- various language servers and formatters

### File Management
- yazi (terminal file manager)
- udiskie (automatic disk mounting)

### Applications
Desktop applications that I use on a daily basis

## Hosts

- **garnix**: Old laptop (Gigabyte G5 gaming laptop)
- **girlfriend-3**: Laptop system (ThinkPad T14 AMD Gen 2) (If you are wondering about the name, it is the only warm thing in my lap)

## System Features

- Flake-based configuration with locked dependencies
- Home-manager integration for user environment
- Stylix for consistent theming
- Tuned power management for laptops
- Pipewire audio with JACK support
- Automatic garbage collection (14-day retention)

## Usage

Build and switch to configuration:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
## or simply
rb
```

Update flake inputs:
```bash
nix flake update
## or simply
upd
```

## Disclaimer

Parts of this configuration were created with AI assistance.
