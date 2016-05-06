## Vendor API SSL

Lyric hosts the vendor API. Each vendor has a unique API endpoint.

### Getting Started

For this API, the Lyric Certificate is the server certificate and the Vendor Certificate is the client.

#### Verify connectivity

1. Goto [settings](/secure/settings/)
2. Find the Vendor API Endpoint under Endpoints
3. Ensure no SSL and that this curl statement responds

 
        curl http://demo-dev.lyricfinancial.com/status

If the endpoint scheme is https you can turn off SSL under Api Config.

#### Turn SSL On

1. Generate a new Lyric Certificate
2. Download the CA Chain
3. Go to API Configs
4. Check the SSL checkbox
5. Set Client Auth to NONE
6. Choose the Lyric SSL Certificate you just made and press Save
7. Ensure this curl statement responds


        curl --cacert ./cachain.crt https://demo-dev.lyricfinancial.com/status
    
#### Turn Client Authentication (Mutual SSL) On

1. Generate a new Vendor Certificate (or submit a CSR)
2. Download the P12 file (If you submitted a CSR you'll need to make a P12 file)
3. Go to API Configs
4. Select Client Auth REQUIRED
5. Choose the Vendor SSL Certificate you generated in step #1
6. Ensure this curl statement responds


        curl --cert ./certificate.pfx:lyric_changeme --cacert ./cachain.crt https://demo-dev.lyricfinancial.com/status
  
When you generate a Vendor Certificate the default p12 password is "lyric_changeme". You can select more than one Vendor Certificate under
Api Config. This way you can test a new certificate before removing the old one.
