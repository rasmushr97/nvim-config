#!/usr/bin/env sh
set -eu

nvim --headless "+Lazy! sync" +qa
