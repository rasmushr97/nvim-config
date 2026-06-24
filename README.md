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

Use `# %%` markers for notebook-style cells, then initialize Molten with `<leader>mi` and run cells/lines/selections with `<leader>mc` / `<leader>ml` / visual `<leader>me`.

Commands are also available: `:NotebookInit`, `:NotebookRunCell`, and `:NotebookRunLine`.

`NotebookInit` uses the current project venv when one is active/detected. For uv projects, the project environment needs `ipykernel`:

```powershell
uv pip install --python .venv/Scripts/python.exe ipykernel
```

## Test

```powershell
pwsh ./scripts/test.ps1
```

## Update plugins

```powershell
pwsh ./scripts/sync.ps1
```
