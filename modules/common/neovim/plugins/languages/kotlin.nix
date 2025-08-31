{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      kotlin-language-server
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      kotlin
    ];

    plugins.lsp.servers.kotlin_language_server = {
      enable = true;
    };
  };
}
