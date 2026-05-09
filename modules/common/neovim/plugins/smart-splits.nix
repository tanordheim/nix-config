{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
      settings = {
        at_edge = "wrap";
        multiplexer_integration = "tmux";
      };
    };

    keymaps = [
      {
        key = "<C-h>";
        mode = "n";
        action.__raw = "function() require('smart-splits').move_cursor_left() end";
        options.desc = "Move cursor to left split/pane";
      }
      {
        key = "<C-j>";
        mode = "n";
        action.__raw = "function() require('smart-splits').move_cursor_down() end";
        options.desc = "Move cursor to lower split/pane";
      }
      {
        key = "<C-k>";
        mode = "n";
        action.__raw = "function() require('smart-splits').move_cursor_up() end";
        options.desc = "Move cursor to upper split/pane";
      }
      {
        key = "<C-l>";
        mode = "n";
        action.__raw = "function() require('smart-splits').move_cursor_right() end";
        options.desc = "Move cursor to right split/pane";
      }
      {
        key = "<C-Left>";
        mode = "n";
        action.__raw = "function() require('smart-splits').resize_left() end";
        options.desc = "Resize split left";
      }
      {
        key = "<C-Down>";
        mode = "n";
        action.__raw = "function() require('smart-splits').resize_down() end";
        options.desc = "Resize split down";
      }
      {
        key = "<C-Up>";
        mode = "n";
        action.__raw = "function() require('smart-splits').resize_up() end";
        options.desc = "Resize split up";
      }
      {
        key = "<C-Right>";
        mode = "n";
        action.__raw = "function() require('smart-splits').resize_right() end";
        options.desc = "Resize split right";
      }
    ];
  };
}
