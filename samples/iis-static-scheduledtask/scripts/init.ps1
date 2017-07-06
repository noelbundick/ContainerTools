# Install ContainerTools
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PsRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name ContainerTools -MinimumVersion $Env:ContainerToolsVersion -Confirm:$false

# Configure IIS to log to a central directory
Import-Module IISAdministration
$section = Get-IISConfigSection -SectionPath 'system.applicationHost/log'
$element = Get-IISConfigElement -ConfigElement $section -ChildElementName 'centralW3CLogFile'
Start-IISCommitDelay
Set-IISConfigAttributeValue -ConfigElement $section -AttributeName 'centralLogFileMode' -AttributeValue 'CentralW3C'
Set-IISConfigAttributeValue -ConfigElement $element -AttributeName 'truncateSize' -AttributeValue '4294967295'
Set-IISConfigAttributeValue -ConfigElement $element -AttributeName 'period' -AttributeValue 'MaxSize'
Set-IISConfigAttributeValue -ConfigElement $element -AttributeName 'directory' -AttributeValue 'c:\iislog'
Stop-IISCommitDelay -Commit $True;

# Create a companion scheduled task to do some work in the background
New-Item 'C:\time.txt' -Type File | out-null
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-Command "(Get-Date).Ticks >> C:\time.txt;"'
$now = Get-Date
$trigger1 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now -Once
$trigger2 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now.AddSeconds(10) -Once
$trigger3 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now.AddSeconds(20) -Once
$trigger4 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now.AddSeconds(30) -Once
$trigger5 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now.AddSeconds(40) -Once
$trigger6 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 1) -At $now.AddSeconds(50) -Once
Register-ScheduledTask -Action $action -Trigger ($trigger1,$trigger2,$trigger3,$trigger4,$trigger5,$trigger6) -Settings (New-ScheduledTaskSettingsSet) -TaskName 'TimeLog' -Description 'Log ticks to file' -User 'SYSTEM' | out-null
