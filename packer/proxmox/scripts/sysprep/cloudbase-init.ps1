# install Cloudbase-Init
mkdir "c:\setup"
Write-Output "Copy CloudbaseInitSetup_1_1_5_x64.msi"
copy-item "G:\sysprep\CloudbaseInitSetup_1_1_5_x64.msi" "c:\setup\CloudbaseInitSetup_1_1_5_x64.msi" -force

Write-Output "Start process CloudbaseInitSetup_1_1_5_x64.msi"
start-process -FilePath 'c:\setup\CloudbaseInitSetup_1_1_5_x64.msi' -ArgumentList '/qn /l*v C:\setup\cloud-init.log' -Wait