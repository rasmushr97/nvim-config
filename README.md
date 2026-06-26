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
