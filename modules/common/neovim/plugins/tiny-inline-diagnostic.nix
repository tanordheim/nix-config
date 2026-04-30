{ lib, config, ... }:
    {
      
        programs.nixvim.plugins.tiny-inline-diagnostic = {
          enable = true;
          settings = {
            preset = "modern";
            multilines.enabled = false;
            options.show_source = {
              enabled = true;
              if_many = false;
            };
          };
        };
      
    }
