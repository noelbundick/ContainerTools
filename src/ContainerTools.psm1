$functions = Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1"
foreach($file in $functions)
{
    try
    {
        . $file.FullName
    }
    catch
    {
        # Ignore errors
    }
}

# System.Timers.Timer doesn't land in PowerShell Core until 6.x
if ($PSVersionTable.PSVersion.Major -lt 6 -and $PSEdition -eq 'Core') {
  . "$PSScriptRoot\netcore1.0\Watch-LogFile.ps1"
}