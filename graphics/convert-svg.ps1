# PowerShell script to convert SVG files to PDF
# Usage: .\convert-svg.ps1
# Optional: .\convert-svg.ps1 -Clean (to remove all PDF files)

param([switch]$Clean)

$graphicsDir = "..\graphics"
$outputDir = ".\gen"

# Handle clean operation first
if ($Clean) {
    Write-Host "Cleaning up PDF files..." -ForegroundColor Yellow
    Get-ChildItem -Path $outputDir -Filter "*.pdf" | Remove-Item -Force
    Write-Host "Cleanup complete." -ForegroundColor Green
    exit 0
}

# Get all SVG files from graphics directory
$svgFiles = Get-ChildItem -Path $graphicsDir -Filter "*.svg"

Write-Host "Found $($svgFiles.Count) SVG file(s) to convert" -ForegroundColor Cyan

# Check if Inkscape is available (common on Windows for SVG conversion)
$inkscapePath = $null
$possiblePaths = @(
    "C:\Program Files\Inkscape\bin\inkscape.exe",
    "C:\Program Files (x86)\Inkscape\bin\inkscape.exe",
    "$env:LOCALAPPDATA\Programs\Inkscape\bin\inkscape.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $inkscapePath = $path
        break
    }
}

# Try to find inkscape in PATH
if (-not $inkscapePath) {
    try {
        $inkscapePath = (Get-Command inkscape -ErrorAction Stop).Source
    } catch {
        # Inkscape not found
    }
}

# Check for rsvg-convert (less common on Windows but possible)
$rsvgPath = $null
try {
    $rsvgPath = (Get-Command rsvg-convert -ErrorAction Stop).Source
} catch {
    # rsvg-convert not found
}

if (-not $inkscapePath -and -not $rsvgPath) {
    Write-Host "`nERROR: Neither Inkscape nor rsvg-convert found!" -ForegroundColor Red
    Write-Host "`nPlease install one of the following:" -ForegroundColor Yellow
    Write-Host "  1. Inkscape (recommended for Windows): https://inkscape.org/release/" -ForegroundColor White
    Write-Host "  2. rsvg-convert via MSYS2/Cygwin" -ForegroundColor White
    Write-Host "`nAlternatively, you can:" -ForegroundColor Yellow
    Write-Host "  - Use WSL (Windows Subsystem for Linux) and run the original Makefile" -ForegroundColor White
    Write-Host "  - Convert files manually using an online tool" -ForegroundColor White
    exit 1
}

# Convert each SVG file
$converted = 0
$failed = 0

foreach ($svg in $svgFiles) {
    $pdfName = [System.IO.Path]::GetFileNameWithoutExtension($svg.Name) + ".pdf"
    $pdfPath = Join-Path $outputDir $pdfName
    
    Write-Host "Converting: $($svg.Name) -> $pdfName" -ForegroundColor Gray
    
    try {
        if ($inkscapePath) {
            # Inkscape command (newer versions use --export-filename)
            & $inkscapePath $svg.FullName --export-filename=$pdfPath --export-dpi=300 2>&1 | Out-Null
        } elseif ($rsvgPath) {
            # rsvg-convert command (same as Ubuntu Makefile)
            & $rsvgPath -f pdf -d 300 -p 300 -o $pdfPath $svg.FullName 2>&1 | Out-Null
        }
        
        if (Test-Path $pdfPath) {
            Write-Host "  [OK] Success: $pdfName" -ForegroundColor Green
            $converted++
        } else {
            Write-Host "  [FAIL] Failed: $pdfName (no output file created)" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "  [FAIL] Failed: $pdfName - $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Conversion complete!" -ForegroundColor Cyan
Write-Host "  Converted: $converted" -ForegroundColor Green
Write-Host "  Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
Write-Host "========================================" -ForegroundColor Cyan

