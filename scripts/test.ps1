$ErrorActionPreference = "Stop"

Write-Host "==> Checking Neovim startup"
nvim --headless +qa

Write-Host "==> Running checkhealth"
nvim --headless "+checkhealth" +qa

Write-Host "==> OK"
