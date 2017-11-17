	p.then(() => {
        var formData = {
            RegistrationRequest: userJwe,
            FinancialRecordGroupingFileSet: fileDataJwe
        };

        # create a new Vendor SSL key and download the pfx file to use here
        var pfxFile = path.resolve('ssl/certificate.pfx')

        # this is generated from the Settings screen of the portal, generate a Lyric API key, then choose Actions -> Create Token
        let token = <token>;

        var options = {
            url: 'https://<your-vendor-id>.lyricfinancial.com/v1/clients.form',
            agentOptions: {
                pfx: fs.readFileSync(pfxFile),
                passphrase: 'lyric_changeme',
                securityOptions: 'SSL_OP_NO_SSLv3'
            },
            headers: {
                'transfer-encoding': 'chunked',
                'Authorization': 'Bearer ' + token,
                'vendor-id': '<your-vendor-id>'
            },
            formData: formData
        };

        request.post(options, callback);
    });