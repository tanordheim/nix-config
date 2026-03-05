{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}:
{
  home-manager.users.${config.username} =
    { config, ... }:
    {
      imports = [
        nixvim.homeModules.nixvim
      ];
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        # set <space> as the leader key; this must happen before anything else
        globals.mapleader = " ";

        # facilitates lazy loading
        plugins.lz-n.enable = true;

        # TEMPORARY: event timing diagnostic
        extraConfigLuaPre = ''
          do
            local start = vim.uv.hrtime()
            local log = io.open("/tmp/nvim-events.log", "w")
            local function ms() return string.format("%.1f", (vim.uv.hrtime() - start) / 1e6) end
            local function record(ev)
              return function(e)
                if log then
                  log:write(ms() .. "ms  " .. ev .. "  " .. (e.file or "") .. "\n")
                  log:flush()
                end
              end
            end
            for _, ev in ipairs({
              "BufReadPre", "BufRead", "BufReadPost",
              "FileType", "BufEnter", "BufWinEnter", "BufWritePost"
            }) do
              vim.api.nvim_create_autocmd(ev, { callback = record(ev) })
            end
          end
        '';

        luaLoader.enable = true;
        performance.byteCompileLua = {
          enable = true;
          plugins = true;
        };
      };
      programs.neovide = {
        enable = false;
        settings = {
          font = {
            normal = [ "${config.stylix.fonts.monospace.name}" ];
            size = config.stylix.fonts.sizes.terminal;
          };
        };
      };
    };

  imports = [
    ./colorscheme.nix
    ./keymaps.nix
    ./options.nix
    ./diagnostics.nix
    ./remember-cursor-position.nix
    ./plugins
  ];
}
