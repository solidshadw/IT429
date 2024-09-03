# Set logfile and function for writing logfile
$logfile = "C:\Tools\red_log.log"
Function lwrite {
    Param ([string]$logstring)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logstring = "$timestamp $logstring"
    Add-Content $logfile -value $logstring
}

$stagingdir = "C:\Tools"

if (-not (Test-Path -Path $stagingdir)) {
    New-Item -ItemType Directory -Path $stagingdir
    Write-Host "Directory created: $stagingdir"
} else {
    Write-Host "Directory already exists: $stagingdir"
}

lwrite("Starting red.ps1")

# Download PurpleSharp
if (Test-Path -Path "C:\Tools") {
  lwrite("C:\Tools exists")
} else {
  lwrite("Creating C:\Tools")
  New-Item -Path "C:\Tools" -ItemType Directory
}

# Creating a Temp folder for Caldera's Payloads
if (Test-Path -Path "C:\Tools\Temp") {
  lwrite("C:\Tools\Temp exists")
} else {
  lwrite("Creating C:\Tools\Temp")
  New-Item -Path "C:\Tools\Temp" -ItemType Directory
}

# Turn off Defender realtime protection so tools can download properly
Set-MpPreference -DisableRealtimeMonitoring $true
# Set AV exclusion path so red team tools can run 
Set-MpPreference -ExclusionPath "C:\Tools" 

# Download PurpleSharp
$MaxAttempts = 5
$TimeoutSeconds = 30
$Attempt = 0

if (Test-Path -Path "C:\Tools\PurpleSharp.exe") {
  lwrite("C:\Tools\PurpleSharp.exe exists")
} else {
  while ($Attempt -lt $MaxAttempts) {
    $Attempt += 1
    lwrite("Attempt: $Attempt")
    try {
        Invoke-WebRequest -Uri "https://github.com/mvelazc0/PurpleSharp/releases/download/v1.3/PurpleSharp_x64.exe" -OutFile "C:\Tools\PurpleSharp.exe" -TimeoutSec $TimeoutSeconds
        lwrite("Successful")
        break
    } catch {
        if ($_.Exception.GetType().Name -eq "WebException" -and $_.Exception.Status -eq "Timeout") {
            lwrite("Connection timed out. Retrying...")
        } else {
            lwrite("An unexpected error occurred:")
            lwrite($_.Exception.Message)
            break
        }
    }
  }
  if ($Attempt -eq $MaxAttempts) {
    Write-Host "Reached maximum number of attempts. Continuing..."
  }
}

# Get atomic red team (ART)
lwrite("Downloading Atomic Red Team")
$MaxAttempts = 5
$TimeoutSeconds = 30
$Attempt = 0

if (Test-Path -Path "C:\Tools\atomic-red-team-master.zip") {
  lwrite("C:\Tools\atomic-red-team-master.zip exists")
} else {
  while ($Attempt -lt $MaxAttempts) {
    $Attempt += 1
    lwrite("Attempt: $Attempt")
    try {
        Invoke-WebRequest -Uri "https://github.com/redcanaryco/atomic-red-team/archive/refs/heads/master.zip" -OutFile "C:\Tools\atomic-red-team-master.zip" -TimeoutSec $TimeoutSeconds
        lwrite("Successful")
        break
    } catch {
        if ($_.Exception.GetType().Name -eq "WebException" -and $_.Exception.Status -eq "Timeout") {
            lwrite("Connection timed out. Retrying...")
        } else {
            lwrite("An unexpected error occurred:")
            lwrite($_.Exception.Message)
            break
        }
    }
  }
  if ($Attempt -eq $MaxAttempts) {
    Write-Host "Reached maximum number of attempts. Continuing..."
  }
}

if (Test-Path -Path "C:\Tools\atomic-red-team-master.zip") {
  lwrite("Expanding atomic red team zip archive")
  Expand-Archive -Force -LiteralPath 'C:\Tools\atomic-red-team-master.zip' -DestinationPath 'C:\Tools\atomic-red-team-master'
} else {
  lwrite("Something went wrong - atomic red team zip not found")
}

# Install invoke-atomicredteam Module
lwrite("Installing Module invoke-atomicredteam")
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name invoke-atomicredteam,powershell-yaml -Scope AllUsers -Force
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -getAtomics

# Install Mimikatz

# Define the URL for the latest Mimikatz release
$MimikatzUrl = "https://github.com/gentilkiwi/mimikatz/releases/latest/download/mimikatz_trunk.zip"
$MaxAttempts = 5
$TimeoutSeconds = 30
$Attempt = 0
$DownloadPath = "C:\Tools\mimikatz.zip"
$ExtractPath = "C:\Tools\mimikatz"

If (Test-Path -Path $DownloadPath) {
  lwrite("Mimikatz zip exists")
} else {
  while ($Attempt -lt $MaxAttempts) {
    $Attempt += 1
    lwrite("Attempt: $Attempt")
    try {
        Invoke-WebRequest -Uri $MimikatzUrl -OutFile $DownloadPath -TimeoutSec $TimeoutSeconds
        lwrite("Successful")
        break
    } catch {
        if ($_.Exception.GetType().Name -eq "WebException" -and $_.Exception.Status -eq "Timeout") {
            lwrite("Connection timed out. Retrying...")
        } else {
            lwrite("An unexpected error occurred:")
            lwrite($_.Exception.Message)
            break
        }
    }
  }
  if ($Attempt -eq $MaxAttempts) {
    Write-Host "Reached maximum number of attempts. Continuing..."
  }
}

if (Test-Path -Path $DownloadPath) {
  lwrite("Extracting Mimikatz...")
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::ExtractToDirectory($DownloadPath, $ExtractPath)
  lwrite("Mimikatz has been downloaded and extracted to $ExtractPath")
} else {
  lwrite("Something went wrong - Mimikatz zip not found")
}

# Clean up the downloaded zip file
Remove-Item $DownloadPath

lwrite("Mimikatz has been downloaded and extracted to $ExtractPath")


lwrite("End of red.ps1")