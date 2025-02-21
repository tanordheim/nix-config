{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      delve
      golangci-lint-langserver
      gopls
      gofumpt
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
          gofumpt = true;
          usePlaceholders = true;
          semanticTokens = true;
          staticcheck = true;
        };
      };
    };

    plugins.lsp.servers.golangci_lint_ls = {
      enable = true;
      settings = {
        cmd = [ pkgs.golangci-lint-langserver ];
        init_options = {
          command = [
            pkgs.golangci-lint
            "run"
            "--out-format"
            "json"
          ];
        };
      };
    };

    plugins.conform-nvim = {
      settings.formatters_by_ft.go = [ "gofumpt" ];
      settings.formatters.gofumpt = {
        command = "${pkgs.gofumpt}/bin/gofumpt";
      };
    };

    plugins.neotest.adapters.golang.enable = true;
    plugins.dap-go = {
      enable = true;
      settings.delve.path = "${pkgs.delve}/bin/dlv";
    };
  };
}
