{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      vscode-langservers-extracted
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      html
    ];

    plugins.lsp.servers.html = {
      enable = true;
      cmd = [
        "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
        "--stdio"
      ];
    };
  };
}
