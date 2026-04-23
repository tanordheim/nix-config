{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = lib.mkIf config.host.features.neovim.enable {
        programs.nixvim = {
          extraPlugins = with pkgs.vimPlugins; [
            sidekick-nvim
          ];

          extraConfigLua = # lua
            ''
              require('sidekick').setup({
                nes = {
                  enabled = false,
                },
                cli = {
                  tools = {
                    claude = { cmd = { "claude" } },
                  },
                },
              })
            '';

          keymaps = [
            {
              key = "<leader>aa";
              mode = "n";
              action.__raw = # lua
                ''
                  function()
                    require("sidekick.cli").toggle({ name = "claude", focus = true })
                  end
                '';
              options.desc = "Toggle Claude Code panel";
            }
            {
              key = "<leader>ap";
              mode = [
                "n"
                "v"
              ];
              action.__raw = # lua
                ''
                  function()
                    require("sidekick.cli").send({ name = "claude" })
                  end
                '';
              options.desc = "Send prompt / selection to Claude";
            }
          ];
        };
      };
    };
}
