{ pkgs, config, ... }:
{
  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        lua
        luadoc
      ];

      plugins.lsp.servers.lua_ls = {
        enable = true;
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.lua = [ "stylua" ];
        formatters.stylua = {
          command = "${pkgs.stylua}/bin/stylua";
        };
      };

      extraPackages = with pkgs; [
        lua-language-server
        stylua
      ];
    };
}
