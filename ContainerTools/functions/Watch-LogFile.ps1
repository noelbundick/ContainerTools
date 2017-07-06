function Watch-LogFile {
  param (
    [Parameter(Mandatory=$true)]
    [string] $LogPath,
    [int] $IntervalMs = 1000
  )

  $timer = New-Object System.Timers.Timer
  $timer.Interval = $IntervalMs
  $tailJob = Start-Job -ScriptBlock { Get-Content -Path $args[0] -Tail 1 -Wait } -ArgumentList $LogPath
  Register-ObjectEvent -InputObject $timer -EventName Elapsed -MessageData $tailJob -Action {
    $job = $event.MessageData
    Receive-Job $job | Write-Host
  } | out-null
  
  $timer.Enabled = $true
  return $tailJob
}