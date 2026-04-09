## Structure

- `home/<user>/` — home-manager config: dotfiles, shell, editor, user packages
  - `global/` — always-imported HM features (cross-platform)
  - `features/` — opt-in HM feature modules (imported per-host)
    - `cli/` — shell, git, ssh, starship, etc.
    - `editors/` — neovim (base, no lang LSPs), vscode (base)
    - `dev/<lang>/` — per-language toolchain + neovim LSP/formatter + IDE config
    - `browsers/`, `terminals/`, `desktop/`, `cloud/`, `media/`, `claude/`
  - `<host>.nix` — per-host HM imports
- `hosts/common/` — system-level config shared across hosts
  - `global/` — always-imported system modules (nix, fonts, stylix, timezone, sudo)
  - `optional/` — opt-in system modules (1password, docker, etc.)
    - `darwin/` — darwin-only system modules (homebrew casks, system-defaults)
    - `nixos/` — nixos-only system modules (bluetooth, gdm, polkit)
  - `users/<user>.nix` — user account, groups, HM entry point
- `hosts/<name>/` — per-host entry points (hardware, host-specific system config)
- `overlays/` — nixpkgs overlays
- `flake.nix` — all inputs and outputs

User-specific system config (account creation, group membership, sudo rules, polkit)
lives in `hosts/common/users/`. Everything else user-specific (packages, dotfiles,
programs) lives in `home/`.

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

## Code Style

Do not add comments to code. Preserve all existing comments.

## Neovim

Configured with nixvim. Read `agent_docs/nixvim.md` when working on neovim configuration.
