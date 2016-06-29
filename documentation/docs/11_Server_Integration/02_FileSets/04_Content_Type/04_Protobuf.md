### Working with Protobuf data

The protobuf schema file:

  - [FinancialRecordGroupingFileSet.proto](/specs/v1/FinancialRecordGroupingFileSet.proto)

The primary Protobuf message is a FinancialRecordGroupingFileSet.

You send FinancialRecordGrouping messages in a FinancialRecordGroupingFileSet message. You are free to create FinancialRecordGroupingFileSet messages as you please. You might include one FinancialRecordGrouping per Set or you might bundle up all 36 months of data into a single FinancialRecordGroupingFileSet. This give you flexibility in how you prepare distribution data.

API performance will probably be better if you break data into multiple FinancialRecordGroupingFileSet messages, as this will allow the API to parse/decode concurrently.