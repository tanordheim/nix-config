{ pkgs, config, ... }:
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        explorer = {
          enabled = true;
          replace_netrw = true;
          ignored = true;
          exclude = [
            ".git"
            ".venv"
            "node_modules"
          ];
        };
        input.enabled = true;
        lazygit.enabled = true;
        notifier.enabled = false;
        picker = {
          enabled = true;
        };
        statuscolumn.enabled = true;
      };
    };

    keymaps = [
      {
        key = "<leader>x";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete()<CR>";
        options.desc = "Close current buffer";
      }
      {
        key = "<leader>X";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete.other()<CR>";
        options.desc = "Close all buffers except current";
      }
      {
        key = "<leader>rN";
        mode = "n";
        action = "<cmd>lua Snacks.rename.rename_file()<CR>";
        options.desc = "[R]e[n]ame file with Snacks";
      }
      {
        key = "<leader>gg";
        mode = "n";
        action = "<cmd>lua Snacks.lazygit.open()<CR>";
        options.desc = "Open LazyGit";
      }
      {
        key = "<S-T>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.explorer({ hidden = true })
            end
          '';
        options.desc = "Show tree";
      }
      {
        key = "<leader><space>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.smart({ hidden = true })
            end
          '';
        options.desc = "Smart file picker (recent + buffers + files)";
      }
      {
        key = "<leader>sf";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.files({ hidden = true })
            end
          '';
        options.desc = "[S]earch [f]iles";
      }
      {
        key = "<leader>sh";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.keymaps()
            end
          '';
        options.desc = "[S]earch [k]eymaps";
      }
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep_word()
            end
          '';
        options.desc = "[S]earch for current [w]ord";
      }
      {
        key = "<leader>sg";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep()
            end
          '';
        options.desc = "[S]earch with [g]rep";
      }
      {
        key = "<leader>sr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.resume()
            end
          '';
        options.desc = "[R]esume current [s]earch";
      }
      {
        key = "<leader>s.";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.recent()
            end
          '';
        options.desc = "[S]earch recent files";
      }
      {
        key = "<leader>st";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.todo_comments()
            end
          '';
        options.desc = "[S]earch [t]odo comments";
      }
      {
        key = "<leader>sd";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.diagnostics()
            end
          '';
        options.desc = "[S]earch [d]iagnostics";
      }
      {
        key = "<leader>sD";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.diagnostics_buffer()
            end
          '';
        options.desc = "[S]earch [d]iagnostics in buffer";
      }
      {
        key = "<leader>sb";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.buffers()
            end
          '';
        options.desc = "[S]earch [b]uffers";
      }
    ];
  };
}
