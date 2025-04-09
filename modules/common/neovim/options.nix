{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraConfigLua = # lua
      ''
        -- Make line numbers default
        vim.opt.number = true
        -- You can also add relative line numbers, to help with jumping.
        --  Experiment for yourself to see if you like it!
        vim.opt.relativenumber = true

        -- Enable mouse mode, can be useful for resizing splits for example!
        vim.opt.mouse = 'a'

        -- Don't show the mode, since it's already in the status line
        vim.opt.showmode = false

        -- Sync clipboard between OS and Neovim.
        --  Schedule the setting after `UiEnter` because it can increase startup-time.
        --  Remove this option if you want your OS clipboard to remain independent.
        --  See `:help 'clipboard'`
        vim.schedule(function()
          vim.opt.clipboard = 'unnamedplus'
        end)

        -- Enable break indent
        vim.opt.breakindent = true

        -- Save undo history
        vim.opt.undofile = true

        -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
        vim.opt.ignorecase = true
        vim.opt.smartcase = true

        -- Keep signcolumn on by default
        vim.opt.signcolumn = 'yes'

        -- Decrease update time
        vim.opt.updatetime = 250

        -- Decrease mapped sequence wait time
        -- Displays which-key popup sooner
        vim.opt.timeoutlen = 300

        -- Configure how new splits should be opened
        vim.opt.splitright = true
        vim.opt.splitbelow = true

        -- Sets how neovim will display certain whitespace characters in the editor.
        --  See `:help 'list'`
        --  and `:help 'listchars'`
        vim.opt.list = true
        vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

        -- Preview substitutions live, as you type!
        vim.opt.inccommand = 'split'

        -- Show which line your cursor is on
        vim.opt.cursorline = true

        -- Minimal number of screen lines to keep above and below the cursor.
        vim.opt.scrolloff = 10

        -- enable undercurl
        vim.cmd([[let &t_Cs = "\e[4:3m"]])
        vim.cmd([[let &t_Ce = "\e[4:0m"]])

        -- neovide config
        if vim.g.neovide then
          vim.g.neovide_floating_blur_amount_x = 2.0
          vim.g.neovide_floating_blur_amount_y = 2.0
          vim.g.neovide_cursor_animation_length = 0.03
          vim.g.neovide_hide_mouse_when_typing = true
          vim.g.neovide_opacity = 0.8
          vim.g.neovide_padding_top = 2
          vim.g.neovide_padding_right = 2
          vim.g.neovide_padding_bottom = 2
          vim.g.neovide_padding_left = 2
        end
      '';
  };
}
