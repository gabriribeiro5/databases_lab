-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema profile_page_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema profile_page_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `profile_page_db` DEFAULT CHARACTER SET utf8 ;
USE `profile_page_db` ;

-- -----------------------------------------------------
-- Table `profile_page_db`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`customer` (
  `customer_id` INT NOT NULL,
  `name` VARCHAR(100) NULL,
  `surname` VARCHAR(100) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `profile_page_db`.`profile_page`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`profile_page` (
  `profile_page_id` INT NOT NULL,
  `customer_id` INT NULL,
  `background_moves` VARCHAR(45) NULL,
  `profile_image_moves` VARCHAR(45) NULL,
  `footer_moves` VARCHAR(45) NULL,
  `background_img_id` VARCHAR(45) NULL,
  PRIMARY KEY (`profile_page_id`),
  CONSTRAINT `fk_profile_page_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `profile_page_db`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '	';


-- -----------------------------------------------------
-- Table `profile_page_db`.`customer_link`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`customer_link` (
  `customer_link_id` INT NOT NULL,
  `customer_id` INT NULL,
  `link_name` VARCHAR(45) NULL,
  `url` VARCHAR(200) NULL,
  PRIMARY KEY (`customer_link_id`),
  INDEX `fk_customer_link_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_customer_link_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `profile_page_db`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profile_page_db`.`known_domain`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`known_domain` (
  `known_domain_id` INT NOT NULL,
  `base_url` VARCHAR(45) NULL,
  `name` VARCHAR(45) NULL,
  `icon_id` VARCHAR(45) NULL,
  PRIMARY KEY (`known_domain_id`))
ENGINE = InnoDB
COMMENT = '			';


-- -----------------------------------------------------
-- Table `profile_page_db`.`session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`session` (
  `session_id` INT NOT NULL,
  `profile_page_id` INT NULL,
  `date` DATE NULL,
  `time` DATETIME NULL,
  `viwer_identifyer` VARCHAR(200) NULL COMMENT 'assigned device_id',
  `origin_path` VARCHAR(100) NULL COMMENT 'QR Code, URL, Search Engine, Profile Page Network',
  PRIMARY KEY (`session_id`),
  CONSTRAINT `fk_session_profile_page`
    FOREIGN KEY (`profile_page_id`)
    REFERENCES `profile_page_db`.`profile_page` (`profile_page_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '		';


-- -----------------------------------------------------
-- Table `profile_page_db`.`link_ranking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profile_page_db`.`link_ranking` (
  `link_ranking_id` INT NOT NULL,
  `session_id` INT NULL,
  `link_name` VARCHAR(100) NULL,
  `ranked_as` INT NULL,
  PRIMARY KEY (`link_ranking_id`),
  INDEX `fk_link_ranking_session_idx` (`session_id` ASC) VISIBLE,
  CONSTRAINT `fk_link_ranking_session`
    FOREIGN KEY (`session_id`)
    REFERENCES `profile_page_db`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '	';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
