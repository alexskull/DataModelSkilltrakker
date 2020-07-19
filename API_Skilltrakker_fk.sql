-- Model: API Skilltrakker    Version: 1.0

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Skilltrakker_API` ;

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Skilltrakker_API` DEFAULT CHARACTER SET utf8 ;
USE `Skilltrakker_API` ;

-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`USERS (USE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`USERS (USE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`USERS (USE)` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'USER code',
  `username` VARCHAR(45) NOT NULL COMMENT 'USER username for login into the system',
  `email` VARCHAR(45) NOT NULL COMMENT 'USER email address',
  `password` VARCHAR(45) NOT NULL COMMENT 'USER password for loging into the system',
  `Stripe_Id` VARCHAR(45) NULL DEFAULT NULL COMMENT 'USER Code for Stripe plataform',
  `Stripe_Email` VARCHAR(45) NULL DEFAULT NULL COMMENT 'USER Email in Stripe Plataform',
  `Stripe_Key` VARCHAR(45) NULL DEFAULT NULL COMMENT 'USER Stripe Key',
  `Status` TINYINT(1) NOT NULL COMMENT 'USER Status 0 Inactive 1 Active',
  `GYM_Id` INT NOT NULL COMMENT 'Gym in which the USER is enrolled',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  INDEX `fk_USE_GYM_idx` (`GYM_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores USERS information';

-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`GYMS (GYM)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`GYMS (GYM)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`GYMS (GYM)` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT 'GYM code',
  `Name` VARCHAR(45) NOT NULL COMMENT 'GYM Name',
  `Description` VARCHAR(45) NULL DEFAULT NULL COMMENT 'GYM Description',
  `USE_id` INT NULL COMMENT 'GYM Owner code',
  `Phone` VARCHAR(45) NOT NULL COMMENT 'GYM Phone',
  `Web` VARCHAR(45) NOT NULL COMMENT 'GYM web domain',
  `Address` JSON NULL DEFAULT NULL COMMENT 'GYM Address in JSON format',
  PRIMARY KEY (`Id`),
  INDEX `fk_GYM_USE_idx` (`USE_id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores GYMS information';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`GYMNASTS (GYA)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`GYMNASTS (GYA)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`GYMNASTS (GYA)` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT 'Gymnast code',
  `Name` VARCHAR(45) NOT NULL COMMENT 'Gymnast name',
  `Birth_Date` DATE NOT NULL COMMENT 'Gymnast Birth Date',
  `Life_Time_Score` INT NOT NULL DEFAULT 0 COMMENT 'Score gather by an gymnast since is member of a gym.',
  `Current_Streak_Points` INT NOT NULL DEFAULT 0 COMMENT 'Amount of points adquired by a Gymnas for loging everyday, is reset after 1 day of not loging.',
  `Last_Streak` DATE NULL DEFAULT NULL COMMENT 'Last amount of points before the gymnast lost his streak',
  `About` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Decription of the Gymnast\n',
  `Status` TINYINT(1) NOT NULL COMMENT 'Gymnast status 0 Inactive 1 Active',
  `Created` DATE NOT NULL,
  `Updated` DATE NOT NULL,
  `USE_id` INT NOT NULL COMMENT 'User Account id in which this Gymnast is registered.',
  PRIMARY KEY (`Id`),
  INDEX `fk_GYA_USE_idx` (`USE_id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores GYMNASTS information';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`CLASSES (CLE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`CLASSES (CLE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`CLASSES (CLE)` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT 'Id of the Class\n',
  `Name` VARCHAR(45) NOT NULL COMMENT 'Name of the Class',
  `Description` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Description of the Class',
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
COMMENT = 'Table that stores CLASSES information';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`GYMNASTS_CLASSES (GCE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`GYMNASTS_CLASSES (GCE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`GYMNASTS_CLASSES (GCE)` (
  `GYA_Id` INT NOT NULL COMMENT 'Foreing key from Gymnasts table',
  `CLE_Id` INT NOT NULL COMMENT 'Foreing key from Classes table',
  PRIMARY KEY (`GYA_Id`, `CLE_Id`),
  INDEX `fk_GYA_is_part_of_a_CLE_idx` (`CLE_Id` ASC),
  INDEX `fk_CLE_has_GYA_idx` (`GYA_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CLASSES in what a GYMNAST is enrolled.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`CHALLENGES (CHE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`CHALLENGES (CHE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`CHALLENGES (CHE)` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Description` MEDIUMTEXT NOT NULL,
  `Points` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
COMMENT = 'Table that stores CHALLENGES information';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)` (
  `CLE_Id` INT NOT NULL COMMENT 'Code of the Class',
  `CHE_Id` INT NOT NULL COMMENT 'Code of the Challenge',
  `Is_Daily?` TINYINT(1) NOT NULL COMMENT 'Tells if a Challenge is Daily or not 0 No 1 Yes',
  `Is_Active?` TINYINT(1) NOT NULL COMMENT 'Status of the Challenge 0 Inactive 1 Active',
  `Daily_date` DATE NULL DEFAULT NULL COMMENT 'If the Challenge is Daily, This field is the day in wich\nhad to be completed.',
  PRIMARY KEY (`CLE_Id`, `CHE_Id`, `Is_Daily?`),
  INDEX `fk_CLE_has_CHE_idx` (`CHE_Id` ASC),
  INDEX `fk_CHE_is_in_CLE_idx` (`CLE_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CHALLENGES that a CLASS had.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`LEVELS (LVE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`LEVELS (LVE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`LEVELS (LVE)` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Level',
  `Level` VARCHAR(45) NOT NULL COMMENT 'Name for the Level',
  `Description` MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Description of what that level means',
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS description for the diferents skills.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`EVENTS (EVE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`EVENTS (EVE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`EVENTS (EVE)` (
  `Id` INT NOT NULL COMMENT 'Code of the Event',
  `Name` VARCHAR(45) NULL COMMENT 'Name of the Event',
  `Abbrev` VARCHAR(45) NULL COMMENT 'Abbreviation of the Event	',
  `Active` TINYINT(1) DEFAULT 0 COMMENT 'Status of the event 0 Inactive 1 Active',
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
COMMENT = 'Table that stores the EVENTS in wich a skill is executed, if they are active and the respective abreviation.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`SKILLS (SKI)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`SKILLS (SKI)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`SKILLS (SKI)` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Skill',
  `Name` VARCHAR(45) NOT NULL COMMENT 'Name of the skill',
  `Description` MEDIUMTEXT NULL COMMENT 'Description of the Skill',
  `Category` VARCHAR(45) NOT NULL COMMENT 'category to which the event belongs',
  `Certificate` TINYINT(1) DEFAULT 0 COMMENT 'Boolean value to know the status',
  `EVE_id` INT NOT NULL COMMENT 'Code of the Event',
  PRIMARY KEY (`Id`),
  INDEX `fk_SKI_EVE_idx` (`EVE_id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST can get.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`GYMNAST_SKILLS (GSI)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`GYMNAST_SKILLS (GSI)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`GYMNAST_SKILLS (GSI)` (
  `GYA_Id` INT NOT NULL COMMENT 'Gymnast code',
  `SKI_Id` INT NOT NULL COMMENT 'Skill code',
  `Progress_status` VARCHAR(45) NULL COMMENT 'Tells the Gymnast actual status in learning the skill',
  `Coach_Verify` JSON NULL COMMENT 'Verification from a coach when an gymnast set the level for a skill',
  `Timestamp` DATE NOT NULL,
  `Interactions` JSON NULL COMMENT 'Interactions for the skill update by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (`GYA_Id`, `SKI_Id`),
  INDEX `fk_GYA_has_SKI_idx` (`SKI_Id` ASC),
  INDEX `fk_SKI_is_mastered_by_GYA_idx` (`GYA_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST get.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`SKILL_LEVEL (SLE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`SKILL_LEVEL (SLE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`SKILL_LEVEL (SLE)` (
  `LVE_Id` INT NOT NULL COMMENT 'Code of the Level',
  `SKI_Id` INT NOT NULL COMMENT 'Code of the Skill',
  `Secuence` TINYINT(1) DEFAULT 0 COMMENT 'The Skill has a secuence?\n0 No\n1 Yes',
  PRIMARY KEY (`LVE_Id`, `SKI_Id`),
  INDEX `fk_LVE_is_part_SKI_idx` (`SKI_Id` ASC),
  INDEX `fk_SKI_has_LVE_idx` (`LVE_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS that a certain skill had.\nLogic Name: Skill Levels';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`GYMNAST_CLASSES_CHALLENGES (GCCE)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`GYMNAST_CLASSES_CHALLENGES (GCCE)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`GYMNAST_CLASSES_CHALLENGES (GCCE)` (
  `GYA_Id` INT NOT NULL COMMENT 'FK of Gymnast',
  `CCE_CLE_Id` INT NOT NULL COMMENT 'Part of the composite foreign key\nCode of the Class',
  `CCE_CHE_Id` INT NOT NULL COMMENT 'Part of the composite foreign key\nCode of the Challenge',
  `CCE_Is_Daily?` TINYINT(1) NOT NULL COMMENT 'Part of the composite foreign key\nBoolean value to kown if is a Daily challenge.',
  `Completion` TINYINT(1) DEFAULT 0 COMMENT 'Status of the Challenge\n0 inactive\n1 Active',
  `Date_of_Completion` DATE NULL COMMENT 'Date in wich the challenge was completed',
  `Interactions` JSON NULL COMMENT 'Interactions for the completed challenged by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (`GYA_Id`, `CCE_CLE_Id`, `CCE_CHE_Id`, `CCE_Is_Daily?`),
  INDEX `fk_GYA_has_CCE_idx` (`CCE_CLE_Id` ASC, `CCE_CHE_Id` ASC, `CCE_Is_Daily?` ASC),
  INDEX `fk_CCE_are_done_by_GYA_idx` (`GYA_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CHALLENGES that a GYMNAST has completed.';


-- -----------------------------------------------------
-- Table `Skilltrakker_API`.`TIMELINE (TME)`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Skilltrakker_API`.`TIMELINE (TME)` ;

CREATE TABLE IF NOT EXISTS `Skilltrakker_API`.`TIMELINE (TME)` (
  `Id` INT NOT NULL,
  `DATA` JSON NULL COMMENT 'Content of the Timeline in format JSON\n',
  `GYM_Id` INT NOT NULL COMMENT 'Code of the Gym owner of this Timeline',
  PRIMARY KEY (`Id`),
  INDEX `fk_TME_GYMS_idx` (`GYM_Id` ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the Timeline for events in format JSON';

-- --------------------------------------------------
-- Adding FK
-- --------------------------------------------------

ALTER TABLE `Skilltrakker_API`.`USERS (USE)` ADD CONSTRAINT `fk_USE_GYM`
    FOREIGN KEY (`GYM_Id`)
    REFERENCES `Skilltrakker_API`.`GYMS (GYM)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`GYMS (GYM)` ADD  CONSTRAINT `fk_GYM_USE`
    FOREIGN KEY (`USE_id`)
    REFERENCES `Skilltrakker_API`.`USERS (USE)` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE `Skilltrakker_API`.`GYMNASTS (GYA)` ADD CONSTRAINT `fk_GYA_USE`
    FOREIGN KEY (`USE_id`)
    REFERENCES `Skilltrakker_API`.`USERS (USE)` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE `Skilltrakker_API`.`GYMNASTS_CLASSES (GCE)` ADD CONSTRAINT `fk_GYA_is_part_of_a_CLE`
    FOREIGN KEY (`GYA_Id`)
    REFERENCES `Skilltrakker_API`.`GYMNASTS (GYA)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE `Skilltrakker_API`.`GYMNASTS_CLASSES (GCE)` ADD CONSTRAINT `fk_CLE_has_GYA`
    FOREIGN KEY (`CLE_Id`)
    REFERENCES `Skilltrakker_API`.`CLASSES (CLE)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)` ADD CONSTRAINT `fk_CLE_has_CHE`
    FOREIGN KEY (`CLE_Id`)
    REFERENCES `Skilltrakker_API`.`CLASSES (CLE)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)` ADD CONSTRAINT `fk_CHE_is_in_CLE`
    FOREIGN KEY (`CHE_Id`)
    REFERENCES `Skilltrakker_API`.`CHALLENGES (CHE)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`SKILLS (SKI)` ADD CONSTRAINT `fk_SKI_EVE`
    FOREIGN KEY (`EVE_id`)
    REFERENCES `Skilltrakker_API`.`EVENTS (EVE)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`GYMNAST_SKILLS (GSI)` ADD CONSTRAINT `fk_GYA_has_SKI`
    FOREIGN KEY (`GYA_Id`)
    REFERENCES `Skilltrakker_API`.`GYMNASTS (GYA)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE `Skilltrakker_API`.`GYMNAST_SKILLS (GSI)` ADD CONSTRAINT `fk_SKI_is_mastered_by_GYA`
    FOREIGN KEY (`SKI_Id`)
    REFERENCES `Skilltrakker_API`.`SKILLS (SKI)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`SKILL_LEVEL (SLE)` ADD CONSTRAINT `fk_LVE_is_part_SKI`
    FOREIGN KEY (`LVE_Id`)
    REFERENCES `Skilltrakker_API`.`LEVELS (LVE)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE `Skilltrakker_API`.`SKILL_LEVEL (SLE)` ADD CONSTRAINT `fk_SKI_has_LVE`
    FOREIGN KEY (`SKI_Id`)
    REFERENCES `Skilltrakker_API`.`SKILLS (SKI)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`GYMNAST_CLASSES_CHALLENGES (GCCE)` ADD CONSTRAINT `fk_GYA_has_CCE`
    FOREIGN KEY (`GYA_Id`)
    REFERENCES `Skilltrakker_API`.`GYMNASTS (GYA)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE `Skilltrakker_API`.`GYMNAST_CLASSES_CHALLENGES (GCCE)` ADD CONSTRAINT `fk_CCE_are_done_by_GYA`
    FOREIGN KEY (`CCE_CLE_Id` , `CCE_CHE_Id` , `CCE_Is_Daily?`)
    REFERENCES `Skilltrakker_API`.`CLASSES_CHALLENGES (CCE)` (`CLE_Id` , `CHE_Id` , `Is_Daily?`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


ALTER TABLE `Skilltrakker_API`.`TIMELINE (TME)` ADD CONSTRAINT `fk_TME_GYMS`
    FOREIGN KEY (`GYM_Id`)
    REFERENCES `Skilltrakker_API`.`GYMS (GYM)` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
