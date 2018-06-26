<#PSScriptInfo
.SYNOPSIS
Demo script for VirtaMed task
.DESCRIPTION
This script loads the json file to retrieve the jenkins job data
Once the data is loaded, it tries to connec to the jenkins uri with the psd data file
After establishing the connection, it checks for jobs that exist in the jenkins system
Triggers identified jobs with specified parameters.

.GUID dffc3763-3e8a-4036-85e4-78f9543dedba
.AUTHOR Sreejith Mani
.VERSION 1.0
#>
[CmdletBinding()]
param ()
$script:VerbosePreference = 'Continue'
#load modules
&{ Get-Module Jenkins | Remove-Module -Force; Import-Module '.\modules\Jenkins' -Force -ErrorAction Stop }4>$null
#
function Get-SMPSData
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)][string] $PSDFilePath,
        [string] $ConfigName = "Default"
    )
    $PSDPath = Split-Path -Parent $PSDFilePath
    Write-Verbose "Current related Data File Path :$PSDFilePath"
    $data = Get-Content -Raw "$PSDFilePath"
    $scriptblk = [ScriptBlock]::Create($data)
    $op = Invoke-Command -ScriptBlock $scriptblk
    $returndata = $op.$ConfigName
    $returndata
}
#
$appdata = Get-SMPSData -PSDFilePath "$PSScriptRoot\appdata.psd1"
$appdata


#read json data
try {
    $json = Get-Content -Raw -LiteralPath $appdata.JenkinsDataJSON -ErrorAction Stop
    $jsonData = ConvertFrom-Json $json -ErrorAction Stop;
    $validJson = $true;
} catch {
    $validJson = $false;
}
if (-not $validJson) {
    Write-Error "Provided text is not a valid JSON string" -ErrorAction Stop
}
Write-Verbose "Provided json data in file succesfully parse to JSON format"
#
$jobinfo = $jsonData | Get-Member | Where-Object{$_.MemberType -like 'NoteProperty'} | Select-Object Name
#$jobinfo

$jenkinJobs = @{}
try {
    foreach($job in $jobinfo){

        $jobName = $job.Name
        Write-Verbose "Parsing data for $($job.Name)"
        $jobParams = $jsonData.($job.Name) | Get-Member | ?{$_.MemberType -like 'NoteProperty'}
        #
        $paramData =@{}
        foreach($param in $jobParams){
           $paramData.Add($param.Name,$jsonData.($job.name).($param.Name))  
        }
        $jenkinJobs.Add($jobName,$paramData)
    
    }
}
catch {
    Write-Error "Error in parsing json data into powershell data format" -ErrorAction Stop
}
#$jenkinJobs | fl *
#
$passkey = $appdata.JenkinsAPIToken | ConvertTo-SecureString -asPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($appdata.UserName,$passkey)
$crumb = Get-JenkinsCrumb -Uri $appdata.BaseUri -Credential $cred
#$crumb
#
$jenkinJobs.GetEnumerator() | ForEach-Object{ 

    $projectName = $_.Key 
    Write-Verbose "Processing job : $projectName"
    $jobExists = Test-JenkinsJob -Uri $appdata.BaseUri -Credential $cred -Name $projectName
    
    if($jobExists){        
        Write-host "============ Executing job :  $projectName"
        Invoke-JenkinsJob -Uri $appdata.BaseUri -Credential $cred -Name $projectName -Crumb $crumb -Parameters $_.Value      
    }else {
        Write-Warning "============= Jenkins job not found on server. Skipping execution"
    }
    
}


