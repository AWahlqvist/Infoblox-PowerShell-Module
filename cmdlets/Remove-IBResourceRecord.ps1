function Remove-IBResourceRecord
{

    <#
    .SYNOPSIS
    Removes a host record from the Infoblox Gridserver

    .DESCRIPTION
    This cmdlet removes a host object from the Infoblox Gridserver.

    .EXAMPLE
    Get-InfoBloxRecord -RecordType host -RecordName MyHost -GridServer myinfoblox.mydomain.com -Credential $Credential -Passthrough | Remove-InfoBloxRecord

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
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string] $GridServer,
    [Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [System.Management.Automation.PSCredential] $Credential)

    BEGIN { }

    PROCESS {
        $InfobloxURI = "https://$GridServer/wapi/v1.2.1/$Reference"

        $WebReqeust = Invoke-WebRequest -Uri $InfobloxURI -Method Delete -Credential $Credential

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
