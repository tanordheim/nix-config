{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.dap = {
      enable = true;
    };
    plugins.dap-ui = {
      enable = true;
    };
    plugins.dap-virtual-text = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>du";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dapui").toggle()
            end
          '';
        options.desc = "[d]ap [u]i";
      }
      {
        key = "<leader>dB";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end
          '';
        options.desc = "[d]ap [B]reakpoint with condition";
      }
      {
        key = "<leader>db";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").toggle_breakpoint()
            end
          '';
        options.desc = "[d]ap [b]reakpoint";
      }
      {
        key = "<leader>dc";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").continue()
            end
          '';
        options.desc = "[d]ap [r]un/continue";
      }
      {
        key = "<leader>da";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").continue({ before = get_args })
            end
          '';
        options.desc = "[d]ap run with [a]rgs";
      }
      {
        key = "<leader>dC";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").run_to_cursor()
            end
          '';
        options.desc = "[d]ap run to [C]ursor";
      }
      {
        key = "<leader>dg";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").goto_()
            end
          '';
        options.desc = "[d]ap [g]oto line (no execute)";
      }
      {
        key = "<leader>di";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").step_into()
            end
          '';
        options.desc = "[d]ap step [i]nto";
      }
      {
        key = "<leader>dj";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").down()
            end
          '';
        options.desc = "[d]ap down";
      }
      {
        key = "<leader>dk";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").up()
            end
          '';
        options.desc = "[d]ap up";
      }
      {
        key = "<leader>dl";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").run_last()
            end
          '';
        options.desc = "[d]ap run [l]ast";
      }
      {
        key = "<leader>do";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").step_out()
            end
          '';
        options.desc = "[d]ap step [o]ut";
      }
      {
        key = "<leader>dO";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").step_over()
            end
          '';
        options.desc = "[d]ap step [O]ver";
      }
      {
        key = "<leader>dP";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").pause()
            end
          '';
        options.desc = "[d]ap [P]ause";
      }
      {
        key = "<leader>dr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").repl.toggle()
            end
          '';
        options.desc = "[d]ap [r]epl";
      }
      {
        key = "<leader>ds";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").session()
            end
          '';
        options.desc = "[d]ap [s]ession";
      }
      {
        key = "<leader>dt";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap").terminate()
            end
          '';
        options.desc = "[d]ap [t]erminate";
      }
      {
        key = "<leader>dw";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("dap.ui.widgets").hover()
            end
          '';
        options.desc = "[d]ap [w]idgets";
      }
    ];
  };
}
