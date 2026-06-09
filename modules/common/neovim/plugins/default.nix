{
  pkgs,
  lib,
  config,
  ...
}:
{

  # commonly needed libraries
  programs.nixvim = {
    plugins = {
      nui.enable = true;
      blink-pairs = {
        enable = true;
        package = pkgs.vimPlugins.blink-pairs;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };

}
