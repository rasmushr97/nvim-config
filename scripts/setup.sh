#!/usr/bin/env sh
set -eu

install_ripgrep() {
  if command -v rg >/dev/null 2>&1; then
    printf '%s\n' "==> ripgrep already installed"
    return
  fi

  printf '%s\n' "==> Installing ripgrep"

  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y ripgrep curl unzip fontconfig
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y ripgrep curl unzip fontconfig
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --needed ripgrep curl unzip fontconfig
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add ripgrep curl unzip fontconfig
  elif command -v brew >/dev/null 2>&1; then
    brew install ripgrep
  else
    printf '%s\n' "Could not find a supported package manager for ripgrep." >&2
    printf '%s\n' "Install ripgrep manually, then rerun this script." >&2
    exit 1
  fi
}

install_nerd_font() {
  font_family="JetBrainsMono Nerd Font"

  if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi "$font_family"; then
    printf '%s\n' "==> $font_family already installed"
    return
  fi

  if ! command -v curl >/dev/null 2>&1 || ! command -v unzip >/dev/null 2>&1; then
    printf '%s\n' "curl and unzip are required to install $font_family." >&2
    exit 1
  fi

  os_name="$(uname -s)"
  case "$os_name" in
    Darwin)
      font_dir="$HOME/Library/Fonts"
      ;;
    Linux)
      font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
      ;;
    *)
      printf '%s\n' "Unsupported OS for font installation: $os_name" >&2
      exit 1
      ;;
  esac

  printf '%s\n' "==> Installing $font_family to $font_dir"

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT INT TERM

  mkdir -p "$font_dir"
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    -o "$tmp_dir/JetBrainsMono.zip"
  unzip -oq "$tmp_dir/JetBrainsMono.zip" -d "$tmp_dir/JetBrainsMono"
  cp "$tmp_dir"/JetBrainsMono/*.ttf "$font_dir"/

  if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f "$font_dir"
  fi
}

link_zellij_config() {
  repo_root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
  config_src="$repo_root/zellij/config.kdl"
  config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zellij"
  config_dst="$config_dir/config.kdl"

  if [ ! -f "$config_src" ]; then
    printf '%s\n' "Zellij config not found: $config_src" >&2
    exit 1
  fi

  mkdir -p "$config_dir"

  if [ -L "$config_dst" ] && [ "$(readlink "$config_dst")" = "$config_src" ]; then
    printf '%s\n' "==> Zellij config already linked"
    return
  fi

  if [ -e "$config_dst" ] || [ -L "$config_dst" ]; then
    printf '%s\n' "==> Zellij config exists; leaving it unchanged: $config_dst"
    printf '%s\n' "    Link $config_src manually if you want this repo to manage it."
    return
  fi

  ln -s "$config_src" "$config_dst"
  printf '%s\n' "==> Linked Zellij config to $config_dst"
}

link_zellij_config
install_ripgrep
install_nerd_font

printf '%s\n' "==> OK"
printf '%s\n' "Set your terminal font to JetBrainsMono Nerd Font Mono to show Neovim icons."
