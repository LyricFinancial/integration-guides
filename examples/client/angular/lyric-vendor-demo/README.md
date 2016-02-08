# Lyric Vendor Demo

This site is an angular example of creating a client to interface with the Lyric Vendor APIs.  It uses the [Lyric Snippet](https://github.com/LyricFinancial/lyric-snippet) to interface with the registration api and has 2 routes to show 2 different use cases.

## /demo-server (Recommended)

This route mimics a vendor site.  It displays basic information for a client and shows the "Get Advance" button.  The serverUrl that it calls defaults to the [Lyric Demo Integration Server](https://github.com/LyricFinancial/demo-integration-server) but can be changed to the vendor's server url (or another deployment of the Demo Integration Server).  It expects the accessToken to be returned as a header.  This token then needs to be passed back to the Lyric Snippet in the advanceRequestComplete() function.

	This demo calls the **/clients/:id/advance_server** endpoint.

### Content Type

#### Json
If the json content type is chosen, then the server will construct the data for the Lyric registration API as application/json.  There is then an option for the content type of the Royalty Earnings.  If text/csv is chosen then it will look on the file system for a file with the specified filename.

#### Multipart (Not Implemented Yet)

## /demo

This route calls a server, passing the data that should be sent to the Lyric API.  
	
	This demo calls the **/clients/:id/advance_client** endpoint.

### Content Type

#### Json
If the json content type is chosen, then data will be passed to the server as application/json.  There is then an option for the content type of the Royalty Earnings.  If text/csv is chosen then data from a comma separated file can be pasted into the text box.  This data is then base64 encoded and included in the json.

#### Multipart
If the multipart content type is chosen, then the data will be passed to the server as multipart/form-data.  A file can be uploaded for Royalty Earnings and that will get included in the multipart payload.

### Advanced Options

#### Server Url
This is the url of the server that this client demo will POST to.  By default it is pointed to the [Demo Integration Server](https://github.com/LyricFinancial/demo-integration-server).  This server just acts as a proxy to the Lyric registration API.  There is a placeholder for :vendorId.  During the post, this value gets replaced with the value entered in the vendorClientAccountId.  This value can be changed to any server that will call the Lyric registration API.

## /lyric-widget
This route mimics the home page of a client's account who has already taken an advance. It adds the widget to the page using ng-bind-html.  
