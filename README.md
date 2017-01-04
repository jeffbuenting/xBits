# xBits

Powershell DSC Resource for Bits

The **xBits** module contians the following resources:

- **xBitTransfer**: Copies a file using Bits.

## Resources

###XbitTransfer 
Most of this information can be found on the Start-BitsTransfer Site ( https://technet.microsoft.com/en-us/library/dd819420.aspx
   )
   
- **`[String]` Url** (_Required_):  The address to the file to be copied. 
- **`[String]` FileName** (_Key_):  Name of the file that combines with URL for the full path to the source.
- **`[Bool]` Asynchronous** (_Write_):  Allows the BITS transfer job to be created and then processed in the background. The command prompt reappears immediately after the BITS transfer job is created. The returned BitsJob object can be used to monitor status and progress.  Default = $False
- **`[String]` Authentication** (_Write_) :  Specifies the authentication mechanism to be used at the server. Possible values are:
  -- Basic: Basic is a scheme in which the user name and password are sent in clear text to the server or proxy.  
  -- Digest: Digest is a challenge-response scheme that uses a server-specified data string for the challenge.
  -- NTLM: NTLM is a challenge-response scheme that uses the credentials of the user for authentication in a Windows-based network environment.
  -- Negotiate (the default): Negotiate is a challenge-response scheme that negotiates with the server or proxy to determine which scheme to use for authentication. For example, this parameter value allows negotiation to determine whether the Kerberos protocol or NTLM is used.
  -- Passport: Passport is a centralized authentication service provided by Microsoft that offers a single logon for member sites.
- **`[PSCredential]` Credential** (_Write_): Specifies the credentials to use to authenticate the user at the server. The default is the current user. Type a user name, such as "User01", "Domain01\User01", or "User@Contoso.com". Or, use the Get-Credential cmdlet to create the value for this parameter. When you type a user name, you will be prompted for a password.
- **`[String]` Description** (_Write_):  Describes the BITS transfer job. The description is limited to 1,024 characters.  Default = Filename 
- **`[String]` Destination** (_Required_): Specifies the destination location and the names of the files that you want to transfer.
- **`[String]` DisplayName** (_Write_): Specifies a display name for the BITS transfer job. The display name provides a user-friendly way to differentiate BITS transfer jobs.  Default = Filename
- **`[String]` Priority** (_Write_):  Sets the priority of the BITS transfer job, which affects bandwidth usage. You can specify the following values:
  -- Foreground (default): Transfers the job in the foreground. Foreground transfers compete for network bandwidth with other applications, which can impede the user's overall network experience. However, if the Start-BitsTransfer command is being used interactively, this is likely the best option. This is the highest priority level. 
  -- High: Transfers the job in the background with a high priority. Background transfers use the idle network bandwidth of the client computer to transfer files. 
  -- Normal: Transfers the job in the background with a normal priority. Background transfers use the idle network bandwidth of the client computer to transfer files.
  -- Low: Transfers the job in the background with a low priority. Background transfers use the idle network bandwidth of the client to transfer files. This is the lowest background priority level.
- **`[Ensure]` Ensure** (_Write_): Present -- Ensures the file exists.  Absent -- Ensures the file does not exist.  Default = 'Present' 

## Versions

## Examples
