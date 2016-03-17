### form-data/multipart

Royalty data is attached in a field named "DistributionGrouping". The attachment can be csv data, protobuf data, or a zip/tar file. If just sending csv or protobuf data, consider using compression when building the JWE. You can send multiple instances of "DistributionGrouping" in any combination of "text field" and/or "file attachment". The Lyric API supports quite a few combinations and it can be hard to keep straight. Here's a summary of each:

#### form-data/multipart text/field

Here, the raw data is optionally compressed first. See [Compression](#compression). This JOSE object is then sent in the text field using compact serialization.

    hash = sha256(protoData)
    jws.setPayload = hash

    jwe.setContentType("application/protobuf")
    jwe.setHeader(SIGNATURE, jws.compact())
    jwe.enableDeflateCompression()
    jwe.setPayload(protoData)

    http.setMultipartField("DistributionGrouping", jwe.compact())

#### form-data/multipart attachments

Multipart attachments are parsed using standard HTTP protocols. These attachments are JOSE objects and must specify the application/jose Content-Type.

Http transparently accounts for encoding (Content-Transfer-Encoding), so assuming your http client library is up to snuff, there should be no need for extra encoding.

#### Zip/tar archives

If the JOSE object cty header is zip, tar, or x-tar, the API will process each entry in the archive. All entries in the archive must be the same content-type. To tell the API what Content-Type the archive entries are, use the lyric-archive.item-content-type header on the JOSE object. I.e.

    jwe.setPayload(zipData)
    jwe.setHeader("lyric-archive.item-content-type", "application/protobuf")

In some scenarios if you preprocess data, it might be desirable to store individual items encrypted/signed/compressed. Therefore, the API also supports lyric-archive.item-content-type of application/jose(coming soon). If the data is already compressed, using a zip/tar archive might just be slightly more convenient for some.