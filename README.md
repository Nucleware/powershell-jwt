# Powershell JWT module

## Description

Create, validate and decode JWT in PowerShell easily.

Supported algorithms: HS256, HS384, HS512, RS256, RS384, RS512

## Install

```powershell
Install-Module powershell-jwt
```

## Usage

Please see the `example` directory for a quick example

Short version: There are two functions: `New-JWT` and `Confirm-JWT` and you can use them to create or validate and decode JWT.

## Code quality 🤦

I apologise for the noob code quality, lack of tests, lack of error handling, and everything else that makes you facepalm,
but nobody else wrote this and I found myself in need of it for a "small" task. Please submit patches.

This is part of my first Powershell project, and it might be my only one for a long while.
I would have avoided Powershell if I could, but it's the only way to interface with MS Exchange Online that does what I need,
and I needed JWT with RSA signatures to interface with another data source.

## Shout outs

This modules was inspired by:

* https://www.reddit.com/r/PowerShell/comments/8bc3rb/generate_jwt_json_web_token_in_powershell/

    This code supports only HMAC algorithms, but it was a great starting point

* [posh-jwt](https://github.com/SP3269/posh-jwt)

    This module supports only RS256 and it's hard to use with plain PEMs

By the power of these two projects combined, and using [BAMCIS.Crypto](https://github.com/bamcisnetworks/BAMCIS.Crypto)
to convert a PEM to an `RSACryptoServiceProvider` object, you now have an easy way to generate a more flexible JWT in PowerShell.
