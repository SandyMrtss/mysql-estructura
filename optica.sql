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
  `id_address` INT NOT NULL AUTO_INCREMENT COMMENT 'Address id',
  `street` VARCHAR(45) NOT NULL COMMENT 'Address street',
  `number` INT NULL DEFAULT NULL COMMENT 'Oprtional address street number',
  `floor` INT NULL DEFAULT NULL COMMENT 'Optional: address floor ',
  `door` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Optional: address door',
  `city` VARCHAR(45) NOT NULL COMMENT 'Addres city',
  `postal_code` INT(5) NOT NULL COMMENT 'Address postal code 5 number format',
  `country` VARCHAR(3) NOT NULL COMMENT 'Address country ISO format',
  PRIMARY KEY (`id_address`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`suppliers` (
  `id_supplier` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'Supplier name',
  `id_address` INT NOT NULL COMMENT 'Supplier\'s address ID ',
  `phone` INT NOT NULL COMMENT 'Supplier\'s phone',
  `fax` INT NOT NULL COMMENT 'Supplier\'s fax',
  `nif` VARCHAR(9) NOT NULL COMMENT 'supplier\'s nif',
  PRIMARY KEY (`id_supplier`),
  UNIQUE INDEX `NIF_UNIQUE` (`nif` ASC) VISIBLE,
  INDEX `fk_sup_ad_idx` (`id_address` ASC) INVISIBLE,
  CONSTRAINT `fk_sup_ad`
    FOREIGN KEY (`id_address`)
    REFERENCES `optica_cul_d_ampolla`.`addresses` (`id_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`brands`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`brands` (
  `id_brand` INT NOT NULL COMMENT 'brand ID\n',
  `name` VARCHAR(45) NOT NULL COMMENT 'brand name',
  `id_supplier` INT NOT NULL,
  PRIMARY KEY (`id_brand`),
  INDEX `fk_brands_suppliers1_idx` (`id_supplier` ASC) VISIBLE,
  CONSTRAINT `fk_brands_suppliers1`
    FOREIGN KEY (`id_supplier`)
    REFERENCES `optica_cul_d_ampolla`.`suppliers` (`id_supplier`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`glasses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`glasses` (
  `id_glasses` INT NOT NULL AUTO_INCREMENT,
  `id_brand` INT NOT NULL,
  `prescription` DOUBLE NULL DEFAULT NULL,
  `frame_type` ENUM('flotant', 'pasta', 'metalica') NULL DEFAULT NULL COMMENT 'Frame type',
  `frame_colour` VARCHAR(45) NULL DEFAULT NULL,
  `glass_colour` VARCHAR(45) NULL DEFAULT NULL,
  `price` DOUBLE NOT NULL,
  PRIMARY KEY (`id_glasses`),
  INDEX `fk_glasses_brands1_idx` (`id_brand` ASC) VISIBLE,
  CONSTRAINT `fk_glasses_brands1`
    FOREIGN KEY (`id_brand`)
    REFERENCES `optica_cul_d_ampolla`.`brands` (`id_brand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`clients` (
  `id_client` INT NOT NULL AUTO_INCREMENT COMMENT 'client ID',
  `name` VARCHAR(45) NOT NULL COMMENT 'Client\'s first name',
  `last_name` VARCHAR(45) NOT NULL COMMENT 'client\'s last name',
  `phone` INT NOT NULL COMMENT 'client\'s phone number',
  `mail` VARCHAR(254) NOT NULL COMMENT 'client\'s mail',
  `register_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'client\'s register date',
  `recommended_by` INT NULL DEFAULT NULL COMMENT 'client that recommended ID',
  `id_address` INT NOT NULL COMMENT 'clients address id',
  INDEX `fk_clients_addresses1_idx` (`id_address` ASC) VISIBLE,
  PRIMARY KEY (`id_client`),
  CONSTRAINT `fk_clients_ad`
    FOREIGN KEY (`id_address`)
    REFERENCES `optica_cul_d_ampolla`.`addresses` (`id_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_clients_rec`
    FOREIGN KEY (`recommended_by`)
    REFERENCES `optica_cul_d_ampolla`.`clients` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`employees` (
  `id_employees` INT NOT NULL AUTO_INCREMENT COMMENT 'id employee',
  `name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_employees`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica_cul_d_ampolla`.`client_buys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica_cul_d_ampolla`.`client_buys` (
  `id_transaction` INT NOT NULL,
  `id_client` INT NOT NULL,
  `id_glasses` INT NOT NULL,
  `id_employee` INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaction`, `id_client`, `id_glasses`),
  INDEX `fk_buy_cl_idx` (`id_client` ASC) VISIBLE,
  INDEX `fk_buy_gl_idx` (`id_glasses` ASC) VISIBLE,
  INDEX `fk_buy_em_idx` (`id_employee` ASC) VISIBLE,
  CONSTRAINT `fk_buy_cl`
    FOREIGN KEY (`id_client`)
    REFERENCES `optica_cul_d_ampolla`.`clients` (`id_client`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buy_gl`
    FOREIGN KEY (`id_glasses`)
    REFERENCES `optica_cul_d_ampolla`.`glasses` (`id_glasses`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buy_em`
    FOREIGN KEY (`id_employee`)
    REFERENCES `optica_cul_d_ampolla`.`employees` (`id_employees`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
