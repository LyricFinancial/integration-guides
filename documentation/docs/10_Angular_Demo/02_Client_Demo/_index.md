## /demo

This route calls a server, passing the data that should be sent to the Lyric API.  
	
    This demo calls the /clients/:id/advance_client endpoint.

### Advanced Options

#### Server Url
This is the url of the server that this client demo will POST to.  By default it is pointed to the [Demo Integration Server](!Demo_Integration_Server).  This server just acts as a proxy to the Lyric registration API.  There is a placeholder for :vendorClntAcctId.  During the post, this value gets replaced with the value entered in the vendorClientAccountId.  This value can be changed to any server that will call the Lyric registration API.
