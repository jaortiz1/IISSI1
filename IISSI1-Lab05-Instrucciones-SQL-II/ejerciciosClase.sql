/*SI NO PONEMOS ORDER BY LO ORDENA POR EL ORDEN DE INSERCION*/
SELECT *
	FROM Grades
	ORDER BY value;
	/*lo ordena de mas nota a menos*/
SELECT *
	FROM Grades
	ORDER BY value DESC;
/*cojo notas aprobadas ordenadas por el apellido del estudiante*/
SELECT *
	FROM Grades
	WHERE value >5
	ORDER BY (SELECT surname
					FROM Students
					WHERE Students.studentId = Grades.studentId)
	DESC;


SELECT *
	FROM Grades
	ORDER BY VALUE DESC
	LIMIT 5;
/*SE SALTA LA PRIMERA PAGINA, OSEA LAS PRIMERAS 5 FILAS
DEL LIMIT*/
SELECT *
	FROM Grades
		ORDER BY VALUE DESC
		LIMIT 5 OFFSET 5;
/*PRODUCTO CARTESIANO = JOIN*/
SELECT *
	FROM Degrees, Subjects;

SELECT *
FROM Degrees
JOIN Subjects ON (degrees.degreeId = Subjects.degreeId);

SELECT *
FROM Degrees
LEFT JOIN Subjects ON (degrees.degreeId = Subjects.degreeId);
/*no devuelve nada porque intenta fusionar por degreeId y 
tambien por el atributo name que esta en ambas tablas*/
SELECT * FROM Degrees NATURAL JOIN Subjects;

SELECT * FROM GroupsStudents NATURAL JOIN Students;
SELECT * FROM GroupsStudents NATURAL JOIN Students NATURAL JOIN Groups;

/*GROUP BY*/
/*me daria todas las notas de cada alumno*/
SELECT *
	FROM Grades
	JOIN Students ON (Grades.StudentId = Students.studentId);
/*agrupar todas las notas de un alumno y luego aplicarle la media*/
SELECT firstName, surname, AVG(value)
	FROM Students
	JOIN Grades ON (Students.studentId = Grades.studentId)
	GROUP BY Students.studentId;

/*unimos students grades y groups y subjects*/
SELECT Students.studentId, Students.firstname, Students.surname,
	Subjects.subjectId, Subjects.name,
	Grades.value, Grades.gradecall,
	Groups.year
FROM Students
JOIN Grades ON (Students.studentId = Grades.studentId)
JOIN Groups ON (Grades.groupId = Groups.groupId)
JOIN Subjects ON (Groups.subjectId = Subjects.subjectId);



CREATE OR REPLACE VIEW ViewSubjectGrades AS
	SELECT Students.studentId, Students.firstname, Students.surname,
		Subjects.subjectId, Subjects.name,
		Grades.value, Grades.gradecall,
		Groups.year
	FROM Students
	JOIN Grades ON (Students.studentId = Grades.studentId)
	JOIN Groups ON (Grades.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId);
	
SELECT gradeCall, name, AVG(value)
	FROM ViewSubjectGrades
	WHERE year = 2018
	GROUP BY gradeCall, subjectId;/*agrupa las filas por los distintos
	subjectsId que van con los distintos gradeCall*/

SELECT name, AVG(value)
	FROM ViewSubjectGrades
	/*AQUI IRIA WHERE*/
	GROUP BY name
	HAVING COUNT(*)>2;/*QUITA LOS GRUPOS CON 2 O MENOS FILAS*/
	
/*Número de alumnos nacidos en cada año*/
SELECT YEAR(birthdate), COUNT(*)
	FROM Students
	GROUP BY YEAR(birthdate);
	
	
CREATE OR REPLACE VIEW ViewSubjectGroups AS
	SELECT Subjects.*, Groups.name AS groupName, Groups.activity, Groups.year AS groupYear
		FROM Subjects JOIN Groups ON (Subjects.subjectId = Groups.subjectId);	
	
SELECT name, COUNT(*)
	FROM ViewSubjectGroups
	WHERE groupYear = 2019 AND activity = 'Teoria'
	GROUP BY subjectId
	ORDER BY COUNT(*) DESC
	LIMIT 3;
	
/*ejercicio 1*/
SELECT U.name, COUNT(*)
	FROM Grades G
	JOIN Users U ON (G.studentId = U.userId)
	WHERE G.value < 5
	GROUP BY U.name;
/*ejercicio 2*/
SELECT *
	FROM Groups G
	LIMIT 3
	OFFSET 6;
/*Ejercicio 3*/
SELECT G.groupId, S.acronym, D.name FROM Groups G
	JOIN Subjects S ON(G.subjectId = S.subjectId)
	JOIN Degrees D ON(S.degreeId = D.degreeId);
/*Ejercicio 4*/
	
SELECT GS.groupId, COUNT(DISTINCT(S.accessMethod)) metodosAcesso
	FROM Students S
	JOIN GroupsStudents GS ON(S.studentId=GS.studentId)
	WHERE GS.groupId=1
	GROUP BY GS.groupId;
/*ejercicio 5*/
CREATE OR REPLACE VIEW ViewSubjectGrades AS
	SELECT Students.studentId, Students.firstName, Students.surname,
			 Subjects.subjectId, Subjects.name, Subjects.credits,
			 Grades.value, Grades.gradeCall, 
			 Groups.year
	FROM Students
	JOIN Grades ON (Students.studentId = Grades.studentId)
	JOIN Groups ON (Grades.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId);
	
SELECT firstname, surname, (credits*value)/(SELECT SUM(credits) FROM ViewSubjectGrades WHERE gradeCall = 1) AS NotaPonderada 
	FROM ViewSubjectGrades
	WHERE gradeCall = 1;
select credits*value FROM ViewSubjectGrades;
	
	
	