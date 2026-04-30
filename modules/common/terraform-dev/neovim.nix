{
  imports = [ ../neovim ];

  home-manager.sharedModules = [
    (
      { pkgs, config, ... }:
      {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
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

          filetype = {
            extension = {
              tf = "terraform";
              tfvars = "terraform-vars";
            };
          };

          extraConfigLua = # lua
            ''
              vim.treesitter.language.register('terraform', 'terraform-vars')
            '';
        };
      }
    )
  ];
}
