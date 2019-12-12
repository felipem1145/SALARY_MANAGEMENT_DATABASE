CREATE SCHEMA Employee
GO





--EMPLOYEE PROJECT

CREATE TABLE Employee.EmployeeProject

(
	EmployeeId INT IDENTITY(1,1),  
	ProjectId  INT,
	ExpectedFinishDate DATE,
	HoursWorked DECIMAL(4,1),
	ExtraHours DECIMAL(3,1)
);

GO