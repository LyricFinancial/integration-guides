### Working with Protobuf data

The protobuf schema file:

  - [DistributionGroupingSet.proto](/specs/v1/DistributionGroupingSet.proto)

The primary Protobuf message is a DistributionGrouping. This represents a group of distributions for:

  * period
  * store
  * country
  * sale type
  * currency
  * distribution date

You send DistributionGrouping messages in a DistributionGroupingSet message. You are free to create DistributionGroupingSet messages as you please. You might include one DistributionGrouping per Set or you might bundle up all 36 months of data into a single DistributionGroupingSet. This give you flexibility in how you prepare distribution data.

API performance will probably be better if you send break data into multiple DistributionGroupingSet messages, as this will allow the API to parse/decode concurrently.