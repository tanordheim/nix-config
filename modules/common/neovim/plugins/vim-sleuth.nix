{
      pkgs,
      lib,
      config,
      ...
    }:
    {
      
        programs.nixvim.plugins.sleuth = {
          enable = true;
        };
      
    }
