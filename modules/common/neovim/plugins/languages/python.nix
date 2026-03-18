{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        basedpyright
        ruff
        ty
      ];

      extraPlugins = with pkgs.vimPlugins; [
        neotest-python
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        python
      ];

      plugins.lsp.servers.ty = {
        enable = true;
        config = {
          cmd = [
            "ty"
            "server"
          ];
          filetypes = [
            "python"
          ];
          root_dir = {
            __raw = ''
              require('lspconfig.util').root_pattern('pyproject.toml', 'uv.lock', '.git')
            '';
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
