{ pkgs, config, ... }:
let
  easy-dotnet-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "easy-dotnet.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "GustavEikaas";
        repo = "easy-dotnet.nvim";
        rev = "b0a1fa6a087925fc716291d3ff910d496d259510";
        hash = "sha256-gvV41ek19KFljE82G0bfP6pTkKqYO4yh2eAUe4asFtw=";
      };
    }
  );
  # TODO: cant update to latest nixpkgs-unstable due to asahi issue, pull this from there once I can
  rzls-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "rzls.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "tris203";
        repo = "rzls.nvim";
        rev = "b76f942a9b58bdd0df21b2dfac5f109ad09454bc";
        hash = "sha256-vSTTaWM42cAg1fHDlsZzZ9NQab1Iy7RK+it7px0kRbM=";
      };
    }
  );

in
{
  home-manager.users.${config.username}.programs.neovim = {
    extraPackages = with pkgs; [
      gopls
      roslyn-ls
      vscode-extensions.ms-dotnettools.csharp
      vscode-langservers-extracted
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
                  semanticTokens = true,
                  staticcheck = true,
                },
              },
            }

            lspconfig.html.setup {
              cmd = { "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio" },
              capabilities = capabilities,
            }

            lspconfig.yamlls.setup {
              cmd = { "${pkgs.yaml-language-server}/bin/yaml-language-server", "--stdio" },
              capabilities = capabilities,
              settings = {
                yaml = {
                  keyOrdering = false,
                  schemas = {
                    kubernetes = {
                      "k8s/*.yaml",
                      "manifest/*.yaml"
                    },
                    ["http://json.schemastore.org/golangci-lint.json"] = ".golangci.{yml,yaml}",
                    ["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
                    ["http://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-stable-2.9.json"] = "roles/tasks/*.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-playbook.json"] = "playbook.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/stylelintrc.json"] = ".stylelintrc.{yml,yaml}",
                    ["http://json.schemastore.org/circleciconfig.json"] = ".circleci/**/*.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/helmfile.json"] = "templates/**/*.{yml,yaml}",
                    ["http://json.schemastore.org/chart.json"] = "Chart.yml,yaml}",
                    ["http://json.schemastore.org/gitlab-ci.json"] = "/*lab-ci.{yml,yaml}",
                    ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "templates/**/*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.{yml,yaml}",
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
      {
        plugin = rzls-nvim-git;
      }
      {
        plugin = roslyn-nvim;
        type = "lua";
        config = # lua
          ''
            local roslyn = require('roslyn')
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            roslyn.setup({
              config = {
                on_attach = function() end,
                capabilities = capabilities,
                handlers = require('rzls.roslyn_handlers'),
                settings = {
                  ['csharp|background_analysis'] = {
                    dotnet_analyzer_diagnostics_scope = 'fullSolution',
                    dotnet_compiler_diagnostics_scope = 'fullSolution',
                  },
                  ['csharp|completion'] = {
                    dotnet_provide_regex_completions = true,
                    dotnet_show_completion_items_from_unimported_namespaces = true,
                    dotnet_show_name_completion_suggestions = true,
                  },
                  ['csharp|inlay_hints'] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation = true,
                    csharp_enable_inlay_hints_for_implicit_variable_types = true,
                    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                    csharp_enable_inlay_hints_for_types = true,
                    dotnet_enable_inlay_hints_for_indexer_parameters = true,
                    dotnet_enable_inlay_hints_for_literal_parameters = true,
                    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                    dotnet_enable_inlay_hints_for_other_parameters = true,
                    dotnet_enable_inlay_hints_for_parameters = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                  },
                  ['csharp|symbol_search'] = {
                    dotnet_search_reference_assemblies = true,
                  },
                  ['csharp|code_lens'] = {
                    dotnet_enable_references_code_lens = true,
                    dotnet_enable_tests_code_lens = true,
                  },
                  ['navigation'] = {
                    dotnet_navigate_to_decompiled_sources = true,
                  },
                },
              },
              -- share/vscode/extensions/ms-dotnettools.csharp/.razor/Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets
              exe = 'Microsoft.CodeAnalysis.LanguageServer',
              args = {
                "--logLevel=Debug",
                "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                "--razorSourceGenerator=${pkgs.vscode-extensions.ms-dotnettools.csharp}/share/vscode/extensions/ms-dotnettools.csharp/.razor/Microsoft.CodeAnalysis.Razor.Compiler.dll",
                "--razorDesignTimePath=${pkgs.vscode-extensions.ms-dotnettools.csharp}/share/vscode/extensions/ms-dotnettools.csharp/.razor/Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets",
              },
              -- filewatching = false, -- slow on large projects
              lock_target = true, -- stick to the first picked solution
            })
          '';
      }
      {
        plugin = easy-dotnet-nvim-git;
        type = "lua";
        config = # lua
          ''
            local dotnet = require('easy-dotnet')
            dotnet.setup()
          '';
      }
    ];
  };
}
