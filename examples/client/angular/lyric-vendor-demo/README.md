# Lyric Vendor Demo

This site is an angular example of creating a client to interface with the Lyric Vendor APIs.  It uses the [Lyric Snippet](https://github.com/LyricFinancial/lyric-snippet) to interface with the registration api and has 2 routes to show 2 different use cases.

## /demo-server (Recommended)

This route mimics a vendor site.  It displays basic information for a client and shows the "Get Advance" button.  The serverUrl that it calls defaults to the [Lyric Demo Integration Server](https://github.com/LyricFinancial/lyric-snippet) but can be changed to the vendor's server url (or another deployment of the Demo Integration Server).  It expects a jsonObject as the response that includes accessToken.  This token then needs to be passed back to the Lyric Snippet in the advanceRequestComplete() function.

## /demo

This route calls a server, passing the data that should be sent to they Lyric API.