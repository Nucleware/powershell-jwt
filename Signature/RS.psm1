Function Get-SignatureRS {
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
        "RS256" {[Security.Cryptography.HashAlgorithmName]::SHA256}
        "RS384" {[Security.Cryptography.HashAlgorithmName]::SHA384}
        "RS512" {[Security.Cryptography.HashAlgorithmName]::SHA512}
        Default {Write-Error 'Unsupported algorithm: ' + $Algorithm}
    }

    $rsa = ConvertFrom-PEM -PEM ([System.Text.Encoding]::UTF8.GetString($SecretKey))

    $Signature = [Convert]::ToBase64String(
        $rsa.SignData(
            [System.Text.Encoding]::UTF8.GetBytes($ToBeSigned),
            $SigningAlgorithm,
            [Security.Cryptography.RSASignaturePadding]::Pkcs1
        )
    ).Split('=')[0].Replace('+', '-').Replace('/', '_')

    $Signature
}
