USE master;
GO

DROP DATABASE IF EXISTS SALARY_MANAGEMENT;
GO

CREATE DATABASE SALARY_MANAGEMENT
GO

USE SALARY_MANAGEMENT
GO

CREATE SCHEMA Employee
GO

CREATE SCHEMA Company
GO


--EMPLOYEE PROJECT

CREATE TABLE Employee.Employee
(
	EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeFirstName varchar(30),
	EmployeeLastName varchar(30),

);
GO

DROP TABLE IF EXISTS Company.CompanyRoles
CREATE TABLE Company.CompanyRoles
(
	RoleID INT IDENTITY(1,1) PRIMARY KEY,
	Department VARCHAR(50), 
	Position VARCHAR(50),
	ExpectedCTC DECIMAL(12,3) 
);
GO

--CONSTRAINT
ALTER TABLE Company.CompanyRoles
	ADD CONSTRAINT CHK_ExpectedCTC CHECK(ExpectedCTC>30000 AND ExpectedCTC < 200000)

DROP TABLE IF EXISTS Employee.EmployeeRole
CREATE TABLE Employee.EmployeeRole
(
	EmployeeID INT,
	RoleID INT,
	Salary DECIMAL(15,3), 
	Startdate DATE,
	Finishdate DATE,
	EmployeeSavings DECIMAL(15,4),
	SalaryCTC DECIMAL(15,4),
	PFDeduction DECIMAL(15,4), 
	SalaryIncrement DECIMAL(12,4),
	NetSalary DECIMAL(15,4),
	OtherDeduction DECIMAL(12,4)
	
);
GO

--CONSTRAINTS
ALTER TABLE Employee.EmployeeRole
	ADD CONSTRAINT FKEmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employee.Employee(EmployeeID);
ALTER TABLE Employee.EmployeeRole
	ADD CONSTRAINT FK_RoleID FOREIGN KEY (RoleID) REFERENCES Company.CompanyRoles (RoleID);
ALTER TABLE Employee.EmployeeRole
	ADD CONSTRAINT CHK_Salary CHECK(Salary<=150000 AND Salary >=30000);


CREATE TABLE Company.Projects
(
	ProjectID INT IDENTITY(1,1) PRIMARY KEY,
	ProjectName VARCHAR(100),
	ProjectManager VARCHAR(60)
);

GO

DROP TABLE IF EXISTS Employee.EmployeeProject
CREATE TABLE Employee.EmployeeProject

(
	EmployeeId INT,
	ProjectId  INT,
	ExpectedFinishDate DATE ,
	HoursWorked DECIMAL(4,1),
	ExtraHours DECIMAL(4,1)
);
GO

--CONSTRAINTS

ALTER TABLE Employee.EmployeeProject
	ADD CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeId) REFERENCES Employee.Employee(EmployeeID)
ALTER TABLE Employee.EmployeeProject
	ADD CONSTRAINT FK_ProjectId FOREIGN KEY (ProjectId) REFERENCES Company.Projects(ProjectID)
ALTER TABLE Employee.EmployeeProject
	ADD CONSTRAINT CHK_ExpectedFinishDate CHECK(ExpectedFinishDate > (SYSDATETIME()))
GO








------------------------------------------------VIEWS REPORTS----------------------------------------------------------------

---Projects by position

CREATE VIEW Company.RoleProject
AS
SELECT Company.CompanyRoles.Position, COUNT(Company.Projects.ProjectID) AS TotalProjects
FROM Company.Projects
	JOIN Employee.EmployeeProject
		ON Company.Projects.ProjectID=Employee.EmployeeProject.ProjectId
	JOIN Employee.EmployeeRole
		ON Employee.EmployeeProject.EmployeeId=Employee.EmployeeRole.EmployeeID
	JOIN Company.CompanyRoles
		ON Employee.EmployeeRole.RoleID=Company.CompanyRoles.RoleID
GROUP BY Company.CompanyRoles.Position
GO



---Projects by department


CREATE VIEW Company.DepartmentProject
AS
SELECT Company.CompanyRoles.Department, COUNT(Company.Projects.ProjectID) AS TotalProjects
FROM Company.Projects
	JOIN Employee.EmployeeProject
		ON Company.Projects.ProjectID=Employee.EmployeeProject.ProjectId
	JOIN Employee.EmployeeRole
		ON Employee.EmployeeProject.EmployeeId=Employee.EmployeeRole.EmployeeID
	JOIN Company.CompanyRoles
		ON Employee.EmployeeRole.RoleID=Company.CompanyRoles.RoleID
GROUP BY Company.CompanyRoles.Department
GO

----Salary by deparment

CREATE VIEW Company.DepartmentSalary
AS
SELECT Company.CompanyRoles.Department, SUM(Employee.EmployeeRole.SalaryCTC) AS TotalSalary
FROM Company.CompanyRoles
	JOIN Employee.EmployeeRole
		ON Company.CompanyRoles.RoleID = Employee.EmployeeRole.RoleID
GROUP BY Company.CompanyRoles.Department
GO


-------------------------------------------STORE PROCEDURE----------------------------------------------------------------


----Employee Table

CREATE PROCEDURE Employee.Employee_Insert

	@ID INT,
	@FirstName varchar(40),
	@LastName varchar(40)
AS
	INSERT INTO Employee.Employee(EmployeeFirstName,EmployeeLastName) VALUES (@FirstName,@LastName);
GO

CREATE PROCEDURE Employee.Employee_Update
	
	@ID INT,
	@FirstName varchar(40),
	@LastName varchar(40)
AS
	UPDATE Employee.Employee
	SET @FirstName=EmployeeFirstName,
		@LastName=EmployeeLastName
	WHERE @ID=EmployeeID;
GO

CREATE PROCEDURE Employee.Employee_Delete

	@ID INT
AS
	DELETE Employee.Employee
	WHERE EmployeeID=@ID;
GO 


----Project Table




---Role Table





------------------------------------FUNCTIONS----------------------------------------------------------

-----NUMBER OF PROJECTS TO FINISH BEFORE A EXACT DATE

CREATE FUNCTION Company.ProjectsToFinish

(	
	@ProjectDate DATE = NULL
)
RETURNS INT
WITH RETURNS NULL ON NULL INPUT,
SCHEMABINDING 

AS

	BEGIN

		DECLARE @NumberProjects INT

		SELECT @NumberProjects= COUNT(Employee.EmployeeProject.ProjectId) 
		FROM Employee.EmployeeProject 
		WHERE ExpectedFinishDate < @ProjectDate;

		RETURN @NumberProjects 
	END;
GO



CREATE FUNCTION Employee.PFDeduction

( 
	@ID INT 
)

RETURNS DECIMAL(15,3)
WITH RETURNS NULL ON NULL INPUT,
SCHEMABINDING

AS
	BEGIN 
		DECLARE @PFDeduction DECIMAL(15,3)

		SELECT @PFDeduction = (Employee.EmployeeRole.Salary*0.11)
		FROM Employee.EmployeeRole
		WHERE @ID=Employee.EmployeeRole.EmployeeID;

		RETURN @PFDeduction
	END;
GO

ALTER TABLE Employee.EmployeeRole
	ADD CONSTRAINT CHK_PFDeduction CHECK(PFDeduction <= (Employee.PFDeduction(EmployeeID)))
GO

CREATE FUNCTION Employee.Increment 

( 
	@ID1 INT 
)

RETURNS DECIMAL(15,3)
WITH RETURNS NULL ON NULL INPUT,
SCHEMABINDING

AS
	BEGIN 
		DECLARE @Increment DECIMAL(15,3)

		SELECT @Increment = (Employee.EmployeeRole.Salary*0.0755)
		FROM Employee.EmployeeRole
		WHERE @ID1=Employee.EmployeeRole.EmployeeID;

		RETURN @Increment
	END;
GO

ALTER TABLE Employee.EmployeeRole
	ADD CONSTRAINT CHK_SalaryIncrement CHECK( SalaryIncrement <= (Employee.Increment(EmployeeID)))
GO