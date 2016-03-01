### Security (JOSE)

All Lyric API calls use [JWS](https://tools.ietf.org/html/rfc7515)/[JWE](https://tools.ietf.org/html/draft-ietf-jose-json-web-encryption-40) for message level security.
All http messages used by the API expect JWE compact serialization.

#### Signature

All JWE's must have a header called SIGNATURE which contains a JWS signed with your private key. The content of the JWS is a SHA256 hash of the content.

    hash = sha256(csvData)
    jws.setPayload(hash)
    jws.setKey(myPrivateKey)
    jws.setKeyId(myPrivateKeyId)

    jwe.setHeader(SIGNATURE, jws.compact())

Messages will be rejected of the content SHA256 hash does not match the value in the JWS.

#### KeyId

As shown previously you must set the "kid" header of the JWS and JWE objects. For the JWS the keyID will be created in the Lyric
[key management tool](https://integrationservices.lyricfinancial.com/key-management/#/keys). The keyId to use for JWE's is associated with Lyric's key. For now, use "lyric-03-2016"

#### Payload

Just set the payload and content type header before creating the JOSE object.

    jwe.setPayload(csvData)
    jwe.setContentType("text/csv")

    http.post(jwe.compact())

The data should be signed, then encrypted.

#### Compression

If you are sending royalty data either embedded or as form-data/multipart (text or attachment) it is highly recommended to
enable compression using JWE. Lyric supports DEFLATE. This is set with the "zip" JWE header. If you are using a library for
JWE, make sure it supports compression.

Alternatively you can attach a zip or tar archive to compress the payload.