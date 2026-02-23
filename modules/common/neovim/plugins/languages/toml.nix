{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      taplo
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      toml
    ];

    plugins.lsp.servers.taplo = {
      enable = true;
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft.toml = [ "taplo" ];
      formatters.taplo = {
        command = "${pkgs.taplo}/bin/taplo";
      };
    };
  };
}
