/*RF-001. Añadir nota*/

DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pInsertGrade(value INT, gradeCall VARCHAR(64), withHonours BOOLEAN, studentId INT, groupId INT)
BEGIN
	INSERT INTO Grades(value, gradeCall, withHonours, studentId, groupId)
		VALUES (value, gradeCall, withHonours, studentId, groupId);
END //
DELIMITER ;

/*RF-002. Citas de una tutoría*/
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pShowTutoringMeetings(tId INT)
BEGIN
	SELECT * FROM Tutorings T JOIN Meetings M ON (T.tutoringId = M.tutoringId) 
		JOIN  Students S ON (M.studentId= S.studentId)
		WHERE T.teacherId=tId;
END //
DELIMITER ;



/*3 RF-003. Asignación de asignaturas*/
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pAsignTeacherToSubject(tId INT, gId INT)
BEGIN
	DECLARE cred INT;
	SET cred = (SELECT credits FROM GROUPS G JOIN Subjects S on (G.subjectId=S.subjectId) where G.groupId=gId);
	INSERT INTO TeachersGroups (teacherId, groupId, credits) values
	(tId, gId, cred);
END //
DELIMITER ;


/*RF-005 Profesor que imparte más créditos en una asignatura*/
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pTeachingMostCredits(subjId INT)
BEGIN
	DECLARE cred INT;
	SELECT teacherId, COUNT(*) FROM Subjects S 
		JOIN Groups G ON (S.subjectId=G.subjectId)
		JOIN TeachersGroups TG ON (G.groupId=TG.groupId)
		where S.subjectId = subjId
		GROUP BY teacherId
		ORDER BY COUNT(*) DESC
		LIMIT 1;
END //
DELIMITER ;


/*RF-006. Borrar notas de un alumno*/
DELIMITER //
CREATE OR REPLACE PROCEDURE 
	pdeleteStudentGrades(dni VARCHAR(9))
BEGIN
	DECLARE id INT;
	SET id = (SELECT S.studentId FROM Students  S WHERE S.dni LIKE dni);
	DELETE FROM Grades  where studentId=id; 

END //
DELIMITER ;

/*RF-011. Nota media de alumno*/
DELIMITER //
CREATE OR REPLACE FUNCTION 
	fAverageDegree(dni VARCHAR(9)) RETURNS DECIMAL
BEGIN
	DECLARE RESULTADO DECIMAL;
	
	
	SET RESULTADO=	(SELECT AVG(value) AS media
			FROM gradesStudentsView G
			WHERE G.dni=dni
			GROUP BY studentId);
	RETURN RESULTADO;
	

END //
DELIMITER ;