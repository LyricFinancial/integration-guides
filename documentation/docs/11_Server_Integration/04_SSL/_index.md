## SSL

You manage SSL keys with the [Settings](/secure/settings/) interface.

Lyric operates a self-signed PKI service using the following two certificates:

- Lyric Root CA
- Lyric Intermediate CA

The key management tool under Settings issues new certificates using the Lyric Intermediate CA. 

While integrating with Lyric's services you are free to toggle SSL off, on, or on with client authentication.
However, while in production client authentication (also known as mutual SSL) is required.

![Api SSL Configs](/Server_Integration/SSL/api_ssl_configs.png)

Further instructions for working with each API are found below:

- [Vendor API](!Server_Integration/SSL/Vendor_Api) 
- [Assignment Service](!Server_Integration/SSL/Assignment_Service) 