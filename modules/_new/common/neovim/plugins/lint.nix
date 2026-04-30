{ lib, config, ... }:
    {
      
        programs.nixvim = {
          plugins.lint = {
            enable = true;
          };
        };
      
    }
