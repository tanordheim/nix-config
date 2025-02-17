{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.avante = {
    enable = true;
    settings = {
      provider = "openai";
    };
  };
}
