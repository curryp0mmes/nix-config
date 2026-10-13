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
    ├── modules/             # Feature modules (niri, gaming, stylix, ...)
    └── hosts/<hostname>/    # Per-machine config: hardware, opt-in modules, stateVersion
```

## Key Components

### Window Manager
- niri (scrolling window manager)
- noctalia (bar, shell, and session widgets)
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
- **ahornblatt**: ThinkPad T14s (no games)

Shared config lives in `system/core-config.nix`, `system/desktop-config.nix` and `home/`.
Each host opts into extra modules (e.g. `modules/gaming.nix`) in `system/hosts/<hostname>/default.nix`,
which can also add per-host home-manager settings via `home-manager.users.simon`.

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
