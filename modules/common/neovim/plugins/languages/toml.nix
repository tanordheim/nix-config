{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        taplo
      ];

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
    };
}
