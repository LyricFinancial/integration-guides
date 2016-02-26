# Server Integration Guide

When a client requests a vATM advance the partner's server will share client data with Lyric. Lyric uses this data to calculate advance limits.

Lyric's primary [Vendor API](https://integrationservices.lyricfinancial.com/docs/vendor-api/) uses JSON via REST endpoints with JOSE message security. Usually, partners use Lyric's
Registration API which sends Lyric name, phone, address, and bank information. You can also send royalty/sales and distribution data in this same
API call. Lyric requires the previous three years of data. There are several methods of sending this data.

## Royalty/Sales Data

Royalty/Sales data can either be embedded in the JSON payload or sent using form-data/multipart as a separate attachment alongside the primary JSON used
by the API. Lyric supports earnings data in CSV format, Google Protobuf format, or as raw JSON. When using form-data/multipart CSV files or Google protobuf
files may also be archived in ZIP or TAR files. Lyric recommends Protobuf files as they will be more compact than CSV/JSON and require less parsing.

### Options

Throughout this spec, options are described when available. These options are set using JWT/JWS/JWE headers. Some options can be defaulted for an entire request using
standard http headers.

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
[key management tool](). The keyId to use for JWE's is associated with Lyric's key. For now, use "lyric-03-2016"

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

### Content-Type

The content type for a request or for each form-data/multipart attachment should be application/jose.

    Content-Type: application/jose

form-data/multipart text fields are assumed to be jose compact serialization.

JOSE objects each define their own internal content-type using the JOSE "cty" header. The possible content-types are:

  - text/csv
  - application/protobuf
  - application/zip
  - application/tar
  - application/x-tar

The JOSE spec recommends only using the "sub part", e.g. "zip" or "csv" when setting this header. The Lyric API supports either or.

### form-data/multipart

Royalty data is attached in a field named "DistributionGrouping". The attachment can be csv data, protobuf data, or a zip/tar file. If just sending csv or protobuf data,
consider using compression when building the JWE. You can send multiple instances of "DistributionGrouping" in any combination of "text field" and/or "file attachment". The Lyric API
supports quite a few combinations and it can be hard to keep straight. Here's a summary of each:

#### form-data/multipart text/field

Here, the raw data is optionally compressed first. See [Compression](#compression). This
JOSE object is then sent in the text field using compact serialization.

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

If the JOSE object cty header is zip, tar, or x-tar, the API will process each entry in the archive. All entries in the archive must be the same content-type. To tell the API
what Content-Type the archive entries are, use the lyric-archive.item-content-type header on the JOSE object. I.e.

    jwe.setPayload(zipData)
    jwe.setHeader("lyric-archive.item-content-type", "application/protobuf")

In some scenarios if you preprocess data, it might be desirable to store individual items encrypted/signed/compressed. Therefore, the API also supports lyric-archive.item-content-type
of application/jose(coming soon). If the data is already compressed, using a zip/tar archive might just be slightly more convenient for some.

### Embedding in JSON payload

This is a non-"form-data/multipart" option.

Status: In progress

See the [API spec](https://integrationservices.lyricfinancial.com/docs/vendor-api/) for more detail.

The "istributionGroupings" field will support embedding encoded CSV data, Google Protobuf data, and possibly plain JSON.

Example:

    Coming once we support embedding

### Working with CSV data

CSV data must follow predefined schemas.

  - [Standard Distributor Schema](https://integrationservices.lyricfinancial.com/specs/v1/StandardDistributor.csvschema)

Column order is dictated by the "schema".

The Standard Distributor Schema is the default. To specify CSV data in a different schema, see option ***lyric-csv.schema***.

    jwe.setPayload(csvData))
    jwe.setContentType("text/csv")
    jwe.setHeader("lyric-csv.schema", "MyCustomSchema")

#### Options

These options are set on the JOSE JWE object headers. To apply defaults for all CSV files in a request, you can also set HTTP headers.

  - **lyric-csv.schema** - (String) Named schema to indicate CSV data in a different format.
  - **lyric-csv.column-separator** - (String) Single character to indicate the column separator used. Default is ",". I.e. ("|", or "\t").
  - **lyric-csv.use-header** - (Boolean) Indicate of CSV data includes header row. Default true.

### Working with Protobuf data

The protobuf schema file:

  - [DistributionGroupingSet.proto](https://integrationservices.lyricfinancial.com/specs/v1/DistributionGroupingSet.proto)

The primary Protobuf message is a DistributionGrouping. This represents a group of distributions for:

  * period
  * store
  * country
  * sale type
  * currency
  * distribution date

You send DistributionGrouping messages in a DistributionGroupingSet message. You are free to create DistributionGroupingSet messages as you please. You might
include one DistributionGrouping per Set or you might bundle up all 36 months of data into a single DistributionGroupingSet. This give you flexibility in how you
prepare distribution data.

API performance will probably be better if you send break data into multiple DistributionGroupingSet messages, as this will allow the API to parse/decode concurrently.

### Using zip/tar archives to send multiple files

A zip/tar archive makes it easy to eagerly prepare data in batches to reduce the "work overhead" required during a vATM handoff. Zip/tar archives can be attached
using the form-data/multipart API and the "DistributionGrouping" field. By default, the API assumes that all files in an archive are CSV data. Use the following option to
tell the API to expect protobuf files instead:

  - **lyric-archive.item-content-type** - (String) [text/csv | application/protobuf] Default: text/csv
