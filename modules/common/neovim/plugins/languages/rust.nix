{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        rust-analyzer
        rustfmt
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        rust
      ];

      plugins.lsp.servers.rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings = {
          rust-analyzer = {
            check = {
              command = "clippy";
            };
            inlayHints = {
              chainingHints.enable = true;
              typeHints.enable = true;
              parameterHints.enable = true;
            };
          };
        };
      };

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

      plugins.conform-nvim.settings = {
        formatters_by_ft.rust = [ "rustfmt" ];
        formatters.rustfmt = {
          command = "${pkgs.rustfmt}/bin/rustfmt";
        };
      };
    };
}
