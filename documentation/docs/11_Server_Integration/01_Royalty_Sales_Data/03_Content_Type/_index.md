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