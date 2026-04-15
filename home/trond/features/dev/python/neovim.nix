{ pkgs, config, ... }:
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        python
      ];

      plugins.lsp.servers.basedpyright = {
        enable = true;
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

      extraPackages = with pkgs; [
        basedpyright
        ruff
      ];

      extraPlugins = with pkgs.vimPlugins; [
        neotest-python
      ];

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
