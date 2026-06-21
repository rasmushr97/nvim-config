# Neovim config

LazyVim-based Neovim setup with Python defaults.

## Python defaults

- LazyVim Python extra enabled
- `basedpyright` LSP
- `ruff` LSP/linting
- `ruff_format` and `ruff_organize_imports` on save through conform.nvim
- `debugpy` for Python debugging

## Test

```powershell
pwsh ./scripts/test.ps1
```

## Update plugins

```powershell
pwsh ./scripts/sync.ps1
```
