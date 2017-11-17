Jose Signing/Encryption: [https://github.com/Spomky-Labs/jose](https://github.com/Spomky-Labs/jose)

	use Jose\Object\JWK;
	use Jose\Factory\JWSFactory;
	use Jose\Factory\JWEFactory;

	use Jose\Factory\JWKFactory;
	use Jose\Loader;

	$boundary =  md5(mt_rand() . microtime());
	$boundary = "--" . $boundary;