{ pkgs, config, ... }:
let
  grpc-nvim-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "grpc-nvim";
    version = "2023-01-22";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "hudclark";
      repo = "grpc-nvim";
      rev = "cd235398a9922ae412f59ebeabb0b13957be0d39";
    };
  };
in
{
  home-manager.users.${config.username}.programs.nixvim = {
    extraPlugins = [
      grpc-nvim-plugin
    ];

    extraConfigLua = # lua
      ''
        -- todo
      '';
  };
}
