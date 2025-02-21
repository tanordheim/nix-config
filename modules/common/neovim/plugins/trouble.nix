{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.trouble = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>xx";
        mode = "n";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics";
      }
    ];
  };
}
