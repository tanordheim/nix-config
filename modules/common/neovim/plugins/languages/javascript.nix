{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        javascript
        typescript
      ];

      plugins.lsp.servers.vtsls = {
        enable = true;
      };

      plugins.lsp.servers.eslint = {
        enable = true;
        settings = {
          workingDirectory.mode = "auto";
        };
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.javascript = [ "prettierd" ];
        formatters_by_ft.typescript = [ "prettierd" ];
        formatters_by_ft.javascriptreact = [ "prettierd" ];
        formatters_by_ft.typescriptreact = [ "prettierd" ];
        formatters.prettierd = {
          command = "${pkgs.prettierd}/bin/prettierd";
        };
      };

      extraPackages = with pkgs; [
        prettierd
        vscode-langservers-extracted
        vtsls
      ];
    };
}
