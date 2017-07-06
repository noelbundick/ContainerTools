# ContainerTools

Useful PowerShell commands for running apps inside containers

## Usage

In your Dockerfile, add the following lines to install the ContainerTools module

```Dockerfile
ENV ContainerToolsVersion=0.0.1
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; `
    Set-PsRepository -Name PSGallery -InstallationPolicy Trusted; `
    Install-Module -Name ContainerTools -MinimumVersion $Env:ContainerToolsVersion -Confirm:$false
```

### Example script

The following is a simple script that could be used in an entrypoint.

```powershell
Import-Module ContainerTools

# Start IIS. A 'StopContainer' event will be raised if the service stops
# Note: you can watch multiple services and take actions, such as restarting the service or exiting the container
Watch-Service W3SVC

# Tail the IIS log file to STDOUT, where it is picked up by the Docker logging provider
# Note: this happens asynchronously, so you can tail multiple logs at once, or perform other work as needed
Watch-LogFile -LogPath 'C:\iislog\w3svc\u_extend1.log'

# Wait for a 'StopContainer' event to exit the script
Wait-Container
``` 

## Wait-Container

Waits for a 'StopContainer' event. Useful for preventing a script from exiting while still allowing monitoring and logging to occur.

## Watch-LogFile

Prints the contents of a log file to STDOUT from a background thread. Because this doesn't block, you can tail multiple logs, continue to do other work in the script, or wait for critical events, such as 'StopContainer'.

## Watch-Service

Starts a service and raises a 'StopContainer' event when it stops. Allows you to run & monitor multiple services and stop the container when any one of them fails or completes.