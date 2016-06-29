### Working with CSV data

CSV data must follow predefined schemas.

  - [Standard Distributor Schema](/specs/v1/StandardDistributor.csvschema)
  - [Standard Publisher Schema](/specs/v1/StandardPublisher.csvschema)

Column order is dictated by the "schema". 

#### Standard Publisher Schema

- statementPeriod: ISO8601 date marking the period end date
- transactionCategory: String
- assetId: String, unique identifier
- assetTitle: String, song title, etc
- releaseDate: ISO8601 date marking asset release 
- releaseType: String, Album, Single, etc
- incomeTypeCategory: String, Mechanical, Print, Performance, etc
- incomeType: String, Radio, Television, etc
- composers: String
- totalEarned: Number
- payeeId: String



The Standard Distributor Schema is the default. To specify CSV data in a different schema, see option ***lyric-csv.schema***.

    jwe.setPayload(csvData)
    jwe.setContentType("text/csv")
    jwe.setHeader("lyric-csv.schema", "MyCustomSchema")

#### Options

These options are set on the JOSE JWE object headers. To apply defaults for all CSV files in a request, you can also set HTTP headers.

  - **lyric-csv.schema** - (String) Named schema to indicate CSV data in a different format.
  - **lyric-csv.column-separator** - (String) Single character to indicate the column separator used. Default is ",". I.e. ("|", or "\t").
  - **lyric-csv.use-header** - (Boolean) Indicate of CSV data includes header row. Default true.
  - **lyric-csv.date-format-string** - (String) A java format string if passing custom date formats. Defaults to ISO8601 format.