{ lib, config, ... }:
{

  # stylix interferes a little with how I want neovim to look
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    colorschemes.nightfox = {
      enable = true;
      flavor = "dawnfox";
      settings.options = {
        dim_inactive = true;
        transparent = true;
      };
    };
  };

}
