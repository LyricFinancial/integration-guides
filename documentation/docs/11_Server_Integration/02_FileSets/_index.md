## FileSet Detail

Example Schema for DistributionGroupings FileSet:

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
    }

A FileSet has three fields, fileId, fileType, and details.

    {
      fileId: x123xxxfs3n
      fileType: earningSummary
      details: [{},{},{}]
    }

  - fileId: Opaque identifier you can use for debugging. Error messages will specify the fileId if a problem is found. If not provided, the server will generate a unique fileId.
  - fileType: A string which categorizes the file for server processing. There is no standard list of fileTypes. Rather, Lyric will work with each vendor to create a comment set
of fileTypes.
  - details: List of detail items

## FileSet Concept

The Lyric APIs use a concept called FileSet to represent a list of detailed data, e.g. earnings history or financial transactions. When using the API
you have the option to model this data as JSON following the schemas (see Swagger spec). Depending on the volume of data, this may be the most efficient method 
(Protobuf is a more efficient option to JSON as well). However, to get started more quickly you can also just upload CSV or ZIP (containing CSV) files. The API
can convert this raw data into FileSet objects. FileSets are used to project advance limits. See [Advance Limit Projections](!Server_Integration/FileSets/Advance_Limit_Projections)
for more details on specifically which FileSets are needed for your integration.


## Customizations/Options

When uploading files [using multipart](!Server_Integration/FileSets/Using_Multipart), the Lyric API, creates FileSet objects.
   

So even though you might upload a CSV file, the API parses this CSV file to create FileSet objects. Various Options control exactly how and IF
the server will parse the CSV file. For more detail on available options, see each individual [content type](!Server_Integration/FileSets/Content_Type) or the summary
below.

### General Options

  - **lyric-fileset.file-id** - (String) Identifier used when reporting errors. Optional
  - **lyric-fileset.file-type** - (String) A file category to differentiate between different data sets. I.e. "songSummary" vs "earningSummary". Both contain
  distribution data, but with different levels of detail. This defaults to "earningSummary". Lyric will work with you to define other fileTypes as necessary.

### CSV Options

  - **lyric-csv.schema** - (String) Named schema to indicate CSV data in a different format.
  - **lyric-csv.column-separator** - (String) Single character to indicate the column separator used. Default is ",". I.e. ("|", or "\t").
  - **lyric-csv.use-header** - (Boolean) Indicate of CSV data includes header row. Default true.

### Zip Options

- **lyric-archive.item-content-type** - (String) [text/csv | application/protobuf] Default: text/csv