	# this would be data that you load from your own database
	var userJson = JSON.stringify({userProfile: {user: { firstName: 'node', lastName: 'test', email: 'nodetest@email.com'}, vendorAccount: { vendorClientAccountId: 'abc123', vendorId: '<your-vendor-id>'}}})

    # create FinancialRecordGroupingFileSet from csv file, 
    # more info can be found here: https://<your-vendor-id>-portal-sandbox.lyricfinancial.com/secure/docs/Server_Integration/FileSets/index.html
    var fileData = fs.readFileSync('yourFile.csv', 'utf8');