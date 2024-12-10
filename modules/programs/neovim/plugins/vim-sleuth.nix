{ pkgs, ... }:
{
  my.user.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-sleuth
    ];
  };
}
