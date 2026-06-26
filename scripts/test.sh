#!/usr/bin/env sh
set -eu

echo "==> Checking Neovim startup"
nvim --headless +qa

echo "==> Running checkhealth"
nvim --headless "+checkhealth" +qa

echo "==> OK"
