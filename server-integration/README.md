# Server Integration Guide

When a client requests a vATM advance the partner's server will share client data with Lyric. Lyric uses this data to calculate advance limits.

Lyric's primary [Vendor API](https://api.lyricfinancial.com/docs/vendor-api/) uses JSON via REST endpoints. Usually, partners use Lyric's
Registration API which sends Lyric names, phones, address, and bank information. You can also send royalty earning and distribution data in this same
API call. Lyric requires the previous three years of earnings data. There are several methods of sending this data.

## Royalty Data

Royalty data can either be embedded in the JSON payload or sent using form-data/multipart as a separate attachment alongside the primary JSON used
by the API. Lyric supports earnings data in CSV format, Google Protobuf format, or as raw JSON. When using form-data/multipart CSV files or Google protobuf
files may also be archived in ZIP or TAR files. Lyric recommends Protobuf files as they will be more compact than CSV/JSON and require less parsing.

### Options

Throughout this spec, options are described when available. These options are set using JWT/JWS/JWE headers. Some options can be defaulted for an entire request using
standard http headers.

### Security (JOSE)

All Lyric API calls use [JWS](https://tools.ietf.org/html/rfc7515)/[JWE](https://tools.ietf.org/html/draft-ietf-jose-json-web-encryption-40) for message level security.
All http messages used by the API expect JWE compact serialization wrapping JWS compact serialization as payload. I.e.

    request = {}
    jws = makeJWS(request).compact()
    jwe = makeJWE(jws).compact()

The data should be signed, then encrypted. All other encoding, e.g. gzip compression should be done before sign/encrypt.

#### JOSE Objects

All messages exchanged with the Lyric API are sent as nested JWE/JWS objects. The payload of the JWS is the message content. And the JWS "cty" (Content-Type)
header tells the API what type of data to expect. The payload should be Base64 encoded using UTF8 charset.

### Compression

If you are sending royalty data either embedded or as form-data/multipart (text or attachment) it is highly recommended to
use GZIP encoding. You will set the Content-Encoding header on the JWS to tell the API that data is GZIP encoded:

  - **content-encoding** - (String) gzip

Alternatively you can attach a zip or tar archive.


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

Royalty data is attached in a field named "royaltyEarnings". The attachment can be csv data, protobuf data, or a zip/tar file. If just sending csv or protobuf data,
this data should be Gzip encoded first. You can send multiple instances of "royaltyEarnings" in any combination of "text field" and/or "file attachment". The Lyric API
supports quite a few combinations and it can be hard to keep straight. Here's a summary of each:

#### form-data/multipart text/field

Here, the raw data is optionally compressed first. See [Compression](#compression). These bytes are then Base64 encoded and stored as the payload of the JOSE object. This
JOSE object is then sent in the text field using compact serialization.

    jws = makeJWS(protoData)
    jws.setContentType("application/protobuf")
    jwe = makeJWE(jws)
    http.setMultipartField("royaltyEarnings", jwe.compact())

#### form-data/multipart attachments

Multipart attachments are parsed using standard HTTP protocols. These attachments are JOSE objects and must specify the application/jose Content-Type.

Http transparently accounts for encoding (Content-Transfer-Encoding), so assuming your http client library is up to snuff, there should be no need for extra encoding.

#### Zip/tar archives

If the JOSE object cty header is zip, tar, or x-tar, the API will process each entry in the archive. All entries in the archive must be the same content-type. To tell the API
what Content-Type the archive entries are, use the lyric-archive.item-content-type header on the JOSE object. I.e.

    jws.setPayload(zip)
    jws.setHeader("lyric-archive.item-content-type", "application/protobuf")

In some scenarios if you preprocess data, it might be desirable to store individual items encrypted/signed/compressed. Therefore, the API also supports lyric-archive.item-content-type
of application/jose. Since the data is already compressed, using a zip/tar archive might just slightly more convenient for some.

### Embedding in JSON payload

This is a non-"form-data/multipart" option.

Status: In progress

See the [API spec](https://api.lyricfinancial.com/docs/vendor-api/) for more detail.

The "royaltyEarnings" field will support embedding encoded CSV data, Google Protobuf data, and possibly plain JSON. When embedding CSV and protobuf data
the data should first be Gzip encoded and then Base64 encoded.

Example:

    Coming once we support embedding

### Working with CSV data

CSV data must follow predefined schemas.

  - [Standard Distributor Schema](https://api.lyricfinancial.com/specs/v1/StandardDistributor.csvschema)

Column order is dictated by the "schema".

The Standard Distributor Schema is the default. To specify CSV data in a different schema, see option ***lyric-csv.schema***.

#### Options

These options are set on the JOSE JWS object headers. To apply defaults for all CSV files in a request, you can also set HTTP headers.

  - **lyric-csv.schema** - (String) Named schema to indicate CSV data in a different format.
  - **lyric-csv.column-separator** - (String) Single character to indicate the column separator used. Default is ",". I.e. ("|", or "\t").
  - **lyric-csv.use-header** - (Boolean) Indicate of CSV data includes header row. Default true.

### Working with Protobuf data

The protobuf schema file:

  - [RoyaltyEarnings.proto](https://api.lyricfinancial.com/specs/v1/RoyaltyEarnings.proto)

You can send Lyric either a single aggregate RoyaltyEarnings message which combines multiple DistributionGrouping messages together. Or, it might
be more convenient to prebuild DistributionGrouping messages and store these separately as DistributionGrouping messages are bound by a period of time.
Sending multiple DistributionGrouping messages is preferred as the API can process the data more concurrently.

### Using zip/tar archives to send multiple files

A zip/tar archive makes it easy to eagerly prepare data in batches to reduce the "work overhead" required during a vATM handoff. Zip/tar archives can be attached
using the form-data/multipart API and the "royaltyEarnings" field. By default, the API assumes that all files in an archive are CSV data. Use the following option to
tell the API to expect protobuf files instead:

  - **lyric-archive.item-content-type** - (String) [text/csv | application/protobuf] Default: text/csv
