	let p, privateKey, publicKey;

	# this should point to a file that was created with the vendor private key created under Settings
	var privateKeyFile = fs.readFileSync('vendorApiPrivateKey.json', 'utf8');
	# this should point to a file that was created with the lyric public key created under Settings
	var publicKeyFile = fs.readFileSync('lyricApiPublicKey.json', 'utf8');

    p = jose.JWK.asKey(privateKeyFile);
	p = p.then((r) => privateKey = r);
	p = p.then(() => jose.JWK.asKey(publicKeyFile));
	p = p.then((r) => publicKey = r);