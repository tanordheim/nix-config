{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
        programs.nixvim.plugins.web-devicons = {
          enable = true;
          lazyLoad = {
            settings = {
              event = "DeferredUIEnter";
            };
          };
        };
      
    }
