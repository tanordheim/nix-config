{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins = {
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
}
