/*GRADOS*/

DROP TABLE IF EXISTS TeachersGroups;
DROP TABLE IF EXISTS Meetings;
DROP TABLE IF EXISTS Tutorings;
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS GroupsStudents;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Classrooms;
DROP TABLE IF EXISTS Dispatchs;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Degrees;

CREATE TABLE Degrees(
	degreeId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL UNIQUE,
	years INT DEFAULT(4) NOT NULL,
	credits INT DEFAULT(240),
	PRIMARY KEY (degreeId),
	CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years <=5)
);
INSERT INTO Degrees (degreeId, name, years, credits) VALUES
	(1, 'Ingeniería del Software', 4, 240),
	(2, 'Ingeniería del Computadores', 5, 300),
	(3, 'Tecnologías Informáticas', 4, 240);
SELECT * FROM Degrees;

/*DEPARTAMENTOS*/
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments (
	departmentId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL UNIQUE,
	PRIMARY KEY (departmentId)
);

INSERT INTO Departments (departmentId, name) VALUES
	(1, 'Matemática'),
	(2, 'Hardware'),
	(3, 'Informática');

SELECT * FROM Departments;

/*DESPACHOS*/
DROP TABLE IF EXISTS Dispatchs;
CREATE TABLE Dispatchs (
	dispatchId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL UNIQUE,
	floor INT NOT NULL,
	capacity INT NOT NULL,
	PRIMARY KEY (dispatchId),
	CONSTRAINT incorrectCapacity CHECK (capacity>0)
);
INSERT INTO Dispatchs (dispatchId, name, floor, capacity) VALUES
	(1, 'Primer despacho', 1, 1),
	(2, 'Segundo despacho', 2, 2),
	(3, 'Tercer despacho',3, 3);
SELECT * FROM Dispatchs;

/*AULAS*/
DROP TABLE IF EXISTS Classrooms;
CREATE TABLE Classrooms (
	classroomId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(60) NOT NULL UNIQUE,
	floor INT NOT NULL,
	capacity INT NOT NULL,
	megaphone BOOLEAN DEFAULT(false),
	projector BOOLEAN DEFAULT(false),
	typeActivity VARCHAR(60) NOT NULL,
	PRIMARY KEY (classroomId),
	CONSTRAINT incorrectCapacity CHECK (capacity>0),
	CONSTRAINT incorrectTypeActivity CHECK (typeActivity='Laboratorio' OR typeActivity='Teoría')
);
INSERT INTO Classrooms (classroomId,name,floor,capacity,megaphone,projector,typeActivity) VALUES
	(1, 'Primera clase', 1, 1,false,false, 'Laboratorio'),
	(2, 'Segunda clase', 2, 2,true,true, 'Laboratorio' ),
	(3, 'Tercera clase',3, 3,true,false, 'Teoría');
SELECT * FROM Classrooms;

/*ESTUDIANTES*/
DROP TABLE IF EXISTS Students;
CREATE TABLE Students(
	studentId INT NOT NULL AUTO_INCREMENT,
	typeAccess VARCHAR(30) NOT NULL,
	dni CHAR(9) NOT NULL UNIQUE,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	birthDate DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	PRIMARY KEY (studentId),
	CONSTRAINT invalidStudentTypeAccess CHECK (typeAccess IN ('Selectividad',
																					  'Ciclo',																				  'Mayor',
																					  'Titulado', 'Mayor', 'Extranjero'))
);
INSERT INTO Students (studentId,name,surname,dni,email, birthdate, typeAccess) VALUES
	(1, 'Juan Antonio','Ortiz Guerra', '12345678A', 'juan@gmail.com', '1991-01-01', 'Ciclo'),
	(2, 'José Luis','Perez Martínez', '12345678B', 'joseluis@gmail.com', '1992-02-02','Selectividad'),
	(3, 'Alejandro','García Monte', '12345678C', 'alejandro@gmail.com', '1993-03-03','Extranjero');
SELECT * FROM Students;

/*PROFESORES*/

DROP TABLE IF EXISTS Teachers;
CREATE TABLE Teachers (
	teacherId INT NOT NULL AUTO_INCREMENT,
	dispatchId INT,
	departmentId INT NOT NULL,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL, 
	dni VARCHAR(9) NOT NULL UNIQUE,
	email VARCHAR(250) NOT NULL UNIQUE,
	typeTeacher VARCHAR(60) NOT NULL,
	PRIMARY KEY (teacherId),
	FOREIGN KEY (dispatchId) REFERENCES Dispatchs (dispatchId),
	FOREIGN KEY (departmentId) REFERENCES Departments (departmentId),
	CONSTRAINT invalidTypeTeacher CHECK (typeTeacher IN ('CU','TU',
																					  'PCD',
																					  'PAD'))
	
);
INSERT INTO Teachers (teacherId,dispatchId,departmentId,name,surname,dni,email, typeTeacher) VALUES
	(1, 1, 1, 'profesor1','apellido1','12345678A','p1@gmail.com','CU'),
	(2, 2, 2, 'profesor2','apellido2','12345678B','p2@gmail.com','TU'),
	(3, 3, 3, 'profesor3','apellido3','12345678C','p3@gmail.com','PAD'),
	(4, 1, 1, 'profesor4','apellido4','12345678D','p4@gmail.com','PAD');
SELECT * FROM Teachers;
/*SUBJECTS*/
DROP TABLE IF EXISTS Subjects;
CREATE TABLE Subjects(
	subjectId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL UNIQUE,
	acronym VARCHAR(8) NOT NULL UNIQUE,
	credits INT NOT NULL,
	course INT NOT NULL,
	typeSubject VARCHAR(20) NOT NULL,
	degreeId INT NOT NULL,
	departmentId INT NOT NULL,
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
	FOREIGN KEY (departmentId) REFERENCES Departments (departmentId),
	CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCourse CHECK (course >= 1 AND course <= 5),
	CONSTRAINT invalidSubjectType CHECK (typeSubject IN ('Formacion Basica',
																 'Optativa',
																 'Obligatoria'))
);
INSERT INTO Subjects (subjectId, name, acronym, credits, course, typeSubject, degreeId, departmentId) VALUES
	(1, 'Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1,2),
	(2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 2,3),
	(3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 3,1);
SELECT * FROM Subjects;


/*GROUPS*/
DROP TABLE IF EXISTS Groups;
CREATE TABLE Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	typeActivity VARCHAR(20) NOT NULL,
	academicYear INT NOT NULL,
	subjectId INT NOT NULL,
	classroomId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	FOREIGN KEY (classroomId) REFERENCES Classrooms (classroomId),
	UNIQUE (name, academicYear, subjectId),
	CONSTRAINT negativeGroupYear CHECK (academicYear > 0),
	CONSTRAINT invalidGroupActivity CHECK (typeActivity IN ('Teoria',
																		 'Laboratorio'))
);

INSERT INTO Groups (groupId, name, typeActivity, academicYear, subjectId, classroomId) VALUES
	(1, 'T1', 'Teoria', 2020, 1,1),
	(2, 'T2', 'Teoria', 2020, 1,1),
	(3, 'L1', 'Laboratorio', 2020, 2,2),
	(4, 'L2', 'Laboratorio', 2020, 2,2),
	(5, 'L3', 'Laboratorio', 2020, 1,3);


SELECT * FROM Groups;

DROP TABLE IF EXISTS GroupsStudents;
/*GROUPSSTUDENTS*/
CREATE TABLE GroupsStudents(
	groupsStudentId INT NOT NULL AUTO_INCREMENT,
	groupId INT NOT NULL,
	studentId INT NOT NULL,
	PRIMARY KEY (groupsStudentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	UNIQUE (groupId, studentId)
);
INSERT INTO GroupsStudents (groupsStudentId, groupId, studentId) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 2, 3),
	(4, 3, 3);

SELECT * FROM GroupsStudents;

/*GRADES=NOTAS*/
DROP TABLE IF EXISTS Grades;
CREATE TABLE Grades(
	gradeId INT NOT NULL AUTO_INCREMENT,
	studentId INT NOT NULL,
	groupId INT NOT NULL,
	value DECIMAL(4,2) NOT NULL,
	gradeCall VARCHAR(32) NOT NULL,
	withHonours BOOLEAN NOT NULL,
	PRIMARY KEY (gradeId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	CONSTRAINT invalidGradeValue CHECK (value >= 0 AND value <= 10),
	CONSTRAINT invalidGradeCall CHECK (gradeCall IN ('Primera', 'Segunda', 'Tercera', 'Extraordinaria'))
);
INSERT INTO Grades (gradeId, value, gradeCall, withHonours, studentId, groupId) VALUES
	(1, 4.50, 'Primera', 0, 1, 1),
	(2, 3.25, 'Segunda', 0, 1, 1),
	(3, 9.95, 'Primera', 0, 3, 3),
	(4, 10, 'Extraordinaria', 1, 2, 2);
SELECT * FROM Grades;



/*TUTORINGS*/
DROP TABLE IF EXISTS Tutorings;
CREATE TABLE Tutorings(
	tutoringId INT NOT NULL AUTO_INCREMENT,
	teacherId INT NOT NULL,
	dayWeek VARCHAR(64),
	startTime TIME NOT NULL,
	endTime TIME NOT NULL,
	PRIMARY KEY(tutoringId),
	FOREIGN KEY(teacherId) REFERENCES Teachers(teacherId),
	CONSTRAINT endTimeGreaterThanFirstTime CHECK (startTime<endTime)
);
INSERT INTO Tutorings (tutoringId, teacherId,dayWeek, startTime, endTime) VALUES
	(1,1,'LUNES','12:25:10', '12:30:10'),
	(2,2, 'MARTES','10:25:10', '13:00:10'),
	(3,3, 'MIÉRCOLES','21:00:00', '22:25:10');
SELECT * FROM Tutorings;

DROP TABLE IF EXISTS Meetings;
CREATE TABLE Meetings(
	meetingId INT NOT NULL AUTO_INCREMENT,
	tutoringId INT NOT NULL,
	studentId INT NOT NULL,
	dateMeeting DATE NOT NULL,
	hourMeeting TIME NOT NULL,
	PRIMARY KEY(meetingId),
	FOREIGN KEY(tutoringId) REFERENCES Tutorings(tutoringId)
);
INSERT INTO Meetings (meetingId,tutoringId,studentId,dateMeeting,hourMeeting) VALUES
(1,1,1, '2021-01-12', '12:25:10'),
(2,2,2, '2021-04-10', '10:25:10'),
(3,3,3, '2021-03-3', '21:00:10');
SELECT * FROM Meetings;

DROP TABLE IF EXISTS TeachersGroups;
CREATE TABLE TeachersGroups (
	teacherGroupsId INT NOT NULL AUTO_INCREMENT,
	teacherId INT NOT NULL,
	groupId INT NOT NULL,
	credits INT NOT NULL,
	PRIMARY KEY(teacherGroupsId),
	FOREIGN KEY(teacherId) REFERENCES Teachers(teacherId),
	FOREIGN KEY(groupId) REFERENCES Groups(groupId),
	CONSTRAINT invalidCredits CHECK (credits>0),
	UNIQUE(teacherId, groupId)
);
INSERT INTO TeachersGroups (teacherGroupsId, teacherId, groupId, credits) VALUES 
(1, 1, 1, 6),
(2, 2, 2, 12),
(3, 3, 4, 18),
(4, 1, 2, 6);
SELECT * FROM TeachersGroups;