# Server Integration Guide

When a client requests a vATM advance the partner's server will share client data with Lyric. Lyric uses this data to calculate advance limits.

Lyric's primary [Vendor API](/secure/vendor-api/) uses JSON via REST endpoints with JOSE message security. Usually, partners use Lyric's Registration API which sends Lyric name, phone, and address. You can also send royalty/sales and distribution data in this same API call or as a separate call. Lyric requires projects an advance limit using up to three years of earnings data. At least one year of data is required. There are several methods of sending this data.

## Concepts

Start here, to understand a few basic concepts first. Then, look at specific API detail.

  - [SSL](!Server_Integration/SSL)
  - [Sign/Encrypt](!Server_Integration/Sign_Encrypt)
  - [FileSet concepts](!Server_Integration/FileSets)
  - [FinancialRecord concepts](!Server_Integration/FinancialRecords)

## Apis

When transfering a client to Lyric you have 3 options.

  1. Make a single Registration api call passing both the UserProfile and FileSet data.
  2. Make two separate calls, one to Register and a second to pass FileSet data.
  3. Don't send FileSet data and only make a single Registration call.

Only one year of earnings data is required. You can send this data on every request if you like, however, if you track what you send Lyric, we allow you to
optimize this process as described in option #3 above. To use this option, you must keep track of when you send data to us and if any new data is available.
If you know that you have already sent Lyric all the available data, then look at the "NO_NEW_FINANCIAL_RECORDS" header option.


### Synchronous Mode

If you use Lyric Snippet's in "Synchronous" mode then it only really makes sense to make a single Registration api call as described above in options #1 and #3.

  - [Client Registration](!Server_Integration/Apis/upsert_client)

### Asynchronous Mode

However, if you use Lyric Snippet in "Asynchronous" mode then some analysis might be required to determine which option is best. Remember that in "Asynchronous" mode
the user is transferred to Lyric's vATM immediately. Here, they will wait at least until Lyric receives the demographic data in the UserProfile.

A crude analysis to make the point:

  > Large data files might slow down a single API call enough that the user wait is excessive. In this case, making two separate calls
  > First, Registration with just UserProfile and second the FinancialRecord FileSet API, concurrently, allows Lyric to verify demographics and
  > start collecting missing data while the large file is still transferring/processing. However, the overhead of two network requests might
  > be more of a factor with smaller files.

For "Asynchronous" mode you will use both APIs:

  - [Client Registration](!Server_Integration/Apis/upsert_client)
  - [FinancialRecord FileSets](!Server_Integration/Apis/create_financial_record_file_sets)