    # Sign & Encrypt User Data
    var userJsonHash = crypto.createHash('sha256').update(userJson).digest('hex');

    p = p.then(() => jose.JWS.createSign({ alg: 'RS256', format: 'compact', kid: "<vendorPrivateKeyKeyId>", fields: { cty: 'text/plain' } }, privateKey).update(userJsonHash).final());
    p = p.then((r) => userJws = r);
    p = p.then(() => jose.JWE.createEncrypt({ alg: 'RSA1_5', format: 'compact', zip: true, kid: "<lyricPublicKeyKeyId>", fields: { cty : 'application/json', 'SIGNATURE': userJws } }, publicKey).
            update(String(userJson)).
            final());
    p = p.then((r) => userJwe = r);


    # Sign & Encrypt File Data
    var fileData = fs.readFileSync('943344.csv', 'utf8');
    var fileDataHash = crypto.createHash('sha256').update(new Buffer(fileData, "binary")).digest('hex');

    p = p.then(() => jose.JWS.createSign({ alg: 'RS256', format: 'compact', kid: "<vendorPrivateKeyKeyId>", fields: { cty: 'text/plain' } }, privateKey).update(fileDataHash).final());
    p = p.then((r) => fileDataJws = r);
    p = p.then(() => {
      return jose.JWE.createEncrypt({ alg: 'RSA1_5', format: 'compact', zip: true, kid: "<lyricPublicKeyKeyId>", fields: { cty : 'text/csv', 'SIGNATURE': fileDataJws, "lyric-fileset.file-type": "fileType", "lyric-csv.schema": "schema" } }, publicKey).
            update(fileData.toString()).
            final();
    });
    p = p.then((r) => fileDataJwe = r);