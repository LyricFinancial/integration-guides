	decryptedBody = JOSE::JWE.block_decrypt(private_key, res.body)
    puts decryptedBody.first

    # you'll want to get the access-token from the header and use that to redirect to SNAP