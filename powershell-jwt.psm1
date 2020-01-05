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

Function Confirm-JWT {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidatePattern('^[^.]+\.[^.]+\.[^.]+$')]
        [string]
        $JWT,

        [Parameter(Mandatory = $True)]
        [System.Byte[]]
        $Key
    )

    $JwtHeaderB64,$JwtPayloadB64,$JwtSignatureB64 = $JWT -split '\.'
    $SignedData = $JwtHeaderB64 + "." + $JwtPayloadB64

    $JwtHeader = Convert-JsonBase64ToHashtable -JsonBase64 $JwtHeaderB64
    $JwtPayload = Convert-JsonBase64ToHashtable -JsonBase64 $JwtPayloadB64

    $Algorithm = $JwtHeader.alg
    $isSignatureValid = switch -Wildcard ($Algorithm) {
        'HS???' { Confirm-SignatureHS -Algorithm $Algorithm -SecretKey $Key -SignedData $SignedData -Signature $JwtSignatureB64 }
        'RS???' { Confirm-SignatureRS -Algorithm $Algorithm -PublicKey $Key -SignedData $SignedData -Signature $JwtSignatureB64 }
        Default { Write-Error -Message ('Unsupported algorithm: ' + $Algorithm) }
    }

    @{
        'header' = $JwtHeader
        'payload' = $JwtPayload
        'isSignatureValid' = $isSignatureValid
    }
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
Export-ModuleMember -Function 'Confirm-JWT'
