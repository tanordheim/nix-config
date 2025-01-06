#!/usr/bin/env bash

set -e

sudo nixos-rebuild switch --impure --flake .
current=$(nixos-rebuild list-generations | grep current)
git commit -am "$current"
notify-send -e "NixOS Rebuilt OK" --icon=software-update-available
