-- MySQL dump 10.13  Distrib 8.0.25, for Linux (x86_64)
--
-- Host: localhost    Database: currency_exchange_rate
-- ------------------------------------------------------
-- Server version	8.0.25-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `currency_code` varchar(3) NOT NULL,
  `russian_name` varchar(50) DEFAULT NULL,
  `chinese_name` varchar(50) DEFAULT NULL,
  `english_name` varchar(50) DEFAULT NULL,
  `german_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES ('CNY','юань','元','yuan','yuan'),('EUR','евро','歐元','euro','euro'),('RUB','рубль','盧布','ruble','rubel'),('USD','доллар','美元','dollar','dollar');
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `euro_rate`
--

DROP TABLE IF EXISTS `euro_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `euro_rate` (
  `euro_rate_id` int NOT NULL AUTO_INCREMENT,
  `RUB` float DEFAULT NULL,
  `USD` float DEFAULT NULL,
  `CNY` float DEFAULT NULL,
  `conversion_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`euro_rate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `euro_rate`
--

LOCK TABLES `euro_rate` WRITE;
/*!40000 ALTER TABLE `euro_rate` DISABLE KEYS */;
/*!40000 ALTER TABLE `euro_rate` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_rate` AFTER INSERT ON `euro_rate` FOR EACH ROW BEGIN
    SET @eur_rub = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'EUR' && to_currency_code = 'RUB');
    SET @eur_cny = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'EUR' && to_currency_code = 'CNY');
    SET @eur_usd = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'EUR' && to_currency_code = 'USD');

    SET @usd_rub = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'USD' && to_currency_code = 'RUB');
    SET @usd_eur = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'USD' && to_currency_code = 'EUR');
    SET @usd_cny = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'USD' && to_currency_code = 'CNY');

    SET @cny_rub = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'CNY' && to_currency_code = 'RUB');
    SET @cny_eur = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'CNY' && to_currency_code = 'EUR');
    SET @cny_usd = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'CNY' && to_currency_code = 'USD');

    SET @rub_cny = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'RUB' && to_currency_code = 'CNY');
    SET @rub_usd = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'RUB' && to_currency_code = 'USD');
    SET @rub_eur = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'RUB' && to_currency_code = 'EUR');

    SET @eur_eur = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'EUR' && to_currency_code = 'EUR');
    SET @usd_usd = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'USD' && to_currency_code = 'USD');
    SET @cny_cny = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'CNY' && to_currency_code = 'CNY');
    SET @rub_rub = (SELECT currency_pair_id FROM exchange_currency_pair WHERE
            from_currency_code = 'RUB' && to_currency_code = 'RUB');

    SET @rub_eur_convert = 1/NEW.RUB;
    SET @rub_usd_convert = NEW.USD/NEW.RUB;
    SET @rub_cny_convert = NEW.CNY/NEW.RUB;

    SET @usd_eur_convert = 1/NEW.USD;
    SET @usd_rub_convert = NEW.RUB/NEW.USD;
    SET @usd_cny_convert = NEW.CNY/NEW.USD;

    SET @cny_rub_convert = NEW.RUB/NEW.CNY;
    SET @cny_eur_convert = 1/NEW.CNY;
    SET @cny_usd_convert = NEW.USD/NEW.CNY;

    INSERT INTO exchange_rate (currency_pair_id, rate, rate_date)
    VALUES
    (@eur_rub, NEW.RUB, NEW.conversion_date),
    (@eur_usd, NEW.USD, NEW.conversion_date),
    (@eur_cny, NEW.CNY, NEW.conversion_date),
    (@eur_eur, 1, NEW.conversion_date),
    (@rub_eur, @rub_eur_convert, NEW.conversion_date),
    (@rub_usd, @rub_usd_convert, NEW.conversion_date),
    (@rub_cny, @rub_cny_convert, NEW.conversion_date),
    (@rub_rub, 1, NEW.conversion_date),
    (@usd_rub, @usd_rub_convert, NEW.conversion_date),
    (@usd_eur, @usd_eur_convert, NEW.conversion_date),
    (@usd_cny, @usd_cny_convert, NEW.conversion_date),
    (@usd_usd, 1, NEW.conversion_date),
    (@cny_eur, @cny_eur_convert, NEW.conversion_date),
    (@cny_rub, @cny_rub_convert, NEW.conversion_date),
    (@cny_usd, @cny_usd_convert, NEW.conversion_date),
    (@cny_cny, 1, NEW.conversion_date)
    ;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `exchange_currency_pair`
--

DROP TABLE IF EXISTS `exchange_currency_pair`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_currency_pair` (
  `currency_pair_id` int NOT NULL AUTO_INCREMENT,
  `from_currency_code` varchar(3) DEFAULT NULL,
  `to_currency_code` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`currency_pair_id`),
  KEY `from_currency_code` (`from_currency_code`),
  KEY `to_currency_code` (`to_currency_code`),
  CONSTRAINT `exchange_currency_pair_ibfk_1` FOREIGN KEY (`from_currency_code`) REFERENCES `currency` (`currency_code`),
  CONSTRAINT `exchange_currency_pair_ibfk_2` FOREIGN KEY (`to_currency_code`) REFERENCES `currency` (`currency_code`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_currency_pair`
--

LOCK TABLES `exchange_currency_pair` WRITE;
/*!40000 ALTER TABLE `exchange_currency_pair` DISABLE KEYS */;
INSERT INTO `exchange_currency_pair` VALUES (1,'EUR','RUB'),(2,'EUR','USD'),(3,'EUR','CNY'),(4,'RUB','EUR'),(5,'RUB','CNY'),(6,'RUB','USD'),(7,'CNY','EUR'),(8,'CNY','RUB'),(9,'CNY','USD'),(10,'USD','EUR'),(11,'USD','RUB'),(12,'USD','CNY'),(13,'USD','USD'),(14,'RUB','RUB'),(15,'EUR','EUR'),(16,'CNY','CNY');
/*!40000 ALTER TABLE `exchange_currency_pair` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_rate`
--

DROP TABLE IF EXISTS `exchange_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rate` (
  `exchange_rate_id` int NOT NULL AUTO_INCREMENT,
  `currency_pair_id` int DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `rate_date` timestamp NOT NULL,
  PRIMARY KEY (`exchange_rate_id`),
  KEY `currency_pair_id` (`currency_pair_id`),
  CONSTRAINT `exchange_rate_ibfk_1` FOREIGN KEY (`currency_pair_id`) REFERENCES `exchange_currency_pair` (`currency_pair_id`)
) ENGINE=InnoDB AUTO_INCREMENT=345 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_rate`
--

LOCK TABLES `exchange_rate` WRITE;
/*!40000 ALTER TABLE `exchange_rate` DISABLE KEYS */;
/*!40000 ALTER TABLE `exchange_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_dollar_exchange_rate`
--

DROP TABLE IF EXISTS `v_dollar_exchange_rate`;
/*!50001 DROP VIEW IF EXISTS `v_dollar_exchange_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_dollar_exchange_rate` AS SELECT 
 1 AS `from_currency`,
 1 AS `from_currency_english_name`,
 1 AS `from_currency_value`,
 1 AS `to_currency`,
 1 AS `to_currency_english_name`,
 1 AS `exchange_rate`,
 1 AS `exchange_rate_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_euro_exchange_rate`
--

DROP TABLE IF EXISTS `v_euro_exchange_rate`;
/*!50001 DROP VIEW IF EXISTS `v_euro_exchange_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_euro_exchange_rate` AS SELECT 
 1 AS `from_currency`,
 1 AS `from_currency_german_name`,
 1 AS `from_currency_value`,
 1 AS `to_currency`,
 1 AS `to_currency_german_name`,
 1 AS `exchange_rate`,
 1 AS `exchange_rate_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_ruble_exchange_rate`
--

DROP TABLE IF EXISTS `v_ruble_exchange_rate`;
/*!50001 DROP VIEW IF EXISTS `v_ruble_exchange_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_ruble_exchange_rate` AS SELECT 
 1 AS `from_currency`,
 1 AS `from_currency_russian_name`,
 1 AS `from_currency_value`,
 1 AS `to_currency`,
 1 AS `to_currency_russian_name`,
 1 AS `exchange_rate`,
 1 AS `exchange_rate_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_yuan_exchange_rate`
--

DROP TABLE IF EXISTS `v_yuan_exchange_rate`;
/*!50001 DROP VIEW IF EXISTS `v_yuan_exchange_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_yuan_exchange_rate` AS SELECT 
 1 AS `from_currency`,
 1 AS `from_currency_chinese_name`,
 1 AS `from_currency_value`,
 1 AS `to_currency`,
 1 AS `to_currency_chinese_name`,
 1 AS `exchange_rate`,
 1 AS `exchange_rate_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_dollar_exchange_rate`
--

/*!50001 DROP VIEW IF EXISTS `v_dollar_exchange_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_dollar_exchange_rate` AS select `currency_from`.`currency_code` AS `from_currency`,`currency_from`.`english_name` AS `from_currency_english_name`,(`exchange_rate`.`rate` / `exchange_rate`.`rate`) AS `from_currency_value`,`currency_to`.`currency_code` AS `to_currency`,`currency_to`.`english_name` AS `to_currency_english_name`,`exchange_rate`.`rate` AS `exchange_rate`,`exchange_rate`.`rate_date` AS `exchange_rate_date` from (((`exchange_currency_pair` `pairs` join `currency` `currency_from` on((`pairs`.`from_currency_code` = `currency_from`.`currency_code`))) join `currency` `currency_to` on((`pairs`.`to_currency_code` = `currency_to`.`currency_code`))) join `exchange_rate` on((`pairs`.`currency_pair_id` = `exchange_rate`.`currency_pair_id`))) where (`pairs`.`to_currency_code` = 'USD') order by `exchange_rate`.`rate_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_euro_exchange_rate`
--

/*!50001 DROP VIEW IF EXISTS `v_euro_exchange_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_euro_exchange_rate` AS select `currency_from`.`currency_code` AS `from_currency`,`currency_from`.`german_name` AS `from_currency_german_name`,(`exchange_rate`.`rate` / `exchange_rate`.`rate`) AS `from_currency_value`,`currency_to`.`currency_code` AS `to_currency`,`currency_to`.`german_name` AS `to_currency_german_name`,`exchange_rate`.`rate` AS `exchange_rate`,`exchange_rate`.`rate_date` AS `exchange_rate_date` from (((`exchange_currency_pair` `pairs` join `currency` `currency_from` on((`pairs`.`from_currency_code` = `currency_from`.`currency_code`))) join `currency` `currency_to` on((`pairs`.`to_currency_code` = `currency_to`.`currency_code`))) join `exchange_rate` on((`pairs`.`currency_pair_id` = `exchange_rate`.`currency_pair_id`))) where (`pairs`.`to_currency_code` = 'EUR') order by `exchange_rate`.`rate_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ruble_exchange_rate`
--

/*!50001 DROP VIEW IF EXISTS `v_ruble_exchange_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_ruble_exchange_rate` AS select `currency_from`.`currency_code` AS `from_currency`,`currency_from`.`russian_name` AS `from_currency_russian_name`,(`exchange_rate`.`rate` / `exchange_rate`.`rate`) AS `from_currency_value`,`currency_to`.`currency_code` AS `to_currency`,`currency_to`.`russian_name` AS `to_currency_russian_name`,`exchange_rate`.`rate` AS `exchange_rate`,`exchange_rate`.`rate_date` AS `exchange_rate_date` from (((`exchange_currency_pair` `pairs` join `currency` `currency_from` on((`pairs`.`from_currency_code` = `currency_from`.`currency_code`))) join `currency` `currency_to` on((`pairs`.`to_currency_code` = `currency_to`.`currency_code`))) join `exchange_rate` on((`pairs`.`currency_pair_id` = `exchange_rate`.`currency_pair_id`))) where (`pairs`.`to_currency_code` = 'RUB') order by `exchange_rate`.`rate_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_yuan_exchange_rate`
--

/*!50001 DROP VIEW IF EXISTS `v_yuan_exchange_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_yuan_exchange_rate` AS select `currency_from`.`currency_code` AS `from_currency`,`currency_from`.`chinese_name` AS `from_currency_chinese_name`,(`exchange_rate`.`rate` / `exchange_rate`.`rate`) AS `from_currency_value`,`currency_to`.`currency_code` AS `to_currency`,`currency_to`.`chinese_name` AS `to_currency_chinese_name`,`exchange_rate`.`rate` AS `exchange_rate`,`exchange_rate`.`rate_date` AS `exchange_rate_date` from (((`exchange_currency_pair` `pairs` join `currency` `currency_from` on((`pairs`.`from_currency_code` = `currency_from`.`currency_code`))) join `currency` `currency_to` on((`pairs`.`to_currency_code` = `currency_to`.`currency_code`))) join `exchange_rate` on((`pairs`.`currency_pair_id` = `exchange_rate`.`currency_pair_id`))) where (`pairs`.`to_currency_code` = 'CNY') order by `exchange_rate`.`rate_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-24 12:55:29
