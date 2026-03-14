{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        kotlin-language-server
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        kotlin
      ];

      plugins.lsp.servers.kotlin_language_server = {
        enable = true;
      };
    };
}
