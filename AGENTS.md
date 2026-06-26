# Agent instructions for this Neovim config

This is a LazyVim-based Neovim config optimized first for Python.

## Rules

- Keep the config small and boring.
- Prefer LazyVim extras before adding custom plugin specs.
- Keep custom plugin specs in `lua/plugins/`.
- Keep core config in `lua/config/`.
- For Python, prefer `basedpyright` for type checking and `ruff` for linting/formatting.
- After any config change, run `pwsh ./scripts/test.ps1` on Windows or `./scripts/test.sh` on Linux/macOS from the repo root.
- Do not commit broken startup, failed `Lazy! sync`, or failed health checks.

## Useful commands

```powershell
pwsh ./scripts/sync.ps1
pwsh ./scripts/check.ps1
pwsh ./scripts/test.ps1
```

```sh
./scripts/sync.sh
./scripts/check.sh
./scripts/test.sh
```
