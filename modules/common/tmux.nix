{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      prefix = "C-a";
    };
    home.shellAliases = {
      tma = "tmux attach-session -t";
      tmls = "tmux list-sessions";
      tmn = "tmux new-session -s";
    };
  };
}
