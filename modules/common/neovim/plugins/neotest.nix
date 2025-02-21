{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.neotest = {
      enable = true;
    };

    keymaps = [
      {
        key = "<leader>t";
        mode = "n";
        action = "";
        options.desc = "+test";
      }
      {
        key = "<leader>tt";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.run(vim.fn.expand("%"))
            end
          '';
        options.desc = "Run all tests in file";
      }
      {
        key = "<leader>tT";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.run(vim.uv.cwd())
            end
          '';
        options.desc = "Run all tests";
      }
      {
        key = "<leader>tr";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.run()
            end
          '';
        options.desc = "Run nearest tests";
      }
      {
        key = "<leader>tR";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.run({ strategy = "dap" })
            end
          '';
        options.desc = "Debug nearest tests";
      }
      {
        key = "<leader>tl";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.run_last()
            end
          '';
        options.desc = "Rerun last test";
      }
      {
        key = "<leader>ts";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").summary.toggle()
            end
          '';
        options.desc = "Toggle test summary";
      }
      {
        key = "<leader>to";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").output.open({ enter = true, auto_close = true })
            end
          '';
        options.desc = "Show test output";
      }
      {
        key = "<leader>tO";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").output_panel.toggle()
            end
          '';
        options.desc = "Toggle test output panel";
      }
      {
        key = "<leader>tS";
        mode = "n";
        action.__raw = # lua
          ''
            function()
              require("neotest").run.stop()
            end
          '';
        options.desc = "Stop currently running test";
      }
    ];
  };
}
