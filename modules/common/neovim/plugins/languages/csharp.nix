{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      roslyn-ls
      # TODO: temporarily disabled due to build error
      # vscode-extensions.ms-dotnettools.csharp
      netcoredbg
    ];
    extraPlugins = with pkgs.vimPlugins; [
      roslyn-nvim
      rzls-nvim
      easy-dotnet-nvim
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c_sharp
    ];

    extraConfigLua = # lua
      ''
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        require('roslyn').setup {
          handlers = require('rzls.roslyn_handlers'),
          cmd = {
            "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer",
            "--logLevel=Debug",
            "--stdio",
            "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            "--razorSourceGenerator=${pkgs.vscode-extensions.ms-dotnettools.csharp}/share/vscode/extensions/ms-dotnettools.csharp/.razor/Microsoft.CodeAnalysis.Razor.Compiler.dll",
            "--razorDesignTimePath=${pkgs.vscode-extensions.ms-dotnettools.csharp}/share/vscode/extensions/ms-dotnettools.csharp/.razor/Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets",
          },
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
        }
        vim.lsp.config("roslyn", {
          on_attach = function(client)
            -- TODO: this is duplicated from lsp.nix and the default onAttach, since this is not using regular lsp setup
            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
              vim.keymap.set('n', '<leader>uh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
              end, { desc = 'Toggle inlay hints' })

              -- enable inlay hints by default
              vim.lsp.inlay_hint.enable()
            end
          end,
        })
        require('easy-dotnet').setup {
          test_runner = {
            viewmode = 'float',
          },
          auto_bootstrap_namespace = {
            type = "file_scoped",
            enabled = true,
          },
        }
      '';

    plugins.conform-nvim = {
      settings.formatters_by_ft.cs = [ "csharpier" ];
      settings.formatters.csharpier = {
        command = "dotnet";
        args = [
          "tool"
          "run"
          "--allow-roll-forward"
          "dotnet-csharpier"
          "--write-stdout"
        ];
      };
    };

    # plugins.neotest.adapters.dotnet = {
    #   enable = true;
    #   settings = {
    #     discovery_root = "solution";
    #     dotnet_additional_args = [
    #       "--no-restore"
    #       "--no-build"
    #       "--nologo"
    #     ];
    #   };
    # };

    plugins.dap = {
      configurations.cs = [
        {
          type = "coreclr";
          request = "launch";
          name = "launch - netcoredbg";
          program = # lua
            ''
              function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
              end,
            '';
        }
      ];
    };
  };
}
