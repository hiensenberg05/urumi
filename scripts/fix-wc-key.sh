#!/usr/bin/env bash
docker exec urumi-local-control-plane kubectl --server=https://127.0.0.1:6443 exec deployment/wordpress -- php /var/www/html/wp-cli.phar eval '
global $wpdb;
$key = "ck_98fbc18596f264871d8717904e5d61483acfb0a1";
$table = $wpdb->prefix . "woocommerce_api_keys";
$hash = wc_api_hash($key);
$wpdb->update($table, array("consumer_key" => $hash), array("key_id" => 1));
echo "Updated consumer_key to HMAC hash: " . $hash . "\n";
' --allow-root
