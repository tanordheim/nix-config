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
        [
          { ".claude/skills".source = skillsDir; }
          {
            "Library/Application Support/ClaudeCode/managed-settings.json".text = builtins.toJSON {
              statusLine = {
                type = "command";
                command = "$HOME/.claude/statusline.sh";
              };
            };
          }
          {
            ".claude/statusline.sh" = {
              executable = true;
              text = ''
                #!/usr/bin/env bash

                input=$(cat)

                MODEL=$(echo "$input" | jq -r '.model.display_name')
                DIR=$(echo "$input" | jq -r '.workspace.current_dir')

                RAW_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
                if [ -n "$RAW_PCT" ]; then
                    PCT=$(printf "%.0f" "$RAW_PCT")
                else
                    PCT=""
                fi

                BAR_WIDTH=10
                if [ -n "$PCT" ]; then
                    FILLED=$((PCT * BAR_WIDTH / 100))
                    EMPTY=$((BAR_WIDTH - FILLED))
                    BAR=""
                    [ "$FILLED" -gt 0 ] && printf -v FILL "%''${FILLED}s" && BAR="''${FILL// /▓}"
                    [ "$EMPTY" -gt 0 ] && printf -v PAD "%''${EMPTY}s" && BAR="''${BAR}''${PAD// /░}"
                    CONTEXT="[$BAR] ''${PCT}%"
                else
                    printf -v PAD "%''${BAR_WIDTH}s"
                    CONTEXT="[''${PAD// /░}] -"
                fi

                if [ -n "$DIR" ] && git -C "$DIR" --no-optional-locks rev-parse --git-dir > /dev/null 2>&1; then
                    BRANCH=$(git -C "$DIR" --no-optional-locks branch --show-current 2>/dev/null)
                    printf "%s   %s    %s" "$MODEL" "$CONTEXT" "$BRANCH"
                else
                    printf "%s   %s" "$MODEL" "$CONTEXT"
                fi
              '';
            };
          }
        ]
        ++ map mkInstanceFiles config.claude.instances
      );
    };
  };
}
