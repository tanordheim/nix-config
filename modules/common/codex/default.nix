{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Keep the prose below in sync with `claudeMd` in modules/common/claude/default.nix.
  # This is the Codex-adapted copy (drops the Claude-only memories and AskUserQuestion lines).
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

  baseConfig = {
    approval_policy = "on-request";
    sandbox_mode = "workspace-write";
    reasoning_effort = "high";

    features.hooks = true;

    agents.max_threads = 20;

    tui.status_line = [
      "model-with-reasoning"
      "current-dir"
      "git-branch"
      "context-used"
      "five-hour-limit"
      "weekly-limit"
    ];
  };

  # MCP servers are declared via the home-manager `codex.mcpServers` option (so the
  # private flake's HM module can add servers, mirroring claude.mcpServers), but rendered
  # into the read-only /etc system config layer — ~/.codex/config.toml must stay writable
  # for codex to persist its own settings there.
  mcpServers = lib.foldl' (acc: hm: acc // hm.codex.mcpServers) { } (
    lib.attrValues config.home-manager.users
  );
in
{
  environment.etc."codex/config.toml".source = (pkgs.formats.toml { }).generate "codex-config.toml" (
    baseConfig // { mcp_servers = mcpServers; }
  );

  home-manager.sharedModules = [
    (
      {
        lib,
        pkgs,
        ...
      }:
      {
        options.codex.mcpServers = lib.mkOption {
          type = lib.types.attrsOf lib.types.attrs;
          default = { };
        };

        config = {
          codex.mcpServers.codegraph = {
            command = "${pkgs.codegraph}/bin/codegraph";
            args = [
              "serve"
              "--mcp"
            ];
          };

          home.packages = [ pkgs.codex ];
          home.file.".codex/AGENTS.md".text = agentsMd;
          home.file.".codex/herdr-agent-state.sh".source =
            "${inputs.herdr}/src/integration/assets/codex/herdr-agent-state.sh";
          home.file.".codex/hooks.json".text = builtins.toJSON {
            hooks.SessionStart = [
              {
                hooks = [
                  {
                    type = "command";
                    command = ''bash "$HOME/.codex/herdr-agent-state.sh" session'';
                    timeout = 10;
                  }
                ];
              }
            ];
          };
        };
      }
    )
  ];
}
