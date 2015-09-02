$files = @(
	@{ Name = "$Profile"; Url = "https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Profile.ps1" }
	@{ Name = "$(Split-Path $Profile)\Settings.ps1"; Url = "https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Settings.ps1" }
)

$wc = New-Object System.Net.WebClient
$wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

$files | % {
	
	$path = (Split-Path $_.Name)
	
	New-Item -Type Directory -Path $path -Force
	
	$fileName = (Split-Path $_.Name -Leaf)
	if (!(Test-Path $fileName)) {
		New-Item -Type File -Name $fileName
	}
	
	$wc.DownloadString($_.Url) | Set-Content $_.Name -Force
}

# Reload Profile
. $Profile
