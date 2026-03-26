# CLAUDE.md

Personal NixOS/nix-darwin flake managing three hosts across Linux and macOS.

## Hosts

| Hostname | Platform | Arch |
|---|---|---|
| lyng | nix-darwin | aarch64-darwin |

Run `hostname` to identify the current host if not clear from context.

## Structure

- `modules/common/` — cross-platform home-manager and shared config
- `modules/linux/` — NixOS-specific (imports common)
- `modules/macos/` — nix-darwin-specific (imports common)
- `hosts/<name>/` — per-host entry points
- `flake.nix` — all inputs and outputs

Some modules come from `nix-config-private` (private flake input) and won't be visible in this repo.

## Rebuilding

Do not run the rebuild scripts (`./darwin-rebuild`, `./nixos-rebuild`) — they require elevated privileges. Tell the user to rebuild manually to test changes.

## Build Failures

When debugging nix build errors, check upstream issue trackers before attempting local diagnosis:

- nixpkgs: https://github.com/NixOS/nixpkgs/issues
- nixvim: https://github.com/nix-community/nixvim/issues
- home-manager: https://github.com/nix-community/home-manager/issues
- nix-darwin: https://github.com/LnL7/nix-darwin/issues
- stylix: https://github.com/danth/stylix/issues
- nixos-apple-silicon: https://github.com/nix-community/nixos-apple-silicon/issues
- nix-homebrew: https://github.com/zhaofengli/nix-homebrew/issues

## Neovim

Configured with nixvim. Read `agent_docs/nixvim.md` when working on neovim configuration.
