{ pkgs, config, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      capabilities = # lua
        ''
          capabilities = require('blink.cmp').get_lsp_capabilities()
        '';
      onAttach = # lua
        ''
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>uh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = 'Toggle inlay hints' })

            -- enable inlay hints by default
            vim.lsp.inlay_hint.enable()
          end
        '';
    };

    plugins.inc-rename = {
      enable = true;
      settings.input_buffer_type = "snacks";
    };

    plugins.lspsaga = {
      enable = true;
      settings.lightbulb.enable = false;
    };

    keymaps = [
      {
        key = "gd";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_definitions()
            end
          '';
        options.desc = "[G]oto [D]efinition";
      }
      {
        key = "gD";
        mode = "n";
        action = "<cmd>Lspsaga peek_definition<CR>";
        options.desc = "Peek definition";
      }
      {
        key = "gi";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_implementations()
            end
          '';
        options.desc = "[G]oto [I]mplementation";
      }
      {
        key = "gr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_references()
            end
          '';
        options.desc = "[G]oto [R]eferences";
      }
      {
        key = "<leader>ss";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_symbols()
            end
          '';
        options.desc = "[S]ymbols in document";
      }
      {
        key = "<leader>sS";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_workspace_symbols()
            end
          '';
        options.desc = "[S]ymbols in workspace";
      }
      {
        key = "<C-k>";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              vim.lsp.buf.signature_help()
            end
          '';
        options.desc = "Signature help";
      }
      {
        key = "<leader>rn";
        mode = "n";
        action.__raw = ''
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end
        '';
        options = {
          desc = "[R]e[n]ame";
          expr = true;
        };
      }
      {
        key = "<leader>ca";
        mode = [
          "n"
          "v"
        ];
        action = "<cmd>Lspsaga code_action<CR>";
        options.desc = "[C]ode [A]ction";
      }
      {
        key = "[d";
        mode = [
          "n"
        ];
        action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      }
      {
        key = "]d";
        mode = [
          "n"
        ];
        action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
        options.desc = "Goto next diagnostic";
      }
    ];
  };
}
