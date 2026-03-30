{
  pkgs,
  config,
  lib,
  ...
}:
let
  skillsDir = ./skills;
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)

    MODEL=$(echo "$input" | jq -r '.model.display_name')
    PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
    DIR=$(echo "$input" | jq -r '.workspace.current_dir')

    BAR_WIDTH=10
    FILLED=$((PCT * BAR_WIDTH / 100))
    EMPTY=$((BAR_WIDTH - FILLED))
    BAR=""
    [ "$FILLED" -gt 0 ] && printf -v FILL "%''${FILLED}s" && BAR="''${FILL// /▓}"
    [ "$EMPTY" -gt 0 ] && printf -v PAD "%''${EMPTY}s" && BAR="''${BAR}''${PAD// /░}"

    CONTEXT="[$BAR] ''${PCT}%"

    if [ -n "$DIR" ] && git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
        printf "%s   %s    %s" "$MODEL" "$CONTEXT" "$BRANCH"
    else
        printf "%s   %s" "$MODEL" "$CONTEXT"
    fi
  '';

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
        [
          { ".claude/skills".source = skillsDir; }
        ]
        ++ map mkInstanceFiles config.claude.instances
      );
    };
  };
}
