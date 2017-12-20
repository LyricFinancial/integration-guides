	# this would be data that you load from your own database
	JsonObject user = new JsonObject()
		.put("firstName", "java")
		.put("lastName", "test")
		.put("email", "javatest@email.com");

	JsonObject vendorAccount = new JsonObject()
		.put("vendorClientAccountId", "abc123")
		.put("vendorId", "<your-vendor-id>");

	JsonObject userProfile = new JsonObject()
		.put("user", user)
		.put("vendorAccount", vendorAccount);

	// load file data