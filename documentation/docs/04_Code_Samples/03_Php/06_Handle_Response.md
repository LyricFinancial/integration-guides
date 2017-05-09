	$header_size = curl_getinfo($this->ch,CURLINFO_HEADER_SIZE);
    $result['header'] = substr($data, 0, $header_size);
    $result['body'] = substr( $data, $header_size );
    $result['http_code'] = curl_getinfo($this -> ch,CURLINFO_HTTP_CODE);
	
	...check http_code to make sure a 400 or 500 wasnt thrown, a 400 provides detail as to why the request was bad

	...get the access-token header to use to redirect to SNAP

	var_dump("***************HEADERS:");
	var_dump($result['header']);
	var_dump("***************RESPONSE:");
	var_dump($result['http_code']);

	curl_close($ch);

	// We create our loader.
	$loader = new Loader();

	$jws = $loader->loadAndDecryptUsingKey(
	    $result['body'],            // The input to load and decrypt
	    $vendor_jwk,     // The symmetric or private key
	    ['RSA-OAEP-256'],      // A list of allowed key encryption algorithms
	    ['A128CBC-HS256'],       // A list of allowed content encryption algorithms
	    $recipient_index   // If decrypted, this variable will be set with the recipient index used to decrypt
	);

	var_dump($jws);