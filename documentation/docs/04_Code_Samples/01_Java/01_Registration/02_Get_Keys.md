	final JsonObject lyricPublicApiJsonKey = new JsonObject()
		.put("kty","RSA")
		.put("kid", "<lyricPublicApiKeyKeyId>")
		.put("n", <n>)
		.put("e", "AQAB")
		.put("x5c", <x5c>);
    final RsaJsonWebKey lyricPublicApiRsaJsonWebKey = (RsaJsonWebKey) JsonWebKey.Factory.newJwk(lyricPublicApiJsonKey.toString());

    final JsonObject vendorPrivateApiJsonKey = new JsonObject()
		.put("kty","RSA")
		.put("kid", "<vendorPrivateApiKeyKeyId>")
		.put("n", <n>)
		.put("e", "AQAB")
		.put("x5c", <x5c>)
		.put("d", <d>)
		.put("p", <p>)
		.put("dp", <dp>)
		.put("dq", <dq>)
		.put("qi", <qi>);
    final RsaJsonWebKey vendorPrivateApiRsaJsonWebKey = (RsaJsonWebKey) JsonWebKey.Factory.newJwk(vendorPrivateApiJsonKey.toString());

    // load file data