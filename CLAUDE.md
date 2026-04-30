## Structure

Dendritic flake-parts layout. Every `.nix` file under `modules/` is auto-imported by `vic/import-tree` (paths containing `/_` are excluded).

- `flake.nix` — inputs + `mkFlake` + `import-tree ./modules`. No logic.
- `modules/core/` — schema files, loaded first:
  - `configurations-{darwin,nixos}.nix` — declare `options.configurations.{darwin,nixos}.<host>.module` (deferredModule) and map to `flake.{darwin,nixos}Configurations`.
  - `module-namespaces.nix` — declares `options.flake.modules` as a freeform attrset of deferredModules, keyed by platform (`darwin`, `nixos`, `homeManager`).
  - `host-features.nix` — central registry: alphabetical list of `host.features.<name>.enable = mkEnableOption "..."` declarations, installed in all three platform scopes via `flake.modules.{darwin,nixos,homeManager}.hostOptions`.
- `modules/hosts/<host>.nix` — per-host inventory. Declares `configurations.<platform>.<host>.module` with host identity (hostname, stateVersion, platform, network) + `host.features = { <flag>.enable = true; … };` + HM feature propagation.
- `modules/hosts/_hsrv/` — excluded from import-tree. Host-specific plain nixos modules imported explicitly by `modules/hosts/hsrv.nix` (hardware, sops, backups, arr wiring).
- `modules/platform/` — always-on platform bits writing to `flake.modules.{darwin,nixos}.base`:
  - `base.nix` — cross-platform env packages + `programs.zsh` + home-manager integration + (nixos) `services.openssh`.
  - `darwin.nix` — homebrew bootstrap, macOS system-defaults, touch-id sudo.
  - `nix.nix` — nix settings (trusted-users, experimental-features, gc, optimise) + nixpkgs overlays (`stable`, `bleeding`, `custom`) + repo-local overlays from `overlays/`.
  - `fonts.nix`, `sudo.nix`, `timezone.nix` — trivial cross-platform bits.
- `modules/hm-base.nix` — HM base: `programs.home-manager.enable`, `services.ssh-agent` (linux).
- `modules/users/trond.nix` — `flake.modules.{darwin,nixos}.trond` with user account, HM homeDir, nixos-only polkit + sudo rules.
- `modules/cli/` — unconditional HM baseline (zsh, git, ssh, starship, eza, zoxide, direnv, shell-aliases, build-tools). All write to `flake.modules.homeManager.base`.
- `modules/apps/<name>.nix` — user-facing applications (1password, slack, firefox, chrome, telegram, docker, qmk, xcode, claude/, …). Each declares one or more of `flake.modules.{darwin,nixos,homeManager}.<name>` gated by `lib.mkIf config.host.features.<name>.enable`.
- `modules/cloud/`, `modules/terminals/`, `modules/desktop/` — feature-gated HM modules (aws, gcp, kubernetes, kitty, aerospace, hyprland, etc.).
- `modules/editors/neovim/` — nixvim-based neovim hub. `default.nix` sets base + imports `inputs.nixvim.homeModules.nixvim`. Plugin files under `plugins/` contribute to `flake.modules.homeManager.neovim.programs.nixvim.*`, all gated by `host.features.neovim.enable`.
- `modules/editors/{jetbrains,vscode}.nix` — editor hubs that language modules contribute to.
- `modules/dev/<lang>.nix` — language toolchain + editor integrations. Each file contributes to `flake.modules.homeManager.<lang>-dev` (toolchain, gated on `<lang>-dev.enable`), plus `flake.modules.homeManager.{neovim,jetbrains,vscode}` (integrations, gated on both `<lang>-dev.enable` AND `<editor>.enable`). Feature name convention: `<lang>-dev`.
- `modules/data/{postgres,redis}.nix` — user-level data tools (HM).
- `modules/media/` — nixos media services (plex, sonarr, radarr, prowlarr, bazarr, sabnzbd, qbittorrent, unpackerr).
- `modules/automation/` — nixos home automation (home-assistant, zigbee2mqtt, mosquitto).
- `modules/web/caddy.nix` — nixos reverse proxy.
- `modules/theme/stylix.nix` — unified stylix config across darwin/nixos/homeManager.
- `overlays/` — nixpkgs overlays. Called with `inputs` at eval time; sub-overlays destructure specific inputs.

## Feature pattern

Each user-facing capability is a feature with a central declaration in `modules/core/host-features.nix` and per-platform contributions gated by `lib.mkIf config.host.features.<name>.enable` inside each deferred module. Hosts enable features in `host.features = { … };`. HM gets features via propagation (`host.features = config.host.features;` inside `home-manager.users.trond`). Cross-feature interactions (e.g. rust-dev × neovim) use `lib.mkIf (config.host.features.rust-dev.enable && config.host.features.neovim.enable)` AND-gates.

Platform-specific code lives inside the feature file. The host author only ever writes `<feature>.enable = true;` — the platform fanout (homebrew cask on darwin, nixpkgs package on nixos, HM config, …) is invisible at the inventory level.

Some modules come from `nix-config-private` (private flake input, imported by `modules/hosts/lyng.nix` only) and won't be visible in this repo.

## Rebuilding

Use `./rebuild` (platform-detecting wrapper). Requires sudo; do not run inside Claude Code — tell the user to rebuild manually to test changes.

## Verifying changes without rebuilding

- `nix build --no-link --print-out-paths .#darwinConfigurations.lyng.system` — build lyng (mac).
- `nix eval .#nixosConfigurations.hsrv.config.system.build.toplevel.drvPath` — eval hsrv (cannot build from darwin).
- `nix store diff-closures <before> <after>` — compare closures; empty output = pure refactor.
- `nix flake check --no-build` — eval-only sanity check.

## Build Failures

When debugging nix build errors, check upstream issue trackers before attempting local diagnosis:

- nixpkgs: https://github.com/NixOS/nixpkgs/issues
- nixvim: https://github.com/nix-community/nixvim/issues
- home-manager: https://github.com/nix-community/home-manager/issues
- nix-darwin: https://github.com/LnL7/nix-darwin/issues
- stylix: https://github.com/danth/stylix/issues
- nixos-apple-silicon: https://github.com/nix-community/nixos-apple-silicon/issues
- nix-homebrew: https://github.com/zhaofengli/nix-homebrew/issues
- flake-parts: https://github.com/hercules-ci/flake-parts/issues
- vic/import-tree: https://github.com/vic/import-tree/issues

## Code Style

Do not add comments to code. Preserve all existing comments.

## Neovim

Configured with nixvim. Read `agent_docs/nixvim.md` when working on neovim configuration.
