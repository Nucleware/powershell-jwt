# Powershell JWT module

## Description

Create, validate and decode JWT in PowerShell easily.

Supported algorithms:

- Symmetric Key
  - HS256
  - HS384
  - HS512
- Asymmetric Key
  - RS256
  - RS384
  - RS512

## Install

This module is published on the [PowerShell Gallery](https://www.powershellgallery.com/packages/powershell-jwt/)

To install it, you can run the following command:

```powershell
Install-Module powershell-jwt
```

To update an installed version of the module, you can run the following command:

```powershell
Update-Module powershell-jwt
```

## Usage

Please see the [example](./example) directory for a quick example

There are two functions: `New-JWT` and `Confirm-JWT` and you can use them to create or validate and decode JWT.

### Import this module

```powershell
Import-Module 'powershell-jwt'
```

### `New-JWT`

Create a signed JWT token.

```powershell
New-JWT
  -Algorithm <string>
  -SecretKey <byte[]>
  [-Type <string>]
  [-Issuer <string>]
  [-ExpiryTimestamp <int64> (UNIX timestamp in seconds)]
  [-HeaderClaims <hashtable>]
  [-PayloadClaims <hashtable>]
```

| Parameter | Description |
| --- | --- |
| `Algorithm` | The algorithm to be used for the signature |
| `SecretKey` | The key to be used for the signature<br>Must be appropriate for the given `Algorithm` |
| `Type`<br>_Optional_ | (Default: `JWT`) Specify the type of the token |
| `Issuer`<br>_Optional_ | Specify the value of the `iss` claim<br>If provided with this parameter, please do not include the `iss` claim in `PayloadClaims` |
| `ExpiryTimeStamp`<br>_Optional_ | UNIX timestamp (in seconds). Specifies when the token expires.<br>If provided with this parameter, please do not include the `exp` claim in `PayloadClaims`<br>Here are two waits to generate this:<br>1. `$exp = [int64](Get-Date -UFormat %s) + $ValidForSeconds`<br>2. `$exp = ([DateTimeOffset][DateTime]::UtcNow.AddSeconds(300)).ToUnixTimeSeconds()`<br>A warning will be issued if the timstamp is above `1E12`. |
| `HeaderClaims`<br>_Optional_ | A hashtable (dictionary) of claims to add the the token header |
| `PayloadClaims`<br>_Optional_ | A hashtable (dictionary) of claims to add the the token payload |

### `Confirm-JWT`

Decode a JWT and validate its signature

```powershell
Confirm-JWT
  -JWT <string>
  -Key <byte[]>
  [-AcceptedAlgorithm <string>]
```

| Parameter | Description |
| --- | --- |
| `JWT` | And encoded JWT token |
| `Key` | The appropriate symmetric key or public key to be used to verify the signature |
| `AcceptedAlgorithm`<br>_Optional_<br>**Strongly Recommended** | Specify the algorithm that the JWT should have been signed with<br>It is strongly recommended that you do not let the JWT token to specify its signing algorithm, lest you get the problems described by e.g. [CVE-2015-9235](https://nvd.nist.gov/vuln/detail/CVE-2015-9235), [CVE-2016-5431](https://nvd.nist.gov/vuln/detail/CVE-2016-5431), [CVE-2016-10555](https://nvd.nist.gov/vuln/detail/CVE-2016-10555) |

### RSA keys

This module accepts **RSA keys in the PEM format**. If you have a DER format key, you can convert it with this command:

```shell
# convert DER to PEM
openssl x509 -inform der -in private_key.der -out private_key.pem
```

You can extract the public key from a private key with this command:

```shell
# extract public key
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

To generate your own RSA key pairs do something like this:

```shell
# generate private key
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
# extract public key
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

## Code quality 🤦

I apologise for the noob code quality, lack of tests, lack of error handling, and everything else that makes you facepalm,
but nobody else wrote this and I found myself in need of it for a "small" task. Please submit patches.

This is part of my first Powershell project, and it might be my only one for a long while.
I would have avoided Powershell if I could, but it's the only way to interface with MS Exchange Online that does what I need,
and I needed JWT with RSA signatures to interface with another data source.

## Shout outs

This modules was inspired by:

* <https://www.reddit.com/r/PowerShell/comments/8bc3rb/generate_jwt_json_web_token_in_powershell/>

    This code supports only HMAC algorithms, but it was a great starting point

* [posh-jwt](https://github.com/SP3269/posh-jwt)

    This module supports only RS256 and it's hard to use with plain PEMs

By the power of these two projects combined, and using [BAMCIS.Crypto](https://github.com/bamcisnetworks/BAMCIS.Crypto)
to convert a PEM to an `RSACryptoServiceProvider` object, you now have an easy way to use JWT in PowerShell.
