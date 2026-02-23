{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      rust-analyzer
      rustfmt
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      rust
    ];

    plugins.lsp.servers.rust_analyzer = {
      enable = true;
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

    plugins.conform-nvim.settings = {
      formatters_by_ft.rust = [ "rustfmt" ];
      formatters.rustfmt = {
        command = "${pkgs.rustfmt}/bin/rustfmt";
      };
    };
  };
}
