# Downloads the Amazon Ember web fonts from AWS's public CDN into fonts/.
# Optional: fix.css falls back to loading them straight from the CDN, but a
# bundled copy loads faster and cannot be blocked by the console's CSP.

$ErrorActionPreference = 'Stop'
$base = 'https://a0.awsstatic.com/libra-css/fonts/amazon-ember'
$dest = Join-Path $PSScriptRoot 'fonts'
New-Item -ItemType Directory -Force $dest | Out-Null

foreach ($name in 'AmazonEmber_Lt.woff2', 'AmazonEmber_Rg.woff2', 'AmazonEmber_Bd.woff2') {
    Invoke-WebRequest -Uri "$base/$name" -OutFile (Join-Path $dest $name)
    Write-Host "Downloaded $name"
}
