DROP TABLE IF EXISTS Grades;/*
DROP TABLE IF EXISTS GroupStudents;*/

DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Degrees;
/* si existe degrees la borra*/


CREATE TABLE Degrees(
	degreeId INT NOT NULL AUTO_INCREMENT,/*NOT NULL ES INNECESARIO
	YA QUE LUEGO LO PONEMOS COMO PK*/
	name VARCHAR(60) NOT NULL UNIQUE,
	years INT DEFAULT(4) NOT NULL,
	PRIMARY KEY (degreeId),
	CONSTRAINT invalidDegreeYear CHECK (years>=3 AND years <=5)
);



CREATE TABLE Subjects(
	subjectId INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	acronym VARCHAR(8) NOT NULL UNIQUE,
	credits INT NOT NULL,
	year INT NOT NULL,
	type VARCHAR(20) NOT NULL,
	degreeId INT NOT NULL,
	PRIMARY KEY (subjectId),
	FOREIGN KEY (degreeId) REFERENCES Degrees (degreeId),
	CONSTRAINT negativeSubjectsCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCourse CHECK (year >= 1 AND year <= 5),
	CONSTRAINT invalidSubjectType CHECK (type IN ('Formacion Basica', 'Optativa', 'Obligatoria'))
);
CREATE TABLE Groups(
	groupId INT AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	year INT NOT NULL,
	subjectId INT, 
	PRIMARY KEY(groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	UNIQUE (name, year, subjectId),
	CONSTRAINT negativeGroupYear CHECK (year>0),
	CONSTRAINT invalidGroupActivity CHECK (activity IN ('Teoria', 'Laboratorio'))
);

/*CREATE TABLE Students(
	studentId INT AUTO_INCREMENT NOT NULL,
	accessMethod VARCHAR(30) NOT NULL,
	DNI CHAR(9) NOT NULL UNIQUE,
	firstName VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	birthDate DATE NOT NULL,
	email VARCHAR(250) NOT NULL UNIQUE,
	PRIMARY KEY (studentId),
	CONSTRAINT invalidStudentAccessMethod CHECK (accessMethod IN ('Selectividad', 'Ciclo', 'Mayor', 'Titulado Extranjero'))
	
);*/
/*CREATE TABLE GroupsStudents(
	groupStudentId INT NOT NULL AUTO_INCREMENT,
	groupId INT NOT NULL,
	studentId INT NOT NULL,
	PRIMARY KEY (groupStudentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	UNIQUE (groupId, studentId)
);

CREATE TABLE Grades(
	gradeId INT NOT NULL AUTO_INCREMENT,
	value DECIMAL(4,2) NOT NULL,
	gradeCall INT NOT NULL,
	withHonours BOOLEAN NOT NULL,
	studentId INT NOT NULL,
	groupId INT NOT NULL,
	PRIMARY KEY (gradeId),
	FOREIGN KEY (studentId) REFERENCES Students (studentId),
	FOREIGN KEY (groupId) REFERENCES Groups (groupId),
	CONSTRAINT invalidGradeValue CHECK (value>=0 AND value<=10),
	CONSTRAINT invalidGradeCall CHECK (gradoCall>=1 AND gradeCall<=3),
	CONSTRAINT duplicatedCallGrade UNIQUE (gradeCall, studentId, groupId)
);*/
/*tabla grupos tiene como clave alternativa name,year y subjectId juntos
no puede haber una fila con los 3 atributos a la vez unicos*/

/*TABLA STUDENTS char-> obliga que la cadena de caracteres tenga exactamente el numero especificado
DATE--> fecha
TIME-->hora
*/
/*tabla groupStudents
apunta a groups y students*/
/*tabla grados
DECIMAL--> numero decimal, primer numero es longitud y el 2º digito para los decimales*/