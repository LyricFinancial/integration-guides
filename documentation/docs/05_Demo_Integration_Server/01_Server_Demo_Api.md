## Server Demo API
This API demonstrates how to use the Lyric API. The endpoint is **/clients/:clientId/advance_server**. 
It is invoked from the [Server Demo](http://lyricfinancial.github.io/integration-guides/#/demo-server) application when pressing "Get Advance". The example code [here](https://github.com/LyricFinancial/demo-integration-server/blob/master/src/main/java/com/lyric/ServerDemoController.java) shows how to POST registrations to the Lyric API. Currently earnings data can only be posted using multipart/form-data. Eventually we will also have ways to embed this in a standard JSON call. However, multipart/form-data will be preferred as it will allow for smaller payloads. You can toggle between JSON and Mutlipart Form when using the demo app.

This API mimics taking the id from the url and using that to look the user up in the system.  This
demo creates a new unique user to pass to the API.  To trigger this flow, **an options json object must
be sent as the body of the request**.  The options tell the server how the data should be sent to the
Lyric registration API and how the Royalty Earnings should be retrieved and sent.  These options are
strictly for demo and testing purposes so that all of the different scenarios can be explored.  The
options json should look like:

    "options": {
        "contentType":"multipart/form-data"
        "royaltyEarningsContentType": "text/csv",
        "filename": "sample.csv"
    }

The endpoint is **/clients/:clientId/advance_server**.  There needs to be a file on the server with the
specified filename.  Right now the only file is sample.csv.
