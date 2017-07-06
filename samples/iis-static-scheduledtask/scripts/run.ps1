Import-Module ContainerTools -DisableNameChecking

# Start & watch required services
Watch-Service W3SVC

# Tail IIS logs to STDOUT
# Note: IIS flushes logs once every 60 seconds or 64K by default
Invoke-WebRequest http://localhost -UseBasicParsing | Out-Null
netsh http flush logbuffer | Out-Null
$iisJob = Watch-LogFile -LogPath 'C:\iislog\w3svc\u_extend1.log'

# Tail logs for scheduled task
# Note: Time log fires once every 10 seconds. We'll get these in near-realtime
Watch-LogFile -LogPath 'C:\time.txt' | out-null

# Wait for 'StopContainer' event
Wait-Container

# Capture final IIS logs before shutting down
netsh http flush logbuffer | out-null
Receive-Job $iisJob

exit