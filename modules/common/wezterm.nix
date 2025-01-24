{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          local config = {
            check_for_updates = false,
            enable_scroll_bar = true,
            scrollback_lines = 10000,
            automatically_reload_config = true,
            window_decorations = 'NONE',
            default_cursor_style = 'BlinkingUnderline',

            hide_tab_bar_if_only_one_tab = false,
            tab_bar_at_bottom = true,
            use_fancy_tab_bar = false,
            show_new_tab_button_in_tab_bar = false,

            leader = {
              key = 'a',
              mods = 'CTRL',
              timeout_milliseconds = 1000,
            },

            keys = {
              {
                key = 'c',
                mods = 'CTRL',
                action = wezterm.action_callback(function(window, pane)
                  local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                  if has_selection then
                    window:perform_action(
                      wezterm.action{CopyTo='ClipboardAndPrimarySelection'},
                      pane)
                    window:perform_action('ClearSelection', pane)
                  else
                    window:perform_action(
                      wezterm.action{SendKey={key='c', mods='CTRL'}},
                      pane)
                  end
                end)
              },
              {
                key = '>',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.IncreaseFontSize
              },
              {
                key = '<',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.DecreaseFontSize
              },
              {
                key = '?',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.ResetFontSize
              },

              -- tab management
              {
                key = 'c',
                mods = 'LEADER',
                action = wezterm.action.SpawnTab 'CurrentPaneDomain'
              },
              {
                key = 'x',
                mods = 'LEADER',
                action = wezterm.action.CloseCurrentTab { confirm = true },
              },
              {
                key = 't',
                mods = 'LEADER',
                action = wezterm.action.ActivateTabRelative(-1),
              },
              {
                key = 'n',
                mods = 'LEADER',
                action = wezterm.action.ActivateTabRelative(1),
              },
            }
          }

          -- configure hotkeys for switching directly to tabs
          for i = 1, 8 do
            table.insert(config.keys, {
              key = tostring(i),
              mods = 'LEADER',
              action = wezterm.action.ActivateTab(i - 1),
            })
          end

          return config
        '';
    };
  };
}
