#!/usr/bin/env bash
docker exec urumi-local-control-plane kubectl --server=https://127.0.0.1:6443 exec deployment/wordpress -- php /var/www/html/wp-cli.phar eval '
global $wpdb;
$keys = $wpdb->get_results("SELECT key_id, user_id, description, permissions, consumer_key, consumer_secret, truncated_key FROM {$wpdb->prefix}woocommerce_api_keys");
echo json_encode($keys, JSON_PRETTY_PRINT) . "\n";
' --allow-root
