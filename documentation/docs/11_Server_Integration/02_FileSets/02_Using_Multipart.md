### multipart/form-data

The Swagger spec for each multipart [API](/secure/vendor-api/#/vendor-form) specifies the field names that the API recognizes. The
swagger paramter type is "formData" and the data type is "file".

Example field names are:

  - RegistrationRequest
  - FinancialRecordGroupingFileSet

The Swagger tools seem to have a limitation related to file types and "allowMultiple". Any Lyric FileSet fields always allow multiple, despite what is reported by Swagger.

#### RegistrationRequest

This is expected to be JSON.

#### FileSets

FileSet attachemnts can be csv data, protobuf data, or a zip/tar file. If just sending csv or protobuf data, consider using compression when building the JWE. You can send multiple instances of FileSet object in any combination of "text field" and/or "file attachment". The Lyric API supports quite a few combinations and it can be hard to keep straight. Here's a summary of each:

#### multipart/form-data text/field

Text fields are presumed to be either JOSE or JSON if JOSE is turned off. Therefore, sending multipart data can be as easy as:

    hash = sha256(protoData)
    jws.setPayload = hash

    jwe.setContentType("application/protobuf")
    jwe.setHeader(SIGNATURE, jws.compact())
    jwe.enableDeflateCompression()
    jwe.setPayload(protoData)

    http.setMultipartField("FinancialRecordGroupingFileSet", jwe.compact())

This might generate HTTP that looks like:

    // Multipart
    POST /clients.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuWmpSbVkyWm1PVEpqTVdRM01qWTNOek16TjJJME1ERTRNREkwWldWbE5ESTFNelF6WlRrMU9ESmxNR1EyWlRFMU5EbGpNalEyTW1RMk1EbGpZemcwWXcua25Ydm5ZX3JGZVdfNDg1MWh6UmFHTGgwYXRZQmFEdFV4WUh1SFJHSDB3bm1ESDlFU0JVMU4zZGtBLXVGOFBFZUE2QnlTNV82MWVqc3RCU3FQMmJibnlsNERldXhZNmJLQlpiRTY4TGJqNVdhelNQc3lBLS1lZXoyQ0l0UVo3RE0wbFdNb1QwNWdCTUVROUJPeWhCS0RiT2JEa041UGs3V0tldEM3MTFLVkUxNHJHOExuVzBsRFFpQ3BoMm5oZXRYR1BKVlotaGNCSS10bzloLWI3LWJCUkk3X0N1UEVicDByZnc5RDV5VERuSnBaOXVobDRwVXctdE5yZFBocXAySWJlNWxYSUg1N2tzNjduVnhiQkE3WWdGT0ZTM2s2SWczLVVpT0ZGdldwTUpwSHdnMEJXWXpJNlRvZ2dCMG9FYU5pZ0hMdlNRWWtWR0QzTWhYcDVpalhRIiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.Tew7-1JR0UWyHSCp_AJBx8v_h0I6Btk1SBaIlpcXITmEbByRLC4BevvdKpY5R4Ea6IfWKJmFFui08t22cPxvsEBtebhAyFbsx4My0WomLi_GkKxY8rwY5p6RtKJxLnDrLhpH4LKn5lkCLYopolnlFRG4T6zAygQ-TQowo-1G2VsqLIfGuRzyUtLOlV0w4vwZTxbTeYN1ml3pbd7wiFslPVzkiYtN3HYHNG9rubaOSYCgZbBKQPXlvoSv_h8Juyr8KlE5SKGvQmanMBqeIPM-ny4QdveMJsllWF5L94_XS5IKxubnh4bq-QM8HyqS6YgWUOETTRxxIj56d98hetAUYw.twTj6ak8DD19RP3cvnkFng.ADGhr531ba1Zp9WCfzl3qkYdelPwNVsrtHX2LXobPTCdPn2BPJ-58LFjz61U0uViSM3a8IYAqX0jssKst_7m6C8l-9M2_XnlZnOabPCKR4yPebTPOJFKA6xC_4ITdWiF6SlDHxDmJnpACj0VdQIaOA._m34VETv-KLlShO_ao09LA
    ------LyricBoundaryAL0lfjW6DJtKiwkd--

#### multipart/form-data attachments

Multipart attachments are parsed using standard HTTP protocols. These attachments are JOSE objects and must specify the application/jose Content-Type.

Http transparently accounts for encoding (Content-Transfer-Encoding), so assuming your http client library is up to snuff, there should be no need for extra encoding. The HTTP for a
file attachment might look like:

    // Multipart
    POST /clients.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="earnings.jose"
    Content-Type: application/jose

    eyJTSUdOQVRVUkUiOiJleUpoYkdjaU9pSlNVelV4TWlJc0ltdHBaQ0k2SW5abGJtUnZja0Z3YVV0bGVTSjkuWmpSbVkyWm1PVEpqTVdRM01qWTNOek16TjJJME1ERTRNREkwWldWbE5ESTFNelF6WlRrMU9ESmxNR1EyWlRFMU5EbGpNalEyTW1RMk1EbGpZemcwWXcua25Ydm5ZX3JGZVdfNDg1MWh6UmFHTGgwYXRZQmFEdFV4WUh1SFJHSDB3bm1ESDlFU0JVMU4zZGtBLXVGOFBFZUE2QnlTNV82MWVqc3RCU3FQMmJibnlsNERldXhZNmJLQlpiRTY4TGJqNVdhelNQc3lBLS1lZXoyQ0l0UVo3RE0wbFdNb1QwNWdCTUVROUJPeWhCS0RiT2JEa041UGs3V0tldEM3MTFLVkUxNHJHOExuVzBsRFFpQ3BoMm5oZXRYR1BKVlotaGNCSS10bzloLWI3LWJCUkk3X0N1UEVicDByZnc5RDV5VERuSnBaOXVobDRwVXctdE5yZFBocXAySWJlNWxYSUg1N2tzNjduVnhiQkE3WWdGT0ZTM2s2SWczLVVpT0ZGdldwTUpwSHdnMEJXWXpJNlRvZ2dCMG9FYU5pZ0hMdlNRWWtWR0QzTWhYcDVpalhRIiwiY3R5IjoiYXBwbGljYXRpb24vanNvbiIsInppcCI6IkRFRiIsImFsZyI6IlJTQS1PQUVQLTI1NiIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJraWQiOiJseXJpY0FwaUtleSJ9.Tew7-1JR0UWyHSCp_AJBx8v_h0I6Btk1SBaIlpcXITmEbByRLC4BevvdKpY5R4Ea6IfWKJmFFui08t22cPxvsEBtebhAyFbsx4My0WomLi_GkKxY8rwY5p6RtKJxLnDrLhpH4LKn5lkCLYopolnlFRG4T6zAygQ-TQowo-1G2VsqLIfGuRzyUtLOlV0w4vwZTxbTeYN1ml3pbd7wiFslPVzkiYtN3HYHNG9rubaOSYCgZbBKQPXlvoSv_h8Juyr8KlE5SKGvQmanMBqeIPM-ny4QdveMJsllWF5L94_XS5IKxubnh4bq-QM8HyqS6YgWUOETTRxxIj56d98hetAUYw.twTj6ak8DD19RP3cvnkFng.ADGhr531ba1Zp9WCfzl3qkYdelPwNVsrtHX2LXobPTCdPn2BPJ-58LFjz61U0uViSM3a8IYAqX0jssKst_7m6C8l-9M2_XnlZnOabPCKR4yPebTPOJFKA6xC_4ITdWiF6SlDHxDmJnpACj0VdQIaOA._m34VETv-KLlShO_ao09LA
    ------LyricBoundaryAL0lfjW6DJtKiwkd--

#### Zip/tar archives

If the JOSE object cty header is zip, tar, or x-tar, the API will process each entry in the archive. All entries in the archive must be the same content-type. To tell the API what Content-Type the archive entries are, use the lyric-archive.item-content-type header on the JOSE object. I.e.

    jwe.setPayload(zipData)
    jwe.setHeader("lyric-archive.item-content-type", "application/protobuf")

In some scenarios if you preprocess data, it might be desirable to store individual items encrypted/signed/compressed. Therefore, the API also supports lyric-archive.item-content-type of application/jose(coming soon). If the data is already compressed, using a zip/tar archive might just be slightly more convenient for some.