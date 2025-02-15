{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signcolumn = false; # handled by snacks
      current_line_blame = true;
      numhl = true;
    };
  };
}
