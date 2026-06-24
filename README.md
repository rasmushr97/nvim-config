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

Initialize Molten with `<leader>mi`. This treats `# %%` comments as cell markers and defines all cells in the file, so plain Python percent-cell files from other people work without any local saved state. Then run code with:

- `<leader>ml` / `:MoltenEvaluateLine` runs the current line
- visual `<leader>me` / `:MoltenEvaluateVisual` runs a selection
- `<leader>me` / `:MoltenEvaluateOperator` runs an operator range
- `<leader>mc` creates and runs a Molten cell from the current `# %%` section, paragraph, or visual selection
- `<leader>pt` opens a right-side Python terminal using the project Python/uv venv
- `<leader>pc` sends the current `# %%` section, paragraph, or visual selection to that terminal
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
