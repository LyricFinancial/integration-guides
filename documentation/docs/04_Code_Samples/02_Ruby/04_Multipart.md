	# this is generated from the Settings screen of the portal, generate a Lyric API key, then choose Actions -> Create Token
    token = <token>

	# specify the parts of your multipart request using the jwe's of the body of each part
    parts = {
      :RegistrationRequest => userDataJwe,
      :FinancialRecordGroupingFileSet => fileJwe
      // :FinancialRecordGroupingFileSet => file2Jwe
    }
    headers = {
      'transfer-encoding' => 'chunked',
      :Authorization => 'Bearer ' + token,
      :vendor-id => '<your-vendor-id>',
      
      # this is where you can set the content type for each part, needs to be application/jose
      :parts => {
        :RegistrationRequest => { "Content-Type" => "application/jose" },
        :FinancialRecordGroupingFileSet => { "Content-Type" => "application/jose" }
      }
    }