{ lib, config, ... }:
{

  # stylix interferes a little with how I want neovim to look
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    colorschemes.kanagawa = {
      enable = true;
      settings = {
        theme = "wave";
        dimInactive = true;
        transparent = true;
      };
    };
  };

}
