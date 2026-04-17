$ErrorActionPreference = "Stop"

# This script fails fast if the icon file is not a valid ICO.
# rsrc reports "bad magic number" when the input is not a real ICO file.

param(
    [string]$IconPath = "public_html/images/app-icon.ico",
    [string]$OutputPath = "zz_chicha_icon_windows_amd64.syso"
)

function Test-IcoHeader {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (-not (Test-Path -LiteralPath $FilePath)) {
        throw "Icon file not found: $FilePath"
    }

    $bytes = [System.IO.File]::ReadAllBytes($FilePath)
    if ($bytes.Length -lt 4) {
        throw "Icon file is too small to be a valid ICO: $FilePath"
    }

    # ICO header starts with: 00 00 01 00
    $isIco =
        $bytes[0] -eq 0 -and
        $bytes[1] -eq 0 -and
        $bytes[2] -eq 1 -and
        $bytes[3] -eq 0

    return $isIco
}

go install github.com/akavel/rsrc@latest

$rsrcBin = Join-Path (go env GOPATH) "bin/rsrc.exe"
if (-not (Test-Path -LiteralPath $rsrcBin)) {
    throw "rsrc binary not found after installation: $rsrcBin"
}

if (-not (Test-IcoHeader -FilePath $IconPath)) {
    throw "Invalid ICO header in '$IconPath'. Convert your source image to a real .ico before running rsrc."
}

& $rsrcBin -ico $IconPath -arch amd64 -o $OutputPath

Write-Host "Generated Windows resource file: $OutputPath"
