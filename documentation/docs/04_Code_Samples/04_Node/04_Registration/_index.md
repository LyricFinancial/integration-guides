	# Jose Signing/Encryption: [https://github.com/cisco/node-jose](https://github.com/cisco/node-jose)

	const request = require('request');
	const path = require('path');
	const fs = require('fs');
	const jose = require('node-jose');
	const crypto = require('crypto');