# Description: Boxstarter Script
# Author: Alexandre Nedelec
# Common dev settings for full stack development

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";

#--- Tools ---
# TODO add git.config global
# TODO add Windows Terminal


choco install -y visualstudio2019enterprise --package-parameters="'--addProductLang En-us --add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install

#--- Visual Studio Workloads ---
# Azure
choco install -y visualstudio2019-workload-azure
# .Net core development
choco install -y visualstudio2019-workload-netcoretools
# Mobile development
choco install -y visualstudio2019-workload-netcrossplat

# Extensions
# Ozcode
# choco install -y ozcode-vs2017 

# UWP workload and installing WindowsTemplateStudio
# choco install -y visualstudio2019-workload-universal
# executeScript "WindowsTemplateStudio.ps1";
# executeScript "GetUwpSamplesOffGithub.ps1";

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
