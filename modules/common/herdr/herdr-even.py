#!/usr/bin/env python3
"""Evenly distribute the panes in a herdr tab (tmux `select-layout` analog).

Two modes:

  even   (default)  Keep the current split structure and directions, but
                    recompute every split ratio so each *leaf pane* ends up
                    with equal area. Uses only `layout.set_split_ratio`, so it
                    never creates, destroys, or moves a pane — purely resizes.

  tiled             Rebuild the tab as a balanced grid (alternating split
                    directions, all ratios 0.5), like tmux `select-layout
                    tiled`. Uses `layout.apply`, i.e. it re-lays-out the
                    existing panes into a new tree. More invasive.

By default it's a DRY RUN: it prints what it would do and changes nothing.
Pass --apply to actually do it.

Examples:
  herdr-even.py                     # dry-run, current tab, even mode
  herdr-even.py --apply             # even out the current tab
  herdr-even.py --tab wP:t1 --apply
  herdr-even.py --mode tiled --apply
"""
import argparse
import json
import math
import os
import socket
import sys

SOCK = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser(
    "~/.config/herdr/herdr.sock"
)


def call(method, params):
    """Send one NDJSON request, return the parsed `result` (or raise on error)."""
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.settimeout(5)
    s.connect(SOCK)
    req = {"id": "even-" + method, "method": method, "params": params}
    s.sendall((json.dumps(req) + "\n").encode())
    buf = b""
    while b"\n" not in buf:
        chunk = s.recv(65536)
        if not chunk:
            break
        buf += chunk
    s.close()
    msg = json.loads(buf.split(b"\n", 1)[0].decode())
    if "error" in msg:
        raise RuntimeError(f"{method} failed: {json.dumps(msg['error'])}")
    return msg["result"]


def leaf_count(node):
    if node["type"] == "pane":
        return 1
    return leaf_count(node["first"]) + leaf_count(node["second"])


def walk_splits(node, path, out):
    """Collect (path, node) for every split, path = list of bools from root.

    In herdr's set_split_ratio, `path` is a list of booleans walking the tree.
    We assume False = descend into `first`, True = descend into `second`.
    """
    if node["type"] != "split":
        return
    out.append((path, node))
    walk_splits(node["first"], path + [False], out)
    walk_splits(node["second"], path + [True], out)


def even_ratio(node):
    """Target ratio for a split so leaves are equal: leaves(first)/total."""
    a = leaf_count(node["first"])
    b = leaf_count(node["second"])
    return a / (a + b)


# ---- tiled: build a balanced binary tree over the existing pane ids ---------


def collect_panes(node, out):
    if node["type"] == "pane":
        out.append(node)
    else:
        collect_panes(node["first"], out)
        collect_panes(node["second"], out)


def build_balanced(panes, horizontal):
    """Balanced tree; split direction alternates each level for a grid look."""
    if len(panes) == 1:
        p = panes[0]
        leaf = {"type": "pane", "pane_id": p["pane_id"]}
        return leaf
    mid = math.ceil(len(panes) / 2)
    direction = "right" if horizontal else "down"
    return {
        "type": "split",
        "direction": direction,
        "ratio": mid / len(panes),
        "first": build_balanced(panes[:mid], not horizontal),
        "second": build_balanced(panes[mid:], not horizontal),
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tab", help="tab_id to operate on (default: $HERDR_TAB_ID, else current)")
    ap.add_argument("--mode", choices=["even", "tiled"], default="even")
    ap.add_argument("--apply", action="store_true", help="actually change the layout (default: dry-run)")
    args = ap.parse_args()

    tab = args.tab or os.environ.get("HERDR_TAB_ID")
    params = {}
    if tab:
        params["tab_id"] = tab
    exported = call("layout.export", params)
    lay = exported["layout"]
    tab_id = lay["tab_id"]
    root = lay["root"]
    n = leaf_count(root)
    print(f"tab {tab_id}: {n} pane(s), mode={args.mode}, {'APPLY' if args.apply else 'dry-run'}")

    if n < 2:
        print("nothing to do (need >= 2 panes)")
        return

    if args.mode == "even":
        splits = []
        walk_splits(root, [], splits)
        for path, node in splits:
            target = even_ratio(node)
            print(f"  split {node.get('id', '?')} path={path} "
                  f"{node['ratio']:.3f} -> {target:.3f}")
            if args.apply:
                call("layout.set_split_ratio",
                     {"tab_id": tab_id, "path": path, "ratio": target})
        if args.apply:
            print("done")
        else:
            print("(dry-run; pass --apply to set these ratios)")
    else:  # tiled
        panes = []
        collect_panes(root, panes)
        new_root = build_balanced(panes, horizontal=True)
        print("  new tree:")
        print(json.dumps(new_root, indent=2))
        if args.apply:
            call("layout.apply", {"tab_id": tab_id, "root": new_root})
            print("done")
        else:
            print("(dry-run; pass --apply to rebuild the tab with this tree)")


if __name__ == "__main__":
    try:
        main()
    except FileNotFoundError:
        sys.exit(f"herdr socket not found at {SOCK} (is the server running?)")
    except (RuntimeError, ConnectionError) as e:
        sys.exit(str(e))
