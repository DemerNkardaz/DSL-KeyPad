param (
	[Parameter(Mandatory = $true)][string]$ZipPath,
	[Parameter(Mandatory = $true)][string]$Destination,
	[Parameter(Mandatory = $true)][string]$Version,
	[int]$DelayMs = 0
)

if (!(Test-Path $ZipPath)) {
	Write-Error "Archive not found: $ZipPath"
	exit 1
}

$TempExtractPath = Join-Path $env:TEMP ("DSLKeyPad_Extract_" + [System.Guid]::NewGuid().ToString())

New-Item -ItemType Directory -Path $TempExtractPath | Out-Null
Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempExtractPath -Force

$KeypadFolder = Get-ChildItem $TempExtractPath -Recurse -Directory | Where-Object { $_.Name -eq "DSLKeyPad" } | Select-Object -First 1

if (-not $KeypadFolder) {
	Write-Error "Folder DSLKeyPad does not exist in the archive"
	Remove-Item $TempExtractPath -Recurse -Force
	exit 2
}

$FilesToCopy = @()
if (Test-Path (Join-Path $KeypadFolder.FullName "User")) {
	Write-Host "Ignoring User directory: $(Join-Path $KeypadFolder.FullName 'User')"
	$FilesToCopy = Get-ChildItem -Path $KeypadFolder.FullName -Recurse | Where-Object { $_.FullName -notlike "*\User\*" }
}
else {
	$FilesToCopy = Get-ChildItem -Path $KeypadFolder.FullName -Recurse
}

$total = $FilesToCopy.Count
if ($total -eq 0) {
	Write-Warning "No files to copy."
}
else {
	Write-Host ""
	Write-Host "Updating your DSL KeyPad installation..." -ForegroundColor Cyan
	Write-Host ""

	$progressWidth = 100

	for ($i = 0; $i -lt $total; $i++) {
		$file = $FilesToCopy[$i]
		$relativePath = $file.FullName.Substring($KeypadFolder.FullName.Length).TrimStart('\')
		$destinationPath = Join-Path $Destination $relativePath

		if ($file.PSIsContainer) {
			if (!(Test-Path $destinationPath)) {
				New-Item -ItemType Directory -Path $destinationPath | Out-Null
			}
		}
		else {
			$destDir = Split-Path $destinationPath -Parent
			if (!(Test-Path $destDir)) {
				New-Item -ItemType Directory -Path $destDir | Out-Null
			}
			Copy-Item -Path $file.FullName -Destination $destinationPath -Force
		}

		$percent = [math]::Round((($i + 1) / $total) * 100)
		$filledLength = [math]::Round(($i + 1) / $total * $progressWidth)
		$bar = ('█' * $filledLength).PadRight($progressWidth)

		Write-Host ("`r[{0}] {1,3}%" -f $bar, $percent) -ForegroundColor Yellow -NoNewline

		if ($DelayMs -gt 0) {
			Start-Sleep -Milliseconds $DelayMs
		}
	}
	Write-Host "`nInstallation complete" -ForegroundColor Yellow
}

Remove-Item $TempExtractPath -Recurse -Force

try {
	Remove-Item $ZipPath -Force
	Write-Host "Deleted archive: $ZipPath" -ForegroundColor Gray
}
catch {
	Write-Warning "Failed to delete archive: $ZipPath"
}

Write-Host "Successfully updated to version $Version" -ForegroundColor Green
Start-Sleep -Seconds 2
exit 0
