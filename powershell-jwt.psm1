Function New-JWT {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Algorithm,

        [string]
        $Type = 'JWT',

        [hashtable]
        $HeaderClaims = @{},

        [Parameter(Mandatory = $True)]
        [string]
        $Issuer,

        [Parameter(Mandatory = $True)]
        [int]
        $ExpiryTimestamp,

        [hashtable]
        $PayloadClaims = @{},

        [Parameter(Mandatory = $True)]
        [System.Byte[]]
        $SecretKey
    )

    $header = New-JwtHeader -Algorithm $Algorithm -Type $Type -ExtraClaims $HeaderClaims
    $payload = New-JwtPayload -Issuer $Issuer -ExpiryTimestamp $ExpiryTimestamp -ExtraClaims $PayloadClaims

    $headerBase64 = Convert-HashtableToJsonBase64 -Hashtable $header
    $payloadBase64 = Convert-HashtableToJsonBase64 -Hashtable $payload

    $ToBeSigned = $headerBase64 + "." + $payloadBase64
    $signature = switch -Wildcard ($Algorithm) {
        'HS???' { Get-SignatureHS -Algorithm $Algorithm -SecretKey $SecretKey -ToBeSigned $ToBeSigned }
        'RS???' { Get-SignatureRS -Algorithm $Algorithm -SecretKey $SecretKey -ToBeSigned $ToBeSigned }
        Default { Write-Error -Message ('Unsupported algorithm: ' + $Algorithm) }
    }

    $token = $ToBeSigned + "." + $signature
    $token
}

Function New-JwtHeader {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Algorithm,

        [string]
        $Type = 'JWT',

        [hashtable]
        $ExtraClaims = @{}
    )

    $header = @{
        alg = $Algorithm
        typ = $Type
    } + $ExtraClaims

    $header
}

Function New-JwtPayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Issuer,

        [Parameter(Mandatory = $True)]
        [int]
        $ExpiryTimestamp,

        [hashtable]
        $ExtraClaims = @{}
    )

    $payload = @{
        iss = $Issuer
        exp = $ExpiryTimestamp
    } + $ExtraClaims

    $payload
}

Export-ModuleMember -Function 'New-JWT'
