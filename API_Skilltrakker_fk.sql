-- Sat 18 Jul 2020 07:49:01 PM -05
-- Model: API Skilltrakker    Version: 1.1

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS Skilltrakker_API ;

-- -----------------------------------------------------
-- Schema Skilltrakker_API
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS Skilltrakker_API DEFAULT CHARACTER SET utf8 ;
USE Skilltrakker_API ;

-- -----------------------------------------------------
-- Table users
-- -----------------------------------------------------
DROP TABLE IF EXISTS users ;

CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'user\' code',
  username VARCHAR(45) NOT NULL COMMENT 'user\' username for login into the system',
  email VARCHAR(45) NOT NULL COMMENT 'user\' email address',
  password VARCHAR(45) NOT NULL COMMENT 'user\' password for loging into the system',
  stripe_Id VARCHAR(45) NULL DEFAULT NULL COMMENT 'user\' code for stripe plataform',
  stripe_email VARCHAR(45) NULL DEFAULT NULL COMMENT 'user\' email in stripe plataform',
  stripe_key VARCHAR(45) NULL DEFAULT NULL COMMENT 'user\' stripe key',
  gyms_id INT NOT NULL COMMENT 'gym\' id which the user belongs',
  PRIMARY KEY (id),
  UNIQUE INDEX email_UNIQUE (email ASC),
  UNIQUE INDEX username_UNIQUE (username ASC),
  INDEX fk_users_gyms_idx (gyms_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores USERS information';


-- -----------------------------------------------------
-- Table gyms
-- -----------------------------------------------------
DROP TABLE IF EXISTS gyms ;

CREATE TABLE IF NOT EXISTS gyms (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'GYM code',
  name VARCHAR(45) NOT NULL COMMENT 'GYM Name',
  description VARCHAR(45) NULL DEFAULT NULL COMMENT 'GYM Description',
  phone VARCHAR(45) NOT NULL COMMENT 'GYM Phone',
  web VARCHAR(45) NOT NULL COMMENT 'GYM web domain',
  address JSON NULL DEFAULT NULL COMMENT 'GYM Address in JSON format',
  owner_id INT NOT NULL COMMENT 'USERS\' id of the Gym Owner',
  PRIMARY KEY (id),
  INDEX fk_gyms_users_idx (owner_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores gyms information';

-- -----------------------------------------------------
-- Table gymnasts
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnasts ;

CREATE TABLE IF NOT EXISTS gymnasts (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Gymnast\' code',
  name VARCHAR(45) NOT NULL COMMENT 'Gymnast\' name',
  birth_date DATE NOT NULL COMMENT 'Gymnast\' birth date',
  life_time_score INT NOT NULL DEFAULT 0 COMMENT 'Score gather by an gymnast since is member of a gym.',
  current_streak_points INT NOT NULL DEFAULT 0 COMMENT 'Amount of points adquired by a Gymnas for loging everyday, is reset after 1 day of not loging.',
  last_streak DATE NULL DEFAULT NULL COMMENT 'Last amount of points before the gymnast lost his streak',
  about MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Decription of the gymnast',
  created DATE NOT NULL,
  updated DATE NOT NULL,
  users_id INT NOT NULL COMMENT 'user\' id which the gymnast belongs',
  PRIMARY KEY (id),
  INDEX fk_gymnasts_users_idx (users_id ASC))  
ENGINE = InnoDB
COMMENT = 'Table that stores GYMNASTS information';

-- -----------------------------------------------------
-- Table classes
-- -----------------------------------------------------
DROP TABLE IF EXISTS classes ;

CREATE TABLE IF NOT EXISTS classes (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Class\' id',
  name VARCHAR(45) NOT NULL COMMENT 'Class\' name',
  description MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Class\' description',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores CLASSES\' information';


-- -----------------------------------------------------
-- Table challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS challenges ;

CREATE TABLE IF NOT EXISTS challenges (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'challenge\' id',
  name VARCHAR(45) NOT NULL COMMENT 'challenge\' name',
  description MEDIUMTEXT NOT NULL COMMENT 'challenge\' description',
  points INT NULL DEFAULT NULL COMMENT 'challenge\' points',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores CHALLENGES\' information';


-- -----------------------------------------------------
-- Table normal_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS normal_challenges ;

CREATE TABLE IF NOT EXISTS normal_challenges (
  classes_id INT NOT NULL COMMENT 'Class\' code',
  challenges_id INT NOT NULL COMMENT 'Challenge\' code',
  is_active TINYINT(1) NOT NULL COMMENT 'Status of the Challenge\n0 Inactive\n1 Active',
  PRIMARY KEY (classes_id, challenges_id),
  INDEX fk_class_has_challenges_idx (challenges_id ASC),
  INDEX fk_challenge_is_in_class_idx (classes_id ASC))  
ENGINE = InnoDB
COMMENT = 'Table that stores the CHALLENGES that a CLASS had.';

-- -----------------------------------------------------
-- Table levels
-- -----------------------------------------------------
DROP TABLE IF EXISTS levels ;

CREATE TABLE IF NOT EXISTS levels (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Level',
  level VARCHAR(45) NOT NULL COMMENT 'Name for the Level',
  description MEDIUMTEXT NULL DEFAULT NULL COMMENT 'Description of what that level means',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS description for the diferents skills.';


-- -----------------------------------------------------
-- Table events
-- -----------------------------------------------------
DROP TABLE IF EXISTS events ;

CREATE TABLE IF NOT EXISTS events (
  id INT NOT NULL COMMENT 'Code of the Event',
  name VARCHAR(45) NULL COMMENT 'Name of the Event',
  abbrev VARCHAR(45) NULL COMMENT 'Abbreviation of the Event	',
  PRIMARY KEY (id))
ENGINE = InnoDB
COMMENT = 'Table that stores the EVENTS in wich a skill is executed, if they are active and the respective abreviation.';


-- -----------------------------------------------------
-- Table skills
-- -----------------------------------------------------
DROP TABLE IF EXISTS skills ;

CREATE TABLE IF NOT EXISTS skills (
  id INT NOT NULL AUTO_INCREMENT COMMENT 'Code of the Skill',
  name VARCHAR(45) NOT NULL COMMENT 'Name of the skill',
  description MEDIUMTEXT NULL COMMENT 'Description of the Skill',
  category VARCHAR(45) NOT NULL COMMENT 'category to which the event belongs',
  certificate TINYINT(1) DEFAULT 0  COMMENT 'Boolean value to know the status',
  events_id INT NOT NULL COMMENT 'Code of the Event',
  PRIMARY KEY (id),
  INDEX fk_skills_events_idx (events_id ASC))  
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST can get.';


-- -----------------------------------------------------
-- Table gymnast_has_skills
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnast_has_skills ;

CREATE TABLE IF NOT EXISTS gymnast_has_skills (
  gymnast_id INT NOT NULL COMMENT 'Gymnast\' code',
  skills_Id INT NOT NULL COMMENT 'Skill\' code',
  progress_status VARCHAR(45) NULL COMMENT 'Tells the gymnast actual status in learning the skill',
  coach_verify JSON NULL COMMENT 'Verification from a coach when an gymnast set the level for a skill',
  timestamp DATE NOT NULL COMMENT 'Date when a gymnast gets the skill',
  interactions JSON NULL COMMENT 'Interactions for the skill update by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnast_id, skills_Id),
  INDEX fk_gymnast_has_skills_idx (skills_Id ASC),
  INDEX fk_skills_is_mastered_by_gymnast_idx (gymnast_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores SKILLS that a GYMNAST get.';

-- -----------------------------------------------------
-- Table skill_has_levels
-- -----------------------------------------------------
DROP TABLE IF EXISTS skill_has_levels ;

CREATE TABLE IF NOT EXISTS skill_has_levels (
  levels_id INT NOT NULL COMMENT 'Code of the Level',
  skills_id INT NOT NULL COMMENT 'Code of the Skill',
  secuence TINYINT(1) DEFAULT 0  COMMENT 'The Skill has a secuence?\n0 No\n1 Yes',
  PRIMARY KEY (levels_id, skills_id),
  INDEX fk_level_is_part_of_skill_idx (skills_id ASC),
  INDEX fk_skill_has_level_idx (levels_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores LEVELS that a certain skill had.\nLogic Name: Skill Levels';

-- -----------------------------------------------------
-- Table timeline
-- -----------------------------------------------------
DROP TABLE IF EXISTS timeline ;

CREATE TABLE IF NOT EXISTS timeline (
  id INT NOT NULL COMMENT 'Code for a gym\' timeline',
  data JSON NULL COMMENT 'Content of the timeline in format JSON\n',
  gyms_Id INT NOT NULL COMMENT 'Id of the gym',
  PRIMARY KEY (id),
  INDEX fk_timeline_gyms_idx (gyms_Id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the Timeline for events in format JSON';


-- -----------------------------------------------------
-- Table gymnasts_classes
-- -----------------------------------------------------
DROP TABLE IF EXISTS gymnasts_classes ;

CREATE TABLE IF NOT EXISTS gymnasts_classes (
  gymnasts_id INT NOT NULL COMMENT 'Foreing key from GYMNASTS table',
  classes_id INT NOT NULL COMMENT 'Foreing key from CLASSES table',
  PRIMARY KEY (gymnasts_id, classes_id),
  INDEX fk_gymnast_has_classes_idx (classes_id ASC),
  INDEX fk_class_has_gymnasts_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CLASSES in what a GYMNAST is enrolled.';

-- -----------------------------------------------------
-- Table daily_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS daily_challenges ;

CREATE TABLE IF NOT EXISTS daily_challenges (
  classes_id INT NOT NULL COMMENT 'Class\' code',
  challenges_id INT NOT NULL COMMENT 'Challenge\' code',
  date_challenge DATE NOT NULL COMMENT 'Date in wich the challenge has to be completed.',
  PRIMARY KEY (classes_id, challenges_id, date_challenge),
  INDEX fk_class_has_daily_challenges_idx (challenges_id ASC),
  INDEX fk_challenge_has_classes_idx (classes_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the daily challenges that a class had.';

-- -----------------------------------------------------
-- Table completed_daily_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS completed_daily_challenges ;

CREATE TABLE IF NOT EXISTS completed_daily_challenges (
  gymnasts_id INT NOT NULL COMMENT 'gymnast\' code',
  daily_challenges_classes_id INT NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  daily_challenges_challenges_id INT NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  daily_challenges_date DATE NOT NULL COMMENT 'Foreing key from DAILY CHALLENGES table',
  date_of_completation DATE NOT NULL COMMENT 'Date in wich the challenge was completed',
  Interactions JSON NULL COMMENT '\nInteractions for the completed challenged by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnasts_id, daily_challenges_classes_id, daily_challenges_challenges_id, daily_challenges_date),
  INDEX fk_gymnast_has_daily_challenges_idx (daily_challenges_classes_id ASC, daily_challenges_challenges_id ASC, daily_challenges_date ASC),
  INDEX fk_completed_challenges_has_gymnasts_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the DAILY CHALLENGES that a GYMNAST has completed.';

-- -----------------------------------------------------
-- Table completed_normal_challenges
-- -----------------------------------------------------
DROP TABLE IF EXISTS completed_normal_challenges ;

CREATE TABLE IF NOT EXISTS completed_normal_challenges (
  gymnasts_id INT NOT NULL COMMENT 'gymnast\' code',
  normal_challenges_classes_id INT NOT NULL COMMENT 'Foreing key from NORMAL CHALLENGES table',
  normal_challenges_challenges_id INT NOT NULL COMMENT 'Foreing key from NORMAL CHALLENGES table',
  date_of_completation DATE NOT NULL COMMENT 'Date in wich the challenge was completed',
  Interactions JSON NULL COMMENT '\nInteractions for the completed challenged by others gymnasts\nHi 5\nComments\nApplasuse\nIn JSON Format',
  PRIMARY KEY (gymnasts_id, normal_challenges_classes_id, normal_challenges_challenges_id),
  INDEX fk_gymnast_has_normal_challenges_idx (normal_challenges_classes_id ASC, normal_challenges_challenges_id ASC),
  INDEX fk_completed_challenges_has_gymnasts_idx (gymnasts_id ASC))
ENGINE = InnoDB
COMMENT = 'Table that stores the CHALLENGES that a GYMNAST has completed.';

-- -----------------------------------------------------
-- ALTER TABLES FOR FK
-- -----------------------------------------------------

ALTER TABLE users
ADD CONSTRAINT fk_users_gyms
    FOREIGN KEY (gyms_id)
    REFERENCES gyms (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gyms 
ADD CONSTRAINT fk_gyms_users
    FOREIGN KEY (owner_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnasts 
ADD CONSTRAINT fk_gymnasts_users_idx
    FOREIGN KEY (users_id)
    REFERENCES users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE normal_challenges 
ADD CONSTRAINT fk_class_has_challenges
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_challenge_is_in_class_
    FOREIGN KEY (challenges_id)
    REFERENCES challenges (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE skills 
ADD CONSTRAINT fk_skills_events
    FOREIGN KEY (events_id)
    REFERENCES events (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnast_has_skills
ADD CONSTRAINT fk_gymnast_has_skills
    FOREIGN KEY (gymnast_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_skills_is_mastered_by_gymnast
    FOREIGN KEY (skills_Id)
    REFERENCES skills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE skill_has_levels
ADD CONSTRAINT fk_level_is_part_of_skill
    FOREIGN KEY (levels_id)
    REFERENCES levels (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_SKI_has_LVE
    FOREIGN KEY (skills_id)
    REFERENCES skills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE timeline
ADD CONSTRAINT fk_timeline_gyms
    FOREIGN KEY (gyms_Id)
    REFERENCES gyms (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE gymnasts_classes
ADD CONSTRAINT fk_gymnast_has_classes
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_class_has_gymnasts
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE daily_challenges
ADD CONSTRAINT fk_class_has_daily_challenges
    FOREIGN KEY (classes_id)
    REFERENCES classes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_challenge_has_classes_idx
    FOREIGN KEY (challenges_id)
    REFERENCES challenges (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE completed_daily_challenges
ADD CONSTRAINT fk_daily_challenge_is_completed_by_gymnast
    FOREIGN KEY (daily_challenges_classes_id , daily_challenges_challenges_id , daily_challenges_date)
    REFERENCES daily_challenges (classes_id , challenges_id , date_challenge)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_gymnast_has_daily_challenges
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE completed_normal_challenges
ADD CONSTRAINT fk_normal_challenge_is_completed_by_gymnast
    FOREIGN KEY (normal_challenges_classes_id , normal_challenges_challenges_id)
    REFERENCES normal_challenges (classes_id , challenges_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
ADD CONSTRAINT fk_gymnast_has_normal_challenges
    FOREIGN KEY (gymnasts_id)
    REFERENCES gymnasts (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
