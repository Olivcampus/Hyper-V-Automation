[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [System.Management.Automation.Runspaces.PSSession[]]$Session
)

$ErrorActionPreference = 'Stop'

Invoke-Command -Session $Session { 
    Write-Verbose 'Enable remote administration'
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    Enable-WSManCredSSP -Role server -Force

    
    Write-Verbose ' Default rule is for Local Subnet only. Change to Any .'
    Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -RemoteAddress Any
} | Out-Null
