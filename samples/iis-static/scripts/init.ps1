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