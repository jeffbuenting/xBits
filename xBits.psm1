<#
    .Synopsis
        bit transfer dsc resource

#>

Enum Ensure {
    Present
    Absent
}

[DscResource()]
Class xBitTransfer {

    [Parameter (Mandatory = $True)]
    [DSCProperty(Key)]
    [String]$Url

    [Parameter (Mandatory = $True)]
    [DSCProperty()]
    [String]$FileName
    
    [DSCProperty()]
    [Bool]$Asynchronous = $False

    [DSCProperty()]
    [ValidateSet ( 'Basic','Digest','NTLM','Negotiate','Passport' )]
    [String]$Authentication = 'Negotiate'

    [DSCProperty()]
    [PSCredential]$Credential

    [DSCProperty()]
    [String]$Description = $FileName

    [Parameter (Mandatory = $True)]
    [DSCProperty()]
    [String]$Destination

    [DSCProperty()]
    [String]$DisplayName = $FileName

    [DscProperty()]
    [ValidateSet ( 'High','Foreground','Normal','Low' ) ]
    [String]$Priority = 'Normal'

    [DscProperty()]
    [ValidateSet ( 'Basic','Digest','NTLM','Negotiate','Passport' ) ]
    [String]$ProxyAuthentication = 'Negotiate'

    [DSCProperty()]
    [Ensure]$Ensure


    [Bool]Test() 
    {

        $Present = Test-Path -Path "$($This.Destination)\$($This.fileName)"

        if ( $This.Ensure ) 
        {
            Return $Present
        }
        Else {
            Return -Not $Present
        }
    }

    [xBitTransfer]Get() 
    {
        $present = Test-Path -Path "$($This.Destination)\$($This.fileName)"

        if ($present)
        {
            $file = Get-Item -Path "$($This.Destination)\$($This.fileName)"
            $this.FileName = $File.Name
            $this.Ensure = [Ensure]::Present
        }
        else
        {
            $this.Ensure = [Ensure]::Absent
        }

        return $this
    }

    [Void]Set() 
    {
        if ( $This.Credential ) 
        {
            Write-Verbose "Downloading via Bits with Credential"
            Start-BitsTransfer -source $This.Url `
                -Destination $This.Destination `
                -Asynchronous:$This.Asynchronous `
                -Authentication $This.Authentication `
                -Credential $This.Credential `
                -Description $This.Description `
                -DisplayName $This.DisplayName `
                -Priority $This.Priority `
        }
        Else 
        {
            Write-Verbose "Downloading via Bits"
            Start-BitsTransfer -source $This.Url `
                -Destination $This.Destination `
                -Asynchronous:$This.Asynchronous `
                -Authentication $This.Authentication `
                -Description $This.Description `
                -DisplayName $This.DisplayName `
                -Priority $This.Priority 
        }              
    }
}