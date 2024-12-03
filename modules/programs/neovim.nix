{ pkgs, ... }:
{
  my.user.programs.neovim = {
    enable = true;
    catppuccin.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        plugins: with plugins; [
	  nix
	]
      ))
    ];
  };
}
