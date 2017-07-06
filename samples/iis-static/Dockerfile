# escape=`
#FROM microsoft/iis:windowsservercore-10.0.14393.1358
FROM microsoft/iis:nanoserver-10.0.14393.1358

SHELL ["powershell", "-command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install ContainerTools
ENV ContainerToolsVersion=0.0.1
RUN Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force; `
    Set-PsRepository -Name PSGallery -InstallationPolicy Trusted; `
    Install-Module -Name ContainerTools -MinimumVersion $Env:ContainerToolsVersion -Confirm:$false

WORKDIR /scripts
COPY scripts .
RUN ./init.ps1
ENTRYPOINT ["powershell", "-File", ".\\run.ps1"]

EXPOSE 80
COPY app /inetpub/wwwroot