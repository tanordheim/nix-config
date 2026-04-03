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

  keybindings = builtins.toJSON {
    "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
    "$docs" = "https://code.claude.com/docs/en/keybindings";
    "bindings" = [
      {
        context = "Chat";
        bindings = {
          "ctrl+alt+e" = "voice:pushToTalk";
        };
      }
    ];
  };

  mkClaudeFiles = prefix: {
    "${prefix}/skills".source = skillsDir;
    "${prefix}/CLAUDE.md".text = claudeMd;
    "${prefix}/keybindings.json".text = keybindings;
  };

  mkInstanceFiles = instance: mkClaudeFiles ".claude-${instance.name}";

  unwrappedClaude = pkgs.bleeding.claude-code;

  mkInstanceAwareClaudeWrapper =
    instances:
    let
      matchBlock = lib.concatMapStrings (instance: ''
        root=$(echo ${lib.escapeShellArg instance.rootDir} | sed 's|^~|'"$HOME"'|')
        len=''${#root}
        if ([[ "$cwd" == "$root" ]] || [[ "$cwd" == "$root/"* ]]) && [ "$len" -gt "$best_len" ]; then
          best_match=${lib.escapeShellArg instance.name}
          best_len=$len
        fi
      '') instances;
    in
    pkgs.writeShellScriptBin "claude" ''
      cwd="$PWD"
      best_match=""
      best_len=0
      ${matchBlock}
      if [ -n "$best_match" ]; then
        export CLAUDE_CONFIG_DIR="$HOME/.claude-$best_match"
      fi
      exec ${unwrappedClaude}/bin/claude "$@"
    '';

  mkInstancePackage =
    instance:
    pkgs.writeShellScriptBin "claude-${instance.name}" ''
      exec env CLAUDE_CONFIG_DIR="$HOME/.claude-${instance.name}" ${unwrappedClaude}/bin/claude "$@"
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
        printf "[%s] |  %s |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$BRANCH" "$CONTEXT"
    else
        printf "[%s] |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$CONTEXT"
    fi
  '';

  managedSettings = pkgs.writeText "claude-managed-settings" (
    builtins.toJSON {
      permissions.allow = [
        # Web
        "WebFetch"
        "WebSearch"

        # Git
        "Bash(git status)"
        "Bash(git log *)"
        "Bash(git diff *)"
        "Bash(git show *)"
        "Bash(git branch *)"
        "Bash(git checkout *)"
        "Bash(git switch *)"
        "Bash(git add *)"
        "Bash(git commit *)"
        "Bash(git stash *)"
        "Bash(git rev-parse *)"
        "Bash(git fetch *)"
        "Bash(git blame *)"
        "Bash(git shortlog *)"
        "Bash(git tag *)"
        "Bash(git ls-files *)"
        "Bash(git config *)"

        # GitHub CLI
        "Bash(gh pr list *)"
        "Bash(gh pr view *)"
        "Bash(gh pr diff *)"
        "Bash(gh pr checks *)"
        "Bash(gh issue list *)"
        "Bash(gh issue view *)"
        "Bash(gh api *)"
        "Bash(gh search *)"
        "Bash(gh run *)"
        "Bash(gh repo view *)"

        # Linear CLI
        "Bash(linear issue *)"
        "Bash(linear project list *)"
        "Bash(linear project view *)"

        # Nix
        "Bash(nix *)"
        "Bash(nixfmt *)"

        # Misc utilities
        "Bash(chmod *)"
        "Bash(openssl rand *)"
      ];
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
        options.rootDir = lib.mkOption {
          type = lib.types.str;
        };
      }
    );
    default = [ ];
  };

  config = lib.mkMerge [
    {
      home-manager.users.${config.username} = {
        home.packages = [
          (mkInstanceAwareClaudeWrapper config.claude.instances)
        ]
        ++ map mkInstancePackage config.claude.instances;
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
