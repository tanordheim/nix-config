{ lib, config, ... }:
{

  # stylix interferes a little with how I want neovim to look
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "latte";
        dim_inactive.enabled = true;
        transparent_background = true;
      };
    };
  };

}
