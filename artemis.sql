-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                10.6.4-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Versie:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Databasestructuur van arte wordt geschreven
CREATE DATABASE IF NOT EXISTS `arte` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `arte`;

-- Structuur van  tabel arte.appartments-stashes wordt geschreven
CREATE TABLE IF NOT EXISTS `appartments-stashes` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.banking-safes wordt geschreven
CREATE TABLE IF NOT EXISTS `banking-safes` (
  `id` longtext DEFAULT NULL,
  `amount` bigint(20) DEFAULT NULL,
  `type` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.bans wordt geschreven
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` longtext DEFAULT NULL,
  `license` longtext DEFAULT NULL,
  `discord` longtext DEFAULT NULL,
  `steam` longtext DEFAULT NULL,
  `hwid` longtext DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  `expire` bigint(20) DEFAULT NULL,
  `bannedby` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.characters wordt geschreven
CREATE TABLE IF NOT EXISTS `characters` (
  `steam` varchar(50) DEFAULT NULL,
  `playerdata` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `slot` int(11) DEFAULT NULL,
  `citizenid` longtext DEFAULT NULL,
  `money` longtext DEFAULT NULL,
  `job` longtext DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `identifiers` longtext DEFAULT NULL,
  `genetics` longtext DEFAULT NULL,
  `crew` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.citizen_inventory wordt geschreven
CREATE TABLE IF NOT EXISTS `citizen_inventory` (
  `uniqueid` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.citizen_vehicles wordt geschreven
CREATE TABLE IF NOT EXISTS `citizen_vehicles` (
  `citizenid` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `mods` longtext DEFAULT NULL,
  `location` longtext DEFAULT NULL,
  `coord` longtext DEFAULT NULL,
  `plate` longtext DEFAULT NULL,
  `slot` int(11) DEFAULT NULL,
  `fuel` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.crew-stashes wordt geschreven
CREATE TABLE IF NOT EXISTS `crew-stashes` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.dashboards wordt geschreven
CREATE TABLE IF NOT EXISTS `dashboards` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.houses wordt geschreven
CREATE TABLE IF NOT EXISTS `houses` (
  `houseid` longtext DEFAULT NULL,
  `location` longtext DEFAULT NULL,
  `drives` longtext DEFAULT NULL,
  `garage` longtext DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `keyholders` longtext DEFAULT NULL,
  `interior` longtext DEFAULT NULL,
  `objects` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.houses-stashes wordt geschreven
CREATE TABLE IF NOT EXISTS `houses-stashes` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.job-inv wordt geschreven
CREATE TABLE IF NOT EXISTS `job-inv` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.meos-decs wordt geschreven
CREATE TABLE IF NOT EXISTS `meos-decs` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` longtext DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `text` longtext DEFAULT NULL,
  `creator` longtext DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.meos-fines wordt geschreven
CREATE TABLE IF NOT EXISTS `meos-fines` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `price` longtext DEFAULT NULL,
  `artikel` longtext DEFAULT NULL,
  `creator` longtext NOT NULL,
  `citizenid` longtext DEFAULT NULL,
  `job` longtext DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.meos-reports wordt geschreven
CREATE TABLE IF NOT EXISTS `meos-reports` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` longtext DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `text` longtext DEFAULT NULL,
  `creator` longtext DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.modifications wordt geschreven
CREATE TABLE IF NOT EXISTS `modifications` (
  `plate` longtext DEFAULT NULL,
  `wheeldata` longtext DEFAULT NULL,
  `nos` int(11) DEFAULT 0,
  `nos_fuel` bigint(20) DEFAULT 0,
  `fuel` bigint(20) DEFAULT 0,
  `2step` int(11) DEFAULT 0,
  `radio` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.outfits wordt geschreven
CREATE TABLE IF NOT EXISTS `outfits` (
  `citizenid` longtext DEFAULT NULL,
  `index` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `skindata` longtext DEFAULT NULL,
  `label` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.pets wordt geschreven
CREATE TABLE IF NOT EXISTS `pets` (
  `id` longtext NOT NULL,
  `citizenid` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `dead` int(11) DEFAULT NULL,
  `loc` longtext DEFAULT NULL,
  `sleeping` int(11) DEFAULT NULL,
  `variation` int(11) DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `mods` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.phone wordt geschreven
CREATE TABLE IF NOT EXISTS `phone` (
  `citizenid` longtext DEFAULT NULL,
  `settings` longtext DEFAULT NULL,
  `phonedata` longtext DEFAULT NULL,
  `number` longtext DEFAULT NULL,
  `paypal` longtext DEFAULT NULL,
  `contacts` longtext DEFAULT NULL,
  `whatsapp` longtext DEFAULT NULL,
  `twitter` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.phone-messages wordt geschreven
CREATE TABLE IF NOT EXISTS `phone-messages` (
  `index` longtext DEFAULT NULL,
  `history` longtext DEFAULT NULL,
  `date` longtext DEFAULT NULL,
  `number_one` longtext DEFAULT NULL,
  `number_two` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.phonedata wordt geschreven
CREATE TABLE IF NOT EXISTS `phonedata` (
  `stateid` longtext DEFAULT NULL,
  `images` longtext DEFAULT NULL,
  `settings` longtext DEFAULT NULL,
  `number` longtext DEFAULT NULL,
  `contacts` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.roles wordt geschreven
CREATE TABLE IF NOT EXISTS `roles` (
  `index` longtext DEFAULT NULL,
  `group` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.settings wordt geschreven
CREATE TABLE IF NOT EXISTS `settings` (
  `citizenid` longtext DEFAULT NULL,
  `keybinds` longtext DEFAULT NULL,
  `background` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.trunks wordt geschreven
CREATE TABLE IF NOT EXISTS `trunks` (
  `index` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.tuner wordt geschreven
CREATE TABLE IF NOT EXISTS `tuner` (
  `citizenid` longtext DEFAULT NULL,
  `plate` longtext DEFAULT NULL,
  `mods` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `location` longtext DEFAULT 'NONE'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel arte.vehicle-charges wordt geschreven
CREATE TABLE IF NOT EXISTS `vehicle-charges` (
  `plate` longtext DEFAULT NULL,
  `charge` longtext DEFAULT NULL,
  `officer` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporteren was gedeselecteerd

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
