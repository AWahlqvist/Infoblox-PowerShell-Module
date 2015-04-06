function Get-IBResourceRecord
{

    <#
    .SYNOPSIS
    Retrieves resource records from a Infoblox Gridserver

    .DESCRIPTION
    Specify an attribute to search for, for example hostname and retrieve the object from the Gridserver

    .EXAMPLE
    Get-InfoBloxRecord -RecordType host -RecordName MyServer -GridServer myinfoblox.mydomain.com -Credential $Credential

    .EXAMPLE
    Get-InfoBloxRecord -RecordType network -RecordName 1.0.0.0/8 -GridServer myinfoblox.mydomain.com -Credential $Credential -Passthrough

    .PARAMETER RecordType
    Specify the type of record, for example host or network.

    .PARAMETER SearchField
    The field where the RecordValue is. Default is "Name".

    .PARAMETER RecordValue
    The value to search for.

    .PARAMETER GridServer
    The name of the infoblox appliance.

    .PARAMETER Properties
    What properties should be included?

    .PARAMETER Credential
    Add a Powershell credential object (created with for example Get-Credential).

    .PARAMETER Passthrough
    Includes credentials and gridserver in the object sent down the pipeline so you don't need to add them in the next cmdlet.

    #>

    [CmdletBinding()]

    param(
    [Parameter(Mandatory=$True)]
    [ValidateSet("A","AAAA","CName","DName","DNSKEY","DS","Host","LBDN","MX","NAPTR","NS","NSEC","NSEC3","NSEC3PARAM","PTR","RRSIG","SRV","TXT")]
    [string] $RecordType,
    [Parameter(Mandatory=$false)]
    $SearchField = 'name',
    [Parameter(Mandatory=$True)]
    $RecordValue,
    [Parameter(Mandatory=$True)]
    $GridServer,
    [Parameter(Mandatory=$false)]
    $Properties,
    [switch] $Passthrough,
    [Parameter(Mandatory=$True)]
    $Credential)

    BEGIN { }

    PROCESS {

        Write-Verbose "Building resource record search query..."
        $InfobloxURI = "https://$GridServer/wapi/v1.2.1/record:$($RecordType.ToLower())`?$($SearchField.ToLower())~=$RecordValue"

        if ($Properties -ne $null) {
            Write-Verbose "Adding return fields/properties..."
            $InfobloxURI = $InfobloxURI + "&_return_fields=$(($Properties -join "," -replace " ").ToLower())"
        }

        Write-Verbose "Initiating webrequest to API..."

        $WebRequest = Invoke-WebRequest -Uri $InfobloxURI -Credential $Credential

        Write-Verbose "Checking status code..."

        if ($WebRequest.StatusCode -eq 200) {
            Write-Verbose "Statuscode OK. Converting from Json..."
            $RecordObj = $WebRequest.Content | ConvertFrom-Json -ErrorAction Stop
        }
        else {
            Write-Error "Request to Infoblox failed (response code is not 200). See error above for details."
            Write-Debug "Request just failed (response not 200 or Json version failed). Please debug."
            return
        }


        Write-Verbose "Looping through returned objects..."

        foreach ($Record in $RecordObj) {

            $returnObject = $null
            $returnObject = $Record

            if ($Passthrough -eq $true) {
                Write-Verbose "Adding credentials/gridserver to the pipeline..."
                $returnObject | Add-Member -Type NoteProperty -Name Credential -Value $Credential
                $returnObject | Add-Member -Type NoteProperty -Name GridServer -Value $GridServer
            }

            Write-Verbose "Sending object to the pipeline..."
            Write-Output $returnObject
        }
    }

    END {
        Write-Verbose "Finished."
    }

}

