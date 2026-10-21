/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.4.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: wordpress
-- ------------------------------------------------------
-- Server version	11.4.13-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `wp_actionscheduler_actions`
--

DROP TABLE IF EXISTS `wp_actionscheduler_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_actionscheduler_actions` (
  `action_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `hook` varchar(191) NOT NULL,
  `status` varchar(20) NOT NULL,
  `scheduled_date_gmt` datetime DEFAULT '0000-00-00 00:00:00',
  `scheduled_date_local` datetime DEFAULT '0000-00-00 00:00:00',
  `priority` tinyint(3) unsigned NOT NULL DEFAULT 10,
  `args` varchar(191) DEFAULT NULL,
  `schedule` longtext DEFAULT NULL,
  `group_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `last_attempt_gmt` datetime DEFAULT '0000-00-00 00:00:00',
  `last_attempt_local` datetime DEFAULT '0000-00-00 00:00:00',
  `claim_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `extended_args` varchar(8000) DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `hook_status_scheduled_date_gmt` (`hook`(163),`status`,`scheduled_date_gmt`),
  KEY `status_scheduled_date_gmt` (`status`,`scheduled_date_gmt`),
  KEY `scheduled_date_gmt` (`scheduled_date_gmt`),
  KEY `args` (`args`),
  KEY `group_id` (`group_id`),
  KEY `last_attempt_gmt` (`last_attempt_gmt`),
  KEY `claim_id_status_scheduled_date_gmt` (`claim_id`,`status`,`scheduled_date_gmt`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_actionscheduler_actions`
--

LOCK TABLES `wp_actionscheduler_actions` WRITE;
/*!40000 ALTER TABLE `wp_actionscheduler_actions` DISABLE KEYS */;
INSERT INTO `wp_actionscheduler_actions` VALUES
(5,'action_scheduler/migration_hook','pending','2026-10-18 07:54:20','2026-10-18 07:54:20',10,'[]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310060;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310060;}',1,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(6,'action_scheduler/migration_hook','pending','2026-10-18 07:54:20','2026-10-18 07:54:20',10,'[]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310060;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310060;}',2,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(7,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:00:53','2026-10-18 08:00:53',10,'[10,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310453;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310453;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(8,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:00:53','2026-10-18 08:00:53',10,'[11,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310453;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310453;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(9,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:00:53','2026-10-18 08:00:53',10,'[12,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310453;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310453;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(10,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:00:53','2026-10-18 08:00:53',10,'[13,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310453;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310453;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(11,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:00:53','2026-10-18 08:00:53',10,'[14,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310453;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310453;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(12,'wc-admin_import_orders','pending','2026-10-18 08:00:59','2026-10-18 08:00:59',10,'[15]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310459;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310459;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(13,'wc-admin_import_orders','pending','2026-10-18 08:01:00','2026-10-18 08:01:00',10,'[16]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310460;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310460;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(14,'wc-admin_import_orders','pending','2026-10-18 08:01:00','2026-10-18 08:01:00',10,'[17]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792310460;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792310460;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(15,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:20:45','2026-10-18 08:20:45',10,'[19,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792311645;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792311645;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(16,'wc-admin_import_orders','pending','2026-10-18 08:20:49','2026-10-18 08:20:49',10,'[20]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792311649;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792311649;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(17,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:21:18','2026-10-18 08:21:18',10,'[21,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792311678;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792311678;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(18,'wc-admin_import_orders','pending','2026-10-18 08:21:22','2026-10-18 08:21:22',10,'[22]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792311682;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792311682;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(19,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:31:40','2026-10-18 08:31:40',10,'[23,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792312300;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792312300;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(20,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 08:31:41','2026-10-18 08:31:41',10,'[13,2]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792312301;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792312301;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(21,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-18 10:36:32','2026-10-18 10:36:32',10,'[24,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792319792;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792319792;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(22,'wc-admin_import_orders','pending','2026-10-18 10:51:46','2026-10-18 10:51:46',10,'[25]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792320706;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792320706;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(23,'wc-admin_import_orders','pending','2026-10-18 10:57:29','2026-10-18 10:57:29',10,'[26]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792321049;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792321049;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(24,'wc-admin_import_orders','pending','2026-10-19 14:11:48','2026-10-19 14:11:48',10,'[38]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792419108;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792419108;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(25,'wc-admin_import_orders','pending','2026-10-19 15:25:09','2026-10-19 15:25:09',10,'[39]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792423509;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792423509;}',4,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(26,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-19 15:45:57','2026-10-19 15:45:57',10,'[10,2]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792424757;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792424757;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(27,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-19 16:03:56','2026-10-19 16:03:56',10,'[40,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792425836;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792425836;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL),
(28,'woocommerce_run_product_attribute_lookup_update_callback','pending','2026-10-20 14:37:36','2026-10-20 14:37:36',10,'[41,1]','O:30:\"ActionScheduler_SimpleSchedule\":2:{s:22:\"\0*\0scheduled_timestamp\";i:1792507056;s:41:\"\0ActionScheduler_SimpleSchedule\0timestamp\";i:1792507056;}',3,0,'0000-00-00 00:00:00','0000-00-00 00:00:00',0,NULL);
/*!40000 ALTER TABLE `wp_actionscheduler_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_actionscheduler_claims`
--

DROP TABLE IF EXISTS `wp_actionscheduler_claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_actionscheduler_claims` (
  `claim_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date_created_gmt` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`claim_id`),
  KEY `date_created_gmt` (`date_created_gmt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_actionscheduler_claims`
--

LOCK TABLES `wp_actionscheduler_claims` WRITE;
/*!40000 ALTER TABLE `wp_actionscheduler_claims` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_actionscheduler_claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_actionscheduler_groups`
--

DROP TABLE IF EXISTS `wp_actionscheduler_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_actionscheduler_groups` (
  `group_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `slug` (`slug`(191))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_actionscheduler_groups`
--

LOCK TABLES `wp_actionscheduler_groups` WRITE;
/*!40000 ALTER TABLE `wp_actionscheduler_groups` DISABLE KEYS */;
INSERT INTO `wp_actionscheduler_groups` VALUES
(1,'action-scheduler-migration'),
(2,'action-scheduler-migration'),
(3,'woocommerce-db-updates'),
(4,'wc-admin-data');
/*!40000 ALTER TABLE `wp_actionscheduler_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_actionscheduler_logs`
--

DROP TABLE IF EXISTS `wp_actionscheduler_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_actionscheduler_logs` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `action_id` bigint(20) unsigned NOT NULL,
  `message` text NOT NULL,
  `log_date_gmt` datetime DEFAULT '0000-00-00 00:00:00',
  `log_date_local` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`log_id`),
  KEY `action_id` (`action_id`),
  KEY `log_date_gmt` (`log_date_gmt`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_actionscheduler_logs`
--

LOCK TABLES `wp_actionscheduler_logs` WRITE;
/*!40000 ALTER TABLE `wp_actionscheduler_logs` DISABLE KEYS */;
INSERT INTO `wp_actionscheduler_logs` VALUES
(1,5,'action created','2026-10-18 07:53:20','2026-10-18 07:53:20'),
(2,6,'action created','2026-10-18 07:53:20','2026-10-18 07:53:20'),
(3,7,'action created','2026-10-18 08:00:52','2026-10-18 08:00:52'),
(4,8,'action created','2026-10-18 08:00:52','2026-10-18 08:00:52'),
(5,9,'action created','2026-10-18 08:00:52','2026-10-18 08:00:52'),
(6,10,'action created','2026-10-18 08:00:52','2026-10-18 08:00:52'),
(7,11,'action created','2026-10-18 08:00:53','2026-10-18 08:00:53'),
(8,12,'action created','2026-10-18 08:00:54','2026-10-18 08:00:54'),
(9,13,'action created','2026-10-18 08:00:55','2026-10-18 08:00:55'),
(10,14,'action created','2026-10-18 08:00:55','2026-10-18 08:00:55'),
(11,15,'action created','2026-10-18 08:20:44','2026-10-18 08:20:44'),
(12,16,'action created','2026-10-18 08:20:44','2026-10-18 08:20:44'),
(13,17,'action created','2026-10-18 08:21:17','2026-10-18 08:21:17'),
(14,18,'action created','2026-10-18 08:21:17','2026-10-18 08:21:17'),
(15,19,'action created','2026-10-18 08:31:39','2026-10-18 08:31:39'),
(16,20,'action created','2026-10-18 08:31:40','2026-10-18 08:31:40'),
(17,21,'action created','2026-10-18 10:36:31','2026-10-18 10:36:31'),
(18,22,'action created','2026-10-18 10:51:41','2026-10-18 10:51:41'),
(19,23,'action created','2026-10-18 10:57:24','2026-10-18 10:57:24'),
(20,24,'action created','2026-10-19 14:11:43','2026-10-19 14:11:43'),
(21,25,'action created','2026-10-19 15:25:04','2026-10-19 15:25:04'),
(22,26,'action created','2026-10-19 15:45:56','2026-10-19 15:45:56'),
(23,27,'action created','2026-10-19 16:03:55','2026-10-19 16:03:55'),
(24,28,'action created','2026-10-20 14:37:35','2026-10-20 14:37:35');
/*!40000 ALTER TABLE `wp_actionscheduler_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_commentmeta`
--

DROP TABLE IF EXISTS `wp_commentmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_commentmeta`
--

LOCK TABLES `wp_commentmeta` WRITE;
/*!40000 ALTER TABLE `wp_commentmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_commentmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_comments`
--

DROP TABLE IF EXISTS `wp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT 0,
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT 'comment',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10)),
  KEY `woo_idx_comment_type` (`comment_type`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_comments`
--

LOCK TABLES `wp_comments` WRITE;
/*!40000 ALTER TABLE `wp_comments` DISABLE KEYS */;
INSERT INTO `wp_comments` VALUES
(1,1,'A WordPress Commenter','wapuu@wordpress.example','https://wordpress.org/','','2026-10-18 07:52:45','2026-10-18 07:52:45','Hi, this is a comment.\nTo get started with moderating, editing, and deleting comments, please visit the Comments screen in the dashboard.\nCommenter avatars come from <a href=\"https://gravatar.com/\">Gravatar</a>.',0,'1','','comment',0,0),
(2,15,'WooCommerce','woocommerce@noreply.com','','','2026-10-18 08:00:55','2026-10-18 08:00:55','Stock levels reduced: Premium Wireless Headphones (SKU-1001) 45&rarr;44',0,'1','WooCommerce','order_note',0,0),
(3,15,'WooCommerce','woocommerce@noreply.com','','','2026-10-18 08:00:55','2026-10-18 08:00:55','Seeded order for demonstration. Order status changed from Pending payment to Processing.',0,'1','WooCommerce','order_note',0,0),
(4,16,'WooCommerce','woocommerce@noreply.com','','','2026-10-18 08:00:55','2026-10-18 08:00:55','Stock levels reduced: Ergonomic Mechanical Keyboard (SKU-1002) 12&rarr;10',0,'1','WooCommerce','order_note',0,0),
(5,16,'WooCommerce','woocommerce@noreply.com','','','2026-10-18 08:00:55','2026-10-18 08:00:55','Seeded completed order. Order status changed from Pending payment to Completed.',0,'1','WooCommerce','order_note',0,0),
(6,20,'WooCommerce','woocommerce@store.local','','','2026-10-18 08:20:45','2026-10-18 08:20:45','Stock levels reduced: Dynamic Studio Mic Boom (SKU-DYN-6) 40&rarr;38',0,'1','WooCommerce','order_note',0,0),
(7,20,'WooCommerce','woocommerce@store.local','','','2026-10-18 08:20:45','2026-10-18 08:20:45','Order status changed from Pending payment to Completed.',0,'1','WooCommerce','order_note',0,0),
(8,22,'WooCommerce','woocommerce@store.local','','','2026-10-18 08:21:18','2026-10-18 08:21:18','Stock levels reduced: Dynamic Studio Mic Boom (SKU-DYN-7) 40&rarr;38',0,'1','WooCommerce','order_note',0,0),
(9,22,'WooCommerce','woocommerce@store.local','','','2026-10-18 08:21:18','2026-10-18 08:21:18','Order status changed from Pending payment to Completed.',0,'1','WooCommerce','order_note',0,0),
(10,25,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:51:41','2026-10-18 10:51:41','Stock levels reduced: Premium Wireless Headphones (SKU-1001) 44&rarr;43',0,'1','WooCommerce','order_note',0,0),
(11,25,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:51:41','2026-10-18 10:51:41','Order status changed from Pending payment to Processing.',0,'1','WooCommerce','order_note',0,0),
(12,26,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:57:41','2026-10-18 10:57:41','Stock hold of 60 minutes applied to: <br>- Dynamic Studio Mic Boom (SKU-DYN-7) &times; 1',0,'1','WooCommerce','order_note',0,0),
(13,26,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:57:41','2026-10-18 10:57:41','Order status changed from Draft to Pending payment.',0,'1','WooCommerce','order_note',0,0),
(14,26,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:57:41','2026-10-18 10:57:41','Stock levels reduced: Dynamic Studio Mic Boom (SKU-DYN-7) 38&rarr;37',0,'1','WooCommerce','order_note',0,0),
(15,26,'WooCommerce','woocommerce@store.local','','','2026-10-18 10:57:41','2026-10-18 10:57:41','Payment to be made upon delivery. Order status changed from Pending payment to Processing.',0,'1','WooCommerce','order_note',0,0),
(16,38,'WooCommerce','woocommerce@store.local','','','2026-10-19 14:18:13','2026-10-19 14:18:13','Stock hold of 60 minutes applied to: <br>- Ergonomic Desk Mat (SKU-DESK-01) &times; 3',0,'1','WooCommerce','order_note',0,0),
(17,38,'WooCommerce','woocommerce@store.local','','','2026-10-19 14:18:13','2026-10-19 14:18:13','Order status changed from Draft to Pending payment.',0,'1','WooCommerce','order_note',0,0),
(18,38,'WooCommerce','woocommerce@store.local','','','2026-10-19 14:18:13','2026-10-19 14:18:13','Stock levels reduced: Ergonomic Desk Mat (SKU-DESK-01) 60&rarr;57',0,'1','WooCommerce','order_note',0,0),
(19,38,'WooCommerce','woocommerce@store.local','','','2026-10-19 14:18:13','2026-10-19 14:18:13','Payment to be made upon delivery. Order status changed from Pending payment to Processing.',0,'1','WooCommerce','order_note',0,0),
(20,39,'WooCommerce','woocommerce@store.local','','','2026-10-19 15:25:05','2026-10-19 15:25:05','Stock levels reduced: Premium Wireless Headphones (SKU-1001) 43&rarr;42',0,'1','WooCommerce','order_note',0,0),
(21,39,'WooCommerce','woocommerce@store.local','','','2026-10-19 15:25:05','2026-10-19 15:25:05','Order status changed from Pending payment to Processing.',0,'1','WooCommerce','order_note',0,0),
(22,39,'WooCommerce','woocommerce@store.local','','','2026-10-19 16:04:47','2026-10-19 16:04:47','Order status changed from Processing to Completed.',0,'1','WooCommerce','order_note',0,0);
/*!40000 ALTER TABLE `wp_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_links`
--

DROP TABLE IF EXISTS `wp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT 1,
  `link_rating` int(11) NOT NULL DEFAULT 0,
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_links`
--

LOCK TABLES `wp_links` WRITE;
/*!40000 ALTER TABLE `wp_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_options`
--

DROP TABLE IF EXISTS `wp_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(191) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`),
  KEY `autoload` (`autoload`)
) ENGINE=InnoDB AUTO_INCREMENT=599 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_options`
--

LOCK TABLES `wp_options` WRITE;
/*!40000 ALTER TABLE `wp_options` DISABLE KEYS */;
INSERT INTO `wp_options` VALUES
(1,'cron','a:17:{i:1792309965;a:2:{s:32:\"recovery_mode_clean_expired_keys\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:34:\"wp_privacy_delete_old_export_files\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"hourly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:3600;}}}i:1792309984;a:1:{s:30:\"wp_delete_temp_updater_backups\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"weekly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:604800;}}}i:1792309993;a:1:{s:26:\"action_scheduler_run_queue\";a:1:{s:32:\"0d04ed39571b55704c122d726248bbac\";a:3:{s:8:\"schedule\";s:12:\"every_minute\";s:4:\"args\";a:1:{i:0;s:7:\"WP Cron\";}s:8:\"interval\";i:60;}}}i:1792309996;a:1:{s:14:\"wc_admin_daily\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}}i:1792310000;a:3:{s:20:\"jetpack_clean_nonces\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"hourly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:3600;}}s:20:\"jetpack_v2_heartbeat\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:33:\"wc_admin_process_orders_milestone\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"hourly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:3600;}}}i:1792310006;a:3:{s:33:\"woocommerce_cleanup_personal_data\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:30:\"woocommerce_tracker_send_event\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:30:\"generate_category_lookup_table\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:2:{s:8:\"schedule\";b:0;s:4:\"args\";a:0:{}}}}i:1792310056;a:1:{s:25:\"woocommerce_geoip_updater\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:11:\"fifteendays\";s:4:\"args\";a:0:{}s:8:\"interval\";i:1296000;}}}i:1792313564;a:1:{s:16:\"wp_version_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1792313596;a:1:{s:32:\"woocommerce_cancel_unpaid_orders\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:2:{s:8:\"schedule\";b:0;s:4:\"args\";a:0:{}}}}i:1792315364;a:1:{s:17:\"wp_update_plugins\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1792317164;a:1:{s:16:\"wp_update_themes\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1792320796;a:2:{s:24:\"woocommerce_cleanup_logs\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}s:31:\"woocommerce_cleanup_rate_limits\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}}i:1792321304;a:1:{s:30:\"wp_1_wc_regenerate_images_cron\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:39:\"wp_1_wc_regenerate_images_cron_interval\";s:4:\"args\";a:0:{}s:8:\"interval\";i:300;}}}i:1792331596;a:1:{s:28:\"woocommerce_cleanup_sessions\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:10:\"twicedaily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:43200;}}}i:1792368000;a:1:{s:27:\"woocommerce_scheduled_sales\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:5:\"daily\";s:4:\"args\";a:0:{}s:8:\"interval\";i:86400;}}}i:1792396365;a:1:{s:30:\"wp_site_health_scheduled_check\";a:1:{s:32:\"40cd750bba9870f18aada2478b24840a\";a:3:{s:8:\"schedule\";s:6:\"weekly\";s:4:\"args\";a:0:{}s:8:\"interval\";i:604800;}}}s:7:\"version\";i:2;}','on'),
(2,'siteurl','http://store.local','on'),
(3,'home','http://store.local','on'),
(4,'blogname','Urumi Store','on'),
(5,'blogdescription','','on'),
(6,'users_can_register','0','on'),
(7,'admin_email','admin@urumi.local','on'),
(8,'start_of_week','1','on'),
(9,'use_balanceTags','0','on'),
(10,'use_smilies','1','on'),
(11,'require_name_email','1','on'),
(12,'comments_notify','1','on'),
(13,'posts_per_rss','10','on'),
(14,'rss_use_excerpt','0','on'),
(15,'mailserver_url','mail.example.com','on'),
(16,'mailserver_login','login@example.com','on'),
(17,'mailserver_pass','','on'),
(18,'mailserver_port','110','on'),
(19,'default_category','1','on'),
(20,'default_comment_status','open','on'),
(21,'default_ping_status','open','on'),
(22,'default_pingback_flag','1','on'),
(23,'posts_per_page','10','on'),
(24,'date_format','F j, Y','on'),
(25,'time_format','g:i a','on'),
(26,'links_updated_date_format','F j, Y g:i a','on'),
(27,'comment_moderation','0','on'),
(28,'moderation_notify','1','on'),
(29,'permalink_structure','/%postname%/','on'),
(30,'rewrite_rules','a:182:{s:24:\"^wc-auth/v([1]{1})/(.*)?\";s:63:\"index.php?wc-auth-version=$matches[1]&wc-auth-route=$matches[2]\";s:22:\"^wc-api/v([1-3]{1})/?$\";s:51:\"index.php?wc-api-version=$matches[1]&wc-api-route=/\";s:24:\"^wc-api/v([1-3]{1})(.*)?\";s:61:\"index.php?wc-api-version=$matches[1]&wc-api-route=$matches[2]\";s:21:\"^wc/file/transient/?$\";s:33:\"index.php?wc-transient-file-name=\";s:24:\"^wc/file/transient/(.+)$\";s:44:\"index.php?wc-transient-file-name=$matches[1]\";s:7:\"shop/?$\";s:27:\"index.php?post_type=product\";s:37:\"shop/feed/(feed|rdf|rss|rss2|atom)/?$\";s:44:\"index.php?post_type=product&feed=$matches[1]\";s:32:\"shop/(feed|rdf|rss|rss2|atom)/?$\";s:44:\"index.php?post_type=product&feed=$matches[1]\";s:24:\"shop/page/([0-9]{1,})/?$\";s:45:\"index.php?post_type=product&paged=$matches[1]\";s:11:\"^wp-json/?$\";s:22:\"index.php?rest_route=/\";s:14:\"^wp-json/(.*)?\";s:33:\"index.php?rest_route=/$matches[1]\";s:21:\"^index.php/wp-json/?$\";s:22:\"index.php?rest_route=/\";s:24:\"^index.php/wp-json/(.*)?\";s:33:\"index.php?rest_route=/$matches[1]\";s:17:\"^wp-sitemap\\.xml$\";s:23:\"index.php?sitemap=index\";s:17:\"^wp-sitemap\\.xsl$\";s:36:\"index.php?sitemap-stylesheet=sitemap\";s:23:\"^wp-sitemap-index\\.xsl$\";s:34:\"index.php?sitemap-stylesheet=index\";s:48:\"^wp-sitemap-([a-z]+?)-([a-z\\d_-]+?)-(\\d+?)\\.xml$\";s:75:\"index.php?sitemap=$matches[1]&sitemap-subtype=$matches[2]&paged=$matches[3]\";s:34:\"^wp-sitemap-([a-z]+?)-(\\d+?)\\.xml$\";s:47:\"index.php?sitemap=$matches[1]&paged=$matches[2]\";s:47:\"category/(.+?)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:52:\"index.php?category_name=$matches[1]&feed=$matches[2]\";s:42:\"category/(.+?)/(feed|rdf|rss|rss2|atom)/?$\";s:52:\"index.php?category_name=$matches[1]&feed=$matches[2]\";s:23:\"category/(.+?)/embed/?$\";s:46:\"index.php?category_name=$matches[1]&embed=true\";s:35:\"category/(.+?)/page/?([0-9]{1,})/?$\";s:53:\"index.php?category_name=$matches[1]&paged=$matches[2]\";s:32:\"category/(.+?)/wc-api(/(.*))?/?$\";s:54:\"index.php?category_name=$matches[1]&wc-api=$matches[3]\";s:43:\"category/(.+?)/wc/file/transient(/(.*))?/?$\";s:65:\"index.php?category_name=$matches[1]&wc/file/transient=$matches[3]\";s:17:\"category/(.+?)/?$\";s:35:\"index.php?category_name=$matches[1]\";s:44:\"tag/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?tag=$matches[1]&feed=$matches[2]\";s:39:\"tag/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?tag=$matches[1]&feed=$matches[2]\";s:20:\"tag/([^/]+)/embed/?$\";s:36:\"index.php?tag=$matches[1]&embed=true\";s:32:\"tag/([^/]+)/page/?([0-9]{1,})/?$\";s:43:\"index.php?tag=$matches[1]&paged=$matches[2]\";s:29:\"tag/([^/]+)/wc-api(/(.*))?/?$\";s:44:\"index.php?tag=$matches[1]&wc-api=$matches[3]\";s:40:\"tag/([^/]+)/wc/file/transient(/(.*))?/?$\";s:55:\"index.php?tag=$matches[1]&wc/file/transient=$matches[3]\";s:14:\"tag/([^/]+)/?$\";s:25:\"index.php?tag=$matches[1]\";s:45:\"type/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?post_format=$matches[1]&feed=$matches[2]\";s:40:\"type/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?post_format=$matches[1]&feed=$matches[2]\";s:21:\"type/([^/]+)/embed/?$\";s:44:\"index.php?post_format=$matches[1]&embed=true\";s:33:\"type/([^/]+)/page/?([0-9]{1,})/?$\";s:51:\"index.php?post_format=$matches[1]&paged=$matches[2]\";s:15:\"type/([^/]+)/?$\";s:33:\"index.php?post_format=$matches[1]\";s:55:\"product-category/(.+?)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?product_cat=$matches[1]&feed=$matches[2]\";s:50:\"product-category/(.+?)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?product_cat=$matches[1]&feed=$matches[2]\";s:31:\"product-category/(.+?)/embed/?$\";s:44:\"index.php?product_cat=$matches[1]&embed=true\";s:43:\"product-category/(.+?)/page/?([0-9]{1,})/?$\";s:51:\"index.php?product_cat=$matches[1]&paged=$matches[2]\";s:25:\"product-category/(.+?)/?$\";s:33:\"index.php?product_cat=$matches[1]\";s:52:\"product-tag/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?product_tag=$matches[1]&feed=$matches[2]\";s:47:\"product-tag/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?product_tag=$matches[1]&feed=$matches[2]\";s:28:\"product-tag/([^/]+)/embed/?$\";s:44:\"index.php?product_tag=$matches[1]&embed=true\";s:40:\"product-tag/([^/]+)/page/?([0-9]{1,})/?$\";s:51:\"index.php?product_tag=$matches[1]&paged=$matches[2]\";s:22:\"product-tag/([^/]+)/?$\";s:33:\"index.php?product_tag=$matches[1]\";s:35:\"product/[^/]+/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:45:\"product/[^/]+/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:65:\"product/[^/]+/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:60:\"product/[^/]+/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:60:\"product/[^/]+/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:41:\"product/[^/]+/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:24:\"product/([^/]+)/embed/?$\";s:40:\"index.php?product=$matches[1]&embed=true\";s:28:\"product/([^/]+)/trackback/?$\";s:34:\"index.php?product=$matches[1]&tb=1\";s:48:\"product/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:46:\"index.php?product=$matches[1]&feed=$matches[2]\";s:43:\"product/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:46:\"index.php?product=$matches[1]&feed=$matches[2]\";s:36:\"product/([^/]+)/page/?([0-9]{1,})/?$\";s:47:\"index.php?product=$matches[1]&paged=$matches[2]\";s:43:\"product/([^/]+)/comment-page-([0-9]{1,})/?$\";s:47:\"index.php?product=$matches[1]&cpage=$matches[2]\";s:33:\"product/([^/]+)/wc-api(/(.*))?/?$\";s:48:\"index.php?product=$matches[1]&wc-api=$matches[3]\";s:44:\"product/([^/]+)/wc/file/transient(/(.*))?/?$\";s:59:\"index.php?product=$matches[1]&wc/file/transient=$matches[3]\";s:39:\"product/[^/]+/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:50:\"product/[^/]+/attachment/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:50:\"product/[^/]+/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:61:\"product/[^/]+/attachment/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:32:\"product/([^/]+)(?:/([0-9]+))?/?$\";s:46:\"index.php?product=$matches[1]&page=$matches[2]\";s:24:\"product/[^/]+/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:34:\"product/[^/]+/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:54:\"product/[^/]+/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:49:\"product/[^/]+/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:49:\"product/[^/]+/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:30:\"product/[^/]+/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:12:\"robots\\.txt$\";s:18:\"index.php?robots=1\";s:13:\"favicon\\.ico$\";s:19:\"index.php?favicon=1\";s:12:\"sitemap\\.xml\";s:24:\"index.php??sitemap=index\";s:48:\".*wp-(atom|rdf|rss|rss2|feed|commentsrss2)\\.php$\";s:18:\"index.php?feed=old\";s:20:\".*wp-app\\.php(/.*)?$\";s:19:\"index.php?error=403\";s:18:\".*wp-register.php$\";s:23:\"index.php?register=true\";s:32:\"feed/(feed|rdf|rss|rss2|atom)/?$\";s:27:\"index.php?&feed=$matches[1]\";s:27:\"(feed|rdf|rss|rss2|atom)/?$\";s:27:\"index.php?&feed=$matches[1]\";s:8:\"embed/?$\";s:21:\"index.php?&embed=true\";s:20:\"page/?([0-9]{1,})/?$\";s:28:\"index.php?&paged=$matches[1]\";s:27:\"comment-page-([0-9]{1,})/?$\";s:38:\"index.php?&page_id=5&cpage=$matches[1]\";s:17:\"wc-api(/(.*))?/?$\";s:29:\"index.php?&wc-api=$matches[2]\";s:28:\"wc/file/transient(/(.*))?/?$\";s:40:\"index.php?&wc/file/transient=$matches[2]\";s:41:\"comments/feed/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?&feed=$matches[1]&withcomments=1\";s:36:\"comments/(feed|rdf|rss|rss2|atom)/?$\";s:42:\"index.php?&feed=$matches[1]&withcomments=1\";s:17:\"comments/embed/?$\";s:21:\"index.php?&embed=true\";s:26:\"comments/wc-api(/(.*))?/?$\";s:29:\"index.php?&wc-api=$matches[2]\";s:37:\"comments/wc/file/transient(/(.*))?/?$\";s:40:\"index.php?&wc/file/transient=$matches[2]\";s:44:\"search/(.+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:40:\"index.php?s=$matches[1]&feed=$matches[2]\";s:39:\"search/(.+)/(feed|rdf|rss|rss2|atom)/?$\";s:40:\"index.php?s=$matches[1]&feed=$matches[2]\";s:20:\"search/(.+)/embed/?$\";s:34:\"index.php?s=$matches[1]&embed=true\";s:32:\"search/(.+)/page/?([0-9]{1,})/?$\";s:41:\"index.php?s=$matches[1]&paged=$matches[2]\";s:29:\"search/(.+)/wc-api(/(.*))?/?$\";s:42:\"index.php?s=$matches[1]&wc-api=$matches[3]\";s:40:\"search/(.+)/wc/file/transient(/(.*))?/?$\";s:53:\"index.php?s=$matches[1]&wc/file/transient=$matches[3]\";s:14:\"search/(.+)/?$\";s:23:\"index.php?s=$matches[1]\";s:47:\"author/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?author_name=$matches[1]&feed=$matches[2]\";s:42:\"author/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:50:\"index.php?author_name=$matches[1]&feed=$matches[2]\";s:23:\"author/([^/]+)/embed/?$\";s:44:\"index.php?author_name=$matches[1]&embed=true\";s:35:\"author/([^/]+)/page/?([0-9]{1,})/?$\";s:51:\"index.php?author_name=$matches[1]&paged=$matches[2]\";s:32:\"author/([^/]+)/wc-api(/(.*))?/?$\";s:52:\"index.php?author_name=$matches[1]&wc-api=$matches[3]\";s:43:\"author/([^/]+)/wc/file/transient(/(.*))?/?$\";s:63:\"index.php?author_name=$matches[1]&wc/file/transient=$matches[3]\";s:17:\"author/([^/]+)/?$\";s:33:\"index.php?author_name=$matches[1]\";s:69:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:80:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&feed=$matches[4]\";s:64:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/(feed|rdf|rss|rss2|atom)/?$\";s:80:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&feed=$matches[4]\";s:45:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/embed/?$\";s:74:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&embed=true\";s:57:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/page/?([0-9]{1,})/?$\";s:81:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&paged=$matches[4]\";s:54:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/wc-api(/(.*))?/?$\";s:82:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&wc-api=$matches[5]\";s:65:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/wc/file/transient(/(.*))?/?$\";s:93:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]&wc/file/transient=$matches[5]\";s:39:\"([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})/?$\";s:63:\"index.php?year=$matches[1]&monthnum=$matches[2]&day=$matches[3]\";s:56:\"([0-9]{4})/([0-9]{1,2})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:64:\"index.php?year=$matches[1]&monthnum=$matches[2]&feed=$matches[3]\";s:51:\"([0-9]{4})/([0-9]{1,2})/(feed|rdf|rss|rss2|atom)/?$\";s:64:\"index.php?year=$matches[1]&monthnum=$matches[2]&feed=$matches[3]\";s:32:\"([0-9]{4})/([0-9]{1,2})/embed/?$\";s:58:\"index.php?year=$matches[1]&monthnum=$matches[2]&embed=true\";s:44:\"([0-9]{4})/([0-9]{1,2})/page/?([0-9]{1,})/?$\";s:65:\"index.php?year=$matches[1]&monthnum=$matches[2]&paged=$matches[3]\";s:41:\"([0-9]{4})/([0-9]{1,2})/wc-api(/(.*))?/?$\";s:66:\"index.php?year=$matches[1]&monthnum=$matches[2]&wc-api=$matches[4]\";s:52:\"([0-9]{4})/([0-9]{1,2})/wc/file/transient(/(.*))?/?$\";s:77:\"index.php?year=$matches[1]&monthnum=$matches[2]&wc/file/transient=$matches[4]\";s:26:\"([0-9]{4})/([0-9]{1,2})/?$\";s:47:\"index.php?year=$matches[1]&monthnum=$matches[2]\";s:43:\"([0-9]{4})/feed/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?year=$matches[1]&feed=$matches[2]\";s:38:\"([0-9]{4})/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?year=$matches[1]&feed=$matches[2]\";s:19:\"([0-9]{4})/embed/?$\";s:37:\"index.php?year=$matches[1]&embed=true\";s:31:\"([0-9]{4})/page/?([0-9]{1,})/?$\";s:44:\"index.php?year=$matches[1]&paged=$matches[2]\";s:28:\"([0-9]{4})/wc-api(/(.*))?/?$\";s:45:\"index.php?year=$matches[1]&wc-api=$matches[3]\";s:39:\"([0-9]{4})/wc/file/transient(/(.*))?/?$\";s:56:\"index.php?year=$matches[1]&wc/file/transient=$matches[3]\";s:13:\"([0-9]{4})/?$\";s:26:\"index.php?year=$matches[1]\";s:27:\".?.+?/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:37:\".?.+?/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:57:\".?.+?/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\".?.+?/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\".?.+?/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:33:\".?.+?/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:16:\"(.?.+?)/embed/?$\";s:41:\"index.php?pagename=$matches[1]&embed=true\";s:20:\"(.?.+?)/trackback/?$\";s:35:\"index.php?pagename=$matches[1]&tb=1\";s:40:\"(.?.+?)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?pagename=$matches[1]&feed=$matches[2]\";s:35:\"(.?.+?)/(feed|rdf|rss|rss2|atom)/?$\";s:47:\"index.php?pagename=$matches[1]&feed=$matches[2]\";s:28:\"(.?.+?)/page/?([0-9]{1,})/?$\";s:48:\"index.php?pagename=$matches[1]&paged=$matches[2]\";s:35:\"(.?.+?)/comment-page-([0-9]{1,})/?$\";s:48:\"index.php?pagename=$matches[1]&cpage=$matches[2]\";s:25:\"(.?.+?)/wc-api(/(.*))?/?$\";s:49:\"index.php?pagename=$matches[1]&wc-api=$matches[3]\";s:36:\"(.?.+?)/wc/file/transient(/(.*))?/?$\";s:60:\"index.php?pagename=$matches[1]&wc/file/transient=$matches[3]\";s:28:\"(.?.+?)/order-pay(/(.*))?/?$\";s:52:\"index.php?pagename=$matches[1]&order-pay=$matches[3]\";s:33:\"(.?.+?)/order-received(/(.*))?/?$\";s:57:\"index.php?pagename=$matches[1]&order-received=$matches[3]\";s:25:\"(.?.+?)/orders(/(.*))?/?$\";s:49:\"index.php?pagename=$matches[1]&orders=$matches[3]\";s:29:\"(.?.+?)/view-order(/(.*))?/?$\";s:53:\"index.php?pagename=$matches[1]&view-order=$matches[3]\";s:28:\"(.?.+?)/downloads(/(.*))?/?$\";s:52:\"index.php?pagename=$matches[1]&downloads=$matches[3]\";s:31:\"(.?.+?)/edit-account(/(.*))?/?$\";s:55:\"index.php?pagename=$matches[1]&edit-account=$matches[3]\";s:31:\"(.?.+?)/edit-address(/(.*))?/?$\";s:55:\"index.php?pagename=$matches[1]&edit-address=$matches[3]\";s:34:\"(.?.+?)/payment-methods(/(.*))?/?$\";s:58:\"index.php?pagename=$matches[1]&payment-methods=$matches[3]\";s:32:\"(.?.+?)/lost-password(/(.*))?/?$\";s:56:\"index.php?pagename=$matches[1]&lost-password=$matches[3]\";s:34:\"(.?.+?)/customer-logout(/(.*))?/?$\";s:58:\"index.php?pagename=$matches[1]&customer-logout=$matches[3]\";s:37:\"(.?.+?)/add-payment-method(/(.*))?/?$\";s:61:\"index.php?pagename=$matches[1]&add-payment-method=$matches[3]\";s:40:\"(.?.+?)/delete-payment-method(/(.*))?/?$\";s:64:\"index.php?pagename=$matches[1]&delete-payment-method=$matches[3]\";s:45:\"(.?.+?)/set-default-payment-method(/(.*))?/?$\";s:69:\"index.php?pagename=$matches[1]&set-default-payment-method=$matches[3]\";s:31:\".?.+?/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:42:\".?.+?/attachment/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:42:\".?.+?/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:53:\".?.+?/attachment/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:24:\"(.?.+?)(?:/([0-9]+))?/?$\";s:47:\"index.php?pagename=$matches[1]&page=$matches[2]\";s:27:\"[^/]+/attachment/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:37:\"[^/]+/attachment/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:57:\"[^/]+/attachment/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\"[^/]+/attachment/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:52:\"[^/]+/attachment/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:33:\"[^/]+/attachment/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";s:16:\"([^/]+)/embed/?$\";s:37:\"index.php?name=$matches[1]&embed=true\";s:20:\"([^/]+)/trackback/?$\";s:31:\"index.php?name=$matches[1]&tb=1\";s:40:\"([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?name=$matches[1]&feed=$matches[2]\";s:35:\"([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:43:\"index.php?name=$matches[1]&feed=$matches[2]\";s:28:\"([^/]+)/page/?([0-9]{1,})/?$\";s:44:\"index.php?name=$matches[1]&paged=$matches[2]\";s:35:\"([^/]+)/comment-page-([0-9]{1,})/?$\";s:44:\"index.php?name=$matches[1]&cpage=$matches[2]\";s:25:\"([^/]+)/wc-api(/(.*))?/?$\";s:45:\"index.php?name=$matches[1]&wc-api=$matches[3]\";s:36:\"([^/]+)/wc/file/transient(/(.*))?/?$\";s:56:\"index.php?name=$matches[1]&wc/file/transient=$matches[3]\";s:31:\"[^/]+/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:42:\"[^/]+/attachment/([^/]+)/wc-api(/(.*))?/?$\";s:51:\"index.php?attachment=$matches[1]&wc-api=$matches[3]\";s:42:\"[^/]+/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:53:\"[^/]+/attachment/([^/]+)/wc/file/transient(/(.*))?/?$\";s:62:\"index.php?attachment=$matches[1]&wc/file/transient=$matches[3]\";s:24:\"([^/]+)(?:/([0-9]+))?/?$\";s:43:\"index.php?name=$matches[1]&page=$matches[2]\";s:16:\"[^/]+/([^/]+)/?$\";s:32:\"index.php?attachment=$matches[1]\";s:26:\"[^/]+/([^/]+)/trackback/?$\";s:37:\"index.php?attachment=$matches[1]&tb=1\";s:46:\"[^/]+/([^/]+)/feed/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:41:\"[^/]+/([^/]+)/(feed|rdf|rss|rss2|atom)/?$\";s:49:\"index.php?attachment=$matches[1]&feed=$matches[2]\";s:41:\"[^/]+/([^/]+)/comment-page-([0-9]{1,})/?$\";s:50:\"index.php?attachment=$matches[1]&cpage=$matches[2]\";s:22:\"[^/]+/([^/]+)/embed/?$\";s:43:\"index.php?attachment=$matches[1]&embed=true\";}','on'),
(31,'hack_file','0','on'),
(32,'blog_charset','UTF-8','on'),
(33,'moderation_keys','','off'),
(34,'active_plugins','a:1:{i:0;s:27:\"woocommerce/woocommerce.php\";}','on'),
(35,'category_base','','on'),
(36,'ping_sites','http://rpc.pingomatic.com/','on'),
(37,'comment_max_links','2','on'),
(38,'gmt_offset','0','on'),
(39,'default_email_category','1','on'),
(40,'recently_edited','','off'),
(41,'template','storefront','on'),
(42,'stylesheet','storefront','on'),
(43,'comment_registration','0','on'),
(44,'html_type','text/html','on'),
(45,'use_trackback','0','on'),
(46,'default_role','subscriber','on'),
(47,'db_version','58975','on'),
(48,'uploads_use_yearmonth_folders','1','on'),
(49,'upload_path','','on'),
(50,'blog_public','1','on'),
(51,'default_link_category','2','on'),
(52,'show_on_front','page','on'),
(53,'tag_base','','on'),
(54,'show_avatars','1','on'),
(55,'avatar_rating','G','on'),
(56,'upload_url_path','','on'),
(57,'thumbnail_size_w','150','on'),
(58,'thumbnail_size_h','150','on'),
(59,'thumbnail_crop','1','on'),
(60,'medium_size_w','300','on'),
(61,'medium_size_h','300','on'),
(62,'avatar_default','mystery','on'),
(63,'large_size_w','1024','on'),
(64,'large_size_h','1024','on'),
(65,'image_default_link_type','none','on'),
(66,'image_default_size','','on'),
(67,'image_default_align','','on'),
(68,'close_comments_for_old_posts','0','on'),
(69,'close_comments_days_old','14','on'),
(70,'thread_comments','1','on'),
(71,'thread_comments_depth','5','on'),
(72,'page_comments','0','on'),
(73,'comments_per_page','50','on'),
(74,'default_comments_page','newest','on'),
(75,'comment_order','asc','on'),
(76,'sticky_posts','a:0:{}','on'),
(77,'widget_categories','a:0:{}','on'),
(78,'widget_text','a:0:{}','on'),
(79,'widget_rss','a:0:{}','on'),
(80,'uninstall_plugins','a:0:{}','off'),
(81,'timezone_string','','on'),
(82,'page_for_posts','0','on'),
(83,'page_on_front','5','on'),
(84,'default_post_format','0','on'),
(85,'link_manager_enabled','0','on'),
(86,'finished_splitting_shared_terms','1','on'),
(87,'site_icon','0','on'),
(88,'medium_large_size_w','768','on'),
(89,'medium_large_size_h','0','on'),
(90,'wp_page_for_privacy_policy','3','on'),
(91,'show_comments_cookies_opt_in','1','on'),
(92,'admin_email_lifespan','1807861964','on'),
(93,'disallowed_keys','','off'),
(94,'comment_previously_approved','1','on'),
(95,'auto_plugin_theme_update_emails','a:0:{}','off'),
(96,'auto_update_core_dev','enabled','on'),
(97,'auto_update_core_minor','enabled','on'),
(98,'auto_update_core_major','enabled','on'),
(99,'wp_force_deactivated_plugins','a:0:{}','on'),
(100,'wp_attachment_pages_enabled','0','on'),
(101,'initial_db_version','58975','on'),
(102,'wp_user_roles','a:7:{s:13:\"administrator\";a:2:{s:4:\"name\";s:13:\"Administrator\";s:12:\"capabilities\";a:114:{s:13:\"switch_themes\";b:1;s:11:\"edit_themes\";b:1;s:16:\"activate_plugins\";b:1;s:12:\"edit_plugins\";b:1;s:10:\"edit_users\";b:1;s:10:\"edit_files\";b:1;s:14:\"manage_options\";b:1;s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:6:\"import\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:8:\"level_10\";b:1;s:7:\"level_9\";b:1;s:7:\"level_8\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:12:\"delete_users\";b:1;s:12:\"create_users\";b:1;s:17:\"unfiltered_upload\";b:1;s:14:\"edit_dashboard\";b:1;s:14:\"update_plugins\";b:1;s:14:\"delete_plugins\";b:1;s:15:\"install_plugins\";b:1;s:13:\"update_themes\";b:1;s:14:\"install_themes\";b:1;s:11:\"update_core\";b:1;s:10:\"list_users\";b:1;s:12:\"remove_users\";b:1;s:13:\"promote_users\";b:1;s:18:\"edit_theme_options\";b:1;s:13:\"delete_themes\";b:1;s:6:\"export\";b:1;s:18:\"manage_woocommerce\";b:1;s:24:\"view_woocommerce_reports\";b:1;s:12:\"edit_product\";b:1;s:12:\"read_product\";b:1;s:14:\"delete_product\";b:1;s:13:\"edit_products\";b:1;s:20:\"edit_others_products\";b:1;s:16:\"publish_products\";b:1;s:21:\"read_private_products\";b:1;s:15:\"delete_products\";b:1;s:23:\"delete_private_products\";b:1;s:25:\"delete_published_products\";b:1;s:22:\"delete_others_products\";b:1;s:21:\"edit_private_products\";b:1;s:23:\"edit_published_products\";b:1;s:20:\"manage_product_terms\";b:1;s:18:\"edit_product_terms\";b:1;s:20:\"delete_product_terms\";b:1;s:20:\"assign_product_terms\";b:1;s:15:\"edit_shop_order\";b:1;s:15:\"read_shop_order\";b:1;s:17:\"delete_shop_order\";b:1;s:16:\"edit_shop_orders\";b:1;s:23:\"edit_others_shop_orders\";b:1;s:19:\"publish_shop_orders\";b:1;s:24:\"read_private_shop_orders\";b:1;s:18:\"delete_shop_orders\";b:1;s:26:\"delete_private_shop_orders\";b:1;s:28:\"delete_published_shop_orders\";b:1;s:25:\"delete_others_shop_orders\";b:1;s:24:\"edit_private_shop_orders\";b:1;s:26:\"edit_published_shop_orders\";b:1;s:23:\"manage_shop_order_terms\";b:1;s:21:\"edit_shop_order_terms\";b:1;s:23:\"delete_shop_order_terms\";b:1;s:23:\"assign_shop_order_terms\";b:1;s:16:\"edit_shop_coupon\";b:1;s:16:\"read_shop_coupon\";b:1;s:18:\"delete_shop_coupon\";b:1;s:17:\"edit_shop_coupons\";b:1;s:24:\"edit_others_shop_coupons\";b:1;s:20:\"publish_shop_coupons\";b:1;s:25:\"read_private_shop_coupons\";b:1;s:19:\"delete_shop_coupons\";b:1;s:27:\"delete_private_shop_coupons\";b:1;s:29:\"delete_published_shop_coupons\";b:1;s:26:\"delete_others_shop_coupons\";b:1;s:25:\"edit_private_shop_coupons\";b:1;s:27:\"edit_published_shop_coupons\";b:1;s:24:\"manage_shop_coupon_terms\";b:1;s:22:\"edit_shop_coupon_terms\";b:1;s:24:\"delete_shop_coupon_terms\";b:1;s:24:\"assign_shop_coupon_terms\";b:1;}}s:6:\"editor\";a:2:{s:4:\"name\";s:6:\"Editor\";s:12:\"capabilities\";a:34:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;}}s:6:\"author\";a:2:{s:4:\"name\";s:6:\"Author\";s:12:\"capabilities\";a:10:{s:12:\"upload_files\";b:1;s:10:\"edit_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;s:22:\"delete_published_posts\";b:1;}}s:11:\"contributor\";a:2:{s:4:\"name\";s:11:\"Contributor\";s:12:\"capabilities\";a:5:{s:10:\"edit_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;}}s:10:\"subscriber\";a:2:{s:4:\"name\";s:10:\"Subscriber\";s:12:\"capabilities\";a:2:{s:4:\"read\";b:1;s:7:\"level_0\";b:1;}}s:8:\"customer\";a:2:{s:4:\"name\";s:8:\"Customer\";s:12:\"capabilities\";a:1:{s:4:\"read\";b:1;}}s:12:\"shop_manager\";a:2:{s:4:\"name\";s:12:\"Shop manager\";s:12:\"capabilities\";a:92:{s:7:\"level_9\";b:1;s:7:\"level_8\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:4:\"read\";b:1;s:18:\"read_private_pages\";b:1;s:18:\"read_private_posts\";b:1;s:10:\"edit_posts\";b:1;s:10:\"edit_pages\";b:1;s:20:\"edit_published_posts\";b:1;s:20:\"edit_published_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"edit_private_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:17:\"edit_others_pages\";b:1;s:13:\"publish_posts\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_posts\";b:1;s:12:\"delete_pages\";b:1;s:20:\"delete_private_pages\";b:1;s:20:\"delete_private_posts\";b:1;s:22:\"delete_published_pages\";b:1;s:22:\"delete_published_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:19:\"delete_others_pages\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:17:\"moderate_comments\";b:1;s:12:\"upload_files\";b:1;s:6:\"export\";b:1;s:6:\"import\";b:1;s:10:\"list_users\";b:1;s:18:\"edit_theme_options\";b:1;s:18:\"manage_woocommerce\";b:1;s:24:\"view_woocommerce_reports\";b:1;s:12:\"edit_product\";b:1;s:12:\"read_product\";b:1;s:14:\"delete_product\";b:1;s:13:\"edit_products\";b:1;s:20:\"edit_others_products\";b:1;s:16:\"publish_products\";b:1;s:21:\"read_private_products\";b:1;s:15:\"delete_products\";b:1;s:23:\"delete_private_products\";b:1;s:25:\"delete_published_products\";b:1;s:22:\"delete_others_products\";b:1;s:21:\"edit_private_products\";b:1;s:23:\"edit_published_products\";b:1;s:20:\"manage_product_terms\";b:1;s:18:\"edit_product_terms\";b:1;s:20:\"delete_product_terms\";b:1;s:20:\"assign_product_terms\";b:1;s:15:\"edit_shop_order\";b:1;s:15:\"read_shop_order\";b:1;s:17:\"delete_shop_order\";b:1;s:16:\"edit_shop_orders\";b:1;s:23:\"edit_others_shop_orders\";b:1;s:19:\"publish_shop_orders\";b:1;s:24:\"read_private_shop_orders\";b:1;s:18:\"delete_shop_orders\";b:1;s:26:\"delete_private_shop_orders\";b:1;s:28:\"delete_published_shop_orders\";b:1;s:25:\"delete_others_shop_orders\";b:1;s:24:\"edit_private_shop_orders\";b:1;s:26:\"edit_published_shop_orders\";b:1;s:23:\"manage_shop_order_terms\";b:1;s:21:\"edit_shop_order_terms\";b:1;s:23:\"delete_shop_order_terms\";b:1;s:23:\"assign_shop_order_terms\";b:1;s:16:\"edit_shop_coupon\";b:1;s:16:\"read_shop_coupon\";b:1;s:18:\"delete_shop_coupon\";b:1;s:17:\"edit_shop_coupons\";b:1;s:24:\"edit_others_shop_coupons\";b:1;s:20:\"publish_shop_coupons\";b:1;s:25:\"read_private_shop_coupons\";b:1;s:19:\"delete_shop_coupons\";b:1;s:27:\"delete_private_shop_coupons\";b:1;s:29:\"delete_published_shop_coupons\";b:1;s:26:\"delete_others_shop_coupons\";b:1;s:25:\"edit_private_shop_coupons\";b:1;s:27:\"edit_published_shop_coupons\";b:1;s:24:\"manage_shop_coupon_terms\";b:1;s:22:\"edit_shop_coupon_terms\";b:1;s:24:\"delete_shop_coupon_terms\";b:1;s:24:\"assign_shop_coupon_terms\";b:1;}}}','on'),
(103,'fresh_site','1','off'),
(104,'user_count','1','off'),
(105,'widget_block','a:6:{i:2;a:1:{s:7:\"content\";s:19:\"<!-- wp:search /-->\";}i:3;a:1:{s:7:\"content\";s:154:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Posts</h2><!-- /wp:heading --><!-- wp:latest-posts /--></div><!-- /wp:group -->\";}i:4;a:1:{s:7:\"content\";s:227:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Comments</h2><!-- /wp:heading --><!-- wp:latest-comments {\"displayAvatar\":false,\"displayDate\":false,\"displayExcerpt\":false} /--></div><!-- /wp:group -->\";}i:5;a:1:{s:7:\"content\";s:146:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Archives</h2><!-- /wp:heading --><!-- wp:archives /--></div><!-- /wp:group -->\";}i:6;a:1:{s:7:\"content\";s:150:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Categories</h2><!-- /wp:heading --><!-- wp:categories /--></div><!-- /wp:group -->\";}s:12:\"_multiwidget\";i:1;}','auto'),
(106,'sidebars_widgets','a:8:{s:19:\"wp_inactive_widgets\";a:0:{}s:9:\"sidebar-1\";a:5:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";i:3;s:7:\"block-5\";i:4;s:7:\"block-6\";}s:8:\"header-1\";a:0:{}s:8:\"footer-1\";a:0:{}s:8:\"footer-2\";a:0:{}s:8:\"footer-3\";a:0:{}s:8:\"footer-4\";a:0:{}s:13:\"array_version\";i:3;}','auto'),
(107,'widget_pages','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(108,'widget_calendar','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(109,'widget_archives','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(110,'widget_media_audio','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(111,'widget_media_image','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(112,'widget_media_gallery','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(113,'widget_media_video','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(114,'widget_meta','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(115,'widget_search','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(116,'widget_recent-posts','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(117,'widget_recent-comments','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(118,'widget_tag_cloud','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(119,'widget_nav_menu','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(120,'widget_custom_html','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(121,'_transient_wp_core_block_css_files','a:2:{s:7:\"version\";s:5:\"6.7.2\";s:5:\"files\";a:540:{i:0;s:23:\"archives/editor-rtl.css\";i:1;s:27:\"archives/editor-rtl.min.css\";i:2;s:19:\"archives/editor.css\";i:3;s:23:\"archives/editor.min.css\";i:4;s:22:\"archives/style-rtl.css\";i:5;s:26:\"archives/style-rtl.min.css\";i:6;s:18:\"archives/style.css\";i:7;s:22:\"archives/style.min.css\";i:8;s:20:\"audio/editor-rtl.css\";i:9;s:24:\"audio/editor-rtl.min.css\";i:10;s:16:\"audio/editor.css\";i:11;s:20:\"audio/editor.min.css\";i:12;s:19:\"audio/style-rtl.css\";i:13;s:23:\"audio/style-rtl.min.css\";i:14;s:15:\"audio/style.css\";i:15;s:19:\"audio/style.min.css\";i:16;s:19:\"audio/theme-rtl.css\";i:17;s:23:\"audio/theme-rtl.min.css\";i:18;s:15:\"audio/theme.css\";i:19;s:19:\"audio/theme.min.css\";i:20;s:21:\"avatar/editor-rtl.css\";i:21;s:25:\"avatar/editor-rtl.min.css\";i:22;s:17:\"avatar/editor.css\";i:23;s:21:\"avatar/editor.min.css\";i:24;s:20:\"avatar/style-rtl.css\";i:25;s:24:\"avatar/style-rtl.min.css\";i:26;s:16:\"avatar/style.css\";i:27;s:20:\"avatar/style.min.css\";i:28;s:21:\"button/editor-rtl.css\";i:29;s:25:\"button/editor-rtl.min.css\";i:30;s:17:\"button/editor.css\";i:31;s:21:\"button/editor.min.css\";i:32;s:20:\"button/style-rtl.css\";i:33;s:24:\"button/style-rtl.min.css\";i:34;s:16:\"button/style.css\";i:35;s:20:\"button/style.min.css\";i:36;s:22:\"buttons/editor-rtl.css\";i:37;s:26:\"buttons/editor-rtl.min.css\";i:38;s:18:\"buttons/editor.css\";i:39;s:22:\"buttons/editor.min.css\";i:40;s:21:\"buttons/style-rtl.css\";i:41;s:25:\"buttons/style-rtl.min.css\";i:42;s:17:\"buttons/style.css\";i:43;s:21:\"buttons/style.min.css\";i:44;s:22:\"calendar/style-rtl.css\";i:45;s:26:\"calendar/style-rtl.min.css\";i:46;s:18:\"calendar/style.css\";i:47;s:22:\"calendar/style.min.css\";i:48;s:25:\"categories/editor-rtl.css\";i:49;s:29:\"categories/editor-rtl.min.css\";i:50;s:21:\"categories/editor.css\";i:51;s:25:\"categories/editor.min.css\";i:52;s:24:\"categories/style-rtl.css\";i:53;s:28:\"categories/style-rtl.min.css\";i:54;s:20:\"categories/style.css\";i:55;s:24:\"categories/style.min.css\";i:56;s:19:\"code/editor-rtl.css\";i:57;s:23:\"code/editor-rtl.min.css\";i:58;s:15:\"code/editor.css\";i:59;s:19:\"code/editor.min.css\";i:60;s:18:\"code/style-rtl.css\";i:61;s:22:\"code/style-rtl.min.css\";i:62;s:14:\"code/style.css\";i:63;s:18:\"code/style.min.css\";i:64;s:18:\"code/theme-rtl.css\";i:65;s:22:\"code/theme-rtl.min.css\";i:66;s:14:\"code/theme.css\";i:67;s:18:\"code/theme.min.css\";i:68;s:22:\"columns/editor-rtl.css\";i:69;s:26:\"columns/editor-rtl.min.css\";i:70;s:18:\"columns/editor.css\";i:71;s:22:\"columns/editor.min.css\";i:72;s:21:\"columns/style-rtl.css\";i:73;s:25:\"columns/style-rtl.min.css\";i:74;s:17:\"columns/style.css\";i:75;s:21:\"columns/style.min.css\";i:76;s:33:\"comment-author-name/style-rtl.css\";i:77;s:37:\"comment-author-name/style-rtl.min.css\";i:78;s:29:\"comment-author-name/style.css\";i:79;s:33:\"comment-author-name/style.min.css\";i:80;s:29:\"comment-content/style-rtl.css\";i:81;s:33:\"comment-content/style-rtl.min.css\";i:82;s:25:\"comment-content/style.css\";i:83;s:29:\"comment-content/style.min.css\";i:84;s:26:\"comment-date/style-rtl.css\";i:85;s:30:\"comment-date/style-rtl.min.css\";i:86;s:22:\"comment-date/style.css\";i:87;s:26:\"comment-date/style.min.css\";i:88;s:31:\"comment-edit-link/style-rtl.css\";i:89;s:35:\"comment-edit-link/style-rtl.min.css\";i:90;s:27:\"comment-edit-link/style.css\";i:91;s:31:\"comment-edit-link/style.min.css\";i:92;s:32:\"comment-reply-link/style-rtl.css\";i:93;s:36:\"comment-reply-link/style-rtl.min.css\";i:94;s:28:\"comment-reply-link/style.css\";i:95;s:32:\"comment-reply-link/style.min.css\";i:96;s:30:\"comment-template/style-rtl.css\";i:97;s:34:\"comment-template/style-rtl.min.css\";i:98;s:26:\"comment-template/style.css\";i:99;s:30:\"comment-template/style.min.css\";i:100;s:42:\"comments-pagination-numbers/editor-rtl.css\";i:101;s:46:\"comments-pagination-numbers/editor-rtl.min.css\";i:102;s:38:\"comments-pagination-numbers/editor.css\";i:103;s:42:\"comments-pagination-numbers/editor.min.css\";i:104;s:34:\"comments-pagination/editor-rtl.css\";i:105;s:38:\"comments-pagination/editor-rtl.min.css\";i:106;s:30:\"comments-pagination/editor.css\";i:107;s:34:\"comments-pagination/editor.min.css\";i:108;s:33:\"comments-pagination/style-rtl.css\";i:109;s:37:\"comments-pagination/style-rtl.min.css\";i:110;s:29:\"comments-pagination/style.css\";i:111;s:33:\"comments-pagination/style.min.css\";i:112;s:29:\"comments-title/editor-rtl.css\";i:113;s:33:\"comments-title/editor-rtl.min.css\";i:114;s:25:\"comments-title/editor.css\";i:115;s:29:\"comments-title/editor.min.css\";i:116;s:23:\"comments/editor-rtl.css\";i:117;s:27:\"comments/editor-rtl.min.css\";i:118;s:19:\"comments/editor.css\";i:119;s:23:\"comments/editor.min.css\";i:120;s:22:\"comments/style-rtl.css\";i:121;s:26:\"comments/style-rtl.min.css\";i:122;s:18:\"comments/style.css\";i:123;s:22:\"comments/style.min.css\";i:124;s:20:\"cover/editor-rtl.css\";i:125;s:24:\"cover/editor-rtl.min.css\";i:126;s:16:\"cover/editor.css\";i:127;s:20:\"cover/editor.min.css\";i:128;s:19:\"cover/style-rtl.css\";i:129;s:23:\"cover/style-rtl.min.css\";i:130;s:15:\"cover/style.css\";i:131;s:19:\"cover/style.min.css\";i:132;s:22:\"details/editor-rtl.css\";i:133;s:26:\"details/editor-rtl.min.css\";i:134;s:18:\"details/editor.css\";i:135;s:22:\"details/editor.min.css\";i:136;s:21:\"details/style-rtl.css\";i:137;s:25:\"details/style-rtl.min.css\";i:138;s:17:\"details/style.css\";i:139;s:21:\"details/style.min.css\";i:140;s:20:\"embed/editor-rtl.css\";i:141;s:24:\"embed/editor-rtl.min.css\";i:142;s:16:\"embed/editor.css\";i:143;s:20:\"embed/editor.min.css\";i:144;s:19:\"embed/style-rtl.css\";i:145;s:23:\"embed/style-rtl.min.css\";i:146;s:15:\"embed/style.css\";i:147;s:19:\"embed/style.min.css\";i:148;s:19:\"embed/theme-rtl.css\";i:149;s:23:\"embed/theme-rtl.min.css\";i:150;s:15:\"embed/theme.css\";i:151;s:19:\"embed/theme.min.css\";i:152;s:19:\"file/editor-rtl.css\";i:153;s:23:\"file/editor-rtl.min.css\";i:154;s:15:\"file/editor.css\";i:155;s:19:\"file/editor.min.css\";i:156;s:18:\"file/style-rtl.css\";i:157;s:22:\"file/style-rtl.min.css\";i:158;s:14:\"file/style.css\";i:159;s:18:\"file/style.min.css\";i:160;s:23:\"footnotes/style-rtl.css\";i:161;s:27:\"footnotes/style-rtl.min.css\";i:162;s:19:\"footnotes/style.css\";i:163;s:23:\"footnotes/style.min.css\";i:164;s:23:\"freeform/editor-rtl.css\";i:165;s:27:\"freeform/editor-rtl.min.css\";i:166;s:19:\"freeform/editor.css\";i:167;s:23:\"freeform/editor.min.css\";i:168;s:22:\"gallery/editor-rtl.css\";i:169;s:26:\"gallery/editor-rtl.min.css\";i:170;s:18:\"gallery/editor.css\";i:171;s:22:\"gallery/editor.min.css\";i:172;s:21:\"gallery/style-rtl.css\";i:173;s:25:\"gallery/style-rtl.min.css\";i:174;s:17:\"gallery/style.css\";i:175;s:21:\"gallery/style.min.css\";i:176;s:21:\"gallery/theme-rtl.css\";i:177;s:25:\"gallery/theme-rtl.min.css\";i:178;s:17:\"gallery/theme.css\";i:179;s:21:\"gallery/theme.min.css\";i:180;s:20:\"group/editor-rtl.css\";i:181;s:24:\"group/editor-rtl.min.css\";i:182;s:16:\"group/editor.css\";i:183;s:20:\"group/editor.min.css\";i:184;s:19:\"group/style-rtl.css\";i:185;s:23:\"group/style-rtl.min.css\";i:186;s:15:\"group/style.css\";i:187;s:19:\"group/style.min.css\";i:188;s:19:\"group/theme-rtl.css\";i:189;s:23:\"group/theme-rtl.min.css\";i:190;s:15:\"group/theme.css\";i:191;s:19:\"group/theme.min.css\";i:192;s:21:\"heading/style-rtl.css\";i:193;s:25:\"heading/style-rtl.min.css\";i:194;s:17:\"heading/style.css\";i:195;s:21:\"heading/style.min.css\";i:196;s:19:\"html/editor-rtl.css\";i:197;s:23:\"html/editor-rtl.min.css\";i:198;s:15:\"html/editor.css\";i:199;s:19:\"html/editor.min.css\";i:200;s:20:\"image/editor-rtl.css\";i:201;s:24:\"image/editor-rtl.min.css\";i:202;s:16:\"image/editor.css\";i:203;s:20:\"image/editor.min.css\";i:204;s:19:\"image/style-rtl.css\";i:205;s:23:\"image/style-rtl.min.css\";i:206;s:15:\"image/style.css\";i:207;s:19:\"image/style.min.css\";i:208;s:19:\"image/theme-rtl.css\";i:209;s:23:\"image/theme-rtl.min.css\";i:210;s:15:\"image/theme.css\";i:211;s:19:\"image/theme.min.css\";i:212;s:29:\"latest-comments/style-rtl.css\";i:213;s:33:\"latest-comments/style-rtl.min.css\";i:214;s:25:\"latest-comments/style.css\";i:215;s:29:\"latest-comments/style.min.css\";i:216;s:27:\"latest-posts/editor-rtl.css\";i:217;s:31:\"latest-posts/editor-rtl.min.css\";i:218;s:23:\"latest-posts/editor.css\";i:219;s:27:\"latest-posts/editor.min.css\";i:220;s:26:\"latest-posts/style-rtl.css\";i:221;s:30:\"latest-posts/style-rtl.min.css\";i:222;s:22:\"latest-posts/style.css\";i:223;s:26:\"latest-posts/style.min.css\";i:224;s:18:\"list/style-rtl.css\";i:225;s:22:\"list/style-rtl.min.css\";i:226;s:14:\"list/style.css\";i:227;s:18:\"list/style.min.css\";i:228;s:22:\"loginout/style-rtl.css\";i:229;s:26:\"loginout/style-rtl.min.css\";i:230;s:18:\"loginout/style.css\";i:231;s:22:\"loginout/style.min.css\";i:232;s:25:\"media-text/editor-rtl.css\";i:233;s:29:\"media-text/editor-rtl.min.css\";i:234;s:21:\"media-text/editor.css\";i:235;s:25:\"media-text/editor.min.css\";i:236;s:24:\"media-text/style-rtl.css\";i:237;s:28:\"media-text/style-rtl.min.css\";i:238;s:20:\"media-text/style.css\";i:239;s:24:\"media-text/style.min.css\";i:240;s:19:\"more/editor-rtl.css\";i:241;s:23:\"more/editor-rtl.min.css\";i:242;s:15:\"more/editor.css\";i:243;s:19:\"more/editor.min.css\";i:244;s:30:\"navigation-link/editor-rtl.css\";i:245;s:34:\"navigation-link/editor-rtl.min.css\";i:246;s:26:\"navigation-link/editor.css\";i:247;s:30:\"navigation-link/editor.min.css\";i:248;s:29:\"navigation-link/style-rtl.css\";i:249;s:33:\"navigation-link/style-rtl.min.css\";i:250;s:25:\"navigation-link/style.css\";i:251;s:29:\"navigation-link/style.min.css\";i:252;s:33:\"navigation-submenu/editor-rtl.css\";i:253;s:37:\"navigation-submenu/editor-rtl.min.css\";i:254;s:29:\"navigation-submenu/editor.css\";i:255;s:33:\"navigation-submenu/editor.min.css\";i:256;s:25:\"navigation/editor-rtl.css\";i:257;s:29:\"navigation/editor-rtl.min.css\";i:258;s:21:\"navigation/editor.css\";i:259;s:25:\"navigation/editor.min.css\";i:260;s:24:\"navigation/style-rtl.css\";i:261;s:28:\"navigation/style-rtl.min.css\";i:262;s:20:\"navigation/style.css\";i:263;s:24:\"navigation/style.min.css\";i:264;s:23:\"nextpage/editor-rtl.css\";i:265;s:27:\"nextpage/editor-rtl.min.css\";i:266;s:19:\"nextpage/editor.css\";i:267;s:23:\"nextpage/editor.min.css\";i:268;s:24:\"page-list/editor-rtl.css\";i:269;s:28:\"page-list/editor-rtl.min.css\";i:270;s:20:\"page-list/editor.css\";i:271;s:24:\"page-list/editor.min.css\";i:272;s:23:\"page-list/style-rtl.css\";i:273;s:27:\"page-list/style-rtl.min.css\";i:274;s:19:\"page-list/style.css\";i:275;s:23:\"page-list/style.min.css\";i:276;s:24:\"paragraph/editor-rtl.css\";i:277;s:28:\"paragraph/editor-rtl.min.css\";i:278;s:20:\"paragraph/editor.css\";i:279;s:24:\"paragraph/editor.min.css\";i:280;s:23:\"paragraph/style-rtl.css\";i:281;s:27:\"paragraph/style-rtl.min.css\";i:282;s:19:\"paragraph/style.css\";i:283;s:23:\"paragraph/style.min.css\";i:284;s:35:\"post-author-biography/style-rtl.css\";i:285;s:39:\"post-author-biography/style-rtl.min.css\";i:286;s:31:\"post-author-biography/style.css\";i:287;s:35:\"post-author-biography/style.min.css\";i:288;s:30:\"post-author-name/style-rtl.css\";i:289;s:34:\"post-author-name/style-rtl.min.css\";i:290;s:26:\"post-author-name/style.css\";i:291;s:30:\"post-author-name/style.min.css\";i:292;s:26:\"post-author/editor-rtl.css\";i:293;s:30:\"post-author/editor-rtl.min.css\";i:294;s:22:\"post-author/editor.css\";i:295;s:26:\"post-author/editor.min.css\";i:296;s:25:\"post-author/style-rtl.css\";i:297;s:29:\"post-author/style-rtl.min.css\";i:298;s:21:\"post-author/style.css\";i:299;s:25:\"post-author/style.min.css\";i:300;s:33:\"post-comments-form/editor-rtl.css\";i:301;s:37:\"post-comments-form/editor-rtl.min.css\";i:302;s:29:\"post-comments-form/editor.css\";i:303;s:33:\"post-comments-form/editor.min.css\";i:304;s:32:\"post-comments-form/style-rtl.css\";i:305;s:36:\"post-comments-form/style-rtl.min.css\";i:306;s:28:\"post-comments-form/style.css\";i:307;s:32:\"post-comments-form/style.min.css\";i:308;s:27:\"post-content/editor-rtl.css\";i:309;s:31:\"post-content/editor-rtl.min.css\";i:310;s:23:\"post-content/editor.css\";i:311;s:27:\"post-content/editor.min.css\";i:312;s:26:\"post-content/style-rtl.css\";i:313;s:30:\"post-content/style-rtl.min.css\";i:314;s:22:\"post-content/style.css\";i:315;s:26:\"post-content/style.min.css\";i:316;s:23:\"post-date/style-rtl.css\";i:317;s:27:\"post-date/style-rtl.min.css\";i:318;s:19:\"post-date/style.css\";i:319;s:23:\"post-date/style.min.css\";i:320;s:27:\"post-excerpt/editor-rtl.css\";i:321;s:31:\"post-excerpt/editor-rtl.min.css\";i:322;s:23:\"post-excerpt/editor.css\";i:323;s:27:\"post-excerpt/editor.min.css\";i:324;s:26:\"post-excerpt/style-rtl.css\";i:325;s:30:\"post-excerpt/style-rtl.min.css\";i:326;s:22:\"post-excerpt/style.css\";i:327;s:26:\"post-excerpt/style.min.css\";i:328;s:34:\"post-featured-image/editor-rtl.css\";i:329;s:38:\"post-featured-image/editor-rtl.min.css\";i:330;s:30:\"post-featured-image/editor.css\";i:331;s:34:\"post-featured-image/editor.min.css\";i:332;s:33:\"post-featured-image/style-rtl.css\";i:333;s:37:\"post-featured-image/style-rtl.min.css\";i:334;s:29:\"post-featured-image/style.css\";i:335;s:33:\"post-featured-image/style.min.css\";i:336;s:34:\"post-navigation-link/style-rtl.css\";i:337;s:38:\"post-navigation-link/style-rtl.min.css\";i:338;s:30:\"post-navigation-link/style.css\";i:339;s:34:\"post-navigation-link/style.min.css\";i:340;s:28:\"post-template/editor-rtl.css\";i:341;s:32:\"post-template/editor-rtl.min.css\";i:342;s:24:\"post-template/editor.css\";i:343;s:28:\"post-template/editor.min.css\";i:344;s:27:\"post-template/style-rtl.css\";i:345;s:31:\"post-template/style-rtl.min.css\";i:346;s:23:\"post-template/style.css\";i:347;s:27:\"post-template/style.min.css\";i:348;s:24:\"post-terms/style-rtl.css\";i:349;s:28:\"post-terms/style-rtl.min.css\";i:350;s:20:\"post-terms/style.css\";i:351;s:24:\"post-terms/style.min.css\";i:352;s:24:\"post-title/style-rtl.css\";i:353;s:28:\"post-title/style-rtl.min.css\";i:354;s:20:\"post-title/style.css\";i:355;s:24:\"post-title/style.min.css\";i:356;s:26:\"preformatted/style-rtl.css\";i:357;s:30:\"preformatted/style-rtl.min.css\";i:358;s:22:\"preformatted/style.css\";i:359;s:26:\"preformatted/style.min.css\";i:360;s:24:\"pullquote/editor-rtl.css\";i:361;s:28:\"pullquote/editor-rtl.min.css\";i:362;s:20:\"pullquote/editor.css\";i:363;s:24:\"pullquote/editor.min.css\";i:364;s:23:\"pullquote/style-rtl.css\";i:365;s:27:\"pullquote/style-rtl.min.css\";i:366;s:19:\"pullquote/style.css\";i:367;s:23:\"pullquote/style.min.css\";i:368;s:23:\"pullquote/theme-rtl.css\";i:369;s:27:\"pullquote/theme-rtl.min.css\";i:370;s:19:\"pullquote/theme.css\";i:371;s:23:\"pullquote/theme.min.css\";i:372;s:39:\"query-pagination-numbers/editor-rtl.css\";i:373;s:43:\"query-pagination-numbers/editor-rtl.min.css\";i:374;s:35:\"query-pagination-numbers/editor.css\";i:375;s:39:\"query-pagination-numbers/editor.min.css\";i:376;s:31:\"query-pagination/editor-rtl.css\";i:377;s:35:\"query-pagination/editor-rtl.min.css\";i:378;s:27:\"query-pagination/editor.css\";i:379;s:31:\"query-pagination/editor.min.css\";i:380;s:30:\"query-pagination/style-rtl.css\";i:381;s:34:\"query-pagination/style-rtl.min.css\";i:382;s:26:\"query-pagination/style.css\";i:383;s:30:\"query-pagination/style.min.css\";i:384;s:25:\"query-title/style-rtl.css\";i:385;s:29:\"query-title/style-rtl.min.css\";i:386;s:21:\"query-title/style.css\";i:387;s:25:\"query-title/style.min.css\";i:388;s:20:\"query/editor-rtl.css\";i:389;s:24:\"query/editor-rtl.min.css\";i:390;s:16:\"query/editor.css\";i:391;s:20:\"query/editor.min.css\";i:392;s:19:\"quote/style-rtl.css\";i:393;s:23:\"quote/style-rtl.min.css\";i:394;s:15:\"quote/style.css\";i:395;s:19:\"quote/style.min.css\";i:396;s:19:\"quote/theme-rtl.css\";i:397;s:23:\"quote/theme-rtl.min.css\";i:398;s:15:\"quote/theme.css\";i:399;s:19:\"quote/theme.min.css\";i:400;s:23:\"read-more/style-rtl.css\";i:401;s:27:\"read-more/style-rtl.min.css\";i:402;s:19:\"read-more/style.css\";i:403;s:23:\"read-more/style.min.css\";i:404;s:18:\"rss/editor-rtl.css\";i:405;s:22:\"rss/editor-rtl.min.css\";i:406;s:14:\"rss/editor.css\";i:407;s:18:\"rss/editor.min.css\";i:408;s:17:\"rss/style-rtl.css\";i:409;s:21:\"rss/style-rtl.min.css\";i:410;s:13:\"rss/style.css\";i:411;s:17:\"rss/style.min.css\";i:412;s:21:\"search/editor-rtl.css\";i:413;s:25:\"search/editor-rtl.min.css\";i:414;s:17:\"search/editor.css\";i:415;s:21:\"search/editor.min.css\";i:416;s:20:\"search/style-rtl.css\";i:417;s:24:\"search/style-rtl.min.css\";i:418;s:16:\"search/style.css\";i:419;s:20:\"search/style.min.css\";i:420;s:20:\"search/theme-rtl.css\";i:421;s:24:\"search/theme-rtl.min.css\";i:422;s:16:\"search/theme.css\";i:423;s:20:\"search/theme.min.css\";i:424;s:24:\"separator/editor-rtl.css\";i:425;s:28:\"separator/editor-rtl.min.css\";i:426;s:20:\"separator/editor.css\";i:427;s:24:\"separator/editor.min.css\";i:428;s:23:\"separator/style-rtl.css\";i:429;s:27:\"separator/style-rtl.min.css\";i:430;s:19:\"separator/style.css\";i:431;s:23:\"separator/style.min.css\";i:432;s:23:\"separator/theme-rtl.css\";i:433;s:27:\"separator/theme-rtl.min.css\";i:434;s:19:\"separator/theme.css\";i:435;s:23:\"separator/theme.min.css\";i:436;s:24:\"shortcode/editor-rtl.css\";i:437;s:28:\"shortcode/editor-rtl.min.css\";i:438;s:20:\"shortcode/editor.css\";i:439;s:24:\"shortcode/editor.min.css\";i:440;s:24:\"site-logo/editor-rtl.css\";i:441;s:28:\"site-logo/editor-rtl.min.css\";i:442;s:20:\"site-logo/editor.css\";i:443;s:24:\"site-logo/editor.min.css\";i:444;s:23:\"site-logo/style-rtl.css\";i:445;s:27:\"site-logo/style-rtl.min.css\";i:446;s:19:\"site-logo/style.css\";i:447;s:23:\"site-logo/style.min.css\";i:448;s:27:\"site-tagline/editor-rtl.css\";i:449;s:31:\"site-tagline/editor-rtl.min.css\";i:450;s:23:\"site-tagline/editor.css\";i:451;s:27:\"site-tagline/editor.min.css\";i:452;s:26:\"site-tagline/style-rtl.css\";i:453;s:30:\"site-tagline/style-rtl.min.css\";i:454;s:22:\"site-tagline/style.css\";i:455;s:26:\"site-tagline/style.min.css\";i:456;s:25:\"site-title/editor-rtl.css\";i:457;s:29:\"site-title/editor-rtl.min.css\";i:458;s:21:\"site-title/editor.css\";i:459;s:25:\"site-title/editor.min.css\";i:460;s:24:\"site-title/style-rtl.css\";i:461;s:28:\"site-title/style-rtl.min.css\";i:462;s:20:\"site-title/style.css\";i:463;s:24:\"site-title/style.min.css\";i:464;s:26:\"social-link/editor-rtl.css\";i:465;s:30:\"social-link/editor-rtl.min.css\";i:466;s:22:\"social-link/editor.css\";i:467;s:26:\"social-link/editor.min.css\";i:468;s:27:\"social-links/editor-rtl.css\";i:469;s:31:\"social-links/editor-rtl.min.css\";i:470;s:23:\"social-links/editor.css\";i:471;s:27:\"social-links/editor.min.css\";i:472;s:26:\"social-links/style-rtl.css\";i:473;s:30:\"social-links/style-rtl.min.css\";i:474;s:22:\"social-links/style.css\";i:475;s:26:\"social-links/style.min.css\";i:476;s:21:\"spacer/editor-rtl.css\";i:477;s:25:\"spacer/editor-rtl.min.css\";i:478;s:17:\"spacer/editor.css\";i:479;s:21:\"spacer/editor.min.css\";i:480;s:20:\"spacer/style-rtl.css\";i:481;s:24:\"spacer/style-rtl.min.css\";i:482;s:16:\"spacer/style.css\";i:483;s:20:\"spacer/style.min.css\";i:484;s:20:\"table/editor-rtl.css\";i:485;s:24:\"table/editor-rtl.min.css\";i:486;s:16:\"table/editor.css\";i:487;s:20:\"table/editor.min.css\";i:488;s:19:\"table/style-rtl.css\";i:489;s:23:\"table/style-rtl.min.css\";i:490;s:15:\"table/style.css\";i:491;s:19:\"table/style.min.css\";i:492;s:19:\"table/theme-rtl.css\";i:493;s:23:\"table/theme-rtl.min.css\";i:494;s:15:\"table/theme.css\";i:495;s:19:\"table/theme.min.css\";i:496;s:24:\"tag-cloud/editor-rtl.css\";i:497;s:28:\"tag-cloud/editor-rtl.min.css\";i:498;s:20:\"tag-cloud/editor.css\";i:499;s:24:\"tag-cloud/editor.min.css\";i:500;s:23:\"tag-cloud/style-rtl.css\";i:501;s:27:\"tag-cloud/style-rtl.min.css\";i:502;s:19:\"tag-cloud/style.css\";i:503;s:23:\"tag-cloud/style.min.css\";i:504;s:28:\"template-part/editor-rtl.css\";i:505;s:32:\"template-part/editor-rtl.min.css\";i:506;s:24:\"template-part/editor.css\";i:507;s:28:\"template-part/editor.min.css\";i:508;s:27:\"template-part/theme-rtl.css\";i:509;s:31:\"template-part/theme-rtl.min.css\";i:510;s:23:\"template-part/theme.css\";i:511;s:27:\"template-part/theme.min.css\";i:512;s:30:\"term-description/style-rtl.css\";i:513;s:34:\"term-description/style-rtl.min.css\";i:514;s:26:\"term-description/style.css\";i:515;s:30:\"term-description/style.min.css\";i:516;s:27:\"text-columns/editor-rtl.css\";i:517;s:31:\"text-columns/editor-rtl.min.css\";i:518;s:23:\"text-columns/editor.css\";i:519;s:27:\"text-columns/editor.min.css\";i:520;s:26:\"text-columns/style-rtl.css\";i:521;s:30:\"text-columns/style-rtl.min.css\";i:522;s:22:\"text-columns/style.css\";i:523;s:26:\"text-columns/style.min.css\";i:524;s:19:\"verse/style-rtl.css\";i:525;s:23:\"verse/style-rtl.min.css\";i:526;s:15:\"verse/style.css\";i:527;s:19:\"verse/style.min.css\";i:528;s:20:\"video/editor-rtl.css\";i:529;s:24:\"video/editor-rtl.min.css\";i:530;s:16:\"video/editor.css\";i:531;s:20:\"video/editor.min.css\";i:532;s:19:\"video/style-rtl.css\";i:533;s:23:\"video/style-rtl.min.css\";i:534;s:15:\"video/style.css\";i:535;s:19:\"video/style.min.css\";i:536;s:19:\"video/theme-rtl.css\";i:537;s:23:\"video/theme-rtl.min.css\";i:538;s:15:\"video/theme.css\";i:539;s:19:\"video/theme.min.css\";}}','on'),
(124,'_transient_doing_cron','1792578180.5711829662322998046875','on'),
(125,'_site_transient_update_core','O:8:\"stdClass\":4:{s:7:\"updates\";a:6:{i:0;O:8:\"stdClass\":10:{s:8:\"response\";s:7:\"upgrade\";s:8:\"download\";s:59:\"https://downloads.wordpress.org/release/wordpress-7.1.3.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:59:\"https://downloads.wordpress.org/release/wordpress-7.1.3.zip\";s:10:\"no_content\";s:70:\"https://downloads.wordpress.org/release/wordpress-7.1.3-no-content.zip\";s:11:\"new_bundled\";s:71:\"https://downloads.wordpress.org/release/wordpress-7.1.3-new-bundled.zip\";s:7:\"partial\";s:0:\"\";s:8:\"rollback\";s:0:\"\";}s:7:\"current\";s:5:\"7.1.3\";s:7:\"version\";s:5:\"7.1.3\";s:11:\"php_version\";s:3:\"7.4\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:0:\"\";}i:1;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:51:\"https://downloads.w.org/release/wordpress-7.1.3.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:51:\"https://downloads.w.org/release/wordpress-7.1.3.zip\";s:10:\"no_content\";s:62:\"https://downloads.w.org/release/wordpress-7.1.3-no-content.zip\";s:11:\"new_bundled\";s:63:\"https://downloads.w.org/release/wordpress-7.1.3-new-bundled.zip\";s:7:\"partial\";s:0:\"\";s:8:\"rollback\";s:0:\"\";}s:7:\"current\";s:5:\"7.1.3\";s:7:\"version\";s:5:\"7.1.3\";s:11:\"php_version\";s:3:\"7.4\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:2;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:51:\"https://downloads.w.org/release/wordpress-7.0.7.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:51:\"https://downloads.w.org/release/wordpress-7.0.7.zip\";s:10:\"no_content\";s:62:\"https://downloads.w.org/release/wordpress-7.0.7-no-content.zip\";s:11:\"new_bundled\";s:63:\"https://downloads.w.org/release/wordpress-7.0.7-new-bundled.zip\";s:7:\"partial\";s:0:\"\";s:8:\"rollback\";s:0:\"\";}s:7:\"current\";s:5:\"7.0.7\";s:7:\"version\";s:5:\"7.0.7\";s:11:\"php_version\";s:3:\"7.4\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:3;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:52:\"https://downloads.w.org/release/wordpress-6.9.10.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:52:\"https://downloads.w.org/release/wordpress-6.9.10.zip\";s:10:\"no_content\";s:63:\"https://downloads.w.org/release/wordpress-6.9.10-no-content.zip\";s:11:\"new_bundled\";s:64:\"https://downloads.w.org/release/wordpress-6.9.10-new-bundled.zip\";s:7:\"partial\";s:0:\"\";s:8:\"rollback\";s:0:\"\";}s:7:\"current\";s:6:\"6.9.10\";s:7:\"version\";s:6:\"6.9.10\";s:11:\"php_version\";s:6:\"7.2.24\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:4;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:52:\"https://downloads.w.org/release/wordpress-6.8.11.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:52:\"https://downloads.w.org/release/wordpress-6.8.11.zip\";s:10:\"no_content\";s:63:\"https://downloads.w.org/release/wordpress-6.8.11-no-content.zip\";s:11:\"new_bundled\";s:64:\"https://downloads.w.org/release/wordpress-6.8.11-new-bundled.zip\";s:7:\"partial\";s:0:\"\";s:8:\"rollback\";s:0:\"\";}s:7:\"current\";s:6:\"6.8.11\";s:7:\"version\";s:6:\"6.8.11\";s:11:\"php_version\";s:6:\"7.2.24\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:0:\"\";s:9:\"new_files\";s:1:\"1\";}i:5;O:8:\"stdClass\":11:{s:8:\"response\";s:10:\"autoupdate\";s:8:\"download\";s:52:\"https://downloads.w.org/release/wordpress-6.7.10.zip\";s:6:\"locale\";s:5:\"en_US\";s:8:\"packages\";O:8:\"stdClass\":5:{s:4:\"full\";s:52:\"https://downloads.w.org/release/wordpress-6.7.10.zip\";s:10:\"no_content\";s:63:\"https://downloads.w.org/release/wordpress-6.7.10-no-content.zip\";s:11:\"new_bundled\";s:64:\"https://downloads.w.org/release/wordpress-6.7.10-new-bundled.zip\";s:7:\"partial\";s:62:\"https://downloads.w.org/release/wordpress-6.7.10-partial-2.zip\";s:8:\"rollback\";s:63:\"https://downloads.w.org/release/wordpress-6.7.10-rollback-2.zip\";}s:7:\"current\";s:6:\"6.7.10\";s:7:\"version\";s:6:\"6.7.10\";s:11:\"php_version\";s:6:\"7.2.24\";s:13:\"mysql_version\";s:5:\"5.5.5\";s:11:\"new_bundled\";s:3:\"6.7\";s:15:\"partial_version\";s:5:\"6.7.2\";s:9:\"new_files\";s:0:\"\";}}s:12:\"last_checked\";i:1792321299;s:15:\"version_checked\";s:5:\"6.7.2\";s:12:\"translations\";a:0:{}}','off'),
(130,'action_scheduler_hybrid_store_demarkation','4','auto'),
(131,'schema-ActionScheduler_StoreSchema','7.0.1792309993','auto'),
(132,'schema-ActionScheduler_LoggerSchema','3.0.1792309993','auto'),
(137,'woocommerce_newly_installed','yes','auto'),
(138,'woocommerce_schema_version','920','auto'),
(139,'woocommerce_store_address','','on'),
(140,'woocommerce_store_address_2','','on'),
(141,'woocommerce_store_city','','on'),
(142,'woocommerce_default_country','US:CA','on'),
(143,'woocommerce_store_postcode','','on'),
(144,'woocommerce_allowed_countries','all','on'),
(145,'woocommerce_all_except_countries','','on'),
(146,'woocommerce_specific_allowed_countries','','on'),
(147,'woocommerce_ship_to_countries','','on'),
(148,'woocommerce_specific_ship_to_countries','','on'),
(149,'woocommerce_default_customer_address','base','on'),
(150,'woocommerce_calc_taxes','no','on'),
(151,'woocommerce_enable_coupons','yes','on'),
(152,'woocommerce_calc_discounts_sequentially','no','off'),
(153,'woocommerce_currency','USD','on'),
(154,'woocommerce_currency_pos','left','on'),
(155,'woocommerce_price_thousand_sep',',','on'),
(156,'woocommerce_price_decimal_sep','.','on'),
(157,'woocommerce_price_num_decimals','2','on'),
(158,'woocommerce_shop_page_id','5','on'),
(159,'woocommerce_cart_redirect_after_add','no','on'),
(160,'woocommerce_enable_ajax_add_to_cart','yes','on'),
(161,'woocommerce_placeholder_image','4','on'),
(162,'woocommerce_weight_unit','kg','on'),
(163,'woocommerce_dimension_unit','cm','on'),
(164,'woocommerce_enable_reviews','yes','on'),
(165,'woocommerce_review_rating_verification_label','yes','off'),
(166,'woocommerce_review_rating_verification_required','no','off'),
(167,'woocommerce_enable_review_rating','yes','on'),
(168,'woocommerce_review_rating_required','yes','off'),
(169,'woocommerce_manage_stock','yes','on'),
(170,'woocommerce_hold_stock_minutes','60','off'),
(171,'woocommerce_notify_low_stock','yes','off'),
(172,'woocommerce_notify_no_stock','yes','off'),
(173,'woocommerce_stock_email_recipient','admin@urumi.local','off'),
(174,'woocommerce_notify_low_stock_amount','2','off'),
(175,'woocommerce_notify_no_stock_amount','0','on'),
(176,'woocommerce_hide_out_of_stock_items','no','on'),
(177,'woocommerce_stock_format','','on'),
(178,'woocommerce_file_download_method','force','off'),
(179,'woocommerce_downloads_redirect_fallback_allowed','no','off'),
(180,'woocommerce_downloads_require_login','no','off'),
(181,'woocommerce_downloads_grant_access_after_payment','yes','off'),
(182,'woocommerce_downloads_deliver_inline','','off'),
(183,'woocommerce_downloads_add_hash_to_filename','yes','on'),
(184,'woocommerce_downloads_count_partial','yes','on'),
(186,'woocommerce_attribute_lookup_direct_updates','no','on'),
(187,'woocommerce_attribute_lookup_optimized_updates','no','on'),
(188,'woocommerce_product_match_featured_image_by_sku','no','on'),
(189,'woocommerce_prices_include_tax','no','on'),
(190,'woocommerce_tax_based_on','shipping','on'),
(191,'woocommerce_shipping_tax_class','inherit','on'),
(192,'woocommerce_tax_round_at_subtotal','no','on'),
(193,'woocommerce_tax_classes','','on'),
(194,'woocommerce_tax_display_shop','excl','on'),
(195,'woocommerce_tax_display_cart','excl','on'),
(196,'woocommerce_price_display_suffix','','on'),
(197,'woocommerce_tax_total_display','itemized','off'),
(198,'woocommerce_enable_shipping_calc','yes','off'),
(199,'woocommerce_shipping_cost_requires_address','no','on'),
(200,'woocommerce_ship_to_destination','billing','off'),
(201,'woocommerce_shipping_debug_mode','no','on'),
(202,'woocommerce_enable_guest_checkout','yes','off'),
(203,'woocommerce_enable_checkout_login_reminder','no','off'),
(204,'woocommerce_enable_signup_and_login_from_checkout','no','off'),
(205,'woocommerce_enable_myaccount_registration','no','off'),
(206,'woocommerce_registration_generate_username','yes','off'),
(207,'woocommerce_registration_generate_password','yes','off'),
(208,'woocommerce_erasure_request_removes_order_data','no','off'),
(209,'woocommerce_erasure_request_removes_download_data','no','off'),
(210,'woocommerce_allow_bulk_remove_personal_data','no','off'),
(211,'woocommerce_registration_privacy_policy_text','Your personal data will be used to support your experience throughout this website, to manage access to your account, and for other purposes described in our [privacy_policy].','on'),
(212,'woocommerce_checkout_privacy_policy_text','Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our [privacy_policy].','on'),
(213,'woocommerce_delete_inactive_accounts','a:2:{s:6:\"number\";s:0:\"\";s:4:\"unit\";s:6:\"months\";}','off'),
(214,'woocommerce_trash_pending_orders','','off'),
(215,'woocommerce_trash_failed_orders','','off'),
(216,'woocommerce_trash_cancelled_orders','','off'),
(217,'woocommerce_anonymize_completed_orders','a:2:{s:6:\"number\";s:0:\"\";s:4:\"unit\";s:6:\"months\";}','off'),
(218,'woocommerce_email_from_name','Urumi Store','off'),
(219,'woocommerce_email_from_address','admin@urumi.local','off'),
(220,'woocommerce_email_header_image','','off'),
(221,'woocommerce_email_base_color','#7f54b3','off'),
(222,'woocommerce_email_background_color','#f7f7f7','off'),
(223,'woocommerce_email_body_background_color','#ffffff','off'),
(224,'woocommerce_email_text_color','#3c3c3c','off'),
(225,'woocommerce_email_footer_text','{site_title} &mdash; Built with {WooCommerce}','off'),
(226,'woocommerce_email_footer_text_color','#3c3c3c','off'),
(227,'woocommerce_merchant_email_notifications','no','off'),
(228,'woocommerce_cart_page_id','6','off'),
(229,'woocommerce_checkout_page_id','7','off'),
(230,'woocommerce_myaccount_page_id','8','off'),
(231,'woocommerce_terms_page_id','','off'),
(232,'woocommerce_force_ssl_checkout','no','on'),
(233,'woocommerce_unforce_ssl_checkout','no','on'),
(234,'woocommerce_checkout_pay_endpoint','order-pay','on'),
(235,'woocommerce_checkout_order_received_endpoint','order-received','on'),
(236,'woocommerce_myaccount_add_payment_method_endpoint','add-payment-method','on'),
(237,'woocommerce_myaccount_delete_payment_method_endpoint','delete-payment-method','on'),
(238,'woocommerce_myaccount_set_default_payment_method_endpoint','set-default-payment-method','on'),
(239,'woocommerce_myaccount_orders_endpoint','orders','on'),
(240,'woocommerce_myaccount_view_order_endpoint','view-order','on'),
(241,'woocommerce_myaccount_downloads_endpoint','downloads','on'),
(242,'woocommerce_myaccount_edit_account_endpoint','edit-account','on'),
(243,'woocommerce_myaccount_edit_address_endpoint','edit-address','on'),
(244,'woocommerce_myaccount_payment_methods_endpoint','payment-methods','on'),
(245,'woocommerce_myaccount_lost_password_endpoint','lost-password','on'),
(246,'woocommerce_logout_endpoint','customer-logout','on'),
(247,'woocommerce_api_enabled','no','on'),
(248,'woocommerce_allow_tracking','no','off'),
(249,'woocommerce_show_marketplace_suggestions','yes','off'),
(250,'woocommerce_custom_orders_table_enabled','no','on'),
(251,'woocommerce_analytics_enabled','yes','on'),
(252,'woocommerce_feature_order_attribution_enabled','yes','on'),
(253,'woocommerce_feature_product_block_editor_enabled','no','on'),
(254,'woocommerce_hpos_fts_index_enabled','no','on'),
(255,'woocommerce_single_image_width','600','on'),
(256,'woocommerce_thumbnail_image_width','300','on'),
(257,'woocommerce_checkout_highlight_required_fields','yes','on'),
(258,'woocommerce_demo_store','no','off'),
(259,'wc_downloads_approved_directories_mode','enabled','auto'),
(260,'woocommerce_permalinks','a:5:{s:12:\"product_base\";s:7:\"product\";s:13:\"category_base\";s:16:\"product-category\";s:8:\"tag_base\";s:11:\"product-tag\";s:14:\"attribute_base\";s:0:\"\";s:22:\"use_verbose_page_rules\";b:0;}','auto'),
(261,'current_theme_supports_woocommerce','yes','auto'),
(262,'woocommerce_queue_flush_rewrite_rules','no','auto'),
(263,'_transient_wc_attribute_taxonomies','a:0:{}','on'),
(266,'product_cat_children','a:0:{}','auto'),
(267,'default_product_cat','15','auto'),
(268,'woocommerce_refund_returns_page_created','9','off'),
(269,'woocommerce_refund_returns_page_id','9','auto'),
(270,'_transient_timeout__wc_activation_redirect','1792310027','off'),
(271,'_transient__wc_activation_redirect','1','off'),
(272,'woocommerce_paypal_settings','a:23:{s:7:\"enabled\";s:2:\"no\";s:5:\"title\";s:6:\"PayPal\";s:11:\"description\";s:85:\"Pay via PayPal; you can pay with your credit card if you don\'t have a PayPal account.\";s:5:\"email\";s:17:\"admin@urumi.local\";s:8:\"advanced\";s:0:\"\";s:8:\"testmode\";s:2:\"no\";s:5:\"debug\";s:2:\"no\";s:16:\"ipn_notification\";s:3:\"yes\";s:14:\"receiver_email\";s:17:\"admin@urumi.local\";s:14:\"identity_token\";s:0:\"\";s:14:\"invoice_prefix\";s:3:\"WC-\";s:13:\"send_shipping\";s:3:\"yes\";s:16:\"address_override\";s:2:\"no\";s:13:\"paymentaction\";s:4:\"sale\";s:9:\"image_url\";s:0:\"\";s:11:\"api_details\";s:0:\"\";s:12:\"api_username\";s:0:\"\";s:12:\"api_password\";s:0:\"\";s:13:\"api_signature\";s:0:\"\";s:20:\"sandbox_api_username\";s:0:\"\";s:20:\"sandbox_api_password\";s:0:\"\";s:21:\"sandbox_api_signature\";s:0:\"\";s:12:\"_should_load\";s:2:\"no\";}','on'),
(273,'woocommerce_version','9.3.3','auto'),
(274,'woocommerce_db_version','9.3.3','auto'),
(275,'woocommerce_store_id','42498b1b-d380-41a0-98e0-d735f6941938','auto'),
(276,'woocommerce_admin_install_timestamp','1792309997','auto'),
(277,'woocommerce_inbox_variant_assignment','6','auto'),
(278,'woocommerce_remote_variant_assignment','116','auto'),
(279,'woocommerce_attribute_lookup_enabled','no','auto'),
(280,'_transient_timeout__woocommerce_upload_directory_status','1792396397','off'),
(281,'_transient__woocommerce_upload_directory_status','protected','off'),
(283,'_transient_jetpack_autoloader_plugin_paths','a:1:{i:0;s:29:\"{{WP_PLUGIN_DIR}}/woocommerce\";}','on'),
(284,'woocommerce_admin_notices','a:2:{i:0;s:20:\"no_secure_connection\";i:1;s:14:\"template_files\";}','auto'),
(285,'wc_blocks_version','11.8.0-dev','auto'),
(287,'woocommerce_maxmind_geolocation_settings','a:1:{s:15:\"database_prefix\";s:32:\"uZCLkr3vTPyiPLANVxp6PuyhGHVmFiPF\";}','on'),
(289,'_transient_woocommerce_webhook_ids_status_active','a:0:{}','on'),
(291,'widget_woocommerce_widget_cart','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(292,'widget_woocommerce_layered_nav_filters','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(293,'widget_woocommerce_layered_nav','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(295,'widget_woocommerce_price_filter','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(296,'widget_woocommerce_product_categories','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(297,'widget_woocommerce_product_search','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(298,'widget_woocommerce_product_tag_cloud','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(299,'widget_woocommerce_products','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(300,'widget_woocommerce_recently_viewed_products','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(301,'widget_woocommerce_top_rated_products','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(302,'widget_woocommerce_recent_reviews','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(303,'widget_woocommerce_rating_filter','a:1:{s:12:\"_multiwidget\";i:1;}','auto'),
(304,'_transient_timeout_woocommerce_blocks_asset_api_script_data','1795170205','off'),
(305,'_transient_woocommerce_blocks_asset_api_script_data','{\"script_data\":{\"assets\\/client\\/blocks\\/wc-settings.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-settings.js\",\"version\":\"eb5ac71a827c4c81fed8\",\"dependencies\":[\"wp-hooks\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-types.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-types.js\",\"version\":\"bda84b1be3361607d04a\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-middleware.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-middleware.js\",\"version\":\"ca04183222edaf8a26be\",\"dependencies\":[\"wp-api-fetch\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-data.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-data.js\",\"version\":\"314d18d8fe63fcbe6cb6\",\"dependencies\":[\"wc-blocks-registry\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-data\",\"wp-data-controls\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-notices\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/wc-blocks-vendors.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-vendors.js\",\"version\":\"9c64b2fb6cec317e1770\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-registry.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-registry.js\",\"version\":\"8c83b2b8521a19ab00b9\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks.js\",\"version\":\"93db775143f168c26ac3\",\"dependencies\":[\"react\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-dom-ready\",\"wp-element\",\"wp-hooks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/wc-blocks-shared-context.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-shared-context.js\",\"version\":\"6eb6865831aa5a75475d\",\"dependencies\":[\"react\",\"wp-element\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-shared-hocs.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-shared-hocs.js\",\"version\":\"4f21a9f43ea5bfa7f02e\",\"dependencies\":[\"react\",\"wc-blocks-data-store\",\"wc-blocks-shared-context\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-is-shallow-equal\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/price-format.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-format.js\",\"version\":\"483d2180eda1f53dc60d\",\"dependencies\":[\"wc-settings\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-frontend-vendors-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-frontend-vendors-frontend.js\",\"version\":\"651d3d70da2d2aef0e82\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-cart-checkout-vendors-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-cart-checkout-vendors-frontend.js\",\"version\":\"4ef596e6634f89ac412f\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-cart-checkout-base-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-cart-checkout-base-frontend.js\",\"version\":\"7657f2f92845b59d4dce\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/blocks-checkout.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/blocks-checkout.js\",\"version\":\"b17cecfe19e23a3899e0\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"react-dom\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/blocks-components.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/blocks-components.js\",\"version\":\"5f11d5c440e62fef7bb5\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"react-dom\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/wc-interactivity-dropdown.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-interactivity-dropdown.js\",\"version\":\"8997b5406dcf18064a4e\",\"dependencies\":[\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-interactivity-checkbox-list.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-interactivity-checkbox-list.js\",\"version\":\"9f910c57a575d29e7f8e\",\"dependencies\":[\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/active-filters.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/active-filters.js\",\"version\":\"e12366c8a56976baed98\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/active-filters-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/active-filters-frontend.js\",\"version\":\"6c48702f58c24bb97f66\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/all-products.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-products.js\",\"version\":\"c265f87ec00d2ff78c66\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/all-products-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-products-frontend.js\",\"version\":\"d3b2da0916f9d8584854\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/all-reviews.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-reviews.js\",\"version\":\"a268036043addd4c5acc\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-escape-html\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/reviews-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-frontend.js\",\"version\":\"403abda05b51a9c06a58\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-a11y\",\"wp-api-fetch\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/attribute-filter.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/attribute-filter.js\",\"version\":\"405769a6c85a0db90cb2\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/attribute-filter-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/attribute-filter-frontend.js\",\"version\":\"61292cafbcfbb0d769e5\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/breadcrumbs.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/breadcrumbs.js\",\"version\":\"a46bdf27ac23bce673ff\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/catalog-sorting.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/catalog-sorting.js\",\"version\":\"46e9a6788747bd1dda73\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/legacy-template.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/legacy-template.js\",\"version\":\"088e05230c1ace46bf83\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-core-data\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-notices\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/classic-shortcode.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/classic-shortcode.js\",\"version\":\"95c41fae930c5aee4110\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-notices\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/coming-soon.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/coming-soon.js\",\"version\":\"07a53f0414db8dad75ac\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-i18n\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/customer-account.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/customer-account.js\",\"version\":\"0c8a286658fcb3e8546f\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/featured-category.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/featured-category.js\",\"version\":\"35f416bff0fb93387cb5\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\"]},\"assets\\/client\\/blocks\\/featured-product.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/featured-product.js\",\"version\":\"369c309dc8e90c3b0d77\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\"]},\"assets\\/client\\/blocks\\/filter-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filter-wrapper.js\",\"version\":\"236ba7d7e783ccbcc380\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/filter-wrapper-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filter-wrapper-frontend.js\",\"version\":\"78dc7015ab2dbf31804b\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/handpicked-products.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/handpicked-products.js\",\"version\":\"396c61722655a19c4f3e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/mini-cart.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart.js\",\"version\":\"7f6c34f992ce0e29a1dc\",\"dependencies\":[\"react\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/mini-cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-frontend.js\",\"version\":\"de93ee7eb69dd39340fa\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-i18n\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/store-notices.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/store-notices.js\",\"version\":\"3a69b4a56afb4e333ca1\",\"dependencies\":[\"react\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-deprecated\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/price-filter.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-filter.js\",\"version\":\"7541325c9e902d96c999\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/price-filter-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-filter-frontend.js\",\"version\":\"cc8ce5fb09220bc02314\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-best-sellers.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-best-sellers.js\",\"version\":\"f02a435ca101ac93f7d8\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-button.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-button.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-button-interactivity-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-button-interactivity-frontend.js\",\"version\":\"cb28f5957f4ece0c48e5\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-data-store\",\"wc-interactivity\",\"wp-a11y\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-categories.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-categories.js\",\"version\":\"6551614b46b75a8fe22d\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\"]},\"assets\\/client\\/blocks\\/product-category.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-category.js\",\"version\":\"eec2cb1659cb15dcbcf7\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-collection.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection.js\",\"version\":\"0242bb55e9a23df3afc1\",\"dependencies\":[\"react\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-editor\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-collection-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection-frontend.js\",\"version\":\"8ffa3332186207691feb\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-collection-no-results.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection-no-results.js\",\"version\":\"d1c4e65a98c9f79e8930\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-gallery.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery.js\",\"version\":\"c6c5acf8484d242125cf\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-gallery-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-frontend.js\",\"version\":\"c340254c6c31444370fb\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-gallery-large-image.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-large-image.js\",\"version\":\"9123fa40c2900c7ffff5\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-gallery-large-image-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-large-image-frontend.js\",\"version\":\"dd8201c48d0f0223ee5a\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-new.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-new.js\",\"version\":\"e02c41db87762f2a864e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-on-sale.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-on-sale.js\",\"version\":\"d2a18f8f5a99b5ae9fcd\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-template.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-template.js\",\"version\":\"fb1199bb22c9b94e41a4\",\"dependencies\":[\"react\",\"wc-blocks-shared-context\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-query.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-query.js\",\"version\":\"8231456d3b3054d4f5d2\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-query-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-query-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-results-count.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-results-count.js\",\"version\":\"f67c632c9c0ac6a63903\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-search.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-search.js\",\"version\":\"241a15bb8d9fb8afcd93\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-summary.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-summary.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-tag.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-tag.js\",\"version\":\"e5ceb3330a4d33c1d80c\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-title.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-title.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-title-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-title-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-top-rated.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-top-rated.js\",\"version\":\"76b1dfaa394469f53991\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/products-by-attribute.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/products-by-attribute.js\",\"version\":\"d8168d1e219afd197673\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/rating-filter.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/rating-filter.js\",\"version\":\"428e74db07d18b6a6c49\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/reviews-by-category.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-by-category.js\",\"version\":\"36d94e215bcc22086f05\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/reviews-by-product.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-by-product.js\",\"version\":\"709a17af900e478ee790\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/single-product.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/single-product.js\",\"version\":\"05193999e0f40595cd8e\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-store-data\",\"wc-types\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/stock-filter.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/stock-filter.js\",\"version\":\"cbb3c58e66888f68e4a7\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/stock-filter-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/stock-filter-frontend.js\",\"version\":\"61da2cb317321e6acc8f\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/page-content-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/page-content-wrapper.js\",\"version\":\"1fd399fa754701bea190\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-status.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-status.js\",\"version\":\"8c9f3a518172327f48a0\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-summary.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-summary.js\",\"version\":\"259daa9a9e302be8a04e\",\"dependencies\":[\"react\",\"wc-price-format\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-date\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-totals.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-totals.js\",\"version\":\"fb4b9c0d40f2d07e0c28\",\"dependencies\":[\"react\",\"wc-price-format\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-totals-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-totals-wrapper.js\",\"version\":\"e2cc2a4e02c46a322434\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-downloads.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-downloads.js\",\"version\":\"26fdedbc1f1b13554ad4\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-downloads-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-downloads-wrapper.js\",\"version\":\"9077b93bf8ff5dc4371e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-billing-address.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-billing-address.js\",\"version\":\"87d59d30fc3b79a280ec\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-shipping-address.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-shipping-address.js\",\"version\":\"3a24afe202ccabf9fd44\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-billing-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-billing-wrapper.js\",\"version\":\"99dbc2cfeb1472282ed4\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-shipping-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-shipping-wrapper.js\",\"version\":\"f68c7a9bfa980dd916fd\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-information.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-information.js\",\"version\":\"21bdd0df3ab78b31e12b\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-fields-wrapper.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-fields-wrapper.js\",\"version\":\"0d2e059d88ef29bca236\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-fields.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-fields.js\",\"version\":\"3d34c07f1650322267f0\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/cart.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart.js\",\"version\":\"6e9fbe4dce866df70b6f\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-editor\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-notices\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-frontend.js\",\"version\":\"f10b598c943a06f25d98\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-items-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-items-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-taxes-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-taxes-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-subtotal-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-subtotal-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-totals-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/filled-cart-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filled-cart-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/empty-cart-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/empty-cart-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-totals-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-items-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-line-items-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-line-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-express-payment-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-express-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/proceed-to-checkout-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/proceed-to-checkout-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-accepted-payment-methods-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-accepted-payment-methods-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-coupon-form-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-coupon-form-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-discount-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-discount-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-fee-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-fee-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-heading-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-heading-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-shipping-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-shipping-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-cross-sells-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-cross-sells-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-cross-sells-products-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-cross-sells-products-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout.js\",\"version\":\"96e1e6e0f4fe470f91fa\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-editor\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-notices\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/checkout-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-frontend.js\",\"version\":\"e140f38159dfa7beb30e\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/actions-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/actions-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/fields-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/fields-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/totals-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/actions-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/actions-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/payment-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/payment-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/express-payment-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-note-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-note-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/terms-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/terms-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/payment-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/totals-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/terms-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/terms-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/fields-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/fields-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment--checkout-blocks\\/express-payment-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment--checkout-blocks\\/express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-actions-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-actions-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-additional-information-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-additional-information-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-billing-address-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-billing-address-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-contact-information-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-contact-information-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-express-payment-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-express-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-fields-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-fields-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-note-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-note-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-cart-items-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-coupon-form-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-coupon-form-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-discount-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-discount-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-fee-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-fee-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-shipping-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-shipping-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-subtotal-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-subtotal-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-taxes-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-taxes-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-totals-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-payment-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-address-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-address-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-methods-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-methods-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-method-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-method-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-pickup-options-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-pickup-options-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-terms-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-terms-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-totals-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents.js\",\"version\":\"0d14f879bb931ec28d02\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/empty-mini-cart-contents-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/empty-mini-cart-contents-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/filled-mini-cart-contents-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filled-mini-cart-contents-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-footer-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-footer-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-items-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-products-table-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-products-table-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-shopping-button-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-shopping-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-cart-button-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-cart-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-checkout-button-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-checkout-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-items-counter-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-items-counter-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-label-block.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-label-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-component-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-component-frontend.js\",\"version\":\"94a847b96873f9cc6d69\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/products-table-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/products-table-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-style.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items--mini-cart-contents-block\\/products-table-frontend.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items--mini-cart-contents-block\\/products-table-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/wc-payment-method-cod.js\":{\"src\":\"http:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-payment-method-cod.js\",\"version\":\"5f402826b33bac8f9e43\",\"dependencies\":[\"react\",\"wc-blocks-registry\",\"wc-settings\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\"]}},\"version\":\"wc-9.3.3\",\"hash\":\"ece36231608b111b2d532b419df04fcb\"}','off'),
(310,'_site_transient_update_plugins','O:8:\"stdClass\":4:{s:12:\"last_checked\";i:1792321299;s:8:\"response\";a:1:{s:19:\"akismet/akismet.php\";O:8:\"stdClass\":13:{s:2:\"id\";s:21:\"w.org/plugins/akismet\";s:4:\"slug\";s:7:\"akismet\";s:6:\"plugin\";s:19:\"akismet/akismet.php\";s:11:\"new_version\";s:5:\"5.7.2\";s:3:\"url\";s:38:\"https://wordpress.org/plugins/akismet/\";s:7:\"package\";s:56:\"https://downloads.wordpress.org/plugin/akismet.5.7.2.zip\";s:5:\"icons\";a:2:{s:2:\"2x\";s:60:\"https://ps.w.org/akismet/assets/icon-256x256.png?rev=2818463\";s:2:\"1x\";s:60:\"https://ps.w.org/akismet/assets/icon-128x128.png?rev=2818463\";}s:7:\"banners\";a:2:{s:2:\"2x\";s:63:\"https://ps.w.org/akismet/assets/banner-1544x500.png?rev=2900731\";s:2:\"1x\";s:62:\"https://ps.w.org/akismet/assets/banner-772x250.png?rev=2900731\";}s:11:\"banners_rtl\";a:0:{}s:8:\"requires\";s:3:\"5.8\";s:6:\"tested\";s:5:\"7.1.3\";s:12:\"requires_php\";s:3:\"7.2\";s:16:\"requires_plugins\";a:0:{}}}s:12:\"translations\";a:0:{}s:9:\"no_update\";a:2:{s:9:\"hello.php\";O:8:\"stdClass\":10:{s:2:\"id\";s:25:\"w.org/plugins/hello-dolly\";s:4:\"slug\";s:11:\"hello-dolly\";s:6:\"plugin\";s:9:\"hello.php\";s:11:\"new_version\";s:5:\"1.7.2\";s:3:\"url\";s:42:\"https://wordpress.org/plugins/hello-dolly/\";s:7:\"package\";s:60:\"https://downloads.wordpress.org/plugin/hello-dolly.1.7.2.zip\";s:5:\"icons\";a:2:{s:2:\"2x\";s:64:\"https://ps.w.org/hello-dolly/assets/icon-256x256.jpg?rev=2052855\";s:2:\"1x\";s:64:\"https://ps.w.org/hello-dolly/assets/icon-128x128.jpg?rev=2052855\";}s:7:\"banners\";a:2:{s:2:\"2x\";s:67:\"https://ps.w.org/hello-dolly/assets/banner-1544x500.jpg?rev=2645582\";s:2:\"1x\";s:66:\"https://ps.w.org/hello-dolly/assets/banner-772x250.jpg?rev=2052855\";}s:11:\"banners_rtl\";a:0:{}s:8:\"requires\";s:3:\"4.6\";}s:27:\"woocommerce/woocommerce.php\";O:8:\"stdClass\":13:{s:2:\"id\";s:25:\"w.org/plugins/woocommerce\";s:4:\"slug\";s:11:\"woocommerce\";s:6:\"plugin\";s:27:\"woocommerce/woocommerce.php\";s:11:\"new_version\";s:6:\"11.2.1\";s:3:\"url\";s:42:\"https://wordpress.org/plugins/woocommerce/\";s:7:\"package\";s:61:\"https://downloads.wordpress.org/plugin/woocommerce.11.2.1.zip\";s:5:\"icons\";a:2:{s:2:\"1x\";s:56:\"https://ps.w.org/woocommerce/assets/icon.svg?rev=3640790\";s:3:\"svg\";s:56:\"https://ps.w.org/woocommerce/assets/icon.svg?rev=3640790\";}s:7:\"banners\";a:2:{s:2:\"2x\";s:67:\"https://ps.w.org/woocommerce/assets/banner-1544x500.png?rev=3640790\";s:2:\"1x\";s:66:\"https://ps.w.org/woocommerce/assets/banner-772x250.png?rev=3640790\";}s:11:\"banners_rtl\";a:0:{}s:8:\"requires\";s:3:\"7.0\";s:6:\"tested\";s:5:\"7.1.3\";s:12:\"requires_php\";s:3:\"7.4\";s:16:\"requires_plugins\";a:0:{}}}}','off'),
(311,'woocommerce_cod_settings','a:6:{s:7:\"enabled\";s:3:\"yes\";s:5:\"title\";s:16:\"Cash on delivery\";s:11:\"description\";s:28:\"Pay with cash upon delivery.\";s:12:\"instructions\";s:28:\"Pay with cash upon delivery.\";s:18:\"enable_for_methods\";a:0:{}s:18:\"enable_for_virtual\";s:3:\"yes\";}','auto'),
(312,'_transient_product_query-transient-version','1792507055','on'),
(317,'_transient_product-transient-version','1792507055','on'),
(334,'_transient_orders-transient-version','1792425886','on'),
(343,'theme_mods_twentytwentyfive','a:2:{s:18:\"custom_css_post_id\";i:-1;s:16:\"sidebars_widgets\";a:2:{s:4:\"time\";i:1792321300;s:4:\"data\";a:3:{s:19:\"wp_inactive_widgets\";a:0:{}s:9:\"sidebar-1\";a:3:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";}s:9:\"sidebar-2\";a:2:{i:0;s:7:\"block-5\";i:1;s:7:\"block-6\";}}}}','off'),
(344,'_transient_wp_styles_for_blocks','a:2:{s:4:\"hash\";s:32:\"07bc1b20f0ef2029a10e68cd12067ca6\";s:6:\"blocks\";a:5:{s:11:\"core/button\";s:0:\"\";s:14:\"core/site-logo\";s:0:\"\";s:18:\"core/post-template\";s:0:\"\";s:12:\"core/columns\";s:0:\"\";s:14:\"core/pullquote\";s:69:\":root :where(.wp-block-pullquote){font-size: 1.5em;line-height: 1.6;}\";}}','on'),
(355,'_transient_timeout_woocommerce_blocks_asset_api_script_data_ssl','1795167549','off'),
(356,'_transient_woocommerce_blocks_asset_api_script_data_ssl','{\"script_data\":{\"assets\\/client\\/blocks\\/wc-settings.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-settings.js\",\"version\":\"eb5ac71a827c4c81fed8\",\"dependencies\":[\"wp-hooks\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/active-filters.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/active-filters.js\",\"version\":\"e12366c8a56976baed98\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/active-filters-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/active-filters-frontend.js\",\"version\":\"6c48702f58c24bb97f66\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/all-products.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-products.js\",\"version\":\"c265f87ec00d2ff78c66\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/all-products-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-products-frontend.js\",\"version\":\"d3b2da0916f9d8584854\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/all-reviews.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/all-reviews.js\",\"version\":\"a268036043addd4c5acc\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-escape-html\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/reviews-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-frontend.js\",\"version\":\"403abda05b51a9c06a58\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-a11y\",\"wp-api-fetch\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/attribute-filter.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/attribute-filter.js\",\"version\":\"405769a6c85a0db90cb2\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/attribute-filter-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/attribute-filter-frontend.js\",\"version\":\"61292cafbcfbb0d769e5\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/breadcrumbs.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/breadcrumbs.js\",\"version\":\"a46bdf27ac23bce673ff\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/catalog-sorting.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/catalog-sorting.js\",\"version\":\"46e9a6788747bd1dda73\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/legacy-template.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/legacy-template.js\",\"version\":\"088e05230c1ace46bf83\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-core-data\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-notices\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/classic-shortcode.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/classic-shortcode.js\",\"version\":\"95c41fae930c5aee4110\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-notices\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/coming-soon.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/coming-soon.js\",\"version\":\"07a53f0414db8dad75ac\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-i18n\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/customer-account.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/customer-account.js\",\"version\":\"0c8a286658fcb3e8546f\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/featured-category.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/featured-category.js\",\"version\":\"35f416bff0fb93387cb5\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\"]},\"assets\\/client\\/blocks\\/featured-product.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/featured-product.js\",\"version\":\"369c309dc8e90c3b0d77\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\"]},\"assets\\/client\\/blocks\\/filter-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filter-wrapper.js\",\"version\":\"236ba7d7e783ccbcc380\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/filter-wrapper-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filter-wrapper-frontend.js\",\"version\":\"78dc7015ab2dbf31804b\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/handpicked-products.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/handpicked-products.js\",\"version\":\"396c61722655a19c4f3e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/mini-cart.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart.js\",\"version\":\"7f6c34f992ce0e29a1dc\",\"dependencies\":[\"react\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/mini-cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-frontend.js\",\"version\":\"de93ee7eb69dd39340fa\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-i18n\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/store-notices.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/store-notices.js\",\"version\":\"3a69b4a56afb4e333ca1\",\"dependencies\":[\"react\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-deprecated\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/price-filter.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-filter.js\",\"version\":\"7541325c9e902d96c999\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/price-filter-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-filter-frontend.js\",\"version\":\"cc8ce5fb09220bc02314\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-best-sellers.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-best-sellers.js\",\"version\":\"f02a435ca101ac93f7d8\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-button.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-button.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-button-interactivity-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-button-interactivity-frontend.js\",\"version\":\"cb28f5957f4ece0c48e5\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"react\",\"wc-blocks-data-store\",\"wc-interactivity\",\"wp-a11y\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-categories.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-categories.js\",\"version\":\"6551614b46b75a8fe22d\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\"]},\"assets\\/client\\/blocks\\/product-category.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-category.js\",\"version\":\"eec2cb1659cb15dcbcf7\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-collection.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection.js\",\"version\":\"0242bb55e9a23df3afc1\",\"dependencies\":[\"react\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-editor\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-collection-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection-frontend.js\",\"version\":\"8ffa3332186207691feb\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-collection-no-results.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-collection-no-results.js\",\"version\":\"d1c4e65a98c9f79e8930\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-gallery.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery.js\",\"version\":\"c6c5acf8484d242125cf\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-gallery-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-frontend.js\",\"version\":\"c340254c6c31444370fb\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-gallery-large-image.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-large-image.js\",\"version\":\"9123fa40c2900c7ffff5\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-gallery-large-image-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-gallery-large-image-frontend.js\",\"version\":\"dd8201c48d0f0223ee5a\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/product-new.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-new.js\",\"version\":\"e02c41db87762f2a864e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-on-sale.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-on-sale.js\",\"version\":\"d2a18f8f5a99b5ae9fcd\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-template.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-template.js\",\"version\":\"fb1199bb22c9b94e41a4\",\"dependencies\":[\"react\",\"wc-blocks-shared-context\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-query.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-query.js\",\"version\":\"8231456d3b3054d4f5d2\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-query-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-query-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-results-count.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-results-count.js\",\"version\":\"f67c632c9c0ac6a63903\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-search.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-search.js\",\"version\":\"241a15bb8d9fb8afcd93\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/product-summary.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-summary.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-tag.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-tag.js\",\"version\":\"e5ceb3330a4d33c1d80c\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/product-title.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-title.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-title-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-title-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/product-top-rated.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/product-top-rated.js\",\"version\":\"76b1dfaa394469f53991\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/products-by-attribute.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/products-by-attribute.js\",\"version\":\"d8168d1e219afd197673\",\"dependencies\":[\"react\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-server-side-render\",\"wp-url\"]},\"assets\\/client\\/blocks\\/rating-filter.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/rating-filter.js\",\"version\":\"428e74db07d18b6a6c49\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/reviews-by-category.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-by-category.js\",\"version\":\"36d94e215bcc22086f05\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/reviews-by-product.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/reviews-by-product.js\",\"version\":\"709a17af900e478ee790\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-element\",\"wp-escape-html\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/single-product.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/single-product.js\",\"version\":\"05193999e0f40595cd8e\",\"dependencies\":[\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-store-data\",\"wc-types\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-element\",\"wp-escape-html\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/stock-filter.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/stock-filter.js\",\"version\":\"cbb3c58e66888f68e4a7\",\"dependencies\":[\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/stock-filter-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/stock-filter-frontend.js\",\"version\":\"61da2cb317321e6acc8f\",\"dependencies\":[\"wc-blocks-frontend-vendors\",\"lodash\",\"react\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/page-content-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/page-content-wrapper.js\",\"version\":\"1fd399fa754701bea190\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-status.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-status.js\",\"version\":\"8c9f3a518172327f48a0\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-summary.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-summary.js\",\"version\":\"259daa9a9e302be8a04e\",\"dependencies\":[\"react\",\"wc-price-format\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-date\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-totals.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-totals.js\",\"version\":\"fb4b9c0d40f2d07e0c28\",\"dependencies\":[\"react\",\"wc-price-format\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-totals-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-totals-wrapper.js\",\"version\":\"e2cc2a4e02c46a322434\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-downloads.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-downloads.js\",\"version\":\"26fdedbc1f1b13554ad4\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-downloads-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-downloads-wrapper.js\",\"version\":\"9077b93bf8ff5dc4371e\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-billing-address.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-billing-address.js\",\"version\":\"87d59d30fc3b79a280ec\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-shipping-address.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-shipping-address.js\",\"version\":\"3a24afe202ccabf9fd44\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-billing-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-billing-wrapper.js\",\"version\":\"99dbc2cfeb1472282ed4\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-shipping-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-shipping-wrapper.js\",\"version\":\"f68c7a9bfa980dd916fd\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-information.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-information.js\",\"version\":\"21bdd0df3ab78b31e12b\",\"dependencies\":[\"react\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-fields-wrapper.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-fields-wrapper.js\",\"version\":\"0d2e059d88ef29bca236\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/order-confirmation-additional-fields.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/order-confirmation-additional-fields.js\",\"version\":\"3d34c07f1650322267f0\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-block-editor\",\"wp-blocks\",\"wp-element\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/cart.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart.js\",\"version\":\"6e9fbe4dce866df70b6f\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-editor\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-notices\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/wc-payment-method-cod.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-payment-method-cod.js\",\"version\":\"5f402826b33bac8f9e43\",\"dependencies\":[\"react\",\"wc-blocks-registry\",\"wc-settings\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-frontend.js\",\"version\":\"f10b598c943a06f25d98\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-context\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-items-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-shipping-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-heading-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-discount-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-taxes-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-items-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/proceed-to-checkout-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-accepted-payment-methods-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-coupon-form-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-subtotal-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-cross-sells-products-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-order-summary-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/filled-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/order-summary-fee-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/empty-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-taxes-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-taxes-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-subtotal-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-subtotal-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-totals-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/filled-cart-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filled-cart-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/empty-cart-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/empty-cart-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-totals-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-items-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-line-items-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-line-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-express-payment-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-express-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/proceed-to-checkout-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/proceed-to-checkout-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-accepted-payment-methods-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-accepted-payment-methods-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-coupon-form-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-coupon-form-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-discount-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-discount-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-fee-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-fee-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-heading-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-heading-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-order-summary-shipping-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-order-summary-shipping-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-cross-sells-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-cross-sells-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-cross-sells-products-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-cross-sells-products-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout.js\",\"version\":\"96e1e6e0f4fe470f91fa\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-core-data\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-editor\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-notices\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/checkout-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-frontend.js\",\"version\":\"e140f38159dfa7beb30e\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-blocks-shared-hocs\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-api-fetch\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-plugins\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-shipping-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/actions-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/actions-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/fields-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/fields-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/totals-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/totals-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/actions-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/actions-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-method-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/contact-information-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/payment-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/payment-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/express-payment-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-methods-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-cart-items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-discount-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-note-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-note-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-taxes-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/terms-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/terms-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/shipping-address-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-coupon-form-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/payment-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/billing-address-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-subtotal-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/additional-information-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/totals-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/totals-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/terms-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/terms-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/order-summary-fee-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/pickup-options-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-blocks\\/fields-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-blocks\\/fields-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment--checkout-blocks\\/express-payment-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-express-payment--checkout-blocks\\/express-payment-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-actions-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-actions-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-additional-information-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-additional-information-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-billing-address-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-billing-address-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-contact-information-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-contact-information-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-express-payment-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-express-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-fields-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-fields-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-note-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-note-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-cart-items-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-coupon-form-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-coupon-form-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-discount-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-discount-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-fee-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-fee-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-shipping-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-shipping-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-subtotal-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-subtotal-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-taxes-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-taxes-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-order-summary-totals-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-order-summary-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-payment-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-payment-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-address-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-address-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-methods-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-methods-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-shipping-method-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-shipping-method-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-pickup-options-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-pickup-options-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-terms-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-terms-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/checkout-totals-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/checkout-totals-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents.js\",\"version\":\"0d14f879bb931ec28d02\",\"dependencies\":[\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-data\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/empty-mini-cart-contents-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/empty-mini-cart-contents-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/filled-mini-cart-contents-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/filled-mini-cart-contents-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-footer-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-footer-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-items-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-items-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-products-table-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-products-table-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-shopping-button-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-shopping-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-cart-button-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-cart-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-checkout-button-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-checkout-button-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-items-counter-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-items-counter-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-title-label-block.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-title-label-block.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/wc-types.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-types.js\",\"version\":\"bda84b1be3361607d04a\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-middleware.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-middleware.js\",\"version\":\"ca04183222edaf8a26be\",\"dependencies\":[\"wp-api-fetch\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-data.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-data.js\",\"version\":\"314d18d8fe63fcbe6cb6\",\"dependencies\":[\"wc-blocks-registry\",\"wc-settings\",\"wc-types\",\"wp-api-fetch\",\"wp-data\",\"wp-data-controls\",\"wp-deprecated\",\"wp-dom\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-notices\",\"wp-polyfill\",\"wp-url\"]},\"assets\\/client\\/blocks\\/wc-blocks-vendors.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-vendors.js\",\"version\":\"9c64b2fb6cec317e1770\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-registry.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-registry.js\",\"version\":\"8c83b2b8521a19ab00b9\",\"dependencies\":[\"react\",\"wc-settings\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks.js\",\"version\":\"93db775143f168c26ac3\",\"dependencies\":[\"react\",\"wc-types\",\"wp-block-editor\",\"wp-blocks\",\"wp-components\",\"wp-compose\",\"wp-data\",\"wp-dom-ready\",\"wp-element\",\"wp-hooks\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\",\"wp-url\"]},\"assets\\/client\\/blocks\\/wc-blocks-shared-context.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-shared-context.js\",\"version\":\"6eb6865831aa5a75475d\",\"dependencies\":[\"react\",\"wp-element\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-shared-hocs.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-shared-hocs.js\",\"version\":\"4f21a9f43ea5bfa7f02e\",\"dependencies\":[\"react\",\"wc-blocks-data-store\",\"wc-blocks-shared-context\",\"wc-types\",\"wp-data\",\"wp-element\",\"wp-is-shallow-equal\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/price-format.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/price-format.js\",\"version\":\"483d2180eda1f53dc60d\",\"dependencies\":[\"wc-settings\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-blocks-frontend-vendors-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-blocks-frontend-vendors-frontend.js\",\"version\":\"651d3d70da2d2aef0e82\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-cart-checkout-vendors-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-cart-checkout-vendors-frontend.js\",\"version\":\"4ef596e6634f89ac412f\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-cart-checkout-base-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-cart-checkout-base-frontend.js\",\"version\":\"7657f2f92845b59d4dce\",\"dependencies\":[\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/blocks-checkout.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/blocks-checkout.js\",\"version\":\"b17cecfe19e23a3899e0\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"react-dom\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-polyfill\",\"wp-primitives\",\"wp-warning\"]},\"assets\\/client\\/blocks\\/blocks-components.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/blocks-components.js\",\"version\":\"5f11d5c440e62fef7bb5\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"react-dom\",\"wc-blocks-data-store\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-html-entities\",\"wp-i18n\",\"wp-polyfill\",\"wp-primitives\"]},\"assets\\/client\\/blocks\\/wc-interactivity-dropdown.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-interactivity-dropdown.js\",\"version\":\"8997b5406dcf18064a4e\",\"dependencies\":[\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/wc-interactivity-checkbox-list.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/wc-interactivity-checkbox-list.js\",\"version\":\"9f910c57a575d29e7f8e\",\"dependencies\":[\"wc-interactivity\",\"wp-polyfill\"]},\"assets\\/client\\/blocks\\/mini-cart-component-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-component-frontend.js\",\"version\":\"94a847b96873f9cc6d69\",\"dependencies\":[\"wc-cart-checkout-base\",\"wc-cart-checkout-vendors\",\"react\",\"wc-blocks-checkout\",\"wc-blocks-components\",\"wc-blocks-data-store\",\"wc-blocks-registry\",\"wc-price-format\",\"wc-settings\",\"wc-types\",\"wp-a11y\",\"wp-autop\",\"wp-compose\",\"wp-data\",\"wp-deprecated\",\"wp-element\",\"wp-hooks\",\"wp-html-entities\",\"wp-i18n\",\"wp-is-shallow-equal\",\"wp-keycodes\",\"wp-polyfill\",\"wp-primitives\",\"wp-style-engine\",\"wp-url\",\"wp-wordcount\"]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-items-counter-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/footer-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/cart-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/title-label-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/shopping-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/filled-cart-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/products-table-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/products-table-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/items-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/checkout-button-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-style.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/mini-cart-contents-block\\/empty-cart-style.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]},\"assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items--mini-cart-contents-block\\/products-table-frontend.js\":{\"src\":\"https:\\/\\/store.local\\/wp-content\\/plugins\\/woocommerce\\/assets\\/client\\/blocks\\/cart-blocks\\/cart-line-items--mini-cart-contents-block\\/products-table-frontend.js\",\"version\":\"wc-9.3.3\",\"dependencies\":[]}},\"version\":\"wc-9.3.3\",\"hash\":\"ece36231608b111b2d532b419df04fcb\"}','off'),
(411,'_transient_shipping-transient-version','1792320519','on'),
(412,'_transient_timeout_wc_shipping_method_count_legacy','1794912519','off'),
(413,'_transient_wc_shipping_method_count_legacy','a:2:{s:7:\"version\";s:10:\"1792320519\";s:5:\"value\";i:0;}','off'),
(422,'_transient_timeout_wc_blocks_query_5363a57d92ddac380bcea0733b79eaad','1795013985','off'),
(423,'_transient_wc_blocks_query_5363a57d92ddac380bcea0733b79eaad','a:2:{s:7:\"version\";s:10:\"1792419493\";s:5:\"value\";a:4:{i:0;i:24;i:1;i:23;i:2;i:21;i:3;i:19;}}','off'),
(430,'_transient_timeout_woocommerce_marketplace_promotions_v2','1792407516','off'),
(431,'_transient_woocommerce_marketplace_promotions_v2','a:0:{}','off'),
(432,'action_scheduler_lock_async-request-runner','6ad4a8f15b2303.74697917|1792321837','no'),
(433,'_transient_timeout__woocommerce_helper_subscriptions','1792322192','off'),
(434,'_transient__woocommerce_helper_subscriptions','a:0:{}','off'),
(435,'_site_transient_timeout_theme_roots','1792323097','off'),
(436,'_site_transient_theme_roots','a:4:{s:10:\"storefront\";s:7:\"/themes\";s:16:\"twentytwentyfive\";s:7:\"/themes\";s:16:\"twentytwentyfour\";s:7:\"/themes\";s:17:\"twentytwentythree\";s:7:\"/themes\";}','off'),
(440,'current_theme','Storefront','auto'),
(441,'theme_switched','','auto'),
(444,'theme_mods_storefront','a:2:{s:18:\"nav_menu_locations\";a:2:{s:7:\"primary\";i:16;s:8:\"handheld\";i:16;}s:18:\"custom_css_post_id\";i:-1;}','auto'),
(445,'woocommerce_catalog_rows','4','auto'),
(446,'woocommerce_catalog_columns','3','auto'),
(447,'woocommerce_maybe_regenerate_images_hash','27acde77266b4d2a3491118955cb3f66','auto'),
(448,'wp_1_wc_regenerate_images_batch_1844c86a023fd0cf32c20e21b20df5c6','a:1:{i:0;a:1:{s:13:\"attachment_id\";s:1:\"4\";}}','off'),
(451,'storefront_nux_fresh_site','1','auto'),
(463,'_transient_timeout_woocommerce_admin_payment_method_promotion_specs','1792436686','off'),
(464,'_transient_woocommerce_admin_payment_method_promotion_specs','a:1:{s:5:\"en_US\";a:2:{i:0;a:7:{s:2:\"id\";s:27:\"woocommerce_payments:woopay\";s:5:\"title\";s:11:\"WooPayments\";s:7:\"content\";s:74:\"Payments made simple — including WooPay, a new express checkout feature.\";s:5:\"image\";s:85:\"https://store.local/wp-content/plugins/woocommerce/assets/images/onboarding/wcpay.svg\";s:7:\"plugins\";a:1:{i:0;s:20:\"woocommerce-payments\";}s:10:\"is_visible\";a:2:{i:0;O:8:\"stdClass\":6:{s:4:\"type\";s:6:\"option\";s:12:\"transformers\";a:2:{i:0;O:8:\"stdClass\":2:{s:3:\"use\";s:12:\"dot_notation\";s:9:\"arguments\";O:8:\"stdClass\":1:{s:4:\"path\";s:8:\"industry\";}}i:1;O:8:\"stdClass\":2:{s:3:\"use\";s:12:\"array_column\";s:9:\"arguments\";O:8:\"stdClass\":1:{s:3:\"key\";s:4:\"slug\";}}}s:11:\"option_name\";s:30:\"woocommerce_onboarding_profile\";s:9:\"operation\";s:9:\"!contains\";s:5:\"value\";s:31:\"cbd-other-hemp-derived-products\";s:7:\"default\";a:0:{}}i:1;O:8:\"stdClass\":2:{s:4:\"type\";s:2:\"or\";s:8:\"operands\";a:1:{i:0;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"US\";s:9:\"operation\";s:1:\"=\";}}}}s:9:\"sub_title\";s:780:\"<img class=\"wcpay-visa-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/visa.svg\" alt=\"Visa\"><img class=\"wcpay-mastercard-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/mastercard.svg\" alt=\"Mastercard\"><img class=\"wcpay-amex-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/amex.svg\" alt=\"Amex\"><img class=\"wcpay-googlepay-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/googlepay.svg\" alt=\"Googlepay\"><img class=\"wcpay-applepay-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/applepay.svg\" alt=\"Applepay\">\";}i:1;a:7:{s:2:\"id\";s:20:\"woocommerce_payments\";s:5:\"title\";s:11:\"WooPayments\";s:7:\"content\";s:160:\"Payments made simple, with no monthly fees – designed exclusively for WooCommerce stores. Accept credit cards, debit cards, and other popular payment methods.\";s:5:\"image\";s:85:\"https://store.local/wp-content/plugins/woocommerce/assets/images/onboarding/wcpay.svg\";s:7:\"plugins\";a:1:{i:0;s:20:\"woocommerce-payments\";}s:10:\"is_visible\";a:2:{i:0;O:8:\"stdClass\":6:{s:4:\"type\";s:6:\"option\";s:12:\"transformers\";a:2:{i:0;O:8:\"stdClass\":2:{s:3:\"use\";s:12:\"dot_notation\";s:9:\"arguments\";O:8:\"stdClass\":1:{s:4:\"path\";s:8:\"industry\";}}i:1;O:8:\"stdClass\":2:{s:3:\"use\";s:12:\"array_column\";s:9:\"arguments\";O:8:\"stdClass\":1:{s:3:\"key\";s:4:\"slug\";}}}s:11:\"option_name\";s:30:\"woocommerce_onboarding_profile\";s:9:\"operation\";s:9:\"!contains\";s:5:\"value\";s:31:\"cbd-other-hemp-derived-products\";s:7:\"default\";a:0:{}}i:1;O:8:\"stdClass\":2:{s:4:\"type\";s:2:\"or\";s:8:\"operands\";a:39:{i:0;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"US\";s:9:\"operation\";s:1:\"=\";}i:1;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"PR\";s:9:\"operation\";s:1:\"=\";}i:2;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"AU\";s:9:\"operation\";s:1:\"=\";}i:3;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"CA\";s:9:\"operation\";s:1:\"=\";}i:4;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"CY\";s:9:\"operation\";s:1:\"=\";}i:5;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"DE\";s:9:\"operation\";s:1:\"=\";}i:6;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"DK\";s:9:\"operation\";s:1:\"=\";}i:7;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"EE\";s:9:\"operation\";s:1:\"=\";}i:8;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"ES\";s:9:\"operation\";s:1:\"=\";}i:9;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"FI\";s:9:\"operation\";s:1:\"=\";}i:10;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"FR\";s:9:\"operation\";s:1:\"=\";}i:11;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"GB\";s:9:\"operation\";s:1:\"=\";}i:12;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"GR\";s:9:\"operation\";s:1:\"=\";}i:13;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"IE\";s:9:\"operation\";s:1:\"=\";}i:14;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"IT\";s:9:\"operation\";s:1:\"=\";}i:15;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"LU\";s:9:\"operation\";s:1:\"=\";}i:16;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"LT\";s:9:\"operation\";s:1:\"=\";}i:17;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"LV\";s:9:\"operation\";s:1:\"=\";}i:18;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"NO\";s:9:\"operation\";s:1:\"=\";}i:19;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"NZ\";s:9:\"operation\";s:1:\"=\";}i:20;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"MT\";s:9:\"operation\";s:1:\"=\";}i:21;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"AT\";s:9:\"operation\";s:1:\"=\";}i:22;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"BE\";s:9:\"operation\";s:1:\"=\";}i:23;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"NL\";s:9:\"operation\";s:1:\"=\";}i:24;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"PL\";s:9:\"operation\";s:1:\"=\";}i:25;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"PT\";s:9:\"operation\";s:1:\"=\";}i:26;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"CH\";s:9:\"operation\";s:1:\"=\";}i:27;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"HK\";s:9:\"operation\";s:1:\"=\";}i:28;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"SI\";s:9:\"operation\";s:1:\"=\";}i:29;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"SK\";s:9:\"operation\";s:1:\"=\";}i:30;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"SG\";s:9:\"operation\";s:1:\"=\";}i:31;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"BG\";s:9:\"operation\";s:1:\"=\";}i:32;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"CZ\";s:9:\"operation\";s:1:\"=\";}i:33;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"HR\";s:9:\"operation\";s:1:\"=\";}i:34;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"HU\";s:9:\"operation\";s:1:\"=\";}i:35;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"RO\";s:9:\"operation\";s:1:\"=\";}i:36;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"SE\";s:9:\"operation\";s:1:\"=\";}i:37;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"JP\";s:9:\"operation\";s:1:\"=\";}i:38;O:8:\"stdClass\":3:{s:4:\"type\";s:21:\"base_location_country\";s:5:\"value\";s:2:\"AE\";s:9:\"operation\";s:1:\"=\";}}}}s:9:\"sub_title\";s:780:\"<img class=\"wcpay-visa-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/visa.svg\" alt=\"Visa\"><img class=\"wcpay-mastercard-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/mastercard.svg\" alt=\"Mastercard\"><img class=\"wcpay-amex-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/amex.svg\" alt=\"Amex\"><img class=\"wcpay-googlepay-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/googlepay.svg\" alt=\"Googlepay\"><img class=\"wcpay-applepay-icon wcpay-icon\" src=\"https://store.local/wp-content/plugins/woocommerce/assets/images/payment-methods/applepay.svg\" alt=\"Applepay\">\";}}}','off'),
(474,'_transient_timeout_wc_order_26_needs_processing','1792509797','off'),
(475,'_transient_wc_order_26_needs_processing','1','off'),
(476,'_transient_timeout_wc_order_25_needs_processing','1792509797','off'),
(477,'_transient_wc_order_25_needs_processing','1','off'),
(478,'_transient_timeout_wc_order_22_needs_processing','1792509797','off'),
(479,'_transient_wc_order_22_needs_processing','1','off'),
(480,'_transient_timeout_wc_order_20_needs_processing','1792509797','off'),
(481,'_transient_wc_order_20_needs_processing','1','off'),
(482,'_transient_timeout_wc_related_24','1792509886','off'),
(483,'_transient_wc_related_24','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=24\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"19\";i:6;s:2:\"21\";i:7;s:2:\"23\";}}','off'),
(484,'_transient_timeout_wc_order_39_needs_processing','1792509905','off'),
(485,'_transient_wc_order_39_needs_processing','1','off'),
(488,'_transient_timeout_wc_order_17_needs_processing','1792509918','off'),
(489,'_transient_wc_order_17_needs_processing','1','off'),
(490,'_transient_timeout_wc_order_16_needs_processing','1792509918','off'),
(491,'_transient_wc_order_16_needs_processing','1','off'),
(492,'_transient_timeout_wc_order_15_needs_processing','1792509918','off'),
(493,'_transient_wc_order_15_needs_processing','1','off'),
(504,'_transient_timeout_wc_related_23','1792511075','off'),
(505,'_transient_wc_related_23','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=23\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"19\";i:6;s:2:\"21\";i:7;s:2:\"24\";}}','off'),
(506,'_transient_timeout_wc_related_21','1792511075','off'),
(507,'_transient_wc_related_21','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=21\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"19\";i:6;s:2:\"23\";i:7;s:2:\"24\";}}','off'),
(508,'_transient_timeout_wc_related_19','1792511075','off'),
(509,'_transient_wc_related_19','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=19\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";}}','off'),
(510,'_transient_timeout_wc_related_14','1792511075','off'),
(511,'_transient_wc_related_14','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=14\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"19\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";}}','off'),
(512,'_transient_timeout_wc_related_12','1792511075','off'),
(513,'_transient_wc_related_12','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=12\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"13\";i:3;s:2:\"14\";i:4;s:2:\"19\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";}}','off'),
(514,'_transient_timeout_wc_related_11','1792511075','off'),
(515,'_transient_wc_related_11','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=11\";a:8:{i:0;s:2:\"10\";i:1;s:2:\"12\";i:2;s:2:\"13\";i:3;s:2:\"14\";i:4;s:2:\"19\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";}}','off'),
(538,'_transient_timeout_wc_related_40','1792512235','off'),
(539,'_transient_wc_related_40','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=40\";a:9:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"19\";i:6;s:2:\"21\";i:7;s:2:\"23\";i:8;s:2:\"24\";}}','off'),
(546,'_transient_timeout_wc_related_13','1792513515','off'),
(547,'_transient_wc_related_13','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=13\";a:9:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"14\";i:4;s:2:\"19\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";i:8;s:2:\"40\";}}','off'),
(570,'_transient_timeout_wc_related_10','1792590587','off'),
(571,'_transient_wc_related_10','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=10\";a:9:{i:0;s:2:\"11\";i:1;s:2:\"12\";i:2;s:2:\"13\";i:3;s:2:\"14\";i:4;s:2:\"19\";i:5;s:2:\"21\";i:6;s:2:\"23\";i:7;s:2:\"24\";i:8;s:2:\"40\";}}','off'),
(572,'_transient_timeout_as-post-store-dependencies-met','1792591543','off'),
(573,'_transient_as-post-store-dependencies-met','yes','off'),
(576,'_transient_timeout_wc_order_38_needs_processing','1792593419','off'),
(577,'_transient_wc_order_38_needs_processing','1','off'),
(580,'_transient_timeout_wc_term_counts','1795099055','off'),
(581,'_transient_wc_term_counts','a:0:{}','off'),
(582,'_transient_timeout_wc_related_41','1792593455','off'),
(583,'_transient_wc_related_41','a:1:{s:50:\"limit=5&exclude_ids%5B0%5D=0&exclude_ids%5B1%5D=41\";a:10:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"12\";i:3;s:2:\"13\";i:4;s:2:\"14\";i:5;s:2:\"19\";i:6;s:2:\"21\";i:7;s:2:\"23\";i:8;s:2:\"24\";i:9;s:2:\"40\";}}','off'),
(590,'_transient_is_multi_author','0','on'),
(597,'_site_transient_timeout_wp_theme_files_patterns-ec66bb55a2ce1cbdd8a2fd4cb9a6193d','1792578995','off'),
(598,'_site_transient_wp_theme_files_patterns-ec66bb55a2ce1cbdd8a2fd4cb9a6193d','a:2:{s:7:\"version\";s:5:\"4.6.2\";s:8:\"patterns\";a:0:{}}','off');
/*!40000 ALTER TABLE `wp_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_postmeta`
--

DROP TABLE IF EXISTS `wp_postmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=568 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_postmeta`
--

LOCK TABLES `wp_postmeta` WRITE;
/*!40000 ALTER TABLE `wp_postmeta` DISABLE KEYS */;
INSERT INTO `wp_postmeta` VALUES
(2,3,'_wp_page_template','default'),
(3,4,'_wp_attached_file','woocommerce-placeholder.png'),
(4,4,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:1200;s:6:\"height\";i:1200;s:4:\"file\";s:27:\"woocommerce-placeholder.png\";s:8:\"filesize\";i:48149;s:5:\"sizes\";a:4:{s:6:\"medium\";a:5:{s:4:\"file\";s:35:\"woocommerce-placeholder-300x300.png\";s:5:\"width\";i:300;s:6:\"height\";i:300;s:9:\"mime-type\";s:9:\"image/png\";s:8:\"filesize\";i:10479;}s:5:\"large\";a:5:{s:4:\"file\";s:37:\"woocommerce-placeholder-1024x1024.png\";s:5:\"width\";i:1024;s:6:\"height\";i:1024;s:9:\"mime-type\";s:9:\"image/png\";s:8:\"filesize\";i:76215;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:35:\"woocommerce-placeholder-150x150.png\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:9:\"image/png\";s:8:\"filesize\";i:3753;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:35:\"woocommerce-placeholder-768x768.png\";s:5:\"width\";i:768;s:6:\"height\";i:768;s:9:\"mime-type\";s:9:\"image/png\";s:8:\"filesize\";i:46535;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(5,10,'_sku','SKU-1001'),
(6,10,'_regular_price','199.99'),
(7,10,'total_sales','3'),
(8,10,'_tax_status','taxable'),
(9,10,'_tax_class',''),
(10,10,'_manage_stock','yes'),
(11,10,'_backorders','no'),
(12,10,'_sold_individually','no'),
(13,10,'_virtual','no'),
(14,10,'_downloadable','no'),
(15,10,'_download_limit','-1'),
(16,10,'_download_expiry','-1'),
(17,10,'_stock','-50'),
(18,10,'_stock_status','outofstock'),
(19,10,'_wc_average_rating','0'),
(20,10,'_wc_review_count','0'),
(21,10,'_product_version','9.3.3'),
(22,10,'_price','199.99'),
(23,11,'_sku','SKU-1002'),
(24,11,'_regular_price','129.50'),
(25,11,'total_sales','2'),
(26,11,'_tax_status','taxable'),
(27,11,'_tax_class',''),
(28,11,'_manage_stock','yes'),
(29,11,'_backorders','no'),
(30,11,'_sold_individually','no'),
(31,11,'_virtual','no'),
(32,11,'_downloadable','no'),
(33,11,'_download_limit','-1'),
(34,11,'_download_expiry','-1'),
(35,11,'_stock','10'),
(36,11,'_stock_status','instock'),
(37,11,'_wc_average_rating','0'),
(38,11,'_wc_review_count','0'),
(39,11,'_product_version','9.3.3'),
(40,11,'_price','129.50'),
(41,12,'_sku','SKU-1003'),
(42,12,'_regular_price','499.00'),
(43,12,'total_sales','0'),
(44,12,'_tax_status','taxable'),
(45,12,'_tax_class',''),
(46,12,'_manage_stock','yes'),
(47,12,'_backorders','no'),
(48,12,'_sold_individually','no'),
(49,12,'_virtual','no'),
(50,12,'_downloadable','no'),
(51,12,'_download_limit','-1'),
(52,12,'_download_expiry','-1'),
(53,12,'_stock','5'),
(54,12,'_stock_status','instock'),
(55,12,'_wc_average_rating','0'),
(56,12,'_wc_review_count','0'),
(57,12,'_product_version','9.3.3'),
(58,12,'_price','499.00'),
(59,13,'_sku','SKU-1004'),
(60,13,'_regular_price','45.00'),
(61,13,'total_sales','0'),
(62,13,'_tax_status','taxable'),
(63,13,'_tax_class',''),
(64,13,'_manage_stock','yes'),
(65,13,'_backorders','no'),
(66,13,'_sold_individually','no'),
(67,13,'_virtual','no'),
(68,13,'_downloadable','no'),
(69,13,'_download_limit','-1'),
(70,13,'_download_expiry','-1'),
(71,13,'_stock','500'),
(72,13,'_stock_status','instock'),
(73,13,'_wc_average_rating','0'),
(74,13,'_wc_review_count','0'),
(75,13,'_product_version','9.3.3'),
(76,13,'_price','45.00'),
(77,14,'_sku','SKU-1005'),
(78,14,'_regular_price','89.00'),
(79,14,'total_sales','0'),
(80,14,'_tax_status','taxable'),
(81,14,'_tax_class',''),
(82,14,'_manage_stock','yes'),
(83,14,'_backorders','no'),
(84,14,'_sold_individually','no'),
(85,14,'_virtual','no'),
(86,14,'_downloadable','no'),
(87,14,'_download_limit','-1'),
(88,14,'_download_expiry','-1'),
(89,14,'_stock','0'),
(90,14,'_stock_status','outofstock'),
(91,14,'_wc_average_rating','0'),
(92,14,'_wc_review_count','0'),
(93,14,'_product_version','9.3.3'),
(94,14,'_price','89.00'),
(95,15,'_order_key','wc_order_NYb761OgVYJGJ'),
(96,15,'_customer_user','0'),
(97,15,'_customer_ip_address','127.0.0.1'),
(98,15,'_customer_user_agent','WP CLI 2.12.0'),
(99,15,'_download_permissions_granted','yes'),
(100,15,'_recorded_sales','yes'),
(101,15,'_recorded_coupon_usage_counts','yes'),
(102,15,'_new_order_email_sent','true'),
(103,15,'_order_stock_reduced','yes'),
(104,15,'_order_currency','USD'),
(105,15,'_cart_discount','0'),
(106,15,'_cart_discount_tax','0'),
(107,15,'_order_shipping','0'),
(108,15,'_order_shipping_tax','0'),
(109,15,'_order_tax','0'),
(110,15,'_order_total','199.99'),
(111,15,'_order_version','9.3.3'),
(112,15,'_prices_include_tax','no'),
(113,15,'_billing_address_index','          '),
(114,15,'_shipping_address_index','         '),
(115,15,'_billing_first_name','Sarah'),
(116,15,'_billing_last_name','Chen'),
(117,15,'_billing_email','sarah.chen@example.com'),
(118,15,'_billing_address_1','100 Market St'),
(119,15,'_billing_city','San Francisco'),
(120,15,'_billing_state','CA'),
(121,15,'_billing_postcode','94105'),
(122,15,'_billing_country','US'),
(123,15,'_date_paid','1792310454'),
(124,15,'_paid_date','2026-10-18 08:00:54'),
(125,16,'_order_key','wc_order_gmwIVIZKs1Fmc'),
(126,16,'_customer_user','0'),
(127,16,'_customer_ip_address','127.0.0.1'),
(128,16,'_customer_user_agent','WP CLI 2.12.0'),
(129,16,'_download_permissions_granted','yes'),
(130,16,'_recorded_sales','yes'),
(131,16,'_recorded_coupon_usage_counts','yes'),
(132,16,'_new_order_email_sent','true'),
(133,16,'_order_stock_reduced','yes'),
(134,16,'_order_currency','USD'),
(135,16,'_cart_discount','0'),
(136,16,'_cart_discount_tax','0'),
(137,16,'_order_shipping','0'),
(138,16,'_order_shipping_tax','0'),
(139,16,'_order_tax','0'),
(140,16,'_order_total','259.00'),
(141,16,'_order_version','9.3.3'),
(142,16,'_prices_include_tax','no'),
(143,16,'_billing_address_index','          '),
(144,16,'_shipping_address_index','         '),
(145,16,'_billing_first_name','Alex'),
(146,16,'_billing_last_name','Rivera'),
(147,16,'_billing_email','alex.rivera@example.com'),
(148,16,'_billing_address_1','250 Broadway'),
(149,16,'_billing_city','New York'),
(150,16,'_billing_state','NY'),
(151,16,'_billing_postcode','10007'),
(152,16,'_billing_country','US'),
(153,16,'_date_completed','1792310455'),
(154,16,'_date_paid','1792310455'),
(155,16,'_paid_date','2026-10-18 08:00:55'),
(156,16,'_completed_date','2026-10-18 08:00:55'),
(157,17,'_order_key','wc_order_VslllYBxq1RRh'),
(158,17,'_customer_user','0'),
(159,17,'_customer_ip_address','127.0.0.1'),
(160,17,'_customer_user_agent','WP CLI 2.12.0'),
(161,17,'_download_permissions_granted','no'),
(162,17,'_recorded_sales','no'),
(163,17,'_recorded_coupon_usage_counts','no'),
(164,17,'_new_order_email_sent','false'),
(165,17,'_order_stock_reduced','no'),
(166,17,'_order_currency','USD'),
(167,17,'_cart_discount','0'),
(168,17,'_cart_discount_tax','0'),
(169,17,'_order_shipping','0'),
(170,17,'_order_shipping_tax','0'),
(171,17,'_order_tax','0'),
(172,17,'_order_total','329.49'),
(173,17,'_order_version','9.3.3'),
(174,17,'_prices_include_tax','no'),
(175,17,'_billing_address_index','          '),
(176,17,'_shipping_address_index','         '),
(177,17,'_billing_first_name','Jordan'),
(178,17,'_billing_last_name','Taylor'),
(179,17,'_billing_email','jordan.taylor@example.com'),
(180,17,'_billing_address_1','500 Pine St'),
(181,17,'_billing_city','Seattle'),
(182,17,'_billing_state','WA'),
(183,17,'_billing_postcode','98101'),
(184,17,'_billing_country','US'),
(185,19,'_sku','SKU-DYN-6'),
(186,19,'_regular_price','89.50'),
(187,19,'total_sales','2'),
(188,19,'_tax_status','taxable'),
(189,19,'_tax_class',''),
(190,19,'_manage_stock','yes'),
(191,19,'_backorders','no'),
(192,19,'_sold_individually','no'),
(193,19,'_virtual','no'),
(194,19,'_downloadable','no'),
(195,19,'_download_limit','-1'),
(196,19,'_download_expiry','-1'),
(197,19,'_stock','38'),
(198,19,'_stock_status','instock'),
(199,19,'_wc_average_rating','0'),
(200,19,'_wc_review_count','0'),
(201,19,'_product_version','9.3.3'),
(202,19,'_price','89.50'),
(203,20,'_order_key','wc_order_LA4EIUhk4aheP'),
(204,20,'_customer_user','0'),
(205,20,'_payment_method','cod'),
(206,20,'_payment_method_title','Cash on Delivery'),
(207,20,'_created_via','rest-api'),
(208,20,'_download_permissions_granted','yes'),
(209,20,'_recorded_sales','yes'),
(210,20,'_recorded_coupon_usage_counts','yes'),
(211,20,'_new_order_email_sent','true'),
(212,20,'_order_stock_reduced','yes'),
(213,20,'_billing_first_name','Antigravity'),
(214,20,'_billing_last_name','Tester'),
(215,20,'_billing_address_1','100 Innovation Way'),
(216,20,'_billing_city','San Francisco'),
(217,20,'_billing_state','CA'),
(218,20,'_billing_postcode','94105'),
(219,20,'_billing_country','US'),
(220,20,'_billing_email','tester@urumi.local'),
(221,20,'_order_currency','USD'),
(222,20,'_cart_discount','0'),
(223,20,'_cart_discount_tax','0'),
(224,20,'_order_shipping','0'),
(225,20,'_order_shipping_tax','0'),
(226,20,'_order_tax','0'),
(227,20,'_order_total','179.00'),
(228,20,'_order_version','9.3.3'),
(229,20,'_prices_include_tax','no'),
(230,20,'_billing_address_index','Antigravity Tester  100 Innovation Way  San Francisco CA 94105 US tester@urumi.local '),
(231,20,'_shipping_address_index','         '),
(232,20,'_date_completed','1792311645'),
(233,20,'_date_paid','1792311645'),
(234,20,'_paid_date','2026-10-18 08:20:45'),
(235,20,'_completed_date','2026-10-18 08:20:45'),
(236,21,'_sku','SKU-DYN-7'),
(237,21,'_regular_price','89.50'),
(238,21,'total_sales','3'),
(239,21,'_tax_status','taxable'),
(240,21,'_tax_class',''),
(241,21,'_manage_stock','yes'),
(242,21,'_backorders','no'),
(243,21,'_sold_individually','no'),
(244,21,'_virtual','no'),
(245,21,'_downloadable','no'),
(246,21,'_download_limit','-1'),
(247,21,'_download_expiry','-1'),
(248,21,'_stock','37'),
(249,21,'_stock_status','instock'),
(250,21,'_wc_average_rating','0'),
(251,21,'_wc_review_count','0'),
(252,21,'_product_version','9.3.3'),
(253,21,'_price','89.50'),
(254,22,'_order_key','wc_order_Z1KGvmjXr76ok'),
(255,22,'_customer_user','0'),
(256,22,'_payment_method','cod'),
(257,22,'_payment_method_title','Cash on Delivery'),
(258,22,'_created_via','rest-api'),
(259,22,'_download_permissions_granted','yes'),
(260,22,'_recorded_sales','yes'),
(261,22,'_recorded_coupon_usage_counts','yes'),
(262,22,'_new_order_email_sent','true'),
(263,22,'_order_stock_reduced','yes'),
(264,22,'_billing_first_name','Antigravity'),
(265,22,'_billing_last_name','Tester'),
(266,22,'_billing_address_1','100 Innovation Way'),
(267,22,'_billing_city','San Francisco'),
(268,22,'_billing_state','CA'),
(269,22,'_billing_postcode','94105'),
(270,22,'_billing_country','US'),
(271,22,'_billing_email','tester@urumi.local'),
(272,22,'_order_currency','USD'),
(273,22,'_cart_discount','0'),
(274,22,'_cart_discount_tax','0'),
(275,22,'_order_shipping','0'),
(276,22,'_order_shipping_tax','0'),
(277,22,'_order_tax','0'),
(278,22,'_order_total','179.00'),
(279,22,'_order_version','9.3.3'),
(280,22,'_prices_include_tax','no'),
(281,22,'_billing_address_index','Antigravity Tester  100 Innovation Way  San Francisco CA 94105 US tester@urumi.local '),
(282,22,'_shipping_address_index','         '),
(283,22,'_date_completed','1792311677'),
(284,22,'_date_paid','1792311677'),
(285,22,'_paid_date','2026-10-18 08:21:17'),
(286,22,'_completed_date','2026-10-18 08:21:17'),
(287,23,'_sku','SKU-TEST-P2-6'),
(288,23,'_regular_price','75.00'),
(289,23,'total_sales','0'),
(290,23,'_tax_status','taxable'),
(291,23,'_tax_class',''),
(292,23,'_manage_stock','yes'),
(293,23,'_backorders','no'),
(294,23,'_sold_individually','no'),
(295,23,'_virtual','no'),
(296,23,'_downloadable','no'),
(297,23,'_download_limit','-1'),
(298,23,'_download_expiry','-1'),
(299,23,'_stock','25'),
(300,23,'_stock_status','instock'),
(301,23,'_wc_average_rating','0'),
(302,23,'_wc_review_count','0'),
(303,23,'_product_version','9.3.3'),
(304,23,'_price','75.00'),
(305,24,'_sku','SKU-DESK-01'),
(306,24,'_regular_price','35.00'),
(307,24,'total_sales','3'),
(308,24,'_tax_status','taxable'),
(309,24,'_tax_class',''),
(310,24,'_manage_stock','yes'),
(311,24,'_backorders','no'),
(312,24,'_sold_individually','no'),
(313,24,'_virtual','no'),
(314,24,'_downloadable','no'),
(315,24,'_download_limit','-1'),
(316,24,'_download_expiry','-1'),
(317,24,'_stock','57'),
(318,24,'_stock_status','instock'),
(319,24,'_wc_average_rating','0'),
(320,24,'_wc_review_count','0'),
(321,24,'_product_version','9.3.3'),
(322,24,'_price','35.00'),
(323,25,'_order_key','wc_order_QDRgdI8MtEA5R'),
(324,25,'_customer_user','0'),
(325,25,'_payment_method','cod'),
(326,25,'_payment_method_title','Cash on delivery'),
(327,25,'_created_via','rest-api'),
(328,25,'_download_permissions_granted','yes'),
(329,25,'_recorded_sales','yes'),
(330,25,'_recorded_coupon_usage_counts','yes'),
(331,25,'_new_order_email_sent','true'),
(332,25,'_order_stock_reduced','yes'),
(333,25,'_billing_first_name','Sarah'),
(334,25,'_billing_last_name','Chen'),
(335,25,'_billing_email','shopper@example.com'),
(336,25,'_order_currency','USD'),
(337,25,'_cart_discount','0'),
(338,25,'_cart_discount_tax','0'),
(339,25,'_order_shipping','0'),
(340,25,'_order_shipping_tax','0'),
(341,25,'_order_tax','0'),
(342,25,'_order_total','199.99'),
(343,25,'_order_version','9.3.3'),
(344,25,'_prices_include_tax','no'),
(345,25,'_billing_address_index','Sarah Chen        shopper@example.com '),
(346,25,'_shipping_address_index','         '),
(347,26,'_order_key','wc_order_v2H24m8KaZQii'),
(348,26,'_customer_user','0'),
(349,26,'_customer_ip_address','172.18.0.1'),
(350,26,'_customer_user_agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36'),
(351,26,'_created_via','store-api'),
(352,26,'_cart_hash','42ad6303e677e9e111c60487cb4e3d63'),
(353,26,'_download_permissions_granted','yes'),
(354,26,'_recorded_sales','yes'),
(355,26,'_recorded_coupon_usage_counts','yes'),
(356,26,'_new_order_email_sent','true'),
(357,26,'_order_stock_reduced','yes'),
(358,26,'_billing_state','UP'),
(359,26,'_billing_country','IN'),
(360,26,'_shipping_state','UP'),
(361,26,'_shipping_country','IN'),
(362,26,'_order_currency','USD'),
(363,26,'_cart_discount','0'),
(364,26,'_cart_discount_tax','0'),
(365,26,'_order_shipping','0'),
(366,26,'_order_shipping_tax','0'),
(367,26,'_order_tax','0'),
(368,26,'_order_total','89.50'),
(369,26,'_order_version','9.3.3'),
(370,26,'_prices_include_tax','no'),
(371,26,'_billing_address_index','Uttkarsh home  sec 2/462 ,chiranjeev vihar  ghaziabad UP 201002 IN uttkarsh2003.solanki@gmail.com +919990766708'),
(372,26,'_shipping_address_index','Uttkarsh home  sec 2/462 ,chiranjeev vihar  ghaziabad UP 201002 IN +919990766708'),
(373,26,'_shipping_hash','9d4568c009d203ab10e33ea9953a0264'),
(374,26,'_coupons_hash','d751713988987e9331980363e24189ce'),
(375,26,'_fees_hash','d751713988987e9331980363e24189ce'),
(376,26,'_taxes_hash','d751713988987e9331980363e24189ce'),
(377,26,'is_vat_exempt','no'),
(378,26,'_billing_last_name','home'),
(379,26,'_billing_address_1','sec 2/462 ,chiranjeev vihar'),
(380,26,'_billing_city','ghaziabad'),
(381,26,'_billing_postcode','201002'),
(382,26,'_billing_email','uttkarsh2003.solanki@gmail.com'),
(383,26,'_billing_phone','+919990766708'),
(384,26,'_shipping_last_name','home'),
(385,26,'_shipping_address_1','sec 2/462 ,chiranjeev vihar'),
(386,26,'_shipping_city','ghaziabad'),
(387,26,'_shipping_postcode','201002'),
(388,26,'_shipping_phone','+919990766708'),
(389,26,'_billing_first_name','Uttkarsh'),
(390,26,'_shipping_first_name','Uttkarsh'),
(391,26,'_wc_order_attribution_source_type','typein'),
(392,26,'_wc_order_attribution_utm_source','(direct)'),
(393,26,'_wc_order_attribution_session_entry','http://store.local/shop/'),
(394,26,'_wc_order_attribution_session_start_time','2026-10-18 10:26:53'),
(395,26,'_wc_order_attribution_session_pages','8'),
(396,26,'_wc_order_attribution_session_count','1'),
(397,26,'_wc_order_attribution_user_agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36'),
(398,26,'_wc_order_attribution_device_type','Desktop'),
(399,26,'_payment_method','cod'),
(400,26,'_payment_method_title','Cash on delivery'),
(401,27,'_wp_attached_file','2026/10/headphones.jpg'),
(402,27,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:533;s:4:\"file\";s:22:\"2026/10/headphones.jpg\";s:8:\"filesize\";i:47260;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:22:\"headphones-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:9785;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:22:\"headphones-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6857;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:22:\"headphones-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:31641;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:22:\"headphones-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:14066;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:22:\"headphones-416x277.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:277;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:13898;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:22:\"headphones-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:5436;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(403,10,'_thumbnail_id','27'),
(404,28,'_wp_attached_file','2026/10/prod_24.jpg'),
(405,28,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:1200;s:4:\"file\";s:19:\"2026/10/prod_24.jpg\";s:8:\"filesize\";i:76260;s:5:\"sizes\";a:7:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_24-200x300.jpg\";s:5:\"width\";i:200;s:6:\"height\";i:300;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:7727;}s:5:\"large\";a:5:{s:4:\"file\";s:20:\"prod_24-683x1024.jpg\";s:5:\"width\";i:683;s:6:\"height\";i:1024;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:37556;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_24-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:5871;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:20:\"prod_24-768x1152.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:1152;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:46570;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_24-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:11426;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_24-416x624.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:624;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:17162;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_24-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:4898;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(406,24,'_thumbnail_id','28'),
(407,29,'_wp_attached_file','2026/10/prod_21.jpg'),
(408,29,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:533;s:4:\"file\";s:19:\"2026/10/prod_21.jpg\";s:8:\"filesize\";i:93651;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_21-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:15519;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_21-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:9117;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:19:\"prod_21-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:62010;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_21-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:24737;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_21-416x277.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:277;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:24318;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_21-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6407;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(409,21,'_thumbnail_id','29'),
(410,30,'_wp_attached_file','2026/10/prod_19.jpg'),
(411,30,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:533;s:4:\"file\";s:19:\"2026/10/prod_19.jpg\";s:8:\"filesize\";i:93651;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_19-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:15519;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_19-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:9117;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:19:\"prod_19-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:62010;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_19-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:24737;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_19-416x277.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:277;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:24318;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_19-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6407;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(412,19,'_thumbnail_id','30'),
(413,31,'_wp_attached_file','2026/10/prod_12.jpg'),
(414,31,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:533;s:4:\"file\";s:19:\"2026/10/prod_12.jpg\";s:8:\"filesize\";i:18631;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_12-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6210;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_12-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:5061;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:19:\"prod_12-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:14285;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_12-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:8135;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_12-416x277.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:277;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:7886;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_12-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:4431;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(415,12,'_thumbnail_id','31'),
(416,32,'_wp_attached_file','2026/10/prod_13.jpg'),
(417,32,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:533;s:4:\"file\";s:19:\"2026/10/prod_13.jpg\";s:8:\"filesize\";i:90963;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_13-300x200.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:200;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:16915;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_13-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:9690;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:19:\"prod_13-768x512.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:512;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:61311;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_13-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:23719;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_13-416x277.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:277;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:25862;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_13-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6759;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(418,13,'_thumbnail_id','32'),
(419,33,'_wp_attached_file','2026/10/prod_11.jpg'),
(420,33,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:536;s:4:\"file\";s:19:\"2026/10/prod_11.jpg\";s:8:\"filesize\";i:81550;s:5:\"sizes\";a:6:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_11-300x201.jpg\";s:5:\"width\";i:300;s:6:\"height\";i:201;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:13044;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_11-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:7446;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:19:\"prod_11-768x515.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:515;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:54404;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_11-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:19173;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_11-416x279.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:279;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:20389;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_11-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:5419;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(421,11,'_thumbnail_id','33'),
(422,34,'_wp_attached_file','2026/10/prod_14.jpg'),
(423,34,'_wp_attachment_metadata','a:6:{s:5:\"width\";i:800;s:6:\"height\";i:1200;s:4:\"file\";s:19:\"2026/10/prod_14.jpg\";s:8:\"filesize\";i:75428;s:5:\"sizes\";a:7:{s:6:\"medium\";a:5:{s:4:\"file\";s:19:\"prod_14-200x300.jpg\";s:5:\"width\";i:200;s:6:\"height\";i:300;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:8272;}s:5:\"large\";a:5:{s:4:\"file\";s:20:\"prod_14-683x1024.jpg\";s:5:\"width\";i:683;s:6:\"height\";i:1024;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:39696;}s:9:\"thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_14-150x150.jpg\";s:5:\"width\";i:150;s:6:\"height\";i:150;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:6148;}s:12:\"medium_large\";a:5:{s:4:\"file\";s:20:\"prod_14-768x1152.jpg\";s:5:\"width\";i:768;s:6:\"height\";i:1152;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:48198;}s:21:\"woocommerce_thumbnail\";a:6:{s:4:\"file\";s:19:\"prod_14-324x324.jpg\";s:5:\"width\";i:324;s:6:\"height\";i:324;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:12102;s:9:\"uncropped\";b:0;}s:18:\"woocommerce_single\";a:5:{s:4:\"file\";s:19:\"prod_14-416x624.jpg\";s:5:\"width\";i:416;s:6:\"height\";i:624;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:18748;}s:29:\"woocommerce_gallery_thumbnail\";a:5:{s:4:\"file\";s:19:\"prod_14-100x100.jpg\";s:5:\"width\";i:100;s:6:\"height\";i:100;s:9:\"mime-type\";s:10:\"image/jpeg\";s:8:\"filesize\";i:4959;}}s:10:\"image_meta\";a:12:{s:8:\"aperture\";s:1:\"0\";s:6:\"credit\";s:0:\"\";s:6:\"camera\";s:0:\"\";s:7:\"caption\";s:0:\"\";s:17:\"created_timestamp\";s:1:\"0\";s:9:\"copyright\";s:0:\"\";s:12:\"focal_length\";s:1:\"0\";s:3:\"iso\";s:1:\"0\";s:13:\"shutter_speed\";s:1:\"0\";s:5:\"title\";s:0:\"\";s:11:\"orientation\";s:1:\"0\";s:8:\"keywords\";a:0:{}}}'),
(424,14,'_thumbnail_id','34'),
(425,35,'_menu_item_type','post_type'),
(426,35,'_menu_item_menu_item_parent','0'),
(427,35,'_menu_item_object_id','5'),
(428,35,'_menu_item_object','page'),
(429,35,'_menu_item_target',''),
(430,35,'_menu_item_classes','a:1:{i:0;s:0:\"\";}'),
(431,35,'_menu_item_xfn',''),
(432,35,'_menu_item_url',''),
(433,36,'_menu_item_type','post_type'),
(434,36,'_menu_item_menu_item_parent','0'),
(435,36,'_menu_item_object_id','6'),
(436,36,'_menu_item_object','page'),
(437,36,'_menu_item_target',''),
(438,36,'_menu_item_classes','a:1:{i:0;s:0:\"\";}'),
(439,36,'_menu_item_xfn',''),
(440,36,'_menu_item_url',''),
(441,37,'_menu_item_type','post_type'),
(442,37,'_menu_item_menu_item_parent','0'),
(443,37,'_menu_item_object_id','7'),
(444,37,'_menu_item_object','page'),
(445,37,'_menu_item_target',''),
(446,37,'_menu_item_classes','a:1:{i:0;s:0:\"\";}'),
(447,37,'_menu_item_xfn',''),
(448,37,'_menu_item_url',''),
(449,23,'_thumbnail_id','34'),
(450,38,'_order_key','wc_order_rWn71Uxlp1Emj'),
(451,38,'_customer_user','0'),
(452,38,'_customer_ip_address','172.18.0.1'),
(453,38,'_customer_user_agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36'),
(454,38,'_created_via','store-api'),
(455,38,'_cart_hash','59e5801e6ce778c477fe81cba232c216'),
(456,38,'_download_permissions_granted','yes'),
(457,38,'_recorded_sales','yes'),
(458,38,'_recorded_coupon_usage_counts','yes'),
(459,38,'_new_order_email_sent','true'),
(460,38,'_order_stock_reduced','yes'),
(461,38,'_billing_first_name','Uttkarsh'),
(462,38,'_billing_last_name','home'),
(463,38,'_billing_address_1','sec 2/462 ,chiranjeev vihar'),
(464,38,'_billing_city','ghaziabad'),
(465,38,'_billing_state','UP'),
(466,38,'_billing_postcode','201002'),
(467,38,'_billing_country','IN'),
(468,38,'_billing_email','uttkarsh2003.solanki@gmail.com'),
(469,38,'_billing_phone','+919990766708'),
(470,38,'_shipping_first_name','Uttkarsh'),
(471,38,'_shipping_last_name','home'),
(472,38,'_shipping_address_1','sec 2/462 ,chiranjeev vihar'),
(473,38,'_shipping_city','ghaziabad'),
(474,38,'_shipping_state','UP'),
(475,38,'_shipping_postcode','201002'),
(476,38,'_shipping_country','IN'),
(477,38,'_shipping_phone','+919990766708'),
(478,38,'_order_currency','USD'),
(479,38,'_cart_discount','0'),
(480,38,'_cart_discount_tax','0'),
(481,38,'_order_shipping','0'),
(482,38,'_order_shipping_tax','0'),
(483,38,'_order_tax','0'),
(484,38,'_order_total','105.00'),
(485,38,'_order_version','9.3.3'),
(486,38,'_prices_include_tax','no'),
(487,38,'_billing_address_index','Uttkarsh home  sec 2/462 ,chiranjeev vihar  ghaziabad UP 201002 IN uttkarsh2003.solanki@gmail.com +919990766708'),
(488,38,'_shipping_address_index','Uttkarsh home  sec 2/462 ,chiranjeev vihar  ghaziabad UP 201002 IN +919990766708'),
(489,38,'_shipping_hash','9d4568c009d203ab10e33ea9953a0264'),
(490,38,'_coupons_hash','d751713988987e9331980363e24189ce'),
(491,38,'_fees_hash','d751713988987e9331980363e24189ce'),
(492,38,'_taxes_hash','d751713988987e9331980363e24189ce'),
(493,38,'is_vat_exempt','no'),
(494,38,'_wc_order_attribution_source_type','typein'),
(495,38,'_wc_order_attribution_utm_source','(direct)'),
(496,38,'_wc_order_attribution_session_entry','http://store.local/'),
(497,38,'_wc_order_attribution_session_start_time','2026-10-19 13:41:20'),
(498,38,'_wc_order_attribution_session_pages','10'),
(499,38,'_wc_order_attribution_session_count','1'),
(500,38,'_wc_order_attribution_user_agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36'),
(501,38,'_wc_order_attribution_device_type','Desktop'),
(502,38,'_payment_method','cod'),
(503,38,'_payment_method_title','Cash on delivery'),
(504,39,'_order_key','wc_order_ucbUYZ2elUtrI'),
(505,39,'_customer_user','0'),
(506,39,'_payment_method','cod'),
(507,39,'_payment_method_title','Cash on delivery'),
(508,39,'_created_via','rest-api'),
(509,39,'_download_permissions_granted','yes'),
(510,39,'_recorded_sales','yes'),
(511,39,'_recorded_coupon_usage_counts','yes'),
(512,39,'_new_order_email_sent','true'),
(513,39,'_order_stock_reduced','yes'),
(514,39,'_billing_first_name','Test'),
(515,39,'_billing_last_name','User'),
(516,39,'_billing_email','shopper@example.com'),
(517,39,'_order_currency','USD'),
(518,39,'_cart_discount','0'),
(519,39,'_cart_discount_tax','0'),
(520,39,'_order_shipping','0'),
(521,39,'_order_shipping_tax','0'),
(522,39,'_order_tax','0'),
(523,39,'_order_total','199.99'),
(524,39,'_order_version','9.3.3'),
(525,39,'_prices_include_tax','no'),
(526,39,'_billing_address_index','Test User        shopper@example.com '),
(527,39,'_shipping_address_index','         '),
(528,40,'_sku','SKU-CHAIR-01'),
(529,40,'_regular_price','249.99'),
(530,40,'total_sales','0'),
(531,40,'_tax_status','taxable'),
(532,40,'_tax_class',''),
(533,40,'_manage_stock','yes'),
(534,40,'_backorders','no'),
(535,40,'_sold_individually','no'),
(536,40,'_virtual','no'),
(537,40,'_downloadable','no'),
(538,40,'_download_limit','-1'),
(539,40,'_download_expiry','-1'),
(540,40,'_stock','15'),
(541,40,'_stock_status','instock'),
(542,40,'_wc_average_rating','0'),
(543,40,'_wc_review_count','0'),
(544,40,'_product_version','9.3.3'),
(545,40,'_price','249.99'),
(546,39,'_date_completed','1792425886'),
(547,39,'_date_paid','1792425886'),
(548,39,'_paid_date','2026-10-19 16:04:46'),
(549,39,'_completed_date','2026-10-19 16:04:46'),
(550,41,'_sku','SKU-CAM-4K'),
(551,41,'_regular_price','129.99'),
(552,41,'total_sales','0'),
(553,41,'_tax_status','taxable'),
(554,41,'_tax_class',''),
(555,41,'_manage_stock','yes'),
(556,41,'_backorders','no'),
(557,41,'_sold_individually','no'),
(558,41,'_virtual','no'),
(559,41,'_downloadable','no'),
(560,41,'_download_limit','-1'),
(561,41,'_download_expiry','-1'),
(562,41,'_stock','25'),
(563,41,'_stock_status','instock'),
(564,41,'_wc_average_rating','0'),
(565,41,'_wc_review_count','0'),
(566,41,'_product_version','9.3.3'),
(567,41,'_price','129.99');
/*!40000 ALTER TABLE `wp_postmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_posts`
--

DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT 0,
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(255) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT 0,
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_posts`
--

LOCK TABLES `wp_posts` WRITE;
/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;
INSERT INTO `wp_posts` VALUES
(1,1,'2026-10-18 07:52:45','2026-10-18 07:52:45','<!-- wp:paragraph -->\n<p>Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n<!-- /wp:paragraph -->','Hello world!','','publish','open','open','','hello-world','','','2026-10-18 07:52:45','2026-10-18 07:52:45','',0,'http://store.local/?p=1',0,'post','',1),
(3,1,'2026-10-18 07:52:45','2026-10-18 07:52:45','<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we are</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Our website address is: http://store.local.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Comments</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>When visitors leave comments on the site we collect the data shown in the comments form, and also the visitor&#8217;s IP address and browser user agent string to help spam detection.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>An anonymized string created from your email address (also called a hash) may be provided to the Gravatar service to see if you are using it. The Gravatar service privacy policy is available here: https://automattic.com/privacy/. After approval of your comment, your profile picture is visible to the public in the context of your comment.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Media</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you upload images to the website, you should avoid uploading images with embedded location data (EXIF GPS) included. Visitors to the website can download and extract any location data from images on the website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Cookies</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment on our site you may opt-in to saving your name, email address and website in cookies. These are for your convenience so that you do not have to fill in your details again when you leave another comment. These cookies will last for one year.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you visit our login page, we will set a temporary cookie to determine if your browser accepts cookies. This cookie contains no personal data and is discarded when you close your browser.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>When you log in, we will also set up several cookies to save your login information and your screen display choices. Login cookies last for two days, and screen options cookies last for a year. If you select &quot;Remember Me&quot;, your login will persist for two weeks. If you log out of your account, the login cookies will be removed.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you edit or publish an article, an additional cookie will be saved in your browser. This cookie includes no personal data and simply indicates the post ID of the article you just edited. It expires after 1 day.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Embedded content from other websites</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Articles on this site may include embedded content (e.g. videos, images, articles, etc.). Embedded content from other websites behaves in the exact same way as if the visitor has visited the other website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>These websites may collect data about you, use cookies, embed additional third-party tracking, and monitor your interaction with that embedded content, including tracking your interaction with the embedded content if you have an account and are logged in to that website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we share your data with</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you request a password reset, your IP address will be included in the reset email.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">How long we retain your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment, the comment and its metadata are retained indefinitely. This is so we can recognize and approve any follow-up comments automatically instead of holding them in a moderation queue.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>For users that register on our website (if any), we also store the personal information they provide in their user profile. All users can see, edit, or delete their personal information at any time (except they cannot change their username). Website administrators can also see and edit that information.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">What rights you have over your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you have an account on this site, or have left comments, you can request to receive an exported file of the personal data we hold about you, including any data you have provided to us. You can also request that we erase any personal data we hold about you. This does not include any data we are obliged to keep for administrative, legal, or security purposes.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Where your data is sent</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Visitor comments may be checked through an automated spam detection service.</p>\n<!-- /wp:paragraph -->\n','Privacy Policy','','draft','closed','open','','privacy-policy','','','2026-10-18 07:52:45','2026-10-18 07:52:45','',0,'http://store.local/?page_id=3',0,'page','',0),
(4,0,'2026-10-18 07:53:16','2026-10-18 07:53:16','','woocommerce-placeholder','','inherit','open','closed','','woocommerce-placeholder','','','2026-10-18 07:53:16','2026-10-18 07:53:16','',0,'http://store.local/wp-content/uploads/2026/10/woocommerce-placeholder.png',0,'attachment','image/png',0),
(5,1,'2026-10-18 07:53:17','2026-10-18 07:53:17','','Shop','','publish','closed','closed','','shop','','','2026-10-18 07:53:17','2026-10-18 07:53:17','',0,'http://store.local/shop/',0,'page','',0),
(6,1,'2026-10-18 07:53:17','2026-10-18 07:53:17','<!-- wp:woocommerce/cart -->\n<div class=\"wp-block-woocommerce-cart alignwide is-loading\"><!-- wp:woocommerce/filled-cart-block -->\n<div class=\"wp-block-woocommerce-filled-cart-block\"><!-- wp:woocommerce/cart-items-block -->\n<div class=\"wp-block-woocommerce-cart-items-block\"><!-- wp:woocommerce/cart-line-items-block -->\n<div class=\"wp-block-woocommerce-cart-line-items-block\"></div>\n<!-- /wp:woocommerce/cart-line-items-block -->\n\n<!-- wp:woocommerce/cart-cross-sells-block -->\n<div class=\"wp-block-woocommerce-cart-cross-sells-block\"><!-- wp:heading {\"fontSize\":\"large\"} -->\n<h2 class=\"wp-block-heading has-large-font-size\">You may be interested in…</h2>\n<!-- /wp:heading -->\n\n<!-- wp:woocommerce/cart-cross-sells-products-block -->\n<div class=\"wp-block-woocommerce-cart-cross-sells-products-block\"></div>\n<!-- /wp:woocommerce/cart-cross-sells-products-block --></div>\n<!-- /wp:woocommerce/cart-cross-sells-block --></div>\n<!-- /wp:woocommerce/cart-items-block -->\n\n<!-- wp:woocommerce/cart-totals-block -->\n<div class=\"wp-block-woocommerce-cart-totals-block\"><!-- wp:woocommerce/cart-order-summary-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-block\"><!-- wp:woocommerce/cart-order-summary-heading-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-heading-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-heading-block -->\n\n<!-- wp:woocommerce/cart-order-summary-coupon-form-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-coupon-form-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-coupon-form-block -->\n\n<!-- wp:woocommerce/cart-order-summary-subtotal-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-subtotal-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-subtotal-block -->\n\n<!-- wp:woocommerce/cart-order-summary-fee-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-fee-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-fee-block -->\n\n<!-- wp:woocommerce/cart-order-summary-discount-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-discount-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-discount-block -->\n\n<!-- wp:woocommerce/cart-order-summary-shipping-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-shipping-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-shipping-block -->\n\n<!-- wp:woocommerce/cart-order-summary-taxes-block -->\n<div class=\"wp-block-woocommerce-cart-order-summary-taxes-block\"></div>\n<!-- /wp:woocommerce/cart-order-summary-taxes-block --></div>\n<!-- /wp:woocommerce/cart-order-summary-block -->\n\n<!-- wp:woocommerce/cart-express-payment-block -->\n<div class=\"wp-block-woocommerce-cart-express-payment-block\"></div>\n<!-- /wp:woocommerce/cart-express-payment-block -->\n\n<!-- wp:woocommerce/proceed-to-checkout-block -->\n<div class=\"wp-block-woocommerce-proceed-to-checkout-block\"></div>\n<!-- /wp:woocommerce/proceed-to-checkout-block -->\n\n<!-- wp:woocommerce/cart-accepted-payment-methods-block -->\n<div class=\"wp-block-woocommerce-cart-accepted-payment-methods-block\"></div>\n<!-- /wp:woocommerce/cart-accepted-payment-methods-block --></div>\n<!-- /wp:woocommerce/cart-totals-block --></div>\n<!-- /wp:woocommerce/filled-cart-block -->\n\n<!-- wp:woocommerce/empty-cart-block -->\n<div class=\"wp-block-woocommerce-empty-cart-block\"><!-- wp:heading {\"textAlign\":\"center\",\"className\":\"with-empty-cart-icon wc-block-cart__empty-cart__title\"} -->\n<h2 class=\"wp-block-heading has-text-align-center with-empty-cart-icon wc-block-cart__empty-cart__title\">Your cart is currently empty!</h2>\n<!-- /wp:heading -->\n\n<!-- wp:separator {\"className\":\"is-style-dots\"} -->\n<hr class=\"wp-block-separator has-alpha-channel-opacity is-style-dots\"/>\n<!-- /wp:separator -->\n\n<!-- wp:heading {\"textAlign\":\"center\"} -->\n<h2 class=\"wp-block-heading has-text-align-center\">New in store</h2>\n<!-- /wp:heading -->\n\n<!-- wp:woocommerce/product-new {\"columns\":4,\"rows\":1} /--></div>\n<!-- /wp:woocommerce/empty-cart-block --></div>\n<!-- /wp:woocommerce/cart -->','Cart','','publish','closed','closed','','cart','','','2026-10-18 07:53:17','2026-10-18 07:53:17','',0,'http://store.local/cart/',0,'page','',0),
(7,1,'2026-10-18 07:53:17','2026-10-18 07:53:17','<!-- wp:woocommerce/checkout -->\n<div class=\"wp-block-woocommerce-checkout alignwide wc-block-checkout is-loading\"><!-- wp:woocommerce/checkout-fields-block -->\n<div class=\"wp-block-woocommerce-checkout-fields-block\"><!-- wp:woocommerce/checkout-express-payment-block -->\n<div class=\"wp-block-woocommerce-checkout-express-payment-block\"></div>\n<!-- /wp:woocommerce/checkout-express-payment-block -->\n\n<!-- wp:woocommerce/checkout-contact-information-block -->\n<div class=\"wp-block-woocommerce-checkout-contact-information-block\"></div>\n<!-- /wp:woocommerce/checkout-contact-information-block -->\n\n<!-- wp:woocommerce/checkout-shipping-method-block -->\n<div class=\"wp-block-woocommerce-checkout-shipping-method-block\"></div>\n<!-- /wp:woocommerce/checkout-shipping-method-block -->\n\n<!-- wp:woocommerce/checkout-pickup-options-block -->\n<div class=\"wp-block-woocommerce-checkout-pickup-options-block\"></div>\n<!-- /wp:woocommerce/checkout-pickup-options-block -->\n\n<!-- wp:woocommerce/checkout-shipping-address-block -->\n<div class=\"wp-block-woocommerce-checkout-shipping-address-block\"></div>\n<!-- /wp:woocommerce/checkout-shipping-address-block -->\n\n<!-- wp:woocommerce/checkout-billing-address-block -->\n<div class=\"wp-block-woocommerce-checkout-billing-address-block\"></div>\n<!-- /wp:woocommerce/checkout-billing-address-block -->\n\n<!-- wp:woocommerce/checkout-shipping-methods-block -->\n<div class=\"wp-block-woocommerce-checkout-shipping-methods-block\"></div>\n<!-- /wp:woocommerce/checkout-shipping-methods-block -->\n\n<!-- wp:woocommerce/checkout-payment-block -->\n<div class=\"wp-block-woocommerce-checkout-payment-block\"></div>\n<!-- /wp:woocommerce/checkout-payment-block -->\n\n<!-- wp:woocommerce/checkout-additional-information-block -->\n<div class=\"wp-block-woocommerce-checkout-additional-information-block\"></div>\n<!-- /wp:woocommerce/checkout-additional-information-block -->\n\n<!-- wp:woocommerce/checkout-order-note-block -->\n<div class=\"wp-block-woocommerce-checkout-order-note-block\"></div>\n<!-- /wp:woocommerce/checkout-order-note-block -->\n\n<!-- wp:woocommerce/checkout-terms-block -->\n<div class=\"wp-block-woocommerce-checkout-terms-block\"></div>\n<!-- /wp:woocommerce/checkout-terms-block -->\n\n<!-- wp:woocommerce/checkout-actions-block -->\n<div class=\"wp-block-woocommerce-checkout-actions-block\"></div>\n<!-- /wp:woocommerce/checkout-actions-block --></div>\n<!-- /wp:woocommerce/checkout-fields-block -->\n\n<!-- wp:woocommerce/checkout-totals-block -->\n<div class=\"wp-block-woocommerce-checkout-totals-block\"><!-- wp:woocommerce/checkout-order-summary-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-block\"><!-- wp:woocommerce/checkout-order-summary-cart-items-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-cart-items-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-cart-items-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-coupon-form-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-coupon-form-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-coupon-form-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-subtotal-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-subtotal-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-subtotal-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-fee-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-fee-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-fee-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-discount-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-discount-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-discount-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-shipping-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-shipping-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-shipping-block -->\n\n<!-- wp:woocommerce/checkout-order-summary-taxes-block -->\n<div class=\"wp-block-woocommerce-checkout-order-summary-taxes-block\"></div>\n<!-- /wp:woocommerce/checkout-order-summary-taxes-block --></div>\n<!-- /wp:woocommerce/checkout-order-summary-block --></div>\n<!-- /wp:woocommerce/checkout-totals-block --></div>\n<!-- /wp:woocommerce/checkout -->','Checkout','','publish','closed','closed','','checkout','','','2026-10-18 07:53:17','2026-10-18 07:53:17','',0,'http://store.local/checkout/',0,'page','',0),
(8,1,'2026-10-18 07:53:17','2026-10-18 07:53:17','<!-- wp:shortcode -->[woocommerce_my_account]<!-- /wp:shortcode -->','My account','','publish','closed','closed','','my-account','','','2026-10-18 07:53:17','2026-10-18 07:53:17','',0,'http://store.local/my-account/',0,'page','',0),
(9,1,'2026-10-18 07:53:17','0000-00-00 00:00:00','<!-- wp:paragraph -->\n<p><b>This is a sample page.</b></p>\n<!-- /wp:paragraph -->\n\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Overview</h2>\n<!-- /wp:heading -->\n\n<!-- wp:paragraph -->\n<p>Our refund and returns policy lasts 30 days. If 30 days have passed since your purchase, we can’t offer you a full refund or exchange.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>To be eligible for a return, your item must be unused and in the same condition that you received it. It must also be in the original packaging.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Several types of goods are exempt from being returned. Perishable goods such as food, flowers, newspapers or magazines cannot be returned. We also do not accept products that are intimate or sanitary goods, hazardous materials, or flammable liquids or gases.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Additional non-returnable items:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:list -->\n<ul>\n<li>Gift cards</li>\n<li>Downloadable software products</li>\n<li>Some health and personal care items</li>\n</ul>\n<!-- /wp:list -->\n\n<!-- wp:paragraph -->\n<p>To complete your return, we require a receipt or proof of purchase.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Please do not send your purchase back to the manufacturer.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>There are certain situations where only partial refunds are granted:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:list -->\n<ul>\n<li>Book with obvious signs of use</li>\n<li>CD, DVD, VHS tape, software, video game, cassette tape, or vinyl record that has been opened.</li>\n<li>Any item not in its original condition, is damaged or missing parts for reasons not due to our error.</li>\n<li>Any item that is returned more than 30 days after delivery</li>\n</ul>\n<!-- /wp:list -->\n\n<!-- wp:paragraph -->\n<h2>Refunds</h2>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Once your return is received and inspected, we will send you an email to notify you that we have received your returned item. We will also notify you of the approval or rejection of your refund.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>If you are approved, then your refund will be processed, and a credit will automatically be applied to your credit card or original method of payment, within a certain amount of days.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:heading -->\n<h3 class=\"wp-block-heading\">Late or missing refunds</h3>\n<!-- /wp:heading -->\n\n<!-- wp:paragraph -->\n<p>If you haven’t received a refund yet, first check your bank account again.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Then contact your credit card company, it may take some time before your refund is officially posted.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Next contact your bank. There is often some processing time before a refund is posted.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>If you’ve done all of this and you still have not received your refund yet, please contact us at {email address}.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:heading -->\n<h3 class=\"wp-block-heading\">Sale items</h3>\n<!-- /wp:heading -->\n\n<!-- wp:paragraph -->\n<p>Only regular priced items may be refunded. Sale items cannot be refunded.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<h2>Exchanges</h2>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>We only replace items if they are defective or damaged. If you need to exchange it for the same item, send us an email at {email address} and send your item to: {physical address}.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<h2>Gifts</h2>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>If the item was marked as a gift when purchased and shipped directly to you, you’ll receive a gift credit for the value of your return. Once the returned item is received, a gift certificate will be mailed to you.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>If the item wasn’t marked as a gift when purchased, or the gift giver had the order shipped to themselves to give to you later, we will send a refund to the gift giver and they will find out about your return.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<h2>Shipping returns</h2>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>To return your product, you should mail your product to: {physical address}.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>You will be responsible for paying for your own shipping costs for returning your item. Shipping costs are non-refundable. If you receive a refund, the cost of return shipping will be deducted from your refund.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Depending on where you live, the time it may take for your exchanged product to reach you may vary.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>If you are returning more expensive items, you may consider using a trackable shipping service or purchasing shipping insurance. We don’t guarantee that we will receive your returned item.</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<h2>Need help?</h2>\n<!-- /wp:paragraph -->\n\n<!-- wp:paragraph -->\n<p>Contact us at {email} for questions related to refunds and returns.</p>\n<!-- /wp:paragraph -->','Refund and Returns Policy','','draft','closed','closed','','refund_returns','','','2026-10-18 07:53:17','0000-00-00 00:00:00','',0,'http://store.local/?page_id=9',0,'page','',0),
(10,0,'2026-10-18 08:00:52','2026-10-18 08:00:52','Active noise canceling studio headphones with 40h battery.','Premium Wireless Headphones','','publish','open','closed','','premium-wireless-headphones','','','2026-10-20 13:49:47','2026-10-20 13:49:47','',0,'http://store.local/product/premium-wireless-headphones/',0,'product','',0),
(11,0,'2026-10-18 08:00:52','2026-10-18 08:00:52','Custom mechanical switches with hot-swappable RGB PCB.','Ergonomic Mechanical Keyboard','','publish','open','closed','','ergonomic-mechanical-keyboard','','','2026-10-18 08:00:55','2026-10-18 08:00:55','',0,'http://store.local/product/ergonomic-mechanical-keyboard/',0,'product','',0),
(12,0,'2026-10-18 08:00:52','2026-10-18 08:00:52','144Hz 1ms curved IPS display with HDR600.','Ultra-Wide Gaming Monitor 34\"','','publish','open','closed','','ultra-wide-gaming-monitor-34','','','2026-10-18 08:00:52','2026-10-18 08:00:52','',0,'http://store.local/product/ultra-wide-gaming-monitor-34/',0,'product','',0),
(13,0,'2026-10-18 08:00:52','2026-10-18 08:00:52','7-in-1 aluminium hub with HDMI 4K and 100W PD.','USB-C Multi-Port Hub','','publish','open','closed','','usb-c-multi-port-hub','','','2026-10-19 16:25:15','2026-10-19 16:25:15','',0,'http://store.local/product/usb-c-multi-port-hub/',0,'product','',0),
(14,0,'2026-10-18 08:00:52','2026-10-18 08:00:52','Cardioid condenser microphone with boom arm.','Noise Cancelling Microphone','','publish','open','closed','','noise-cancelling-microphone','','','2026-10-18 08:00:52','2026-10-18 08:00:52','',0,'http://store.local/product/noise-cancelling-microphone/',0,'product','',0),
(15,1,'2026-10-18 08:00:54','2026-10-18 08:00:54','','Order &ndash; October 18, 2026 @ 08:00 AM','','wc-processing','open','closed','wc_order_NYb761OgVYJGJ','order-oct-18-2026-0800-am','','','2026-10-18 08:00:54','2026-10-18 08:00:54','',0,'http://store.local/?post_type=shop_order&#038;p=15',0,'shop_order','',2),
(16,1,'2026-10-18 08:00:55','2026-10-18 08:00:55','','Order &ndash; October 18, 2026 @ 08:00 AM','','wc-completed','open','closed','wc_order_gmwIVIZKs1Fmc','order-oct-18-2026-0800-am-2','','','2026-10-18 08:00:55','2026-10-18 08:00:55','',0,'http://store.local/?post_type=shop_order&#038;p=16',0,'shop_order','',2),
(17,1,'2026-10-18 08:00:55','2026-10-18 08:00:55','','Order &ndash; October 18, 2026 @ 08:00 AM','','wc-pending','open','closed','wc_order_VslllYBxq1RRh','order-oct-18-2026-0800-am-3','','','2026-10-18 08:00:55','2026-10-18 08:00:55','',0,'http://store.local/?post_type=shop_order&#038;p=17',0,'shop_order','',0),
(18,0,'2026-10-18 08:05:18','2026-10-18 08:05:18','<!-- wp:page-list /-->','Navigation','','publish','closed','closed','','navigation','','','2026-10-18 08:05:18','2026-10-18 08:05:18','',0,'http://store.local/navigation/',0,'wp_navigation','',0),
(19,1,'2026-10-18 08:20:44','2026-10-18 08:20:44','Created dynamically during Step 1 verification test.','Dynamic Studio Mic Boom','','publish','open','closed','','dynamic-studio-mic-boom','','','2026-10-18 08:20:45','2026-10-18 08:20:45','',0,'https://store.local/product/dynamic-studio-mic-boom/',0,'product','',0),
(20,1,'2026-10-18 08:20:44','2026-10-18 08:20:44','','Order &ndash; October 18, 2026 @ 08:20 AM','','wc-completed','open','closed','wc_order_LA4EIUhk4aheP','order-oct-18-2026-0820-am','','','2026-10-18 08:20:45','2026-10-18 08:20:45','',0,'https://store.local/?post_type=shop_order&#038;p=20',0,'shop_order','',2),
(21,1,'2026-10-18 08:21:16','2026-10-18 08:21:16','Created dynamically during Step 1 verification test.','Dynamic Studio Mic Boom','','publish','open','closed','','dynamic-studio-mic-boom-2','','','2026-10-18 10:57:41','2026-10-18 10:57:41','',0,'https://store.local/product/dynamic-studio-mic-boom-2/',0,'product','',0),
(22,1,'2026-10-18 08:21:17','2026-10-18 08:21:17','','Order &ndash; October 18, 2026 @ 08:21 AM','','wc-completed','open','closed','wc_order_Z1KGvmjXr76ok','order-oct-18-2026-0821-am','','','2026-10-18 08:21:17','2026-10-18 08:21:17','',0,'https://store.local/?post_type=shop_order&#038;p=22',0,'shop_order','',2),
(23,1,'2026-10-18 08:31:39','2026-10-18 08:31:39','Created via FastMCP client during automated test suite.','Phase 2 Automated Test Mic','','publish','open','closed','','phase-2-automated-test-mic','','','2026-10-18 08:31:39','2026-10-18 08:31:39','',0,'https://store.local/product/phase-2-automated-test-mic/',0,'product','',0),
(24,1,'2026-10-18 10:36:31','2026-10-18 10:36:31','High-quality ergonomic desk mat for comfortable work surface.','Ergonomic Desk Mat','','publish','open','closed','','ergonomic-desk-mat','','','2026-10-19 14:18:13','2026-10-19 14:18:13','',0,'https://store.local/product/ergonomic-desk-mat/',0,'product','',0),
(25,1,'2026-10-18 10:51:41','2026-10-18 10:51:41','','Order &ndash; October 18, 2026 @ 10:51 AM','','wc-processing','open','closed','wc_order_QDRgdI8MtEA5R','order-oct-18-2026-1051-am','','','2026-10-18 10:51:41','2026-10-18 10:51:41','',0,'https://store.local/?post_type=shop_order&#038;p=25',0,'shop_order','',2),
(26,1,'2026-10-18 10:57:23','2026-10-18 10:57:23','','Order &ndash; October 18, 2026 @ 10:57 AM','','wc-processing','open','closed','wc_order_v2H24m8KaZQii','order-oct-18-2026-1057-am','','','2026-10-18 10:57:41','2026-10-18 10:57:41','',0,'http://store.local/?post_type=shop_order&#038;p=26',0,'shop_order','',4),
(27,0,'2026-10-18 11:02:15','2026-10-18 11:02:15','','headphones','','inherit','open','closed','','headphones','','','2026-10-18 11:02:15','2026-10-18 11:02:15','',10,'http://store.local/wp-content/uploads/2026/10/headphones.jpg',0,'attachment','image/jpeg',0),
(28,0,'2026-10-18 11:02:55','2026-10-18 11:02:55','','prod_24','','inherit','open','closed','','prod_24','','','2026-10-18 11:02:55','2026-10-18 11:02:55','',24,'http://store.local/wp-content/uploads/2026/10/prod_24.jpg',0,'attachment','image/jpeg',0),
(29,0,'2026-10-18 11:02:59','2026-10-18 11:02:59','','prod_21','','inherit','open','closed','','prod_21','','','2026-10-18 11:02:59','2026-10-18 11:02:59','',21,'http://store.local/wp-content/uploads/2026/10/prod_21.jpg',0,'attachment','image/jpeg',0),
(30,0,'2026-10-18 11:03:01','2026-10-18 11:03:01','','prod_19','','inherit','open','closed','','prod_19','','','2026-10-18 11:03:01','2026-10-18 11:03:01','',19,'http://store.local/wp-content/uploads/2026/10/prod_19.jpg',0,'attachment','image/jpeg',0),
(31,0,'2026-10-18 11:03:04','2026-10-18 11:03:04','','prod_12','','inherit','open','closed','','prod_12','','','2026-10-18 11:03:04','2026-10-18 11:03:04','',12,'http://store.local/wp-content/uploads/2026/10/prod_12.jpg',0,'attachment','image/jpeg',0),
(32,0,'2026-10-18 11:03:06','2026-10-18 11:03:06','','prod_13','','inherit','open','closed','','prod_13','','','2026-10-18 11:03:06','2026-10-18 11:03:06','',13,'http://store.local/wp-content/uploads/2026/10/prod_13.jpg',0,'attachment','image/jpeg',0),
(33,0,'2026-10-18 11:03:09','2026-10-18 11:03:09','','prod_11','','inherit','open','closed','','prod_11','','','2026-10-18 11:03:09','2026-10-18 11:03:09','',11,'http://store.local/wp-content/uploads/2026/10/prod_11.jpg',0,'attachment','image/jpeg',0),
(34,0,'2026-10-18 11:03:10','2026-10-18 11:03:10','','prod_14','','inherit','open','closed','','prod_14','','','2026-10-18 11:03:10','2026-10-18 11:03:10','',14,'http://store.local/wp-content/uploads/2026/10/prod_14.jpg',0,'attachment','image/jpeg',0),
(35,0,'2026-10-18 11:05:51','2026-10-18 11:05:51',' ','','','publish','closed','closed','','35','','','2026-10-18 11:05:51','2026-10-18 11:05:51','',0,'http://store.local/35/',0,'nav_menu_item','',0),
(36,0,'2026-10-18 11:05:56','2026-10-18 11:05:56',' ','','','publish','closed','closed','','36','','','2026-10-18 11:05:56','2026-10-18 11:05:56','',0,'http://store.local/36/',2,'nav_menu_item','',0),
(37,0,'2026-10-18 11:06:02','2026-10-18 11:06:02',' ','','','publish','closed','closed','','37','','','2026-10-18 11:06:02','2026-10-18 11:06:02','',0,'http://store.local/37/',3,'nav_menu_item','',0),
(38,1,'2026-10-19 14:11:43','2026-10-19 14:11:43','','Order &ndash; October 19, 2026 @ 02:11 PM','','wc-processing','open','closed','wc_order_rWn71Uxlp1Emj','order-oct-19-2026-0211-pm','','','2026-10-19 14:18:13','2026-10-19 14:18:13','',0,'http://store.local/?post_type=shop_order&#038;p=38',0,'shop_order','',4),
(39,1,'2026-10-19 15:25:04','2026-10-19 15:25:04','','Order &ndash; October 19, 2026 @ 03:25 PM','','wc-completed','open','closed','wc_order_ucbUYZ2elUtrI','order-oct-19-2026-0325-pm','','','2026-10-19 16:04:46','2026-10-19 16:04:46','',0,'https://store.local/?post_type=shop_order&#038;p=39',0,'shop_order','',3),
(40,1,'2026-10-19 16:03:55','2026-10-19 16:03:55','','Ultra-Comfort Gaming Chair','','publish','open','closed','','ultra-comfort-gaming-chair','','','2026-10-19 16:03:55','2026-10-19 16:03:55','',0,'https://store.local/product/ultra-comfort-gaming-chair/',0,'product','',0),
(41,1,'2026-10-20 14:37:34','2026-10-20 14:37:34','Professional 60fps streaming webcam with autofocus','4K Ultra HD Webcam','','publish','open','closed','','4k-ultra-hd-webcam','','','2026-10-20 14:37:34','2026-10-20 14:37:34','',0,'https://store.local/product/4k-ultra-hd-webcam/',0,'product','',0);
/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_term_relationships`
--

DROP TABLE IF EXISTS `wp_term_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_relationships`
--

LOCK TABLES `wp_term_relationships` WRITE;
/*!40000 ALTER TABLE `wp_term_relationships` DISABLE KEYS */;
INSERT INTO `wp_term_relationships` VALUES
(1,1,0),
(10,2,0),
(10,9,0),
(10,15,0),
(11,2,0),
(11,15,0),
(12,2,0),
(12,15,0),
(13,2,0),
(13,15,0),
(14,2,0),
(14,9,0),
(14,15,0),
(19,2,0),
(19,15,0),
(21,2,0),
(21,15,0),
(23,2,0),
(23,15,0),
(24,2,0),
(24,15,0),
(35,16,0),
(36,16,0),
(37,16,0),
(40,2,0),
(40,15,0),
(41,2,0),
(41,15,0);
/*!40000 ALTER TABLE `wp_term_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_term_taxonomy`
--

DROP TABLE IF EXISTS `wp_term_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_term_taxonomy`
--

LOCK TABLES `wp_term_taxonomy` WRITE;
/*!40000 ALTER TABLE `wp_term_taxonomy` DISABLE KEYS */;
INSERT INTO `wp_term_taxonomy` VALUES
(1,1,'category','',0,1),
(2,2,'product_type','',0,11),
(3,3,'product_type','',0,0),
(4,4,'product_type','',0,0),
(5,5,'product_type','',0,0),
(6,6,'product_visibility','',0,0),
(7,7,'product_visibility','',0,0),
(8,8,'product_visibility','',0,0),
(9,9,'product_visibility','',0,2),
(10,10,'product_visibility','',0,0),
(11,11,'product_visibility','',0,0),
(12,12,'product_visibility','',0,0),
(13,13,'product_visibility','',0,0),
(14,14,'product_visibility','',0,0),
(15,15,'product_cat','',0,11),
(16,16,'nav_menu','',0,3);
/*!40000 ALTER TABLE `wp_term_taxonomy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_termmeta`
--

DROP TABLE IF EXISTS `wp_termmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_termmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `term_id` (`term_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_termmeta`
--

LOCK TABLES `wp_termmeta` WRITE;
/*!40000 ALTER TABLE `wp_termmeta` DISABLE KEYS */;
INSERT INTO `wp_termmeta` VALUES
(1,15,'product_count_product_cat','11');
/*!40000 ALTER TABLE `wp_termmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_terms`
--

DROP TABLE IF EXISTS `wp_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_terms`
--

LOCK TABLES `wp_terms` WRITE;
/*!40000 ALTER TABLE `wp_terms` DISABLE KEYS */;
INSERT INTO `wp_terms` VALUES
(1,'Uncategorized','uncategorized',0),
(2,'simple','simple',0),
(3,'grouped','grouped',0),
(4,'variable','variable',0),
(5,'external','external',0),
(6,'exclude-from-search','exclude-from-search',0),
(7,'exclude-from-catalog','exclude-from-catalog',0),
(8,'featured','featured',0),
(9,'outofstock','outofstock',0),
(10,'rated-1','rated-1',0),
(11,'rated-2','rated-2',0),
(12,'rated-3','rated-3',0),
(13,'rated-4','rated-4',0),
(14,'rated-5','rated-5',0),
(15,'Uncategorized','uncategorized',0),
(16,'Main','main',0);
/*!40000 ALTER TABLE `wp_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_usermeta`
--

DROP TABLE IF EXISTS `wp_usermeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_usermeta`
--

LOCK TABLES `wp_usermeta` WRITE;
/*!40000 ALTER TABLE `wp_usermeta` DISABLE KEYS */;
INSERT INTO `wp_usermeta` VALUES
(1,1,'nickname','admin'),
(2,1,'first_name',''),
(3,1,'last_name',''),
(4,1,'description',''),
(5,1,'rich_editing','true'),
(6,1,'syntax_highlighting','true'),
(7,1,'comment_shortcuts','false'),
(8,1,'admin_color','fresh'),
(9,1,'use_ssl','0'),
(10,1,'show_admin_bar_front','true'),
(11,1,'locale',''),
(12,1,'wp_capabilities','a:1:{s:13:\"administrator\";b:1;}'),
(13,1,'wp_user_level','10'),
(14,1,'dismissed_wp_pointers',''),
(15,1,'show_welcome_panel','1');
/*!40000 ALTER TABLE `wp_usermeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_users`
--

DROP TABLE IF EXISTS `wp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT 0,
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_users`
--

LOCK TABLES `wp_users` WRITE;
/*!40000 ALTER TABLE `wp_users` DISABLE KEYS */;
INSERT INTO `wp_users` VALUES
(1,'admin','$P$BUxiNEQZ4.9ISKZLDEBJCSfxxycrqP0','admin','admin@urumi.local','http://store.local','2026-10-18 07:52:44','',0,'admin');
/*!40000 ALTER TABLE `wp_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_admin_note_actions`
--

DROP TABLE IF EXISTS `wp_wc_admin_note_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_admin_note_actions` (
  `action_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `note_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `query` longtext NOT NULL,
  `status` varchar(255) NOT NULL,
  `actioned_text` varchar(255) NOT NULL,
  `nonce_action` varchar(255) DEFAULT NULL,
  `nonce_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`action_id`),
  KEY `note_id` (`note_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_admin_note_actions`
--

LOCK TABLES `wp_wc_admin_note_actions` WRITE;
/*!40000 ALTER TABLE `wp_wc_admin_note_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_admin_note_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_admin_notes`
--

DROP TABLE IF EXISTS `wp_wc_admin_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_admin_notes` (
  `note_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` varchar(20) NOT NULL,
  `locale` varchar(20) NOT NULL,
  `title` longtext NOT NULL,
  `content` longtext NOT NULL,
  `content_data` longtext DEFAULT NULL,
  `status` varchar(200) NOT NULL,
  `source` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_reminder` datetime DEFAULT NULL,
  `is_snoozable` tinyint(1) NOT NULL DEFAULT 0,
  `layout` varchar(20) NOT NULL DEFAULT '',
  `image` varchar(200) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `icon` varchar(200) NOT NULL DEFAULT 'info',
  PRIMARY KEY (`note_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_admin_notes`
--

LOCK TABLES `wp_wc_admin_notes` WRITE;
/*!40000 ALTER TABLE `wp_wc_admin_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_admin_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_category_lookup`
--

DROP TABLE IF EXISTS `wp_wc_category_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_category_lookup` (
  `category_tree_id` bigint(20) unsigned NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`category_tree_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_category_lookup`
--

LOCK TABLES `wp_wc_category_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_category_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_category_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_customer_lookup`
--

DROP TABLE IF EXISTS `wp_wc_customer_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_customer_lookup` (
  `customer_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `username` varchar(60) NOT NULL DEFAULT '',
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `date_last_active` timestamp NULL DEFAULT NULL,
  `date_registered` timestamp NULL DEFAULT NULL,
  `country` char(2) NOT NULL DEFAULT '',
  `postcode` varchar(20) NOT NULL DEFAULT '',
  `city` varchar(100) NOT NULL DEFAULT '',
  `state` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_customer_lookup`
--

LOCK TABLES `wp_wc_customer_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_customer_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_customer_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_download_log`
--

DROP TABLE IF EXISTS `wp_wc_download_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_download_log` (
  `download_log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `permission_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `user_ip_address` varchar(100) DEFAULT '',
  PRIMARY KEY (`download_log_id`),
  KEY `permission_id` (`permission_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_download_log`
--

LOCK TABLES `wp_wc_download_log` WRITE;
/*!40000 ALTER TABLE `wp_wc_download_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_download_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_order_coupon_lookup`
--

DROP TABLE IF EXISTS `wp_wc_order_coupon_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_order_coupon_lookup` (
  `order_id` bigint(20) unsigned NOT NULL,
  `coupon_id` bigint(20) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `discount_amount` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`order_id`,`coupon_id`),
  KEY `coupon_id` (`coupon_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_order_coupon_lookup`
--

LOCK TABLES `wp_wc_order_coupon_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_order_coupon_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_order_coupon_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_order_product_lookup`
--

DROP TABLE IF EXISTS `wp_wc_order_product_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_order_product_lookup` (
  `order_item_id` bigint(20) unsigned NOT NULL,
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `variation_id` bigint(20) unsigned NOT NULL,
  `customer_id` bigint(20) unsigned DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `product_qty` int(11) NOT NULL,
  `product_net_revenue` double NOT NULL DEFAULT 0,
  `product_gross_revenue` double NOT NULL DEFAULT 0,
  `coupon_amount` double NOT NULL DEFAULT 0,
  `tax_amount` double NOT NULL DEFAULT 0,
  `shipping_amount` double NOT NULL DEFAULT 0,
  `shipping_tax_amount` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `customer_id` (`customer_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_order_product_lookup`
--

LOCK TABLES `wp_wc_order_product_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_order_product_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_order_product_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_order_stats`
--

DROP TABLE IF EXISTS `wp_wc_order_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_order_stats` (
  `order_id` bigint(20) unsigned NOT NULL,
  `parent_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_created_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_paid` datetime DEFAULT '0000-00-00 00:00:00',
  `date_completed` datetime DEFAULT '0000-00-00 00:00:00',
  `num_items_sold` int(11) NOT NULL DEFAULT 0,
  `total_sales` double NOT NULL DEFAULT 0,
  `tax_total` double NOT NULL DEFAULT 0,
  `shipping_total` double NOT NULL DEFAULT 0,
  `net_total` double NOT NULL DEFAULT 0,
  `returning_customer` tinyint(1) DEFAULT NULL,
  `status` varchar(200) NOT NULL,
  `customer_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `date_created` (`date_created`),
  KEY `customer_id` (`customer_id`),
  KEY `status` (`status`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_order_stats`
--

LOCK TABLES `wp_wc_order_stats` WRITE;
/*!40000 ALTER TABLE `wp_wc_order_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_order_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_order_tax_lookup`
--

DROP TABLE IF EXISTS `wp_wc_order_tax_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_order_tax_lookup` (
  `order_id` bigint(20) unsigned NOT NULL,
  `tax_rate_id` bigint(20) unsigned NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `shipping_tax` double NOT NULL DEFAULT 0,
  `order_tax` double NOT NULL DEFAULT 0,
  `total_tax` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`order_id`,`tax_rate_id`),
  KEY `tax_rate_id` (`tax_rate_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_order_tax_lookup`
--

LOCK TABLES `wp_wc_order_tax_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_order_tax_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_order_tax_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_product_attributes_lookup`
--

DROP TABLE IF EXISTS `wp_wc_product_attributes_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_product_attributes_lookup` (
  `product_id` bigint(20) NOT NULL,
  `product_or_parent_id` bigint(20) NOT NULL,
  `taxonomy` varchar(32) NOT NULL,
  `term_id` bigint(20) NOT NULL,
  `is_variation_attribute` tinyint(1) NOT NULL,
  `in_stock` tinyint(1) NOT NULL,
  PRIMARY KEY (`product_or_parent_id`,`term_id`,`product_id`,`taxonomy`),
  KEY `is_variation_attribute_term_id` (`is_variation_attribute`,`term_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_product_attributes_lookup`
--

LOCK TABLES `wp_wc_product_attributes_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_product_attributes_lookup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_product_attributes_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_product_download_directories`
--

DROP TABLE IF EXISTS `wp_wc_product_download_directories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_product_download_directories` (
  `url_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(256) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`url_id`),
  KEY `url` (`url`(191))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_product_download_directories`
--

LOCK TABLES `wp_wc_product_download_directories` WRITE;
/*!40000 ALTER TABLE `wp_wc_product_download_directories` DISABLE KEYS */;
INSERT INTO `wp_wc_product_download_directories` VALUES
(1,'file:///var/www/html/wp-content/uploads/woocommerce_uploads/',1),
(2,'http://store.local/wp-content/uploads/woocommerce_uploads/',1);
/*!40000 ALTER TABLE `wp_wc_product_download_directories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_product_meta_lookup`
--

DROP TABLE IF EXISTS `wp_wc_product_meta_lookup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_product_meta_lookup` (
  `product_id` bigint(20) NOT NULL,
  `sku` varchar(100) DEFAULT '',
  `global_unique_id` varchar(100) DEFAULT '',
  `virtual` tinyint(1) DEFAULT 0,
  `downloadable` tinyint(1) DEFAULT 0,
  `min_price` decimal(19,4) DEFAULT NULL,
  `max_price` decimal(19,4) DEFAULT NULL,
  `onsale` tinyint(1) DEFAULT 0,
  `stock_quantity` double DEFAULT NULL,
  `stock_status` varchar(100) DEFAULT 'instock',
  `rating_count` bigint(20) DEFAULT 0,
  `average_rating` decimal(3,2) DEFAULT 0.00,
  `total_sales` bigint(20) DEFAULT 0,
  `tax_status` varchar(100) DEFAULT 'taxable',
  `tax_class` varchar(100) DEFAULT '',
  PRIMARY KEY (`product_id`),
  KEY `virtual` (`virtual`),
  KEY `downloadable` (`downloadable`),
  KEY `stock_status` (`stock_status`),
  KEY `stock_quantity` (`stock_quantity`),
  KEY `onsale` (`onsale`),
  KEY `min_max_price` (`min_price`,`max_price`),
  KEY `sku` (`sku`(50))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_product_meta_lookup`
--

LOCK TABLES `wp_wc_product_meta_lookup` WRITE;
/*!40000 ALTER TABLE `wp_wc_product_meta_lookup` DISABLE KEYS */;
INSERT INTO `wp_wc_product_meta_lookup` VALUES
(10,'SKU-1001','',0,0,199.9900,199.9900,0,-50,'outofstock',0,0.00,3,'taxable',''),
(11,'SKU-1002','',0,0,129.5000,129.5000,0,10,'instock',0,0.00,2,'taxable',''),
(12,'SKU-1003','',0,0,499.0000,499.0000,0,5,'instock',0,0.00,0,'taxable',''),
(13,'SKU-1004','',0,0,45.0000,45.0000,0,500,'instock',0,0.00,0,'taxable',''),
(14,'SKU-1005','',0,0,89.0000,89.0000,0,0,'outofstock',0,0.00,0,'taxable',''),
(19,'SKU-DYN-6','',0,0,89.5000,89.5000,0,38,'instock',0,0.00,2,'taxable',''),
(21,'SKU-DYN-7','',0,0,89.5000,89.5000,0,37,'instock',0,0.00,3,'taxable',''),
(23,'SKU-TEST-P2-6','',0,0,75.0000,75.0000,0,25,'instock',0,0.00,0,'taxable',''),
(24,'SKU-DESK-01','',0,0,35.0000,35.0000,0,57,'instock',0,0.00,3,'taxable',''),
(40,'SKU-CHAIR-01','',0,0,249.9900,249.9900,0,15,'instock',0,0.00,0,'taxable',''),
(41,'SKU-CAM-4K','',0,0,129.9900,129.9900,0,25,'instock',0,0.00,0,'taxable','');
/*!40000 ALTER TABLE `wp_wc_product_meta_lookup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_rate_limits`
--

DROP TABLE IF EXISTS `wp_wc_rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_rate_limits` (
  `rate_limit_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rate_limit_key` varchar(200) NOT NULL,
  `rate_limit_expiry` bigint(20) unsigned NOT NULL,
  `rate_limit_remaining` smallint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`rate_limit_id`),
  UNIQUE KEY `rate_limit_key` (`rate_limit_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_rate_limits`
--

LOCK TABLES `wp_wc_rate_limits` WRITE;
/*!40000 ALTER TABLE `wp_wc_rate_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_reserved_stock`
--

DROP TABLE IF EXISTS `wp_wc_reserved_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_reserved_stock` (
  `order_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `stock_quantity` double NOT NULL DEFAULT 0,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`order_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_reserved_stock`
--

LOCK TABLES `wp_wc_reserved_stock` WRITE;
/*!40000 ALTER TABLE `wp_wc_reserved_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_reserved_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_tax_rate_classes`
--

DROP TABLE IF EXISTS `wp_wc_tax_rate_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_tax_rate_classes` (
  `tax_rate_class_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`tax_rate_class_id`),
  UNIQUE KEY `slug` (`slug`(191))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_tax_rate_classes`
--

LOCK TABLES `wp_wc_tax_rate_classes` WRITE;
/*!40000 ALTER TABLE `wp_wc_tax_rate_classes` DISABLE KEYS */;
INSERT INTO `wp_wc_tax_rate_classes` VALUES
(1,'Reduced rate','reduced-rate'),
(2,'Zero rate','zero-rate');
/*!40000 ALTER TABLE `wp_wc_tax_rate_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_wc_webhooks`
--

DROP TABLE IF EXISTS `wp_wc_webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_wc_webhooks` (
  `webhook_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(200) NOT NULL,
  `name` text NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `delivery_url` text NOT NULL,
  `secret` text NOT NULL,
  `topic` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_created_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `api_version` smallint(4) NOT NULL,
  `failure_count` smallint(10) NOT NULL DEFAULT 0,
  `pending_delivery` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`webhook_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_wc_webhooks`
--

LOCK TABLES `wp_wc_webhooks` WRITE;
/*!40000 ALTER TABLE `wp_wc_webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_wc_webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_api_keys`
--

DROP TABLE IF EXISTS `wp_woocommerce_api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_api_keys` (
  `key_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `permissions` varchar(10) NOT NULL,
  `consumer_key` char(64) NOT NULL,
  `consumer_secret` char(43) NOT NULL,
  `nonces` longtext DEFAULT NULL,
  `truncated_key` char(7) NOT NULL,
  `last_access` datetime DEFAULT NULL,
  PRIMARY KEY (`key_id`),
  KEY `consumer_key` (`consumer_key`),
  KEY `consumer_secret` (`consumer_secret`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_api_keys`
--

LOCK TABLES `wp_woocommerce_api_keys` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_api_keys` DISABLE KEYS */;
INSERT INTO `wp_woocommerce_api_keys` VALUES
(1,1,'MCP Gateway Key','read_write','a7220082fff8512350b0ae5d62b47e4fa6362e75ac3a0396c4a5546f4f2b1cdd','cs_12cda47b1981cb02720b08051a8bc8f895f3b7d1',NULL,'acfb0a1','2026-10-21 09:39:09');
/*!40000 ALTER TABLE `wp_woocommerce_api_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_attribute_taxonomies`
--

DROP TABLE IF EXISTS `wp_woocommerce_attribute_taxonomies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_attribute_taxonomies` (
  `attribute_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_name` varchar(200) NOT NULL,
  `attribute_label` varchar(200) DEFAULT NULL,
  `attribute_type` varchar(20) NOT NULL,
  `attribute_orderby` varchar(20) NOT NULL,
  `attribute_public` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`attribute_id`),
  KEY `attribute_name` (`attribute_name`(20))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_attribute_taxonomies`
--

LOCK TABLES `wp_woocommerce_attribute_taxonomies` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_attribute_taxonomies` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_attribute_taxonomies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_downloadable_product_permissions`
--

DROP TABLE IF EXISTS `wp_woocommerce_downloadable_product_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_downloadable_product_permissions` (
  `permission_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `download_id` varchar(36) NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `order_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `order_key` varchar(200) NOT NULL,
  `user_email` varchar(200) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `downloads_remaining` varchar(9) DEFAULT NULL,
  `access_granted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `access_expires` datetime DEFAULT NULL,
  `download_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`permission_id`),
  KEY `download_order_key_product` (`product_id`,`order_id`,`order_key`(16),`download_id`),
  KEY `download_order_product` (`download_id`,`order_id`,`product_id`),
  KEY `order_id` (`order_id`),
  KEY `user_order_remaining_expires` (`user_id`,`order_id`,`downloads_remaining`,`access_expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_downloadable_product_permissions`
--

LOCK TABLES `wp_woocommerce_downloadable_product_permissions` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_downloadable_product_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_downloadable_product_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_log`
--

DROP TABLE IF EXISTS `wp_woocommerce_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_log` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `level` smallint(4) NOT NULL,
  `source` varchar(200) NOT NULL,
  `message` longtext NOT NULL,
  `context` longtext DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_log`
--

LOCK TABLES `wp_woocommerce_log` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_order_itemmeta`
--

DROP TABLE IF EXISTS `wp_woocommerce_order_itemmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_order_itemmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint(20) unsigned NOT NULL,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `order_item_id` (`order_item_id`),
  KEY `meta_key` (`meta_key`(32))
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_order_itemmeta`
--

LOCK TABLES `wp_woocommerce_order_itemmeta` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_order_itemmeta` DISABLE KEYS */;
INSERT INTO `wp_woocommerce_order_itemmeta` VALUES
(1,1,'_product_id','10'),
(2,1,'_variation_id','0'),
(3,1,'_qty','1'),
(4,1,'_tax_class',''),
(5,1,'_line_subtotal','199.99'),
(6,1,'_line_subtotal_tax','0'),
(7,1,'_line_total','199.99'),
(8,1,'_line_tax','0'),
(9,1,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(10,1,'_reduced_stock','1'),
(11,2,'_product_id','11'),
(12,2,'_variation_id','0'),
(13,2,'_qty','2'),
(14,2,'_tax_class',''),
(15,2,'_line_subtotal','259'),
(16,2,'_line_subtotal_tax','0'),
(17,2,'_line_total','259'),
(18,2,'_line_tax','0'),
(19,2,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(20,2,'_reduced_stock','2'),
(21,3,'_product_id','10'),
(22,3,'_variation_id','0'),
(23,3,'_qty','1'),
(24,3,'_tax_class',''),
(25,3,'_line_subtotal','199.99'),
(26,3,'_line_subtotal_tax','0'),
(27,3,'_line_total','199.99'),
(28,3,'_line_tax','0'),
(29,3,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(30,4,'_product_id','11'),
(31,4,'_variation_id','0'),
(32,4,'_qty','1'),
(33,4,'_tax_class',''),
(34,4,'_line_subtotal','129.5'),
(35,4,'_line_subtotal_tax','0'),
(36,4,'_line_total','129.5'),
(37,4,'_line_tax','0'),
(38,4,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(39,5,'_product_id','19'),
(40,5,'_variation_id','0'),
(41,5,'_qty','2'),
(42,5,'_tax_class',''),
(43,5,'_line_subtotal','179'),
(44,5,'_line_subtotal_tax','0'),
(45,5,'_line_total','179'),
(46,5,'_line_tax','0'),
(47,5,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(48,5,'_reduced_stock','2'),
(49,6,'_product_id','21'),
(50,6,'_variation_id','0'),
(51,6,'_qty','2'),
(52,6,'_tax_class',''),
(53,6,'_line_subtotal','179'),
(54,6,'_line_subtotal_tax','0'),
(55,6,'_line_total','179'),
(56,6,'_line_tax','0'),
(57,6,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(58,6,'_reduced_stock','2'),
(59,7,'_product_id','10'),
(60,7,'_variation_id','0'),
(61,7,'_qty','1'),
(62,7,'_tax_class',''),
(63,7,'_line_subtotal','199.99'),
(64,7,'_line_subtotal_tax','0'),
(65,7,'_line_total','199.99'),
(66,7,'_line_tax','0'),
(67,7,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(68,7,'_reduced_stock','1'),
(69,8,'_product_id','21'),
(70,8,'_variation_id','0'),
(71,8,'_qty','1'),
(72,8,'_tax_class',''),
(73,8,'_line_subtotal','89.5'),
(74,8,'_line_subtotal_tax','0'),
(75,8,'_line_total','89.5'),
(76,8,'_line_tax','0'),
(77,8,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(78,8,'_reduced_stock','1'),
(79,9,'_product_id','24'),
(80,9,'_variation_id','0'),
(81,9,'_qty','3'),
(82,9,'_tax_class',''),
(83,9,'_line_subtotal','105'),
(84,9,'_line_subtotal_tax','0'),
(85,9,'_line_total','105'),
(86,9,'_line_tax','0'),
(87,9,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(88,9,'_reduced_stock','3'),
(89,10,'_product_id','10'),
(90,10,'_variation_id','0'),
(91,10,'_qty','1'),
(92,10,'_tax_class',''),
(93,10,'_line_subtotal','199.99'),
(94,10,'_line_subtotal_tax','0'),
(95,10,'_line_total','199.99'),
(96,10,'_line_tax','0'),
(97,10,'_line_tax_data','a:2:{s:5:\"total\";a:0:{}s:8:\"subtotal\";a:0:{}}'),
(98,10,'_reduced_stock','1');
/*!40000 ALTER TABLE `wp_woocommerce_order_itemmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_order_items`
--

DROP TABLE IF EXISTS `wp_woocommerce_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_order_items` (
  `order_item_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_item_name` text NOT NULL,
  `order_item_type` varchar(200) NOT NULL DEFAULT '',
  `order_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_order_items`
--

LOCK TABLES `wp_woocommerce_order_items` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_order_items` DISABLE KEYS */;
INSERT INTO `wp_woocommerce_order_items` VALUES
(1,'Premium Wireless Headphones','line_item',15),
(2,'Ergonomic Mechanical Keyboard','line_item',16),
(3,'Premium Wireless Headphones','line_item',17),
(4,'Ergonomic Mechanical Keyboard','line_item',17),
(5,'Dynamic Studio Mic Boom','line_item',20),
(6,'Dynamic Studio Mic Boom','line_item',22),
(7,'Premium Wireless Headphones','line_item',25),
(8,'Dynamic Studio Mic Boom','line_item',26),
(9,'Ergonomic Desk Mat','line_item',38),
(10,'Premium Wireless Headphones','line_item',39);
/*!40000 ALTER TABLE `wp_woocommerce_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_payment_tokenmeta`
--

DROP TABLE IF EXISTS `wp_woocommerce_payment_tokenmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_payment_tokenmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_token_id` bigint(20) unsigned NOT NULL,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `payment_token_id` (`payment_token_id`),
  KEY `meta_key` (`meta_key`(32))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_payment_tokenmeta`
--

LOCK TABLES `wp_woocommerce_payment_tokenmeta` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_payment_tokenmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_payment_tokenmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_payment_tokens`
--

DROP TABLE IF EXISTS `wp_woocommerce_payment_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_payment_tokens` (
  `token_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gateway_id` varchar(200) NOT NULL,
  `token` text NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `type` varchar(200) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`token_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_payment_tokens`
--

LOCK TABLES `wp_woocommerce_payment_tokens` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_payment_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_payment_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_sessions`
--

DROP TABLE IF EXISTS `wp_woocommerce_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_sessions` (
  `session_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_key` char(32) NOT NULL,
  `session_value` longtext NOT NULL,
  `session_expiry` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `session_key` (`session_key`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_sessions`
--

LOCK TABLES `wp_woocommerce_sessions` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_sessions` DISABLE KEYS */;
INSERT INTO `wp_woocommerce_sessions` VALUES
(1,'t_49d75bdd5bf1ea9c64df6ec30fcd26','a:9:{s:4:\"cart\";s:6:\"a:0:{}\";s:11:\"cart_totals\";s:367:\"a:15:{s:8:\"subtotal\";i:0;s:12:\"subtotal_tax\";i:0;s:14:\"shipping_total\";i:0;s:12:\"shipping_tax\";i:0;s:14:\"shipping_taxes\";a:0:{}s:14:\"discount_total\";i:0;s:12:\"discount_tax\";i:0;s:19:\"cart_contents_total\";i:0;s:17:\"cart_contents_tax\";i:0;s:19:\"cart_contents_taxes\";a:0:{}s:9:\"fee_total\";i:0;s:7:\"fee_tax\";i:0;s:9:\"fee_taxes\";a:0:{}s:5:\"total\";i:0;s:9:\"total_tax\";i:0;}\";s:15:\"applied_coupons\";s:6:\"a:0:{}\";s:22:\"coupon_discount_totals\";s:6:\"a:0:{}\";s:26:\"coupon_discount_tax_totals\";s:6:\"a:0:{}\";s:21:\"removed_cart_contents\";s:6:\"a:0:{}\";s:8:\"customer\";s:967:\"a:28:{s:2:\"id\";s:1:\"0\";s:13:\"date_modified\";s:0:\"\";s:10:\"first_name\";s:8:\"Uttkarsh\";s:9:\"last_name\";s:4:\"home\";s:7:\"company\";s:0:\"\";s:5:\"phone\";s:13:\"+919990766708\";s:5:\"email\";s:30:\"uttkarsh2003.solanki@gmail.com\";s:7:\"address\";s:27:\"sec 2/462 ,chiranjeev vihar\";s:9:\"address_1\";s:27:\"sec 2/462 ,chiranjeev vihar\";s:9:\"address_2\";s:0:\"\";s:4:\"city\";s:9:\"ghaziabad\";s:5:\"state\";s:2:\"UP\";s:8:\"postcode\";s:6:\"201002\";s:7:\"country\";s:2:\"IN\";s:19:\"shipping_first_name\";s:8:\"Uttkarsh\";s:18:\"shipping_last_name\";s:4:\"home\";s:16:\"shipping_company\";s:0:\"\";s:14:\"shipping_phone\";s:13:\"+919990766708\";s:16:\"shipping_address\";s:27:\"sec 2/462 ,chiranjeev vihar\";s:18:\"shipping_address_1\";s:27:\"sec 2/462 ,chiranjeev vihar\";s:18:\"shipping_address_2\";s:0:\"\";s:13:\"shipping_city\";s:9:\"ghaziabad\";s:14:\"shipping_state\";s:2:\"UP\";s:17:\"shipping_postcode\";s:6:\"201002\";s:16:\"shipping_country\";s:2:\"IN\";s:13:\"is_vat_exempt\";s:0:\"\";s:19:\"calculated_shipping\";s:0:\"\";s:9:\"meta_data\";a:0:{}}\";s:10:\"wc_notices\";N;s:21:\"store_api_draft_order\";i:38;}',1792493841);
/*!40000 ALTER TABLE `wp_woocommerce_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_shipping_zone_locations`
--

DROP TABLE IF EXISTS `wp_woocommerce_shipping_zone_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_shipping_zone_locations` (
  `location_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `zone_id` bigint(20) unsigned NOT NULL,
  `location_code` varchar(200) NOT NULL,
  `location_type` varchar(40) NOT NULL,
  PRIMARY KEY (`location_id`),
  KEY `zone_id` (`zone_id`),
  KEY `location_type_code` (`location_type`(10),`location_code`(20))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_shipping_zone_locations`
--

LOCK TABLES `wp_woocommerce_shipping_zone_locations` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zone_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zone_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_shipping_zone_methods`
--

DROP TABLE IF EXISTS `wp_woocommerce_shipping_zone_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_shipping_zone_methods` (
  `zone_id` bigint(20) unsigned NOT NULL,
  `instance_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `method_id` varchar(200) NOT NULL,
  `method_order` bigint(20) unsigned NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_shipping_zone_methods`
--

LOCK TABLES `wp_woocommerce_shipping_zone_methods` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zone_methods` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zone_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_shipping_zones`
--

DROP TABLE IF EXISTS `wp_woocommerce_shipping_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_shipping_zones` (
  `zone_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `zone_name` varchar(200) NOT NULL,
  `zone_order` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_shipping_zones`
--

LOCK TABLES `wp_woocommerce_shipping_zones` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zones` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_shipping_zones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_tax_rate_locations`
--

DROP TABLE IF EXISTS `wp_woocommerce_tax_rate_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_tax_rate_locations` (
  `location_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `location_code` varchar(200) NOT NULL,
  `tax_rate_id` bigint(20) unsigned NOT NULL,
  `location_type` varchar(40) NOT NULL,
  PRIMARY KEY (`location_id`),
  KEY `tax_rate_id` (`tax_rate_id`),
  KEY `location_type_code` (`location_type`(10),`location_code`(20))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_tax_rate_locations`
--

LOCK TABLES `wp_woocommerce_tax_rate_locations` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_tax_rate_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_tax_rate_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wp_woocommerce_tax_rates`
--

DROP TABLE IF EXISTS `wp_woocommerce_tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_woocommerce_tax_rates` (
  `tax_rate_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tax_rate_country` varchar(2) NOT NULL DEFAULT '',
  `tax_rate_state` varchar(200) NOT NULL DEFAULT '',
  `tax_rate` varchar(8) NOT NULL DEFAULT '',
  `tax_rate_name` varchar(200) NOT NULL DEFAULT '',
  `tax_rate_priority` bigint(20) unsigned NOT NULL,
  `tax_rate_compound` int(1) NOT NULL DEFAULT 0,
  `tax_rate_shipping` int(1) NOT NULL DEFAULT 1,
  `tax_rate_order` bigint(20) unsigned NOT NULL,
  `tax_rate_class` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`tax_rate_id`),
  KEY `tax_rate_country` (`tax_rate_country`),
  KEY `tax_rate_state` (`tax_rate_state`(2)),
  KEY `tax_rate_class` (`tax_rate_class`(10)),
  KEY `tax_rate_priority` (`tax_rate_priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wp_woocommerce_tax_rates`
--

LOCK TABLES `wp_woocommerce_tax_rates` WRITE;
/*!40000 ALTER TABLE `wp_woocommerce_tax_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_woocommerce_tax_rates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-10-21 10:23:30
