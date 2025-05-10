param (
	[Parameter(Mandatory = $true)][string]$IniPath
)

$OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$nbspChar = [char]0x00A0
$enDash = [char]0x2013

function Remove-FileAttributes {
	param (
		[string]$FilePath
	)
    
	try {
		$output = cmd /c attrib -R -H -S "$FilePath" 2>&1
		if ($LASTEXITCODE -ne 0) {
			Write-Host "Warning: Unable to remove attributes using attrib: $output" -ForegroundColor Yellow
			return $false
		}
		return $true
	}
	catch {
		Write-Host "Error removing attributes: $($_.Exception.Message)" -ForegroundColor Red
		return $false
	}
}

function Set-FileAttributes {
	param (
		[string]$FilePath
	)
    
	try {
		$output = cmd /c attrib +H +S "$FilePath" 2>&1
		if ($LASTEXITCODE -ne 0) {
			Write-Host "Warning: Unable to set attributes using attrib: $output" -ForegroundColor Yellow
			return $false
		}
		return $true
	}
	catch {
		Write-Host "Error setting attributes: $($_.Exception.Message)" -ForegroundColor Red
		return $false
	}
}

function Get-FileContent {
	param (
		[string]$FilePath
	)

	try {
		if (Test-Path $FilePath) {
			$attributesRemoved = Remove-FileAttributes -FilePath $FilePath
            
			try {
				$content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::Unicode)
				return $content
			}
			catch {
				Write-Host "Warning: Could not read file content: $($_.Exception.Message)" -ForegroundColor Yellow
				return $null
			}
			finally {
				if ($attributesRemoved) {
					Set-FileAttributes -FilePath $FilePath | Out-Null
				}
			}
		}
		return $null
	}
	catch {
		Write-Host "Error reading file: $($_.Exception.Message)" -ForegroundColor Red
		return $null
	}
}

try {
	$desktopIniContent = @"
[.ShellClassInfo]
ConfirmFileOp=0
IconResource=Bin\DSLKeyPad_App_Icons.dll,0
InfoTip=Diacritics-Spaces-Letters${nbspChar}KeyPad. A${nbspChar}multilingual${nbspChar}unicode${nbspChar}input${nbspChar}tool @Yalla${nbspChar}Nkardaz;${nbspChar}GitHub${enDash}SourceForge
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

	Write-Host $desktopIniContent
    
	$directory = [System.IO.Path]::GetDirectoryName($IniPath)
	if (-not (Test-Path -Path $directory -PathType Container)) {
		New-Item -ItemType Directory -Path $directory -Force | Out-Null
		Write-Host "Created directory: $directory" -ForegroundColor Cyan
	}


	if (Test-Path $IniPath) {
		Write-Host "File exists. Checking content..." -ForegroundColor Yellow

		$existingContent = Get-FileContent -FilePath $IniPath
		if ($null -ne $existingContent) {
			$existingNormalized = $existingContent.Replace("`r`n", "`n").Trim()
			$desktopIniContentNormalized = $desktopIniContent.Replace("`r`n", "`n").Trim()
            
			if ($existingNormalized -eq $desktopIniContentNormalized) {
				Write-Host "File content is identical. No changes needed." -ForegroundColor Green
				Set-FileAttributes -FilePath $IniPath | Out-Null
				return
			}

			Write-Host "File content differs. Need to update." -ForegroundColor Yellow
		}

		$attributesRemoved = Remove-FileAttributes -FilePath $IniPath
		if (-not $attributesRemoved) {
			Write-Host "Warning: Failed to remove file attributes. Attempting alternative approach..." -ForegroundColor Yellow

			$backupPath = "$IniPath.bak"
			if (Test-Path $backupPath) {
				Remove-Item $backupPath -Force -ErrorAction SilentlyContinue
			}

			try {
				Rename-Item -Path $IniPath -NewName "$([System.IO.Path]::GetFileName($IniPath)).bak" -Force -ErrorAction Stop
				Remove-Item -Path $backupPath -Force -ErrorAction SilentlyContinue
				Write-Host "Successfully removed old file" -ForegroundColor Green
			}
			catch {
				Write-Host "Cannot rename or remove the file. Will try direct overwrite." -ForegroundColor Red
			}
		}
	}

	try {
		[System.IO.File]::WriteAllText($IniPath, $desktopIniContent, [System.Text.Encoding]::Unicode)
		Write-Host "File written successfully" -ForegroundColor Green
	}
	catch {
		Write-Host "Error writing file directly: $($_.Exception.Message)" -ForegroundColor Red

		$tempFile = [System.IO.Path]::GetTempFileName()
		[System.IO.File]::WriteAllText($tempFile, $desktopIniContent, [System.Text.Encoding]::Unicode)

		$output = cmd /c copy /Y "$tempFile" "$IniPath" 2>&1
		if ($LASTEXITCODE -ne 0) {
			throw "Failed to copy file using cmd: $output"
		}
		Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
		Write-Host "File written using alternative method" -ForegroundColor Green
	}

	Write-Host "Setting file attributes..." -ForegroundColor Yellow
	$attributesSet = Set-FileAttributes -FilePath $IniPath
	if ($attributesSet) {
		Write-Host "File attributes set: Hidden + System" -ForegroundColor Green
	}

	Write-Host "Operation completed successfully!" -ForegroundColor Green
}
catch {
	Write-Host "Critical Error: $($_.Exception.Message)" -ForegroundColor Red
	Write-Host "Error details: $($_.Exception)" -ForegroundColor DarkRed
	Write-Host "Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor DarkRed
	Read-Host "Press Enter to continue..."
}