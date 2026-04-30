{
  imports = [ ../neovim ];

  home-manager.sharedModules = [
    (
      { pkgs, config, ... }:
      {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
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
    )
  ];
}
