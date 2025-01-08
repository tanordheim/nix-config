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

            roslyn.setup({
              config = {
                on_attach = function() end,
                capabilities = capabilities,
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
              exe = 'Microsoft.CodeAnalysis.LanguageServer',
              args = {
                "--logLevel=Debug", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
              },
              filewatching = false, -- slow on large projects
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
