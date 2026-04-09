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

  config = {
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
