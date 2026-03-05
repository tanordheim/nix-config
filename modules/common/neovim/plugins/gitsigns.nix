{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };

      settings = {
        current_line_blame = false;
        numhl = true;
        linehl = false;
      };
    };

    keymaps = [
      {
        key = "]h";
        mode = "n";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              require('gitsigns').nav_hunk('next')
            end
          end
        '';
        options.desc = "Next git hunk";
      }
      {
        key = "[h";
        mode = "n";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              require('gitsigns').nav_hunk('prev')
            end
          end
        '';
        options.desc = "Previous git hunk";
      }
      {
        key = "<leader>gp";
        mode = "n";
        action.__raw = "function() require('gitsigns').preview_hunk() end";
        options.desc = "[P]review git hunk";
      }
      {
        key = "<leader>gd";
        mode = "n";
        action.__raw = "function() require('gitsigns').diffthis() end";
        options.desc = "[D]iff current file against HEAD";
      }
      {
        key = "<leader>gs";
        mode = [
          "n"
          "v"
        ];
        action.__raw = "function() require('gitsigns').stage_hunk() end";
        options.desc = "[S]tage hunk";
      }
      {
        key = "<leader>gu";
        mode = "n";
        action.__raw = "function() require('gitsigns').reset_hunk() end";
        options.desc = "[U]ndo / reset hunk";
      }
    ];
  };
}
