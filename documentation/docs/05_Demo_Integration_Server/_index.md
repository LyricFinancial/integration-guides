<button><a href="https://github.com/LyricFinancial/demo-integration-server" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

This project is a vertx 3 web server that mimics a vendor's server.  It is set up to be flexible to
demonstrate the various scenarios that a vendor might use to integrate with the Lyric APIs. The primary integration method is shown in the [Server Demo API](!Demo_Integration_Server/Server_Demo_Api). The Lyric API uses basic authentication and vendor API credentials should never be exposed to client devices. To experiment with this demo now, you can access the [Server Demo](http://client-demo-stage.lyricfinancial.com/#/demo-server) application. This application demonstrates the full primary integration method with Lyric's APIs. However, it is limited as the server uses randomized datasets.

We also created a Client Demo API to support a [demo app](http://client-demo-stage.lyricfinancial.com/#/demo)
that is less limited. This app is good for experimenting with the vATM "flow", but is not representative
of "real world" integrations.

## Mutual SSL
It is required that mutual ssl be turned on for production environments.  To configure your SSL in Lyric's environment see the [SSL Documentation](!Server_Integration/SSL).  To configure mutual SSL on your server, you'll need the P12 file and CA Chain certificate from the Vendor SSL that you generated and set to use in the Api config section.  An example of how this was implemented in our vertx project can be found [here](https://github.com/LyricFinancial/demo-integration-server/blob/master/src/main/java/com/lyric/controllers/DemoBaseController.java).

## Jose Authentication
If you look at the code for the Demo Integration Server, you'll see that the payload is being signed and then encrypted before being passed along to the Vendor API.  In the case of a pure Json request, the whole body can just be signed and encrypted.  For multipart, each part needs to be signed the encrypted and the request will remain as multipart.  More information can be found in the [Vendor API Documentation](/secure/vendor-api/) and the [Security Documentation](!Server_Integration/Sign_Encrypt).  

Documentation for both of the demo applications can be found [here](!Angular_Demo).

Use the [API Documentation](/secure/vendor-api/) to see how to properly
use the Lyric registration API.


## Next Steps

[Configure a new Demo Integration Server](!Demo_Integration_Server/Welcome) to work with the demo apps.
