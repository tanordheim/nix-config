{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      ty
      ruff
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      python
    ];

    plugins.lsp.servers.ty = {
      enable = true;
      cmd = [
        "${pkgs.ty}/bin/ty"
        "server"
      ];
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft.python = [ "ruff_format" ];
      formatters.ruff_format = {
        command = "${pkgs.ruff}/bin/ruff";
      };
    };
  };
}
