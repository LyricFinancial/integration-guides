<button><a href="https://github.com/LyricFinancial/demo-integration-server" target="_blank" class="btn btn-secondary btn-hero">View On GitHub</a></button>

This project is a vertx 3 web server that mimics a vendor's server.  It is set up to be flexible to
demonstrate the various scenarios that a vendor might use to integrate with the Lyric APIs. The primary integration
method is shown in the [Server Demo API](#server-demo-api). The Lyric API uses basic authentication and vendor API credentials
should never be exposed to client devices. To experiment with this demo now, you can access the [Server Demo](http://lyricfinancial.github.io/integration-guides/#/demo-server)
application. This application demonstrates the full primary integration method with Lyric's APIs. 
However, it is limited as the server uses randomized datasets.

We also created a [Client Demo API](#client-demo-api) to support a [demo app](http://lyricfinancial.github.io/integration-guides/#/demo)
that is less limited. This app is good for experimenting with the vATM "flow", but is not representative
of "real world" integrations.

Documentation for both of the demo applications can be found [here](https://github.com/LyricFinancial/integration-guides/tree/master/examples/client/angular/lyric-vendor-demo).

Use the [API Documentation](https://api.lyricfinancial.com/docs/vendor-api/) to see how to properly
use the Lyric registration API.


## Next Steps

[Configure a new Demo Integration Server](Welcome.md) to work with the demo apps.
