{
  lib,
  isDarwin,
  pkgs,
  ...
}:
let
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)

    mkbar() {
        local pct=$1 width=10 filled empty bar="" fill pad
        filled=$((pct * width / 100))
        empty=$((width - filled))
        [ "$filled" -gt 0 ] && printf -v fill "%''${filled}s" && bar="''${fill// /▓}"
        [ "$empty" -gt 0 ] && printf -v pad "%''${empty}s" && bar="''${bar}''${pad// /░}"
        printf '%s' "$bar"
    }

    MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name')
    PCT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
    USED=$(echo "$input" | ${pkgs.jq}/bin/jq -r '((.context_window.total_input_tokens // 0) / 10 | round) / 100 | tostring | . + "k"')
    DIR=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir // empty')
    BASEDIR=''${DIR:+$(basename "$DIR")}
    BASEDIR=''${BASEDIR:-?}

    CONTEXT="[$(mkbar "$PCT")] ''${PCT}% (''${USED})"

    if [ -n "$DIR" ] && ${pkgs.git}/bin/git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(${pkgs.git}/bin/git -C "$DIR" branch --show-current 2>/dev/null)
        GIT_DIR=$(${pkgs.git}/bin/git -C "$DIR" rev-parse --git-dir 2>/dev/null)
        COMMON_DIR=$(${pkgs.git}/bin/git -C "$DIR" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
        REPO=$(basename "$(dirname "$COMMON_DIR")")
        case "$GIT_DIR" in
            */worktrees/*)
                WT=$(basename "$GIT_DIR")
                printf "[%s] | 󰉋 %s | 󰘬 %s (󰙅 %s) | 󱙺 %s" "$MODEL" "$REPO" "$BRANCH" "$WT" "$CONTEXT" ;;
            *)
                printf "[%s] | 󰉋 %s | 󰘬 %s | 󱙺 %s" "$MODEL" "$REPO" "$BRANCH" "$CONTEXT" ;;
        esac
    else
        printf "[%s] | 󰉋 %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$CONTEXT"
    fi

    FIVE_PCT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.used_percentage // empty' | cut -d. -f1)
    FIVE_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.resets_at // empty')
    WEEK_PCT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.used_percentage // empty' | cut -d. -f1)
    WEEK_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.resets_at // empty')

    if [ -n "$FIVE_PCT" ]; then
        RESET=""
        [ -n "$FIVE_RESET" ] && RESET=" · resets $(${pkgs.coreutils}/bin/date -d @"$FIVE_RESET" +'%H:%M')"
        printf "\n󱑂 session [%s] %s%%%s" "$(mkbar "$FIVE_PCT")" "$FIVE_PCT" "$RESET"
    fi
    if [ -n "$WEEK_PCT" ]; then
        RESET=""
        [ -n "$WEEK_RESET" ] && RESET=" · resets $(${pkgs.coreutils}/bin/date -d @"$WEEK_RESET" +'%a %H:%M')"
        printf "\n󰃭 weekly  [%s] %s%%%s" "$(mkbar "$WEEK_PCT")" "$WEEK_PCT" "$RESET"
    fi
  '';
in
{
  imports = [
    (lib.mkPlatformImport ./. isDarwin)
  ];

  _module.args.claudeManagedSettings = {
    statusLine = {
      type = "command";
      command = "${statuslineScript}";
      refreshInterval = 60;
    };
    sandbox = {
      enabled = true;
      autoAllowBashIfSandboxed = true;
      excludedCommands = [
        "git*"
        "uv run pytest*"
      ];
    };
  };

  home-manager.sharedModules = [
    (
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        claudeMd = ''
          Your human partner is Trond. When a skill or instruction refers to "Trond," that's me — the person in this session.

          ## Operating mode

          - Talk to me as a peer senior engineer, not an assistant.
          - Optimize for my time, not your thoroughness. Be direct, and terse.
          - Default to discussing, not doing: answer and propose, don't edit files or run mutating commands until I say go (e.g. "go ahead", "do it") or did earlier in the conversation.
          - Read-only investigation (read, search, eval/build checks) needs no approval. Auto mode isn't a license to start unprompted.

          ## Output

          - Answer first. Reasoning after, only if non-obvious. No preamble, no recap of my request.
          - No sycophancy or closing pleasantries. No "Great question!", "Excellent point!", "Sure", "Certainly", "You're absolutely right".
          - Surface disagreement directly. Do not soften, do not hedge with "it's worth noting".
          - Do not change a correct answer because I push back. Defend it or show me where it's wrong.
          - When something is a subjective preference, say so. Don't frame opinions as facts.
          - Keep responses concise. Every token should be purposeful.

          ## Git / GitHub

          - Your primary method for interacting with GitHub (issues, PRs, reviews, repos, content) should be the `gh` CLI. Its authenticated, never reach for curl or tools.
          - Conventional commits: type(scope): subject. Subject under 72 chars, imperative mood.
          - Keep commit descriptions extremely concise.
          - Name branches with conventional-commit-style prefix: `feat-`, `fix-`, `chore-`, `docs-`, `refactor-`, etc.
          - Stage files individually. Never `git add -A`/`git add .`.
          - Confirm before destructive/irreversible ops: `push --force`, `reset --hard`, branch/file deletion, `rm -rf`, amending pushed commits, or anything visible to others.
          - Never commit secrets, credentials, tokens, or PII.

          ## Planning / Questions

          - End every plan with a list of unresolved questions, if any.
          - When asked to ask me questions, ask one at a time. Do not move on until aligned on the current one.
          - Never use the AskUserQuestion tool when asking question, unless explicitly told to.
        '';

        keybindings = builtins.toJSON {
          "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
          "$docs" = "https://code.claude.com/docs/en/keybindings";
          "bindings" = [ ];
        };

        agentsFromDir =
          dir:
          lib.mapAttrs' (name: _: lib.nameValuePair name (dir + "/${name}")) (
            lib.filterAttrs (_: type: type == "regular") (builtins.readDir dir)
          );

        allAgents = lib.foldl' (acc: dir: acc // agentsFromDir dir) { } config.claude.extraAgentDirs;

        mkAgentFiles =
          prefix:
          lib.mapAttrs' (name: src: lib.nameValuePair "${prefix}/agents/${name}" { source = src; }) allAgents;

        worktreeCreateScript = pkgs.writeShellApplication {
          name = "claude-worktree-create";
          runtimeInputs = [
            pkgs.git
            pkgs.jq
            pkgs.gnugrep
            pkgs.codegraph
          ];
          text = builtins.readFile ./worktree-create.sh;
        };

        codeDirName = if isDarwin then "Code" else "code";

        codegraphAutoinitScript = pkgs.writeShellApplication {
          name = "codegraph-autoinit";
          runtimeInputs = [
            pkgs.codegraph
            pkgs.git
            pkgs.jq
          ];
          text = builtins.readFile ./codegraph-autoinit.sh;
        };

        sessionEndCleanupScript = pkgs.writeShellApplication {
          name = "claude-session-end-cleanup";
          runtimeInputs = [
            pkgs.jq
            pkgs.coreutils
          ];
          text = builtins.readFile ./session-end-cleanup.sh;
        };

        herdrAgentStateScript = pkgs.writeShellApplication {
          name = "herdr-agent-state";
          runtimeInputs = [ pkgs.python3 ];
          text = builtins.readFile ./herdr-agent-state.sh;
        };

        stopWipMarkerScript = pkgs.writeShellApplication {
          name = "claude-stop-wip-marker";
          runtimeInputs = [
            pkgs.jq
            pkgs.coreutils
          ];
          text = builtins.readFile ./stop-wip-marker.sh;
        };

        onePasswordAgentSocket =
          if isDarwin then
            "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "${config.home.homeDirectory}/.1password/agent.sock";

        extraCacheDirs = lib.optionals isDarwin [ "~/Library/Caches" ];

        baseSettings = {
          agentPushNotifEnabled = true;
          theme = "dark";
          skipAutoPermissionPrompt = true;
          enableAllProjectMcpServers = true;
          permissions.defaultMode = "auto";
          env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          env.CLAUDE_CODE_EFFORT_LEVEL = "high";
          sandbox.filesystem.allowWrite = [
            "~/.cache"
          ]
          ++ extraCacheDirs
          ++ config.claude.sandbox.allowWrite;
          sandbox.network.allowedDomains = [
            "api.github.com"
            "lfs.github.com"
            "proxy.golang.org"
            "registry.terraform.io"
          ];
          sandbox.network.enableWeakerNetworkIsolation = isDarwin;
          sandbox.network.allowAllUnixSockets = true;
          hooks.WorktreeCreate = [
            {
              hooks = [
                {
                  type = "command";
                  command = "${worktreeCreateScript}/bin/claude-worktree-create";
                }
              ];
            }
          ];
          hooks.SessionEnd = [
            {
              hooks = [
                {
                  type = "command";
                  command = "${sessionEndCleanupScript}/bin/claude-session-end-cleanup";
                }
              ];
            }
          ];
          hooks.SessionStart = [
            {
              matcher = "*";
              hooks = [
                {
                  type = "command";
                  command = "${herdrAgentStateScript}/bin/herdr-agent-state session";
                  timeout = 10;
                }
                {
                  type = "command";
                  command = "${codegraphAutoinitScript}/bin/codegraph-autoinit \"$HOME/${codeDirName}\"";
                  timeout = 10;
                }
              ];
            }
          ];
          hooks.Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = "${stopWipMarkerScript}/bin/claude-stop-wip-marker";
                }
              ];
            }
          ];
        };

        mkClaudeFiles =
          prefix: settings:
          mkAgentFiles prefix
          // {
            "${prefix}/CLAUDE.md".text = claudeMd;
            "${prefix}/keybindings.json".text = keybindings;
            "${prefix}/settings.json".text = builtins.toJSON settings;
          };

        mkInstanceSettings =
          instance:
          lib.recursiveUpdate baseSettings {
            sandbox.filesystem = {
              allowWrite =
                instance.rootDirs
                ++ [
                  "~/.cache"
                ]
                ++ extraCacheDirs
                ++ config.claude.sandbox.allowWrite;
              denyRead = [ "~" ];
              allowRead =
                instance.rootDirs
                ++ config.claude.pluginDirs
                ++ [
                  onePasswordAgentSocket
                  "~/.claude-${instance.name}"
                  "~/.cache"
                  "~/.config"
                  "~/.gitconfig"
                  "~/.local"
                  "~/.ssh/config"
                  "~/.ssh/known_hosts"
                ]
                ++ extraCacheDirs;
            };
          };

        instanceMcpServers = instance: config.claude.mcpServers // instance.mcpServers;

        mkInstanceFiles =
          instance:
          let
            mcpServers = instanceMcpServers instance;
          in
          mkClaudeFiles ".claude-${instance.name}" (mkInstanceSettings instance)
          // lib.optionalAttrs (mcpServers != { }) {
            ".claude-${instance.name}/mcp.json".text = builtins.toJSON {
              inherit mcpServers;
            };
          };

        unwrappedClaude = pkgs.bleeding.claude-code;

        pluginDirArgs = lib.concatMapStrings (dir: ''
          d=$(echo ${lib.escapeShellArg dir} | sed 's|^~|'"$HOME"'|')
          [ -d "$d" ] && plugin_args+=(--plugin-dir "$d")
        '') config.claude.pluginDirs;

        mkInstanceAwareClaudeWrapper =
          instances:
          let
            mkRootCheck = name: rootDir: ''
              root=$(echo ${lib.escapeShellArg rootDir} | sed 's|^~|'"$HOME"'|')
              len=''${#root}
              if ([[ "$cwd" == "$root" ]] || [[ "$cwd" == "$root/"* ]]) && [ "$len" -gt "$best_len" ]; then
                best_match=${lib.escapeShellArg name}
                best_len=$len
              fi
            '';
            matchBlock = lib.concatMapStrings (
              instance: lib.concatMapStrings (mkRootCheck instance.name) instance.rootDirs
            ) instances;
          in
          pkgs.writeShellScriptBin "claude" ''
            cwd="$PWD"
            best_match=""
            best_len=0
            ${matchBlock}
            mcp_args=()
            plugin_args=()
            ${pluginDirArgs}
            if [ -n "$best_match" ]; then
              export CLAUDE_CONFIG_DIR="$HOME/.claude-$best_match"
            fi
            config_dir="''${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
            if [ -f "$config_dir/mcp.json" ]; then
              mcp_args=(--mcp-config "$config_dir/mcp.json")
            fi
            exec ${unwrappedClaude}/bin/claude ''${mcp_args[@]+"''${mcp_args[@]}"} ''${plugin_args[@]+"''${plugin_args[@]}"} "$@"
          '';

        mkInstancePackage =
          instance:
          let
            mcpArgs = lib.optionalString (
              instanceMcpServers instance != { }
            ) ''--mcp-config "$HOME/.claude-${instance.name}/mcp.json" '';
          in
          pkgs.writeShellScriptBin "claude-${instance.name}" ''
            plugin_args=()
            ${pluginDirArgs}
            exec env CLAUDE_CONFIG_DIR="$HOME/.claude-${instance.name}" ${unwrappedClaude}/bin/claude ${mcpArgs}''${plugin_args[@]+"''${plugin_args[@]}"} "$@"
          '';
      in
      {
        options.claude.instances = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options.name = lib.mkOption { type = lib.types.str; };
              options.rootDirs = lib.mkOption { type = lib.types.listOf lib.types.str; };
              options.mcpServers = lib.mkOption {
                type = lib.types.attrsOf lib.types.attrs;
                default = { };
              };
            }
          );
          default = [ ];
        };

        options.claude.pluginDirs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        options.claude.extraAgentDirs = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
        };

        options.claude.mcpServers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        options.claude.sandbox.allowWrite = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        config = {
          claude.mcpServers.codegraph = {
            type = "stdio";
            command = "${pkgs.codegraph}/bin/codegraph";
            args = [
              "serve"
              "--mcp"
            ];
          };

          programs.git.ignores = [
            "**/.claude/settings.local.json"
            ".codegraph/"
          ];

          home.packages = [
            (mkInstanceAwareClaudeWrapper config.claude.instances)
            pkgs.codegraph
          ]
          ++ map mkInstancePackage config.claude.instances;

          home.file = lib.mkMerge (
            [ (mkClaudeFiles ".claude" baseSettings) ]
            ++ lib.optional (config.claude.mcpServers != { }) {
              ".claude/mcp.json".text = builtins.toJSON { mcpServers = config.claude.mcpServers; };
            }
            ++ map mkInstanceFiles config.claude.instances
          );
        };
      }
    )
  ];
}
