{ pkgs, ... }:
{
  my.user.programs.neovim = {
    extraPackages = with pkgs; [
      gopls
      yaml-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = # lua
          ''
            local lspconfig = require('lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            lspconfig.gopls.setup {
              cmd = { "${pkgs.gopls}/bin/gopls" },
              capabilities = capabilities,
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                    unusedvariable = true,
                    unusedwrite = true,
                    useany = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  staticcheck = true,
                },
              },
            }

            lspconfig.yamlls.setup {
              cmd = { "${pkgs.yaml-language-server}/bin/yaml-language-server", "--stdio" },
              capabilities = capabilities,
              settings = {
                yaml = {
                  keyOrdering = false,
                  schemas = {
                    kubernetes = "*.yaml",
                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                  },
                },
              },
            }

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                local telescope_builtin = require('telescope.builtin')

                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client.server_capabilities.inlayHintProvider then
                  vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                end

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
                vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, { desc = '[G]oto [I]mplementation' })
                vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, { desc = '[G]oto [R]eferences' })
                vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
                vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'LSP signature help' })
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[R]e[n]ame' })
                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = '[C]ode [A]ction' })
              end,
            })

            local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
            local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

            -- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
              border = 'rounded',
              max_width = max_width,
              max_height = max_height,
            })

            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
              border = 'rounded',
              max_width = max_width,
              max_height = max_height,
            })
          '';
      }
    ];
  };
}
