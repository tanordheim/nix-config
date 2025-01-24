{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      basedpyright
      black
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      python
    ];

    plugins.lsp.servers.basedpyright = {
      enable = true;
      cmd = [
        "${pkgs.basedpyright}/bin/basedpyright-langserver"
        "--stdio"
      ];
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft.python = [ "black" ];
      formatters.black = {
        command = "${pkgs.black}/bin/black";
      };
    };
  };
}
