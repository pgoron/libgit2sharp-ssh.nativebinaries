Param(
    [Parameter(Mandatory=$true)]
    [string]$version,
    [switch]$pre
)

$buildDate = (Get-Date).ToUniversalTime().ToString("yyyyMMddHHmmss")
$versionSuffix = ""
if ($pre.IsPresent) { $versionSuffix = "-pre$BuildDate" }

$projectDirectory = Split-Path $MyInvocation.MyCommand.Path
$x86Directory = Join-Path $projectDirectory "nuget.package\runtimes\win-x86\native"
$x64Directory = Join-Path $projectDirectory "nuget.package\runtimes\win-x64\native"
$osxDirectory = Join-Path $projectDirectory "nuget.package\runtimes\osx\native"
$linuxDirectory = Join-Path $projectDirectory "nuget.package\runtimes\linux-x64\native"

if ( -Not (Test-Path $x86Directory\*.dll) )
{
    mkdir -fo $x86Directory > $null
    Set-Content $x86Directory\addbinaries.here $null
}

if ( -Not (Test-Path $x64Directory\*.dll) )
{
    mkdir -fo $x64Directory > $null
    Set-Content $x64Directory\addbinaries.here $null
}

if ( -Not (Test-Path $osxDirectory\*.dylib) )
{
    mkdir -fo $osxDirectory > $null
    Set-Content $osxDirectory\addbinaries.here $null
}

if ( -Not (Test-Path $linuxDirectory\*.so) )
{
    mkdir -fo $linuxDirectory > $null
    Set-Content $linuxDirectory\addbinaries.here $null
}

.\Nuget.exe Pack nuget.package\NativeBinaries.nuspec -Version $version$versionSuffix -NoPackageAnalysis
