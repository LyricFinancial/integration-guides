### Working with CSV data

CSV data must follow predefined schemas.

  - [Standard Distributor Schema](/specs/v1/StandardDistributor.csvschema)

Column order is dictated by the "schema".

The Standard Distributor Schema is the default. To specify CSV data in a different schema, see option ***lyric-csv.schema***.

    jwe.setPayload(csvData)
    jwe.setContentType("text/csv")
    jwe.setHeader("lyric-csv.schema", "MyCustomSchema")

#### Options

These options are set on the JOSE JWE object headers. To apply defaults for all CSV files in a request, you can also set HTTP headers.

  - **lyric-csv.schema** - (String) Named schema to indicate CSV data in a different format.
  - **lyric-csv.column-separator** - (String) Single character to indicate the column separator used. Default is ",". I.e. ("|", or "\t").
  - **lyric-csv.use-header** - (Boolean) Indicate of CSV data includes header row. Default true.