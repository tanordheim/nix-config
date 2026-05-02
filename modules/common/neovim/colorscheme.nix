{ lib, config, pkgs, ... }:
    {

        # stylix interferes a little with how I want neovim to look
        stylix.targets.nixvim.enable = false;

        programs.nixvim = {
          colorscheme = "base46-catppuccin";
          extraPlugins = [
            (pkgs.vimUtils.buildVimPlugin {
              pname = "base46";
              version = "v3.0-65cb8ea";
              src = pkgs.fetchFromGitHub {
                owner = "AvengeMedia";
                repo = "base46";
                rev = "65cb8ea00157a2808de594def4c70071255132cd";
                hash = "sha256-BlKW8BN4VBi4CQpwOjEjisFfuLbHBGRfA1Ll4De6IPM=";
              };
              nvimRequireCheck = [ "base46" ];
            })
          ];
          extraConfigLua = ''
            require("base46").setup({
              transparency = true,
            })
          '';
        };

    }
