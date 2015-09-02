. "$(Split-Path $Profile)\Settings.ps1"

$env:path += ";" + ($Settings.Path -Join ";")

function Open($path) {
    Explorer $path
}

function Edit {

    [CmdletBinding()]
    Param(

        [Parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromRemainingArguments = $True, Position = 0)] 
        $File
    )

    Process {
        $app = $Settings.TextEditor

        if ($File -ne $null) {
            $parameters = '"' + $File + '"'

            $options = New-Object "System.Diagnostics.ProcessStartInfo"
            $options.FileName = $app
            $options.Arguments = $parameters
            $options.WorkingDirectory = $pwd

            $temp = [Diagnostics.Process]::Start($options).WaitForInputIdle(500)
        }
        Invoke-Item $app
    }
}

# This was already here
function Elevate-Process
{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";

    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi);
}
Set-Alias sudo elevate-process;

function Get-WebClient()
{
    $wc = New-Object System.Net.WebClient
    $wc.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    return $wc
}

function Get-WebContent([string]$url)
{
    $webClient = Get-WebClient
    $webClient.DownloadString($url);
}

function Shorten-Path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function Prompt { 
    # our theme
    $cdelim = [ConsoleColor]::DarkCyan 
    $chost = [ConsoleColor]::Green 
    $cloc = [ConsoleColor]::Cyan 
    $default = [ConsoleColor]::White 

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $default

    write-host (shorten-path (pwd).Path) "" -n -f $cloc
    Write-VcsStatus
    return '> '
}

function Enable-Git {
    .  "$(Split-Path $profile)\Modules\posh-git\profile.example.ps1"
}

function Load-Profile
{
    . $Profile
}

function Edit-Profile
{
    edit $profile
}

function Git-Log([switch]$OneLine, $Length)
{
    $Length = 1000;

    if ($OneLine) {
        git log --pretty=oneline -n $Length
    } else {
        git log -n $Length
    }   
}
