{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins = {
      avante = {
        enable = true;
        settings = {
          provider = "openai";
          openai = {
            endpoint = "https://api.openai.com/v1";
            model = "gpt-4o";
            timeout = 30000;
            temperature = 0;
            max_tokens = 4096;
            # reasoning_effort = "high";
          };
        };
      };

      # avante deps
      nui.enable = true;
      dressing.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
    ];
  };
}
