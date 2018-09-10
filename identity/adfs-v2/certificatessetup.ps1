Configuration Certificates
{
    Param(
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$AdminCreds
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xStorage, xNetworking, xComputerManagement

    #Step by step to reverse
    #https://www.mssqltips.com/sqlservertip/4991/implement-a-sql-server-2016-availability-group-without-active-directory-part-1/
    #
    #2.1-Create a Windows Failover Cluster thru Powershell
    #    https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/enable-and-disable-always-on-availability-groups-sql-server
    #    https://docs.microsoft.com/en-us/powershell/module/failoverclusters/new-cluster?view=win10-ps
    #    New-Cluster -Name “WSFCSQLCluster” -Node sqlao-vm1,sqlao-vm2 -AdministrativeAccessPoint DNS

    Node localhost
    {
        # $Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer
        # https://go.microsoft.com/fwlink/?LinkId=708343&clcid=0x409

        File DirectoryTemp
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Type = "Directory" # Default is "File".
            Recurse = $false
            DestinationPath = "C:\TempDSCAssets"
            PsDscRunAsCredential = $AdminCreds
        }

        Script GetCerts
        { 
            SetScript = 
            { 
                $webClient = New-Object System.Net.WebClient 
                $uri = New-Object System.Uri "https://lugizidscstorage.blob.core.windows.net/isos/adfs-certs.zip" 
                $webClient.DownloadFile($uri, "C:\TempDSCAssets\adfs-certs.zip") 
            } 
            TestScript = { Test-Path "C:\TempDSCAssets\adfs-certs.zip" } 
            GetScript = { @{ Result = (Get-Content "C:\TempDSCAssets\adfs-certs.zip") } } 
            DependsOn = '[File]DirectoryTemp'
            PsDscRunAsCredential = $AdminCreds
        }

        Archive CertZipFile
        {
            Path = 'C:\TempDSCAssets\adfs-certs.zip'
            Destination = 'c:\TempDSCAssets\'
            Ensure = 'Present'
            DependsOn = '[Script]GetCerts'
            PsDscRunAsCredential = $AdminCreds
        }

        Script SetupCerts
        { 
            SetScript = 
            { 
                Import-Certificate -FilePath "C:\TempDSCAssets\MyFakeRootCertificateAuthority.cer" -CertStoreLocation 'Cert:\LocalMachine\Root' -Verbose
                $password = ConvertTo-SecureString 'AweS0me@PW' -AsPlainText -Force
                Import-PfxCertificate -FilePath "C:\TempDSCAssets\adfs.contoso.com.pfx" -CertStoreLocation 'Cert:\LocalMachine\My' -Password $password
            }
            TestScript = { return $false } 
            GetScript = { @{ Result = {} } } 
            DependsOn = '[Archive]CertZipFile'
            PsDscRunAsCredential = $AdminCreds
        }
    }
}