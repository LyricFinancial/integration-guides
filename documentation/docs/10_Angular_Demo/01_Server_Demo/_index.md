## /demo-server (Recommended)

This route mimics a vendor site.  It displays basic information for a client and shows the "Get Advance" button.  The serverUrl that it calls defaults to the [Lyric Demo Integration Server](!Demo_Integration_Server) but can be changed to the vendor's server url (or another deployment of the Demo Integration Server).  It expects the accessToken to be returned as a header.  This token then needs to be passed back to the Lyric Snippet in the advanceRequestComplete() function.

    This demo calls the /clients/:id/advance_server endpoint.