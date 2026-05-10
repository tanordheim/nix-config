{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
      in
      {
        home.packages = [
          pkgs.sesh
          pkgs.fzf
        ];

        programs.tmux = {
          enable = true;
          sensibleOnTop = false;
          mouse = true;
          keyMode = "vi";
          baseIndex = 1;
          escapeTime = 0;
          historyLimit = 50000;
          terminal = "tmux-256color";

          extraConfig = ''
            unbind C-b
            set -g prefix C-Space
            bind C-Space send-prefix

            bind R source-file ~/.config/tmux/tmux.conf \; display "tmux config reloaded"
            bind Tab last-window

            unbind '"'
            unbind %
            bind s split-window -v -c "#{pane_current_path}"
            bind v split-window -h -c "#{pane_current_path}"
            bind c new-window -c "#{pane_current_path}"

            bind J command-prompt -p "join pane from window:" "join-pane -h -s ':%%'"
            bind K command-prompt -p "join pane from window:" "join-pane -v -s ':%%'"

            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi V send -X select-line
            bind -T copy-mode-vi C-v send -X rectangle-toggle
            bind -T copy-mode-vi y send -X copy-pipe-and-cancel

            set -g set-clipboard on

            set -g focus-events on
            set -g renumber-windows on
            setw -g pane-base-index 1
            setw -g aggressive-resize on

            set -as terminal-features ",*:RGB"
            set -as terminal-features ",*:usstyle"

            # claude code: shift+enter / extended keys passthrough
            set -g allow-passthrough on
            set -s extended-keys on
            set -as terminal-features "xterm*:extkeys"

            is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?|fzf)(diff)?$'"

            bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
            bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
            bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
            bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

            bind-key -n C-Left  if-shell "$is_vim" "send-keys C-Left"  "resize-pane -L 3"
            bind-key -n C-Down  if-shell "$is_vim" "send-keys C-Down"  "resize-pane -D 3"
            bind-key -n C-Up    if-shell "$is_vim" "send-keys C-Up"    "resize-pane -U 3"
            bind-key -n C-Right if-shell "$is_vim" "send-keys C-Right" "resize-pane -R 3"

            bind-key -T copy-mode-vi C-h select-pane -L
            bind-key -T copy-mode-vi C-j select-pane -D
            bind-key -T copy-mode-vi C-k select-pane -U
            bind-key -T copy-mode-vi C-l select-pane -R

            bind o display-popup -E -w 60% -h 60% \
              "sesh connect \"$(sesh list -i | fzf-tmux -p 55%,55% --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ')\""

            set -g status on
            set -g status-position bottom
            set -g status-interval 5
            set -g status-justify centre

            set -g status-left-length 40
            set -g status-right-length 40

            set -g status-left "#[fg=${c.base00},bg=${c.base0D},bold] #S #[fg=${c.base0D},bg=${c.base00}] "
            set -g status-right "#[fg=${c.base04}]%H:%M  #[fg=${c.base0D},bold]#H "

            set -g window-status-format " #I:#W "
            set -g window-status-current-format "#[fg=${c.base00},bg=${c.base0E},bold] #I:#W "
            set -g window-status-separator ""
          '';
        };
      }
    )
  ];
}
