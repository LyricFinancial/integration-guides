	# this is generated from the Settings screen of the portal, generate a Lyric API key, then choose Actions -> Create Token
	$token = <token>
	$url = "https://<your-vendor-id>-sandbox.lyricfinancial.com/v1/clients.form";

	$header = array(
		'Authorization: Bearer $token',
		'vendor-id: <your-vendor-id>',
		'Content-Type: multipart/form-data; boundary='.$boundary.'',
		'no-new-financial-records: true'
	);


	$ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HTTPHEADER,$header);
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	  
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $user_data_jwe);

	curl_setopt($ch, CURLOPT_HEADER, 1);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	  
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,2);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER,1);

	# SSL certificate created in the Settings section
	curl_setopt($ch, CURLOPT_SSLCERT, "certificate.pfx"); 
	curl_setopt($ch, CURLOPT_SSLCERTTYPE, 'P12'); 
	curl_setopt($ch, CURLOPT_SSLCERTPASSWD, 'lyric_changeme');
	curl_setopt($ch, CURLOPT_CAINFO, "cachain.crt");
	  
	$data = curl_exec($ch);