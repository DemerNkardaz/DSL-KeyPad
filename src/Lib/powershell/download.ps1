param (
	[Parameter(Mandatory = $true)][string]$Url,
	[Parameter(Mandatory = $true)][string]$Destination,
	[Parameter(Mandatory = $true)][string]$FileName,
	[int]$DelayMs = 0
)

$DestinationFolder = Split-Path -Path $Destination -Parent
if (-not (Test-Path $DestinationFolder)) {
	try {
		New-Item -ItemType Directory -Path $DestinationFolder -Force | Out-Null
		Write-Host "Created directory: $DestinationFolder" -ForegroundColor Gray
	}
	catch {
		Write-Error "Failed to create directory: $DestinationFolder"
		exit 1
	}
}

$FilePath = Join-Path $Destination $FileName
$TempFilePath = "$FilePath.tmp"

Write-Host "`nStarting download from: $Url" -ForegroundColor Cyan
Write-Host "Temporary file: $TempFilePath`n" -ForegroundColor Cyan

$webClient = New-Object System.Net.WebClient

$global:DownloadComplete = $false

$progressWidth = 50

Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -SourceIdentifier ProgressChanged -Action {
	$percent = $EventArgs.ProgressPercentage
	$filled = [math]::Round($percent / 100 * $progressWidth)
	$bar = ('█' * $filled).PadRight($progressWidth)
	$receivedKB = [math]::Round($EventArgs.BytesReceived / 1KB, 2)
	$totalKB = [math]::Round($EventArgs.TotalBytesToReceive / 1KB, 2)

	Write-Host ("`r[{0}] {1,3}%  ({2} KB of {3} KB)" -f $bar, $percent, $receivedKB, $totalKB) -ForegroundColor Yellow -NoNewline
} | Out-Null

Register-ObjectEvent -InputObject $webClient -EventName DownloadFileCompleted -SourceIdentifier DownloadCompleted -Action {
	$global:DownloadComplete = $true
} | Out-Null


try {
	$uri = [System.Uri]::new($Url)
	$webClient.DownloadFileAsync($uri, $TempFilePath)

	while (-not $global:DownloadComplete) {
		Start-Sleep -Milliseconds 100
	}

	Write-Progress -Activity "Downloading $FileName" -Completed
	Write-Host "`nDownload completed" -ForegroundColor Green

	if (Test-Path $FilePath) {
		Remove-Item $FilePath -Force
	}

	Move-Item -Path $TempFilePath -Destination $FilePath -Force

	Write-Host "File saved as: $FilePath" -ForegroundColor Green
	Start-Sleep -Milliseconds $DelayMs
	exit 0
}
catch {
	Write-Error "Error during download: $_"
	if (Test-Path $TempFilePath) {
		Remove-Item $TempFilePath -Force
	}
	exit 1
}
