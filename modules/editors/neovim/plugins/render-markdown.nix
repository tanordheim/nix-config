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
        programs.nixvim.plugins.render-markdown = {
          enable = true;
          lazyLoad = {
            settings = {
              ft = "markdown";
            };
          };
        };
      };
    };
}
