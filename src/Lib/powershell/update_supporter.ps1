param (
	[string]$ZipPath,
	[string]$Destination
)

if (!(Test-Path $ZipPath)) {
	Write-Error "Archive not found: $ZipPath"
	exit 1
}

$TempExtractPath = Join-Path $env:TEMP ("DSLKeyPad_Extract_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TempExtractPath | Out-Null

Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempExtractPath -Force

Write-Host "Archive content:"
Get-ChildItem $TempExtractPath -Recurse | ForEach-Object { Write-Host $_.FullName }

$KeypadFolder = Get-ChildItem $TempExtractPath -Recurse -Directory | Where-Object { $_.Name -eq "DSLKeyPad" } | Select-Object -First 1

if (-not $KeypadFolder) {
	Write-Error "Folder DSLKeyPad does not exist in the archive"
	exit 2
}

Copy-Item -Path "$($KeypadFolder.FullName)\*" -Destination $Destination -Recurse -Force
Remove-Item $TempExtractPath -Recurse -Force

try {
	Remove-Item $ZipPath -Force
	Write-Host "Deleted archive: $ZipPath"
}
catch {
	Write-Warning "Failed to delete archive: $ZipPath"
}

Write-Host "Files successfully copied to $Destination"
exit 0
