{
  flake.modules.homeManager.terraform-dev =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.host.features.terraform-dev.enable {
        home.packages = with pkgs; [
          terraform
          tflint
        ];
      };
    };

  flake.modules.homeManager.neovim =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config =
        lib.mkIf (config.host.features.terraform-dev.enable && config.host.features.neovim.enable)
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
          };
    };

  flake.modules.darwin.terraform-dev = { lib, ... }: { };
  flake.modules.nixos.terraform-dev = { lib, ... }: { };
}
