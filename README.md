# Description

Create JWT in PowerShell easily.

Supported algorithms: HS256, HS384, HS512, RS256, RS384, RS512

# Install

```powershell
Install-Module powershell-jwt
```

# Usage

Please see the `example` directory for a quick example

# Missing functionality

Right now you can only create a JWT.

TODO: ability to verify and decode a JWT.

# Shout outs

This modules was inspired by:

* https://www.reddit.com/r/PowerShell/comments/8bc3rb/generate_jwt_json_web_token_in_powershell/

    This code supports only HMAC algorithms, but it was a great starting point

* [posh-jwt](https://github.com/SP3269/posh-jwt)

    This module supports only RS256 and it's hard to use with plain PEMs

By the power of these two projects combined, and using [BAMCIS.Crypto](https://github.com/bamcisnetworks/BAMCIS.Crypto)
to convert a PEM to an `RSACryptoServiceProvider` object, you now have an easy way to generate a more flexible JWT in PowerShell.
