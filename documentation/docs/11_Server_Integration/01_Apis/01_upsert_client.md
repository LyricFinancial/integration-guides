## Client Registration

At this point, it is required to call the "registration" api (swagger path POST /clients). Visit the [api spec](/secure/vendor-api/) for full details.

To create a RegistrationRequest for this API, you need at a minimum:

  - Email
  - First Name
  - A unique identifier from your system (VendorClientAccountId)
  - Up to three years of earnings history (minimum 1 year)

There is a multipart alternative to the standard JSON endpoint.

### Synchronous Mode

This API will return an access-token header which represents a vATM "session" for the
end user. If you are using the [Lyric Snippet](!Lyric_Snippet/Lyric_Snippet_Sync), you just pass this token to the advanceRequestComplete(token) callback handler.


### Asynchronous Mode

See [Lyric Snippet](!Lyric_Snippet/Lyric_Snippet_Async) documentation for how to configure the snippet in Async Mode. You will be required to create a JWT, referred to as
"the Async Token", on your server. This token represents an "async session" as it grants the user access to the vAtm for a period of time. You can generate the Async Token
when the user loads your page for the first time. You'll then use this same token in the Lyric Snippet as well as on your server as a header when you make calls to the Lyric
API's. You'll want to regenerate the Aysnc Token each time the user loads the page in order to extend the length of the session. The requirements to create an async token are:

  1. Signed with your vendor_api key
  2. issuer = "Vendor"
  3. audience = "vatmAsyncService"
  4. subject = "\<vendorClientAccountId>"
  5. jti = "\<Globally Unique ID>"
  6. exp = <reasonable session length to complete an advance request, recommended: Your site's session timeout + 2 hours>
  7. Custom claims:
  
      async = true

      vendorId = "\<yourVendorId>"

It is crucial that you use a GLOBALLY unique id in step 5 for the jti.

I.e.

    POST /clients HTTP/1.1
    Content-Type: application/jose
    async-token: <the async token you generated>

### no-new-financial-records Optimization

If you track when you send data to the Lyric API, you can avoid sending financial data with every request. As long as Lyric already has the newest data,
you can explicitly tell the API not to expect any data in a registration request.

Set a header like this:

    POST /clients HTTP/1.1
    Content-Type: application/jose
    no-new-financial-records: <anything>

Just the presence of the header acts as a flag. If you aren't coding for this optimization, do not set this header at all.

### Responses

**201** - If you send financial data and/or specify the noNewFinancialRecords flag, expect a 201 http response

**202** - If the request does not include financial data, expect a 202 http response. The body of the response will contain a message stating that processing cannot continue until financial data is sent.


### Request Anatomy

The primary RegistrationRequest is a JSON object with the following high-level schema:

    "RegistrationRequest" : {
      "type" : "object",
      "required" : [ "userProfile" ],
      "properties" : {
        "userProfile" : {
          "$ref" : "#/definitions/UserProfile"
        },
        "encumbranceFileSets" : {
          "$ref" : "#/definitions/EncumbranceFileSetRequest"
        },
        "financialRecordGroupingFileSets" : {
          "$ref" : "#/definitions/FinancialRecordGroupingFileSetRequest"
        }
      }
    },
    "UserProfile" : {
      "type" : "object",
      "required" : [ "user", "vendorAccount" ],
      "properties" : {
        "user" : {
          "$ref" : "#/definitions/User"
        },
        "vendorAccount" : {
          "$ref" : "#/definitions/VendorAccount"
        },
        "bankInfo" : {
          "$ref" : "#/definitions/BankInfo"
        },
        "taxInfo" : {
          "$ref" : "#/definitions/TaxInfo"
        }
      },
      "description" : "Various profile data related to a client user"
    },
    "User" : {
      "type" : "object",
      "required" : [ "email", "firstName" ],
      "properties" : {
        "firstName" : {
          "type" : "string",
          "readOnly" : true
        },
        "lastName" : {
          "type" : "string"
        },
        "email" : {
          "type" : "string"
        },
        "phone" : {
          "type" : "string"
        },
        "mobilePhone" : {
          "type" : "string"
        },
        "address1" : {
          "type" : "string"
        },
        "address2" : {
          "type" : "string"
        },
        "city" : {
          "type" : "string"
        },
        "state" : {
          "type" : "string"
        },
        "zipCode" : {
          "type" : "string",
          "pattern" : "^[0-9]{5}(?:-[0-9]{4})?$"
        },
        "gender" : {
          "type" : "string",
          "enum" : [ "male", "female", "other", "unknown" ]
        },
        "maritalStatus" : {
          "type" : "string",
          "enum" : [ "single", "married", "separated", "divorced", "widowed", "unknown" ]
        },
        "dob" : {
          "type" : "string",
          "pattern" : "\\d{4}-[01]\\d-[0-3]\\d"
        }
      }
    },
    "BankInfo" : {
      "type" : "object",
      "required" : [ "bankAccountNumber", "bankAccountType", "bankName", "bankRoutingNumber", "vendorId" ],
      "properties" : {
        "vendorId" : {
          "type" : "string"
        },
        "bankName" : {
          "type" : "string"
        },
        "bankRoutingNumber" : {
          "type" : "string"
        },
        "bankAccountNumber" : {
          "type" : "string",
          "pattern" : "\\d{4,17}"
        },
        "bankAccountType" : {
          "type" : "string",
          "enum" : [ "checking", "savings" ]
        }
      }
    },
    "TaxInfo" : {
      "type" : "object",
      "required" : [ "memberBusinessType", "tinType" ],
      "properties" : {
        "memberBusinessType" : {
          "type" : "string",
          "enum" : [ "individual", "soleProprietor", "llc", "corporation", "partnership", "unknown" ]
        },
        "tinType" : {
          "type" : "string",
          "enum" : [ "ssn", "itin", "ein", "unknown" ]
        },
        "taxEinTinSsn" : {
          "type" : "string"
        }
      }
    }

So the basic API (/clients):

    POST /clients HTTP/1.1
    Content-Type: application/json

    {
      userProfile: {
        user: {...}
      }
    }

However, to use the API in production, you must enable JOSE sign/encrypt message security. With JOSE turned on, the request will look something like:

    POST /clients HTTP/1.1
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuT0RabU1qVmtZVGRoT1dReFlXRXlZV014WWpOalpUSTJOamczWWpSak1ESXhNelV5TVRFMk16SmxPR1ZsTTJJMVpEVTRNalUxTTJWall6WTNZamRqTmcuSERNeEU4R01URHhuY2piR0t4aFZTYUpuelQxNG9MZlYyalRCUWFNZUZQMlZueGlOWVp4TjhBYTdJTVFFYXl3TEhYVDB1MDMxaUxSUEdMRGFHZ3Q1YmZmcWtLdHdsQU9lTjBDTjNjQjZvazFoT1VUcEd2NW9DTldaaUR6UnNQUkhkcENxQk5QSjdSVS0yUU9KMkpFWVlOOVp2TkJYd0ptSlJpTVFRYW9nS0NWOTlKTXQtWE82VGJ4N0xHLWpSTnpmN1NfNkVhZHh1M3JodENTOGZlMUFDbDdtQW40MUZUNllPX0NfdkFiM0dxeVNzYjE2QjZIS1dadi1CTlRTeDFUOC1nT3M0Y29iM3NJRHhEcEpNd0toUTB6R21XRGNubDFmSVQxZFIzSVAxOE51MVB0bTJ3YWVQVHAxOHllanBTSnhYWkstWmpGYnNUQVFGUTJhZFZSOHd3IiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.dcZ70ZfqThFSAqz7kMFIbZtyryzoGZ-8VodBHqSGstwPK5OGzg1cS9HiKexI1GAbGOvjYzbfE9ZSwYst8h54piwbawAusePf4ibfQZtpwfU2Yts92lwEktePcq3GuCKcs7X2BzEqxrPafLc2EImi3c25dCbUBIC2PSEaSGiiq03EThpMyR9ksVjeh9wigqRIQ6-PmH2Kf8UXWeLKjkQdRVh8VwlE6lxQx5SHyQ26FSJCffKgr3DU0Q_vNoKU8rveFyujqlI0-oxIyWGtJ0jBSqDm2Um2jGwH9ZWYnW8X_cSQyVx1jYJ7FT3oo-F_ecDR8b0WN4_c74RuzCboF5oLWg.R_Lvj-QmBtaiK79gdB3Umw._ggGJEQcAfCBhJCGi0AnpkVOH9msNsIr6cvuZeGTEjuSbHnfo1_1gVFvE1GLpNjtg6K4WRsfsUkiBOYL7MYJ4j9H-WgV0m3xcyxs4fyMmYsyKyo3emsOMTuqZKQGr4xLvDwp4k2X6cJEQu2vPMer97pONehcaxaB4KJ_HZw-C1SMpgVlpB32BEAy4Pd6WNM5XewTpIn_3Hvgk76uRxXODUlr7o6AlRMDB_Vs0UxhaU0AhXCt9JUDV19vVK54QE4AAH5myatOIS_yga3XXmeCKBEqpKkQ4BKRHIEvBnrepXDWMKsajHg4sUCY-0GIAD77h6LfuQ4uHbgKVqIXM_X98i_JOQx08AsDniEh8v9T7IwAPCuIKJf4bTxFKVCfrQLQjOD3tew6OFYSfvTC-XMAoP-UjsZ9Lmawzjt0ggchLFxSUA8eCFBOBMo1dN7AY9sgFqz8_dsjcNLi6Xyzs51gAlL4tIpoe9v76Cl7zE_ShP4.MXj0Kngh2EY59_Tyw4l4cg

See the [Security](!Server_Integration/Sign_Encrypt) section for more information on JOSE.

The request object contains the userProfile as well as financialRecord FileSets. You can use the FileSets to send historical earnings and financial data as JSON or embedded attachment data (coming soon). Alternatively, and for now exclusively, you can use the multipart/form-data version of the api, /clients.form, and attach files to the HTTP request directly. 
If using multipart/form-data, use the field name, RegistrationRequest, to send the JSON object. I.e.


    // Multipart
    POST /clients.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="RegistrationRequest"
    Content-Type: application/json

    {
      userProfile: {
        user: {...}
      }
    }

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="earnings.csv"
    Content-Type: text/csv

    header1,header2
    data1,data2
    ------LyricBoundaryAL0lfjW6DJtKiwkd--


And finally, when JOSE is enabled, each part of a multipart request should contain a separate JOSE object.

    // Multipart
    POST /clients.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="RegistrationRequest"
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuT0RabU1qVmtZVGRoT1dReFlXRXlZV014WWpOalpUSTJOamczWWpSak1ESXhNelV5TVRFMk16SmxPR1ZsTTJJMVpEVTRNalUxTTJWall6WTNZamRqTmcuSERNeEU4R01URHhuY2piR0t4aFZTYUpuelQxNG9MZlYyalRCUWFNZUZQMlZueGlOWVp4TjhBYTdJTVFFYXl3TEhYVDB1MDMxaUxSUEdMRGFHZ3Q1YmZmcWtLdHdsQU9lTjBDTjNjQjZvazFoT1VUcEd2NW9DTldaaUR6UnNQUkhkcENxQk5QSjdSVS0yUU9KMkpFWVlOOVp2TkJYd0ptSlJpTVFRYW9nS0NWOTlKTXQtWE82VGJ4N0xHLWpSTnpmN1NfNkVhZHh1M3JodENTOGZlMUFDbDdtQW40MUZUNllPX0NfdkFiM0dxeVNzYjE2QjZIS1dadi1CTlRTeDFUOC1nT3M0Y29iM3NJRHhEcEpNd0toUTB6R21XRGNubDFmSVQxZFIzSVAxOE51MVB0bTJ3YWVQVHAxOHllanBTSnhYWkstWmpGYnNUQVFGUTJhZFZSOHd3IiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.dcZ70ZfqThFSAqz7kMFIbZtyryzoGZ-8VodBHqSGstwPK5OGzg1cS9HiKexI1GAbGOvjYzbfE9ZSwYst8h54piwbawAusePf4ibfQZtpwfU2Yts92lwEktePcq3GuCKcs7X2BzEqxrPafLc2EImi3c25dCbUBIC2PSEaSGiiq03EThpMyR9ksVjeh9wigqRIQ6-PmH2Kf8UXWeLKjkQdRVh8VwlE6lxQx5SHyQ26FSJCffKgr3DU0Q_vNoKU8rveFyujqlI0-oxIyWGtJ0jBSqDm2Um2jGwH9ZWYnW8X_cSQyVx1jYJ7FT3oo-F_ecDR8b0WN4_c74RuzCboF5oLWg.R_Lvj-QmBtaiK79gdB3Umw._ggGJEQcAfCBhJCGi0AnpkVOH9msNsIr6cvuZeGTEjuSbHnfo1_1gVFvE1GLpNjtg6K4WRsfsUkiBOYL7MYJ4j9H-WgV0m3xcyxs4fyMmYsyKyo3emsOMTuqZKQGr4xLvDwp4k2X6cJEQu2vPMer97pONehcaxaB4KJ_HZw-C1SMpgVlpB32BEAy4Pd6WNM5XewTpIn_3Hvgk76uRxXODUlr7o6AlRMDB_Vs0UxhaU0AhXCt9JUDV19vVK54QE4AAH5myatOIS_yga3XXmeCKBEqpKkQ4BKRHIEvBnrepXDWMKsajHg4sUCY-0GIAD77h6LfuQ4uHbgKVqIXM_X98i_JOQx08AsDniEh8v9T7IwAPCuIKJf4bTxFKVCfrQLQjOD3tew6OFYSfvTC-XMAoP-UjsZ9Lmawzjt0ggchLFxSUA8eCFBOBMo1dN7AY9sgFqz8_dsjcNLi6Xyzs51gAlL4tIpoe9v76Cl7zE_ShP4.MXj0Kngh2EY59_Tyw4l4cg

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="earnings.csv"
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuWmpSbVkyWm1PVEpqTVdRM01qWTNOek16TjJJME1ERTRNREkwWldWbE5ESTFNelF6WlRrMU9ESmxNR1EyWlRFMU5EbGpNalEyTW1RMk1EbGpZemcwWXcua25Ydm5ZX3JGZVdfNDg1MWh6UmFHTGgwYXRZQmFEdFV4WUh1SFJHSDB3bm1ESDlFU0JVMU4zZGtBLXVGOFBFZUE2QnlTNV82MWVqc3RCU3FQMmJibnlsNERldXhZNmJLQlpiRTY4TGJqNVdhelNQc3lBLS1lZXoyQ0l0UVo3RE0wbFdNb1QwNWdCTUVROUJPeWhCS0RiT2JEa041UGs3V0tldEM3MTFLVkUxNHJHOExuVzBsRFFpQ3BoMm5oZXRYR1BKVlotaGNCSS10bzloLWI3LWJCUkk3X0N1UEVicDByZnc5RDV5VERuSnBaOXVobDRwVXctdE5yZFBocXAySWJlNWxYSUg1N2tzNjduVnhiQkE3WWdGT0ZTM2s2SWczLVVpT0ZGdldwTUpwSHdnMEJXWXpJNlRvZ2dCMG9FYU5pZ0hMdlNRWWtWR0QzTWhYcDVpalhRIiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.Tew7-1JR0UWyHSCp_AJBx8v_h0I6Btk1SBaIlpcXITmEbByRLC4BevvdKpY5R4Ea6IfWKJmFFui08t22cPxvsEBtebhAyFbsx4My0WomLi_GkKxY8rwY5p6RtKJxLnDrLhpH4LKn5lkCLYopolnlFRG4T6zAygQ-TQowo-1G2VsqLIfGuRzyUtLOlV0w4vwZTxbTeYN1ml3pbd7wiFslPVzkiYtN3HYHNG9rubaOSYCgZbBKQPXlvoSv_h8Juyr8KlE5SKGvQmanMBqeIPM-ny4QdveMJsllWF5L94_XS5IKxubnh4bq-QM8HyqS6YgWUOETTRxxIj56d98hetAUYw.twTj6ak8DD19RP3cvnkFng.ADGhr531ba1Zp9WCfzl3qkYdelPwNVsrtHX2LXobPTCdPn2BPJ-58LFjz61U0uViSM3a8IYAqX0jssKst_7m6C8l-9M2_XnlZnOabPCKR4yPebTPOJFKA6xC_4ITdWiF6SlDHxDmJnpACj0VdQIaOA._m34VETv-KLlShO_ao09LA
    ------LyricBoundaryAL0lfjW6DJtKiwkd--
