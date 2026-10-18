<?php
/**
 * Plugin Name: Modern Storefront Enhancer
 * Description: High-end, realistic styling for the Urumi E-Commerce Storefront
 * Version: 1.1.0
 */

// 1. Inject Modern Typography & Global Styles
add_action('wp_head', function() {
    ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-primary: #10b981;
            --brand-primary-dark: #059669;
            --brand-dark: #0f172a;
            --brand-slate: #334155;
            --card-border: #e2e8f0;
        }

        body, button, input, select, textarea {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
            color: #1e293b;
            background-color: #f8fafc !important;
        }

        /* Top Announcement Bar */
        #urumi-top-banner {
            background: linear-gradient(90deg, #0f172a 0%, #1e293b 100%);
            color: #94a3b8;
            font-size: 12.5px;
            font-weight: 500;
            text-align: center;
            padding: 9px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
        }
        #urumi-top-banner .badge {
            background: rgba(16, 185, 129, 0.2);
            color: #34d399;
            padding: 2px 8px;
            border-radius: 9999px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid rgba(52, 211, 153, 0.3);
        }
        #urumi-top-banner strong {
            color: #f1f5f9;
        }

        /* Container Layout */
        .col-full {
            max-width: 1240px !important;
            margin-left: auto !important;
            margin-right: auto !important;
            padding: 0 24px !important;
        }

        /* Site Header */
        .site-header {
            background: #ffffff !important;
            border-bottom: 1px solid #e2e8f0 !important;
            padding-top: 14px !important;
            padding-bottom: 14px !important;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.04);
        }

        .site-branding .site-title a {
            color: #0f172a !important;
            font-weight: 800 !important;
            font-size: 24px !important;
            letter-spacing: -0.6px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .site-branding .site-description {
            color: #64748b !important;
            font-size: 12px !important;
            font-weight: 500 !important;
        }

        .main-navigation ul.nav-menu li a, 
        .main-navigation ul.menu li a {
            color: #334155 !important;
            font-weight: 600 !important;
            font-size: 14px !important;
            padding: 10px 16px !important;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .main-navigation ul.nav-menu li a:hover, 
        .main-navigation ul.menu li a:hover {
            color: #10b981 !important;
            background: #f1f5f9;
        }

        .site-header-cart .cart-contents {
            background: #f1f5f9 !important;
            border-radius: 8px !important;
            padding: 8px 14px !important;
            font-weight: 600 !important;
            color: #0f172a !important;
            font-size: 13px !important;
        }

        /* Full Width Shop Page - Hide Default Blog Sidebar */
        #secondary {
            display: none !important;
        }
        #primary {
            width: 100% !important;
            float: none !important;
            margin: 0 !important;
        }

        /* Hero Banner */
        .urumi-hero-card {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
            border-radius: 16px;
            padding: 36px 40px;
            margin-bottom: 32px;
            color: #ffffff;
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.25);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.08);
            position: relative;
            overflow: hidden;
        }
        .urumi-hero-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(16, 185, 129, 0.15) 0%, transparent 70%);
            pointer-events: none;
        }
        .urumi-hero-content h1 {
            color: #ffffff !important;
            font-size: 28px !important;
            font-weight: 800 !important;
            margin: 8px 0 10px 0 !important;
            letter-spacing: -0.5px;
        }
        .urumi-hero-content p {
            color: #94a3b8;
            font-size: 14.5px;
            max-width: 560px;
            line-height: 1.5;
            margin: 0 !important;
        }
        .urumi-hero-stats {
            display: flex;
            gap: 20px;
            border-left: 1px solid rgba(255, 255, 255, 0.1);
            padding-left: 28px;
        }
        .urumi-stat-item {
            text-align: center;
        }
        .urumi-stat-val {
            font-size: 22px;
            font-weight: 800;
            color: #34d399;
        }
        .urumi-stat-lbl {
            font-size: 11px;
            color: #94a3b8;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* Product Cards Grid */
        ul.products {
            display: grid !important;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)) !important;
            gap: 24px !important;
            margin-top: 20px !important;
            margin-bottom: 40px !important;
        }

        ul.products li.product {
            background: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 16px !important;
            padding: 18px !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -2px rgba(0, 0, 0, 0.02) !important;
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1) !important;
            display: flex !important;
            flex-direction: column !important;
            justify-content: space-between !important;
            margin: 0 !important;
            width: auto !important;
            position: relative;
        }

        ul.products li.product:hover {
            transform: translateY(-5px) !important;
            box-shadow: 0 20px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.04) !important;
            border-color: #cbd5e1 !important;
        }

        ul.products li.product img {
            border-radius: 12px !important;
            height: 210px !important;
            width: 100% !important;
            object-fit: cover !important;
            margin-bottom: 14px !important;
            background: #f1f5f9;
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
            font-size: 17px !important;
            font-weight: 800 !important;
            color: #059669 !important;
            margin-bottom: 14px !important;
            display: block !important;
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
            border-radius: 10px !important;
            padding: 11px 18px !important;
            font-weight: 700 !important;
            font-size: 13.5px !important;
            border: none !important;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.25) !important;
            transition: all 0.2s ease !important;
            text-align: center !important;
            display: block !important;
            width: 100% !important;
        }

        ul.products li.product .button:hover,
        .woocommerce #respond input#submit.alt:hover, 
        .woocommerce a.button.alt:hover, 
        .woocommerce button.button.alt:hover, 
        .woocommerce input.button.alt:hover {
            background: #047857 !important;
            box-shadow: 0 6px 12px rgba(16, 185, 129, 0.35) !important;
            transform: translateY(-1px);
        }

        /* Cart & Checkout Styling */
        .woocommerce-cart table.cart,
        .woocommerce-checkout #order_review {
            border: 1px solid #e2e8f0 !important;
            border-radius: 14px !important;
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
            padding: 14px 18px !important;
        }

        .woocommerce table.shop_table td {
            padding: 14px 18px !important;
            border-top: 1px solid #f1f5f9 !important;
        }

        .woocommerce-checkout #payment {
            background: #f8fafc !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 14px !important;
            padding: 20px !important;
        }

        /* Footer */
        .site-footer {
            background: #0f172a !important;
            color: #94a3b8 !important;
            padding-top: 40px !important;
            padding-bottom: 40px !important;
            border-top: 1px solid #1e293b !important;
        }

        .site-footer a {
            color: #cbd5e1 !important;
        }
        .site-footer a:hover {
            color: #34d399 !important;
        }
        .site-info {
            text-align: center !important;
            font-size: 13px !important;
        }
    </style>
    <div id="urumi-top-banner">
        <span class="badge">Kubernetes v1.28</span>
        <span>🚀 <strong>Urumi Autonomous Hardware Store</strong> — Live MCP Gateway Enabled & Synchronized</span>
    </div>
    <?php
});

// 2. Add Sleek Hero Section on the Shop Catalog
add_action('woocommerce_before_shop_loop', function() {
    ?>
    <div class="urumi-hero-card">
        <div class="urumi-hero-content">
            <span style="display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#34d399; background:rgba(52,211,153,0.12); padding:3px 10px; border-radius:6px; margin-bottom:8px;">Live MCP Catalog</span>
            <h1>Developer & Hardware Emporium</h1>
            <p>Curated tech gadgets connected directly to live MCP inventory tools and autonomous AI agents. Real-time stock decrement upon purchase.</p>
        </div>
        <div class="urumi-hero-stats">
            <div class="urumi-stat-item">
                <div class="urumi-stat-val">3</div>
                <div class="urumi-stat-lbl">Microservices</div>
            </div>
            <div class="urumi-stat-item">
                <div class="urumi-stat-val">12</div>
                <div class="urumi-stat-lbl">MCP Tools</div>
            </div>
            <div class="urumi-stat-item">
                <div class="urumi-stat-val">Live</div>
                <div class="urumi-stat-lbl">Inventory</div>
            </div>
        </div>
    </div>
    <?php
}, 5);

// 3. Customize Storefront Footer Credits
add_filter('storefront_credit_link', '__return_false');
add_action('storefront_footer', function() {
    ?>
    <div class="site-info" style="color: #94a3b8; font-size: 13px; text-align: center; padding: 12px 0;">
        &copy; <?php echo date('Y'); ?> <strong>Urumi Autonomous Hardware Store</strong>. Integrated with FastMCP &amp; Team Gateway on Kubernetes.
    </div>
    <?php
}, 20);
