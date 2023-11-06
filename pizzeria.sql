-- MySQL Script generated by MySQL Workbench
-- Thu Nov  2 10:58:53 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provinces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provinces` (
  `id_province` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_province`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`cities` (
  `id_city` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `provinces_id_province` INT NOT NULL,
  PRIMARY KEY (`id_city`, `provinces_id_province`),
  INDEX `fk_cities_provinces1_idx` (`provinces_id_province` ASC) VISIBLE,
  CONSTRAINT `fk_cities_provinces1`
    FOREIGN KEY (`provinces_id_province`)
    REFERENCES `pizzeria`.`provinces` (`id_province`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`restaurant` (
  `id_restaurant` INT NOT NULL AUTO_INCREMENT,
  `postal_code` INT(5) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `cities_id_city` INT NOT NULL,
  PRIMARY KEY (`id_restaurant`),
  INDEX `fk_restaurant_cities1_idx` (`cities_id_city` ASC) VISIBLE,
  CONSTRAINT `fk_restaurant_cities1`
    FOREIGN KEY (`cities_id_city`)
    REFERENCES `pizzeria`.`cities` (`id_city`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`employees` (
  `id_employee` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(9) NOT NULL,
  `phone` INT(9) NOT NULL,
  `type` ENUM('C', 'D') NOT NULL COMMENT 'Cook or Delivery',
  `restaurant_id_restaurant` INT NOT NULL,
  PRIMARY KEY (`id_employee`),
  INDEX `fk_employees_restaurant1_idx` (`restaurant_id_restaurant` ASC) VISIBLE,
  CONSTRAINT `fk_employees_restaurant1`
    FOREIGN KEY (`restaurant_id_restaurant`)
    REFERENCES `pizzeria`.`restaurant` (`id_restaurant`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`client` (
  `id_client` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `postal_code` INT(5) NOT NULL,
  `phone` INT(9) NOT NULL,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cities_id_city` INT NOT NULL,
  PRIMARY KEY (`id_client`),
  INDEX `fk_client_cities1_idx` (`cities_id_city` ASC) VISIBLE,
  CONSTRAINT `fk_client_cities1`
    FOREIGN KEY (`cities_id_city`)
    REFERENCES `pizzeria`.`cities` (`id_city`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `pizzeria`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order` (
  `id_order` INT NOT NULL AUTO_INCREMENT,
  `time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('PU', 'D') NOT NULL COMMENT 'Pick Up or Delivery',
  `total` DOUBLE NOT NULL,
  `id_employee` INT NULL DEFAULT NULL,
  `id_client` INT NOT NULL,
  `restaurant_id_restaurant` INT NOT NULL,
  PRIMARY KEY (`id_order`),
  INDEX `fk_ord_em_idx` (`id_employee` ASC) VISIBLE,
  INDEX `fk_order_client1_idx` (`id_client` ASC) VISIBLE,
  INDEX `fk_order_restaurant1_idx` (`restaurant_id_restaurant` ASC) VISIBLE,
  CONSTRAINT `fk_ord_em`
    FOREIGN KEY (`id_employee`)
    REFERENCES `pizzeria`.`employees` (`id_employee`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_client1`
    FOREIGN KEY (`id_client`)
    REFERENCES `pizzeria`.`client` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_restaurant1`
    FOREIGN KEY (`restaurant_id_restaurant`)
    REFERENCES `pizzeria`.`restaurant` (`id_restaurant`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`products` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `image` VARCHAR(255) NULL DEFAULT NULL,
  `price` DOUBLE NOT NULL,
  PRIMARY KEY (`id_product`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`hamburgers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`hamburgers` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_product`),
  CONSTRAINT `fk_ham_pr`
    FOREIGN KEY (`id_product`)
    REFERENCES `pizzeria`.`products` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`drinks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`drinks` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_product`),
  CONSTRAINT `fk_dri_pr`
    FOREIGN KEY (`id_product`)
    REFERENCES `pizzeria`.`products` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pizza_categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pizza_categories` (
  `id_pizza_category` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_pizza_category`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pizzas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pizzas` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  `id_pizza_category` INT NOT NULL,
  PRIMARY KEY (`id_product`),
  INDEX `fk_pizzas_pizza_category1_idx` (`id_pizza_category` ASC) VISIBLE,
  CONSTRAINT `fk_piz_pr`
    FOREIGN KEY (`id_product`)
    REFERENCES `pizzeria`.`products` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_piz_pc`
    FOREIGN KEY (`id_pizza_category`)
    REFERENCES `pizzeria`.`pizza_categories` (`id_pizza_category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`order_has_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order_has_products` (
  `id_order` INT NOT NULL,
  `id_product` INT NOT NULL,
  PRIMARY KEY (`id_order`, `id_product`),
  INDEX `fk_order_has_products_products1_idx` (`id_product` ASC) VISIBLE,
  INDEX `fk_order_has_products_order1_idx` (`id_order` ASC) VISIBLE,
  CONSTRAINT `fk_order_has_products_order1`
    FOREIGN KEY (`id_order`)
    REFERENCES `pizzeria`.`order` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_has_products_products1`
    FOREIGN KEY (`id_product`)
    REFERENCES `pizzeria`.`products` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
