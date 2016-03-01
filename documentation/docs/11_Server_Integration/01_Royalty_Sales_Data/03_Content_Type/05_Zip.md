### Using zip/tar archives to send multiple files

A zip/tar archive makes it easy to eagerly prepare data in batches to reduce the "work overhead" required during a vATM handoff. Zip/tar archives can be attached
using the form-data/multipart API and the "DistributionGrouping" field. By default, the API assumes that all files in an archive are CSV data. Use the following option to
tell the API to expect protobuf files instead:

  - **lyric-archive.item-content-type** - (String) [text/csv | application/protobuf] Default: text/csv
