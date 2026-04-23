{
  flake.modules.homeManager.neovim =
    { lib, config, ... }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim = {
          plugins.lint = {
            enable = true;
          };
        };
      };
    };
}
