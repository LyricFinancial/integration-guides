  	function callback(error, response, body) {
	 	if (error) { return console.log(error); }

	 	if(response.statusCode == 400){
	 		# there was something wrong with the data that was sent, either required information was missing or there was not enough song data sent
	 		# this needs to be handled, you cannot redirect to SNAP if a 400 is returned
	 		return;
	 	}

	 	if(response.statusCode == 500){
	 		# there was an internal server error
	 		# this needs to be handled, you cannot redirect to SNAP if a 500 is returned
	 		return;
	 	}

	 	# this is the accessToken returned that you will use to redirect to SNAP, if there is no accessToken, you cannot redirect to SNAP
		accessToken = response.headers['access-token'];

		let q, decryptedResult;

		# decrypt the response and then verify the signature
		q = jose.JWE.createDecrypt(privateKey).decrypt(response.body);
		q = q.then((r) => {
			decryptedResult = r;
			return jose.JWS.createVerify(publicKey).verify(decryptedResult.header['SIGNATURE']);
		}).catch((err) => false);
		q = q.then((isValid) => {
			if (!isValid){
			  console.log('not a valid signature');
			  return;
			}
			userJson = JSON.parse(decryptedResult.payload.toString());
			# the memberToken is the users unique key in the Lyric system
			memberToken = userJson.vendorAccount.memberToken;
		});

	}