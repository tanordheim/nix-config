{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      terraform
    ];

    plugins.lsp.servers.terraformls = {
      enable = true;
    };

    plugins.conform-nvim.settings = {
      formatters_by_ft.terraform = [ "terraform_fmt" ];
      formatters.terraform_fmt = {
        command = "${pkgs.terraform}/bin/terraform";
      };
    };

    filetype = {
      extension = {
        tf = "terraform";
        tfvars = "terraform";
      };
    };
  };
}
