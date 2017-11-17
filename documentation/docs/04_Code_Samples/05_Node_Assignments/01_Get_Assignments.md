    # this is generated from the Settings screen of the portal, generate a Lyric API key, then choose Actions -> Create Token
    let token = <token>;

    # create a new Vendor SSL key and download the pfx file to use here
    var pfxFile = path.resolve('certificate.pfx')

    # toDate cannot be within 5 minutes of the current time to allow for data synchronization, it is best to make the code that is calling this function idempotent, so if can handle pulling the same assignment multiple times
    var fromDate = '2017-11-10T00:00:00'
    var toDate = '2017-11-15T23:59:99'

    var options = {
		url: 'https://<your-vendor-id>.lyricfinancial.com/v1/assignments',
		qs: { "fromDate":fromDate, "toDate":toDate },
		agentOptions: {
			pfx: fs.readFileSync(pfxFile),
			passphrase: 'lyric_changeme',
			securityOptions: 'SSL_OP_NO_SSLv3'
		},
		headers: {
			'Content-Type': 'application/jose',
			'Authorization': 'Bearer ' + token,
			'vendor-id': <your-vendor-id>
		}
    };

    request.get(options, callback);

    function callback(error, response, body) {

		if (error) { return console.log(error); }
		console.log(response.statusCode);

		var privateKeyFile = fs.readFileSync('vendorPrivateKey.json', 'utf8');
		var publicKeyFile = fs.readFileSync('lyricPublicKey.json', 'utf8');

		let p, privateKey, publicKey, decryptedResult;

		p = jose.JWK.asKey(privateKeyFile);
		p = p.then((r) => privateKey = r);
		p = p.then(() => jose.JWK.asKey(publicKeyFile));
		p = p.then((r) => publicKey = r);

		p = p.then(() => jose.JWE.createDecrypt(privateKey).decrypt(response.body));
		p = p.then((r) => {
			decryptedResult = r;
			return jose.JWS.createVerify(publicKey).verify(decryptedResult.header['SIGNATURE']);
		}).catch((err) => console.log(err));
		p = p.then((isValid) => {
			if (!isValid){
			  console.log('not a valid signature');
			  return;
			}
			console.log(decryptedResult.payload.toString());
		});

    }