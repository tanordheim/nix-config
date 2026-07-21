{ lib, config, ... }:
{

  # stylix interferes a little with how I want neovim to look
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    opts.background = "light";

    colorschemes.everforest = {
      enable = true;
      settings = {
        background = "medium";
        dim_inactive_windows = 1;
        transparent_background = 1;
      };
    };
  };

}
