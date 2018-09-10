Configuration Provision_OnPrem
{
    Param(
            [Parameter(Mandatory)]
            [System.Management.Automation.PSCredential]$SqlUserCredentials
    )

    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName PackageManagementProviderResource, SqlServerDsc, StorageDsc, xPsDesiredStateConfiguration, xPendingReboot
    Import-DscResource -ModuleName xSystemSecurity -Name xIEEsc

    Node localhost {
        PSModule MyPSModule
        {
            Ensure = "Present"
            Name = "SqlServer"
            Repository = "PSGallery"
            InstallationPolicy = "Trusted"
        }

        $packageFolder = "c:\SampleDataFiles"
        $downloadsFolder = Join-Path $packageFolder "\Downloads"
        $logFilesFolder = Join-Path $packageFolder "\Logs"
        $dataFolder = Join-Path $packageFolder "\Data"
        $projectFolder = Join-Path $packageFolder "\reference-architectures"

        # AzCopy
        $azCopyLogPath = Join-Path $logFilesFolder "\azcopy_log.txt"
        $azCopyDownloadUri = "http://aka.ms/downloadazcopy"
        $azCopyMsiPath = Join-Path $downloadsFolder "\MicrosoftAzureStorageTools.msi"
        $azCopyPath = "c:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"

        # SQL Server Data Tools
        $ssdtLogPath = Join-Path $logFilesFolder "\ssdt_log.txt"
        $ssdtIsoDownloadUri = "https://go.microsoft.com/fwlink/?linkid=863443&clcid=0x409"
        $ssdtIsoPath = Join-Path $downloadsFolder "\ssdt.iso"

        # Git for Windows
        $gitLogPath = Join-Path $logFilesFolder "\git_log.txt"
        $gitDownloadUri = "https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/Git-2.16.2-64-bit.exe"
        $gitInstallerPath = Join-Path $downloadsFolder "\GitInstall.exe"

        # Wide World Importers Database Backup
        $wwiDownloadUri = "https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak"
        $wwiBakPath = Join-Path $downloadsFolder "\WideWorldImporters-Full.bak"
        $databaseName = "WideWorldImporters"

        # Power BI Desktop
        $powerBILogPath = Join-Path $logFilesFolder "\powerbi_log.txt"
        $powerBIDownloadUri = "https://go.microsoft.com/fwlink/?LinkId=521662&clcid=0x409"
        $powerBIMsiPath = Join-Path $downloadsFolder "\PowerBIDesktop.msi"

        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            ConfigurationMode = "ApplyOnly"
        }

        # Create directory structure
        File PackageFolder
        {
            Ensure = "Present"  
            Type = "Directory" 
            Recurse = $false
            DestinationPath = $packageFolder
        }

        File LogsFolder
        {
            Ensure = "Present"  
            Type = "Directory" 
            Recurse = $false
            DestinationPath = $logFilesFolder
            DependsOn = "[File]PackageFolder"
        }

        File DownloadsFolder
        {
            Ensure = "Present"  
            Type = "Directory" 
            Recurse = $false
            DestinationPath = $downloadsFolder
            DependsOn = "[File]PackageFolder"
        }

        # Create the directory for the database files
        File DataFolder
        {
            Ensure = "Present"  
            Type = "Directory" 
            Recurse = $false
            DestinationPath = $dataFolder
            DependsOn = "[File]PackageFolder"
        }

        # Disable Protected Mode so the sign-in experience to Azure Analysis Services is easier
        xIEEsc DisableIEEscAdmin
        {
            IsEnabled = $false
            UserRole = "Administrators"
        }

        # Add the default AzCopy install directory to PATH to make things easier
        Environment AddAzCopyToPath
        {
            Name = "Path"
            Ensure = "Present"
            Path = $true
            Value = $azCopyPath
        }

        # Download AzCopy MSI
        xRemoteFile AzCopyDownload
        {
            Uri             = $azCopyDownloadUri
            DestinationPath = $azCopyMsiPath
            MatchSource = $false
            DependsOn = "[File]DownloadsFolder"
        }

        # Download Sql Server Data Tools ISO
        xRemoteFile SSDTIsoDownload
        {
            Uri = $ssdtIsoDownloadUri
            DestinationPath = $ssdtIsoPath
            MatchSource = $false
            DependsOn = "[File]DownloadsFolder"
        }

        # Download Git for Windows
        Script GitDownload
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Downloading $Using:gitDownloadUri to $Using:gitInstallerPath"
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                Invoke-WebRequest -Uri $Using:gitDownloadUri -OutFile $Using:gitInstallerPath
            }
            TestScript = {
                Write-Verbose "Finding '$Using:gitInstallerPath'"
                $fileExists = Test-Path $Using:gitInstallerPath
                if ($fileExists) {
                    Write-Verbose "DestinationPath: '$Using:gitInstallerPath' is existing file on the machine"
                }

                return $fileExists
            }
            DependsOn = "[File]DownloadsFolder"
        }

        # Download Wide World Importers OLTP database backup
        Script DownloadWWIBackup
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Downloading $Using:wwiDownloadUri to $Using:wwiBakPath"
                [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
                Invoke-WebRequest -Uri $Using:wwiDownloadUri -OutFile $Using:wwiBakPath
            }
            TestScript = {
                Write-Verbose "Finding '$Using:wwiBakPath'"
                $fileExists = Test-Path $Using:wwiBakPath
                if ($fileExists) {
                    Write-Verbose "DestinationPath: '$Using:wwiBakPath' is existing file on the machine"
                }

                return $fileExists
            }
            DependsOn = "[File]DownloadsFolder"
        }

        # Download Power BI Desktop MSI
        xRemoteFile PowerBIDownload
        {
            Uri = $powerBIDownloadUri
            DestinationPath = $powerBIMsiPath
            MatchSource = $false
            DependsOn = "[File]DownloadsFolder"
        }

        # Install Git for Windows
        Script GitInstall
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Installing Git for Windows"
                Start-Process -Wait -FilePath "$Using:gitInstallerPath" `
                    -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES", "/LOG=`"$Using:gitLogPath`"", "/NOCANCEL", "/NORESTART"
                # The installer just exits so we can't wait on it.  We'll sleep for a minute and a half and send the broadcast.
                # This usually takes ~30 seconds to run
                Start-Sleep -Seconds 90
            }
            TestScript = {
                Write-Verbose "Finding Git for Windows"
                $gitExists = Test-Path "C:\Program Files\Git"
                if ($gitExists) {
                    Write-Verbose "Git for Windows found"
                }

                return $gitExists
            }
            Credential = $SqlUserCredentials
            DependsOn = @("[Script]GitDownload", "[File]LogsFolder")
        }

        # Clone our repo
        Script CloneProject
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                $gitPath = "C:\Program Files\Git\cmd\git.exe"
                Write-Verbose "Cloning project..."
                Start-Process -Wait -FilePath $gitPath -ArgumentList "clone", "https://github.com/mspnp/reference-architectures.git", `
                    "--branch", "master", "--depth", "1", "--single-branch", "--no-checkout" -WorkingDirectory $Using:packageFolder
                Start-Process -Wait -FilePath $gitPath -ArgumentList "config", "core.sparseCheckout", "true" -WorkingDirectory $Using:projectFolder
                "data/*" | Out-File -Encoding ascii (Join-Path $Using:projectFolder "\.git\info\sparse-checkout")
                Start-Process -Wait -FilePath $gitPath -ArgumentList "checkout", "master" -WorkingDirectory $Using:projectFolder
            }
            TestScript = {
                Write-Verbose "Finding project directory"
                $cloneExists = Test-Path $Using:projectFolder
                if ($cloneExists) {
                    Write-Verbose "Project directory found"
                }

                return $cloneExists
            }
            DependsOn = @("[Script]GitInstall", "[File]PackageFolder")
        }

        Script RestoreWWI
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Restoring database '$Using:databaseName'"
                # Get the list of files for the database, re-path them, and create the RelocateFile objects for the Restore-SqlDatabase cmdlet
                $relocateFiles = Invoke-Sqlcmd -Query "RESTORE FILELISTONLY FROM DISK = '$Using:wwiBakPath'" | `
                    Select-Object -Property LogicalName,@{Name="PhysicalName"; Expression = {Join-Path $Using:dataFolder (Split-Path $_.PhysicalName -Leaf)}} | `
                    ForEach-Object {New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($_.LogicalName, $_.PhysicalName)}
                Restore-SqlDatabase -ServerInstance $env:ComputerName -Database "$Using:databaseName" -BackupFile $Using:wwiBakPath -RelocateFile $relocateFiles
                Invoke-Sqlcmd -InputFile (Join-Path $Using:projectFolder "\data\enterprise_bi_sqldw\onprem\sql_scripts\GetDateDimensions.sql")
            }
            TestScript = {
                Write-Verbose "Finding database '$Using:databaseName' on server instance '$env:ComputerName'"
                Get-SqlDatabase -ServerInstance $env:ComputerName -Name "$Using:databaseName" -ErrorAction SilentlyContinue | `
                    Tee-Object -Variable databaseExists | Out-Null
                if ([bool]$databaseExists) {
                    Write-Verbose "Database: '$Using:databaseName' exists"
                } else {
                    Write-Verbose "Database: '$Using:databaseName' does not exist"
                }
                return [bool]$databaseExists
            }
            DependsOn = @("[File]DataFolder", "[Script]DownloadWWIBackup", "[Script]CloneProject")
            PsDscRunAsCredential = $SqlUserCredentials
        }

        # Install AzCopy
        Script AzCopyInstall
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Installing AzCopy"
                Start-Process -Wait -FilePath "c:\Windows\System32\msiexec.exe" `
                    -ArgumentList "/package `"$Using:azCopyMsiPath`"", "/qn", "/log `"$Using:azCopyLogPath`""
            }
            TestScript = {
                Write-Verbose "Finding AzCopy"
                $exists = Test-Path $Using:azCopyPath
                if ($exists) {
                    Write-Verbose "AzCopy found"
                }

                return $exists
            }
            DependsOn = @("[Script]CloneProject", "[xRemoteFile]AzCopyDownload", "[File]LogsFolder")
        }

        # Mount the SSDT ISO.  We need to wait for the AzCopy install to finish
        # since we will be running an installer
        MountImage MountSsdtIso
        {
            ImagePath = $ssdtIsoPath
            DriveLetter = "Z"
            Ensure = "Present"
            DependsOn = @("[xRemoteFile]SSDTIsoDownload", "[Script]AzCopyInstall")
        }

        # Wait for the ISO to mount
        WaitForVolume WaitForISO
        {
            DriveLetter      = "Z"
            RetryIntervalSec = 5
            RetryCount       = 10
            DependsOn = "[MountImage]MountSsdtIso"
        }

        # Install Sql Server Data Tools.  This isn't a "real" installer, so we need to execute it as a Windows Process
        Script SsdtInstall
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Installing SQL Server Data Tools"
                Start-Process -Wait -FilePath "Z:\SSDTSETUP.EXE" -ArgumentList "INSTALLALL=1", "/silent", "/norestart", "/log `"$Using:ssdtLogPath`""
            }
            TestScript = {
                Write-Verbose "Finding SQL Server Data Tools"
                $ssdtExists = Test-Path "HKLM:\SOFTWARE\Classes\Installer\Dependencies\{f3809ec7-e8e2-4989-98a4-0f68d25f7568}"
                if ($ssdtExists) {
                    Write-Verbose "SQL Server Data Tools found"
                }

                return $ssdtExists
            }
            DependsOn = @("[WaitForVolume]WaitForISO", "[File]LogsFolder")
        }

        # Since the Path and DriveLetter are the key, we can't use the MountImage to do this
        Script UnmountSsdtIso
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Dismount-DiskImage -ImagePath $Using:ssdtIsoPath
            }
            TestScript = {
                $diskImage = Get-DiskImage -ImagePath $Using:ssdtIsoPath
                # If the image is not attached, everything is good
                return -not $diskImage.Attached
            }
            DependsOn = "[Script]SsdtInstall"
        }

        # Install Power BI Desktop
        Script PowerBIDesktopInstall
        {
            GetScript = {
                return @{Result=""}
            }
            SetScript = {
                Write-Verbose "Installing Microsoft Power BI Desktop (x64)"
                Start-Process -Wait -FilePath "c:\Windows\System32\msiexec.exe" `
                    -ArgumentList "/package `"$Using:powerBIMsiPath`"", "/qn", "/log `"$Using:powerBILogPath`"", "/norestart", "ACCEPT_EULA=1"
            }
            TestScript = {
                Write-Verbose "Finding Microsoft Power BI Desktop (x64)"
                $exists = Test-Path "C:\Program Files\Microsoft Power BI Desktop"
                if ($exists) {
                    Write-Verbose "Microsoft Power BI Desktop (x64) found"
                }

                return $exists
            }
            DependsOn = @("[Script]UnmountSsdtIso", "[xRemoteFile]PowerBIDownload", "[File]LogsFolder")
        }

        xPendingReboot RebootAfterInstalls
        {
            Name = "RebootAfterInstalls"
            DependsOn = "[Script]PowerBIDesktopInstall"
        }
    }
}
