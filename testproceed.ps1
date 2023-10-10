$isoFile = 'C:\Users\olivier.himblot\Downloads\SERVER_EVAL_x64FRE_en-us.iso'
$vmName = 'test'
$pass = 'Denver26'

.\New-VMFromWindowsImage.ps1 -SourcePath $isoFile -Edition 'Windows Server 2022 Standard Evaluation (Desktop Experience)' -VMName $vmName -VHDXSizeBytes 120GB -AdministratorPassword $pass  -Version 'Server2022Standard' -MemoryStartupBytes 4GB -VMProcessorCount 4
Write-Verbose 'création vm sesion'
$sess = .\New-VMSession.ps1 -VMName $vmName -AdministratorPassword $pass
Write-Verbose 'activation remote management'
.\Enable-RemoteManagementViaSession.ps1 -Session $sess

# You can run any commands on VM with Invoke-Command:
Invoke-Command -Session $sess { 
    Write-Output "Hello, world! (from $env:COMPUTERNAME)"

    # Install chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Install soft
    choco install 7zip -y
    choco install mariadb.install -y
    choco install mariadb
    Install-WindowsFeature -name Web-Server -IncludeManagementTools #install IIS
    choco install php-manager -y
}

Remove-PSSession -Session $sess