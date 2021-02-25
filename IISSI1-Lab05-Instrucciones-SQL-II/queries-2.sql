SELECT * 
	FROM Grades 
	ORDER BY value;
	
SELECT * 
	FROM Grades 
	WHERE VALUE >5
	ORDER BY (SELECT surname 
				 FROM Students 
				 WHERE Students.studentId = Grades.studentId) 
	DESC;

SELECT * 
	FROM Grades 
	ORDER BY VALUE DESC
	LIMIT 5;
	
SELECT * 
	FROM Grades 
	ORDER BY VALUE DESC
	LIMIT 5 OFFSET 5;
	
SELECT *
	FROM Groups, GroupsStudents, Students;
	
SELECT *
	FROM Groups
	JOIN GroupsStudents ON (Groups.groupId = GroupsStudents.groupId)
	JOIN Students ON (GroupsStudents.studentId = Students.studentId);
	
	
SELECT *
	FROM Groups, GroupsStudents, Students
	WHERE Groups.groupId = GroupsStudents.groupId AND
			GroupsStudents.studentId = Students.studentId;
			
SELECT firstName, surname, AVG(value)
	FROM Students 
	JOIN Grades ON (Students.studentId = Grades.studentId)
	GROUP BY Students.studentId;
	
CREATE OR REPLACE VIEW ViewSubjectGrades AS
	SELECT Students.studentId, Students.firstName, Students.surname,
			 Subjects.subjectId, Subjects.name,
			 Grades.value, Grades.gradeCall, 
			 Groups.year
	FROM Students
	JOIN Grades ON (Students.studentId = Grades.studentId)
	JOIN Groups ON (Grades.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId);
	
SELECT gradeCall, name, AVG(value)
	FROM ViewSubjectGrades
	WHERE VALUE >= 5 AND year = 2018
	GROUP BY gradeCall, subjectId;
	
SELECT name, AVG(VALUE)
	FROM ViewSubjectGrades
	GROUP BY NAME
	HAVING COUNT(*) > 2;
	
-- Número de alumnos nacidos en cada año
			
SELECT YEAR(birthdate), COUNT(*)
	FROM Students
	GROUP BY YEAR(birthdate);

-- Número de alumnos por grado en el curso 2019
-- Vista con los estudiantes de cada grado
CREATE OR REPLACE VIEW ViewDegreeStudents AS
	SELECT Students.*, Degrees.*, year
	FROM Students
	JOIN GroupsStudents ON (Students.studentId = GroupsStudents.studentId)
	JOIN Groups ON (GroupsStudents.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId)
	JOIN Degrees ON (Subjects.degreeId = Degrees.degreeId);
	
SELECT name, COUNT(*)
	FROM ViewDegreeStudents
	WHERE year = 2019
	GROUP BY NAME;
	

-- Nota máxima de cada alumno, con el nombre y apellidos

SELECT firstName, surname, MAX(VALUE)
	FROM ViewSubjectGrades
	GROUP BY studentId;
	
-- Nombre y número de grupos de teoría de las 3 asignaturas con mayor número de grupos de teoría en el año 2019
-- Vista con las asignaturas de cada grupo
CREATE OR REPLACE VIEW ViewSubjectGroups AS
	SELECT Subjects.*, Groups.name AS groupName, Groups.activity, Groups.year
	FROM Subjects JOIN Groups ON (Subjects.subjectId = Groups.subjectId);
	
SELECT name, COUNT(*)
	FROM ViewSubjectGroups
	WHERE year = 2019 AND activity = 'Teoria'
	GROUP BY subjectId
	ORDER BY COUNT(*) DESC LIMIT 3;
	
-- Nombre y apellidos de alumnos por año que tuvieron una nota media mayor que la nota media del año
-- Vista con la nota media de cada año
CREATE OR REPLACE VIEW ViewAvgGradesYear AS
	SELECT year, AVG(VALUE) AS average
	FROM ViewSubjectGrades
	GROUP BY year;
	
SELECT firstName, surname, year, AVG(VALUE) AS studentAverage
	FROM ViewSubjectGrades
	GROUP BY studentId, year
	HAVING (studentAverage > (SELECT average 
								 FROM ViewAvgGradesYear 
								 WHERE ViewAvgGradesYear.year = ViewSubjectGrades.year));
	
-- Nombre de asignaturas que pertenecen a un grado con más de 4 asignaturas
-- Vista con el número de asignaturas de cada grado
CREATE OR REPLACE VIEW ViewDegreeNumSubjects AS
	SELECT Degrees.degreeId, COUNT(*) AS numSubjects
	FROM Subjects JOIN Degrees ON (Subjects.degreeId = Degrees.degreeId)
	GROUP BY degreeId;

SELECT name 
	FROM Subjects
	WHERE (SELECT numSubjects 
			 FROM ViewDegreeNumSubjects
			 WHERE ViewDegreeNumSubjects.degreeId = Subjects.degreeId) > 4;
			 
-- Casa

-- Número de suspensos de cada alumno, dando nombre y apellidos
SELECT firstName, surname, COUNT(*)
	FROM Students JOIN Grades ON (Students.studentId = Grades.studentId)
	WHERE value < 5
	GROUP BY Students.studentId;

-- La tercera página de 3 grupos, ordenados según su año por orden descendente
SELECT *
	FROM Groups
	ORDER BY YEAR DESC
	LIMIT 3 OFFSET 6;
	
-- Un listado de los grupos, añadiendo el acrónimo de la asignatura a la que pertenecen y el nombre del grado.

SELECT Groups.*, acronym, Degrees.name
	FROM Groups
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId)
	JOIN Degrees ON (Subjects.degreeId = Degrees.degreeId);

-- Número de métodos de acceso diferentes de los alumnos de cada grupo, dando el id del grupo.
CREATE OR REPLACE VIEW ViewGroupStudents AS
	SELECT groupId, Students.studentId, accessMethod
	FROM Students
	JOIN ViewGroupsStudents ON (Students.studentId = ViewGroupsStudents.studentId);
	
SELECT groupId, COUNT(DISTINCT accessMethod)
	FROM ViewGroupStudents
	GROUP BY groupId;
	
-- Nota ponderada por créditos de cada alumno, dando nombre y apellidos, del curso 2019 en la primera convocatoria.
-- Pista: midifique la vista subjectGrades añadiendo los atributos que falten. La nota ponderada es igual a la suma de las notas multiplicadas por los creditos de la asignatura, dividida entre la suma de todos los créditos de las asignaturas
CREATE OR REPLACE VIEW ViewSubjectGrades2 AS
	SELECT Students.studentId, Students.firstName, Students.surname,
			 Subjects.subjectId, Subjects.name, Subjects.credits,
			 Grades.value, Grades.gradeCall, 
			 Groups.year
	FROM Students
	JOIN Grades ON (Students.studentId = Grades.studentId)
	JOIN Groups ON (Grades.groupId = Groups.groupId)
	JOIN Subjects ON (Groups.subjectId = Subjects.subjectId);
	
SELECT firstName, surname, SUM(value*credits)/SUM(credits)
	FROM ViewSubjectGrades2
	WHERE year = 2019 AND gradeCall = 1
	GROUP BY studentId;