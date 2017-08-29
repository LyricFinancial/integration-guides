## Disbursements

When it's time for funds to be repayed to Lyric, disbursements can be made to the Lyric system (swagger path POST /disbursements).  Visit the [api spec](/secure/vendor-api/) for full details.

#### CSV Format

- amount: String
- description: String
- distributionDate: ISO8601 date
- transactionId: String
- memberAccountToken: String
- vendorClientAccountId: String
- masterClientId: String (optional)
- paymentSource: String (optional)