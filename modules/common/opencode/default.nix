{
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        # Keep this prose in sync with `agentsMd` in modules/common/codex/default.nix
        # and `claudeMd` in modules/common/claude/default.nix (the non-Claude copy).
        baseAgentsMd = ''
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
        '';

        unwrappedOpencode = pkgs.opencode;

        baseMcpServers = {
          codegraph = {
            type = "local";
            command = [
              "${pkgs.codegraph}/bin/codegraph"
              "serve"
              "--mcp"
            ];
            enabled = true;
          };
        };

        personal = {
          name = "personal";
          rootDirs = [ ];
          mcpServers = { };
          skillDirs = [ ];
          agentsMd = null;
          model = null;
        };

        allInstances = [ personal ] ++ config.opencode.instances;

        mkInstanceConfig =
          instance:
          let
            agentsMdFile = pkgs.writeText "opencode-agents-${instance.name}.md" (
              if instance.agentsMd != null then instance.agentsMd else baseAgentsMd
            );
            skillPaths = config.opencode.skillDirs ++ instance.skillDirs;
          in
          {
            "$schema" = "https://opencode.ai/config.json";
            model = if instance.model != null then instance.model else "openai/gpt-5.6-terra";
            permission = "allow";
            autoupdate = false;
            instructions = [ "${agentsMdFile}" ];
            mcp = config.opencode.mcpServers // baseMcpServers // instance.mcpServers;
          }
          // lib.optionalAttrs (skillPaths != [ ]) {
            skills.paths = skillPaths;
          }
          // lib.optionalAttrs (config.opencode.providers != { }) {
            provider = config.opencode.providers;
          };

        mkInstanceFiles = instance: {
          ".config/opencode-${instance.name}/opencode.json".text = builtins.toJSON (
            mkInstanceConfig instance
          );
          ".config/opencode-${instance.name}/plugin/herdr-agent-state.js".source =
            "${inputs.herdr}/src/integration/assets/opencode/herdr-agent-state.js";
        };

        mkInstanceBin =
          instance:
          pkgs.writeShellScriptBin "opencode-${instance.name}" ''
            exec env \
              OPENCODE_CONFIG_DIR="$HOME/.config/opencode-${instance.name}" \
              XDG_DATA_HOME="$HOME/.local/share/opencode-${instance.name}" \
              OPENCODE_DISABLE_CLAUDE_CODE=1 \
              OPENCODE_DISABLE_EXTERNAL_SKILLS=1 \
              ${unwrappedOpencode}/bin/opencode "$@"
          '';

        mkInstanceAwareOpencodeWrapper =
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
          pkgs.writeShellScriptBin "opencode" ''
            cwd="$PWD"
            best_match="personal"
            best_len=0
            ${matchBlock}
            exec env \
              OPENCODE_CONFIG_DIR="$HOME/.config/opencode-$best_match" \
              XDG_DATA_HOME="$HOME/.local/share/opencode-$best_match" \
              OPENCODE_DISABLE_CLAUDE_CODE=1 \
              OPENCODE_DISABLE_EXTERNAL_SKILLS=1 \
              ${unwrappedOpencode}/bin/opencode "$@"
          '';
      in
      {
        options.opencode.instances = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options.name = lib.mkOption { type = lib.types.str; };
              options.rootDirs = lib.mkOption { type = lib.types.listOf lib.types.str; };
              options.mcpServers = lib.mkOption {
                type = lib.types.attrsOf lib.types.attrs;
                default = { };
              };
              options.skillDirs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
              options.agentsMd = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              options.model = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            }
          );
          default = [ ];
        };

        options.opencode.mcpServers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        options.opencode.providers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        options.opencode.skillDirs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        config = {
          home.packages = [
            (mkInstanceAwareOpencodeWrapper config.opencode.instances)
          ]
          ++ map mkInstanceBin allInstances;

          home.file = lib.mkMerge (map mkInstanceFiles allInstances);
        };
      }
    )
  ];
}
