{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      view.width = {
        min = 30;
        max = -1;
      };
    };

    extraConfigLua = # lua
      ''
        -- handle snacks file renames
        local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
        vim.api.nvim_create_autocmd("User", {
          pattern = "NvimTreeSetup",
          callback = function()
            local events = require("nvim-tree.api").events
            events.subscribe(events.Event.NodeRenamed, function(data)
              if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                data = data
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
              end
            end)
          end,
        })
      '';

    keymaps = [
      {
        key = "<S-T>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("nvim-tree.api").tree.toggle {
                find_file = true,
              }
            end
          '';
        options.desc = "Show tree";
      }
    ];
  };
}
