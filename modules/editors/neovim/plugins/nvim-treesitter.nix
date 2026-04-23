{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim =
          { config, ... }:
          {
            plugins.treesitter = {
              enable = true;
              settings = {
                highlight.enable = true;
                indent.enable = false;
              };

              # grammar packages not covered by a language setup under ./languages/
              grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
                bash
                c
                css
                devicetree
                diff
                helm
                http
                ini
                just
                json
                query
                rasi
                vim
                vimdoc
              ];
            };
          };
      };
    };
}
