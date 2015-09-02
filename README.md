PowerShellProfile
=================

A useful PowerShell profile

### Install

	PS:\> 

> (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Install.ps1') | iex

### Install behind a corporate proxy

	PS:\>

> $wc = New-Object System.Net.WebClient
> $wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
> (new-object net.webclient).DownloadString('https://raw.githubusercontent.com/Lavinski/PowerShellProfile/master/Install.ps1') | iex
