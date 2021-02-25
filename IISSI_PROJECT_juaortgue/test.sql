-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.5.6-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para proyecto_iissi
CREATE DATABASE IF NOT EXISTS `proyecto_iissi` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `proyecto_iissi`;

-- Volcando estructura para vista proyecto_iissi.bussydispatchsview
DROP VIEW IF EXISTS `bussydispatchsview`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `bussydispatchsview` (
	`name` VARCHAR(60) NOT NULL COLLATE 'latin1_swedish_ci',
	`numeroProfesores` BIGINT(21) NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para tabla proyecto_iissi.classrooms
DROP TABLE IF EXISTS `classrooms`;
CREATE TABLE IF NOT EXISTS `classrooms` (
  `classroomId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `floor` int(11) NOT NULL,
  `capacity` int(11) NOT NULL,
  `megaphone` tinyint(1) DEFAULT 0,
  `projector` tinyint(1) DEFAULT 0,
  `typeActivity` varchar(60) NOT NULL,
  PRIMARY KEY (`classroomId`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `incorrectCapacity` CHECK (`capacity` > 0),
  CONSTRAINT `incorrectTypeActivity` CHECK (`typeActivity` = 'Laboratorio' or `typeActivity` = 'Teoría')
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.classrooms: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `classrooms` DISABLE KEYS */;
REPLACE INTO `classrooms` (`classroomId`, `name`, `floor`, `capacity`, `megaphone`, `projector`, `typeActivity`) VALUES
	(1, 'Primera clase', 1, 1, 0, 0, 'Laboratorio'),
	(2, 'Segunda clase', 2, 2, 1, 1, 'Laboratorio'),
	(3, 'Tercera clase', 3, 3, 1, 0, 'Teoría');
/*!40000 ALTER TABLE `classrooms` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.degrees
DROP TABLE IF EXISTS `degrees`;
CREATE TABLE IF NOT EXISTS `degrees` (
  `degreeId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `years` int(11) NOT NULL DEFAULT 4,
  `credits` int(11) DEFAULT 240,
  PRIMARY KEY (`degreeId`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `invalidDegreeYear` CHECK (`years` >= 3 and `years` <= 5)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.degrees: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `degrees` DISABLE KEYS */;
REPLACE INTO `degrees` (`degreeId`, `name`, `years`, `credits`) VALUES
	(1, 'Ingeniería del Software', 4, 240),
	(2, 'Ingeniería del Computadores', 5, 300),
	(3, 'Tecnologías Informáticas', 4, 240);
/*!40000 ALTER TABLE `degrees` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.departments
DROP TABLE IF EXISTS `departments`;
CREATE TABLE IF NOT EXISTS `departments` (
  `departmentId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  PRIMARY KEY (`departmentId`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.departments: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
REPLACE INTO `departments` (`departmentId`, `name`) VALUES
	(2, 'Hardware'),
	(3, 'Informática'),
	(1, 'Matemática');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.dispatchs
DROP TABLE IF EXISTS `dispatchs`;
CREATE TABLE IF NOT EXISTS `dispatchs` (
  `dispatchId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `floor` int(11) NOT NULL,
  `capacity` int(11) NOT NULL,
  PRIMARY KEY (`dispatchId`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `incorrectCapacity` CHECK (`capacity` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.dispatchs: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `dispatchs` DISABLE KEYS */;
REPLACE INTO `dispatchs` (`dispatchId`, `name`, `floor`, `capacity`) VALUES
	(1, 'Primer despacho', 1, 1),
	(2, 'Segundo despacho', 2, 2),
	(3, 'Tercer despacho', 3, 3);
/*!40000 ALTER TABLE `dispatchs` ENABLE KEYS */;

-- Volcando estructura para función proyecto_iissi.fAverageDegree
DROP FUNCTION IF EXISTS `fAverageDegree`;
DELIMITER //
CREATE FUNCTION `fAverageDegree`(dni VARCHAR(9)) RETURNS decimal(10,0)
BEGIN
	DECLARE RESULTADO DECIMAL;
	
	
	SET RESULTADO=	(SELECT AVG(value) AS media
			FROM gradesStudentsView G
			WHERE G.dni=dni
			GROUP BY studentId);
	RETURN RESULTADO;
	

END//
DELIMITER ;

-- Volcando estructura para tabla proyecto_iissi.grades
DROP TABLE IF EXISTS `grades`;
CREATE TABLE IF NOT EXISTS `grades` (
  `gradeId` int(11) NOT NULL AUTO_INCREMENT,
  `studentId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `value` decimal(4,2) NOT NULL,
  `gradeCall` varchar(32) NOT NULL,
  `withHonours` tinyint(1) NOT NULL,
  PRIMARY KEY (`gradeId`),
  KEY `studentId` (`studentId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`studentId`) REFERENCES `students` (`studentId`),
  CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `groups` (`groupId`),
  CONSTRAINT `invalidGradeValue` CHECK (`value` >= 0 and `value` <= 10),
  CONSTRAINT `invalidGradeCall` CHECK (`gradeCall` in ('Primera','Segunda','Tercera','Extraordinaria'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.grades: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
REPLACE INTO `grades` (`gradeId`, `studentId`, `groupId`, `value`, `gradeCall`, `withHonours`) VALUES
	(1, 1, 1, 4.50, 'Primera', 0),
	(2, 1, 1, 3.25, 'Segunda', 0),
	(3, 3, 3, 9.95, 'Primera', 0),
	(4, 2, 2, 10.00, 'Extraordinaria', 1);
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;

-- Volcando estructura para vista proyecto_iissi.gradesstudents
DROP VIEW IF EXISTS `gradesstudents`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `gradesstudents` (
	`studentId` INT(11) NOT NULL,
	`name` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`dni` CHAR(9) NOT NULL COLLATE 'latin1_swedish_ci',
	`gradeId` INT(11) NOT NULL,
	`groupId` INT(11) NOT NULL,
	`value` DECIMAL(4,2) NOT NULL,
	`gradeCall` VARCHAR(32) NOT NULL COLLATE 'latin1_swedish_ci',
	`withHonours` TINYINT(1) NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para vista proyecto_iissi.gradesstudentsview
DROP VIEW IF EXISTS `gradesstudentsview`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `gradesstudentsview` (
	`studentId` INT(11) NOT NULL,
	`name` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`dni` CHAR(9) NOT NULL COLLATE 'latin1_swedish_ci',
	`gradeId` INT(11) NOT NULL,
	`groupId` INT(11) NOT NULL,
	`value` DECIMAL(4,2) NOT NULL,
	`gradeCall` VARCHAR(32) NOT NULL COLLATE 'latin1_swedish_ci',
	`withHonours` TINYINT(1) NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para tabla proyecto_iissi.groups
DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `groupId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `typeActivity` varchar(20) NOT NULL,
  `academicYear` int(11) NOT NULL,
  `subjectId` int(11) NOT NULL,
  `classroomId` int(11) NOT NULL,
  PRIMARY KEY (`groupId`),
  UNIQUE KEY `name` (`name`,`academicYear`,`subjectId`),
  KEY `subjectId` (`subjectId`),
  KEY `classroomId` (`classroomId`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`subjectId`) REFERENCES `subjects` (`subjectId`),
  CONSTRAINT `groups_ibfk_2` FOREIGN KEY (`classroomId`) REFERENCES `classrooms` (`classroomId`),
  CONSTRAINT `negativeGroupYear` CHECK (`academicYear` > 0),
  CONSTRAINT `invalidGroupActivity` CHECK (`typeActivity` in ('Teoria','Laboratorio'))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.groups: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
REPLACE INTO `groups` (`groupId`, `name`, `typeActivity`, `academicYear`, `subjectId`, `classroomId`) VALUES
	(1, 'T1', 'Teoria', 2020, 1, 1),
	(2, 'T2', 'Teoria', 2020, 1, 1),
	(3, 'L1', 'Laboratorio', 2020, 2, 2),
	(4, 'L2', 'Laboratorio', 2020, 2, 2),
	(5, 'L3', 'Laboratorio', 2020, 1, 3);
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.groupsstudents
DROP TABLE IF EXISTS `groupsstudents`;
CREATE TABLE IF NOT EXISTS `groupsstudents` (
  `groupsStudentId` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  PRIMARY KEY (`groupsStudentId`),
  UNIQUE KEY `groupId` (`groupId`,`studentId`),
  KEY `studentId` (`studentId`),
  CONSTRAINT `groupsstudents_ibfk_1` FOREIGN KEY (`groupId`) REFERENCES `groups` (`groupId`),
  CONSTRAINT `groupsstudents_ibfk_2` FOREIGN KEY (`studentId`) REFERENCES `students` (`studentId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.groupsstudents: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `groupsstudents` DISABLE KEYS */;
REPLACE INTO `groupsstudents` (`groupsStudentId`, `groupId`, `studentId`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 2, 3),
	(4, 3, 3);
/*!40000 ALTER TABLE `groupsstudents` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.meetings
DROP TABLE IF EXISTS `meetings`;
CREATE TABLE IF NOT EXISTS `meetings` (
  `meetingId` int(11) NOT NULL AUTO_INCREMENT,
  `tutoringId` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  `dateMeeting` date NOT NULL,
  `hourMeeting` time NOT NULL,
  PRIMARY KEY (`meetingId`),
  KEY `tutoringId` (`tutoringId`),
  CONSTRAINT `meetings_ibfk_1` FOREIGN KEY (`tutoringId`) REFERENCES `tutorings` (`tutoringId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.meetings: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `meetings` DISABLE KEYS */;
REPLACE INTO `meetings` (`meetingId`, `tutoringId`, `studentId`, `dateMeeting`, `hourMeeting`) VALUES
	(1, 1, 1, '2021-01-12', '12:25:10'),
	(2, 2, 2, '2021-04-10', '10:25:10'),
	(3, 3, 3, '2021-03-03', '21:00:10');
/*!40000 ALTER TABLE `meetings` ENABLE KEYS */;

-- Volcando estructura para procedimiento proyecto_iissi.pAsignTeacherToSubject
DROP PROCEDURE IF EXISTS `pAsignTeacherToSubject`;
DELIMITER //
CREATE PROCEDURE `pAsignTeacherToSubject`(tId INT, gId INT)
BEGIN
	DECLARE cred INT;
	SET cred = (SELECT credits FROM GROUPS G JOIN Subjects S on (G.subjectId=S.subjectId) where G.groupId=gId);
	INSERT INTO TeachersGroups (teacherId, groupId, credits) values
	(tId, gId, cred);
END//
DELIMITER ;

-- Volcando estructura para procedimiento proyecto_iissi.pdeleteStudentGrades
DROP PROCEDURE IF EXISTS `pdeleteStudentGrades`;
DELIMITER //
CREATE PROCEDURE `pdeleteStudentGrades`(dni VARCHAR(9))
BEGIN
	DECLARE id INT;
	SET id = (SELECT S.studentId FROM Students  S WHERE S.dni LIKE dni);
	DELETE FROM Grades  where studentId=id; 

END//
DELIMITER ;

-- Volcando estructura para vista proyecto_iissi.pendingmeetingsview
DROP VIEW IF EXISTS `pendingmeetingsview`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `pendingmeetingsview` (
	`dayWeek` VARCHAR(64) NULL COLLATE 'latin1_swedish_ci',
	`startTime` TIME NOT NULL,
	`endTime` TIME NOT NULL,
	`teacherId` INT(11) NOT NULL,
	`tutoringId` INT(11) NOT NULL,
	`meetingId` INT(11) NOT NULL,
	`studentId` INT(11) NOT NULL,
	`dateMeeting` DATE NOT NULL,
	`hourMeeting` TIME NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para procedimiento proyecto_iissi.pInsertGrade
DROP PROCEDURE IF EXISTS `pInsertGrade`;
DELIMITER //
CREATE PROCEDURE `pInsertGrade`(value INT, gradeCall VARCHAR(64), withHonours BOOLEAN, studentId INT, groupId INT)
BEGIN
	INSERT INTO Grades(value, gradeCall, withHonours, studentId, groupId)
		VALUES (value, gradeCall, withHonours, studentId, groupId);
END//
DELIMITER ;

-- Volcando estructura para procedimiento proyecto_iissi.pShowTutoringMeetings
DROP PROCEDURE IF EXISTS `pShowTutoringMeetings`;
DELIMITER //
CREATE PROCEDURE `pShowTutoringMeetings`(tId INT)
BEGIN
	SELECT * FROM Tutorings T JOIN Meetings M ON (T.tutoringId = M.tutoringId) 
		JOIN  Students S ON (M.studentId= S.studentId)
		WHERE T.teacherId=tId;
END//
DELIMITER ;

-- Volcando estructura para procedimiento proyecto_iissi.pTeachingMostCredits
DROP PROCEDURE IF EXISTS `pTeachingMostCredits`;
DELIMITER //
CREATE PROCEDURE `pTeachingMostCredits`(subjId INT)
BEGIN
	DECLARE cred INT;
	SELECT teacherId, COUNT(*) FROM Subjects S 
		JOIN Groups G ON (S.subjectId=G.subjectId)
		JOIN TeachersGroups TG ON (G.groupId=TG.groupId)
		where S.subjectId = subjId
		GROUP BY teacherId
		ORDER BY COUNT(*) DESC
		LIMIT 1;
END//
DELIMITER ;

-- Volcando estructura para tabla proyecto_iissi.students
DROP TABLE IF EXISTS `students`;
CREATE TABLE IF NOT EXISTS `students` (
  `studentId` int(11) NOT NULL AUTO_INCREMENT,
  `typeAccess` varchar(30) NOT NULL,
  `dni` char(9) NOT NULL,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `birthDate` date NOT NULL,
  `email` varchar(250) NOT NULL,
  PRIMARY KEY (`studentId`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `invalidStudentTypeAccess` CHECK (`typeAccess` in ('Selectividad','Ciclo','Mayor','Titulado','Mayor','Extranjero'))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.students: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
REPLACE INTO `students` (`studentId`, `typeAccess`, `dni`, `name`, `surname`, `birthDate`, `email`) VALUES
	(1, 'Ciclo', '12345678A', 'Juan Antonio', 'Ortiz Guerra', '1991-01-01', 'juan@gmail.com'),
	(2, 'Selectividad', '12345678B', 'José Luis', 'Perez Martínez', '1992-02-02', 'joseluis@gmail.com'),
	(3, 'Extranjero', '12345678C', 'Alejandro', 'García Monte', '1993-03-03', 'alejandro@gmail.com');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;

-- Volcando estructura para vista proyecto_iissi.studentsgroups
DROP VIEW IF EXISTS `studentsgroups`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `studentsgroups` (
	`studentName` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`studentSurname` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`groupName` VARCHAR(30) NOT NULL COLLATE 'latin1_swedish_ci',
	`typeActivity` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci',
	`academicYear` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Volcando estructura para tabla proyecto_iissi.subjects
DROP TABLE IF EXISTS `subjects`;
CREATE TABLE IF NOT EXISTS `subjects` (
  `subjectId` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `acronym` varchar(8) NOT NULL,
  `credits` int(11) NOT NULL,
  `course` int(11) NOT NULL,
  `typeSubject` varchar(20) NOT NULL,
  `degreeId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL,
  PRIMARY KEY (`subjectId`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `acronym` (`acronym`),
  KEY `degreeId` (`degreeId`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`degreeId`) REFERENCES `degrees` (`degreeId`),
  CONSTRAINT `subjects_ibfk_2` FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`),
  CONSTRAINT `negativeSubjectCredits` CHECK (`credits` > 0),
  CONSTRAINT `invalidSubjectCourse` CHECK (`course` >= 1 and `course` <= 5),
  CONSTRAINT `invalidSubjectType` CHECK (`typeSubject` in ('Formacion Basica','Optativa','Obligatoria'))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.subjects: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
REPLACE INTO `subjects` (`subjectId`, `name`, `acronym`, `credits`, `course`, `typeSubject`, `degreeId`, `departmentId`) VALUES
	(1, 'Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1, 2),
	(2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 2, 3),
	(3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 3, 1);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.teachers
DROP TABLE IF EXISTS `teachers`;
CREATE TABLE IF NOT EXISTS `teachers` (
  `teacherId` int(11) NOT NULL AUTO_INCREMENT,
  `dispatchId` int(11) DEFAULT NULL,
  `departmentId` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `dni` varchar(9) NOT NULL,
  `email` varchar(250) NOT NULL,
  `typeTeacher` varchar(60) NOT NULL,
  PRIMARY KEY (`teacherId`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  KEY `dispatchId` (`dispatchId`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `teachers_ibfk_1` FOREIGN KEY (`dispatchId`) REFERENCES `dispatchs` (`dispatchId`),
  CONSTRAINT `teachers_ibfk_2` FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`),
  CONSTRAINT `invalidTypeTeacher` CHECK (`typeTeacher` in ('CU','TU','PCD','PAD'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.teachers: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
REPLACE INTO `teachers` (`teacherId`, `dispatchId`, `departmentId`, `name`, `surname`, `dni`, `email`, `typeTeacher`) VALUES
	(1, 1, 1, 'profesor1', 'apellido1', '12345678A', 'p1@gmail.com', 'CU'),
	(2, 2, 2, 'profesor2', 'apellido2', '12345678B', 'p2@gmail.com', 'TU'),
	(3, 3, 3, 'profesor3', 'apellido3', '12345678C', 'p3@gmail.com', 'PAD'),
	(4, 1, 1, 'profesor4', 'apellido4', '12345678D', 'p4@gmail.com', 'PAD');
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;

-- Volcando estructura para tabla proyecto_iissi.teachersgroups
DROP TABLE IF EXISTS `teachersgroups`;
CREATE TABLE IF NOT EXISTS `teachersgroups` (
  `teacherGroupsId` int(11) NOT NULL AUTO_INCREMENT,
  `teacherId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `credits` int(11) NOT NULL,
  PRIMARY KEY (`teacherGroupsId`),
  UNIQUE KEY `teacherId` (`teacherId`,`groupId`),
  KEY `groupId` (`groupId`),
  CONSTRAINT `teachersgroups_ibfk_1` FOREIGN KEY (`teacherId`) REFERENCES `teachers` (`teacherId`),
  CONSTRAINT `teachersgroups_ibfk_2` FOREIGN KEY (`groupId`) REFERENCES `groups` (`groupId`),
  CONSTRAINT `invalidCredits` CHECK (`credits` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.teachersgroups: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `teachersgroups` DISABLE KEYS */;
REPLACE INTO `teachersgroups` (`teacherGroupsId`, `teacherId`, `groupId`, `credits`) VALUES
	(1, 1, 1, 6),
	(2, 2, 2, 12),
	(3, 3, 4, 18),
	(4, 1, 2, 6),
	(10, 3, 1, 6);
/*!40000 ALTER TABLE `teachersgroups` ENABLE KEYS */;

-- Volcando estructura para vista proyecto_iissi.teachersgroupsview
DROP VIEW IF EXISTS `teachersgroupsview`;
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `teachersgroupsview` (
	`teacherName` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`teacherSurname` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`groupName` VARCHAR(30) NOT NULL COLLATE 'latin1_swedish_ci',
	`typeActivity` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Volcando estructura para tabla proyecto_iissi.tutorings
DROP TABLE IF EXISTS `tutorings`;
CREATE TABLE IF NOT EXISTS `tutorings` (
  `tutoringId` int(11) NOT NULL AUTO_INCREMENT,
  `teacherId` int(11) NOT NULL,
  `dayWeek` varchar(64) DEFAULT NULL,
  `startTime` time NOT NULL,
  `endTime` time NOT NULL,
  PRIMARY KEY (`tutoringId`),
  KEY `teacherId` (`teacherId`),
  CONSTRAINT `tutorings_ibfk_1` FOREIGN KEY (`teacherId`) REFERENCES `teachers` (`teacherId`),
  CONSTRAINT `endTimeGreaterThanFirstTime` CHECK (`startTime` < `endTime`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla proyecto_iissi.tutorings: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `tutorings` DISABLE KEYS */;
REPLACE INTO `tutorings` (`tutoringId`, `teacherId`, `dayWeek`, `startTime`, `endTime`) VALUES
	(1, 1, 'LUNES', '12:25:10', '12:30:10'),
	(2, 2, 'MARTES', '10:25:10', '13:00:10'),
	(3, 3, 'MIÉRCOLES', '21:00:00', '22:25:10');
/*!40000 ALTER TABLE `tutorings` ENABLE KEYS */;

-- Volcando estructura para vista proyecto_iissi.bussydispatchsview
DROP VIEW IF EXISTS `bussydispatchsview`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `bussydispatchsview`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `bussydispatchsview` AS (select `d`.`name` AS `name`,count(0) AS `numeroProfesores` from (`dispatchs` `d` join `teachers` `t` on(`d`.`dispatchId` = `t`.`dispatchId`)) group by `d`.`dispatchId` having count(0) > 1);

-- Volcando estructura para vista proyecto_iissi.gradesstudents
DROP VIEW IF EXISTS `gradesstudents`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `gradesstudents`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `gradesstudents` AS (select `s`.`studentId` AS `studentId`,`s`.`name` AS `name`,`s`.`dni` AS `dni`,`g`.`gradeId` AS `gradeId`,`g`.`groupId` AS `groupId`,`g`.`value` AS `value`,`g`.`gradeCall` AS `gradeCall`,`g`.`withHonours` AS `withHonours` from (`students` `s` join `grades` `g` on(`s`.`studentId` = `g`.`studentId`)));

-- Volcando estructura para vista proyecto_iissi.gradesstudentsview
DROP VIEW IF EXISTS `gradesstudentsview`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `gradesstudentsview`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `gradesstudentsview` AS (select `s`.`studentId` AS `studentId`,`s`.`name` AS `name`,`s`.`dni` AS `dni`,`g`.`gradeId` AS `gradeId`,`g`.`groupId` AS `groupId`,`g`.`value` AS `value`,`g`.`gradeCall` AS `gradeCall`,`g`.`withHonours` AS `withHonours` from (`students` `s` join `grades` `g` on(`s`.`studentId` = `g`.`studentId`)));

-- Volcando estructura para vista proyecto_iissi.pendingmeetingsview
DROP VIEW IF EXISTS `pendingmeetingsview`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `pendingmeetingsview`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `pendingmeetingsview` AS (select `t`.`dayWeek` AS `dayWeek`,`t`.`startTime` AS `startTime`,`t`.`endTime` AS `endTime`,`t`.`teacherId` AS `teacherId`,`t`.`tutoringId` AS `tutoringId`,`m`.`meetingId` AS `meetingId`,`m`.`studentId` AS `studentId`,`m`.`dateMeeting` AS `dateMeeting`,`m`.`hourMeeting` AS `hourMeeting` from (`tutorings` `t` join `meetings` `m` on(`t`.`tutoringId` = `m`.`tutoringId`)) where `m`.`dateMeeting` >= current_timestamp());

-- Volcando estructura para vista proyecto_iissi.studentsgroups
DROP VIEW IF EXISTS `studentsgroups`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `studentsgroups`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `studentsgroups` AS (select `s`.`name` AS `studentName`,`s`.`surname` AS `studentSurname`,`g`.`name` AS `groupName`,`g`.`typeActivity` AS `typeActivity`,`g`.`academicYear` AS `academicYear` from ((`students` `s` join `groupsstudents` `gs` on(`s`.`studentId` = `gs`.`studentId`)) join `groups` `g` on(`gs`.`groupId` = `g`.`groupId`)));

-- Volcando estructura para vista proyecto_iissi.teachersgroupsview
DROP VIEW IF EXISTS `teachersgroupsview`;
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `teachersgroupsview`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `teachersgroupsview` AS (select `t`.`name` AS `teacherName`,`t`.`surname` AS `teacherSurname`,`g`.`name` AS `groupName`,`g`.`typeActivity` AS `typeActivity` from ((`teachers` `t` join `teachersgroups` `tg` on(`t`.`teacherId` = `tg`.`teacherId`)) join `groups` `g` on(`tg`.`groupId` = `g`.`groupId`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
