{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        typescript-language-server
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        javascript
        typescript
      ];

      plugins.lsp.servers.ts_ls = {
        enable = true;
      };
    };
}
