﻿$ErrorActionPreference = 'Stop'

$packageName = 'kubernetes-cli'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$installLocation = "$(Get-ToolsLocation)\$packageName"

$packageArgs = @{
  PackageName    = $packageName
  FileFullPath   = Get-Item $toolsPath\*-386.tar.gz
  FileFullPath64 = Get-Item $toolsPath\*-amd64.tar.gz
  Destination    = $installLocation
}
Get-ChocolateyUnzip @packageArgs

if (!(Test-Path "$installLocation\kubernetes\client" -include "*.exe")) {
  $packageArgs2 = @{
    PackageName    = $packageName
    FileFullPath   = Get-Item $installLocation\*-386.tar
    FileFullPath64 = Get-Item $installLocation\*-amd64.tar
    Destination    = $installLocation
  }
  Get-ChocolateyUnzip @packageArgs2
}

Move-Item "$installLocation\kubernetes\client\*" "$installLocation" -Force
Install-ChocolateyPath "$installLocation\bin"

Remove-Item "$installLocation\kubernetes" -Recurse -Force -ea 0
Remove-Item "$installLocation\*.tar"