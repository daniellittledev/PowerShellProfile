$files = @(
	@{ Name = "$Profile"; Url = "https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Profile.ps1" }
	@{ Name = "$(Split-Path $Profile)\Settings.ps1"; Url = "https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Settings.ps1" }
)

$files | % {
	
	New-Item -Type Directory -Name (Split-Path $_.Name) -Force
	
	$fileName = (Split-Path $_.Name -Leaf)
	if (!(Test-Path $fileName)) {
		New-Item -Type File -Name $fileName
	}
	
	(new-object net.webclient).DownloadString($_.Url) | Set-Content $_.Name -Force
}

# Reload Profile
. $Profile
