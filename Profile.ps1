function Open($path) {
    explorer $path
}

function Edit {

    [CmdletBinding()]
    Param(

        [Parameter(Mandatory = $False, ValueFromPipeline = $True, ValueFromRemainingArguments = $True, Position = 0)] 
        $File
    )

    Process {
        $app = "C:\Program Files (x86)\Notepad++\notepad++.exe"

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
function elevate-process
{
    $file, [string]$arguments = $args;
    $psi = new-object System.Diagnostics.ProcessStartInfo $file;
    $psi.Arguments = $arguments;
    $psi.Verb = "runas";

    $psi.WorkingDirectory = get-location;
    [System.Diagnostics.Process]::Start($psi);
}
set-alias sudo elevate-process;


# WebGet
function get-html([string]$url)
{
    $webClient = (New-Object System.Net.WebClient);
    $webClient.DownloadString($url);
}

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function prompt { 
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

# gci . *.cs -Recurse | select-string . | Group Filename | Measure-Object Count -Min -Max -Average
function CountLines($directory)
{
    $pattern = "*.cs"
    $directories = [System.IO.Directory]::GetDirectories($directory)
    $files = [System.IO.Directory]::GetFiles($directory, $pattern)

    $lineCount = 0

    foreach($file in $files) {
        $lineCount += [System.IO.File]::ReadAllText($file).Split("`n").Count
    }

    foreach($subdirectory in $directories) {
        $lineCount += CountLines $subdirectory
    }

    $lineCount
}

$msbuildPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\"
$gitPath = (Get-Item "Env:LocalAppData").Value + "\GitHub\PortableGit_93e8418133eb85e81a81e5e19c272776524496c6\cmd\"

$env:path += ";$gitPath;$msbuildPath;"


function Enable-Git {
    .  "$(Split-Path $profile)\Modules\posh-git\profile.example.ps1"
}

#Write-Host "For git use 'Enable-Git'"

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
