{ pkgs, config, ... }:
{
  imports = [ ../../editors/neovim ];

  programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
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

      plugins.lint.lintersByFt = {
        terraform = [ "tflint" ];
      };

      extraPackages = with pkgs; [
        terraform
        tflint
      ];

      filetype = {
        extension = {
          tf = "terraform";
          tfvars = "terraform";
        };
      };
    };
}
