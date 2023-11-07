-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica_cul_d_ampolla
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optica_cul_d_ampolla
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica_cul_d_ampolla` DEFAULT CHARACTER SET utf8 ;
USE `optica_cul_d_ampolla` ;

-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`addresses` (
  `id_address` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `street` VARCHAR(45) NOT NULL,
  `number` INT UNSIGNED NULL DEFAULT NULL,
  `floor` VARCHAR(20) NULL DEFAULT NULL,
  `door` VARCHAR(45) NULL DEFAULT NULL,
  `city` VARCHAR(45) NOT NULL,
  `postal_code` INT(5) NOT NULL,
  `country` VARCHAR(3) NOT NULL COMMENT 'Address country ISO format',
  PRIMARY KEY (`id_address`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`suppliers` (
  `id_supplier` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `id_address` INT UNSIGNED NOT NULL,
  `phone` INT(9) UNSIGNED NOT NULL,
  `fax` INT UNSIGNED NOT NULL,
  `nif` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id_supplier`),
  UNIQUE INDEX `NIF_UNIQUE` (`nif` ASC) ,
  INDEX `fk_sup_ad_idx` (`id_address` ASC),
  CONSTRAINT `fk_sup_ad`
    FOREIGN KEY (`id_address`)
    REFERENCES `optica_cul_d_ampolla`.`addresses` (`id_address`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`brands`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`brands` (
  `id_brand` INT UNSIGNED NOT NULL COMMENT '\n',
  `name` VARCHAR(45) NOT NULL,
  `id_supplier` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_brand`),
  INDEX `fk_brands_suppliers1_idx` (`id_supplier` ASC) ,
  CONSTRAINT `fk_brands_suppliers1`
    FOREIGN KEY (`id_supplier`)
    REFERENCES `optica_cul_d_ampolla`.`suppliers` (`id_supplier`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`glasses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`glasses` (
  `id_glasses` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_brand` INT UNSIGNED NOT NULL,
  `prescription` VARCHAR(15) NOT NULL COMMENT '(+-left, +-right)',
  `frame_type` ENUM('flotant', 'pasta', 'metalica') NOT NULL,
  `frame_colour` VARCHAR(45) NOT NULL,
  `glass_colour` VARCHAR(45) NOT NULL,
  `price` DOUBLE UNSIGNED NOT NULL,
  PRIMARY KEY (`id_glasses`),
  INDEX `fk_glasses_brands1_idx` (`id_brand` ASC) ,
  CONSTRAINT `fk_glasses_brands1`
    FOREIGN KEY (`id_brand`)
    REFERENCES `optica_cul_d_ampolla`.`brands` (`id_brand`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`clients` (
  `id_client` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'client ID',
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL COMMENT 'client\'s last name',
  `phone` INT(9) UNSIGNED NOT NULL,
  `mail` VARCHAR(254) NOT NULL,
  `register_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recommended_by` INT UNSIGNED NULL DEFAULT NULL,
  `id_address` INT UNSIGNED NOT NULL,
  INDEX `fk_clients_addresses1_idx` (`id_address` ASC) ,
  PRIMARY KEY (`id_client`),
  CONSTRAINT `fk_clients_ad`
    FOREIGN KEY (`id_address`)
    REFERENCES `optica_cul_d_ampolla`.`addresses` (`id_address`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_clients_rec`
    FOREIGN KEY (`recommended_by`)
    REFERENCES `optica_cul_d_ampolla`.`clients` (`id_client`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`employees` (
  `id_employees` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_employees`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`client_buys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`client_buys` (
  `id_transaction` INT UNSIGNED NOT NULL,
  `id_client` INT UNSIGNED NOT NULL,
  `id_glasses` INT UNSIGNED NOT NULL,
  `id_employee` INT UNSIGNED NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaction`, `id_client`, `id_glasses`),
  INDEX `fk_buy_cl_idx` (`id_client` ASC) ,
  INDEX `fk_buy_gl_idx` (`id_glasses` ASC) ,
  INDEX `fk_buy_em_idx` (`id_employee` ASC) ,
  CONSTRAINT `fk_buy_cl`
    FOREIGN KEY (`id_client`)
    REFERENCES `optica_cul_d_ampolla`.`clients` (`id_client`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_buy_gl`
    FOREIGN KEY (`id_glasses`)
    REFERENCES `optica_cul_d_ampolla`.`glasses` (`id_glasses`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_buy_em`
    FOREIGN KEY (`id_employee`)
    REFERENCES `optica_cul_d_ampolla`.`employees` (`id_employees`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
