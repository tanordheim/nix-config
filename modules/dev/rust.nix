{
  flake.modules.homeManager.rust-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.rust-dev.enable {
        home.packages = with pkgs; [
          cargo
          clippy
          rustc
        ];
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
      config = lib.mkIf (config.host.features.rust-dev.enable && config.host.features.neovim.enable) {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              rust
              ron
            ];

          plugins.rustaceanvim = {
            enable = true;
            settings = {
              server = {
                settings = {
                  "rust-analyzer" = {
                    check.command = "clippy";
                    inlayHints = {
                      chainingHints.enable = true;
                      typeHints.enable = true;
                      parameterHints.enable = true;
                    };
                    lens = {
                      enable = true;
                      run.enable = true;
                      debug.enable = true;
                      implementations.enable = true;
                      references = {
                        adt.enable = false;
                        enumVariant.enable = false;
                        method.enable = false;
                        trait.enable = false;
                      };
                    };
                  };
                };
              };
              dap = {
                adapter.__raw = ''
                  require("rustaceanvim.config").get_codelldb_adapter(
                    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
                    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb${
                      if pkgs.stdenv.isDarwin then ".dylib" else ".so"
                    }"
                  )
                '';
              };
            };
          };

          plugins.conform-nvim.settings = {
            formatters_by_ft.rust = [ "rustfmt" ];
            formatters.rustfmt = {
              command = "${pkgs.rustfmt}/bin/rustfmt";
            };
          };

          extraPackages = with pkgs; [
            rust-analyzer
            rustfmt
            vscode-extensions.vadimcn.vscode-lldb
          ];

          plugins.crates = {
            enable = true;
            settings = {
              completion = {
                crates = {
                  enabled = true;
                };
              };
            };
          };

          plugins.blink-cmp.settings.sources.providers.crates = {
            module = "blink.compat.source";
            name = "crates";
          };

          plugins.blink-cmp.settings.sources.per_filetype.toml = [
            "crates"
            "lsp"
            "path"
            "snippets"
          ];

          plugins.neotest.settings.adapters = [
            {
              __raw = ''
                require("rustaceanvim.neotest")
              '';
            }
          ];
        };
      };
    };

  flake.modules.darwin.rust-dev = { lib, ... }: { };
  flake.modules.nixos.rust-dev = { lib, ... }: { };
}
