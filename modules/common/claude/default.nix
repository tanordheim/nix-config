{ lib, isDarwin, ... }:
{
  imports = [
    (lib.mkPlatformImport ./. isDarwin)
  ];

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

        skillNames = lib.attrNames (
          lib.filterAttrs (_: type: type == "directory") (builtins.readDir skillsDir)
        );

        mkSkillFiles =
          prefix:
          lib.listToAttrs (
            map (name: {
              name = "${prefix}/skills/${name}";
              value = {
                source = skillsDir + "/${name}";
              };
            }) skillNames
          );

        mkClaudeFiles =
          prefix:
          mkSkillFiles prefix
          // {
            "${prefix}/CLAUDE.md".text = claudeMd;
            "${prefix}/keybindings.json".text = keybindings;
          };

        mkInstanceFiles =
          instance:
          mkClaudeFiles ".claude-${instance.name}"
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

        config = {
          home.packages = [
            (mkInstanceAwareClaudeWrapper config.claude.instances)
          ]
          ++ map mkInstancePackage config.claude.instances;

          home.file = lib.mkMerge (
            [ (mkClaudeFiles ".claude") ] ++ map mkInstanceFiles config.claude.instances
          );
        };
      }
    )
  ];
}
