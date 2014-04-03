function Add-IBResourceRecordA
{

    <#
    .SYNOPSIS
    Adds a A record on the Infoblox Gridserver

    .DESCRIPTION
    This cmdlet creates a CName record on the Infoblox Gridserver.

    .EXAMPLE
    Add-IBResourceRecordCName -IPv4Address 1.2.3.4 -HostName myserver.mydomain.com -GridServer myinfoblox.mydomain.com -Credential $Credential

    .PARAMETER IPv4Address
    The IPv4 address for the host record. Allows pipeline input.

    .PARAMETER HostName
    The hostname for the host record. Allows pipeline input.

    .PARAMETER GridServer
    The name of the infoblox appliance. Allows pipeline input.

    .PARAMETER Credential
    Add a Powershell credential object (created with for example Get-Credential). Allows pipeline input.

    #>

    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    $IPv4Address,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('name')]
    $HostName,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string] $GridServer,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [System.Management.Automation.PSCredential] $Credential)

    BEGIN { }

    PROCESS {

        $InfobloxURI = "https://$GridServer/wapi/v1.2.1/record:a"

        $Data = "{`"ipv4addr`":'$IPv4Address',`"name`":'$HostName'}" | ConvertFrom-Json | ConvertTo-Json

        $WebReqeust = Invoke-WebRequest -Uri $InfobloxURI -Method Post -Body $Data -ContentType "application/json" -Credential $Credential

        if ($WebReqeust.StatusCode -ne 201) {
            Write-Error "Request to Infoblox failed for record $HostName!"
            return
        }
    }

    END { }
}
