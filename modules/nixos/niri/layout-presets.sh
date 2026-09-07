fail() {
  printf '%s\n' "$1" >&2
  notify-send --app-name=Niri 'Layout preset failed' "$1"
  exit 1
}

trap 'fail "Niri could not apply the layout preset."' ERR

case "${1-}" in
  1) offsets='[0,1]'; widths='[50,50]' ;;
  2) offsets='[0,1]'; widths='[66.666667,33.333333]' ;;
  3) offsets='[-1,0,1]'; widths='[25,50,25]' ;;
  *) fail 'Choose layout preset 1, 2, or 3.' ;;
esac

windows=$(niri msg --json windows)
if ! plan=$(jq -er --argjson offsets "$offsets" --argjson widths "$widths" '
  . as $windows
  | (map(select(.is_focused == true)) | first) as $focused
  | if $focused == null or $focused.is_floating or
       $focused.layout.pos_in_scrolling_layout == null then
      error("Focus a tiled window before applying a layout preset")
    else . end
  | $focused.layout.pos_in_scrolling_layout[0] as $column
  | [range(0; $widths | length) as $i
     | ([$windows[] | select(
         .workspace_id == $focused.workspace_id and
         .is_floating == false and
         .layout.pos_in_scrolling_layout != null and
         .layout.pos_in_scrolling_layout[0] == ($column + $offsets[$i])
       )] | first) as $neighbor
     | if $neighbor == null then
         error("The required neighboring columns are missing")
       else {id: $neighbor.id, width: $widths[$i]} end
    ] as $selected
  | {focused: $focused.id, column: $column, selected: $selected}
' <<< "$windows" 2>&1); then
  fail "$plan"
fi

focused=$(jq -r '.focused' <<< "$plan")
selected=$(jq -r '.selected[] | [.id, .width] | @tsv' <<< "$plan")
while IFS=$'\t' read -r id width; do
  niri msg action set-window-width --id "$id" "${width}%"
done <<< "$selected"

if [[ "$1" == 3 ]]; then
  niri msg action center-window --id "$focused"
else
  rightColumn=$(jq -r '.column + 1' <<< "$plan")
  trap 'niri msg action focus-window --id "$focused"' EXIT
  niri msg action focus-column "$rightColumn"
  niri msg action focus-window --id "$focused"
  trap - EXIT
fi
