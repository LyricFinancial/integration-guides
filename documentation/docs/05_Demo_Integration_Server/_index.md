<button><a href="https://github.com/LyricFinancial/demo-integration-server" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

This project is a vertx 3 web server that mimics a vendor's server.  It is set up to be flexible to
demonstrate the various scenarios that a vendor might use to integrate with the Lyric APIs. The primary integration
method is shown in the [Server Demo API](!Demo_Integration_Server/Server_Demo_Api). The Lyric API uses basic authentication and vendor API credentials
should never be exposed to client devices. To experiment with this demo now, you can access the [Server Demo](http://vatm-demo.lyricfinancial.com/#/demo-server)
application. This application demonstrates the full primary integration method with Lyric's APIs. 
However, it is limited as the server uses randomized datasets.

We also created a Client Demo API to support a [demo app](http://vatm-demo.lyricfinancial.com/#/demo)
that is less limited. This app is good for experimenting with the vATM "flow", but is not representative
of "real world" integrations.

## Jose Authentication
If you look at the code for the Demo Integration Server, you'll see that the payload is being signed and then encrypted before being passed along to the Vendor API.  In the case of a pure Json request, the whole body can just be signed and encrypted.  For multipart, each part needs to be signed the encrypted and the request will remain as multipart.  More information can be found in the [Vendor API Documentation]().  

Documentation for both of the demo applications can be found [here](!Angular_Demo).

Use the [API Documentation](https://demoservices.lyricfinancial.com/docs/vendor-api/) to see how to properly
use the Lyric registration API.


## Next Steps

[Configure a new Demo Integration Server](!Demo_Integration_Server/Welcome) to work with the demo apps.
