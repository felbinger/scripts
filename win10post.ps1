# post installation script for Windows 10

<#
TODO:
* Taskbar Links
* Explorer Favorites
#>

# should the script remove it traces? (e.g. C:\temp, the script itself, ...)
$cleanup = $TRUE;  # can be changed to $FALSE

# how many times should the script try to rerun cleanup (deletion of script, C:\temp), default is 3
$maxTries = 3

# check if the script is running as administrator if not elevate to administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[*] Elevating privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 1
}

# create folder C:\temp if it does not exist
if(!(Test-Path -Path 'C:\temp' )){
    New-Item -ItemType directory -Path 'C:\temp' | out-null
}
 
# add desktop icon: this computer
Write-Host "[*] Adding desktop icon: This Computer"
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' 0
 
# install google chrome, the chrome installer should automatically install the latest version of chrome
Write-Host '[*] Installing Google Chrome'
(New-Object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', 'c:\temp\chrome.exe')
Start-Process -FilePath 'C:\temp\chrome.exe' -ArgumentList '/silent /install'
 
# explorer: show known file extension, hide recent and frequent used files
Write-Host "[*] Configure explorer to show known file extensions and hide recent & frequent used files"
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' HideFileExt 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' ShowRecent 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' ShowFrequent 0
 
# energy settings
Write-Output "[*] Configure power settings"
powercfg.exe -CHANGE -disk-timeout-ac 30
powercfg.exe -CHANGE -disk-timeout-dc 30
powercfg.exe -CHANGE -standby-timeout-ac 0
powercfg.exe -CHANGE -standby-timeout-dc 0
powercfg.exe -CHANGE -hibernate-timeout-ac 0
powercfg.exe -CHANGE -hibernate-timeout-dc 0
 
# remove microsoft edge desktop icon
Write-Host '[*] Removing Microsoft Edge desktop icon'
$path = "C:\Users\${username}\Desktop\Microsoft Edge.lnk"
if (Test-Path -Path $path -PathType leaf) {
    rm $path
}
 
# remove contacts, taskview and cortana buttons from taskbar
Write-Host "[*] Removing taskbar icons"
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' PeopleBand 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowTaskViewButton 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' SearchboxTaskbarMode 0
 
# removing directories from this computer
Write-Host '[*] Remoing system directories'
[String[]] $keys = '{1CF1260C-4DD0-4ebb-811F-33C572699FDE}',
    '{374DE290-123F-4565-9164-39C4925E467B}',
    '{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}',
    '{A0953C92-50DC-43bf-BE83-3742FED03C9C}',
    '{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}',
    '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}',
    '{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}',
    '{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}',
    '{088e3905-0323-4b02-9826-5d99428e115f}',
    '{24ad3ad4-a569-4530-98e1-ab02f9417aa8}',
    '{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}',
    '{d3162b92-9365-467a-956b-92703aca08af}',
    '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'
foreach ($key in $keys) {
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\${key}") {
        Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\${key}"
    }
}
 
# control panel: show all links instead of categories
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' ForceClassicControlPanel 1
 
# restart explorer - windows 10 should automaticlly start explorer.exe if it's not running
Stop-Process -ProcessName explorer
 
# cleanup
if ($cleanup) {
    # remove the executed script (commented out because it's on the installer stick)
    Write-Host "[*] Removing ${PSCommandPath}"
    Remove-Item $PSCommandPath
   
    Start-Sleep -Milliseconds 30000
 
    # try to remove the temp folder, could go wrong because chrome.exe is in use (while installation)
    $retries = 0
    do {
        $textTry = switch ($retries){
            0 {"first"; break}
            1 {"second"; break}
            2 {"third"; break}
        }
        Write-Host "[*] Trying to removing C:\temp\ (${textTry} try of $maxTries) ..."
        Remove-Item 'C:\temp' -Recurse -Force 2>&1 | out-null
        Start-Sleep -Milliseconds 2000
        $retries++
    } while ($retries -lt $maxTries -and (Test-Path -Path 'C:\temp'))
}
 
Read-Host -Prompt "Press Enter to continue"
