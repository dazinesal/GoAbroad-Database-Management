IF OBJECT_ID(N'dbo.Review', N'U') IS NOT NULL
Begin 
DROP TABLE Review
END
IF OBJECT_ID(N'dbo.Application', N'U') IS NOT NULL
Begin 
DROP TABLE Application
END
IF OBJECT_ID(N'dbo.Program', N'U') IS NOT NULL
Begin 
DROP Table Program
END
IF OBJECT_ID(N'dbo.ProgramType', N'U') IS NOT NULL
Begin 
DROP TABLE ProgramType
END
IF OBJECT_ID(N'dbo.University', N'U') IS NOT NULL
Begin 
DROP Table University
END
IF OBJECT_ID(N'dbo.StudentAccount', N'U') IS NOT NULL
Begin 
DROP TABLE StudentAccount
END
IF OBJECT_ID(N'dbo.Student', N'U') IS NOT NULL
Begin 
DROP TABLE Student
END
IF OBJECT_ID(N'dbo.Major', N'U') IS NOT NULL
Begin 
DROP TABLE Major
END
IF OBJECT_ID(N'dbo.School', N'U') IS NOT NULL
Begin 
DROP TABLE School
END
IF OBJECT_ID(N'dbo.EmployeeAccount', N'U') IS NOT NULL
Begin 
DROP TABLE EmployeeAccount
END
GO



/*Creating the tables*/

CREATE TABLE EmployeeAccount(
Email varchar(50) NOT NULL PRIMARY KEY,
Password varchar(20) NOT NULL,
SecurityQuest varchar(50),
SecurityAns varchar(50),
);

CREATE TABLE School(
SchoolCode varchar(20) NOT NULL PRIMARY KEY,
SchoolName varchar(500) NOT NULL,
);



CREATE TABLE Major(
MajorCode varchar(10) NOT NULL PRIMARY KEY,
MajorName varchar(500) NOT NULL,
SchoolCode varchar(20) NOT NULL,
FOREIGN KEY (SchoolCode) REFERENCES School (SchoolCode) ON UPDATE CASCADE ON DELETE NO ACTION,
);



CREATE TABLE Student (
StudentID int PRIMARY KEY,
FirstName varchar(20) NOT NULL,
LastName varchar(30) NOT NULL,
GPA decimal(3,2) CHECK (0.0<=GPA AND GPA<=4.0)NOT NULL,
Credits int NOT NULL,
BirthDate date NOT NULL,
BirthPlace varchar(40) NOT NULL,
PassportNumber varchar(20) NOT NULL,
MajorCode varchar(10) NOT NULL,
FOREIGN KEY (MajorCode) REFERENCES Major ON UPDATE CASCADE ON DELETE NO ACTION, 
);

CREATE TABLE StudentAccount(
Email varchar(500) NOT NULL PRIMARY KEY,
Password varchar(50) NOT NULL,
--Password BINARY(64) NOT NULL,
SecurityQuest varchar(50),
SecurityAns varchar(50),
StudentID int,
FOREIGN KEY (StudentID) REFERENCES Student ON UPDATE CASCADE ON DELETE NO ACTION
);



CREATE TABLE University (
UniCode varchar(20) PRIMARY KEY,
Name varchar(40) NOT NULL,
City varchar (40)NOT NULL,
Country varchar(40) NOT NULL,
Description varchar(200),
Website nvarchar(200),
);
CREATE TABLE ProgramType(
TypeCode INTEGER NOT NULL PRIMARY KEY,
Type varchar(30) NOT NULL,
SubType varchar(30),
TuitionDescription varchar(200),
MinGPA decimal (3,2) CHECK (0.0 <= MinGPA AND MinGPA <= 4.0),
MinCredits INTEGER,
MaxCredits INTEGER,
AddReq varchar(200),
);



CREATE TABLE Program (
UniCode varchar(20),
FOREIGN KEY (UniCode) REFERENCES University ON UPDATE CASCADE ON DELETE NO ACTION, 
TypeCode INTEGER NOT NULL,
FOREIGN KEY (TypeCode) REFERENCES ProgramType ON UPDATE CASCADE ON DELETE NO ACTION, 
Semester varchar (10) NOT NULL,
Year INT NOT NULL,
PRIMARY KEY (UniCode,TypeCode,Semester,Year),
StartDate date,
EndDate date,
MinGPA decimal (3,2) CHECK (0.0 <= MinGPA AND MinGPA <= 4.0),
Places INTEGER,
MinCredits INTEGER NOT NULL,
MaxCredits INTEGER NOT NULL,
Majors varchar(200), 
Courses nvarchar(200),
Tuition INTEGER,
AddReq varchar(200),
);



CREATE TABLE Application (
StudentID int,
UniCode varchar(20),
TypeCode INTEGER,
Semester varchar(10),
Year int,
Motivation varchar(200),
Status varchar(20),
CONSTRAINT chk_Status CHECK (Status IN ('Accepted', 'Rejected', 'Pending')),
FOREIGN KEY (StudentID) REFERENCES Student (StudentID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (UniCode,TypeCode,Semester,Year) REFERENCES Program ON UPDATE CASCADE ON DELETE CASCADE,
PRIMARY KEY(StudentID,UniCode,TypeCode,Semester,Year),
);



CREATE TABLE Review (
ReviewCode int identity PRIMARY KEY,
StudentID int,
FOREIGN KEY (StudentID) REFERENCES Student ON UPDATE CASCADE ON DELETE SET NULL,
UniCode varchar(20),
FOREIGN KEY (UniCode) REFERENCES University ON UPDATE CASCADE ON DELETE SET NULL,
Rating int,
Comment varchar(200),
Date date,
Time Time,
);
GO



/*Inserting values into the tables*/

INSERT INTO EmployeeAccount VALUES
('houdaouhmad@gmail.com', 'aui123654789', 'What is your previous status?', 'Project Manager at AUI'),
('oip@aui.ma', 'oip123456789', 'what is your city of origin?', 'Rabat');


INSERT INTO School VALUES 
('SBA', 'School of Business Administration'),
('SSE', 'School of Science and Engineering'),
('SHSS', 'School of Humanities and Social Science');


INSERT INTO Major VALUES 
('CSC','Computer Science', 'SSE'),
('GE','General Engineering','SSE'),
('EMS','Engineering and Management Science','SSE'),
('BA', 'Business Administration', 'SBA'),
('CS', 'Communication Studies', 'SHSS'),
('HRD','Human Resource Development','SHSS'),
('IS','International Studies','SHSS');


INSERT INTO Student VALUES 
(67766,'Salmane','Dazine',3.10,78,'08-07-1998','Casablanca','JC1516309','CSC'),
(67785,'Hanane','Mohaouchane',3.56,75,'06-05-1998','Rabat','BA456730','BA'),
(67723,'Houda','Ouhmad',3.48,100,'02-03-1997','Tanger','CA452210','CS');


INSERT INTO StudentAccount VALUES('salmane00@gmail.com', 'abcd123', 
'What is your phone number?', '0661259845',67766),
('hanane.moh@gmail.com', '789khfd', 'What is your favorite place?', 'AUI',67785),
('houdaouhmad@hotmail.fr', 'azert97', 'What is your previous password?', 'thisone@01',67723);


INSERT INTO University VALUES
(11111,'Hanyang University','Seoul','South Korea',
'One of the well-reputed universities in South Korea. Includes English-taught courses from all majors','http://www.hanyang.ac.kr/web/eng'),
(11112,'Ljubljana University','Ljubljana','Slovenia',
'The oldest and largest university in Slovenia, and among the largest in Europe. Well known for its Economics courses and short term semesters','https://www.uni-lj.si/eng/about_university_of_ljubljana.aspx'),
(11113,'Bogazici University','Istanbul','Turkey',
'First ranked university in Turkey for the past 4 years. Includes Computer Science and Philosophy courses and very interesting electives','http://www.boun.edu.tr/en_US');


INSERT INTO ProgramType VALUES
(1,'Bilateral Exchange', 'Partial Exchange', 'Tuition, fees, and housing (include small kitchens in some institutions) are paid at AUI. Meals, international health insurance and books
are paid to host institution', 2.85,45,90,NULL),
(2,'Bilateral Exchange','Full Exchange',' (Tuition, housing, meals and some fees are paid to AUI)
Students must cover the airline ticket and travel expenses, additional international health
insurance, textbooks,and pocket money',2.85,45,90,NULL),
(3,'Bilateral Exchange','Tuition Only','Tuition only is paid at AUI, 
all other charges are paid to host institution',2.85,45,90,NULL),
(4,'Erasmus','','Tuition paid at AUI. Other fees payed at thehost institution. 
The student will be given a grant depending on the institution',3.0,45,90,NULL),
(5,'Study Abroad','','All fees are payed at the host institution',2.4,45,90,NULL);


INSERT INTO Program VALUES 
(11111,1,'Spring',2018,'2018-01-03','2018-06-21',3.00,5,45, 95,'GenEd, BAIS, BACS, BBA, BSGE, BSHRD, BBA','http://www.hanyangexchange.com/academics/syllabus/',
20000,NULL),
(11111,1,'Summer',2018,'2018-07-01','2018-07-31',3.00, 4, 45, 90,'BSCSC,BSGE, BSEMS,BAIS, BSHRD',
'http://www.hanyangsummer.com/seoul/courses/',
30000,NULL),
(11113,1,'Summer',2018,'2018-06-22','2018-08-02',2.50,2, 45, 85,'BACS, BBA, BSGE, BSHRD, BBA
','http://www.summer.boun.edu.tr/CourseSch.aspx',
20000,NULL);


INSERT INTO Application VALUES
(67766,'11111',1,'Spring',2018,
'I’m applying to this university in view of my interest in the Computer Graphics course offered, and also my intention in visiting on of the most beautiful countries in the world.','Accepted'),
(67766,'11113',1,'Summer',2018,
'I’m applying to this university because I am interested in the Advanced computer science courses they have offered.','Pending'),
(67766,'11111',1,'Summer',2018,
'I’m applying to this university in view of my interest in the Computer Graphics course offered, and also my intention in visiting on of the most beautiful countries in the world.','Pending');


INSERT INTO Review VALUES
(67766,11111,5,'Great Program! Awesome Country!','2018-10-23','10:30:23'),
(67766,11113,3,'The Computer Science courses are hard. Great Experience though!','2018-10-23','10:45:13'),
(67723,11113,1,'I don’t recommend this university at all.','2018-10-24','22:00:05');



/* Updating the rating on review 1' when a student wants to edit his review*/ 

UPDATE Review 
SET Rating = 7 
WHERE ReviewCode = 1;
SELECT* FROM Review



/* Search universities by country */

SELECT * FROM University 
WHERE Country = 'South Korea';
GO
/*View the information of students who applied to Hanyang University*/
IF OBJECT_ID('vwstudent', 'V') IS NOT NULL
    DROP VIEW vwstudent;
	GO
CREATE VIEW vwstudent AS
Select S.* 
FROM Student AS S INNER JOIN Application AS A
ON S.StudentID = A.StudentID
WHERE A.UniCode = (Select UniCode FROM University WHERE Name ='Hanyang University');
GO
SELECT * FROM vwstudent;



/*View of the current applications of a student*/

IF OBJECT_ID ('vwCurrentApplication' , 'V') IS NOT NULL
	DROP VIEW vwCurrentApplication;
	GO
CREATE VIEW vwCurrentApplication AS
SELECT StudentID,A.Unicode,U.Name AS 'University',Semester, Year,A.TypeCode, Type,SubType, Motivation, Status
FROM University U INNER JOIN Application A 
ON U.UniCode = A.Unicode
INNER JOIN ProgramType PT
ON A.TypeCode = PT.TypeCode
WHERE Status='Pending' 
GO



/*View of the past applications of a student*/

IF OBJECT_ID ('vwPastApplication' , 'V') IS NOT NULL
	DROP VIEW vwPastApplication;
	GO
CREATE VIEW vwPastApplication AS
SELECT StudentID,U.Name AS 'University',Semester, Year, Type,SubType, Motivation, Status
FROM University U INNER JOIN Application A 
ON U.UniCode = A.Unicode
INNER JOIN ProgramType PT
ON A.TypeCode = PT.TypeCode
WHERE Status<>'Pending' 
GO
/* Count the number of applications to each university in a given semester */
SELECT UniCode, COUNT (StudentID) AS 'Application Count'
FROM Application
WHERE Semester='Spring'AND Year = 2018
GROUP BY UniCode




/* Indexes */

CREATE INDEX Index_UniversityName on University(Name);
CREATE INDEX Index_ProgramType on ProgramType(Type);
GO




/* Procedures */

-- Search Universities by Name

IF (OBJECT_ID('sp_SearchUniversity') IS NOT NULL)
  DROP PROCEDURE sp_SearchUniversity
GO
CREATE PROCEDURE sp_SearchUniversity @UniName varchar(40)
AS
BEGIN
    SELECT * FROM University WHERE Name = @UniName;
END;
GO
-- Delete an application
IF (OBJECT_ID('sp_DeleteApplication')IS NOT NULL)
	DROP PROCEDURE sp_DeleteApplication
GO

CREATE PROCEDURE sp_DeleteApplication @StudentId int, @UniName varchar(40),
 @TypeName varchar(30),@SubType varchar(30),@Semester varchar(10),@Year int
AS
BEGIN
DECLARE @UniCode int,@TypeCode int;
SET @UniCode = (SELECT UniCode FROM University WHERE Name = @UniName);
SET @TypeCode = (SELECT TypeCode FROM ProgramType WHERE Type= @TypeName AND SubType = @SubType);
DELETE FROM Application WHERE 
UniCode = @UniCode
AND
TypeCode = @TypeCode
AND 
StudentID = @StudentId
AND 
Semester = @Semester
AND
Year = @Year
END
GO



--Login Procedure

IF (OBJECT_ID ('Validate_User') IS NOT NULL)
	DROP PROCEDURE Validate_User
GO
	
CREATE PROCEDURE [dbo].[Validate_User]
      @Username NVARCHAR(20),
      @Password NVARCHAR(20)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @UserId INT;
	  
      SELECT @UserId = StudentID
      FROM StudentAccount WHERE StudentID = @Username AND Password = @Password
     
		IF @UserId IS NOT NULL
			BEGIN
            
			 SELECT @UserId [UserId] -- User Valid
           
			END
		ELSE
			BEGIN
				SELECT -1 -- User invalid.
			END

END;
GO

ALTER TABLE EmployeeAccount
ADD EmployeeID int;
GO

Update EmployeeAccount 
SET EmployeeID = 11234 
WHERE Email = 'oip@aui.ma';  
GO



--Employee Login Procedure

IF (OBJECT_ID ('EmployeeLogin') IS NOT NULL)
	DROP PROCEDURE EmployeeLogin
GO
	
CREATE PROCEDURE [dbo].EmployeeLogin
      @Username NVARCHAR(20),
      @Password NVARCHAR(20)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @UserId INT;
	  
      SELECT @UserId = EmployeeID
      FROM EmployeeAccount WHERE EmployeeID = @Username AND Password = @Password
     
		IF @UserId IS NOT NULL
			BEGIN
            
			 SELECT @UserId [UserId] -- User Valid
           
			END
		ELSE
			BEGIN
				SELECT -1 -- User invalid.
			END

END;
GO



--ADD a review

IF (OBJECT_ID ('sp_AddReview') IS NOT NULL)
	DROP PROCEDURE sp_AddReview 
GO
CREATE PROCEDURE sp_AddReview @StudentID int, @UniName varchar(40),@Rating int, @Comment varchar(200)
AS
BEGIN
	DECLARE @UniCode int, @Date date, @Time time;
	SET @UniCode = (SELECT UniCode FROM University WHERE Name = @UniName);
	SET @Date = (SELECT CONVERT (date, GETDATE()));
	SET @Time = (CONVERT (time, GETDATE()));
	INSERT INTO Review VALUES (@StudentID,@UniCode,@Rating,@Comment,@Date,@Time);
END;
GO

-- Search Programs by Name
IF (OBJECT_ID('sp_SearchProgramType') IS NOT NULL)
  DROP PROCEDURE sp_SearchProgramType
GO
CREATE PROCEDURE sp_SearchProgramType @ProgType varchar(40)
AS
BEGIN
    SELECT * FROM ProgramType WHERE Type = @ProgType;
END;
GO



-- Search Programs

IF (OBJECT_ID('sp_SearchProgram') IS NOT NULL)
  DROP PROCEDURE sp_SearchProgram
GO
CREATE PROCEDURE sp_SearchProgram @UniName varchar(40)
AS
BEGIN
Declare @Unicode varchar(20), @Univ varchar(40);
	SET @UniCode = (SELECT UniCode FROM University WHERE Name = @UniName);
	SET @Univ = (SELECT Name FROM University WHERE UniCode = @Unicode);
    SELECT @Univ, P.UniCode,P.TypeCode, P.Semester, P.year, PT.Type, PT.SubType, P.StartDate, P.EndDate, P.MinGPA, P.Places, P.MinCredits, P.MaxCredits, P.Majors, P.Majors, P.Courses
	, P.Tuition, P.AddReq
	 FROM Program P inner join ProgramType PT on P.TypeCode = PT.TypeCode WHERE Unicode=@Unicode;
END;
GO



-- Delete University

IF (OBJECT_ID('sp_DeleteUniversity') IS NOT NULL)
  DROP PROCEDURE sp_DeleteUniversity
GO
CREATE PROCEDURE sp_DeleteUniversity @ID int
AS
BEGIN
	DELETE FROM University WHERE UniCode = @ID;
END;
GO
/*This procedure inserts both the student and the student account in one statement, it takes as arguemnt the major name instead of the major code*/
IF (OBJECT_ID('spInsertStudentAndAccount') IS NOT NULL)
  DROP PROCEDURE spInsertStudentAndAccount
GO
CREATE PROCEDURE spInsertStudentAndAccount @StudentId int,@FirstName varchar(20),
@LastName varchar(30),@GPA decimal(3,2),@Credits int,@BirthDate date,@BirthPlace varchar(40),
@PasportNumber varchar(20),@MajorName varchar(500),@Email varchar(500),@Password varchar(50)
AS
BEGIN
DECLARE @MajorCode varchar(10)
SET @MajorCode = (Select MajorCode FROM Major WHERE MajorName =@MajorName);
IF EXISTS (Select StudentID FROM Student WHERE StudentID = @StudentId)
  BEGIN
  SELECT -1
  END;
ELSE IF EXISTS (Select Email FROM StudentAccount WHERE Email = @Email)
  BEGIN 
  SELECT -2
  END;
ELSE 
  BEGIN
INSERT INTO Student VALUES (@StudentId,@FirstName,@LastName,@GPA,@Credits,@BirthDate,@BirthPlace,@PasportNumber,@MajorCode);
INSERT INTO StudentAccount VALUES (@Email,@Password,NULL,NULL,@StudentId);
  SELECT 0;
  END;
END;
GO



-- Delete a review

IF (OBJECT_ID('sp_DeleteReview')IS NOT NULL)
	DROP PROCEDURE sp_DeleteReview
GO

CREATE PROCEDURE sp_DeleteReview @ReviewCode int
AS
BEGIN

DELETE FROM Review WHERE 
ReviewCode = @ReviewCode
END
GO




/* Triggers */

/*This trigger makes sure that a student soes not exceed 3 applications 
before inserting a new application. It uses transaction to solve concurrency issues*/

CREATE TRIGGER tri_AddNewApplication ON Application INSTEAD OF INSERT 
AS
BEGIN
DECLARE @app_count int, @studentID int, @UniCode int, @TypeCode int,
@Semester varchar(20),@Year int, @Motivation varchar(500), @Status varchar(30);
DECLARE app_cursor CURSOR FOR
	SELECT StudentID,UniCode,TypeCode,Semester,Year,Motivation,Status FROM inserted;

OPEN app_cursor;
FETCH NEXT FROM app_cursor INTO @studentID,@UniCode,@TypeCode,@Semester,@Year,@Motivation,@Status;
WHILE(@@FETCH_STATUS=0)
BEGIN
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SET @app_count = (SELECT COUNT(*) AS 'ApplicationCOUNT'FROM Application A
					WHERE A.StudentID = @studentID
					AND Semester = @Semester
					AND Year = @Year);
IF @app_count < 3
  BEGIN
  INSERT INTO Application VALUES (@studentID,@UniCode,@TypeCode,@Semester,@Year,@Motivation,@Status);
  END;
COMMIT TRANSACTION;
FETCH NEXT FROM app_cursor INTO @studentID,@UniCode,@TypeCode,@Semester,@Year,@Motivation,@Status;
END;
END;

 


