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
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };

}
