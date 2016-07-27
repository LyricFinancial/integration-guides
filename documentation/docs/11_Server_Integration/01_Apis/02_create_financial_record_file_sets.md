## FinancialRecord FileSets

It might make sense if when transferring larger files to send these in a separate API call from the primary registration API. This
creates a better user experience. You can pass demographic/userprofile data in the first API call while concurrently you extract, format, compress,
and encrypt the financial data. As soon as Lyric has the userprofile, it can begin the verification process and gather additional demographic data from the
user. This can happen even while financial data is being prepared.

### Asynchronous Mode

If you are using Async Mode, be sure to include the exact same 'async-token' for all related API calls. For details, see [Client Registration](!Server_Integration/Apis/upsert_client).

### JSON vs CSV vs Protobuf

The JSON schema is shown because it is an option. However, during initial testing, most partners will integrate using CSV. The most efficient transfer though will be Protobuf.

### REST vs Multipart

  - [Rest](/secure/vendor-api/#!/vendor/postFinancialRecordGroupingFileSets) - The standard REST api
  - [Multipart](/secure/vendor-api/#!/vendor-form/postFinancialRecordGroupingFileSetsMultipart) - The Multipart API

### JSON Requests

Below is the JSON schema for sending FinancialRecords.


    "FinancialRecordGroupingFileSetRequest" : {
      "type" : "object",
      "required" : [ "fileSets" ],
      "properties" : {
        "fileSets" : {
          "type" : "array",
          "readOnly" : true,
          "items" : {
            "$ref" : "#/definitions/FileSetFinancialRecordGrouping"
          },
          "maxItems" : 2147483647,
          "minItems" : 1
        },
        "inlineAttachments" : {
          "type" : "array",
          "readOnly" : true,
          "items" : {
            "$ref" : "#/definitions/InlineAttachment"
          }
        }
      }
    },
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
        }
      }
    },
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
    },


So the basic API (/clients/{memberToken}/financialRecordGroupingFileSets):

    POST /clients/{memberToken}/financialRecordGroupingFileSets HTTP/1.1
    Content-Type: application/json

    {
      fileSets: []
    }

However, to use the API in production, you must enable JOSE sign/encrypt message security. With JOSE turned on, the request will look something like:

    POST /clients/{memberToken}/financialRecordGroupingFileSets HTTP/1.1
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuT0RabU1qVmtZVGRoT1dReFlXRXlZV014WWpOalpUSTJOamczWWpSak1ESXhNelV5TVRFMk16SmxPR1ZsTTJJMVpEVTRNalUxTTJWall6WTNZamRqTmcuSERNeEU4R01URHhuY2piR0t4aFZTYUpuelQxNG9MZlYyalRCUWFNZUZQMlZueGlOWVp4TjhBYTdJTVFFYXl3TEhYVDB1MDMxaUxSUEdMRGFHZ3Q1YmZmcWtLdHdsQU9lTjBDTjNjQjZvazFoT1VUcEd2NW9DTldaaUR6UnNQUkhkcENxQk5QSjdSVS0yUU9KMkpFWVlOOVp2TkJYd0ptSlJpTVFRYW9nS0NWOTlKTXQtWE82VGJ4N0xHLWpSTnpmN1NfNkVhZHh1M3JodENTOGZlMUFDbDdtQW40MUZUNllPX0NfdkFiM0dxeVNzYjE2QjZIS1dadi1CTlRTeDFUOC1nT3M0Y29iM3NJRHhEcEpNd0toUTB6R21XRGNubDFmSVQxZFIzSVAxOE51MVB0bTJ3YWVQVHAxOHllanBTSnhYWkstWmpGYnNUQVFGUTJhZFZSOHd3IiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.dcZ70ZfqThFSAqz7kMFIbZtyryzoGZ-8VodBHqSGstwPK5OGzg1cS9HiKexI1GAbGOvjYzbfE9ZSwYst8h54piwbawAusePf4ibfQZtpwfU2Yts92lwEktePcq3GuCKcs7X2BzEqxrPafLc2EImi3c25dCbUBIC2PSEaSGiiq03EThpMyR9ksVjeh9wigqRIQ6-PmH2Kf8UXWeLKjkQdRVh8VwlE6lxQx5SHyQ26FSJCffKgr3DU0Q_vNoKU8rveFyujqlI0-oxIyWGtJ0jBSqDm2Um2jGwH9ZWYnW8X_cSQyVx1jYJ7FT3oo-F_ecDR8b0WN4_c74RuzCboF5oLWg.R_Lvj-QmBtaiK79gdB3Umw._ggGJEQcAfCBhJCGi0AnpkVOH9msNsIr6cvuZeGTEjuSbHnfo1_1gVFvE1GLpNjtg6K4WRsfsUkiBOYL7MYJ4j9H-WgV0m3xcyxs4fyMmYsyKyo3emsOMTuqZKQGr4xLvDwp4k2X6cJEQu2vPMer97pONehcaxaB4KJ_HZw-C1SMpgVlpB32BEAy4Pd6WNM5XewTpIn_3Hvgk76uRxXODUlr7o6AlRMDB_Vs0UxhaU0AhXCt9JUDV19vVK54QE4AAH5myatOIS_yga3XXmeCKBEqpKkQ4BKRHIEvBnrepXDWMKsajHg4sUCY-0GIAD77h6LfuQ4uHbgKVqIXM_X98i_JOQx08AsDniEh8v9T7IwAPCuIKJf4bTxFKVCfrQLQjOD3tew6OFYSfvTC-XMAoP-UjsZ9Lmawzjt0ggchLFxSUA8eCFBOBMo1dN7AY9sgFqz8_dsjcNLi6Xyzs51gAlL4tIpoe9v76Cl7zE_ShP4.MXj0Kngh2EY59_Tyw4l4cg

See the [Security](!Server_Integration/Sign_Encrypt) section for more information on JOSE.

If using multipart/form-data, use the field name, FinancialRecordGroupingFileSet, to send the JSON object. I.e.


    // Multipart
    POST /clients/{memberToken}/financialRecordGroupingFileSets.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd


    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="earnings.csv"
    Content-Type: text/csv

    header1,header2
    data1,data2
    ------LyricBoundaryAL0lfjW6DJtKiwkd--


And finally, when JOSE is enabled, each part of a multipart request should contain a separate JOSE object.

    // Multipart
    POST /clients/{memberToken}/financialRecordGroupingFileSets.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="earnings.csv"
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuWmpSbVkyWm1PVEpqTVdRM01qWTNOek16TjJJME1ERTRNREkwWldWbE5ESTFNelF6WlRrMU9ESmxNR1EyWlRFMU5EbGpNalEyTW1RMk1EbGpZemcwWXcua25Ydm5ZX3JGZVdfNDg1MWh6UmFHTGgwYXRZQmFEdFV4WUh1SFJHSDB3bm1ESDlFU0JVMU4zZGtBLXVGOFBFZUE2QnlTNV82MWVqc3RCU3FQMmJibnlsNERldXhZNmJLQlpiRTY4TGJqNVdhelNQc3lBLS1lZXoyQ0l0UVo3RE0wbFdNb1QwNWdCTUVROUJPeWhCS0RiT2JEa041UGs3V0tldEM3MTFLVkUxNHJHOExuVzBsRFFpQ3BoMm5oZXRYR1BKVlotaGNCSS10bzloLWI3LWJCUkk3X0N1UEVicDByZnc5RDV5VERuSnBaOXVobDRwVXctdE5yZFBocXAySWJlNWxYSUg1N2tzNjduVnhiQkE3WWdGT0ZTM2s2SWczLVVpT0ZGdldwTUpwSHdnMEJXWXpJNlRvZ2dCMG9FYU5pZ0hMdlNRWWtWR0QzTWhYcDVpalhRIiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.Tew7-1JR0UWyHSCp_AJBx8v_h0I6Btk1SBaIlpcXITmEbByRLC4BevvdKpY5R4Ea6IfWKJmFFui08t22cPxvsEBtebhAyFbsx4My0WomLi_GkKxY8rwY5p6RtKJxLnDrLhpH4LKn5lkCLYopolnlFRG4T6zAygQ-TQowo-1G2VsqLIfGuRzyUtLOlV0w4vwZTxbTeYN1ml3pbd7wiFslPVzkiYtN3HYHNG9rubaOSYCgZbBKQPXlvoSv_h8Juyr8KlE5SKGvQmanMBqeIPM-ny4QdveMJsllWF5L94_XS5IKxubnh4bq-QM8HyqS6YgWUOETTRxxIj56d98hetAUYw.twTj6ak8DD19RP3cvnkFng.ADGhr531ba1Zp9WCfzl3qkYdelPwNVsrtHX2LXobPTCdPn2BPJ-58LFjz61U0uViSM3a8IYAqX0jssKst_7m6C8l-9M2_XnlZnOabPCKR4yPebTPOJFKA6xC_4ITdWiF6SlDHxDmJnpACj0VdQIaOA._m34VETv-KLlShO_ao09LA
    ------LyricBoundaryAL0lfjW6DJtKiwkd--
