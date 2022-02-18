-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 18, 2022 at 11:59 AM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 7.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ocpp`
--

-- --------------------------------------------------------

--
-- Table structure for table `connector_meter_value`
--

CREATE TABLE `connector_meter_value` (
  `connector_pk` int(11) UNSIGNED NOT NULL,
  `transaction_pk` int(10) UNSIGNED DEFAULT NULL,
  `value_timestamp` timestamp(6) NULL DEFAULT NULL,
  `value` text DEFAULT NULL,
  `context` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `measurand` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `phase` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `connector_meter_value`
--

INSERT INTO `connector_meter_value` (`connector_pk`, `transaction_pk`, `value_timestamp`, `value`, `context`, `format`, `measurand`, `location`, `unit`, `phase`) VALUES
(1, 10, '2022-02-18 01:06:37.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(1, 10, '2022-02-18 01:06:37.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(1, 10, '2022-02-18 01:06:37.000000', '642', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', 'L1'),
(5, 3, '2022-02-18 10:43:41.000000', '100', 'Sample.Periodic', 'Raw', 'Energy.Active.Import.Register', 'Outlet', 'Wh', NULL),
(5, 3, '2022-02-18 10:43:41.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(5, 3, '2022-02-18 10:43:41.000000', '642', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', 'L1'),
(5, 4, '2022-02-18 10:49:48.000000', '100', 'Sample.Periodic', 'Raw', 'Energy.Active.Import.Register', 'Outlet', 'Wh', NULL),
(5, 4, '2022-02-18 10:49:48.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(5, 4, '2022-02-18 10:49:48.000000', '642', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', 'L1'),
(5, 4, '2022-02-18 10:49:52.000000', '100', 'Sample.Periodic', 'Raw', 'Energy.Active.Import.Register', 'Outlet', 'Wh', NULL),
(5, 4, '2022-02-18 10:49:52.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(5, 4, '2022-02-18 10:49:52.000000', '642', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', 'L1'),
(5, 4, '2022-02-18 10:49:53.000000', '100', 'Sample.Periodic', 'Raw', 'Energy.Active.Import.Register', 'Outlet', 'Wh', NULL),
(5, 4, '2022-02-18 10:49:53.000000', '1931', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', NULL),
(5, 4, '2022-02-18 10:49:53.000000', '642', 'Sample.Periodic', 'Raw', 'Power.Active.Import', 'Outlet', 'W', 'L1');

-- --------------------------------------------------------

--
-- Table structure for table `connector_status`
--

CREATE TABLE `connector_status` (
  `connector_pk` int(11) NOT NULL,
  `status_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `connector_status`
--

INSERT INTO `connector_status` (`connector_pk`, `status_timestamp`, `status`) VALUES
(2, '2022-02-18 10:50:08', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_start`
--

CREATE TABLE `transaction_start` (
  `transaction_pk` int(10) NOT NULL,
  `connector_pk` int(11) NOT NULL,
  `start_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `start_value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaction_start`
--

INSERT INTO `transaction_start` (`transaction_pk`, `connector_pk`, `start_timestamp`, `start_value`) VALUES
(1, 1, '2022-02-18 10:28:59.000000', ''),
(2, 2, '2022-02-18 10:34:38.000000', '0'),
(3, 2, '2022-02-18 10:43:35.000000', '0'),
(4, 2, '2022-02-18 10:49:44.000000', '0');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_stop`
--

CREATE TABLE `transaction_stop` (
  `transaction_pk` int(10) NOT NULL,
  `stop_timestamp` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `stop_value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaction_stop`
--

INSERT INTO `transaction_stop` (`transaction_pk`, `stop_timestamp`, `stop_value`) VALUES
(2, '2022-02-18 10:38:50.000000', '20'),
(3, '2022-02-18 10:44:33.000000', '20'),
(4, '2022-02-18 10:50:03.000000', '20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `connector_meter_value`
--
ALTER TABLE `connector_meter_value`
  ADD KEY `connector_pk` (`connector_pk`),
  ADD KEY `transaction_pk` (`transaction_pk`),
  ADD KEY `value_timestamp` (`value_timestamp`);

--
-- Indexes for table `connector_status`
--
ALTER TABLE `connector_status`
  ADD KEY `connector_pk` (`connector_pk`);

--
-- Indexes for table `transaction_start`
--
ALTER TABLE `transaction_start`
  ADD PRIMARY KEY (`transaction_pk`),
  ADD KEY `connector_pk` (`connector_pk`),
  ADD KEY `start_timestamp` (`start_timestamp`);

--
-- Indexes for table `transaction_stop`
--
ALTER TABLE `transaction_stop`
  ADD PRIMARY KEY (`transaction_pk`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `transaction_start`
--
ALTER TABLE `transaction_start`
  MODIFY `transaction_pk` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transaction_stop`
--
ALTER TABLE `transaction_stop`
  MODIFY `transaction_pk` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
