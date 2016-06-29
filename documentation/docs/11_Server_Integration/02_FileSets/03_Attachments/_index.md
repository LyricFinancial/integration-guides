### Multipart vs Embedded

You can upload files to the API using standard HTTP multipart/form-data.


    // Multipart
    POST /<api> HTTP/1.1
    Content-Type: multipart/form-data
  
To process files on the server, there are sometimes a few extra bits the client needs to send with Multipart uploads. 

Normally, these are sent using JOSE JWE headers. I.e.


    jwe.setHeader("lyric-fileset.file-id", "5ec019b0-d259-418d-972a-419856215bf9")
    jwe.setHeader("lyric-fileset.file-type", "earningSummary")
    jwe.setHeader("lyric-csv.column-separator", "|")

However, if JOSE is disabled we still need a way to specify these options. You can do so using content type parameters. I.e.


    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="sample.csv"
    Content-Type: text/csv; lyric-fileset.file-id=5ec019b0-d259-418d-972a-419856215bf9; lyric-fileset.file-type=earningSummary; lyric-csv.column-separator=|

However, when embedding file data into a JSON request, this becomes easier. When embedding, we use the InlineAttachment object:

     "InlineAttachment" : {
      "type" : "object",
      "properties" : {
        "fileId" : {
          "type" : "string"
        },
        "fileType" : {
          "type" : "string"
        },
        "headers" : {
          "type" : "array",
          "items" : {
            "$ref" : "#/definitions/Header"
          }
        },
        "fileContents" : {
          "type" : "array",
          "items" : {
            "type" : "string",
            "format" : "byte"
          }
        }
      }
    }

    "Header" : {
      "type" : "object",
      "properties" : {
        "name" : {
          "type" : "string"
        },
        "value" : {
          "type" : "string"
        }
      }
    }

So, i.e.

    {
      fileId: 5ec019b0-d259-418d-972a-419856215bf9
      fileType: earningSummary
      headers: [
        {
          name: lyric-csv.column-separator
          value: |
        }
      ]
      fileContents: "<Base64Data>"
    }