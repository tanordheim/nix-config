{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPackages = with pkgs; [
      fd
      ripgrep
    ];

    plugins.telescope = {
      enable = true;
      extensions = {
        ui-select.enable = true;
        fzf-native.enable = true;
      };
    };

    keymaps = [
      {
        key = "<leader>sh";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').keymaps()
            end
          '';
        options.desc = "[S]earch [k]eymaps";
      }
      {
        key = "<leader>sw";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').grep_string()
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
              require('telescope.builtin').live_grep()
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
              require('telescope.builtin').resume()
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
              require('telescope.builtin').oldfiles()
            end
          '';
        options.desc = "[S]earch recent files";
      }
      {
        key = "<leader><leader>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require('telescope.builtin').oldfiles()
            end
          '';
        options.desc = "Find existing buffers";
      }
    ];
  };
}
