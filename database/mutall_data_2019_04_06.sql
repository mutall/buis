-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 06, 2019 at 06:48 AM
-- Server version: 10.3.14-MariaDB
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mutallco_data`
--

-- --------------------------------------------------------

--
-- Table structure for table `adjustment`
--

CREATE TABLE `adjustment` (
  `adjustment` int(10) NOT NULL,
  `posted_item` int(10) DEFAULT NULL,
  `client` int(10) DEFAULT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `reason` longtext DEFAULT NULL,
  `date` date DEFAULT NULL,
  `debit` double DEFAULT NULL,
  `credit` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `assignment`
--

CREATE TABLE `assignment` (
  `assignment` int(10) NOT NULL,
  `client` int(10) DEFAULT NULL,
  `staff` int(10) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `lesson` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `attribute`
--

CREATE TABLE `attribute` (
  `attribute` int(10) NOT NULL,
  `entity` int(10) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `position` int(5) DEFAULT NULL,
  `default` varchar(30) DEFAULT NULL,
  `is_nullable` varchar(30) DEFAULT NULL,
  `data_type` varchar(30) DEFAULT NULL,
  `character_maximum_length` int(5) DEFAULT NULL,
  `numeric_precision` varchar(50) DEFAULT NULL,
  `numeric_scale` varchar(30) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  `comment` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `balance_initial`
--

CREATE TABLE `balance_initial` (
  `balance_initial` int(10) NOT NULL,
  `client` int(10) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `debit` double DEFAULT NULL,
  `credit` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `logo` varchar(225) DEFAULT NULL,
  `motto` varchar(100) NOT NULL,
  `type` varchar(20) DEFAULT NULL,
  `password` varchar(30) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `database` varchar(225) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client`, `name`, `logo`, `motto`, `type`, `password`, `email`, `phone`, `website`, `database`) VALUES
(1, 'Mutall_Data', 'logo.png', 'Making Data Usefull', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutall_data%20/', 'mutallco_data'),
(2, 'Eureka Waters', 'eureka.png', 'Beyond Expectation', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutall_eureka_waters/', 'mutallco_eureka_waters'),
(3, 'Mutall Property', 'mutall.png', '', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutall_project/', 'mutallco_properties'),
(4, 'Mutall Rental', NULL, '', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutall_rental/home.php', 'mutallco_rental'),
(5, 'Mutall Real Estate', NULL, '', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutallco_real_estate/', 'mutallco_real_estate'),
(6, 'Mutallco Tourism', NULL, '', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mutallco_tourism/', 'mutallco_tourism'),
(7, 'Deekos Bakery', 'deekem.png', '', NULL, NULL, NULL, NULL, 'http://deekos.mutall.co.ke/', 'mutallco_deekos'),
(8, 'Giraffe Ark Game Lodge', 'giraffearklogo.png', 'Unveiling a trully hidden tourism gem in Nyeri', NULL, NULL, NULL, NULL, 'http://www.giraffeark.com/', 'mutallco_giraffe_ark'),
(9, 'Mountain Top Safari Tour and Travel', 'mountaintoplogo.png', '', NULL, NULL, NULL, NULL, 'http://mountaintopsafarisadventures.co.ke/', 'mutallco_mountain_top'),
(10, 'Friends of Ngong Hills', NULL, '', NULL, NULL, NULL, NULL, 'http://mutall.co.ke/mlima/', 'mutallco_mlima'),
(11, 'Karen Direct Insurance', 'karendirect.png', 'Get Insured', NULL, NULL, NULL, NULL, NULL, 'mutallco_karen'),
(12, 'Chick Joint', 'chickjoint.png', '', NULL, NULL, NULL, NULL, NULL, NULL),
(13, 'Mzalendo Saba Saba Party of Kenya', NULL, '', NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'mutallco', NULL, '', NULL, 'mutall_2015', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `columns`
--

CREATE TABLE `columns` (
  `TABLE_CATALOG` varchar(512) DEFAULT NULL,
  `TABLE_SCHEMA` varchar(64) DEFAULT NULL,
  `TABLE_NAME` varchar(64) DEFAULT NULL,
  `COLUMN_NAME` varchar(64) DEFAULT NULL,
  `ORDINAL_POSITION` bigint(21) UNSIGNED DEFAULT NULL,
  `COLUMN_DEFAULT` longtext DEFAULT NULL,
  `IS_NULLABLE` varchar(3) DEFAULT NULL,
  `DATA_TYPE` varchar(64) DEFAULT NULL,
  `CHARACTER_MAXIMUM_LENGTH` bigint(21) UNSIGNED DEFAULT NULL,
  `CHARACTER_OCTET_LENGTH` bigint(21) UNSIGNED DEFAULT NULL,
  `NUMERIC_PRECISION` bigint(21) UNSIGNED DEFAULT NULL,
  `NUMERIC_SCALE` bigint(21) UNSIGNED DEFAULT NULL,
  `DATETIME_PRECISION` bigint(21) UNSIGNED DEFAULT NULL,
  `CHARACTER_SET_NAME` varchar(32) DEFAULT NULL,
  `COLLATION_NAME` varchar(32) DEFAULT NULL,
  `COLUMN_TYPE` longtext DEFAULT NULL,
  `COLUMN_KEY` varchar(3) DEFAULT NULL,
  `EXTRA` varchar(27) DEFAULT NULL,
  `PRIVILEGES` varchar(80) DEFAULT NULL,
  `COLUMN_COMMENT` varchar(1024) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dbase`
--

CREATE TABLE `dbase` (
  `dbase` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `entity`
--

CREATE TABLE `entity` (
  `entity` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `dbase` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `invoice` int(10) NOT NULL,
  `client` int(10) DEFAULT NULL,
  `period` int(10) DEFAULT NULL,
  `valid` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `month`
--

CREATE TABLE `month` (
  `month` int(10) NOT NULL,
  `num` int(10) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `long_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment` int(10) NOT NULL,
  `client` int(10) DEFAULT NULL,
  `posted_item` int(10) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `date` date DEFAULT NULL,
  `ref` varchar(255) DEFAULT NULL,
  `marked` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `period`
--

CREATE TABLE `period` (
  `period` int(10) NOT NULL,
  `month` int(10) DEFAULT NULL,
  `year` int(5) DEFAULT NULL,
  `is_current` int(1) NOT NULL,
  `is_initial` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `picture`
--

CREATE TABLE `picture` (
  `picture` int(10) NOT NULL,
  `picture_folder` int(10) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `staff` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `picture`
--

INSERT INTO `picture` (`picture`, `picture_folder`, `image`, `type`, `size`, `date`, `staff`) VALUES
(2, NULL, 'peter.jpg', NULL, NULL, NULL, 1),
(3, NULL, 'dennis.jpg', NULL, NULL, NULL, 3),
(4, NULL, 'camilus.jpg', NULL, NULL, NULL, 4),
(5, NULL, 'james.jpg', NULL, NULL, NULL, 5),
(7, NULL, 'samuel.jpg', 'jpg', NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `picture_folder`
--

CREATE TABLE `picture_folder` (
  `picture_folder` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `keyword` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `posted_item`
--

CREATE TABLE `posted_item` (
  `posted_item` int(10) NOT NULL,
  `invoice` int(10) DEFAULT NULL,
  `source` int(10) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `debit` double DEFAULT NULL,
  `credit` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `relation`
--

CREATE TABLE `relation` (
  `relation` int(10) NOT NULL,
  `attribute` int(10) DEFAULT NULL,
  `entity` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `serialization`
--

CREATE TABLE `serialization` (
  `serialization` int(10) NOT NULL,
  `entity` int(10) DEFAULT NULL,
  `sql_edit` longtext DEFAULT NULL,
  `sql_selector` longtext DEFAULT NULL,
  `error` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `source`
--

CREATE TABLE `source` (
  `source` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff`, `name`, `role`) VALUES
(1, 'Peter Muraya', 'Program Cordinator'),
(2, 'Samuel Njoroge', 'Programmer'),
(3, 'Dennis Njuguna', 'Programmer'),
(4, 'Camilus Odhiambo', 'Communications'),
(5, 'James Mwareri', 'Programmer');

-- --------------------------------------------------------

--
-- Table structure for table `sub_assignment`
--

CREATE TABLE `sub_assignment` (
  `sub_assignment` int(10) NOT NULL,
  `assignment` int(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `done` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `template`
--

CREATE TABLE `template` (
  `template` int(10) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adjustment`
--
ALTER TABLE `adjustment`
  ADD PRIMARY KEY (`adjustment`),
  ADD UNIQUE KEY `id` (`client`,`purpose`,`date`),
  ADD KEY `posted_item` (`posted_item`);

--
-- Indexes for table `assignment`
--
ALTER TABLE `assignment`
  ADD PRIMARY KEY (`assignment`),
  ADD UNIQUE KEY `id` (`staff`),
  ADD KEY `client` (`client`);

--
-- Indexes for table `attribute`
--
ALTER TABLE `attribute`
  ADD PRIMARY KEY (`attribute`),
  ADD UNIQUE KEY `id` (`entity`,`name`);

--
-- Indexes for table `balance_initial`
--
ALTER TABLE `balance_initial`
  ADD PRIMARY KEY (`balance_initial`),
  ADD UNIQUE KEY `id` (`client`,`date`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client`),
  ADD UNIQUE KEY `id` (`name`);

--
-- Indexes for table `dbase`
--
ALTER TABLE `dbase`
  ADD PRIMARY KEY (`dbase`),
  ADD UNIQUE KEY `id` (`name`);

--
-- Indexes for table `entity`
--
ALTER TABLE `entity`
  ADD PRIMARY KEY (`entity`),
  ADD UNIQUE KEY `id` (`dbase`,`name`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`invoice`),
  ADD UNIQUE KEY `id` (`client`,`valid`,`period`),
  ADD KEY `period` (`period`);

--
-- Indexes for table `month`
--
ALTER TABLE `month`
  ADD PRIMARY KEY (`month`),
  ADD UNIQUE KEY `id` (`num`),
  ADD UNIQUE KEY `id2` (`name`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment`),
  ADD UNIQUE KEY `id` (`client`,`amount`,`date`),
  ADD KEY `posted_item` (`posted_item`);

--
-- Indexes for table `period`
--
ALTER TABLE `period`
  ADD PRIMARY KEY (`period`),
  ADD UNIQUE KEY `id` (`year`,`month`),
  ADD KEY `month` (`month`);

--
-- Indexes for table `picture`
--
ALTER TABLE `picture`
  ADD PRIMARY KEY (`picture`),
  ADD UNIQUE KEY `id` (`image`),
  ADD KEY `picture_folder` (`picture_folder`),
  ADD KEY `staff` (`staff`);

--
-- Indexes for table `picture_folder`
--
ALTER TABLE `picture_folder`
  ADD PRIMARY KEY (`picture_folder`),
  ADD UNIQUE KEY `id` (`name`);

--
-- Indexes for table `posted_item`
--
ALTER TABLE `posted_item`
  ADD PRIMARY KEY (`posted_item`),
  ADD UNIQUE KEY `id` (`source`,`code`),
  ADD KEY `invoice` (`invoice`);

--
-- Indexes for table `relation`
--
ALTER TABLE `relation`
  ADD PRIMARY KEY (`relation`),
  ADD UNIQUE KEY `id` (`entity`,`attribute`),
  ADD KEY `attribute` (`attribute`);

--
-- Indexes for table `serialization`
--
ALTER TABLE `serialization`
  ADD PRIMARY KEY (`serialization`),
  ADD UNIQUE KEY `id` (`entity`);

--
-- Indexes for table `source`
--
ALTER TABLE `source`
  ADD PRIMARY KEY (`source`),
  ADD UNIQUE KEY `id` (`name`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff`),
  ADD UNIQUE KEY `id` (`name`);

--
-- Indexes for table `sub_assignment`
--
ALTER TABLE `sub_assignment`
  ADD PRIMARY KEY (`sub_assignment`),
  ADD UNIQUE KEY `id` (`done`),
  ADD KEY `assignment` (`assignment`);

--
-- Indexes for table `template`
--
ALTER TABLE `template`
  ADD PRIMARY KEY (`template`),
  ADD UNIQUE KEY `id` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adjustment`
--
ALTER TABLE `adjustment`
  MODIFY `adjustment` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `assignment`
--
ALTER TABLE `assignment`
  MODIFY `assignment` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `attribute`
--
ALTER TABLE `attribute`
  MODIFY `attribute` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `balance_initial`
--
ALTER TABLE `balance_initial`
  MODIFY `balance_initial` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `dbase`
--
ALTER TABLE `dbase`
  MODIFY `dbase` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `entity`
--
ALTER TABLE `entity`
  MODIFY `entity` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `invoice` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `month`
--
ALTER TABLE `month`
  MODIFY `month` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `payment` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `period`
--
ALTER TABLE `period`
  MODIFY `period` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `picture`
--
ALTER TABLE `picture`
  MODIFY `picture` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `picture_folder`
--
ALTER TABLE `picture_folder`
  MODIFY `picture_folder` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posted_item`
--
ALTER TABLE `posted_item`
  MODIFY `posted_item` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `relation`
--
ALTER TABLE `relation`
  MODIFY `relation` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `serialization`
--
ALTER TABLE `serialization`
  MODIFY `serialization` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `source`
--
ALTER TABLE `source`
  MODIFY `source` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sub_assignment`
--
ALTER TABLE `sub_assignment`
  MODIFY `sub_assignment` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `template`
--
ALTER TABLE `template`
  MODIFY `template` int(10) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `adjustment`
--
ALTER TABLE `adjustment`
  ADD CONSTRAINT `adjustment_ibfk_1` FOREIGN KEY (`posted_item`) REFERENCES `posted_item` (`posted_item`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `adjustment_ibfk_2` FOREIGN KEY (`client`) REFERENCES `client` (`client`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `assignment`
--
ALTER TABLE `assignment`
  ADD CONSTRAINT `assignment_ibfk_1` FOREIGN KEY (`client`) REFERENCES `client` (`client`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `assignment_ibfk_2` FOREIGN KEY (`staff`) REFERENCES `staff` (`staff`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `attribute`
--
ALTER TABLE `attribute`
  ADD CONSTRAINT `attribute_ibfk_1` FOREIGN KEY (`entity`) REFERENCES `entity` (`entity`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `balance_initial`
--
ALTER TABLE `balance_initial`
  ADD CONSTRAINT `balance_initial_ibfk_1` FOREIGN KEY (`client`) REFERENCES `client` (`client`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `entity`
--
ALTER TABLE `entity`
  ADD CONSTRAINT `entity_ibfk_1` FOREIGN KEY (`dbase`) REFERENCES `dbase` (`dbase`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`client`) REFERENCES `client` (`client`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`period`) REFERENCES `period` (`period`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`client`) REFERENCES `client` (`client`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`posted_item`) REFERENCES `posted_item` (`posted_item`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `period`
--
ALTER TABLE `period`
  ADD CONSTRAINT `period_ibfk_1` FOREIGN KEY (`month`) REFERENCES `month` (`month`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `picture`
--
ALTER TABLE `picture`
  ADD CONSTRAINT `picture_ibfk_1` FOREIGN KEY (`picture_folder`) REFERENCES `picture_folder` (`picture_folder`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `picture_ibfk_2` FOREIGN KEY (`staff`) REFERENCES `staff` (`staff`);

--
-- Constraints for table `posted_item`
--
ALTER TABLE `posted_item`
  ADD CONSTRAINT `posted_item_ibfk_1` FOREIGN KEY (`invoice`) REFERENCES `invoice` (`invoice`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `posted_item_ibfk_2` FOREIGN KEY (`source`) REFERENCES `source` (`source`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `relation`
--
ALTER TABLE `relation`
  ADD CONSTRAINT `relation_ibfk_1` FOREIGN KEY (`attribute`) REFERENCES `attribute` (`attribute`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `relation_ibfk_2` FOREIGN KEY (`entity`) REFERENCES `entity` (`entity`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `serialization`
--
ALTER TABLE `serialization`
  ADD CONSTRAINT `serialization_ibfk_1` FOREIGN KEY (`entity`) REFERENCES `entity` (`entity`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sub_assignment`
--
ALTER TABLE `sub_assignment`
  ADD CONSTRAINT `sub_assignment_ibfk_1` FOREIGN KEY (`assignment`) REFERENCES `assignment` (`assignment`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
