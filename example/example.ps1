Import-Module 'powershell-jwt'

Function Get-CurrentTimestamp {
    [int](Get-Date -UFormat %s) # Grab Unix Epoch Timestamp
}

Function Get-ExpiryTimeStamp {
    param (
        [int]$ValidForSeconds = 30
    )
    $exp = (Get-CurrentTimestamp) + $ValidForSeconds # Grab Unix Epoch Timestamp and add desired expiration.
    $exp
}

$Issuer = 'example'
$hmacSecret = [Convert]::FromBase64String('kFmnkHSH2E7IZ2HDV9QDDo2jv3tVfqWmRPnqT+y7vfN5O0ZbXc4cnxxhs1TfP0+hFKKAbc2MFwRN75o72M33Pcd2Wt8iBBQvNHXwp1XOUZ0zRTwQ1IO+gJGaVRv0OvSz5aDo+41rq0scZnpUSmR30r9curUUlFKVIHF8mE9NMQJx7ojp1WlJBss8OvIwG2pw/v74S33MkkElZibjEuydrR3k0vPBI7JgQpJjAPeLzzf+gfBZZOgKOS2U9ajLcE5TtAL4Wr8U/AEYDFSct362LlgTx5zMT+BaXQNIcJxxyBnOEIUhcxfykQ1tJrr0T8dG/wrvfkGuaqEzd8eEOkK+bA==')
$rsaPrivateKey = Get-Content "./private_key.pem" -AsByteStream
$rsaPublicKey = Get-Content "./public_key.pem" -AsByteStream

$exp = Get-ExpiryTimeStamp -ValidForSeconds 30
$payloadClaims = @{
    name = "John Smith"
    roles = @(
        'ROLE_READ_DATA'
        'ROLE_WRITE_DATA'
        'ROLE_DELETE_DATA'
    )
}

# using HS256
$jwt1 = New-JWT -Algorithm 'HS256' -Issuer $Issuer -SecretKey $hmacSecret -ExpiryTimestamp $exp -PayloadClaims $payloadClaims
# using RS256
$jwt2 = New-JWT -Algorithm 'RS256' -Issuer $Issuer -SecretKey $rsaPrivateKey -ExpiryTimestamp $exp -PayloadClaims $payloadClaims

Write-Host "HS256 signed token:" $jwt1
Write-Host "RS256 signed token:" $jwt2

$valid1 = Confirm-JWT -JWT $jwt1 -AcceptedAlgorithm 'HS256' -Key $hmacSecret
$valid2 = Confirm-JWT -JWT $jwt2 -AcceptedAlgorithm 'RS256' -Key $rsaPublicKey

Write-Host "HS256 signature is valid:" $valid1.isSignatureValid
Write-Host "HS256 confirmation:" ($valid1 | ConvertTo-Json)

Write-Host "RS256 signature is valid:" $valid2.isSignatureValid
Write-Host "RS256 confirmation:" ($valid2 | ConvertTo-Json)
