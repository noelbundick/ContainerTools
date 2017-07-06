function Watch-Service {
  param (
    [Parameter(Mandatory=$true)]
    [string] $ServiceName
  )
  Start-Service $ServiceName
  $query = "Select * from CIM_InstModification within 1 where TargetInstance ISA 'Win32_Service' AND TargetInstance.Name='$ServiceName' AND TargetInstance.State='Stopped'"
  Register-CimIndicationEvent -Query $query -MessageData $ServiceName -Action {
    New-Event -SourceIdentifier 'StopContainer' -MessageData "$($event.MessageData) has stopped"
  } | out-null
}