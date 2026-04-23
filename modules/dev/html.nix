{
  flake.modules.homeManager.html-dev = { lib, ... }: { };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.host.features.html-dev.enable && config.host.features.neovim.enable) {
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
      };
    };

  flake.modules.darwin.html-dev = { lib, ... }: { };
  flake.modules.nixos.html-dev = { lib, ... }: { };
}
