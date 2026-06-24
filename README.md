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

Use `# %%` markers for notebook-style cells, then initialize Molten with `<leader>mi` and run lines/selections with `<leader>ml` / visual `<leader>me`.

You still need a Python Jupyter kernel available in the environment you use, for example:

```powershell
uv pip install pynvim jupyter ipykernel
```

## Test

```powershell
pwsh ./scripts/test.ps1
```

## Update plugins

```powershell
pwsh ./scripts/sync.ps1
```
