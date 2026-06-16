# Stop hook enforcing the work-in-progress marker protocol. While a marker file
# for this session exists, block the stop and force the agent to continue;
# absent marker = clean stop. Skills own the marker lifecycle (touch at start of
# an autonomous span, remove at a genuine terminal state) — this hook only reads.
set -eu

input=$(cat 2>/dev/null || true)
session_id=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)

# Fail open: no session id, nothing we can scope to.
[ -n "${session_id:-}" ] || exit 0

dir="${TMPDIR:-/tmp}"
marker="$dir/work-in-progress-$session_id.marker"
retries="$dir/work-in-progress-$session_id.retries"

# Clean path: no marker, allow the stop. The default for every session that
# isn't running a marker-aware skill.
if [ ! -f "$marker" ]; then
  rm -f "$retries" 2>/dev/null || true
  exit 0
fi

count=0
[ -f "$retries" ] && count=$(cat "$retries" 2>/dev/null || echo 0)
case "$count" in
  ''|*[!0-9]*) count=0 ;;
esac

# Give up after 3 forced continues without the marker being cleared: stop
# blocking and allow the stop so a stuck loop surfaces instead of barking
# forever.
if [ "$count" -ge 3 ]; then
  rm -f "$retries" 2>/dev/null || true
  exit 0
fi

reason=$(cat "$marker" 2>/dev/null || true)
[ -n "${reason//[[:space:]]/}" ] || reason="A work-in-progress marker exists for this session — you have unfinished work. Continue until done, or remove the marker if the work is genuinely complete."

printf '%s' "$((count + 1))" >"$retries" 2>/dev/null || true

jq -nc --arg reason "$reason" '{decision: "block", reason: $reason}'
exit 0
