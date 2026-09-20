import math
import subprocess
import sys

from niri_ipc import TiledWindow, notify_failure, query, tiled_windows


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
                    case _:
                        continue
            case _:
                continue
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
        notify_failure("Fill neighboring columns failed", error)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
