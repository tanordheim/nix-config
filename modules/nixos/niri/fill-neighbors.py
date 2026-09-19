import json
import math
import subprocess
import sys
from dataclasses import dataclass

type Json = None | bool | int | float | str | list[Json] | dict[str, Json]


@dataclass(frozen=True)
class TiledWindow:
    id: int
    workspace: int
    column: int
    width: float
    focused: bool


def query(subject: str) -> Json:
    result = subprocess.run(
        ["niri", "msg", "--json", subject], check=True, capture_output=True, text=True
    )
    data: Json = json.loads(result.stdout)
    return data


def tiled_windows() -> list[TiledWindow]:
    records = query("windows")
    if not isinstance(records, list):
        raise TypeError("Niri returned an invalid window list")
    windows: list[TiledWindow] = []
    for record in records:
        match record:
            case {"is_floating": True} | {"layout": {"pos_in_scrolling_layout": None}}:
                continue
            case {
                "id": int() as identifier,
                "workspace_id": int() as workspace,
                "is_focused": bool() as focused,
                "is_floating": False,
                "layout": {
                    "pos_in_scrolling_layout": [int() as column, _],
                    "tile_size": [(int() | float()) as width, _],
                },
            }:
                windows.append(
                    TiledWindow(identifier, workspace, column, width, focused)
                )
            case _:
                raise ValueError("Niri returned invalid tiled window geometry")
    return windows


def output_width(workspace_id: int) -> float:
    workspaces = query("workspaces")
    outputs = query("outputs")
    if not isinstance(workspaces, list) or not isinstance(outputs, dict):
        raise TypeError("Niri returned invalid workspace or output data")
    for workspace in workspaces:
        match workspace:
            case {"id": int() as identifier, "output": str() as output} if (
                identifier == workspace_id
            ):
                match outputs.get(output):
                    case {"logical": {"width": int() as width}} if width > 0:
                        return width
    raise ValueError("The focused workspace has no usable output width")


def fill_neighbors(gaps: float) -> None:
    windows = tiled_windows()
    focused = next((window for window in windows if window.focused), None)
    if focused is None:
        raise ValueError("Focus a tiled window before resizing its neighbors")

    columns: dict[int, list[TiledWindow]] = {}
    for window in windows:
        if window.workspace == focused.workspace:
            columns.setdefault(window.column, []).append(window)

    focused_width = max(window.width for window in columns[focused.column])
    if not math.isfinite(focused_width) or focused_width <= 0:
        raise ValueError("The focused column has no usable width")
    workspace_width = output_width(focused.workspace)
    neighbor_width = (workspace_width - focused_width - 4 * gaps) / 2
    if neighbor_width <= 0:
        return
    percent = 100 * (neighbor_width + gaps) / (workspace_width - gaps)

    for column in (focused.column - 1, focused.column + 1):
        neighbors = columns.get(column)
        if neighbors:
            subprocess.run(
                [
                    "niri",
                    "msg",
                    "action",
                    "set-window-width",
                    "--id",
                    str(neighbors[0].id),
                    f"{percent}%",
                ],
                check=True,
            )


def main(args: list[str]) -> int:
    try:
        if len(args) != 1:
            raise ValueError("Expected the configured Niri gap size")
        gaps = float(args[0])
        if not math.isfinite(gaps) or gaps < 0:
            raise ValueError("The Niri gap size must be finite and nonnegative")
        fill_neighbors(gaps)
    except (OSError, TypeError, ValueError, subprocess.CalledProcessError) as error:
        message = str(error)
        if isinstance(error, subprocess.CalledProcessError) and error.stderr:
            message = error.stderr.strip()
        print(message, file=sys.stderr)
        subprocess.run(
            [
                "notify-send",
                "--app-name=Niri",
                "Fill neighboring columns failed",
                message,
            ],
            check=True,
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
