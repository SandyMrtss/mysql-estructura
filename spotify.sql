-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`users` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `dob` DATE NOT NULL,
  `gender` ENUM('M', 'F', 'O') NOT NULL,
  `country` VARCHAR(3) NOT NULL,
  `postal_code` INT(5) NOT NULL,
  `type_user` ENUM('free', 'premium') NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`users_premium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`users_premium` (
  `id_user` INT NOT NULL,
  PRIMARY KEY (`id_user`),
  INDEX `fk_users_premium_users_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fk_users_premium_users`
    FOREIGN KEY (`id_user`)
    REFERENCES `spotify`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`subscriptions` (
  `id_subscription` INT NOT NULL AUTO_INCREMENT,
  `date_start` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_renew` DATETIME NOT NULL,
  `payment_type` ENUM('P', 'C') NOT NULL,
  `users_premium_id_user` INT NOT NULL,
  PRIMARY KEY (`id_subscription`),
  INDEX `fk_subscriptions_users_premium1_idx` (`users_premium_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_subscriptions_users_premium1`
    FOREIGN KEY (`users_premium_id_user`)
    REFERENCES `spotify`.`users_premium` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`payments` (
  `id_payment` INT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total` DOUBLE NOT NULL,
  `users_premium_id_user` INT NOT NULL,
  PRIMARY KEY (`id_payment`),
  INDEX `fk_payments_users_premium1_idx` (`users_premium_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_payments_users_premium1`
    FOREIGN KEY (`users_premium_id_user`)
    REFERENCES `spotify`.`users_premium` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`credit_cards_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`credit_cards_details` (
  `payments_id_payment` INT NOT NULL,
  `number_card` INT NOT NULL,
  `date_cad` DATETIME NOT NULL,
  `cvv` INT(3) NOT NULL,
  PRIMARY KEY (`payments_id_payment`),
  INDEX `fk_credit_cards_details_payments1_idx` (`payments_id_payment` ASC) VISIBLE,
  CONSTRAINT `fk_credit_cards_details_payments1`
    FOREIGN KEY (`payments_id_payment`)
    REFERENCES `spotify`.`payments` (`id_payment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`paypal_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal_details` (
  `payments_id_payment` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`payments_id_payment`),
  INDEX `fk_paypal_details_payments1_idx` (`payments_id_payment` ASC) VISIBLE,
  CONSTRAINT `fk_paypal_details_payments1`
    FOREIGN KEY (`payments_id_payment`)
    REFERENCES `spotify`.`payments` (`id_payment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists` (
  `id_playlist` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `num_songs` INT NOT NULL,
  `date_create` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` ENUM('A', 'D') NOT NULL DEFAULT 'A',
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`id_playlist`),
  INDEX `fk_playlists_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_playlists_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `spotify`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_active`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists_active` (
  `id_playlist_active` INT NOT NULL,
  PRIMARY KEY (`id_playlist_active`),
  INDEX `fk_playlists_active_playlists1_idx` (`id_playlist_active` ASC) VISIBLE,
  CONSTRAINT `fk_playlists_active_playlists1`
    FOREIGN KEY (`id_playlist_active`)
    REFERENCES `spotify`.`playlists` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_deleted`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlists_deleted` (
  `id_playlist_deleted` INT NOT NULL,
  `date_delete` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_playlist_deleted`),
  CONSTRAINT `fk_playlists_deleted_playlists1`
    FOREIGN KEY (`id_playlist_deleted`)
    REFERENCES `spotify`.`playlists` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artists` (
  `id_artist` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `image` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id_artist`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`albums`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`albums` (
  `id_album` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `date_publication` YEAR NOT NULL,
  `cover_image` VARCHAR(255) NULL DEFAULT NULL,
  `artists_id_artist` INT NOT NULL,
  PRIMARY KEY (`id_album`),
  INDEX `fk_albums_artists1_idx` (`artists_id_artist` ASC) VISIBLE,
  CONSTRAINT `fk_albums_artists1`
    FOREIGN KEY (`artists_id_artist`)
    REFERENCES `spotify`.`artists` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`songs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`songs` (
  `id_song` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `length` DOUBLE NOT NULL,
  `reproductions` INT NOT NULL,
  `albums_id_album` INT NOT NULL,
  PRIMARY KEY (`id_song`),
  INDEX `fk_songs_albums1_idx` (`albums_id_album` ASC) VISIBLE,
  CONSTRAINT `fk_songs_albums1`
    FOREIGN KEY (`albums_id_album`)
    REFERENCES `spotify`.`albums` (`id_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`users_add_songs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`users_add_songs` (
  `users_id_user` INT NOT NULL,
  `playlists_active_id_playlist_active` INT NOT NULL,
  `songs_id_song` INT NOT NULL,
  `date_added` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`users_id_user`, `playlists_active_id_playlist_active`, `songs_id_song`),
  INDEX `fk_users_has_playlists_active_playlists_active1_idx` (`playlists_active_id_playlist_active` ASC) VISIBLE,
  INDEX `fk_users_has_playlists_active_users1_idx` (`users_id_user` ASC) VISIBLE,
  INDEX `fk_add_sogs_idx` (`songs_id_song` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_playlists_active_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `spotify`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_playlists_active_playlists_active1`
    FOREIGN KEY (`playlists_active_id_playlist_active`)
    REFERENCES `spotify`.`playlists_active` (`id_playlist_active`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_add_sogs`
    FOREIGN KEY (`songs_id_song`)
    REFERENCES `spotify`.`songs` (`id_song`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`users_follow_artists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`users_follow_artists` (
  `users_id_user` INT NOT NULL,
  `artists_id_artist` INT NOT NULL,
  PRIMARY KEY (`users_id_user`, `artists_id_artist`),
  INDEX `fk_users_has_artists_artists1_idx` (`artists_id_artist` ASC) VISIBLE,
  INDEX `fk_users_has_artists_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_artists_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `spotify`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_artists_artists1`
    FOREIGN KEY (`artists_id_artist`)
    REFERENCES `spotify`.`artists` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artists_resemble_artists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artists_resemble_artists` (
  `artists_id_artist` INT NOT NULL,
  `artists_id_artist1` INT NOT NULL,
  PRIMARY KEY (`artists_id_artist`, `artists_id_artist1`),
  INDEX `fk_artists_has_artists_artists2_idx` (`artists_id_artist1` ASC) VISIBLE,
  INDEX `fk_artists_has_artists_artists1_idx` (`artists_id_artist` ASC) VISIBLE,
  CONSTRAINT `fk_artists_has_artists_artists1`
    FOREIGN KEY (`artists_id_artist`)
    REFERENCES `spotify`.`artists` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artists_has_artists_artists2`
    FOREIGN KEY (`artists_id_artist1`)
    REFERENCES `spotify`.`artists` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
