-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `youtube` DEFAULT CHARACTER SET utf8 ;
USE `youtube` ;

-- -----------------------------------------------------
-- Table `youtube`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`users` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `dob` DATE NOT NULL,
  `gender` ENUM('F', 'M', 'O') NOT NULL,
  `country` VARCHAR(3) NOT NULL,
  `postal_code` INT(5) NOT NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos` (
  `id_video` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `size` INT NOT NULL,
  `file_name` VARCHAR(45) NOT NULL,
  `length` DOUBLE NOT NULL,
  `thumbnail` VARCHAR(255) NULL DEFAULT NULL,
  `views` INT NOT NULL,
  `likes` INT NOT NULL,
  `dislikes` INT NOT NULL,
  `state` ENUM('public', 'ocult', 'private') NOT NULL DEFAULT 'private',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`id_video`),
  INDEX `fk_videos_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_videos_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`tags` (
  `id_tag` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tag`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`channels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`channels` (
  `id_channel` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`id_channel`),
  INDEX `fk_channels_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_channels_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlists` (
  `id_playlist` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` ENUM('public', 'private') NOT NULL DEFAULT 'public',
  PRIMARY KEY (`id_playlist`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comments` (
  `id_comment` INT NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(255) NOT NULL,
  `date_create` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `videos_id_video` INT NOT NULL,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`id_comment`),
  INDEX `fk_comments_videos1_idx` (`videos_id_video` ASC) VISIBLE,
  INDEX `fk_comments_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_comments_videos1`
    FOREIGN KEY (`videos_id_video`)
    REFERENCES `youtube`.`videos` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`videos_has_tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`videos_has_tags` (
  `videos_id_video` INT NOT NULL,
  `tags_id_tag` INT NOT NULL,
  PRIMARY KEY (`videos_id_video`, `tags_id_tag`),
  INDEX `fk_videos_has_tags_tags1_idx` (`tags_id_tag` ASC) VISIBLE,
  INDEX `fk_videos_has_tags_videos1_idx` (`videos_id_video` ASC) VISIBLE,
  CONSTRAINT `fk_videos_has_tags_videos1`
    FOREIGN KEY (`videos_id_video`)
    REFERENCES `youtube`.`videos` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_videos_has_tags_tags1`
    FOREIGN KEY (`tags_id_tag`)
    REFERENCES `youtube`.`tags` (`id_tag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`users_subscribe_channels`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`users_subscribe_channels` (
  `channels_id_channel` INT NOT NULL,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`channels_id_channel`, `users_id_user`),
  INDEX `fk_channels_has_users_users1_idx` (`users_id_user` ASC) VISIBLE,
  INDEX `fk_channels_has_users_channels1_idx` (`channels_id_channel` ASC) VISIBLE,
  CONSTRAINT `fk_channels_has_users_channels1`
    FOREIGN KEY (`channels_id_channel`)
    REFERENCES `youtube`.`channels` (`id_channel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_channels_has_users_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`likes_dislikes_video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`likes_dislikes_video` (
  `users_id_user` INT NOT NULL,
  `videos_id_video` INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('like', 'dislike') NOT NULL DEFAULT 'like',
  PRIMARY KEY (`videos_id_video`, `users_id_user`),
  INDEX `fk_likes_dislikes_video_videos1_idx` (`videos_id_video` ASC) VISIBLE,
  INDEX `fk_likes_dislikes_video_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_likes_dislikes_video_videos1`
    FOREIGN KEY (`videos_id_video`)
    REFERENCES `youtube`.`videos` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_likes_dislikes_video_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`users_creates_playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`users_creates_playlists` (
  `users_id_user` INT NOT NULL,
  `playlists_id_playlist` INT NOT NULL,
  PRIMARY KEY (`users_id_user`, `playlists_id_playlist`),
  INDEX `fk_users_has_playlists_playlists1_idx` (`playlists_id_playlist` ASC) VISIBLE,
  INDEX `fk_users_has_playlists_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_playlists_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_playlists_playlists1`
    FOREIGN KEY (`playlists_id_playlist`)
    REFERENCES `youtube`.`playlists` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlists_has_videos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlists_has_videos` (
  `playlists_id_playlist` INT NOT NULL,
  `videos_id_video` INT NOT NULL,
  PRIMARY KEY (`playlists_id_playlist`, `videos_id_video`),
  INDEX `fk_playlists_has_videos_videos1_idx` (`videos_id_video` ASC) VISIBLE,
  INDEX `fk_playlists_has_videos_playlists1_idx` (`playlists_id_playlist` ASC) VISIBLE,
  CONSTRAINT `fk_playlists_has_videos_playlists1`
    FOREIGN KEY (`playlists_id_playlist`)
    REFERENCES `youtube`.`playlists` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlists_has_videos_videos1`
    FOREIGN KEY (`videos_id_video`)
    REFERENCES `youtube`.`videos` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`users_like_comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`users_like_comments` (
  `users_id_user` INT NOT NULL,
  `comments_id_comment` INT NOT NULL,
  `type` ENUM('like', 'dislike') NOT NULL DEFAULT 'like',
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`users_id_user`, `comments_id_comment`),
  INDEX `fk_users_has_comments_comments1_idx` (`comments_id_comment` ASC) VISIBLE,
  INDEX `fk_users_has_comments_users1_idx` (`users_id_user` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_comments_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `youtube`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_comments_comments1`
    FOREIGN KEY (`comments_id_comment`)
    REFERENCES `youtube`.`comments` (`id_comment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
