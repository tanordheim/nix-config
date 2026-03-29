{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        nix
      ];

      plugins.lsp.servers.nil_ls = {
        enable = true;
      };

      plugins.conform-nvim.settings = {
        formatters_by_ft.nix = [ "nixfmt" ];
        formatters.nixfmt = {
          command = "${pkgs.nixfmt}/bin/nixfmt";
        };
      };

      plugins.lint.lintersByFt = {
        nix = [ "statix" ];
      };

      extraPackages = with pkgs; [
        nil
        statix
      ];
    };
}
