#!/usr/bin/env bash
set -e

export KUBECONFIG="${HOME}/.kube/config"
export PATH="/snap/bin:/usr/local/bin:$PATH"
KUBECTL="/snap/bin/kubectl --kubeconfig /home/lenovo/.kube/config"

echo "=== 0. Waiting for WordPress pod to be Ready ==="
$KUBECTL wait --for=condition=ready pod -l app.kubernetes.io/name=wordpress --timeout=120s

echo "=== Ensuring WP-CLI is installed ==="
if ! $KUBECTL exec deployment/wordpress -- which wp >/dev/null 2>&1; then
  echo "Installing WP-CLI in WordPress container..."
  $KUBECTL exec deployment/wordpress -- bash -c 'curl -sS -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x /usr/local/bin/wp'
fi

echo "=== 1. Checking WordPress installation status ==="
if $KUBECTL exec deployment/wordpress -- wp core is-installed --allow-root 2>/dev/null; then
  echo "WordPress is already installed."
else
  echo "Installing WordPress core..."
  /snap/bin/kubectl exec deployment/wordpress -- wp core install \
    --url="http://store.local" \
    --title="Urumi Store" \
    --admin_user="admin" \
    --admin_password="AdminPassword123!" \
    --admin_email="admin@urumi.local" \
    --skip-email \
    --allow-root
fi

echo "=== 2. Configuring Pretty Permalinks (Required for WC REST API) ==="
$KUBECTL exec deployment/wordpress -- wp rewrite structure '/%postname%/' --allow-root

echo "=== 3. Installing and Activating WooCommerce Plugin ==="
if $KUBECTL exec deployment/wordpress -- wp plugin is-installed woocommerce --allow-root 2>/dev/null; then
  echo "WooCommerce already installed, ensuring active..."
  $KUBECTL exec deployment/wordpress -- wp plugin activate woocommerce --allow-root || true
else
  echo "Downloading and activating WooCommerce 9.3.3..."
  $KUBECTL exec deployment/wordpress -- wp plugin install https://downloads.wordpress.org/plugin/woocommerce.9.3.3.zip --activate --allow-root
fi

echo "=== 4. Configuring WooCommerce Basic Settings & COD Gateway ==="
$KUBECTL exec deployment/wordpress -- wp option update woocommerce_currency "USD" --allow-root
$KUBECTL exec deployment/wordpress -- wp option update woocommerce_cod_settings '{"enabled":"yes","title":"Cash on delivery","description":"Pay with cash upon delivery.","instructions":"Pay with cash upon delivery.","enable_for_methods":[],"enable_for_virtual":"yes"}' --format=json --allow-root

echo "=== 5. Provisioning WooCommerce REST API Keys ==="
$KUBECTL exec deployment/wordpress -- wp eval '
global $wpdb;
$table = $wpdb->prefix . "woocommerce_api_keys";
$key = "ck_98fbc18596f264871d8717904e5d61483acfb0a1";
$secret = "cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1";

$existing = $wpdb->get_var($wpdb->prepare("SELECT key_id FROM $table WHERE consumer_key = %s", wc_api_hash($key)));
if (!$existing) {
    $wpdb->insert(
        $table,
        array(
            "user_id"         => 1,
            "description"     => "MCP Gateway Key",
            "permissions"     => "read_write",
            "consumer_key"    => wc_api_hash($key),
            "consumer_secret" => $secret,
            "truncated_key"   => substr($key, -7),
        ),
        array("%d", "%s", "%s", "%s", "%s", "%s")
    );
    echo "API Key created successfully\n";
} else {
    echo "API Key already exists\n";
}
' --allow-root

echo "=== 6. Seeding Test Products ==="
$KUBECTL exec deployment/wordpress -- wp eval '
if (function_exists("wc_get_product_id_by_sku")) {
    $products = array(
        array(
            "name" => "Premium Wireless Headphones",
            "sku" => "SKU-1001",
            "price" => "199.99",
            "description" => "Active noise canceling studio headphones with 40h battery.",
            "stock" => 45
        ),
        array(
            "name" => "Ergonomic Mechanical Keyboard",
            "sku" => "SKU-1002",
            "price" => "129.50",
            "description" => "Custom mechanical switches with hot-swappable RGB PCB.",
            "stock" => 12
        ),
        array(
            "name" => "Ultra-Wide Gaming Monitor 34\"",
            "sku" => "SKU-1003",
            "price" => "499.00",
            "description" => "144Hz 1ms curved IPS display with HDR600.",
            "stock" => 5
        ),
        array(
            "name" => "USB-C Multi-Port Hub",
            "sku" => "SKU-1004",
            "price" => "45.00",
            "description" => "7-in-1 aluminium hub with HDMI 4K and 100W PD.",
            "stock" => 80
        ),
        array(
            "name" => "Noise Cancelling Microphone",
            "sku" => "SKU-1005",
            "price" => "89.00",
            "description" => "Cardioid condenser microphone with boom arm.",
            "stock" => 0
        )
    );

    foreach ($products as $p) {
        $existing_id = wc_get_product_id_by_sku($p["sku"]);
        if (!$existing_id) {
            $product = new WC_Product_Simple();
            $product->set_name($p["name"]);
            $product->set_regular_price($p["price"]);
            $product->set_sku($p["sku"]);
            $product->set_description($p["description"]);
            $product->set_manage_stock(true);
            $product->set_stock_quantity($p["stock"]);
            $product->set_status("publish");
            $product->save();
            echo "Created product: " . $p["sku"] . " (ID: " . $product->get_id() . ")\n";
        } else {
            echo "Product already exists: " . $p["sku"] . " (ID: $existing_id)\n";
        }
    }
} else {
    echo "WooCommerce functions not available for seeding products\n";
}
' --allow-root

echo "=== 7. Seeding Test Orders ==="
$KUBECTL exec deployment/wordpress -- wp eval '
if (function_exists("wc_create_order") && function_exists("wc_get_product_id_by_sku")) {
    $p1_id = wc_get_product_id_by_sku("SKU-1001");
    $p2_id = wc_get_product_id_by_sku("SKU-1002");

    $order_count = count(wc_get_orders(array("limit" => 5)));
    if ($order_count == 0 && $p1_id && $p2_id) {
        // Order 1: Processing
        $o1 = wc_create_order();
        $o1->add_product(wc_get_product($p1_id), 1);
        $o1->set_address(array(
            "first_name" => "Sarah",
            "last_name" => "Chen",
            "email" => "sarah.chen@example.com",
            "address_1" => "100 Market St",
            "city" => "San Francisco",
            "state" => "CA",
            "postcode" => "94105",
            "country" => "US"
        ), "billing");
        $o1->calculate_totals();
        $o1->update_status("processing", "Seeded order for demonstration.");

        // Order 2: Completed
        $o2 = wc_create_order();
        $o2->add_product(wc_get_product($p2_id), 2);
        $o2->set_address(array(
            "first_name" => "Alex",
            "last_name" => "Rivera",
            "email" => "alex.rivera@example.com",
            "address_1" => "250 Broadway",
            "city" => "New York",
            "state" => "NY",
            "postcode" => "10007",
            "country" => "US"
        ), "billing");
        $o2->calculate_totals();
        $o2->update_status("completed", "Seeded completed order.");

        // Order 3: Pending payment
        $o3 = wc_create_order();
        $o3->add_product(wc_get_product($p1_id), 1);
        $o3->add_product(wc_get_product($p2_id), 1);
        $o3->set_address(array(
            "first_name" => "Jordan",
            "last_name" => "Taylor",
            "email" => "jordan.taylor@example.com",
            "address_1" => "500 Pine St",
            "city" => "Seattle",
            "state" => "WA",
            "postcode" => "98101",
            "country" => "US"
        ), "billing");
        $o3->calculate_totals();
        $o3->update_status("pending", "Seeded pending order.");

        echo "Seeded 3 test orders successfully!\n";
    } else {
        echo "Orders already seeded ($order_count found).\n";
    }
}
' --allow-root

echo "=== WooCommerce Storefront Bootstrap Complete! ==="
