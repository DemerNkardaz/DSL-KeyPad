param (
	[string]$ZipPath,
	[string]$Destination
)

# Проверим существование ZIP-файла
if (!(Test-Path $ZipPath)) {
	Write-Error "Архив не найден: $ZipPath"
	exit 1
}

# Временная директория для извлечения
$TempExtractPath = Join-Path $env:TEMP ("DSLKeyPad_Extract_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TempExtractPath | Out-Null

# Распаковываем в неё
Expand-Archive -LiteralPath $ZipPath -DestinationPath $TempExtractPath -Force

# Ищем папку DSLKeyPad (первую попавшуюся)
$KeypadFolder = Get-ChildItem $TempExtractPath -Directory | Where-Object { $_.Name -eq "DSLKeyPad" }

if (-not $KeypadFolder) {
	Write-Error "Папка DSLKeyPad не найдена в архиве"
	exit 2
}

# Копируем её содержимое в целевую папку с перезаписью
Copy-Item -Path "$($KeypadFolder.FullName)\*" -Destination $Destination -Recurse -Force

# Убираем временные файлы
Remove-Item $TempExtractPath -Recurse -Force

Write-Host "Файлы успешно распакованы в $Destination"
exit 0
