$project = ".\PizzaApi.csproj"

[xml]$xmlDoc = Get-Content $project

$projectVersionString = $xmlDoc.Project.PropertyGroup.Version
$projectVersionNumber = $projectVersionString -replace "\."

# Get the current version of the latest public NuGet package
$url = "https://api.nuget.org/v3/registration5-semver1/pizzaapi/index.json"
$nugetIndex = Invoke-RestMethod -Uri $url -Method Get
$currentPublishedVersionString = $nugetIndex.items[0].upper
$currentPublishedVersionNumber = $currentPublishedVersionString -replace "\."

if ($projectVersionNumber -le  $currentPublishedVersionNumber) {
	Write-Error "The version number has not been incremented. Aborting build."
	Exit 1
}
else {
	Write-Host "Validated that the version has been updated from $currentPublishedVersionNumber to $projectVersionNumber" -ForegroundColor Green
}
