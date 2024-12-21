{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = # lua
          ''
            -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#sorting-files-naturally-respecting-numbers-within-files-names
            local function natural_cmp(left, right)
              -- Directories before files
              if left.type == "directory" and right.type ~= "directory" then
                return true
              elseif left.type ~= "directory" and right.type == "directory" then
                return false
              end

              left = left.name:lower()
              right = right.name:lower()

              if left == right then
                return false
              end

              for i = 1, math.max(string.len(left), string.len(right)), 1 do
                local l = string.sub(left, i, -1)
                local r = string.sub(right, i, -1)

                if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
                  local l_number = tonumber(string.match(l, "^[0-9]+"))
                  local r_number = tonumber(string.match(r, "^[0-9]+"))

                  if l_number ~= r_number then
                    return l_number < r_number
                  end
                elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
                  return l < r
                end
              end
            end

            require('nvim-tree').setup {
              view = {
                width = 45,
              },
              trash = {
                cmd = "rm -rf",
              },
              renderer = {
                add_trailing = true,
                group_empty = true,
              },
              update_focused_file = {
                enable = true,
              },
              sort_by = function(nodes)
                table.sort(nodes, natural_cmp)
              end,
              filters = {
                git_ignored = false,
              },
            }

            vim.keymap.set('n', '<S-T>', function()
              require("nvim-tree.api").tree.toggle {
                find_file = true,
              }
            end, { desc = 'Show tree' })

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
      }
    ];
  };
}
