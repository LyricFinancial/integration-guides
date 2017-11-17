	Buffer body = Buffer.buffer();

    buffer.appendString("--" + BOUNDARY + "\n");
    buffer.appendString("Content-Disposition: form-data; name=\"RegistrationRequest\"));
    buffer.appendString("Content-Type: application/jose \n");
    buffer.appendString("\n");
    buffer.appendString(userJweString);
    buffer.appendString("\n");

    buffer.appendString("--" + BOUNDARY + "\n");
    buffer.appendString("Content-Disposition: form-data; name=\"FinancialRecordGroupingFileSet\"));
    buffer.appendString("Content-Type: application/jose; lyric-fileset-file-type=<fileType>; lyric-csv-schema=<schema>" \n");
    buffer.appendString("\n");
    buffer.appendString(fileJweString);
    buffer.appendString("\n");

    body.appendString("--" + BOUNDARY + "--\n");