{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      prefix = "C-a";
    };
  };
}
