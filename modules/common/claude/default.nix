{
  lib,
  isDarwin,
  pkgs,
  ...
}:
let
  statuslineScript = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)

    MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name')
    PCT=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
    USED=$(echo "$input" | ${pkgs.jq}/bin/jq -r '((.context_window.total_input_tokens // 0) / 10 | round) / 100 | tostring | . + "k"')
    DIR=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir')
    BASEDIR=$(basename "$DIR")

    BAR_WIDTH=10
    FILLED=$((PCT * BAR_WIDTH / 100))
    EMPTY=$((BAR_WIDTH - FILLED))
    BAR=""
    [ "$FILLED" -gt 0 ] && printf -v FILL "%''${FILLED}s" && BAR="''${FILL// /▓}"
    [ "$EMPTY" -gt 0 ] && printf -v PAD "%''${EMPTY}s" && BAR="''${BAR}''${PAD// /░}"

    CONTEXT="[$BAR] ''${USED}"

    if [ -n "$DIR" ] && ${pkgs.git}/bin/git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(${pkgs.git}/bin/git -C "$DIR" branch --show-current 2>/dev/null)
        printf "[%s] |  %s |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$BRANCH" "$CONTEXT"
    else
        printf "[%s] |  %s | 󱙺 %s" "$MODEL" "$BASEDIR" "$CONTEXT"
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
    };
    sandbox = {
      enabled = true;
      autoAllowBashIfSandboxed = true;
      excludedCommands = [
        "nix"
        "git*"
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
          - When opening a Pull Request, or editing an existing one, don't wrap the text you are writing (like you would in the commit message itself); The GitHub PR page renderer will reflow this.

          ## Git

          - When creating branches, prefix them with `trond/` to indicate they came from me.

          ## Plans

          - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.

          ## Questions

          - When asked to ask me questions, ask one at a time. Do not move on until aligned on the current one.
        '';

        keybindings = builtins.toJSON {
          "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
          "$docs" = "https://code.claude.com/docs/en/keybindings";
          "bindings" = [ ];
        };

        skillsFromDir =
          dir:
          lib.mapAttrs' (name: _: lib.nameValuePair name (dir + "/${name}")) (
            lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
          );

        allSkills = lib.foldl' (acc: dir: acc // skillsFromDir dir) { } (
          [ skillsDir ] ++ config.claude.extraSkillDirs
        );

        mkSkillFiles =
          prefix:
          lib.mapAttrs' (name: src: lib.nameValuePair "${prefix}/skills/${name}" { source = src; }) allSkills;

        agentsFromDir =
          dir:
          lib.mapAttrs' (name: _: lib.nameValuePair name (dir + "/${name}")) (
            lib.filterAttrs (_: type: type == "regular") (builtins.readDir dir)
          );

        allAgents = lib.foldl' (acc: dir: acc // agentsFromDir dir) { } config.claude.extraAgentDirs;

        mkAgentFiles =
          prefix:
          lib.mapAttrs' (name: src: lib.nameValuePair "${prefix}/agents/${name}" { source = src; }) allAgents;

        onePasswordAgentSocket =
          if isDarwin then
            "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          else
            "${config.home.homeDirectory}/.1password/agent.sock";

        baseSettings = {
          agentPushNotifEnabled = true;
          theme = "dark";
          skipAutoPermissionPrompt = true;
          permissions.defaultMode = "auto";
          env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          env.CLAUDE_CODE_EFFORT_LEVEL = "xhigh";
          sandbox.filesystem.allowWrite = [
            "~/.cache"
          ];
          sandbox.network.allowedDomains = [
            "api.github.com"
            "lfs.github.com"
            "proxy.golang.org"
            "registry.terraform.io"
          ];
          sandbox.network.enableWeakerNetworkIsolation = isDarwin;
          sandbox.network.allowUnixSockets = [
            onePasswordAgentSocket
          ]
          ++ lib.optional (!isDarwin) "/var/run/docker.sock";
        };

        mkClaudeFiles =
          prefix: settings:
          mkSkillFiles prefix
          // mkAgentFiles prefix
          // {
            "${prefix}/CLAUDE.md".text = claudeMd;
            "${prefix}/keybindings.json".text = keybindings;
            "${prefix}/settings.json".text = builtins.toJSON settings;
          };

        mkInstanceSettings =
          instance:
          lib.recursiveUpdate baseSettings {
            sandbox.filesystem = {
              allowWrite = instance.rootDirs ++ [
                "~/.cache"
              ];
              denyRead = [ "~" ];
              allowRead = instance.rootDirs ++ [
                onePasswordAgentSocket
                "~/.claude-${instance.name}"
                "~/.cache"
                "~/.config"
                "~/.gitconfig"
                "~/.local"
                "~/.ssh/config"
                "~/.ssh/known_hosts"
              ];
            };
          };

        mkInstanceFiles =
          instance:
          mkClaudeFiles ".claude-${instance.name}" (mkInstanceSettings instance)
          // lib.optionalAttrs (instance.mcpServers != { }) {
            ".claude-${instance.name}/mcp.json".text = builtins.toJSON {
              mcpServers = instance.mcpServers;
            };
          };

        unwrappedClaude = pkgs.bleeding.claude-code;

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
            if [ -n "$best_match" ]; then
              export CLAUDE_CONFIG_DIR="$HOME/.claude-$best_match"
              if [ -f "$CLAUDE_CONFIG_DIR/mcp.json" ]; then
                mcp_args=(--mcp-config "$CLAUDE_CONFIG_DIR/mcp.json")
              fi
            fi
            exec ${unwrappedClaude}/bin/claude ''${mcp_args[@]+"''${mcp_args[@]}"} "$@"
          '';

        mkInstancePackage =
          instance:
          let
            mcpArgs = lib.optionalString (
              instance.mcpServers != { }
            ) ''--mcp-config "$HOME/.claude-${instance.name}/mcp.json" '';
          in
          pkgs.writeShellScriptBin "claude-${instance.name}" ''
            exec env CLAUDE_CONFIG_DIR="$HOME/.claude-${instance.name}" ${unwrappedClaude}/bin/claude ${mcpArgs}"$@"
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

        options.claude.extraSkillDirs = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
        };

        options.claude.extraAgentDirs = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
        };

        config = {
          home.packages = [
            (mkInstanceAwareClaudeWrapper config.claude.instances)
          ]
          ++ map mkInstancePackage config.claude.instances;

          home.file = lib.mkMerge (
            [ (mkClaudeFiles ".claude" baseSettings) ] ++ map mkInstanceFiles config.claude.instances
          );
        };
      }
    )
  ];
}
