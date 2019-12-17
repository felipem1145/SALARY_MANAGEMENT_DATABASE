CREATE DATABASE SALARY_MANAGEMENT
GO
USE SALARY_MANAGEMENT
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

CREATE TABLE Employee.EmployeeRole
(
	EmployeeID INT,
	RoleID INT,
	Salary DECIMAL(8,3), 
	Startdate DATE,
	Finishdate DATE,
	EmployeeSavings DECIMAL(12,4),
	SalaryCTC DECIMAL(8,4),
	PFDeduction DECIMAL(8,4),
	SalaryIncrement DECIMAL(5,4),
	NetSalary DECIMAL(8,4),
	OtherDeduction DECIMAL(5,4)
	
);
GO

CREATE TABLE Employee.EmployeeProject

(
	EmployeeId INT IDENTITY(1,1),  
	ProjectId  INT,
	ExpectedFinishDate DATE,
	HoursWorked DECIMAL(4,1),
	ExtraHours DECIMAL(3,1)
);
GO

CREATE TABLE Company.CompanyRoles
(
	RoleID INT PRIMARY KEY,
	Department VARCHAR(30),
	Position VARCHAR(30),
	ExpectedCTC DECIMAL(8,3)
);
GO

CREATE TABLE Company.Projects
(
	ProjectID INT PRIMARY KEY,
	ProjectName VARCHAR(40),
	ProjectManager VARCHAR(60)
);
GO

