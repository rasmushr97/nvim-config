#!/usr/bin/env sh
set -eu

nvim --headless "+checkhealth" +qa
