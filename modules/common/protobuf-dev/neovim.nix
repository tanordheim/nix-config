{
  imports = [ ../neovim ];

  home-manager.sharedModules = [
    (
      { pkgs, config, ... }:
      {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              proto
            ];

          plugins.lsp.servers.protols = {
            enable = true;
            cmd = [ "${pkgs.protols}/bin/protols" ];
          };

          plugins.conform-nvim.settings = {
            formatters_by_ft.proto = [ "buf" ];
            formatters.buf = {
              command = "${pkgs.buf}/bin/buf";
            };
          };

          extraPackages = with pkgs; [
            buf
            protols
          ];
        };
      }
    )
  ];
}
