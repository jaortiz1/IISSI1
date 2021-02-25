/*RN-001 Limitación créditos docentes
Como director del Centro.
Quiero que se cumpla la siguiente regla de negocio: garantizar que un profesor no imparte más de 24 créditos por curso académico.
Para poder cumplir las disposiciones legales correspondientes.
*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerMaxCreditsTeacherInsert
	BEFORE INSERT ON TeachersGroups
	FOR EACH ROW
	BEGIN
		DECLARE totalCredits INT;
		
		SET totalCredits = (SELECT SUM(credits) 	
									FROM TeachersGroups TG 
									JOIN Groups G ON (TG.groupId=G.groupId) 
									where (G.academicYear=YEAR(NOW()) OR G.academicYear=YEAR(NOW())-1) AND TG.teacherId=new.teacherID);
		SET totalCredits = totalCredits + new.credits;
		IF (totalCredits>24) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'RN-01 You cannot insert a teacher with more than 24 credits per curse';
		END IF;
		
	END//
DELIMITER ; 

DELIMITER //
CREATE OR REPLACE TRIGGER triggerMaxCreditsTeacherUpdate
	BEFORE UPDATE ON TeachersGroups
	FOR EACH ROW
	BEGIN
		DECLARE totalCredits INT;
		
		SET totalCredits = (SELECT SUM(credits) 	
									FROM TeachersGroups TG 
									JOIN Groups G ON (TG.groupId=G.groupId) 
									where (G.academicYear=YEAR(NOW()) OR G.academicYear=YEAR(NOW())-1) AND TG.teacherId=old.teacherID);
		SET totalCredits = totalCredits + new.credits;
		IF (totalCredits>24) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'RN-01 You cannot insert a teacher with more than 24 credits per curse';
		END IF;
		
	END//
DELIMITER ; 


/*RN-006 Matrícula de honor
Como director del centro
Quiero que se cumpla la siguiente regla de negocio: para que una nota sea matrícula de honor es necesario que su valor sea igual o superior a 9.
Para poder cumplir la normativa de la propia universidad.
*/
/*INSERT*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerWithHonours
	BEFORE INSERT ON Grades
	FOR EACH ROW
	BEGIN
		IF (new.withHonours = 1 AND new.value < 9.0 ) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'You cannot insert a grade with honours whose value is less than 9';
		END IF;
	END//
DELIMITER ;
/*UPDATE*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerWithHonours
	BEFORE UPDATE ON Grades
	FOR EACH ROW
	BEGIN
		IF (new.withHonours = 1 AND new.value < 9.0 ) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'You cannot insert a grade with honours whose value is less than 9';
		END IF;
	END//
DELIMITER ;

/*RN-007 Nota por alumno
Como director del Centro
Quiero que se cumpla la siguiente regla de negocio: un alumno no puede tener 
más de una nota para la misma asignatura, convocatoria y año académico.
Para poder cumplir la normativa de la propia universidad.
*/
/*trigger sobre inserccion*/
/*se mirara mediante groups que el */

DELIMITER //
CREATE OR REPLACE TRIGGER triggerRN007Insert
	BEFORE INSERT ON Grades
	FOR EACH ROW
	BEGIN
	/*declaraciones*/
		
		DECLARE thisSubjectId VARCHAR(64);
		DECLARE ANYO INT;
		DECLARE COMPROBACION INT;
		/*seteos*/
		
		
		SET thisSubjectId = (SELECT subjectId FROM Groups where Groups.groupId = new.groupId);
		SET anyo = (SELECT G.academicYear FROM Groups G where G.groupId = new.groupId);
		
		/*conseguir convocatoria nueva y antigua*/
		SET COMPROBACION = (
								SELECT COUNT(*)
									FROM Grades G
									JOIN Groups GS ON (G.groupId=GS.groupId) 
									WHERE G.studentId=new.studentId AND
									academicYear = ANYO AND
									subjectId = thisSubjectId AND
									gradeCall=new.gradeCall
								);
		IF (COMPROBACION>0) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'You cannot insert a grade with the same gradecall and academicyear and userid';
		END IF;
	END//
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER triggerRN007Update
	BEFORE UPDATE ON Grades
	FOR EACH ROW
	BEGIN
	/*declaraciones*/
		
		DECLARE thisSubjectId VARCHAR(64);
		DECLARE ANYO INT;
		DECLARE COMPROBACION INT;
		/*seteos*/
		
		
		SET thisSubjectId = (SELECT subjectId FROM Groups where Groups.groupId = new.groupId);
		SET anyo = (SELECT G.academicYear FROM Groups G where G.groupId = new.groupId);
		
		/*conseguir convocatoria nueva y antigua*/
		SET COMPROBACION = (
								SELECT COUNT(*)
									FROM Grades G
									JOIN Groups GS ON (G.groupId=GS.groupId) 
									WHERE G.studentId=new.studentId AND
									academicYear = ANYO AND
									subjectId = thisSubjectId AND
									gradeCall=new.gradeCall
								);
		IF (COMPROBACION>0) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'You cannot insert a grade with the same gradecall and academicyear and userid';
		END IF;
	END//
DELIMITER ;
/*RN-010 Cambios bruscos en notas
Como director del centro
Quiero que se cumpla la siguiente regla de negocio: una nota no puede alterarse de una vez en más de 4 puntos (aumentada o disminuida).
Para evitar cambios bruscos accidentales en las notas.
*/
DELIMITER //
CREATE OR REPLACE TRIGGER changeGrade
	BEFORE UPDATE ON Grades
	FOR EACH ROW
	BEGIN
	/*declaraciones*/
		DECLARE MINIMO INT;
		DECLARE MAXIMO INT;
		SET MINIMO = old.value-4;
		SET MAXIMO = old.value+4;
		IF(new.value>=MAXIMO OR new.value <=MINIMO) THEN
			SIGNAL SQLSTATE '45000' SET message_text = 
			'RN-010 You cannot change a value of degree 0,4 points in at the same moment.';
		END IF;
	END//
DELIMITER ;


/*RN-019 Pertenencia de alumnos a grupos
Como director del centro
Quiero que se cumpla la siguiente regla de negocio: un alumno no puede pertenecer a más de un grupo de teoría y a más de un grupo de prácticas de cada asignatura.
Para evitar duplicidad en las listas de clases.
*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerSameGroupAndSubject
	BEFORE INSERT ON GroupsStudents
	FOR EACH ROW
	BEGIN
	/*declaraciones*/
	DECLARE numTeoria INT;
	DECLARE numLab INT;
	DECLARE thisSubjectId INT;
	SET thisSubjectId = (SELECT DISTINCT (subjectId)
									FROM GroupsStudents GS 
									JOIN Groups G ON (GS.groupId=G.groupId) 
									WHERE  G.typeActivity = 'Teoría' AND G.groupId = new.groupId);
	SET numTeoria = (SELECT COUNT(*)
									FROM GroupsStudents GS 
									JOIN Groups G ON (GS.groupId=G.groupId) WHERE  G.typeActivity = 'Teoría' AND G.subjectId=thisSubjectId AND studentId=new.studentId);
	
	IF(numTeoria>0) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
			'RN-019 You cannot add a student to two groups of the same type in the same subject.';
	END IF;
	END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER triggerSameGroupAndSubject
	BEFORE UPDATE ON GroupsStudents
	FOR EACH ROW
	BEGIN
	/*declaraciones*/
	DECLARE numTeoria INT;
	DECLARE numLab INT;
	DECLARE thisSubjectId INT;
	SET thisSubjectId = (SELECT DISTINCT (subjectId)
									FROM GroupsStudents GS 
									JOIN Groups G ON (GS.groupId=G.groupId) 
									WHERE  G.typeActivity = 'Teoría' AND G.groupId = new.groupId);
	SET numTeoria = (SELECT COUNT(*)
									FROM GroupsStudents GS 
									JOIN Groups G ON (GS.groupId=G.groupId) WHERE  G.typeActivity = 'Teoría' AND G.subjectId=thisSubjectId AND studentId=new.studentId);
	SET numLab = (SELECT COUNT(*)
									FROM GroupsStudents GS 
									JOIN Groups G ON (GS.groupId=G.groupId) WHERE  G.typeActivity = 'Laboratorio' AND G.subjectId=thisSubjectId AND studentId=new.studentId);
	
	IF(numTeoria>0 || numLab>0) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 
			'RN-019 You cannot add a student to two groups of the same type in the same subject.';
	END IF;
	END//
DELIMITER ;

/*RN-020 Profesor de teoría y prácticas
Como director del departamento
Quiero que se cumpla la siguiente regla de negocio: 
cuando en una asignatura haya grupos de prácticas, el profesor del grupo de teoría, debe impartir alguno de los grupos de prácticas.
Para poder cumplir el reglamento interno del departamento sobre organización docente.

*/
/*si en una asignatura hay grupos de practicas:
		Y si el el grupo al que va a introducir es de teoria
				Entonces: error, primero debe dar clase en un grupo de practicas
		*/
		/*de teachersGroup-groups-subjects*/
DELIMITER //
CREATE OR REPLACE TRIGGER triggerTeacherIsInTheoryGroup
	BEFORE INSERT ON TeachersGroups
	FOR EACH ROW
	BEGIN
		DECLARE tieneLab INT;
		DECLARE thisSubject INT;
		DECLARE grupoTeoria INT;
		DECLARE daTeoria INT;
		SET thisSubject = (SELECT S.subjectId
								FROM Groups G 
								JOIN Subjects S ON (G.subjectId=S.subjectId)
								WHERE G.groupId = new.groupId);
		SET tieneLab = (SELECT COUNT(DISTINCT(G.typeActivity))
								FROM Groups G 
								JOIN Subjects S ON (G.subjectId=S.subjectId)
								WHERE S.subjectId=thisSubject AND G.typeActivity='Laboratorio');
		IF(tieneLab!=0) THEN
		/*significa que tiene grupos de laboratorio*/
			SET grupoTeoria = (SELECT COUNT(S.subjectId)
										FROM Groups G 
										JOIN Subjects S ON (G.subjectId=S.subjectId)
										WHERE G.groupId = new.groupId AND G.typeActivity='Teoría');
			IF(grupoTeoria!=0) THEN
			/*SI EL GRUPO AL QUE SE QUIERE UNIR EL PROFESOR ES DE TEORIA*/
				SET daTeoria = (SELECT COUNT(*)
										FROM TeachersGroups TG 
										JOIN Teachers T ON(TG.teacherId=T.teacherId) 
										JOIN Groups G ON (TG.groupId=G.groupId)
										WHERE G.subjectId = thisSubject AND G.typeActivity='Teoria' 
										AND T.teacherId=new.teacherId);
				IF(daTeoria<0) THEN
					SIGNAL SQLSTATE '45000' SET message_text = 
					'RN-020 Add first to the teacher a laboratory group in this subject.';
				END IF;
			END IF;
		END IF;
	END//
DELIMITER ;
