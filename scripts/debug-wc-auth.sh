#!/usr/bin/env bash
docker exec urumi-local-control-plane kubectl --server=https://127.0.0.1:6443 exec deployment/wordpress -- php /var/www/html/wp-cli.phar eval '
$key = "ck_98fbc18596f264871d8717904e5d61483acfb0a1";
$secret = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1";

$auth = new WC_REST_Authentication();
// Test internal auth check
$_GET["consumer_key"] = $key;
$_GET["consumer_secret"] = $secret;
$_SERVER["REQUEST_METHOD"] = "GET";

$user = $auth->authenticate(false);
var_dump($user);
if (is_wp_error($user)) {
    echo "Error: " . $user->get_error_message() . " (" . $user->get_error_code() . ")\n";
} else {
    echo "Authenticated user ID: " . $user . "\n";
}
' --allow-root
