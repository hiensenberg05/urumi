<?php
/**
 * Plugin Name: Modern Storefront Enhancer
 * Description: High-end, realistic styling for the Urumi E-Commerce Storefront
 * Version: 1.0.0
 */

add_action('wp_head', function() {
    ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-primary: #10b981;
            --brand-dark: #0f172a;
            --brand-slate: #334155;
            --card-border: #e2e8f0;
        }

        body, button, input, select, textarea {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
            color: #1e293b;
        }

        /* Top Announcement Bar */
        #urumi-top-banner {
            background: linear-gradient(90deg, #0f172a 0%, #1e293b 100%);
            color: #94a3b8;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            padding: 8px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        #urumi-top-banner strong {
            color: #34d399;
        }

        /* Site Header */
        .site-header {
            background: #ffffff !important;
            border-bottom: 1px solid #f1f5f9 !important;
            padding-top: 18px !important;
            padding-bottom: 18px !important;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05);
        }

        .site-branding .site-title a {
            color: #0f172a !important;
            font-weight: 800 !important;
            font-size: 22px !important;
            letter-spacing: -0.5px;
        }

        .main-navigation ul.nav-menu li a, 
        .main-navigation ul.menu li a {
            color: #475569 !important;
            font-weight: 600 !important;
            font-size: 14px !important;
            transition: color 0.2s ease;
        }

        .main-navigation ul.nav-menu li a:hover, 
        .main-navigation ul.menu li a:hover {
            color: #10b981 !important;
        }

        /* Product Cards Grid */
        ul.products {
            display: grid !important;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)) !important;
            gap: 24px !important;
            margin-top: 24px !important;
        }

        ul.products li.product {
            background: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 14px !important;
            padding: 16px !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.04), 0 2px 4px -2px rgba(0, 0, 0, 0.03) !important;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1) !important;
            display: flex !important;
            flex-direction: column !important;
            justify-content: space-between !important;
            margin: 0 !important;
            width: auto !important;
        }

        ul.products li.product:hover {
            transform: translateY(-4px) !important;
            box-shadow: 0 12px 24px -4px rgba(15, 23, 42, 0.1) !important;
            border-color: #cbd5e1 !important;
        }

        ul.products li.product img {
            border-radius: 10px !important;
            height: 190px !important;
            width: 100% !important;
            object-fit: cover !important;
            margin-bottom: 14px !important;
            background: #f8fafc;
        }

        ul.products li.product .woocommerce-loop-product__title {
            font-size: 15px !important;
            font-weight: 700 !important;
            color: #0f172a !important;
            line-height: 1.35 !important;
            margin-bottom: 8px !important;
            padding: 0 !important;
        }

        ul.products li.product .price {
            font-size: 16px !important;
            font-weight: 700 !important;
            color: #059669 !important;
            margin-bottom: 14px !important;
        }

        /* Buttons (Add to Cart, Checkout) */
        ul.products li.product .button,
        .woocommerce #respond input#submit.alt, 
        .woocommerce a.button.alt, 
        .woocommerce button.button.alt, 
        .woocommerce input.button.alt,
        .woocommerce .cart .button,
        .woocommerce-page .cart .button {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
            color: #ffffff !important;
            border-radius: 8px !important;
            padding: 10px 16px !important;
            font-weight: 600 !important;
            font-size: 13px !important;
            border: none !important;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.25) !important;
            transition: all 0.2s ease !important;
            text-align: center !important;
        }

        ul.products li.product .button:hover,
        .woocommerce #respond input#submit.alt:hover, 
        .woocommerce a.button.alt:hover, 
        .woocommerce button.button.alt:hover, 
        .woocommerce input.button.alt:hover {
            background: #047857 !important;
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.35) !important;
            transform: translateY(-1px);
        }

        /* Cart & Checkout Styling */
        .woocommerce-cart table.cart,
        .woocommerce-checkout #order_review {
            border: 1px solid #e2e8f0 !important;
            border-radius: 12px !important;
            background: #ffffff !important;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.03) !important;
            overflow: hidden !important;
        }

        .woocommerce table.shop_table th {
            background: #f8fafc !important;
            color: #475569 !important;
            font-weight: 700 !important;
            font-size: 12px !important;
            text-transform: uppercase !important;
            letter-spacing: 0.5px !important;
            padding: 14px 16px !important;
        }

        .woocommerce table.shop_table td {
            padding: 14px 16px !important;
            border-top: 1px solid #f1f5f9 !important;
        }

        .woocommerce-checkout #payment {
            background: #f8fafc !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 12px !important;
        }

        /* Footer */
        .site-footer {
            background: #0f172a !important;
            color: #94a3b8 !important;
            padding-top: 36px !important;
            padding-bottom: 36px !important;
            border-top: 1px solid #1e293b !important;
        }

        .site-footer a {
            color: #cbd5e1 !important;
        }
        .site-footer a:hover {
            color: #34d399 !important;
        }
    </style>
    <div id="urumi-top-banner">
        🚀 <strong>Urumi Autonomous Hardware Store</strong> — Live Model Context Protocol (MCP) Kubernetes Gateway Enabled
    </div>
    <?php
});
