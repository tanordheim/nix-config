{ pkgs, config, ... }:
{
  home-manager.users.${config.username} = {
    programs.wezterm = {
      enable = true;
      extraConfig = # lua
        ''
          return {
            check_for_updates = false,
            enable_scroll_bar = true,
            hide_tab_bar_if_only_one_tab = true,
            scrollback_lines = 10000,
            automatically_reload_config = true,
            default_cursor_style = 'BlinkingUnderline',

            keys = {
              {
                key='c',
                mods='CTRL',
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
                key = '.',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.IncreaseFontSize
              },
              {
                key = ',',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.DecreaseFontSize
              },
              {
                key = '/',
                mods = 'CTRL|SHIFT',
                action = wezterm.action.ResetFontSize
              },
            }
          }
        '';
    };
  };
}
