{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
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

          userCommands.LspRestart = {
            command.__raw = # lua
              ''
                function(opts)
                  local filter = opts.args ~= "" and { name = opts.args } or nil
                  local clients = vim.lsp.get_clients(filter)
                  local bufs = {}
                  for _, c in ipairs(clients) do
                    for buf in pairs(c.attached_buffers or {}) do bufs[buf] = true end
                    c:stop()
                  end
                  vim.defer_fn(function()
                    for buf in pairs(bufs) do
                      if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
                      end
                    end
                  end, 100)
                end
              '';
            nargs = "?";
            desc = "Restart LSP client(s)";
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
      
    }
