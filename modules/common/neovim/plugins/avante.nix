{ config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim.plugins.avante = {
    enable = true;
    settings = {
      provider = "openai";
      openai = {
        endpoint = "https://api.openai.com/v1";
        model = "o1-mini";
        timeout = 30000;
        temperature = 0;
        max_tokens = 4096;
        reasoning_effort = "high";
      };
    };
  };
}
