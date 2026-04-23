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
        programs.nixvim.plugins.todo-comments = {
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
