### Content-Type

The vendor api is primarily a JSON api. However, message bodies are secured with [JOSE](Security) and this requires
a content-type: application/jose. 

    // Standard
    POST /<api> HTTP/1.1
    Content-Type: application/jose

However, during testing (or in a sandbox), you can disable JOSE.

**Steps to Disable JOSE**

  1. Goto [settings](/secure/settings/)
  2. Click Api Configs
  3. Uncheck Jose under Sign/Encrypt and press Save 

If JOSE is disabled, you can use content-type: application/json instead of application/jose.

    // Standard
    POST /<api> HTTP/1.1
    Content-Type: application/json

#### Multipart

When using an API that supports multipart, e.g. /clients.form, the content-type for the request is ALWAYS multipart/form-data.

    // Multipart
    POST /<api> HTTP/1.1
    Content-Type: multipart/form-data
    ...
    Content-Disposition: form-data; name="DistributionGroupingFileSet"; filename="sample.csv"
    Content-Type: application/jose


multipart/form-data text fields are assumed to be jose compact serialization.

JOSE objects each define their own internal content-type using the JOSE "cty" header. The possible content-types are:

  - text/csv
  - application/protobuf
  - application/zip
  - application/tar
  - application/x-tar

The JOSE spec recommends only using the "sub part", e.g. "zip" or "csv" when setting this header. The Lyric API supports either or.

    jwe.setHeader(cty, "protobuf")

More details about Multipart are [here](Mutipart).