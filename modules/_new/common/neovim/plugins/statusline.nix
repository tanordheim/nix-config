{ lib, config, ... }:
    {
      
        programs.nixvim = {
          opts = {
            laststatus = 3;
            showmode = false;
          };

          extraConfigLua = ''
            local M = {}

            local mode_palette = {
              n = "blue", i = "green", v = "mauve", V = "mauve",
              ["\22"] = "mauve", s = "mauve", S = "mauve", ["\19"] = "mauve",
              c = "peach", r = "peach", ["!"] = "peach",
              R = "red", Rv = "red",
              t = "teal", nt = "teal",
            }

            local mode_letter = {
              n = "N", i = "I", v = "V", V = "V", ["\22"] = "V",
              s = "S", S = "S", ["\19"] = "S",
              c = "C", r = "P", ["!"] = "!",
              R = "R", Rv = "R",
              t = "T", nt = "T",
            }

            local fallback = {
              base = "#1e1e2e", mantle = "#181825", text = "#cdd6f4",
              surface0 = "#313244", surface1 = "#45475a",
              blue = "#89b4fa", green = "#a6e3a1", mauve = "#cba6f7",
              peach = "#fab387", red = "#f38ba8", teal = "#94e2d5",
              yellow = "#f9e2af",
            }

            local P = fallback

            local function refresh_palette()
              local ok, cp = pcall(require, "catppuccin.palettes")
              if ok then
                local p = cp.get_palette()
                if p and p.base then P = p end
              end
            end

            local function hex_rgb(hex)
              return tonumber(hex:sub(2,3),16), tonumber(hex:sub(4,5),16), tonumber(hex:sub(6,7),16)
            end

            local function blend(c1, c2, ratio)
              local r1,g1,b1 = hex_rgb(c1)
              local r2,g2,b2 = hex_rgb(c2)
              return string.format("#%02x%02x%02x",
                math.floor((1-ratio)*r1 + ratio*r2),
                math.floor((1-ratio)*g1 + ratio*g2),
                math.floor((1-ratio)*b1 + ratio*b2))
            end

            local function apply_mode_hl(mode)
              local color_name = mode_palette[mode] or "blue"
              local color = P[color_name] or fallback[color_name]
              local base = P.base or fallback.base
              local text = P.text or fallback.text
              local mid = blend(color, base, 0.78)
              local light = blend(color, text, 0.55)
              local endcap = blend(color, base, 0.92)

              vim.api.nvim_set_hl(0, "SlModeSolid", { fg = base, bg = color, bold = true })
              vim.api.nvim_set_hl(0, "SlModeLight", { fg = base, bg = light, bold = true })
              vim.api.nvim_set_hl(0, "SlModeMid",   { fg = text, bg = mid })
              vim.api.nvim_set_hl(0, "SlModeAccent",{ fg = color, bg = mid, bold = true })
              vim.api.nvim_set_hl(0, "SlEnd",       { fg = color, bg = endcap })
              vim.api.nvim_set_hl(0, "SlCap",       { fg = light, bg = "NONE" })
            end

            local function mode_block()
              local m = vim.fn.mode()
              return "%#SlModeLight# " .. (mode_letter[m] or m:upper()) .. " "
            end

            local function recording()
              local r = vim.fn.reg_recording()
              if r == "" then return "" end
              return "%#SlModeAccent# recording @" .. r .. " "
            end

            local function git_branch()
              local gs = vim.b.gitsigns_status_dict
              if not gs or not gs.head or gs.head == "" then return "" end
              return "%#SlModeMid#  " .. gs.head .. " "
            end

            local function devicon(name, ext)
              local ok, d = pcall(require, "nvim-web-devicons")
              if not ok then return "" end
              local icon = d.get_icon(name, ext, { default = true })
              return icon or ""
            end

            local function buffer_list()
              local bufs = {}
              for _, b in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[b].buflisted then table.insert(bufs, b) end
              end
              if #bufs == 0 then return "" end

              local cap = 6
              local cur = vim.api.nvim_get_current_buf()
              local cur_idx
              for i, b in ipairs(bufs) do
                if b == cur then cur_idx = i; break end
              end

              local s, e
              if #bufs <= cap then
                s, e = 1, #bufs
              elseif cur_idx then
                s = math.max(1, cur_idx - math.floor(cap/2))
                e = s + cap - 1
                if e > #bufs then e = #bufs; s = e - cap + 1 end
              else
                s, e = 1, cap
              end

              local parts = {}
              for i = s, e do
                local b = bufs[i]
                local path = vim.api.nvim_buf_get_name(b)
                local name = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")
                local stem = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t:r")
                local ext = vim.fn.fnamemodify(path, ":e")
                local icon = devicon(name, ext)
                local mod = vim.bo[b].modified and " ●" or ""
                local hl = (b == cur) and "SlModeSolid" or "SlModeMid"
                table.insert(parts, "%#" .. hl .. "# " .. icon .. " " .. stem .. mod .. " ")
              end
              local hidden = #bufs - (e - s + 1)
              if hidden > 0 then
                table.insert(parts, "%#SlModeAccent# +" .. hidden .. " ")
              end
              return table.concat(parts)
            end

            local function search_count()
              if vim.v.hlsearch == 0 then return "" end
              local ok, sc = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 50 })
              if not ok or not sc.total or sc.total == 0 then return "" end
              return "%#SlModeAccent# [" .. sc.current .. "/" .. sc.total .. "] "
            end

            local function selection_size()
              local m = vim.fn.mode()
              if m ~= "v" and m ~= "V" and m ~= "\22" then return "" end
              local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
              local wc = vim.fn.wordcount()
              local words = wc.visual_words or 0
              return "%#SlModeAccent# " .. lines .. "L " .. words .. "W "
            end

            local function filetype_block()
              local ft = vim.bo.filetype
              if ft == "" then return "" end
              local name = vim.fn.expand("%:t")
              local ext = vim.fn.expand("%:e")
              local icon = devicon(name, ext)
              if icon ~= "" then icon = icon .. " " end
              return "%#SlModeMid# " .. icon .. ft .. " "
            end

            local function lsp_block()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              local mark = (#clients > 0) and "✓" or "✗"
              return "%#SlModeMid# " .. mark .. " "
            end

            function M.render()
              return table.concat({
                "%#SlCap#",
                "\238\130\182",
                mode_block(),
                recording(),
                git_branch(),
                buffer_list(),
                "%#SlModeMid#%=",
                search_count(),
                selection_size(),
                filetype_block(),
                lsp_block(),
                "%#SlModeLight# %l:%c ",
                "%#SlCap#",
                "\238\130\180",
              })
            end

            _G.MyStatusline = M.render

            vim.opt.statusline = "%{%v:lua.MyStatusline()%}"

            local aug = vim.api.nvim_create_augroup("MyStatusline", { clear = true })

            local function refresh_all()
              refresh_palette()
              apply_mode_hl(vim.fn.mode())
            end

            vim.api.nvim_create_autocmd("ColorScheme", { group = aug, callback = refresh_all })
            vim.api.nvim_create_autocmd("ModeChanged", {
              group = aug,
              callback = function()
                apply_mode_hl(vim.fn.mode())
                vim.cmd("redrawstatus")
              end,
            })
            vim.api.nvim_create_autocmd({
              "WinEnter", "BufEnter", "BufWritePost",
              "LspAttach", "LspDetach", "DiagnosticChanged",
              "CmdlineLeave", "RecordingEnter", "RecordingLeave",
            }, { group = aug, command = "redrawstatus" })
            vim.api.nvim_create_autocmd("User", {
              group = aug, pattern = "GitSignsUpdate", command = "redrawstatus",
            })

            refresh_all()
          '';
        };
      
    }
