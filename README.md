# NixOS Configuration

Personal NixOS configuration using flakes and home-manager for reproducible system management.

## Structure

```
.
├── flake.nix           # Main flake configuration
├── home/               # Home-manager configurations
│   ├── home.nix       # User environment setup
│   ├── programs.nix   # Application packages
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
- rofi (application launcher)
- mako (notification daemon)

### Terminal Environment
- kitty (terminal emulator)
- zsh (shell)
- starship (prompt)
- zoxide (directory jumping)

### Development Tools
- neovim (with LazyVim)
- git with custom configuration
- direnv for project environments
- various language servers and formatters

### File Management
- yazi (terminal file manager)
- udiskie (automatic disk mounting)

### Applications
Desktop applications including Firefox, Discord, OBS Studio, VSCode, KiCad, GIMP, and various creative tools (Kdenlive, Mixxx, Orca Slicer).

## Hosts

- **garnix**: Desktop system (Gigabyte hardware)
- **girlfriend-3**: Laptop system (ThinkPad T14 AMD Gen 2)

## System Features

- Flake-based configuration with locked dependencies
- Home-manager integration for user environment
- Stylix for consistent theming
- TLP power management for laptops
- Pipewire audio with JACK support
- Automatic garbage collection (14-day retention)

## Usage

Build and switch to configuration:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Update flake inputs:
```bash
nix flake update
```

Using nh (helper tool):
```bash
nh os switch
```

## Disclaimer

Parts of this configuration were created with AI assistance.