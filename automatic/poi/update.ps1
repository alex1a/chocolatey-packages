import-module au

$releases = 'https://github.com/poooi/poi/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`$1$($Latest.FileName32)`""
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(1\..+)\<.*\>"         = "`${1}<$($Latest.URL32)>"
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType32)"
            "(?i)(checksum:\s+).*"      = "`${1}$($Latest.Checksum32)"
        }
    }
}

function global:au_GetLatest {


    $download_page = Invoke-WebRequest -Uri "$releases$lastVersionString" -UseBasicParsing
    $urls = $download_page.links | ? href -match 'poi-setup-.+\.exe$' | % href
    $url = $urls | select -First 1

    $exeSep  = (Split-Path($url) -Leaf) -split 'poi-setup-|\.exe'
    $version = $exeSep | select -Last 1 -Skip 1
    $validVersion = $version -replace "beta\.", "beta"

    @{
        URL32   = 'https://github.com' + $url
        Version = $validVersion
        ReleaseNotes = "$releases/tag/v${version}"
    }
}

update -ChecksumFor none
