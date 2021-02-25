/*
INSERT INTO degrees VALUES (NULL, 'Tecnologías informáticas',4);
*/
/*Insertamos por orden*/
INSERT INTO degrees (name, years) VALUES/*decimos las columnas a las que les damos valor*/
 ('Tecnologías Informáticas', 4),/*si no aparece la columna se le dara el valor nulo*/
 ('Ingeniería de computadores', 4),
 ('Ingeniería del software', 4);
INSERT INTO subjects (name, acronym, credits, year, type, degreeId) VALUES
 	('Fundamentos de programación', 'FP', 12, 1, 'Formación básica', 3),
	('Lógica informática', 'LI', 6, 2, 'Optativa', 3);
INSERT INTO groups (name, activity, year, subjectId) VALUES
	('T1', 'Teoría', 2019, 1),
	('L1', 'Laboratorio', 2019,1);

UPDATE students
	SET birthdate='2001-06-04', surname='Cano'
	WHERE studentId=1;
UPDATE subjects
	SET credits = credits/2;
/*Si no hay un where se actualizan todas las filas
Si es impar el numero de creditos redondea por arriba*/
SELECT * FROM subjects;

DELETE FROM grades 
	WHERE gradeId=1;
	
SELECT * FROM grades;

DELETE FROM degrees where degreeId=1;
/************CONSULTAS**************/
SELECT firstname, surname
	FROM students
	WHERE accessMethod = 'Selectividad';
SELECT credits > 8/*nos devuelve 1 o 0 para cada fila
si cumple la condicion*/
	FROM subjects;

/*operadores de agregacion: SOLO MUESTRAN UN VALOR*/
SELECT AVG(credits) AS MEDIA, SUM(credits) as SUMA, MAX(credits) AS MAXIMO
	FROM subjects;
	/*No tiene sentido pedir columnas y operadores de agregacion*/
SELECT AVG(credits), SUM(credits), name
	FROM subjects;

SELECT COUNT(*)
	FROM subjects
	WHERE credits > 8;
/*cuenta los valores que hay diferentes en el accessMethod*/
SELECT COUNT(DISTINCT accessMethod) AS METODOS_ACCESO
	FROM students;

/*******VISTAS*********/
/*almacenamos loso grados donde el grupoId sea 18*/
/*AS indica que va a empezar la definición*/
CREATE OR REPLACE VIEW ViewGradesGroup18 AS
	SELECT * FROM grades WHERE groupId = 18;
SELECT MAX(value) FROM ViewGradesGroup18;

SELECT COUNT(*) FROM ViewGradesGroup18;

SELECT * FROM ViewGradesGroup18
	WHERE gradeCall = 2;
SELECT * FROM ViewGradesGroup18;

/*VISTAS DENTRO DE OTRAS*/
/*hacemos otra vista que incluye a la primera pero
que sea solo de la primera convocatoria*/
CREATE OR REPLACE VIEW ViewGradesGroup18Call1 AS
	SELECT * FROM ViewGradesGroup18 
	WHERE gradeCall = 1;
SELECT * FROM ViewGradesGroup18Call1;


SELECT * 
	FROM grades
	 WHERE value < 4 OR value > 6;
SELECT DISTINCT name
	FROM groups;

/*alumnos que tienen el apellido igual al acronimo de una 
asignatura*/
SELECT * 
	FROM students
	WHERE surname IN	(SELECT acronym FROM subjects);
/*ID DE LOS ALUMNOS DEL CURSO 2019
el año esta en groups
la tabla groupStudents me relaciona alumnos y grupos*/
SELECT DISTINCT(studentId)
	FROM groupsStudents
	WHERE groupId IN(SELECT groupId FROM groups WHERE year = 2019);

/********************EJERCICIOS*******************/
/*1.Nombre de las asignaturas que son obligatorias.*/
SELECT DISTINCT(name)
	FROM subjects
	WHERE type = 'Obligatoria';
/*2.Media de las notas del grupo con ID 19, usando el agregador AVG.*/
SELECT AVG(value) 
	FROM grades
	WHERE groupId=19;
/*3.Media de las notas del grupo con ID 19 sin usar AVG*/

SELECT SUM(value)/COUNT(*) FROM grades WHERE groupId = 19;
/*4.Cantidad de nombres de grupo diferentes*/
SELECT DISTINCT(name) from groups;
/*5.Notas entre 4 y 6, inclusive.*/
SELECT value 
	FROM grades 
	WHERE 4<=value AND value<=6;
/*6.Notas con valor igual o superior a 9, pero que no son matrícula de honor.
Cree una vista para las notas que son matrícula de honor*/
CREATE OR REPLACE VIEW matriculas AS 
	(SELECT value 
		FROM grades
	 	where withHonours=1);
SELECT value 
	FROM grades
	WHERE value>=9 AND withHonours = 0;

/