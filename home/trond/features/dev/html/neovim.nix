{ pkgs, config, ... }:
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        html
      ];

      plugins.lsp.servers.html = {
        enable = true;
        cmd = [
          "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
          "--stdio"
        ];
      };

      extraPackages = with pkgs; [
        vscode-langservers-extracted
      ];
    };
}
