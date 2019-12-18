USE SALARY_MANAGEMENT
GO

DROP DATABASE IF EXISTS SALARY_MANAGEMENT;
GO

CREATE DATABASE SALARY_MANAGEMENT
GO



CREATE SCHEMA Employee
GO

CREATE SCHEMA Company
GO


--EMPLOYEE PROJECT
DROP TABLE Employee.Employee
CREATE TABLE Employee.Employee
(
	EmployeeID INT PRIMARY KEY,
	EmployeeFirstName varchar(30),
	EmployeeLastName varchar(30),

);
GO

SELECT *
FROM Employee.Employee
GO

DROP TABLE Employee.EmployeeRole
CREATE TABLE Employee.EmployeeRole
(
	EmployeeID INT CONSTRAINT FKEmployeeID FOREIGN KEY REFERENCES Employee.Employee(EmployeeID),
	RoleID INT CONSTRAINT FK_RoleID FOREIGN KEY REFERENCES Company.CompanyRoles (RoleID),
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
SELECT * FROM Employee.EmployeeRole

CREATE TABLE Employee.EmployeeProject

(
	EmployeeId INT CONSTRAINT FK_EmployeeId FOREIGN KEY REFERENCES Employee.Employee(EmployeeID),  
	ProjectId  INT CONSTRAINT FK_ProjectId FOREIGN KEY REFERENCES Company.Projects(ProjectID),
	ExpectedFinishDate DATE,
	HoursWorked DECIMAL(4,1),
	ExtraHours DECIMAL(4,1)
);
GO


CREATE TABLE Company.CompanyRoles
(
	RoleID INT PRIMARY KEY,
	Department VARCHAR(50), 
	Position VARCHAR(50),
	ExpectedCTC DECIMAL(12,3)
);
GO



CREATE TABLE Company.Projects
(
	ProjectID INT PRIMARY KEY,
	ProjectName VARCHAR(100),
	ProjectManager VARCHAR(60)
);

GO


