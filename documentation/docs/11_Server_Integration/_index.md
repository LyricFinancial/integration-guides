# Server Integration Guide

When a client requests a vATM advance the partner's server will share client data with Lyric. Lyric uses this data to calculate advance limits.

Lyric's primary [Vendor API](/secure/vendor-api/) uses JSON via REST endpoints with JOSE message security. Usually, partners use Lyric's Registration API which sends Lyric name, phone, address, and bank information. You can also send royalty/sales and distribution data in this same API call. Lyric requires the previous three years of data. There are several methods of sending this data.

## Concepts

Start here, to understand a few basic concepts first. Then, look at specific API detail.

  - [SSL](!Server_Integration/SSL)
  - [Sign/Encrypt](!Server_Integration/Sign_Encrypt)
  - [FileSet concepts](!Server_Integration/FileSets)
  - [FinancialRecord concepts](!Server_Integration/FinancialRecords)

## Apis

  - [Registration](!Server_Integration/Apis/upsert_client)

