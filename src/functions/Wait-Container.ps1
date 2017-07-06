function Wait-Container {
  $stopEvent = Wait-Event -SourceIdentifier 'StopContainer'
  Write-Host "Container stopping: $($stopEvent.MessageData)"
}