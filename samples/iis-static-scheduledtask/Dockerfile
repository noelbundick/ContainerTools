# escape=`
#FROM microsoft/iis:windowsservercore-10.0.14393.1358
FROM microsoft/iis:nanoserver-10.0.14393.1358

SHELL ["powershell", "-command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV ContainerToolsVersion=0.0.1

WORKDIR /scripts
COPY scripts .
RUN ./init.ps1
ENTRYPOINT ["powershell", "-File", ".\\run.ps1"]

EXPOSE 80
COPY app /inetpub/wwwroot