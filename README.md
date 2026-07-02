# Neovim config

LazyVim-based Neovim setup with Python defaults and Rust tools.

## Python defaults

- LazyVim Python extra enabled
- `basedpyright` LSP
- `ruff` LSP/linting
- `ruff_format` and `ruff_organize_imports` on save through conform.nvim
- `debugpy` for Python debugging

## Rust defaults

- LazyVim Rust extra enabled
- `rust-analyzer` LSP installed through Mason
- `codelldb` debugger installed through Mason

## Notebook-style Python

Iron.nvim is installed for sending regular Python files to a right-side Python/IPython REPL.

Use `# %%` comments as cell markers:

```python
# %%
x = 1
x + 2
```

Keymaps:

- `<leader>pi` opens the Python REPL
- `<leader>pc` sends the current `# %%` cell or paragraph to the REPL
- visual `<leader>pc` sends the selection to the REPL
- `<leader>pl` sends the current line
- `<leader>pr` restarts the REPL

For richer interactive output, add IPython and configure Plotly to open in the browser:

```sh
uv add --dev ipython
```

```python
import plotly.io as pio
pio.renderers.default = "browser"
```

## Setup

Linux/macOS:

```sh
./scripts/setup.sh
```

This links `zellij/config.kdl` to `~/.config/zellij/config.kdl` if no Zellij config already exists, then installs `ripgrep` and JetBrains Mono Nerd Font. After running it, set your terminal font to `JetBrainsMono Nerd Font Mono` so Neovim icons render correctly.

## Zellij

The repo-managed Zellij config lives at `zellij/config.kdl`.

If `~/.config/zellij/config.kdl` already exists, `./scripts/setup.sh` leaves it unchanged. To use the repo config manually:

```sh
mkdir -p ~/.config/zellij
ln -s "$PWD/zellij/config.kdl" ~/.config/zellij/config.kdl
```

## Test

Linux/macOS:

```sh
./scripts/test.sh
```

Windows PowerShell:

```powershell
pwsh ./scripts/test.ps1
```

## Update plugins

Linux/macOS:

```sh
./scripts/sync.sh
```

Windows PowerShell:

```powershell
pwsh ./scripts/sync.ps1
```
