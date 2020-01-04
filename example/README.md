# Private key in commit? 🤔

Yes, the keys in this directory are here on purpose.

To generate your own RSA key pairs do something like this:

    openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
    openssl rsa -pubout -in private_key.pem -out public_key.pem
