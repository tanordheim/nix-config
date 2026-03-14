{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim =
    { config, ... }:
    {
      extraPackages = with pkgs; [
        nixfmt
      ];

      plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        nix
      ];

      plugins.conform-nvim.settings = {
        formatters_by_ft.nix = [ "nixfmt" ];
        formatters.nixfmt = {
          command = "${pkgs.nixfmt}/bin/nixfmt";
        };
      };
    };
}
