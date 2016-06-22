## Royalty/Distributions Data

Royalty/Distributions data can either be [embedded](!Server_Integration/FileSets/Attachments) in the JSON payload or sent [using multipart/form-data](!Server_Integration/FileSets/Using_Multipart) as a separate attachment alongside the primary JSON used by the API. Lyric supports earnings data in CSV format, Google Protobuf format, or as raw JSON. When using multipart/form-data CSV files or Google protobuf files may also be archived in ZIP or TAR files. Lyric recommends Protobuf files as they will be more compact than CSV/JSON and require less parsing.

Lyric uses Royalty/Distribution data to [calculate projected earnings and determine an advance limit](!Server_Integration/FileSets/Advance_Limit_Projections) for each client. You can transfer this data to Lyric during a [Registration](!Server_Integration/Apis/upsert_client) request or out-of-band afterwards.

To calculate advance limits, Lyric uses DistributionGroupings, Encumbrances, Asset data (e.g. Songs information), and user profile data.

Internally, Lyric refers to distribution, asset, and encumbrance data posted through the API as "FileSets". These FileSets represent collections of our normalized view of the data. You can view the
schemas in the API documentation. Preparing the data in these formats is the most efficient way to pass data to Lyric. However, it is also possible to pass less structured data using CSV if Lyric provides a compatible CSV parser.

The schema for DistributionGroupingFileSet:

    "FileSetDistributionGrouping" : {
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
            "$ref" : "#/definitions/DistributionGrouping"
          },
          "maxItems" : 2147483647,
          "minItems" : 1
        }
      }
    },
    "DistributionGrouping" : {
      "type" : "object",
      "required" : [ "distributionSet", "memberToken", "statementDate", "vendorId" ],
      "properties" : {
        "distributionSet" : {
          "readOnly" : true,
          "$ref" : "#/definitions/DistributionSet"
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
    "DistributionSet" : {
      "type" : "object",
      "properties" : {
        "distributions" : {
          "type" : "array",
          "uniqueItems" : true,
          "items" : {
            "$ref" : "#/definitions/Distribution"
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
    "Distribution" : {
      "type" : "object",
      "required" : [ "totalEarned" ],
      "properties" : {
        "totalEarned" : {
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
          "type" : "array",
          "description" : "Base64 encoded JSON data which further describes the distribution. I.e. incomeType, storeName, salesType, countryOfSale, etc",
          "readOnly" : true,
          "items" : {
            "type" : "string",
            "format" : "byte"
          }
        }
      },
      "description" : "A distribution represents a payment to the client during a period. All distributions belong to a DistributionGrouping which defines the client and period. A distribution can be more or less granular based on other meta data passed in extendedJson. I.e. You might send a single distribution as a complete rollup for the period. Alternatively, and on the other extreme, you could send every single transaction and include a reference number in the extendedJson. A more common scenario might be to send a rollup by a given property, e.g. songId, or category."
    },
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
    }

FileSet handling is always idempotent. DistributionGrouping data is keyed on the statement date and any new dataset replaces the previous dataset. Encumbrance and Asset data
are keyed on externalTransactionId and assetId, both of which are provided from your system. Lyric treats these as opaque identifiers and expects them to not change over time.


### Distribution Groupings FileSet

The DistributionGroupingsFileSet represents a breakdown of earnings by period. Vendors might send Summary or Detail data depending on agreements with Lyric.

A DistributionGroupingsFileSet object is a FileSet object where each of the "details" is a DistributionGrouping object.

The "statement" date/period is the only required data for the top level DistributionGrouping. DistributionGroupings contain a list of 
Distribution objects and optionally a list of Asset objects. When sending Summary data, a DistributionGrouping might contain as few as one Distribution which represents
the Summary for the period. A Distribution must define the totalEarned. ExchangeRate and currencyCode may also be specified. These typically default to 100 and 840 (USD).

If sending Detailed data, a vendor can send many Distribution objects. Distinguishing meta-data is attached to each Distribution using the extendedJson field, which is a Base64
encoded JSON string. Lyric is able to update its projection formulas using additional data provided this way. If Distribution data includes asset level detail, the assetId should be
included in extendedJson and additional details about the Asset sent in the DistributionGrouping.assets fields.

#### Apis

- [Registration](/secure/vendor-api/#!/vendor/registerClient) - When registering a user, you can include a DistributionGroupingFileSet on the RegistrationRequest
- [Add New Distribution History](/secure/vendor-api/#!/vendor/postDistributionGroupings) - You can send DistributionGroupingFileSet data out of band as well

You can also use the multipart/form-data version of these API's.


- [Registration](/secure/vendor-api/#!/vendor-form/registerClientMultipart) - When registering a user, you can include a DistributionGroupingFileSet on the RegistrationRequest
- [Add New Distribution History](/secure/vendor-api/#!/vendor-form/postDistributionGroupingsMultipart) - You can send DistributionGroupingFileSet data out of band as well
