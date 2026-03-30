{
  pkgs,
  config,
  lib,
  ...
}:
let
  skillsDir = ./skills;

  mkInstanceFiles = instance: {
    ".claude-${instance.name}/skills".source = skillsDir;
  };

  mkInstancePackage =
    instance:
    pkgs.writeShellScriptBin "claude-${instance.name}" ''
      exec env CLAUDE_CONFIG_DIR="$HOME/.claude-${instance.name}" claude "$@"
    '';
in
{
  options.claude.instances = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options.name = lib.mkOption {
          type = lib.types.str;
        };
      }
    );
    default = [ ];
  };

  config = {
    home-manager.users.${config.username} = {
      home.packages = [ pkgs.claude-code ] ++ map mkInstancePackage config.claude.instances;
      home.file = lib.mkMerge (
        [ { ".claude/skills".source = skillsDir; } ] ++ map mkInstanceFiles config.claude.instances
      );
    };
  };
}
