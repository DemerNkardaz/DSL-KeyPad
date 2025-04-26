param (
	[Parameter(Mandatory = $true)][string]$FolderPath,
	[Parameter(Mandatory = $true)][string]$Version
)

if (-not (Test-Path $FolderPath -PathType Container)) {
	Write-Error "Папка не найдена: $FolderPath"
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
	$zipFileStream = [System.IO.File]::Create($ZipPath)
	$zipArchive = New-Object System.IO.Compression.ZipArchive($zipFileStream, [System.IO.Compression.ZipArchiveMode]::Create)

	Get-ChildItem -Path $FolderPath -Recurse -File | ForEach-Object {
		$file = $_

		$relativePath = $file.FullName.Substring($FolderPath.Length).TrimStart('\', '/')

		if ($relativePath -like 'User\*') {
			return
		}

		$entryPath = Join-Path "DSLKeyPad" $relativePath
		$entryPath = $entryPath -replace '\\', '/'
        
		$zipEntry = $zipArchive.CreateEntry($entryPath, [System.IO.Compression.CompressionLevel]::Optimal)

		$entryStream = $zipEntry.Open()
		$fileStream = [System.IO.File]::OpenRead($file.FullName)

		try {
			$fileStream.CopyTo($entryStream)
		}
		finally {
			$fileStream.Dispose()
			$entryStream.Dispose()
		}
	}

	$zipArchive.Dispose()
	$zipFileStream.Dispose()

	Write-Host "Успешно создан архив без папки User: $ZipPath"
	exit 0
}
catch {
	Write-Error "Ошибка при создании архива: $_"
	Read-Host -Prompt "Нажмите Enter для выхода"
	exit 2
}
