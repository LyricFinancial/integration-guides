	$fieldName = "RegistrationRequest";
	$body = $body."\r\n".$boundary;
	$body = $body."\r\n". implode("\r\n", array(
        "Content-Disposition: form-data; name=\"{$fieldName}\"",
        "Content-Type: application/jose",
        "",
        $user_data_jwe,
    ));


	$fieldName = "FinancialRecordGroupingFileSet";
	$fileName = basename($csvFile);
	$body = $body."\r\n".$boundary;
	$body = $body."\r\n". implode("\r\n", array(
	            "Content-Disposition: form-data; name=\"{$fieldName}\"; filename=\"{$fileName}\"",
	            "Content-Type: application/jose",
	            "",
	            $history_data_jwe,
	        ));

	$body = $body."\r\n".$boundary."--";  //ending boundary