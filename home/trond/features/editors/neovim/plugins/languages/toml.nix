{ pkgs, config, ... }:
{
  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
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

      extraPackages = with pkgs; [
        taplo
      ];
    };
}
