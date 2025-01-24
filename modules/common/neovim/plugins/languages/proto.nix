{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      buf
      protols
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
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
  };
}
