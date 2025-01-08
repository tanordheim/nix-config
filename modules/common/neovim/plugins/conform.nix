{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      stylua
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = conform-nvim;
        type = "lua";
        config = # lua
          ''
            require('conform').setup {
              notify_on_error = true,
              format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                  lsp_format_opt = 'never'
                else
                  lsp_format_opt = 'fallback'
                end
                return {
                  timeout_ms = 500,
                  lsp_format = lsp_format_opt,
                }
              end,
              formatters_by_ft = {
                cs = { 'csharpier' },
                go = { 'goimports' },
                lua = { 'stylua' },
                nix = { 'nixfmt' },
                terraform = { 'terraform_fmt' },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use 'stop_after_first' to run the first available formatter from the list
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
              },
              formatters = {
                csharpier = {
                  command = "${pkgs.dotnet-sdk}/bin/dotnet",
                  args = { 'tool', 'run', '--allow-roll-forward', 'csharpier', '--write-stdout' },
                },
                goimports = {
                  command = "${pkgs.gotools}/bin/goimports"
                },
                nixfmt = {
                  command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
                },
                stylua = {
                  command = "${pkgs.stylua}/bin/stylua"
                },
                terraform_fmt = {
                  command = "${pkgs.terraform}/bin/terraform"
                },
              }
            }

            vim.keymap.set('n', '<leader>f', function()
              require('conform').format { async = true, lsp_format = 'fallback' }
            end, { desc = '[F]ormat buffer' })
          '';
      }
    ];
  };
}
