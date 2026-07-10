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
        agentsMd = ''
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

        # MANUAL UPDATE CHECK: https://github.com/slkiser/opencode-quota/releases
        # Registered as both a server plugin (opencode.json) and a TUI plugin (tui.json).
        # Bump the version, rebuild, then clear the plugin cache to apply:
        # rm -rf ~/.cache/opencode/node_modules ~/.cache/opencode/bun.lock
        quotaPluginSpec = "@slkiser/opencode-quota@3.11.1";

        opencodeConfig = {
          "$schema" = "https://opencode.ai/config.json";
          model = "openai/gpt-5.6-terra";
          permission = "allow";
          autoupdate = false;
          plugin = [ quotaPluginSpec ];
          agent.plan.disable = true;
          mcp = config.opencode.mcpServers // baseMcpServers;
        }
        // lib.optionalAttrs (config.opencode.providers != { }) {
          provider = config.opencode.providers;
        };

        c = config.lib.stylix.colors.withHashtag;

        opencodeTheme = {
          theme = {
            primary = c.base0D;
            secondary = c.base0E;
            accent = c.base0C;
            error = c.base08;
            warning = c.base0A;
            success = c.base0B;
            info = c.base0D;
            text = c.base05;
            textMuted = c.base04;
            background = c.base00;
            backgroundPanel = c.base01;
            backgroundElement = c.base02;
            border = c.base03;
            borderActive = c.base0D;
            borderSubtle = c.base02;

            diffAdded = c.base0B;
            diffRemoved = c.base08;
            diffContext = c.base04;
            diffHunkHeader = c.base0C;
            diffHighlightAdded = c.base0B;
            diffHighlightRemoved = c.base08;
            diffLineNumber = c.base03;

            markdownText = c.base05;
            markdownHeading = c.base0E;
            markdownLink = c.base0D;
            markdownLinkText = c.base0C;
            markdownCode = c.base0B;
            markdownBlockQuote = c.base0A;
            markdownEmph = c.base0A;
            markdownStrong = c.base09;
            markdownHorizontalRule = c.base03;
            markdownListItem = c.base0D;
            markdownListEnumeration = c.base0C;
            markdownImage = c.base0D;
            markdownImageText = c.base0C;
            markdownCodeBlock = c.base05;

            syntaxComment = c.base03;
            syntaxKeyword = c.base0E;
            syntaxFunction = c.base0D;
            syntaxVariable = c.base08;
            syntaxString = c.base0B;
            syntaxNumber = c.base09;
            syntaxType = c.base0A;
            syntaxOperator = c.base0C;
            syntaxPunctuation = c.base05;
          };
        };

        opencodeConfigFile = pkgs.writeText "opencode.json" (builtins.toJSON opencodeConfig);

        opencodeWrapper = pkgs.writeShellScriptBin "opencode" ''
          exec env \
            OPENCODE_DISABLE_CLAUDE_CODE=1 \
            OPENCODE_DISABLE_EXTERNAL_SKILLS=1 \
            OPENCODE_CONFIG=${opencodeConfigFile} \
            ${pkgs.opencode}/bin/opencode "$@"
        '';
      in
      {
        options.opencode.mcpServers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        options.opencode.providers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        config = {
          home.packages = [ opencodeWrapper ];

          home.file = {
            ".config/opencode/tui.json".text = builtins.toJSON {
              "$schema" = "https://opencode.ai/tui.json";
              theme = "stylix";
              plugin = [ quotaPluginSpec ];
            };
            ".config/opencode/themes/stylix.json".text = builtins.toJSON opencodeTheme;
            ".config/opencode/opencode-quota/quota-toast.json".text = builtins.toJSON {
              enableToast = false;
              tuiSidebarPanel = {
                enabled = true;
              };
            };
            ".config/opencode/AGENTS.md".text = agentsMd;
            ".config/opencode/plugin/herdr-agent-state.js".source =
              "${inputs.herdr}/src/integration/assets/opencode/herdr-agent-state.js";
          };
        };
      }
    )
  ];
}
