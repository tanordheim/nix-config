{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        stylua
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        lua
        luadoc
      ];

      plugins.conform-nvim.settings = {
        formatters_by_ft.lua = [ "stylua" ];
        formatters.stylua = {
          command = "${pkgs.stylua}/bin/stylua";
        };
      };
    };
}
