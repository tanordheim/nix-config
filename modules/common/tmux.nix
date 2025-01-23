{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      prefix = "C-a";
      baseIndex = 1;
      terminal = "xterm-256color";
      extraConfig = ''
        set-option -sa terminal-features ',xterm-256color:RGB'
      '';
    };
    home.shellAliases = {
      tma = "tmux attach-session -t";
      tmls = "tmux list-sessions";
      tmn = "tmux new-session -s";
    };
  };
}
