#!/usr/bin/env bash
docker exec urumi-local-control-plane kubectl --server=https://127.0.0.1:6443 exec deployment/wordpress -- php /var/www/html/wp-cli.phar eval '
$key = "ck_98fbc18596f264871d8717904e5d61483acfb0a1";
$secret = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1";

$_SERVER["PHP_AUTH_USER"] = $key;
$_SERVER["PHP_AUTH_PW"] = $secret;
$_SERVER["HTTPS"] = "on";

$reflector = new ReflectionClass("WC_REST_Authentication");
$method = $reflector->getMethod("perform_basic_authentication");
$method->setAccessible(true);
$res = $method->invoke(new WC_REST_Authentication());
var_dump($res);
' --allow-root
