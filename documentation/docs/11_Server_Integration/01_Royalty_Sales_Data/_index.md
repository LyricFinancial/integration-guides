## Royalty/Sales Data

Royalty/Sales data can either be embedded in the JSON payload or sent using form-data/multipart as a separate attachment alongside the primary JSON used
by the API. Lyric supports earnings data in CSV format, Google Protobuf format, or as raw JSON. When using form-data/multipart CSV files or Google protobuf
files may also be archived in ZIP or TAR files. Lyric recommends Protobuf files as they will be more compact than CSV/JSON and require less parsing.