# Set logfile and function for writing logfile
$logfile = "C:\Tools\sysmon_log.log"
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

lwrite("Starting sysmon.ps1")

# Download Sysmon config xml
$object_url = "https://wazuh.com/resources/blog/emulation-of-attack-techniques-and-detection-with-wazuh/sysmonconfig.xml"
$outfile = "C:\Tools\sysmonconfig-export.xml"
$MaxAttempts = 5
$TimeoutSeconds = 30
$Attempt = 0
lwrite("Going to download Sysmon config from GitHub")
lwrite("object url: $object_url")

if (Test-Path -Path "C:\Tools\sysmonconfig-export.xml") {
  lwrite("Sysmon config exists")
} else {
  while ($Attempt -lt $MaxAttempts) {
    $Attempt += 1
    lwrite("Attempt: $Attempt")
    try {
        Invoke-WebRequest -Uri "$object_url" -OutFile $outfile -TimeoutSec $TimeoutSeconds 
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
# Finished Download of Sysmon config xml


# Download Sysmon zip 
$object_url = "https://download.sysinternals.com/files/Sysmon.zip"
$outfile = "C:\Tools\Sysmon.zip"
$MaxAttempts = 5
$TimeoutSeconds = 30
$Attempt = 0
lwrite("Going to download Sysmon zip from Sysinternals")
lwrite("object url: $object_url")

if (Test-Path -Path "C:\Tools\Sysmon.zip") {
  lwrite("Sysmon zip exists")
} else {
  while ($Attempt -lt $MaxAttempts) {
    $Attempt += 1
    lwrite("Attempt: $Attempt")
    try {
        Invoke-WebRequest -Uri "$object_url" -OutFile $outfile -TimeoutSec $TimeoutSeconds
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
# Finished Download of Sysmon zip

# Expand the Sysmon zip archive
if (Test-Path -Path "C:\Tools\Sysmon.zip") {
  lwrite("Expand the Sysmon zip file")
  Expand-Archive -Force -LiteralPath 'C:\Tools\Sysmon.zip' -DestinationPath 'C:\Tools\Sysmon' 
} else {
  lwrite("Something wrong - Sysmon zip file doesn't exist")
}

# Copy the Sysmon configuration for SwiftOnSecurity to destination Sysmon folder
lwrite("Copy the Sysmon configuration to destination Sysmon folder")
Copy-Item "C:\Tools\sysmonconfig-export.xml" -Destination "C:\Tools\Sysmon"

# Install Sysmon
lwrite("Install Sysmon")
C:\Tools\Sysmon\sysmon.exe -accepteula -i C:\Tools\Sysmon\sysmonconfig-export.xml

lwrite("End of sysmon.ps1")