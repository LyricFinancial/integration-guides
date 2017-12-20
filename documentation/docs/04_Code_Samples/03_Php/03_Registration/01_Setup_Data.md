	# this would be data that you load from your own database
	$curl_post_user_data = json_encode(
	array(
	'userProfile' => array(
		'user' => array(
			'firstName' =>'php',
			'lastName' => 'test',
			'email' => 'phptest@email.com'),
		'vendorAccount' => array(
			'vendorClientAccountId' => 'abc123',
		    'vendorId' => '<your-vendor-id>')
		)
	));

	# create FinancialRecordGroupingFileSet from csv file, 
    # more info can be found here: https://<your-vendor-id>-portal-sandbox.lyricfinancial.com/secure/docs/Server_Integration/FileSets/index.html

    ...load file data from your system
	$csvData = file_get_contents(<your file data>);