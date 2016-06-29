Lyric calculates an advance limit for each client using historical earnings data and financial transactions (encumbrances). Because
this data varies between Vendors, we customize our formula for each vendor and it's unique data sets.

At a high level, we ask for 3 years (1 minimum) worth of earnings data and "recent" encumbrances. Lyric will work with you to define the level
of detail required in earnings data. The API is flexible and can accomodate existing reports and/or exports defined within your system. 
It can even combine data from multiple sources. We accomplish this by labeling each file with a fileType. The default fileType is "earningSummary".
However, if additional files are necessary to send asset (song) level detail, we will simply agree on a new fileType, e.g. "songSummary" and now you
just send both files to the API. It should be noted too that if necessary, files can be split (say 1 file per year), and multiple files of the same fileType
can all be uploaded.

Each FileSet object is defined by a fileType. Right now, there is one type of FileSet object:

  - FinancialRecordGroupingFileSet

When using the multipart API, you specify the HTTP field name using the object name, FinancialRecordGroupingFileSet. You can upload multiple files by repeating the field name. I.e.


    // Multipart
    POST /clients.form HTTP/1.1
    Content-Type: multipart/form-data; boundary=----LyricBoundaryAL0lfjW6DJtKiwkd

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="123-earnings-export.csv"
    Content-Type: text/csv; lyric-fileset.file-id=5ec019b0-d259-418d-972a-419856215bf9; lyric-fileset.file-type=earningSummary; lyric-csv.schema=StandardDistributor

    header1,header2
    data1,data2

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="123-song-export.csv"
    Content-Type: text/csv; lyric-fileset.file-id=f1366c3a-0b28-430c-aa35-aefdbe6b2035; lyric-fileset.file-type=songSummary; lyric-csv.schema=SongDetailDistributor

    header1,header2
    data1,data2

    ------LyricBoundaryAL0lfjW6DJtKiwkd
    Content-Disposition: form-data; name="FinancialRecordGroupingFileSet"; filename="123-txn.csv"
    Content-Type: text/csv; lyric-fileset.file-id=0f740d39-7236-438b-b427-3776ca3eaf64; lyric-fileset.file-type=encumbrances; lyric-csv.schema=StandardTransactions

    header1,header2
    data1,data2
    ------LyricBoundaryAL0lfjW6DJtKiwkd--

In the above example, we upload three files. Of the three FinancialRecordGroupingFileSet files, each is
a different fileType, which indicates different contents. Notice the lyric-csv.schema option as well. This can be left blank if using the "default" schema.
Default schemas are (will be) listed [here](!Server_Integration/FileSets/Content_Type/Csv).

## Data Contract

It is critical that we keep the CSV schemas and fileTypes constant over time for the continued operation of the advance limit projection formulas.
We publish your specific list of expected fileTypes, here. (Need link to dynamic listing, specific to vendor.)