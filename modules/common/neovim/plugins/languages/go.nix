{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      gopls
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      go
      gomod
      gosum
    ];

    plugins.lsp.servers.gopls = {
      enable = true;
      settings = {
        gopls = {
          analyses = {
            unusedparams = true;
            unusedvariable = true;
            unusedwrite = true;
            useany = true;
          };
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
          semanticTokens = true;
          staticcheck = true;
        };
      };
    };

    plugins.conform-nvim = {
      settings.formatters_by_ft.go = [ "goimports" ];
      settings.formatters.goimports = {
        command = "${pkgs.gotools}/bin/goimports";
      };
    };

    plugins.neotest.adapters.golang.enable = true;
  };
}
