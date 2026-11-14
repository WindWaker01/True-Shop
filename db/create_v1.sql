-- True Shop: database structure (trueshop)
-- Generated from live DB (matches the Reverse-Engineered EER diagram)

CREATE DATABASE IF NOT EXISTS trueshop DEFAULT CHARACTER SET utf8mb4;
USE trueshop;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `manufacturirs`;
CREATE TABLE `manufacturirs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `suppliers`;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `orderstatus`;
CREATE TABLE `orderstatus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(60) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_role` (`role_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pvz`;
CREATE TABLE `pvz` (
  `id` int NOT NULL AUTO_INCREMENT,
  `postcode` char(6) NOT NULL,
  `city` varchar(30) NOT NULL,
  `street` varchar(35) NOT NULL,
  `house` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `article` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `unit` varchar(10) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `supplier_id` int NOT NULL,
  `manufacturer_id` int NOT NULL,
  `category_id` int NOT NULL,
  `discount` int NOT NULL,
  `stock_qty` int NOT NULL,
  `description` text,
  `photo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_products_category` (`category_id`),
  KEY `fk_products_manufacturer` (`manufacturer_id`),
  KEY `fk_products_supplier` (`supplier_id`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `fk_products_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturirs` (`id`),
  CONSTRAINT `fk_products_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_date` datetime NOT NULL,
  `delivery_date` datetime DEFAULT NULL,
  `pvz_id` int NOT NULL,
  `user_id` int NOT NULL,
  `receive_code` varchar(10) NOT NULL,
  `status_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_orders_pvz` (`pvz_id`),
  KEY `fk_orders_user` (`user_id`),
  KEY `fk_orders_status` (`status_id`),
  CONSTRAINT `fk_orders_pvz` FOREIGN KEY (`pvz_id`) REFERENCES `pvz` (`id`),
  CONSTRAINT `fk_orders_status` FOREIGN KEY (`status_id`) REFERENCES `orderstatus` (`id`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `prodorders`;
CREATE TABLE `prodorders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `qty` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_prodorders_order` (`order_id`),
  KEY `fk_prodorders_product` (`product_id`),
  CONSTRAINT `fk_prodorders_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_prodorders_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;