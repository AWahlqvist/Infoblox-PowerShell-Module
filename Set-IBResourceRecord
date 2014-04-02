function Set-IBResourceRecord
{

    <#
    .SYNOPSIS
    Changes a host record on the Infoblox Gridserver

    .DESCRIPTION
    This cmdlet changes a host object on the Infoblox Gridserver.

    .EXAMPLE
    Set-InfoBloxRecord -Reference Reference -IPv4Address 1.2.3.4 -HostName myhost.mydomain.com -GridServer myinfoblox.mydomain.com -Credential $Credential

    .EXAMPLE
    Get-InfoBloxRecord -RecordType host -RecordName MyHost -GridServer myinfoblox.mydomain.com -Credential $Credential -Passthrough | Set-InfoBloxRecord -IPv4Address 2.3.4.5

    .PARAMETER IPv4Address
    The new IPv4 address for the host record.

    .PARAMETER HostName
    The new HostName for the host record.

    .PARAMETER Reference
    The object reference for the host record. Allows pipeline input.

    .PARAMETER GridServer
    The name of the infoblox appliance. Allows pipeline input.

    .PARAMETER Credential
    Add a Powershell credential object (created with for example Get-Credential). Allows pipeline input.

    #>

    [CmdletBinding()]
    param(
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('_ref')]
    [string] $Reference,
    [Parameter(Mandatory=$True)]
    [string] $IPv4Address,
    [Parameter(Mandatory=$False)]
    [string] $HostName,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string] $GridServer,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [System.Management.Automation.PSCredential] $Credential)

    BEGIN { }

    PROCESS {
        $InfobloxURI = "https://$GridServer/wapi/v1.2.1/$Reference"

        $Data = "{`"ipv4addrs`":[{`"ipv4addr`":'$IPv4Address'}] }" | ConvertFrom-Json | ConvertTo-Json

        $WebReqeust = Invoke-WebRequest -Uri $InfobloxURI -Method Put -Body $Data -Credential $Credential

        if ($WebReqeust.StatusCode -eq 200) {
            $RecordObj = $WebReqeust.Content | ConvertFrom-Json
        }
        else {
            Write-Error "Request to Infoblox failed!"
            return
        }
    }

    END { }

}
