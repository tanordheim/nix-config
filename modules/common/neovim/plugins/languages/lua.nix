{
  pkgs,
  lib,
  config,
  ...
}:
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

      plugins.lint.lintersByFt.lua = [ "luacheck" ];

      extraPackages = [
        pkgs.lua-language-server
        pkgs.lua51Packages.luacheck
        pkgs.stylua
      ];
    };

}
