# New starter setup Script

#Set Exececution Policy 
$executionpolicy = Get-ExecutionPolicy -Scope LocalMachine
Write-Host "Current Execution Policy is $executionpolicy" -ForegroundColor Magenta
if ($executionpolicy -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    Write-Host "Setting Execution Policy to RemoteSigned" -ForegroundColor Green
}

#Install Chocoaltey
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

#Install Packages
cinst googlechrome git.install slack visualstudiocode chefdk vagrant terraform virtualbox -y




#Install Azure Modules & Nuget Package Provider
if ((Get-PackageProvider -ListAvailable).Name -eq 'NuGet'){
    Write-Host "NuGet Package Provider already installed" -ForegroundColor Magenta
    }
else {
    Install-PackageProvider -Name nuget -Force
    Write-Host "NuGet Package Provider installed" -ForegroundColor Green
}
If ((Get-Module -ListAvailable).Name -like "*Azure*") {
    Write-Host "Azure Modules already installed!" -ForegroundColor Magenta
}
else {
    Install-Module -Name Azure -Force
    Install-Module -Name AzureRM -Force
}


#Set Env Variables for Git & Vagrant
If ((Test-Path -Path 'C:\Program Files\Git') -ne $true) {
    [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Program Files\Git\usr\bin", "Machine")}
else {
    Write-Host "Git not Installed!" -ForegroundColor Magenta
}

If ((Test-Path -Path 'C:\HashiCorp\Vagrant') -and ((Get-ChildItem Env:Path).Value -like "*vagrant*")) {
    [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\HashiCorp\Vagrant\bin", "Machine")}
else {
    Write-Host "Vagrant not Installed!" -ForegroundColor Magenta
}


#Restart Machine to Finish updates

Restart-Computer -Wait -Force{
Write-Host "Restarting $Env:COMPUTERNAME" -ForegroundColor Green
}