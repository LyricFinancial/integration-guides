## Assignment Service SSL

Each vendor will host an assignment service API endpoint. Lyric will connect to this endpoint using Client Authentication SSL.

### Getting Started

For this API, the Vendor Certificate is the server certificate and the Lyric Certificate is the client. The assignment service
can share certificates with the vendor API or use separate ones.

#### Verify connectivity

Lyric makes an HTTP Post to <host>/clients/<id>/assignments. You can test the connection first without SSL by turning SSL
off under Assignment Configs.

#### Turn SSL On

1. Generate a new Vendor Certificate (or you can reeuse an existing one)
2. Download the P12 file (If you submitted a CSR you'll need to make a P12 file)
3. Configure your server for SSL using the Key and Certificates in the P12 file.
4. Go to Assignment Configs
5. Check the SSL checkbox
6. Set Client Auth to NONE
7. Choose the Vendor SSL Certificate you just made and press Save
8. Process a test advance and verify the POST

    
#### Turn Client Authentication (Mutual SSL) On

This is still a work in progress.

1. Generate a new Lyric Certificate
2. Go to Assignment Configs
3. Choose the Lyric SSL Certificate you generated in step #1
4. Retest the assignment POST
  
When you generate a Vendor Certificate the default p12 password is "lyric_changeme".