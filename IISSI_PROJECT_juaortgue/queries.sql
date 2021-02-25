/*Vista creada por comodidad*/

SELECT * FROM gradesStudentsView;
CREATE OR REPLACE VIEW gradesStudentsView AS (
	SELECT S.studentId, S.name, S.dni, G.gradeId, G.groupId, G.value, G.gradeCall, G.withHonours 
		FROM Students S JOIN Grades G ON (S.studentId=G.studentId)
);




/*RF-036 Listado de alumnos de una asignaturas por grupos
Como profesor.
Quiero Presentar los grupos de teoría y de prácticas existentes junto con los nombres de los alumnos de cada grupo.
Para poder organizar la impartición de clases.
*/
CREATE OR REPLACE VIEW  studentsGroups AS (
	SELECT S.name as studentName, S.surname AS studentSurname, G.name AS groupName, G.typeActivity, G.academicYear 
		FROM Students S 
			JOIN GroupsStudents GS ON (S.studentId=GS.studentId)
			JOIN Groups G ON (GS.groupId=G.groupId)
);
/*RF-037 Listado de grupos por profesor y asignatura
Como profesor.
Quiero Presentar los grupos de teoría y de prácticas que imparte cada profesor
Para poder organizar el plan de organización docente.
*/
CREATE OR REPLACE VIEW teachersGroupsView AS (
SELECT T.name AS teacherName, T.surname AS teacherSurname, G.name as groupName, G.typeActivity 
	FROM Teachers T 
	JOIN TeachersGroups  TG ON (T.teacherId=TG.teacherId) 
	JOIN Groups G ON (TG.groupId=G.groupId)
	);

/*RF-038 Listado de despachos con más de un profesor
Como director del centro.
Quiero Listado de despachos ocupados por más de un profesor.
Para poder conocer puntos conflictivos en ocupación de despachos.
*/
CREATE OR REPLACE VIEW bussyDispatchsView AS (
	SELECT D.name, COUNT(*) AS numeroProfesores
		FROM Dispatchs D 
		JOIN Teachers T ON (D.dispatchId=T.dispatchId)
		GROUP BY D.dispatchId
		HAVING COUNT(*)>1);

/*RF-039 Listado de tutorías pendientes de cada profesor 
Como profesor.
Quiero Listado de las tutorias que cada profesor tiene pendientes
Para poder organizar el trabajo diario
*/
CREATE OR REPLACE VIEW pendingMeetingsView AS (
	SELECT T.dayWeek, T.startTime, T.endTime, T.teacherId, T.tutoringId, M.meetingId, M.studentId, M.dateMeeting, M.hourMeeting
	FROM Tutorings T JOIN Meetings M ON (T.tutoringId=M.tutoringId)
	WHERE M.dateMeeting>=NOW()
);

