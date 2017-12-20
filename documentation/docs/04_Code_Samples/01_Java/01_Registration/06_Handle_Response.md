
    cRes.bodyHandler(data -> {

        if(cRes.statusCode() != 201 && cRes.statusCode() != 202){
            //handle error
        }

        JsonWebEncryption jwe = null;
        try {
        	JsonWebEncryption jwe = new JsonWebEncryption();

        	jwe.setCompactSerialization(data.toString());

        	jwe.setKey(vendorPrivateApiRsaJsonWebKey.getRsaPrivateKey());
        } catch (JoseException e) {
            //handle decryption error
        }

        JsonObject response = null;
        try {
            response = new JsonObject(jwe.getPlaintextString());
            //store member token
        } catch (JoseException e) {
            e.printStackTrace();
        }


    });