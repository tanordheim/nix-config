import math
import subprocess
import sys

from niri_ipc import notify_failure, query, tiled_windows


def focused_workspace() -> int:
    records = query("workspaces")
    if not isinstance(records, list):
        raise TypeError("Niri returned an invalid workspace list")
    for record in records:
        match record:
            case {"id": int() as identifier, "is_focused": True}:
                return identifier
            case {"id": int(), "is_focused": False}:
                continue
            case _:
                raise ValueError("Niri returned invalid workspace data")
    raise ValueError("Niri has no focused workspace")


def reset_widths(percent: float) -> None:
    workspace = focused_workspace()
    columns: dict[int, int] = {}
    for window in tiled_windows():
        if window.workspace == workspace:
            columns.setdefault(window.column, window.id)

    for identifier in columns.values():
        current = next(
            (window for window in tiled_windows() if window.id == identifier), None
        )
        if current is None or current.workspace != workspace:
            raise ValueError(
                "A target window moved or closed; stopped resetting widths"
            )
        subprocess.run(
            [
                "niri",
                "msg",
                "action",
                "set-window-width",
                "--id",
                str(identifier),
                f"{percent:g}%",
            ],
            check=True,
            capture_output=True,
            text=True,
        )


def main(args: list[str]) -> int:
    try:
        if len(args) != 1:
            raise ValueError("Expected the configured default column width percentage")
        percent = float(args[0])
        if not math.isfinite(percent) or percent <= 0:
            raise ValueError("The default width percentage must be finite and positive")
        reset_widths(percent)
    except (OSError, TypeError, ValueError, subprocess.CalledProcessError) as error:
        notify_failure("Reset column widths failed", error)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
