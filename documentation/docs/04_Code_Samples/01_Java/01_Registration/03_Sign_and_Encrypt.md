	
	// ********** Sign the User data **********
	final HashCode userContentHash = hashFunction.hashBytes(client.toString().getBytes());

    JsonWebSignature userJws = new JsonWebSignature();

    userJws.setPayload(contentHash.toString());
    userJws.setKey(vendorPrivateApiRsaJsonWebKey.getRsaPrivateKey());
    userJws.setContentTypeHeaderValue("text/plain");
    userJws.setKeyIdHeaderValue(vendorPrivateApiRsaJsonWebKey.getKeyId());
    userJws.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);

    // ********** Encrypt the User data **********
    JsonWebEncryption jwe = new JsonWebEncryption();

    jwe.setHeader("SIGNATURE", signature.getCompactSerialization());
    jwe.setContentTypeHeaderValue("application/json");

    jwe.enableDefaultCompression();

    // The plaintext of the JWE is the message that we want to encrypt.
    jwe.setPlaintext(userJws);
    jwe.setAlgorithmHeaderValue(KeyManagementAlgorithmIdentifiers.RSA1_5);
    // Set the "enc" header, which indicates the content encryption algorithm to be used.
    jwe.setEncryptionMethodHeaderParameter(ContentEncryptionAlgorithmIdentifiers.AES_128_CBC_HMAC_SHA_256);

    // Set the key on the JWE.
    jwe.setKey(lyricPublicApiJsonKey.getRsaPublicKey());
    jwe.setKeyIdHeaderValue(lyricPublicApiJsonKey.getKeyId());

    String userJweString jwe.getCompactSerialization();

    // ********** Sign the File data **********
    final HashCode fileContentHash = hashFunction.hashBytes(<file data bytes>);
    JsonWebSignature fileJws = new JsonWebSignature();

    fileJws.setPayload(fileContentHash.toString());
    fileJws.setKey(vendorPrivateApiRsaJsonWebKey.getRsaPrivateKey());
    fileJws.setContentTypeHeaderValue("text/plain");
    fileJws.setKeyIdHeaderValue(vendorPrivateApiRsaJsonWebKey.getKeyId());
    fileJws.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);


    // ********** Encrypt the File data **********
    JsonWebEncryption fileJwe = new JsonWebEncryption();

    fileJwe.setHeader("SIGNATURE", signature.getCompactSerialization());
    fileJwe.setContentTypeHeaderValue("text/csv");

    fileJwe.setHeader("lyric-fileset.file-type", "<fileType>");
    fileJwe.setHeader("lyric-csv.schema", "<schema>");

    fileJwe.enableDefaultCompression();

    // The plaintext of the JWE is the message that we want to encrypt.
    fileJwe.setPlaintext(fileJws);
    fileJwe.setAlgorithmHeaderValue(KeyManagementAlgorithmIdentifiers.RSA1_5);
    // Set the "enc" header, which indicates the content encryption algorithm to be used.
    fileJwe.setEncryptionMethodHeaderParameter(ContentEncryptionAlgorithmIdentifiers.AES_128_CBC_HMAC_SHA_256);

    // Set the key on the JWE.
    fileJwe.setKey(lyricPublicApiJsonKey.getRsaPublicKey());
    fileJwe.setKeyIdHeaderValue(lyricPublicApiJsonKey.getKeyId());

    String fileJweString jwe.getCompactSerialization();