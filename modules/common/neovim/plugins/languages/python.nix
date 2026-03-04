{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      basedpyright
      ruff
    ];

    extraPlugins = with pkgs.vimPlugins; [
      neotest-python
    ];

    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      python
    ];

    plugins.lsp.servers.basedpyright = {
      enable = true;
      cmd = [
        "${pkgs.basedpyright}/bin/basedpyright-langserver"
        "--stdio"
      ];
      settings = {
        basedpyright.analysis = {
          autoFormatStrings = true;
          inlayHints = {
            variableTypes = true;
            callArgumentNames = true;
            functionReturnTypes = true;
          };
        };
      };
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft.python = [
        "ruff_organize_imports"
        "ruff_format"
      ];
      formatters.ruff_format = {
        command = "${pkgs.ruff}/bin/ruff";
      };
      formatters.ruff_organize_imports = {
        command = "${pkgs.ruff}/bin/ruff";
      };
    };

    plugins.neotest.settings.adapters = [
      {
        __raw = ''
          require("neotest-python")({
            runner = "pytest",
          })
        '';
      }
    ];
  };
}
