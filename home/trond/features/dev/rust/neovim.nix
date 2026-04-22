{ pkgs, config, ... }:
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
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
    };
}
