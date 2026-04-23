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
        # commonly needed libraries
        programs.nixvim = {
          plugins = {
            nui.enable = true;
            blink-pairs.enable = true;
          };

          extraPlugins = with pkgs.vimPlugins; [
            plenary-nvim
          ];
        };
      };
    };
}
