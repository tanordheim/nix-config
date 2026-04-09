# Neovim (nixvim)

## Structure

- `home/trond/features/editors/neovim/` — base editor config (options, keymaps, colorscheme, diagnostics)
- `home/trond/features/editors/neovim/plugins/` — one file per plugin
- `home/trond/features/editors/neovim/plugins/languages/` — universal languages only (yaml, toml, shell, lua)
- `home/trond/features/dev/<lang>/neovim.nix` — per-language LSP/formatter/DAP config (imports editors/neovim)

## Conventions

Prefer structured nixvim options over `extraConfigLua`/`extraConfig`. Use raw Lua only when no structured nixvim option exists for the behavior you need.

Universal language files (yaml, toml, shell, lua) live in `plugins/languages/`. All other language configs live in `dev/<lang>/neovim.nix` and import `../../editors/neovim` so the base editor is included. Each language file follows: treesitter grammars + LSP server(s) via `plugins.lsp.servers` + formatter via `plugins.conform-nvim` + `extraPackages` (required binaries). Add DAP config in the same file if applicable.

## Reference

- nixvim options search: https://nix-community.github.io/nixvim/
- nixvim issues: https://github.com/nix-community/nixvim/issues
