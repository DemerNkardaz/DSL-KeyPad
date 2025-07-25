﻿param (
	[Parameter(Mandatory = $true)][string]$FolderPath,
	[Parameter(Mandatory = $true)][string]$Version,
	[Int16]$SleepingDuration = 4
)

if (-not (Test-Path $FolderPath -PathType Container)) {
	Write-Error "Folder not found: $FolderPath"
	exit 1
}

$ParentDir = Split-Path $FolderPath -Parent
$ZipName = "DSL-KeyPad-$Version.zip"
$ZipPath = Join-Path $ParentDir $ZipName

if (Test-Path $ZipPath) {
	Remove-Item $ZipPath -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression

try {
	Write-Host ""
	Write-Host "Preparing to create archive..." -ForegroundColor Cyan
	Write-Host ""

	$excludedFiles = @()
	$files = Get-ChildItem -Path $FolderPath -Recurse -File | Where-Object {
		$relativePath = $_.FullName.Substring($FolderPath.Length).TrimStart('\', '/')

		$isInUserFolder = $relativePath -like 'User\*'
		$isInModsFolder = $relativePath -like 'Mods\*'
		$isInBinSubfolder = ($relativePath -like 'Bin\*\*') -and ($relativePath -notmatch '^Bin\\[^\\]+$')
		$hasExcludedExtension = $_.Extension -in '.cmd', '.cs'
		$isExcludedFile = $_.Name -in @('version', 'message', 'prerelease', 'make_latest', 'title', 'latest', 'workflow.ps1', 'desktop.ini')

		if ($isInUserFolder -or $isInModsFolder -or $isInBinSubfolder -or $hasExcludedExtension -or $isExcludedFile) {
			$excludedFiles += $_
			return $false
		}

		return $true
	}

	Write-Host ""
	Write-Host "Excluded files and paths:" -ForegroundColor Yellow
	foreach ($excluded in $excludedFiles) {
		Write-Host $excluded.FullName -ForegroundColor DarkGray
	}
	
	$totalFiles = $files.Count
	$originalSize = ($files | Measure-Object -Property Length -Sum).Sum
	
	Write-Host "Found $totalFiles files to archive." -ForegroundColor White
	Write-Host "Original size: $([Math]::Round($originalSize / 1MB, 2)) MB" -ForegroundColor White
	Write-Host ""
	
	$zipFileStream = [System.IO.File]::Create($ZipPath)
	$zipArchive = New-Object System.IO.Compression.ZipArchive($zipFileStream, [System.IO.Compression.ZipArchiveMode]::Create)

	$progressWidth = 50
	$processedFiles = 0
	
	Write-Host "Creating archive:" -ForegroundColor Cyan

	foreach ($file in $files) {
		$relativePath = $file.FullName.Substring($FolderPath.Length).TrimStart('\', '/')

		$entryPath = Join-Path "DSLKeyPad" $relativePath
		$entryPath = $entryPath -replace '\\', '/'
        
		$zipEntry = $zipArchive.CreateEntry($entryPath, [System.IO.Compression.CompressionLevel]::Optimal)
		$zipEntry.LastWriteTime = $file.LastWriteTime

		$entryStream = $zipEntry.Open()
		$fileStream = [System.IO.File]::OpenRead($file.FullName)

		try {
			$fileStream.CopyTo($entryStream)
		}
		finally {
			$fileStream.Dispose()
			$entryStream.Dispose()
		}
		
		$processedFiles++
		$percent = [math]::Round(($processedFiles / $totalFiles) * 100)
		$filledLength = [math]::Round($processedFiles / $totalFiles * $progressWidth)
		$bar = ('█' * $filledLength).PadRight($progressWidth)

		Write-Host ("`r[{0}] {1,3}%" -f $bar, $percent) -ForegroundColor Yellow -NoNewline
	}
	
	Write-Host "" 
	
	$zipArchive.Dispose()
	$zipFileStream.Dispose()

	$finalSize = (Get-Item $ZipPath).Length
	$compressionRatio = 100 - [Math]::Round(($finalSize / $originalSize) * 100, 2)
	
	Write-Host ""
	Write-Host "Bundle successfully created: $ZipPath" -ForegroundColor Green
	Write-Host "Original size: $([Math]::Round($originalSize / 1MB, 2)) MB" -ForegroundColor Green
	Write-Host "Compressed size: $([Math]::Round($finalSize / 1MB, 2)) MB" -ForegroundColor Green
	Write-Host "Compression ratio: $compressionRatio%" -ForegroundColor Green
	Write-Host ""
	
	Start-Sleep -Seconds $SleepingDuration
	exit 0
}
catch {
	Write-Error "Error during bundle creation: $_"
	Read-Host -Prompt "Press Enter to exit"
	exit 2
}