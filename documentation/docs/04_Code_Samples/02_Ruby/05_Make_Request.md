    url = URI.parse('https://<your-vendor-id>-sandbox.lyricfinancial.com/v1/clients.form')

    http = Net::HTTP.new(url.host,url.port)
    http.set_debug_output $stderr

    req = Net::HTTP::Post::Multipart.new url.path, parts, headers

    # SSL certificate created in the Settings section
    pem = File.read("certificate.pem")
    http.use_ssl = true
    http.cert = OpenSSL::X509::Certificate.new pem
    http.key = OpenSSL::PKey::RSA.new pem, 'lyric_changeme'
    http.ca_file = "cachain.crt"

    res = http.request(req)