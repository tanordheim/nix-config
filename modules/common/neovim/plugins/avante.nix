{ pkgs, config, ... }:
{
  home-manager.users.${config.username}.programs.nixvim = {
    plugins.avante = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };
      settings = {
        provider = "claude";
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com";
            model = "claude-3-5-sonnet-20241022";
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
          openai = {
            endpoint = "https://api.openai.com/v1";
            model = "gpt-4o";
            timeout = 30000;
            extra_request_body = {
              temperature = 0;
              max_tokens = 4096;
            };
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      img-clip-nvim
    ];
  };
}
