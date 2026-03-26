# Neovim (nixvim)

## Structure

- `modules/common/neovim/` — top-level config (options, keymaps, colorscheme, diagnostics)
- `modules/common/neovim/plugins/` — one file per plugin
- `modules/common/neovim/plugins/languages/` — per-language config

## Conventions

All nixvim config is wrapped: `home-manager.users.${config.username}.programs.nixvim = ...`

Prefer structured nixvim options over `extraConfigLua`/`extraConfig`. Use raw Lua only when no structured nixvim option exists for the behavior you need.

Language files follow this pattern: treesitter grammars + LSP server(s) via `plugins.lsp.servers` + formatter via `plugins.conform-nvim` + `extraPackages` (required binaries). Add DAP config in the same file if applicable.

## Reference

- nixvim options search: https://nix-community.github.io/nixvim/
- nixvim issues: https://github.com/nix-community/nixvim/issues
