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
  roslyn-nvim-git = (
    pkgs.vimUtils.buildVimPlugin {
      name = "roslyn.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "seblj";
        repo = "roslyn.nvim";
        rev = "85aca5d48ddf8ada4e010ee9fa4d43c77ebf68c9";
        hash = "sha256-UW0iWGNNWjLIYszKUBYOqoFxbmELX9VVgTj63UJdo4A=";
      };
    }
  );

in
{
  home-manager.users.${config.username}.programs.neovim = {
    extraPackages = with pkgs; [
      roslyn-ls
    ];
    plugins = [
      {
        plugin = roslyn-nvim-git;
        type = "lua";
        config = # lua
          ''
            local roslyn = require('roslyn')
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            -- capabilities = vim.tbl_deep_extend('force', capabilities, {
            --   workspace = {
            --     didChangeWatchedFiles = {
            --       dynamicRegistration = false,
            --     },
            --   },
            -- })

            roslyn.setup({
              config = {
                on_attach = function()
                  if client.is_hacked then
                    return
                  end
                  client.is_hacked = true
                  print("monkeypatching roslyn")

                  -- let the runtime know the server can do semanticTokens/full now
                  client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, {
                    semanticTokensProvider = {
                      full = true,
                    },
                  })

                  -- monkey patch the request proxy
                  local request_inner = client.request
                  client.request = function(method, params, handler, req_bufnr)
                    if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
                      return request_inner(method, params, handler)
                    end

                    local function find_buf_by_uri(search_uri)
                      local bufs = vim.api.nvim_list_bufs()
                      for _, buf in ipairs(bufs) do
                        local name = vim.api.nvim_buf_get_name(buf)
                        local uri = 'file://' .. name
                        if uri == search_uri then
                          return buf
                        end
                      end
                    end

                    local target_bufnr = find_buf_by_uri(params.textDocument.uri)
                    local line_count = vim.api.nvim_buf_line_count(target_bufnr)
                    local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

                    return request_inner('textDocument/semanticTokens/range', {
                      textDocument = params.textDocument,
                      range = {
                        ['start'] = {
                          line = 0,
                          character = 0,
                        },
                        ['end'] = {
                          line = line_count - 1,
                          character = string.len(last_line) - 1,
                        },
                      },
                    }, handler, req_bufnr)
                  end
                end,
              },
              exe = 'Microsoft.CodeAnalysis.LanguageServer',
              args = {
                "--logLevel=Debug", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
              },
              capabilities = capabilities
              -- config = {
              --   settings = {
              --     ['csharp|background_analysis'] = {
              --       dotnet_analyzer_diagnostics_scope = 'fullSolution',
              --       dotnet_compiler_diagnostics_scope = 'fullSolution',
              --     },
              --     ['csharp|completion'] = {
              --       dotnet_provide_regex_completions = true,
              --       dotnet_show_completion_items_from_unimported_namespaces = true,
              --       dotnet_show_name_completion_suggestions = true,
              --     },
              --     ['csharp|inlay_hints'] = {
              --       csharp_enable_inlay_hints_for_implicit_object_creation = true,
              --       csharp_enable_inlay_hints_for_implicit_variable_types = true,
              --       csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              --       csharp_enable_inlay_hints_for_types = true,
              --       dotnet_enable_inlay_hints_for_indexer_parameters = true,
              --       dotnet_enable_inlay_hints_for_literal_parameters = true,
              --       dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              --       dotnet_enable_inlay_hints_for_other_parameters = true,
              --       dotnet_enable_inlay_hints_for_parameters = true,
              --       dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              --       dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              --       dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
              --     },
              --     ['csharp|symbol_search'] = {
              --       dotnet_search_reference_assemblies = true,
              --     },
              --     ['csharp|code_lens'] = {
              --       dotnet_enable_references_code_lens = true,
              --       dotnet_enable_tests_code_lens = true,
              --     },
              --     ['navigation'] = {
              --       dotnet_navigate_to_decompiled_sources = true,
              --     },
              --   },
              --   -- enable semantic tokens for the full buffer
              --   on_attach = function(client)
              --   end
              -- }
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
