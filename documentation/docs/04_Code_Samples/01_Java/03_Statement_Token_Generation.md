This snippet demonstrates how the vendor will need to generate a statement token that can be used to redirect to the Lyric Statement website so a client can view their account statement information.  The token needs to be signed with the vendor's private key and include the memberToken and vendorId as a claim.  The audience of the key must be "statementApi". An authorities claim must also be set to give the token the proper permissions. Use one of your "Vendor API" keys to sign the JWT.

    JwtClaims claims = new JwtClaims();
    claims.setIssuer("Vendor");
    claims.setAudience("statementApi"); // to whom the token is intended to be sent
    claims.setExpirationTimeMinutesInTheFuture(30); // time when the token will expire this shouldn't be too long
    claims.setJwtId(UUID.randomUUID().toString());; // a unique identifier for the token
    claims.setIssuedAtToNow();  // when the token was issued/created (now)
    claims.setNotBeforeMinutesInThePast(2); // time before which the token is not yet valid (2 minutes ago)
    claims.setSubject(UUID.randomUUID().toString());

    claims.setClaim("vendorId", "<your-vendor-id>"); // set to your vendorId
    claims.setClaim("memberToken", <memberToken>);

    List<String> permissions = new ArrayList<>();
    permissions.add("https://statement-api.lyricfinancial.com/statements.read");  // this permission makes it so the token can be used to read the client's account statement
    claims.setStringListClaim("authorities", permissions);


    // A JWT is a JWS and/or a JWE with JSON claims as the payload.
    // In this example it is a JWS so we create a JsonWebSignature object.
    JsonWebSignature jws = new JsonWebSignature();

    // The payload of the JWS is JSON content of the JWT Claims
    jws.setPayload(claims.toJson());

    // The JWT is signed using the private key
    jws.setKey(vendorRsaJsonWebKey.getPrivateKey());

    // Set the Key ID (kid) header because it's just the polite thing to do.
    // We only have one key in this example but a using a Key ID helps
    // facilitate a smooth key rollover process
    jws.setKeyIdHeaderValue(vendorRsaJsonWebKey.getKeyId());

    // Set the signature algorithm on the JWT/JWS that will integrity protect the claims
    jws.setAlgorithmHeaderValue(AlgorithmIdentifiers.RSA_USING_SHA256);

    // Sign the JWS and produce the compact serialization or the complete JWT/JWS
    // representation, which is a string consisting of three dot ('.') separated
    // base64url-encoded parts in the form Header.Payload.Signature
    // If you wanted to encrypt it, you can simply set this jwt as the payload
    // of a JsonWebEncryption object and set the cty (Content Type) header to "jwt".
    return jws.getCompactSerialization();