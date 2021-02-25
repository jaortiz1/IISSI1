/*Borrar todas las notas de un alumno dado*/
--indica que el END va a terminar con // para no confundirlo con los; de las sentencias
DELIMITER // 
CREATE OR REPLACE PROCEDURE procDeleteGrades (studentDni CHAR(9))
	BEGIN
		DECLARE id INT;
		SET id = (SELECT studentId FROM Students WHERE dni=studentDni);
		DELETE FROM Grades WHERE studentId=id;
	END //
DELIMITER ;

SELECT * FROM Grades;
--Ejecutar procedimiento:
CALL procDeleteGrades('12345678A');

DELIMITER //
CREATE OR REPLACE PROCEDURE procDeleteData();
	BEGIN
		DELETE FROM Grades;
		DELETE FROM GroupsStudents;
		DELETE FROM Students;
		DELETE FROM Groups;
		DELETE FROM Subjects;
		DELETE FROM Degrees;
	END //
DELIMITER ;

call procDeleteData();
SELECT * FROM Students;


DELIMITER //
CREATE OR REPLACE FUNCTION avgGrade(studentId INT) RETURNS DOUBLE
	BEGIN
		DECLARE avgStudentGrade DOUBLE;
		/*Ponemos Grades.studentId porque el parametro pasado se llama igual*/
		SET avgStudentGrade = (SELECT AVG(value) FROM Grades
									  WHERE Grades.studentId = studentId);
		RETURN avgStudentGrade;
	END //
DELIMITER ; 

SELECT avgGrade(2);


