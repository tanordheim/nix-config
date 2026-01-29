{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt
    ];

    # broken by https://github.com/nix-community/tree-sitter-nix/issues/84
    # TODO: find fix
    # plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    #   nix
    # ];

    plugins.conform-nvim.settings = {
      formatters_by_ft.nix = [ "nixfmt" ];
      formatters.nixfmt = {
        command = "${pkgs.nixfmt}/bin/nixfmt";
      };
    };
  };
}
