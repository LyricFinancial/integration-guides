	# create RegistrationRequest part from user json
	$hashedUserData = hash('sha256', $curl_post_user_data);

	# create a JWS with the user data
	$user_data_jws = JWSFactory::createJWSToCompactJSON(
	    $hashedUserData,                     // The payload or claims to sign
	    $vendor_jwk,                 // The key used to sign
	    [                             // Protected headers. Must contain at least the algorithm
	        'alg'  => 'RS256',
	        'cty' => 'text/plain',
	        'kid' => '<vendorPrivateKeyKeyId>'
	    ]
	);

	# create a JWE using the JWS as the signature
	$user_data_jwe = JWEFactory::createJWEToCompactJSON(
	  (string)$curl_post_user_data,
	    $lyric_jwk,                        // The key of the recipient
	    [
	        'alg' => 'RSA1_5',
	        'enc' => 'A128CBC-HS256',
	        'zip' => 'DEF',
	        'cty' => 'application/json',
	        'kid' => '<lyricPublicKeyKeyId>',
	        'SIGNATURE' => $user_data_jws
	      ]
	);    



	$hashedCsvData = hash('sha256', $csvData);

	# create a JWS with the file data
	$history_data_jws = JWSFactory::createJWSToCompactJSON(
	    $hashedCsvData,                     // The payload or claims to sign
	    $vendor_jwk,                 // The key used to sign
	    [                             // Protected headers. Muse contains at least the algorithm
	        'alg'  => 'RS256',
	        'cty' => 'text/plain',
	        'kid' => '<vendorPrivateKeyKeyId>'
	    ]
	);

	# create a JWE using the JWS as the signature
	$history_data_jwe = JWEFactory::createJWEToCompactJSON(
		(string)$csvData,
	    $lyric_jwk,                        // The key of the recipient
	    [
	        'alg' => 'RSA1_5',
	        'enc' => 'A128CBC-HS256',
	        'zip' => 'DEF',
	        'cty' => 'text/csv',
	        'kid' => '<lyricPublicKeyKeyId>',
			'lyric-fileset.file-type' => '<fileType>',
			'lyric-csv.schema' => '<schema>',
			'lyric-csv-date-format-string' => '<your date format>',
			'lyric-csv-use-header' => 'false',
	        'SIGNATURE' => $history_data_jws
	      ]
	);   