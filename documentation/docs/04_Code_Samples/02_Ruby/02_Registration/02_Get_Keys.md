	# replace these values with the lyric public key that you create under Settings
    public_key = JOSE::JWK.from_file("lyricApiPublicKey.json")
    
    # replace these values with the vendor private key that you create under Settings
    private_key = JOSE::JWK.from_file("vendorApiPrivateKey.json")