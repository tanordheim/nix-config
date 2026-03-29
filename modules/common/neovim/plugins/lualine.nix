{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.lualine = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };

    settings = {
      options = {
        theme = "catppuccin";
        globalstatus = true;
        section_separators = {
          left.__raw = "'\\xEE\\x82\\xB0'";
          right.__raw = "'\\xEE\\x82\\xB2'";
        };
        component_separators = {
          left = "";
          right = "";
        };
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          {
            "__unkeyed-1" = "diff";
            source.__raw = ''
              function()
                local gs = vim.b.gitsigns_status_dict
                if gs then
                  return { added = gs.added, modified = gs.changed, removed = gs.removed }
                end
              end
            '';
          }
        ];
        lualine_c = [
          {
            "__unkeyed-1" = "filename";
            file_status = true;
            newfile_status = true;
            path = 0;
          }
        ];
        lualine_x = [
          {
            "__unkeyed-1" = "diagnostics";
            sources = [ "nvim_lsp" ];
          }
          {
            "__unkeyed-1".__raw = ''
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then return "" end
                local names = {}
                for _, c in ipairs(clients) do
                  table.insert(names, c.name)
                end
                return " " .. table.concat(names, ", ")
              end
            '';
          }
        ];
        lualine_y = [ "filetype" ];
        lualine_z = [
          "location"
          "progress"
        ];
      };
    };
  };
}
