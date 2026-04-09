{ pkgs, config, ... }:
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        kotlin
      ];

      plugins.lsp.servers.kotlin_language_server = {
        enable = true;
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.kotlin = [ "ktlint" ];
        formatters.ktlint = {
          command = "${pkgs.ktlint}/bin/ktlint";
        };
      };

      plugins.lint.lintersByFt = {
        kotlin = [ "ktlint" ];
      };

      extraPackages = with pkgs; [
        kotlin-language-server
        ktlint
      ];
    };
}
