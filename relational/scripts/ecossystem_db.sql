-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecossystem_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ecossystem_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecossystem_db` DEFAULT CHARACTER SET utf8 ;
USE `ecossystem_db` ;

-- -----------------------------------------------------
-- Table `ecossystem_db`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`customer` (
  `customer_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `surname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) INVISIBLE,
  INDEX `email_idx` (`email` ASC) VISIBLE,
  INDEX `name_idx` (`name` ASC, `surname` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = '		';


-- -----------------------------------------------------
-- Table `ecossystem_db`.`eco_unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`eco_unit` (
  `eco_unit_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `ecossys_category` VARCHAR(45) NULL COMMENT 'Ecossystem_Category: florestas, savanas, desertos ou pradarias',
  `require_update` TINYINT NOT NULL COMMENT 'BOOLEAN. If product config must be updated. 1=YES.',
  `location` GEOMETRY NULL,
  PRIMARY KEY (`eco_unit_id`),
  INDEX `fk_eco_unit_customer_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_eco_unit_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ecossystem_db`.`customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '					';


-- -----------------------------------------------------
-- Table `ecossystem_db`.`communication_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`communication_event` (
  `communication_event_id` INT NOT NULL,
  `eco_unit_id` INT NOT NULL,
  `date_time` DATETIME NULL,
  PRIMARY KEY (`communication_event_id`),
  INDEX `fk_communication_event_eco_unit_idx` (`eco_unit_id` ASC) VISIBLE,
  CONSTRAINT `fk_communication_event_eco_unit`
    FOREIGN KEY (`eco_unit_id`)
    REFERENCES `ecossystem_db`.`eco_unit` (`eco_unit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecossystem_db`.`environment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`environment` (
  `environment_id` INT NOT NULL,
  `communication_event_id` INT NOT NULL,
  `scan_date_time` DATETIME NULL,
  `soil_moisture_min` VARCHAR(45) NULL,
  `soil_moisture_max` VARCHAR(45) NULL,
  `temperature_min` VARCHAR(45) NULL,
  `temperature_max` VARCHAR(45) NULL,
  `rain_occurrences_per_day` INT NULL,
  PRIMARY KEY (`environment_id`),
  INDEX `fk_environment_communication_event_idx` (`communication_event_id` ASC) VISIBLE,
  CONSTRAINT `fk_environment_communication_event`
    FOREIGN KEY (`communication_event_id`)
    REFERENCES `ecossystem_db`.`communication_event` (`communication_event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecossystem_db`.`config_update_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`config_update_history` (
  `config_update_id` INT NOT NULL,
  `config_status_id` INT NOT NULL COMMENT '1 = confirmed; 2 = sent; 3 = wating; 4 = expired',
  `communication_event_id` INT NULL,
  `run_physical_diagnostics` TINYINT NULL,
  `soil_moisture_max` VARCHAR(45) NULL,
  `soil_moisture_min` VARCHAR(45) NULL,
  `watering_initial_lenght` VARCHAR(45) NULL,
  `watering_lenght_growth_rate` VARCHAR(45) NULL,
  `watering_lenght_down_rate` VARCHAR(45) NULL,
  `expected_climate_season` VARCHAR(45) NULL,
  PRIMARY KEY (`config_update_id`),
  INDEX `fk_config_update_his_communication_event_idx` (`communication_event_id` ASC) VISIBLE,
  CONSTRAINT `fk_config_update_his_communication_event`
    FOREIGN KEY (`communication_event_id`)
    REFERENCES `ecossystem_db`.`communication_event` (`communication_event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecossystem_db`.`self_diagnostic_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`self_diagnostic_history` (
  `self_diagnostic_id` INT NOT NULL,
  `communication_event_id` INT NOT NULL,
  `diagnostic_date_time` DATETIME NULL,
  `eco_unit_message` VARCHAR(200) NULL,
  `wifi_connected` SMALLINT NULL,
  `watering_system` SMALLINT NULL,
  `river_system` SMALLINT NULL,
  `wind_system` SMALLINT NULL,
  `lighting_system` SMALLINT NULL,
  PRIMARY KEY (`self_diagnostic_id`),
  INDEX `fk_self_diagnostic_his_communication_event_idx` (`communication_event_id` ASC) VISIBLE,
  CONSTRAINT `fk_self_diagnostic_his_communication_event`
    FOREIGN KEY (`communication_event_id`)
    REFERENCES `ecossystem_db`.`communication_event` (`communication_event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecossystem_db`.`config_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`config_status` (
  `config_status_id` INT NOT NULL,
  `status_name` VARCHAR(45) NOT NULL COMMENT '1 = confirmed; 2 = sent; 3 = wating; 4 = expired',
  `status_description` VARCHAR(100) NULL COMMENT 'confirmed = configuration data declared by eco_unit only;\nsent = configuration update data sent to eco_unit;\nwating = configuration update data wating to be sent;\nexpired = configuration update data that has not been (and will not be) sent to eco_unit',
  PRIMARY KEY (`config_status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecossystem_db`.`sensor_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecossystem_db`.`sensor_status` (
  `sensor_status_id` SMALLINT NOT NULL,
  `sensor_status_name` VARCHAR(45) NOT NULL COMMENT '1 = running; 2 = malfunction; 3 = not installed',
  `sensor_status_description` VARCHAR(45) NULL COMMENT 'running = working fine;\nmalfunction = something is wrong;\nnot installed = diagnostics do not apply',
  PRIMARY KEY (`sensor_status_id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
