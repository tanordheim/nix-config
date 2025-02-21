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
    ];
  };
}
