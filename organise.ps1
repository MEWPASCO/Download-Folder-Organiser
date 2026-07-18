# --- CONFIGURATION ---
$source = "$env:USERPROFILE\Downloads"

# Globally scoped so both the initial sort and the watcher can see it
$global:FileMap = @{
    "Images"             = @(".jpg",".jpeg",".png",".gif",".webp",".avif",".svg",".ico",".pdn",".bmp",".tiff",".psd",".ai")
    "Videos"             = @(".mp4",".mkv",".mov",".avi",".webm",".flv",".wmv")
    "Documents"          = @(".pdf",".docx",".xlsx",".txt",".yaml",".html",".yml",".pptx",".csv",".md",".pdfx")
    "Audio"              = @(".mp3",".wav",".flac",".aac",".ogg",".m4a",".wma")
    
    # Core system tools, installers, and archives
    "Installers"         = @(".exe",".msi",".zip",".rar",".7z",".bat",".msix",".iso",".tar",".gz",".tgz",".vhd",".vhdx")
    
    # 3D Printing, slicing, and CAD profiles
    "3D Print Downloads" = @(".stl",".3mf",".obj",".step",".gcode",".amf",".f3d",".step",".stp")
    
    # Scripts, web components, configuration payloads
    "Web and Coding"     = @(".json",".jsonc",".xml",".css",".scss",".js",".ts",".html",".php",".py",".cs",".unitypackage",".tf",".tfvars")
    
    # Mods, game patches, assemblies, binaries, and system tweaks
    "Gaming and Mods"    = @(".dll",".apk",".xapk",".patched",".bin",".dat",".pak",".reg",".cfg",".config",".ini",".log",".unity3d",".assets",".bundle",".wad",".jar")
    
    # Typography files
    "Fonts"              = @(".ttf",".otf",".woff",".woff2")
}

# --- FUNCTIONS ---
function Sort-Downloads {
    foreach ($folder in $global:FileMap.Keys) {
        $dest = Join-Path $source $folder
        if (-not (Test-Path $dest)) { 
            New-Item -ItemType Directory -Path $dest | Out-Null
        }
        Get-ChildItem -Path $source -File | Where-Object {
            $global:FileMap[$folder] -contains $_.Extension.ToLower()
        } | Move-Item -Destination $dest -Force
    }
}

# Helper to ensure browsers are done writing the file before moving it
function Test-FileReady ($filePath) {
    if (-not (Test-Path $filePath)) { return $false }
    try {
        $stream = [System.IO.File]::Open($filePath, 'Open', 'Write', 'None')
        $stream.Close()
        return $true
    } catch {
        return $false
    }
}

# --- INITIAL RUN ---
Clear-Host
Write-Host "Running initial cleanup..." -ForegroundColor Cyan
Sort-Downloads
Write-Host "Downloads sorted successfully!`n" -ForegroundColor Green

# --- WATCHER SETUP ---
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $source
$watcher.EnableRaisingEvents = $true

$action = {
    $file = $Event.SourceEventArgs.FullPath
    
    # Wait until the browser fully releases the file (up to 30 seconds)
    $retry = 0
    while (-not (Test-FileReady $file) -and $retry -lt 30) {
        Start-Sleep -Seconds 1
        $retry++
    }

    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $sourceDir = [System.IO.Path]::GetDirectoryName($file)

    foreach ($folder in $global:FileMap.Keys) {
        if ($global:FileMap[$folder] -contains $ext) {
            $dest = Join-Path $sourceDir $folder
            if (-not (Test-Path $dest)) { 
                New-Item -ItemType Directory -Path $dest | Out-Null
            }
            if (Test-Path $file) {
                Move-Item -Path $file -Destination $dest -Force
                Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Moved: $(Split-Path $file -Leaf) -> $folder" -ForegroundColor Yellow
            }
            break
        }
    }
}

# Reset any stale event subscribers to avoid duplicates on script restart
Get-EventSubscriber -SourceIdentifier "DownloadsWatcher" -ErrorAction SilentlyContinue | Unregister-Event
Register-ObjectEvent $watcher Created -SourceIdentifier "DownloadsWatcher" -Action $action | Out-Null

# --- LIVE CONSOLE LOOP ---
Write-Host "Watching Downloads folder... press Ctrl+C to stop." -ForegroundColor Magenta
while ($true) { 
    Start-Sleep -Seconds 1 
}
