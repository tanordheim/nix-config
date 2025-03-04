{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "claude";
        claude = {
          endpoint = "https://api.anthropic.com";
          model = "claude-3-7-sonnet";
          temperature = 0;
          max_tokens = 4096;
        };
        openai = {
          endpoint = "https://api.openai.com/v1";
          model = "gpt-4o";
          timeout = 30000;
          temperature = 0;
          max_tokens = 4096;
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      img-clip-nvim
    ];
  };
}
