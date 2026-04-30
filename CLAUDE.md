## Structure

Plain flake with explicit imports. No flake-parts, no auto-discovery, no feature flags.

- `flake.nix` — `inputs` and `outputs`. `outputs` is a let-binding that builds an `lib.extend`-ed `lib` (adding `lib.mkPlatformImport`) and assigns:
  - `darwinConfigurations.lyng = inputs.nix-darwin.lib.darwinSystem { specialArgs = { inputs; isDarwin = true; lib = libExtended; }; modules = [ ./hosts/lyng/default.nix ]; };`
  - `nixosConfigurations.hsrv = inputs.nixpkgs.lib.nixosSystem { specialArgs = { inputs; isDarwin = false; lib = libExtended; }; modules = [ ./hosts/hsrv/default.nix ]; };`
- `lib/mkPlatformImport.nix` — `dir: isDarwin: dir + (if isDarwin then "/_darwin.nix" else "/_linux.nix")`. Used as `lib.mkPlatformImport ./. isDarwin` from a module's `default.nix` to pick a platform-specific sibling. `isDarwin` is passed via `specialArgs` (not `pkgs.stdenv.isDarwin` — using `pkgs` in `imports` causes infinite recursion).
- `hosts/<host>/default.nix` — host inventory: identity (`networking.hostName`, `nixpkgs.hostPlatform`, `system.stateVersion`, network config) + `imports = [ ../../modules/<platform>/_base.nix … ../../modules/common/<feature> … ];`. Reading the file tells you exactly what's installed.
- `hosts/hsrv/{hardware-configuration,sops,arr-download-clients,backups}.nix` — host-specific siblings imported from `hosts/hsrv/default.nix`. Hardware, secrets, cross-service glue specific to hsrv lives here, not in `modules/`.
- `modules/<scope>/<feature>/` — every feature is a directory with `default.nix`. `<scope>` is one of:
  - `common/` — cross-platform features. Default placement.
  - `darwin/` — darwin-only (`_base.nix`).
  - `nixos/` — nixos-only services (media, automation, web, atuin-server) and `_base.nix`.
- `modules/<scope>/_base.nix` — platform baseline: HM integration module, `nix.settings`/`gc`, `imports` of all unconditional `common/` modules + platform-specific bits (homebrew + macOS defaults + touch-id sudo on darwin; nothing extra on nixos beyond what `common/` provides).
- `modules/common/_overlays.nix` — `nixpkgs.overlays` (`stable`/`bleeding`/`custom` via inputs + `(import ../../overlays inputs)`). Imported by both `_base.nix` files.
- `modules/common/users/trond/` — user account. `default.nix` dispatches via `mkPlatformImport`. `_darwin.nix` sets `users.users.trond` + `system.primaryUser`. `_linux.nix` sets `users.users.trond` + polkit/sudo. Both push `home.homeDirectory` (and on linux `xdg`) via `home-manager.sharedModules`. This is the only place "trond" is hardcoded outside host files.
- `modules/common/stylix/` — universal stylix config, imported from `_base.nix`. `default.nix` sets cross-platform stylix fonts/theme/HM `gtk.gtk4.theme` override; `_darwin.nix` and `_linux.nix` import the platform stylix module and set platform-specific bits.
- `modules/common/{zsh,git,ssh,starship,eza,zoxide,direnv,shell-aliases,build-tools,fonts,sudo,timezone,hm-base,base}/` — unconditional baseline. Imported from `_base.nix`. HM-targeted ones push via `home-manager.sharedModules`; system-targeted ones (`fonts`, `sudo`, `timezone`, `base`) configure system options directly.
- `modules/common/<app>/` — user-facing applications (1password as `_1password/`, slack, firefox, chrome, claude/, claude-desktop, etc.). Plain modules: no feature gate, no `flake.modules` namespace. Platform-divergent ones split via `default.nix` + `_darwin.nix` + `_linux.nix`. HM contributions via `home-manager.sharedModules`.
- `modules/common/{aws,gcp,kubernetes,postgres,redis,kaf,stern,atuin}/` — cloud and CLI/data tools.
- `modules/common/neovim/` — nixvim-based neovim base. `default.nix` pushes `inputs.nixvim.homeModules.nixvim` plus all sub-files under `colorscheme.nix`, `diagnostics.nix`, `keymaps.nix`, `options.nix`, `remember-cursor-position.nix`, `plugins/*.nix`, `plugins/luasnip/`, `plugins/languages/{lua,shell,toml,yaml}.nix` into `home-manager.sharedModules`. Each sub-file is a plain HM module configuring `programs.nixvim`. Read `agent_docs/nixvim.md` when working on neovim configuration.
- `modules/common/{jetbrains,vscode}/` — editor hubs that language modules contribute to. `jetbrains/default.nix` exposes a `jetbrains.ideavimConfigs` option (attrset of per-product IdeaVim configs) and emits `xdg.configFile."ideavim/ideavimrc"`.
- `modules/common/<lang>-dev/` — language toolchain + editor integrations. `default.nix` imports the relevant subset of `./toolchain.nix`, `./neovim.nix`, `./jetbrains.nix`, `./vscode.nix`. Each integration file imports its respective editor (`../neovim`, `../jetbrains`, `../vscode`) so it's self-sufficient when the host wants only that language. Dependency direction is **lang → editor, never editor → lang.** No cycles.
- `modules/common/private/default.nix` — opt-in. Pushes `inputs.nix-config-private.homeManagerModules.default` into `home-manager.sharedModules`. Modules from `nix-config-private` won't be visible in this repo.
- `modules/nixos/<service>/` — nixos-only system services (atuin-server, aurral, bazarr, caddy, home-assistant, lidarr, mosquitto, plex, prowlarr, qbittorrent, radarr, sabnzbd, seerr, sonarr, unpackerr, zigbee2mqtt). Each typically configures `services.<x>`, optional `systemd.services.<x>` overrides, sops templates/secrets, and a `services.caddy.virtualHosts.<host>.extraConfig` reverse-proxy block.
- `overlays/` — nixpkgs overlays. `default.nix` is called with `inputs` at eval time; sub-overlays destructure specific inputs.

## Single-user assumption

HM contributions are pushed through `home-manager.sharedModules`, which applies to **every** HM user. The repo assumes a single user (`trond`). If a second user is ever introduced, switch the relevant modules from `home-manager.sharedModules = [ … ]` to `home-manager.users.<name>.imports = [ … ]`. The user-provisioning file `modules/common/users/trond/` (and host files) are the only places `"trond"` is hardcoded.

## Adding a new feature

1. Create `modules/<scope>/<name>/default.nix`. If the feature has divergent platform behavior, also add `_darwin.nix` and `_linux.nix` and have `default.nix` do `imports = [ (lib.mkPlatformImport ./. isDarwin) ];`.
2. HM contributions go via `home-manager.sharedModules = [ … ]` (or `[ ({ pkgs, … }: { … }) ]` if the inner needs args).
3. System contributions go directly (`environment.systemPackages`, `services.x`, `homebrew.casks`, etc.).
4. If the feature integrates with editors (rust-dev × neovim, etc.), add a sibling `neovim.nix`/`jetbrains.nix`/`vscode.nix` that does `imports = [ ../neovim ];` and adds the integration. `default.nix` then `imports = [ ./toolchain.nix ./neovim.nix ];`.
5. Add `../../modules/<scope>/<name>` to the relevant host file's `imports` list.

## Rebuilding

Use `./rebuild` (platform-detecting wrapper). Requires sudo; do not run inside Claude Code — tell the user to rebuild manually to test changes.

## Verifying changes without rebuilding

- `nix build --no-link --print-out-paths .#darwinConfigurations.lyng.system` — build lyng (mac).
- `nix eval --raw .#nixosConfigurations.hsrv.config.system.build.toplevel.drvPath` — eval hsrv (cannot build from darwin).
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

## Code Style

Do not add comments to code. Preserve all existing comments.
