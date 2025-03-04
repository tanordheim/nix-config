{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.codecompanion = {
    enable = true;
    settings = {
      strategies = {
        chat = {
          adapter = "anthropic";
        };
        inline = {
          adapter = "anthropic";
        };
        agent = {
          adapter = "anthropic";
        };
      };
    };
  };
}
