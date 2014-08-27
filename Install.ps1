$files = (
	@{ Name = "$Profile", Url = "https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Profile.ps1" }
)

$files | % {
	(new-object net.webclient).DownloadString($_.Url) | Set-Content $_.Name -Force
}