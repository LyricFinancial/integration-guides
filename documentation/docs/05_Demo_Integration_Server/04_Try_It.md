You are free to experiment with the Lyric Demo server, [deployed here](https://lyric-demo-server.herokuapp.com). In fact, the Demo Apps are preconfigured to work with this server. They also allow you to change vendorID and API credentials under Advance Settings. However, if want to experiment with your own server, you can use this Heroku button to deploy your own instance.

> The Demo Integration Server is deployed at **https://lyric-demo-server.herokuapp.com** and the url to request an advance is **https://lyric-demo-server.herokuapp.com/clients/:clientId/advance_client** and **https://lyric-demo-server.herokuapp.com/clients/:clientId/advance_server**.

This project can be forked and used to make modifications.  You can then deploy it to your own heroku
instance.  Make sure to set the vendorId, username and password environment variables in heroku once
it is deployed.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/LyricFinancial/demo-integration-server)