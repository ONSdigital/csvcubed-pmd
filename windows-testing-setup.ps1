"""
This script is used to install csv2rdf inside the Windows environment of a GitHub Action Runner.
"""

$path = $env:PATH

$initialWorkingDir = $pwd


Write-Output "=== Installing csv2rdf ==="

Invoke-WebRequest -Uri "https://github.com/Swirrl/csv2rdf/releases/download/0.4.7/csv2rdf-0.4.7-standalone.jar" -OutFile "csv2rdf.jar"
$csv2rdfPath = (Get-Item csv2rdf.jar | Resolve-Path).Path.Substring(38)
Set-Content -Path csv2rdf.bat -Value "@REM Forwarder script`n@echo off`necho Attempting to launch csv2rdf at $csv2rdfPath`njava -jar $csv2rdfPath %*"

$csv2rdfLocation = (Get-Item csv2rdf.bat | Resolve-Path).Path.Substring(38)
echo "CSV2RDF_LOCATION=$csv2rdfLocation" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf8 -Append
Write-Output "csv2rdf location: $csv2rdfLocation"

$path += ";$pwd"
