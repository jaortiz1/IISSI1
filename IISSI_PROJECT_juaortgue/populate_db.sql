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


INSERT INTO Degrees (degreeId, name, years, credits) VALUES
	(1, 'Ingeniería del Software', 4, 240),
	(2, 'Ingeniería del Computadores', 5, 300),
	(3, 'Tecnologías Informáticas', 4, 240);


/*DEPARTAMENTOS*/


INSERT INTO Departments (departmentId, name) VALUES
	(1, 'Matemática'),
	(2, 'Hardware'),
	(3, 'Informática');


/*DESPACHOS*/

INSERT INTO Dispatchs (dispatchId, name, floor, capacity) VALUES
	(1, 'Primer despacho', 1, 1),
	(2, 'Segundo despacho', 2, 2),
	(3, 'Tercer despacho',3, 3);


/*AULAS*/

INSERT INTO Classrooms (classroomId,name,floor,capacity,megaphone,projector,typeActivity) VALUES
	(1, 'Primera clase', 1, 1,false,false, 'Laboratorio'),
	(2, 'Segunda clase', 2, 2,true,true, 'Laboratorio' ),
	(3, 'Tercera clase',3, 3,true,false, 'Teoría');


/*ESTUDIANTES*/

INSERT INTO Students (studentId,name,surname,dni,email, birthdate, typeAccess) VALUES
	(1, 'Juan Antonio','Ortiz Guerra', '12345678A', 'juan@gmail.com', '1991-01-01', 'Ciclo'),
	(2, 'José Luis','Perez Martínez', '12345678B', 'joseluis@gmail.com', '1992-02-02','Selectividad'),
	(3, 'Alejandro','García Monte', '12345678C', 'alejandro@gmail.com', '1993-03-03','Extranjero');


/*PROFESORES*/


INSERT INTO Teachers (teacherId,dispatchId,departmentId,name,surname,dni,email, typeTeacher) VALUES
	(1, 1, 1, 'profesor1','apellido1','12345678A','p1@gmail.com','CU'),
	(2, 2, 2, 'profesor2','apellido2','12345678B','p2@gmail.com','TU'),
	(3, 3, 3, 'profesor3','apellido3','12345678C','p3@gmail.com','PAD'),
	(4, 1, 1, 'profesor4','apellido4','12345678D','p4@gmail.com','PAD');

INSERT INTO Subjects (subjectId, name, acronym, credits, course, typeSubject, degreeId, departmentId) VALUES
	(1, 'Diseño y Pruebas', 'DP', 12, 3, 'Obligatoria', 1,2),
	(2, 'Acceso Inteligente a la Informacion', 'AII', 6, 4, 'Optativa', 2,3),
	(3, 'Optimizacion de Sistemas', 'OS', 6, 4, 'Optativa', 3,1);



/*GROUPS*/


INSERT INTO Groups (groupId, name, typeActivity, academicYear, subjectId, classroomId) VALUES
	(1, 'T1', 'Teoria', 2020, 1,1),
	(2, 'T2', 'Teoria', 2020, 1,1),
	(3, 'L1', 'Laboratorio', 2020, 2,2),
	(4, 'L2', 'Laboratorio', 2020, 2,2),
	(5, 'L3', 'Laboratorio', 2020, 1,3);



/*GROUPSSTUDENTS*/

INSERT INTO GroupsStudents (groupsStudentId, groupId, studentId) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 2, 3),
	(4, 3, 3);



/*GRADES=NOTAS*/

INSERT INTO Grades (gradeId, value, gradeCall, withHonours, studentId, groupId) VALUES
	(1, 4.50, 'Primera', 0, 1, 1),
	(2, 3.25, 'Segunda', 0, 1, 1),
	(3, 9.95, 'Primera', 0, 3, 3),
	(4, 10, 'Extraordinaria', 1, 2, 2);
SELECT * FROM Grades;



/*TUTORINGS*/

INSERT INTO Tutorings (tutoringId, teacherId,dayWeek, startTime, endTime) VALUES
	(1,1,'LUNES','12:25:10', '12:30:10'),
	(2,2, 'MARTES','10:25:10', '13:00:10'),
	(3,3, 'MIÉRCOLES','21:00:00', '22:25:10');



INSERT INTO Meetings (meetingId,tutoringId,studentId,dateMeeting,hourMeeting) VALUES
(1,1,1, '2021-01-12', '12:25:10'),
(2,2,2, '2021-04-10', '10:25:10'),
(3,3,3, '2021-03-3', '21:00:10');

INSERT INTO TeachersGroups (teacherGroupsId, teacherId, groupId, credits) VALUES 
(1, 1, 1, 6),
(2, 2, 2, 12),
(3, 3, 4, 18),
(4, 1, 2, 6);
