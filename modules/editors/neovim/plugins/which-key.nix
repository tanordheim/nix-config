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
        programs.nixvim.plugins.which-key = {
          enable = true;
          lazyLoad = {
            settings = {
              event = "DeferredUIEnter";
            };
          };
          settings.win.border = "rounded";
        };
      };
    };
}
