Function Get-SignatureHS {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Algorithm,

        [Parameter(Mandatory = $True)]
        [System.Byte[]]
        $SecretKey,

        [Parameter(Mandatory = $True)]
        [string]
        $ToBeSigned
    )

    $SigningAlgorithm = switch ($Algorithm) {
        "HS256" {New-Object System.Security.Cryptography.HMACSHA256}
        "HS384" {New-Object System.Security.Cryptography.HMACSHA384}
        "HS512" {New-Object System.Security.Cryptography.HMACSHA512}
        Default {Write-Error -Message ('Unsupported algorithm: ' + $Algorithm)}
    }

    $SigningAlgorithm.Key = $SecretKey
    $Signature = [Convert]::ToBase64String(
        $SigningAlgorithm.ComputeHash(
            [System.Text.Encoding]::UTF8.GetBytes($ToBeSigned)
        )
    ).Split('=')[0].Replace('+', '-').Replace('/', '_')

    $Signature
}

Function Confirm-SignatureHS {
    param (
        [Parameter(Mandatory = $True)]
        [string]
        $Algorithm,

        [Parameter(Mandatory = $True)]
        [System.Byte[]]
        $SecretKey,

        [Parameter(Mandatory = $True)]
        [string]
        $SignedData,

        [Parameter(Mandatory = $True)]
        [string]
        $Signature
    )

    $ComputedSignature = Get-SignatureHS -Algorithm $Algorithm -SecretKey $SecretKey -ToBeSigned $SignedData

    $Signature -eq $ComputedSignature
}
