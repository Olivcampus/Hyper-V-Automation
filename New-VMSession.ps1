[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$VMName,

    [Parameter(Mandatory=$true)]
    [string]$AdministratorPassword,

    [string]$DomainName
)

if ($DomainName) {
    $userName = "$DomainName\administrator"
} else {
    Write-Verbose 'username administrator'
    $userName = 'administrator'
}
Write-Verbose 'check secure password'
$pass = ConvertTo-SecureString $AdministratorPassword -AsPlainText -Force
Write-Verbose 'save secure password'
$cred = New-Object System.Management.Automation.PSCredential($userName, $pass)

do {
    Write-Verbose 'testing version'
    $result = New-PSSession -VMName $VMName -Credential $cred -ErrorAction SilentlyContinue

    if (-not $result) {
        Write-Verbose "Waiting for connection with '$VMName'..."
        Start-Sleep -Seconds 1
    }
} while (-not $result)
Write-Verbose 'return result'
$result
