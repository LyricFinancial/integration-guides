	# create RegistrationRequest part from user json
    hashedUserData = Digest::SHA256.hexdigest userData
    userDataJws = JOSE::JWS.sign(private_key, hashedUserData, { "alg" => "RS256", "cty" => "text/plain", "kid" => "<vendorPrivateKeyKeyId>" }).compact

    userDataJwe = JOSE::JWE.block_encrypt(public_key, userData.to_s, { "alg" => "RSA1_5", "enc" => "A128CBC-HS256", "cty" => "application/json", "SIGNATURE" => userDataJws, "kid" => "<lyricPublicKeyKeyId>", "zip" => "DEF" }).compact

    # create FinancialRecordGroupingFileSet part from the file data, create a part for each file that needs to be sent
    hashedFileCsv = Digest::SHA256.hexdigest fileCsv
    fileJws = JOSE::JWS.sign(private_key, hashedFileCsv, { "alg" => "RS256", "cty" => "text/plain", "kid" => "<vendorPrivateKeyKeyId>" }).compact

    fileJwe = JOSE::JWE.block_encrypt(public_key, fileCsv, { "alg" => "RSA1_5", "enc" => "A128CBC-HS256", "cty" => "text/csv", "SIGNATURE" => fileJws, 
      "kid" => "<lyricPublicKeyKeyId>", "lyric-fileset.file-type" => "<fileType>", "lyric-csv.schema" => "<schema>", "zip" => "DEF" }
    ).compact