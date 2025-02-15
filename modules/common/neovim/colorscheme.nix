{ config, ... }:
{

  home-manager.users.${config.username} = {
    # stylix interferes a little with how I want neovim to look
    stylix.targets.nixvim.enable = false;

    programs.nixvim = {
      colorschemes.tokyonight = {
        enable = true;
      };
    };
  };
}
