# Server Integration Guide

When a client requests a vATM advance the partner's server will share client data with Lyric. Lyric uses this data to calculate advance limits.

Lyric's primary [Vendor API](https://integrationservices.lyricfinancial.com/docs/vendor-api/) uses JSON via REST endpoints with JOSE message security. Usually, partners use Lyric's
Registration API which sends Lyric name, phone, address, and bank information. You can also send royalty/sales and distribution data in this same
API call. Lyric requires the previous three years of data. There are several methods of sending this data.