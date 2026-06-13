# Clean up phantom 0-byte read-only dotfiles left in the project dir by Claude
# Code's bwrap sandbox (anthropics/claude-code#17258). Guarded to the phantom
# signature only — regular file + empty + non-writable (0444) — so real
# .mcp.json / .gitconfig / .vscode dirs are never touched.
cwd=$(jq -r '.cwd // empty' 2>/dev/null || true)
[ -z "${cwd:-}" ] && cwd="$PWD"
cd "$cwd" 2>/dev/null || exit 0

for f in .bash_profile .bashrc .gitconfig .gitmodules .idea .mcp.json \
         .profile .ripgreprc .vscode .zprofile .zshrc; do
  if [ -f "$f" ] && [ ! -s "$f" ] && [ ! -w "$f" ]; then
    rm -f "$f" || true
  fi
done
