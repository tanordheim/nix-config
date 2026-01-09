# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS/nix-darwin configuration repository managing system configurations for multiple machines (both Linux and macOS). It uses Nix flakes for reproducible system configuration.

## Hosts

The repository defines three host configurations:
- **harahorn**: NixOS on Apple Silicon (aarch64-linux) with Asahi Linux support
- **harahorn-mac**: nix-darwin on Apple Silicon macOS (aarch64-darwin)
- **lyng**: nix-darwin on Apple Silicon macOS (aarch64-darwin)

Each host is defined in `hosts/<hostname>/default.nix` and references platform-specific modules.

## Build and Deployment Commands

### macOS (nix-darwin)
```bash
# Quick rebuild using Makefile
make darwin-rebuild

# Or use the wrapper script (also commits generation automatically)
./darwin-rebuild

# Manual rebuild
nix run nix-darwin -- switch --flake .
```

### NixOS (Linux)
```bash
# Use the wrapper script (commits generation automatically)
./nixos-rebuild

# Manual rebuild
sudo nixos-rebuild switch --impure --flake .
```

Both wrapper scripts (`darwin-rebuild` and `nixos-rebuild`) automatically commit the current generation to git after a successful rebuild.

## Architecture

### Module Organization

The configuration follows a three-tier module structure:

1. **`modules/common/`**: Cross-platform modules used by both macOS and Linux
   - Development tools (neovim, git, docker, kubernetes, etc.)
   - Programming languages (go, node, python, dotnet, java)
   - Shell configuration (zsh, starship, shell-aliases)
   - Terminal emulators (kitty, wezterm)
   - Defines shared options like `username`, `user.fullName`, `git.email`, etc.

2. **`modules/linux/`**: Linux-specific modules for NixOS
   - Desktop environment (Hyprland, hyprpanel, etc.)
   - Display manager (GDM)
   - Linux-specific applications
   - System configuration (users, keyboard, bluetooth, printers)
   - Imports all `modules/common/` modules

3. **`modules/macos/`**: macOS-specific modules for nix-darwin
   - Window management (Aerospace, sketchybar)
   - Homebrew configuration
   - macOS system defaults
   - Touch ID configuration
   - Imports all `modules/common/` modules

### Key Configuration Files

- **`flake.nix`**: Main flake defining inputs (nixpkgs, home-manager, nix-darwin, stylix, etc.) and outputs (darwinConfigurations, nixosConfigurations)
- **`modules/*/default.nix`**: Platform-specific entry points that import all modules for that platform
- **`overlays/`**: Custom package overlays (fish, jankyborders)

### Private Configuration

The flake imports `nix-config-private` as an input, which provides additional private modules not stored in this public repository. These are merged into host configurations via:
```nix
++ (builtins.attrValues inputs.nix-config-private.outputs.homeManagerModules)
++ (builtins.attrValues inputs.nix-config-private.outputs.nixModules)
```

### Configuration Options

The `modules/common/default.nix` defines custom options used throughout the configuration:
- `username`: System username (default: "trond")
- `user.fullName`: User's full name
- `user.ssh.key`: SSH public key
- `user.image`: User profile image path
- `git.email`: Git email address
- `git.githubUsername`: GitHub username

These options are referenced by individual module files to ensure consistency.

## Development Workflow

When modifying this configuration:

1. Edit the relevant `.nix` files in `modules/` or `hosts/`
2. Test changes by running the appropriate rebuild command for your platform
3. The rebuild script will automatically commit the generation if successful
4. Review the auto-generated commit message showing the generation number

## Neovim Configuration

Neovim is configured using nixvim (Nix-based Neovim configuration). The configuration is modular:
- `modules/common/neovim/`: Main neovim configuration
- `modules/common/neovim/plugins/`: Individual plugin configurations
- `modules/common/neovim/plugins/languages/`: Language-specific LSP/formatter configurations

## Stylix

The repository uses Stylix for system-wide theming and color scheme management. Theme definitions are in `modules/common/stylix-themes/`.
