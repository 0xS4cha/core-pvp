-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           11.7.2-MariaDB - mariadb.org binary distribution
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.16.0.7229
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `blacklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Steam` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `SteamLink` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `playerName` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `DiscordUID` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `DiscordTag` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `GameLicense` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `ip` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `xbl` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `live` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `BanType` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `reason` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Date` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Banner` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `Token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Expiration` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `blacklist` (`id`, `Steam`, `SteamLink`, `playerName`, `DiscordUID`, `DiscordTag`, `GameLicense`, `ip`, `xbl`, `live`, `BanType`, `reason`, `Date`, `Banner`, `Token`, `Expiration`) VALUES
	(1, 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', '["4:400423cff244c62ba608afcd","4:a602bf2a8924fb0a0aa2bbf8","1:88ac322ede187a4e5a3e","4:52caf4d1cbf74644027a","4:977779c330b6e2d1","4:c7c9b5edb0496","3:5cdbfecf14603956222deae","4:d9a5db096cb4cb8e","4:9f81247074b53bce190eb"]', 1744218746);

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) DEFAULT NULL,
  `playerName` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL,
  `permission` int(11) NOT NULL DEFAULT 0,
  `vip` int(11) DEFAULT NULL,
  `cloths` text NOT NULL,
  `active` float NOT NULL,
  `playerName` varchar(255) DEFAULT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `liveid` varchar(255) DEFAULT NULL,
  `xblid` varchar(255) DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `playerip` varchar(255) DEFAULT NULL,
  `first_connection` datetime DEFAULT current_timestamp(),
  `playtime` varchar(50) NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

CREATE TABLE IF NOT EXISTS `players_adverts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `staff` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `players_scene` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `players_skin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `players_vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player` int(11) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
