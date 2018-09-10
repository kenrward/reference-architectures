Configuration InstallWebProxy
{ 
   param
    (
        [Parameter(Mandatory)]
        [string]$DomainName,
        
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,
        
        [Parameter(Mandatory)]
        [string]$FederationName
    )

    #Import the required DSC Resources
    Import-DscResource -Module xPendingReboot
    
    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $Thumbprint =(Get-ChildItem -DnsName $FederationName -Path cert:\LocalMachine\My).Thumbprint
    
    Node localhost
    {
        WindowsFeature RSAT
        {
             Ensure = "Present"
             Name = "RSAT"
             IncludeAllSubFeature = $true
        }
        
        WindowsFeature WebApplicationProxy
        {
            Ensure = "Present"
            Name = "Web-Application-Proxy"
            IncludeAllSubFeature = $true
        }

        Script InstallWebProxy
        {
            GetScript = {return @{}}
            
            TestScript = { return $false; } # Is always run

            SetScript = 
            {
                Write-Verbose -Message 'Installing Web Application Proxy.';
                Install-WebApplicationProxy -FederationServiceTrustCredential $using:DomainCreds -CertificateThumbprint $using:Thumbprint -FederationServiceName $using:FederationName 
            }
            DependsOn = "[WindowsFeature]WebApplicationProxy"
        }

        xPendingReboot Reboot1
        { 
            Name = "RebootServer"
            DependsOn = @("[Script]InstallWebProxy")
        }
    }
}