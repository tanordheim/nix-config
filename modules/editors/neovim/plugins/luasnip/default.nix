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
        programs.nixvim.plugins = {
          friendly-snippets.enable = true;

          luasnip = {
            enable = true;
            lazyLoad = {
              settings = {
                event = "InsertEnter";
              };
            };
            fromVscode = [
              {
                lazyLoad = true;
                paths = "${pkgs.vimPlugins.friendly-snippets}";
              }
            ];
            fromLua = [
              {
                lazyLoad = true;
                paths = ./snippets;
              }
            ];
          };
        };
      };
    };
}
