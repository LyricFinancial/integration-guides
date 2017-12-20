	# this would be data that you load from your own database
	userData = {
      "userProfile" => {
        "user" => {
            "firstName" => "ruby",
            "lastName" => "test"
            "email" => "rubytest@email.com",
          
        },
        "vendorAccount"=> {
            "vendorClientAccountId"=> "abc123",
            "vendorId"=><your-vendor-id>
        }
      }
    }.to_json

    # create FinancialRecordGroupingFileSet from csv file, 
    # more info can be found here: https://<your-vendor-id>-portal-sandbox.lyricfinancial.com/secure/docs/Server_Integration/FileSets/index.html
    fileCsv = File.read "yourFile.csv"