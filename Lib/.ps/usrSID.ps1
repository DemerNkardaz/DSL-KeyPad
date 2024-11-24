param(
    [string]$folderPath
)

$fileName = "usrSID.txt"
$fullPath = Join-Path -Path $folderPath -ChildPath $fileName

$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$id.User.Value | Out-File -FilePath $fullPath -Encoding UTF8