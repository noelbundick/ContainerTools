# Shim to use System.Threading.Timers because the friendlier System.Timers.Timers is not available in .NET Core 1.0
[System.Collections.ArrayList]$global:__timers = @()

$references = @("C:\Windows\System32\DotNetCore\v1.0\System.Linq.dll", "C:\Windows\System32\DotNetCore\v1.0\System.Linq.Expressions.dll","C:\Windows\System32\WindowsPowerShell\v1.0\System.Management.Automation.ni.dll", "C:\Windows\System32\DotNetCore\v1.0\System.Reflection.dll")
Add-Type -Path "$PSScriptRoot\RunspaceDelegateFactory.cs" -ReferencedAssemblies $references

function New-Timer
{
  param (
    [System.Threading.TimerCallback]$callback,
    [int]$interval = 1000,
    [object]$state
  )

  $runspacedDelegate = [RunspacedDelegateFactory]::NewRunspacedDelegate($callback, [Runspace]::DefaultRunspace)
  $timer = New-Object System.Threading.Timer($runspacedDelegate, $state, 0, $interval)
  return $timer
}

function Watch-LogFile {
  param (
    [Parameter(Mandatory=$true)]
    [string] $LogPath,
    [int] $IntervalMs = 1000
  )

  $identifier = [Guid]::NewGuid().ToString()
  $tailJob = Start-Job -ScriptBlock { Get-Content -Path $args[0] -Tail 1 -Wait } -ArgumentList $LogPath
  $callback = [System.Threading.TimerCallback] {
    param($state)
    $results = Receive-Job $state.job
    if ($results -ne $null) {
      New-Event -SourceIdentifier $state.identifier -MessageData $results | out-null
    }
  }

  $state = @{"identifier"=$identifier; "job"=$tailJob;}
  $timer = New-Timer -callback $callback -interval $IntervalMs -state $state
  $__timers.Add($timer) | out-null
  
  Register-EngineEvent -SourceIdentifier $identifier -Action {
    $event.MessageData | Write-Host
  } | out-null

  return $tailJob
}