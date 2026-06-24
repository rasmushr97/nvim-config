# Neovim config

LazyVim-based Neovim setup with Python defaults.

## Python defaults

- LazyVim Python extra enabled
- `basedpyright` LSP
- `ruff` LSP/linting
- `ruff_format` and `ruff_organize_imports` on save through conform.nvim
- `debugpy` for Python debugging

## Notebook-style Python

Molten.nvim is installed for Jupyter-kernel execution from regular Python files.

Initialize Molten with `<leader>mi` / `:MoltenInit`, then run code with native Molten commands:

- `<leader>ml` / `:MoltenEvaluateLine` runs the current line
- visual `<leader>me` / `:MoltenEvaluateVisual` runs a selection
- `<leader>me` / `:MoltenEvaluateOperator` runs an operator range
- `<leader>mc` creates a Molten cell from the current `# %%` section, paragraph, or visual selection
- `<leader>mr` / `:MoltenReevaluateCell` reruns the active Molten cell

For uv projects, install and register an ipykernel in the project environment, then choose that kernel in `:MoltenInit`:

```powershell
uv add --dev ipykernel
uv run python -m ipykernel install --user --name my-project --display-name "Python (my-project)"
```

## Test

```powershell
pwsh ./scripts/test.ps1
```

## Update plugins

```powershell
pwsh ./scripts/sync.ps1
```
