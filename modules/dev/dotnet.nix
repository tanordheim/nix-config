{
  flake.modules.homeManager.dotnet-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.dotnet;

      dotnet-packages =
        with pkgs;
        with dotnetCorePackages;
        combinePackages [
          sdk_10_0-bin
        ];

      dotnet-sdk = pkgs.dotnetCorePackages.sdk_10_0-bin;

      buildNugetConfig =
        nugetSources:
        pkgs.stdenv.mkDerivation {
          name = "nugetConfig";
          phases = [ "installPhase" ];
          buildInputs = [ dotnet-sdk ];
          installPhase =
            let
              toCommand =
                name: params:
                ''${dotnet-sdk}/bin/dotnet nuget add source "${params.url}" --name "${name}" --protocol-version "${builtins.toString (params.protocolVersion)}" --username "${params.username}" --password "${params.password}" --store-password-in-clear-text'';
              commands = lib.concatStringsSep "\n" (lib.mapAttrsToList toCommand nugetSources);
            in
            ''
              mkdir -p "$out"
              export HOME=$TMPDIR
              ${dotnet-sdk}/bin/dotnet nuget remove source nuget.org
              ${commands}
              cp -R $TMPDIR/.nuget $out/
            '';
        };

      toJSON = (pkgs.formats.json { }).generate;
    in
    {
      options.dotnet.nugetSources = lib.mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              url = mkOption {
                type = types.str;
              };
              protocolVersion = mkOption {
                type = types.ints.between 2 3;
                default = 2;
              };
              username = mkOption {
                type = types.str;
                default = "";
              };
              password = mkOption {
                type = types.str;
                default = "";
              };
            };
          }
        );
        default = { };
      };

      config = lib.mkIf config.host.features.dotnet-dev.enable {
        home.packages = [ dotnet-packages ];

        home.sessionPath = [
          "$HOME/.dotnet/tools"
        ];
        home.sessionVariables = {
          DOTNET_ROOT = "${dotnet-packages}/share/dotnet";
        };

        dotnet.nugetSources = {
          "nuget.org" = {
            url = "https://api.nuget.org/v3/index.json";
            protocolVersion = 3;
          };
        };

        home.file = {
          ".nuget/NuGet/NuGet.Config".source =
            let
              nugetConfig = buildNugetConfig cfg.nugetSources;
            in
            "${nugetConfig}/.nuget/NuGet/NuGet.Config";

          "omnisharp.json".source = toJSON "omnisharp.json" {
            RoslynExtensionOptions = {
              enableDecompilationSupport = true;
              enableAnalyzersSupport = true;
              inlayHintsOptions = {
                enableForParameters = true;
                forLiteralParameters = true;
                forIndexerParameters = true;
                forObjectCreationParameters = true;
                forOtherParameters = true;
                suppressForParametersThatDifferOnlyBySuffix = true;
                suppressForParametersThatMatchMethodIntent = true;
                suppressForParametersThatMatchArgumentName = true;
                enableForTypes = true;
                forImplicitVariableTypes = true;
                forLambdaParameterTypes = true;
                forImplicitObjectCreation = true;
              };
            };
          };
        };
      };
    };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.dotnet-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              c_sharp
            ];

          filetype = {
            extension = {
              razor = "razor";
              cshtml = "razor";
            };
          };

          plugins.conform-nvim = {
            settings.formatters_by_ft.cs = [ "csharpier" ];
            settings.formatters.csharpier = { };
          };

          extraPackages = with pkgs; [
            roslyn-ls
          ];

          extraPlugins = with pkgs.vimPlugins; [
            roslyn-nvim
            easy-dotnet-nvim
          ];

          extraConfigLua = # lua
            ''
              local capabilities = require('blink.cmp').get_lsp_capabilities()
              require('roslyn').setup {
                cmd = {
                  "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer",
                  "--logLevel=Debug",
                  "--stdio",
                  "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
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
        };
      };
    };

  flake.modules.homeManager.jetbrains =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.host.features.dotnet-dev.enable && config.host.features.jetbrains.enable)
          (
            let
              versionMajorMinor = lib.versions.majorMinor pkgs.jetbrains.rider.version;

              vmOptionsFile =
                if pkgs.stdenv.isDarwin then
                  "Library/Application Support/JetBrains/Rider${versionMajorMinor}/rider.vmoptions"
                else
                  ".config/JetBrains/Rider${versionMajorMinor}/rider64.vmoptions";

              vmOptionsContent =
                if pkgs.stdenv.isDarwin then
                  ''
                    -Xms1g
                    -Xmx2g
                  ''
                else
                  ''
                    -Xms1g
                    -Xmx2g
                    -Dawt.toolkit.name=WLToolkit
                  '';
            in
            {
              home = {
                packages = [ pkgs.bleeding.jetbrains.rider ];
                file = {
                  "${vmOptionsFile}".text = vmOptionsContent;
                };
              };

              jetbrains.ideavimConfigs.rider = ''
                " solution-wide error navigation
                nnoremap [D :action ReSharperGotoPrevErrorInSolution<CR>
                nnoremap ]D :action ReSharperGotoNextErrorInSolution<CR>

                " building and testing
                nnoremap <leader>B :action BuildSolutionAction<CR>
                nnoremap <leader>tt :action RiderUnitTestRunContextAction<CR>
                nnoremap <leader>ta :action RiderUnitTestRunClassAction<CR>
                nnoremap <leader>tl :action RiderUnitTestRepeatPreviousRunAction<CR>
              '';
            }
          );
    };

  flake.modules.homeManager.vscode =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.dotnet-dev.enable && config.host.features.vscode.enable) {
        programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
          ms-dotnettools.csdevkit
          ms-dotnettools.csharp
          ms-dotnettools.vscodeintellicode-csharp
        ];
      };
    };

  flake.modules.darwin.dotnet-dev = { lib, ... }: { };
  flake.modules.nixos.dotnet-dev = { lib, ... }: { };
}
