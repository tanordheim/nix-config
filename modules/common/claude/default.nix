{
  pkgs,
  config,
  lib,
  ...
}:
let
  skillsDir = ./skills;

  claudeMd = ''
    In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.

    ## PR Comments

    <pr-comment-rule>
    When I say to add a comment to a PR with a TODO on it, use the GitHub `checkbox` markdown format to add the TODO. For instance:

    <example>
    - [ ] A description of the todo goes here
    </example>
    </pr-comment-rule>

    When tagging Claude in GitHub issues, use `@claude`.

    ## GitHub

    - Your primary method for interacting with GitHub should be the `gh` CLI.

    ## Git

    - When creating branches, prefix them with `trond/` to indicate they came from me.

    ## Plans

    - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.
  '';

  mkClaudeFiles = prefix: {
    "${prefix}/skills".source = skillsDir;
    "${prefix}/CLAUDE.md".text = claudeMd;
  };

  mkInstanceFiles = instance: mkClaudeFiles ".claude-${instance.name}";

  mkInstancePackage =
    instance:
    pkgs.writeShellScriptBin "claude-${instance.name}" ''
      exec env CLAUDE_CONFIG_DIR="$HOME/.claude-${instance.name}" claude "$@"
    '';

  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)

    MODEL=$(echo "$input" | jq -r '.model.display_name')
    PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
    DIR=$(echo "$input" | jq -r '.workspace.current_dir')
    BASEDIR=$(basename "$DIR")

    BAR_WIDTH=10
    FILLED=$((PCT * BAR_WIDTH / 100))
    EMPTY=$((BAR_WIDTH - FILLED))
    BAR=""
    [ "$FILLED" -gt 0 ] && printf -v FILL "%''${FILLED}s" && BAR="''${FILL// /▓}"
    [ "$EMPTY" -gt 0 ] && printf -v PAD "%''${EMPTY}s" && BAR="''${BAR}''${PAD// /░}"

    CONTEXT="[$BAR] ''${PCT}%"

    if [ -n "$DIR" ] && git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
        printf "[%s] |  %s |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$BRANCH" "$CONTEXT"
    else
        printf "[%s] |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$CONTEXT"
    fi
  '';

  managedSettings = pkgs.writeText "claude-managed-settings" (
    builtins.toJSON {
      statusLine = {
        type = "command";
        command = "${statuslineScript}";
      };
      voiceEnabled = true;
    }
  );
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

  config = lib.mkMerge [
    {
      home-manager.users.${config.username} = {
        home.packages = [ pkgs.claude-code ] ++ map mkInstancePackage config.claude.instances;
        home.file = lib.mkMerge (
          [
            (mkClaudeFiles ".claude")
          ]
          ++ map mkInstanceFiles config.claude.instances
        );
      };
    }
    (lib.mkIf pkgs.stdenv.isDarwin {
      homebrew.casks = [
        "claude"
      ];

      system.activationScripts.postActivation.text = lib.mkAfter ''
        echo "setting up Claude Code managed settings..."
        mkdir -p "/Library/Application Support/ClaudeCode"
        ln -sf ${managedSettings} "/Library/Application Support/ClaudeCode/managed-settings.json"
      '';
    })
  ];
}
