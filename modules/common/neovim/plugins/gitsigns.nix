{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      numhl = true;
    };
  };
}
