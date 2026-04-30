{
  imports = [ ../neovim ];

  home-manager.sharedModules = [
    (
      { pkgs, config, ... }:
      {
        programs.nixvim = {
          plugins.treesitter.grammarPackages =
            with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
              nix
            ];
          plugins.lsp.servers.nil_ls.enable = true;
          plugins.conform-nvim.settings = {
            formatters_by_ft.nix = [ "nixfmt" ];
            formatters.nixfmt.command = "${pkgs.nixfmt}/bin/nixfmt";
          };
          plugins.lint.lintersByFt.nix = [ "statix" ];
          extraPackages = with pkgs; [
            nil
            statix
          ];
        };
      }
    )
  ];
}
