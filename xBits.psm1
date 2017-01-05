<#
    DSC Class Resource to copy files via Bits Transfer
#>

Enum Ensure {
    Present
    Absent
}

[DscResource()]
Class xBitsTransfer {

    # ----- Path / web address to the file
    [DSCProperty(Mandatory)]
    [String]$Url

    # ----- Name of the file that combines with URL for the full path to the source.
    [DSCProperty(Key)]
    [String]$FileName
    
    [DSCProperty()]
    [Bool]$Asynchronous = $False

    [DSCProperty()]
    [ValidateSet ( 'Basic','Digest','NTLM','Negotiate','Passport' )]
    [String]$Authentication = 'Negotiate'

    [DSCProperty()]
    [PSCredential]$Credential

    [DSCProperty()]
    [String]$Description 

    [DSCProperty(Mandatory)]
    [String]$Destination

    [DSCProperty()]
    [String]$DisplayName 

    [DscProperty()]
    [ValidateSet ( 'High','Foreground','Normal','Low' ) ]
    [String]$Priority = 'Normal'

    [DscProperty()]
    [ValidateSet ( 'Basic','Digest','NTLM','Negotiate','Passport' ) ]
    [String]$ProxyAuthentication = 'Negotiate'

    [DSCProperty()]
    [Ensure]$Ensure = 'Present'

    # ----- Test if the file exists.  
    [Bool]Test() 
    {
        
        $Present = Test-Path -Path "$($This.Destination)\$($This.fileName)"

        if ( $This.Ensure -eq 'Present' ) 
        {
            Write-Verbose "We want $($This.Filename) to exist and it does : $Present"
            Return $Present
        }
        Else {
            Write-Verbose "We don't want $($This.Filename) to exist and it doesn't : $(-Not $Present)"
            Return -Not $Present
        }
    }

    # ----- Returns info about the file at the destination if it exists.
    [xBitsTransfer]Get() 
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
            $This.FileName = $Null
            $This.Url = $Null
            $this.Ensure = [Ensure]::Absent
        }

        return $this
    }

    # ----- Performs Bit Transfer if file does not exist at destination
    [Void]Set() 
    {
        Write-Verbose "Downloading File : $($This.fileName), from : $($This.Url), to : $($This.Destination)"

        # ----- Because we get errors with $Null.  Converting $Null to $This.Filename.
        if ( $This.Description -eq $Null ) { $This.Description = $This.FileName }
        if ( $This.DisplayName -eq $Null ) { $This.DisplayName = $This.FileName }

        Write-Verbose "Description : $($This.Description)"
        Write-Verbose "DisplayName : $($This.DisplayName)"
        Write-Verbose "Anychronous : $($This.Asynchronous)"
        Write-Verbose "Authentication : $($This.Authentication)"
        Write-Verbose "Priority : $($This.Priority)"
        Write-Verbose "Url : $($This.Url)"
        Write-Verbose "FileName : $($This.FileName)"
        Write-Verbose "URL/FileName : $($This.Url)/$($This.FileName)"

        if ( $This.Ensure -eq 'Present' ) 
        {
            if ( $This.Credential ) 
            {
                Write-Verbose "Downloading via Bits with Credential"
                Start-BitsTransfer -source "$($This.Url)/$($This.FileName)" `
                    -Destination $This.Destination `
                    -Asynchronous:$This.Asynchronous `
                    -Authentication $This.Authentication `
                    -Credential $This.Credential `
                    -Description $This.Description `
                    -DisplayName $This.DisplayName `
                    -Priority $This.Priority `
                    -ErrorAction Stop `
                    -Verbose
            }
            Else 
            {
                Write-Verbose "Downloading via Bits"
                Start-BitsTransfer -Source "$($This.Url)/$($This.FileName)" `
                    -Destination $This.Destination `
                    -Asynchronous:$This.Asynchronous `
                    -Authentication $This.Authentication `
                    -Description $This.Description `
                    -DisplayName $This.DisplayName `
                    -Priority $This.Priority `
                    -ErrorAction Stop
            }
        }
        Else 
        {
            Write-Verbose "Removing File if it exists $($This.Url)/$($This.Filename)"
            if ( Test-Path -Path $($This.Url)/$($This.Filename) )
            {
                Remove-Item -Path $($This.Url)/$($This.Filename) -Force
            }
        }
    }
}