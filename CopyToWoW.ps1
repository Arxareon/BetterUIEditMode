<# Resources #>

#Main World of Warcraft install directory
$destination = "D:\World of Warcraft\"

#Addons to install
$addons = @()
#List of addon folders to copy from the source folder
$addons += "BetterUIEditMode"
$addons += "WidgetTools"

#Target clients to install to
$clients = @()
#List of client tags used by Blizzard 
$clients += "_retail_" #Dragonflight
$clients += "_ptr_" #Dragonflight PTR
$clients += "_beta_" #Dragonflight Beta

<# Installation #>

#Assemble the paths
$source = Get-Location
$source = Join-Path $source "\[addon]\*"
$destination = Join-Path $destination "[client]\Interface\Addons\[addon]"

#Copy the files
foreach ($addon in $addons) {
	foreach ($client in $clients) {
		#Fill in the paths
		$sourcePath = $source -replace "\[addon\]", $addon
		$destinationPath = $destination -replace "\[client\]", $client -replace "\[addon\]", $addon
		#Install the addon
		if (!(Test-Path -Path $destinationPath)) { New-Item $destinationPath -Type Directory }
		Copy-Item $sourcePath -Destination $destinationPath -Recurse -Force
	}
}