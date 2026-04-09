{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.node;

  buildNpmConfig =
    npmRegistries:
    pkgs.writeText "npmrc" (
      lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${value.url}") npmRegistries)
    );

in
{
  options.node.npmRegistries = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          url = mkOption {
            type = types.str;
          };
        };
      }
    );
    default = { };
  };

  config = {
    home.packages = with pkgs; [
      nodejs
      pnpm
      yarn
    ];
    home.file.".npmrc".source = buildNpmConfig cfg.npmRegistries;
  };
}
