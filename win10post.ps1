# post installation script for Windows 10

<#
* Taskbar Links
* Explorer Favorites
#>

# should the script remove it traces? (e.g. C:\temp, the script itself, ...)
$cleanup = $TRUE;  # can be changed to $FALSE

# how many times should the script try to rerun cleanup (deletion of script, C:\temp), default is 3
$maxTries = 3

# check if the script is running as administrator if not elevate to administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[*] Elevating privileges..." -ForegroundColor Green
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 1
}

# create folder C:\temp if it does not exist
if(!(Test-Path -Path 'C:\temp' )){
    New-Item -ItemType directory -Path 'C:\temp' | out-null
}

# check network connectivity
if (!([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet)) {
    Write-Host "[!] Internet not connected" -ForegroundColor Red
} else {
    # create a web client
    $wc = New-Object System.Net.WebClient

    # install google chrome, the chrome installer should automatically install the latest version of chrome
    Write-Host '[*] Installing Google Chrome' -ForegroundColor Green
    $wc.DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', 'c:\temp\chrome.exe')
    Start-Process -FilePath 'C:\temp\chrome.exe' -ArgumentList '/silent /install'

  	# install adobe acrobat reader dc
  	Write-Host '[*] Installing Adobe Acrobat Reader DC' -ForegroundColor Green
  	# WARNING TODO: Hardcoded Version number
  	$wc.DownloadFile("http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1901020064/AcroRdrDC1901020064_de_DE.exe", "C:\temp\adobeDC.exe")
  	Start-Process -FilePath 'C:\temp\adobeDC.exe' -ArgumentList '/qn EULA_ACCEPT=YES AgreeToLicense=Yes RebootYesNo=No /sAll'
}

# add desktop icon: this computer
Write-Host "[*] Adding desktop icon: This Computer" -ForegroundColor Green
# check if key exist, create it if not
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons")) {
	New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons" | out-null
}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) {
	New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" | out-null
}
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' 0

# explorer: show known file extension, hide recent and frequent used files, hide checkboxes to select multiple files
Write-Host "[*] Configure explorer to show known file extensions and hide recent & frequent used files" -ForegroundColor Green
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' HideFileExt 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' ShowRecent 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' ShowFrequent 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' AutoCheckSelect 0

# energy settings
Write-Host "[*] Configure power settings" -ForegroundColor Green
powercfg.exe -CHANGE -disk-timeout-ac 30
powercfg.exe -CHANGE -disk-timeout-dc 30
powercfg.exe -CHANGE -standby-timeout-ac 0
powercfg.exe -CHANGE -standby-timeout-dc 0
powercfg.exe -CHANGE -hibernate-timeout-ac 0
powercfg.exe -CHANGE -hibernate-timeout-dc 0

# remove microsoft edge desktop icon
Write-Host '[*] Removing Microsoft Edge desktop icon' -ForegroundColor Green
$path = "C:\Users\${username}\Desktop\Microsoft Edge.lnk"
if (Test-Path -Path $path -PathType leaf) {
    rm $path
}

# remove adobe acrobat reader dc desktop icon
Write-Host '[*] Removing Adobe Acrobat Reader DC desktop icon' -ForegroundColor Green
$path = "C:\Users\${username}\Desktop\Acrobat Reader DC.lnk"
if (Test-Path -Path $path -PathType leaf) {
    rm $path
}

# remove contacts, taskview and cortana buttons from taskbar
Write-Host "[*] Removing taskbar icons" -ForegroundColor Green
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' PeopleBand 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' ShowTaskViewButton 0
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' SearchboxTaskbarMode 0

# removing directories from this computer
Write-Host '[*] Remoing system directories' -ForegroundColor Green
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
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
	New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
}
Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' ForceClassicControlPanel 1

# restart explorer - windows 10 should automaticlly start explorer.exe if it's not running
Stop-Process -ProcessName explorer

# set google chrome as default browser

Add-Type -AssemblyName 'System.Windows.Forms'
Start-Process $env:windir\system32\control.exe -ArgumentList '/name Microsoft.DefaultPrograms /page pageDefaultProgram\pageAdvancedSettings?pszAppName=google%20chrome'
Sleep 3
# go to default webbrowser
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{TAB}{TAB}{TAB} ")
Sleep -Milliseconds 300
# choose google chrome
[System.Windows.Forms.SendKeys]::SendWait("{TAB} ")
Sleep 1
# close window
[System.Windows.Forms.SendKeys]::SendWait("%{F4}")

# cleanup
if ($cleanup) {
	  # remove the executed script (commented out because it's on the installer stick)
    Write-Host "[*] Removing ${PSCommandPath}"
    Remove-Item $PSCommandPath

    Start-Sleep -Milliseconds 10000

    # try to remove the temp folder, could go wrong because chrome.exe and acrobat reader dc are in use (while installation)
    $retries = 0
    do {
		$textTry = switch ($retries){
			0 {"first"; break}
			1 {"second"; break}
			2 {"third"; break}
		}
        Write-Host "[*] Trying to removing C:\temp\ (${textTry} try of $maxTries) ..." -ForegroundColor Green
        Remove-Item 'C:\temp' -Recurse -Force 2>&1 | out-null
        Start-Sleep -Milliseconds 2000
        $retries++
    } while ($retries -lt $maxTries -and (Test-Path -Path 'C:\temp'))
}

Read-Host -Prompt "Press Enter to continue"
