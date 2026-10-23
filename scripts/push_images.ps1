# =================================================================
# Urumi MCP Gateway - Docker Hub Image Tagging & Push Script (PowerShell)
# Usage: .\scripts\push_images.ps1 -Registry "<your_dockerhub_username>"
# =================================================================
param (
    [Parameter(Mandatory=$false)]
    [string]$Registry = "hiensenbergg"
)

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " Tagging and Pushing Urumi Platform Container Images" -ForegroundColor Cyan
Write-Host " Registry Target: $Registry" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

$images = @(
    @{ Local = "urumi/mcp-gateway:v1.6.7"; Repo = "mcp-gateway"; Tag = "v1.6.7" },
    @{ Local = "urumi/ai-service:v1.3.6"; Repo = "ai-service"; Tag = "v1.3.6" },
    @{ Local = "urumi/frontend:v1.0.0"; Repo = "frontend"; Tag = "v1.0.0" },
    @{ Local = "urumi/woocommerce-mcp:v1.1.0"; Repo = "woocommerce-mcp"; Tag = "v1.1.0" },
    @{ Local = "urumi/inventory-mcp:v1.1.1"; Repo = "inventory-mcp"; Tag = "v1.1.1" },
    @{ Local = "urumi/analytics-mcp:v1.1.0"; Repo = "analytics-mcp"; Tag = "v1.1.0" },
    @{ Local = "urumi/hosted-mcp:latest"; Repo = "hosted-mcp"; Tag = "latest" }
)

foreach ($item in $images) {
    $remoteTag = "$Registry/$($item.Repo):$($item.Tag)"
    $remoteLatest = "$Registry/$($item.Repo):latest"

    Write-Host "`nTagging: $($item.Local) -> $remoteTag" -ForegroundColor Yellow
    wsl docker tag $item.Local $remoteTag
    wsl docker tag $item.Local $remoteLatest

    Write-Host "Pushing: $remoteTag" -ForegroundColor Green
    wsl docker push $remoteTag
    wsl docker push $remoteLatest
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
Write-Host " Image Push Complete!" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
