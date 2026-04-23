{
  flake.modules.darwin.claude-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
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
          permissions.allow = [
            "WebFetch"
            "WebSearch"

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

            "Bash(linear issue *)"
            "Bash(linear project list *)"
            "Bash(linear project view *)"

            "Bash(nix *)"
            "Bash(nixfmt *)"

            "Bash(chmod *)"
            "Bash(openssl rand *)"
          ];
          statusLine = {
            type = "command";
            command = "${statuslineScript}";
          };
        }
      );
    in
    {
      config = lib.mkIf config.host.features.claude-desktop.enable {
        homebrew.casks = [ "claude" ];

        system.activationScripts.postActivation.text = lib.mkAfter ''
          echo "setting up Claude Code managed settings..."
          mkdir -p "/Library/Application Support/ClaudeCode"
          ln -sf ${managedSettings} "/Library/Application Support/ClaudeCode/managed-settings.json"
        '';
      };
    };
}
