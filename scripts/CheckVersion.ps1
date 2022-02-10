
<#
.Synopsis
    Check if version has been bumped
.Description
    Check if the project version has been bumped by comparing current project version 
	with what is publised on nuget.org
.Parameter projectVersion
    Current project version
#>

Param(
	[parameter(Mandatory = $true)]
	[string]$projectVersion
)

$packageName = "pizzaapi"

# Cast the project version string to System.Version
[version]$currentProjectVersion = $projectVersion

# API is case-sensitive
$packageName = $packageName.ToLower()
$url = "https://api.nuget.org/v3/registration5-semver1/$packageName/index.json"

# Call the NuGet API for the package and get the current published version.
$nugetIndex = Invoke-RestMethod -Uri $url -Method Get
$publishedVersionString = $nugetIndex.items[0].upper

# Cast the published version string to System.Version
[version]$currentPublishedVersion = $publishedVersionString

# Validate that the version number has been updated.
if ($currentProjectVersion -le $currentPublishedVersion) {
    Write-Error "The project version in versioning.props file ($projectVersion) `
    has not been bumped up. The current published version is $publishedVersionString. `
    Please increment the current project version."
}
else {
    Write-Host "Validated that the version has been updated from $publishedVersionString to $currentProjectVersion" -ForegroundColor Green
}
