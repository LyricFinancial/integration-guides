### FinancialRecord

FinancialRecords are an abstract data structure which represents a transaction OR an aggregation of transactions. Lyric uses this structure to capture both earnings data and encumbrances.

    "FinancialRecord" : {
      "type" : "object",
      "required" : [ "amount" ],
      "properties" : {
        "amount" : {
          "type" : "number",
          "readOnly" : true
        },
        "exchangeRate" : {
          "type" : "integer",
          "format" : "int32",
          "readOnly" : true
        },
        "currencyCode" : {
          "type" : "integer",
          "format" : "int32",
          "readOnly" : true
        },
        "extendedJson" : {
          "type" : "string",
          "description" : "Base64 encoded JSON data which further describes the financialRecord. I.e. incomeType, storeName, salesType, countryOfSale, etc",
          "readOnly" : true
        }
      },
      "description" : "A FinancialRecord represents a payment to the client or encumbrance during a period. All FinancialRecords belong to a FinancialRecordGrouping which defines the client and period. A FinancialRecord can be more or less granular based on other meta data passed in extendedJson. I.e. You might send a single FinancialRecord as a complete rollup for the period. Alternatively, and on the other extreme, you could send every single transaction and include a reference number in the extendedJson. A more common scenario might be to send a rollup by a given property, e.g. songId, or category."
    },

A FinancialRecord must define the amount. This might be the totalEarned for a distribution or the transaction amount of an encumbrance. ExchangeRate and currencyCode may also be specified. These typically default to 100 and 840 (USD).

### Extensions

If sending Detailed data, a vendor can send many FinancialRecord objects. Distinguishing meta-data is attached to each FinancialRecord using the extendedJson field, which is a Base64
encoded JSON string. Lyric is able to update its projection formulas using additional data provided this way. If FinancialRecord data includes asset level detail, the assetId should be
included in extendedJson and additional details about the Asset sent in the FinancialRecordGrouping.assets fields.

### Statement Grouping

FinancialRecord data is always grouped by statement date. Any associated asset data is also stored in this per-period grouping object.

    "FinancialRecordGrouping" : {
      "type" : "object",
      "required" : [ "financialRecordSet", "memberToken", "statementDate", "vendorId" ],
      "properties" : {
        "financialRecordSet" : {
          "readOnly" : true,
          "$ref" : "#/definitions/FinancialRecordSet"
        },
        "vendorId" : {
          "type" : "string",
          "readOnly" : true
        },
        "memberToken" : {
          "type" : "string"
        },
        "statementDate" : {
          "type" : "integer",
          "format" : "int64",
          "readOnly" : true,
          "minimum" : 1.262304E12
        }
      }
    },
    "FinancialRecordSet" : {
      "type" : "object",
      "properties" : {
        "financialRecords" : {
          "type" : "array",
          "uniqueItems" : true,
          "items" : {
            "$ref" : "#/definitions/FinancialRecord"
          },
          "maxItems" : 2147483647,
          "minItems" : 1
        },
        "assets" : {
          "type" : "array",
          "uniqueItems" : true,
          "items" : {
            "$ref" : "#/definitions/Asset"
          }
        }
      }
    },

### Assets

Asset details are normalized using the following structure.

    "Asset" : {
      "type" : "object",
      "required" : [ "assetId", "assetTitle", "vendorId" ],
      "properties" : {
        "assetId" : {
          "type" : "string",
          "readOnly" : true
        },
        "assetTitle" : {
          "type" : "string",
          "readOnly" : true
        },
        "assetType" : {
          "type" : "string",
          "readOnly" : true,
          "enum" : [ "UNKNOWN", "SONG" ]
        },
        "assetRights" : {
          "type" : "string",
          "readOnly" : true,
          "enum" : [ "writer", "publisher", "master_owner" ]
        },
        "marketDate" : {
          "type" : "string",
          "readOnly" : true,
          "pattern" : "\\d{4}-[01]\\d-[0-3]\\d"
        },
        "creatorId" : {
          "type" : "string",
          "readOnly" : true
        },
        "creatorNames" : {
          "type" : "string",
          "readOnly" : true
        },
        "assetOwnershipPercent" : {
          "type" : "number",
          "readOnly" : true
        },
        "royaltyPercent" : {
          "type" : "number",
          "readOnly" : true
        },
        "incomePerformanceLink" : {
          "type" : "string",
          "readOnly" : true
        },
        "vendorId" : {
          "type" : "string"
        }
      }

### FinancialRecordGroupingFileSet

The FinancialRecordGroupingFileSet represents a breakdown of financial data by period, where the type of data is defined by the FileSet.fileType. Vendors might send Summary or Detail data depending on agreements with Lyric.

A FinancialRecordGroupingFileSet object is a FileSet object where each of the "details" is a FinancialRecordGrouping object.

The "statement" date/period is the only required data for the top level FinancialRecordGrouping. FinancialRecordGrouping contain a list of 
FinancialRecord objects and optionally a list of Asset objects. When sending Summary data, a FinancialRecordGrouping might contain as few as one FinancialRecord which represents
the Summary for the period. 


    "FileSetFinancialRecordGrouping" : {
      "type" : "object",
      "required" : [ "details", "fileId", "fileType" ],
      "properties" : {
        "fileId" : {
          "type" : "string",
          "readOnly" : true
        },
        "fileType" : {
          "type" : "string",
          "readOnly" : true
        },
        "details" : {
          "type" : "array",
          "readOnly" : true,
          "uniqueItems" : true,
          "items" : {
            "$ref" : "#/definitions/FinancialRecordGrouping"
          },
          "maxItems" : 2147483647,
          "minItems" : 1
        }
      }
    }

### Usage

FinancialRecord data can either be [embedded](!Server_Integration/FileSets/Attachments) in the JSON payload or sent [using multipart/form-data](!Server_Integration/FileSets/Using_Multipart) as a separate attachment alongside the primary JSON used by the API. Lyric supports earnings data in CSV format, Google Protobuf format, or as raw JSON. When using multipart/form-data CSV files or Google protobuf files may also be archived in ZIP or TAR files. Lyric recommends Protobuf files as they will be more compact than CSV/JSON and require less parsing.

Lyric uses FinancialRecord data to [calculate projected earnings and determine an advance limit](!Server_Integration/FileSets/Advance_Limit_Projections) for each client. You can transfer this data to Lyric during a [Registration](!Server_Integration/Apis/upsert_client) request or out-of-band afterwards.

To calculate advance limits, Lyric uses FinancialRecords, Asset data (e.g. Songs information), and user profile data.

### FileSets

Internally, Lyric refers to distribution, asset, and encumbrance data posted through the API as [FileSets](!Server_Integration/FileSets). These FileSets represent collections of our normalized view of the data. You can view the
schemas in the API documentation. Preparing the data in these formats is the most efficient way to pass data to Lyric. However, it is also possible to pass less structured data using CSV if Lyric provides a compatible CSV parser.

FileSet handling is always idempotent. FinancialRecordGrouping data is keyed on the statement date and any new dataset replaces the previous dataset. Asset data
are keyed on assetId, which is provided from your system. Lyric treats these as opaque identifiers and expects them to not change over time.



### Apis

- [Registration](/secure/vendor-api/#!/vendor/registerClient) - When registering a user, you can include a FinancialRecordGroupingFileSet on the RegistrationRequest
- [Add New FinancialRecord History](/secure/vendor-api/#!/vendor/postFinancialRecordGroupingFileSets) - You can send FinancialRecordGroupingFileSet data out of band as well

You can also use the multipart/form-data version of these API's.


- [Registration](/secure/vendor-api/#!/vendor-form/registerClientMultipart) - When registering a user, you can include a FinancialRecordGroupingFileSet on the RegistrationRequest
- [Add New FinancialRecord History](/secure/vendor-api/#!/vendor-form/postFinancialRecordGroupingFileSetsMultipart) - You can send FinancialRecordGroupingFileSet data out of band as well
