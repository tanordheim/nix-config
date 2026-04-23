{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim = {
          plugins.lsp = {
            enable = true;
            capabilities = # lua
              ''
                capabilities = require('blink.cmp').get_lsp_capabilities()
                capabilities.textDocument.diagnostic = {
                  dynamicRegistration = true,
                  relatedDocumentSupport = true,
                }
                capabilities.workspace = capabilities.workspace or {}
                capabilities.workspace.diagnostics = {
                  refreshSupport = true,
                }
              '';
            onAttach = # lua
              ''
                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                  vim.keymap.set('n', '<leader>uh', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                  end, { desc = 'Toggle inlay hints' })

                  -- enable inlay hints by default
                  vim.lsp.inlay_hint.enable()
                end

                if client and client:supports_method('textDocument/documentColor') and vim.lsp.document_color then
                  vim.lsp.document_color.enable(true, bufnr, { style = 'virtual' })
                end

                if client and client:supports_method('textDocument/codeLens') then
                  vim.lsp.codelens.refresh({ bufnr = bufnr })
                  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
                    buffer = bufnr,
                    callback = function()
                      vim.lsp.codelens.refresh({ bufnr = bufnr })
                    end,
                  })
                end
              '';
          };

          keymaps = [
            {
              key = "gd";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_definitions()
                  end
                '';
              options.desc = "[G]oto [D]efinition";
            }
            {
              key = "grr";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_references()
                  end
                '';
              options.desc = "Goto references";
            }
            {
              key = "gri";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_implementations()
                  end
                '';
              options.desc = "Goto implementation";
            }
            {
              key = "grt";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_type_definitions()
                  end
                '';
              options.desc = "Goto type definition";
            }
            {
              key = "gO";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_symbols()
                  end
                '';
              options.desc = "Document symbols";
            }
            {
              key = "<leader>sS";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    Snacks.picker.lsp_workspace_symbols()
                  end
                '';
              options.desc = "[S]ymbols in workspace";
            }
            {
              key = "<C-k>";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    vim.lsp.buf.signature_help()
                  end
                '';
              options.desc = "Signature help";
            }
            {
              key = "<leader>cl";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    vim.lsp.codelens.run()
                  end
                '';
              options.desc = "Run [C]ode [L]ens";
            }
            {
              key = "[d";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    vim.diagnostic.jump({ count = -1, float = true })
                  end
                '';
              options.desc = "Goto previous diagnostic";
            }
            {
              key = "]d";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    vim.diagnostic.jump({ count = 1, float = true })
                  end
                '';
              options.desc = "Goto next diagnostic";
            }
          ];
        };
      };
    };
}
