{
  home-manager.sharedModules = [
    (
      { config, lib, pkgs, ... }:
      let
        c = config.lib.stylix.colors.withHashtag;
        palette = [
          c.base08
          c.base09
          c.base0A
          c.base0B
          c.base0C
          c.base0D
          c.base0E
          c.base0F
        ];
        sessionColor = pkgs.writeShellScript "tmux-session-color" ''
          set -u
          name="''${1:-}"
          colors=(${lib.concatMapStringsSep " " (x: ''"${x}"'') palette})
          state="''${XDG_RUNTIME_DIR:-/tmp}/tmux-session-color.map"
          : > "$state.lock" 2>/dev/null || true
          (
            ${pkgs.util-linux}/bin/flock 9
            touch "$state"
            existing=$(${pkgs.gawk}/bin/awk -v n="$name" -F'\t' '$1==n {print $2; exit}' "$state")
            if [ -n "$existing" ]; then
              printf '%s' "$existing"
              exit 0
            fi
            used=$(${pkgs.gawk}/bin/awk -F'\t' '{print $2}' "$state")
            for col in "''${colors[@]}"; do
              if ! printf '%s\n' "$used" | grep -qxF "$col"; then
                printf '%s\t%s\n' "$name" "$col" >> "$state"
                printf '%s' "$col"
                exit 0
              fi
            done
            idx=$(( $(printf '%s' "$name" | cksum | ${pkgs.gawk}/bin/awk '{print $1}') % ''${#colors[@]} ))
            printf '%s' "''${colors[$idx]}"
          ) 9>"$state.lock"
        '';
        prune = pkgs.writeShellScript "tmux-session-color-prune" ''
          set -u
          tmux=${pkgs.tmux}/bin/tmux
          state="''${XDG_RUNTIME_DIR:-/tmp}/tmux-session-color.map"
          [ -f "$state" ] || exit 0
          alive="$($tmux list-sessions -F '#{session_name}' 2>/dev/null)" || exit 0
          (
            ${pkgs.util-linux}/bin/flock 9
            tmp="$(mktemp "''${state}.XXXXXX")"
            ${pkgs.gawk}/bin/awk -F'\t' -v alive="$alive" '
              BEGIN { n = split(alive, a, "\n"); for (i = 1; i <= n; i++) live[a[i]] = 1 }
              live[$1]
            ' "$state" > "$tmp" && mv "$tmp" "$state"
          ) 9>"$state.lock"
        '';
        applyStyle = pkgs.writeShellScript "tmux-apply-session-style" ''
          set -u
          tmux=${pkgs.tmux}/bin/tmux
          name="$($tmux display -p '#S' 2>/dev/null)" || exit 0
          [ -n "$name" ] || exit 0
          color="$(${sessionColor} "$name")"
          [ -n "$color" ] || exit 0
          $tmux set status-style "fg=${c.base00},bg=$color"
          $tmux set -g pane-active-border-style "fg=$color"
          $tmux set message-style "fg=${c.base00},bg=$color,bold"
        '';
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
              "sesh connect \"$(sesh list -it | fzf --no-sort --ansi --border --border-label ' sesh ' --prompt '⚡  ')\""

            set -g status on
            set -g status-position bottom
            set -g status-interval 5
            set -g status-justify centre

            set -g status-left-length 60
            set -g status-right-length 40

            set -g status-left "#[fg=${c.base00},bg=#(${sessionColor} '#S'),bold]  #S  "
            set -g status-right "#[fg=${c.base00},bold]%H:%M    #H  "

            set -g window-status-format "#[fg=${c.base00}] #I:#W "
            set -g window-status-current-format "#[fg=#(${sessionColor} '#S'),bg=${c.base00},bold] #I:#W "
            set -g window-status-separator ""

            set-hook -g client-session-changed 'run-shell -b "${applyStyle}"'
            set-hook -g session-created       'run-shell -b "${applyStyle}"'
            set-hook -g session-renamed       'run-shell -b "${applyStyle}"'
            set-hook -g after-new-session     'run-shell -b "${applyStyle}"'
            set-hook -g session-closed        'run-shell -b "${prune}"'
            set-hook -ag session-renamed      'run-shell -b "${prune}"'
            run-shell -b "${applyStyle}"
          '';
        };
      }
    )
  ];
}
