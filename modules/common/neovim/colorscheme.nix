{ config, ... }:
{

  home-manager.users.${config.username} = {
    # stylix interferes a little with how I want neovim to look
    stylix.targets.nixvim.enable = false;

    programs.nixvim = {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          dim_inactive.enabled = true;
          transparent_background = true;
        };
      };
    };
  };
}
