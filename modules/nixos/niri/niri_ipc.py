import json
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


def notify_failure(title: str, error: Exception) -> None:
    message = str(error)
    if isinstance(error, subprocess.CalledProcessError) and error.stderr:
        message = str(error.stderr).strip()
    print(message, file=sys.stderr)
    subprocess.run(
        ["notify-send", "--app-name=Niri", title, message],
        check=True,
    )
