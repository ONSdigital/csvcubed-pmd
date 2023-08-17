"""
This script is used to install csv2rdf and csvlint inside the Windows environment of a GitHub Action Runner.
"""

$path = $env:PATH

$initialWorkingDir = $pwd

Write-Output "=== Installing csvlint ==="

mkdir csvlint
cd csvlint

Invoke-WebRequest -Uri https://curl.se/windows/dl-7.86.0/curl-7.86.0-win64-mingw.zip -OutFile "curl.zip"
Expand-Archive -LiteralPath curl.zip -DestinationPath .
cp curl-7.86.0-win64-mingw\bin\libcurl-x64.dll curl-7.86.0-win64-mingw\bin\libcurl.dll
cp curl-7.86.0-win64-mingw\bin\* C:\hostedtoolcache\windows\Ruby\2.4.10\x64\bin

$curlExe = (Get-Item curl-7.86.0-win64-mingw\bin\curl.exe | Resolve-Path).Path.Substring(38)


gem install bundle
bundle init
bundle add i18n --version "~> 1.12.0"
bundle add csvlint --git https://github.com/GSS-Cogs/csvlint.rb --ref v0.6.7

$gemDir = gem environment gemdir

bundle config set bin bin
bundle config set path "$gemDir"
bundle install

$csvLintInstallationFolder = (Get-Item bin | Resolve-Path).Path.Substring(38)

Set-Content -Path "$csvLintInstallationFolder\csvlint.bat" -Value "@REM Forwarder script`n@echo off`necho Attempting to launch csvlint`nC:\hostedtoolcache\windows\Ruby\2.4.10\x64\bin\ruby $csvLintInstallationFolder\csvlint %*"

$path += ";$csvLintInstallationFolder"

cd $initialWorkingDir

Write-Output "=== Installing csv2rdf ==="

Invoke-WebRequest -Uri "https://github.com/Swirrl/csv2rdf/releases/download/0.4.7/csv2rdf-0.4.7-standalone.jar" -OutFile "csv2rdf.jar"
$csv2rdfPath = (Get-Item csv2rdf.jar | Resolve-Path).Path.Substring(38)
Set-Content -Path csv2rdf.bat -Value "@REM Forwarder script`n@echo off`necho Attempting to launch csv2rdf at $csv2rdfPath`njava -jar $csv2rdfPath %*"

$csv2rdfLocation = (Get-Item csv2rdf.bat | Resolve-Path).Path.Substring(38)
echo "CSV2RDF_LOCATION=$csv2rdfLocation" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf8 -Append
Write-Output "csv2rdf location: $csv2rdfLocation"

$path += ";$pwd"

Write-Output "Setting path"
echo "PATH=$path" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
Write-Output $path
