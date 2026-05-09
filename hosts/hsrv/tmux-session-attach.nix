{
  home-manager.sharedModules = [
    {
      programs.zsh.initContent = ''
        if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]] && [[ -t 1 ]]; then
          tmux new-session -A -s main
        fi
      '';
    }
  ];
}
