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
        programs.nixvim.plugins.web-devicons = {
          enable = true;
          lazyLoad = {
            settings = {
              event = "DeferredUIEnter";
            };
          };
        };
      };
    };
}
