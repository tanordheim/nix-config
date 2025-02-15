{ pkgs, config, ... }:
let
  snacks-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "snacks.nvim";
    version = "2.2.20";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "snacks.nvim";
      rev = "1491b543ef1d8a0eb29a6ebc35db4fb808dcb47f";
      hash = "sha256-DLbXRDBKGxe3JcgrqNp4FPJq/yKZZcGdOR6I9b3+YCo=";
    };
  };
in
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.snacks = {
      enable = true;
      package = snacks-nvim-plugin;
      settings = {
        explorer = {
          enabled = true;
          replace_netrw = true;
        };
        lazygit.enabled = true;
        notifier.enabled = true;
        picker = {
          enabled = true;
        };
        statuscolumn.enabled = true;
      };

    };

    extraConfigLua = # lua
      ''
        -- show lsp progress
        local progress = vim.defaulttable()
        vim.api.nvim_create_autocmd("LspProgress", {
          ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
          callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
            if not client or type(value) ~= "table" then
              return
            end
            local p = progress[client.id]

            for i = 1, #p + 1 do
              if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                  token = ev.data.params.token,
                  msg = ("[%3d%%] %s%s"):format(
                    value.kind == "end" and 100 or value.percentage or 100,
                    value.title or "",
                    value.message and (" **%s**"):format(value.message) or ""
                  ),
                  done = value.kind == "end",
                }
                break
              end
            end

            local msg = {} ---@type string[]
            progress[client.id] = vim.tbl_filter(function(v)
              return table.insert(msg, v.msg) or not v.done
            end, p)

            local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            vim.notify(table.concat(msg, "\n"), "info", {
              id = "lsp_progress",
              title = client.name,
              opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                  or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
              end,
            })
          end,
        })
      '';

    keymaps = [
      {
        key = "<leader>bd";
        mode = "n";
        action = "<cmd>lua Snacks.bufdelete()<CR>";
        options.desc = "[D]elete current [b]uffer";
      }
      {
        key = "<leader>nd";
        mode = "n";
        action = "<cmd>lua Snacks.notifier.hide()<CR>";
        options.desc = "[D]ismiss [n]otifications";
      }
      {
        key = "<leader>ns";
        mode = "n";
        action = "<cmd>lua Snacks.notifier.show_history()<CR>";
        options.desc = "[S]how [n]otification history";
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
              Snacks.explorer()
            end
          '';
        options.desc = "Show tree";
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
    ];
  };
}
