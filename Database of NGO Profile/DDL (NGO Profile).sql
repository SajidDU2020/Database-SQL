--Name: SAJID MUSHFIK RAHMAN
--TraineeID: 1255604
--BatchID: ESAD-CS/ACSL-M/43/01
CREATE DATABASE NGOProfile
GO
USE NGOProfile
GO
CREATE TABLE Departments			
(
	departmentid INT PRIMARY KEY,
	departmentname NVARCHAR(30) NOT NULL
)
GO

CREATE TABLE Projects				
(
	projectid INT PRIMARY KEY,
	projectname NVARCHAR(40) NOT NULL,
	manager NVARCHAR(40) NOT NULL,
	budget MONEY NOT NULL
)
GO

CREATE TABLE EmployeesList			
(
	employeeid INT PRIMARY KEY,
	employeename NVARCHAR(40) NOT NULL,
	payrate MONEY NOT NULL,
	departmentid INT NOT NULL REFERENCES Departments (departmentid),
	projectid INT NOT NULL REFERENCES Projects (projectid)
)
GO


--Index Creation
CREATE INDEX ixEmpName						
ON EmployeesList (employeename)
GO
EXEC sp_helpindex 'employeename'
GO


--Create VIEW
CREATE VIEW viewNGOProfile
AS
SELECT P.projectid, P.projectname, D.departmentname
FROM Projects P						--Table1
INNER JOIN EmployeesList El			--Table2
	ON P.projectid=El.projectid
INNER JOIN Departments D			--Table3
	ON D.departmentid=El.departmentid
GO

--Insert Stored Procedure(sp)
CREATE PROC sInsertproject @n NVARCHAR(40),		--projectname
						   @m NVARCHAR(40),		--manager
						   @b MONEY,			--Budget
						   @CurrentId INT OUTPUT
AS
DECLARE @id INT
SELECT @id=ISNULL(max(projectid),0)+1 FROM Projects
	BEGIN TRY
		INSERT INTO Projects(projectid,projectname,manager,budget)
		VALUES (@id, @n,@m,@b)
		SET @CurrentId = @id
	END TRY
	BEGIN CATCH
		;
		THROW 50001, 'There is something wrong', 1
	END CATCH
GO

--Update Procedure
CREATE PROC sUpdateproject @n NVARCHAR(40),		--projectname
						   @m NVARCHAR(40),		--manager
						   @b MONEY,			--Budget
						   @CurrentId INT OUTPUT
AS
DECLARE @id INT
SELECT @id=ISNULL(max(projectid),0)+1 FROM Projects

	BEGIN TRY
		UPDATE Projects
		SET projectname= @n, manager= @m, budget=@b
		WHERE projectid=@id
	END TRY

	BEGIN CATCH
		;
		THROW 50001, 'Error Happend', 1
	END CATCH
GO

--Delete Strored Procedure
CREATE PROC sDeleteproject @i INT
AS
DECLARE @id INT
SELECT @id=ISNULL(max(projectid),0)+1 FROM Projects

	BEGIN TRY
		DELETE FROM Projects
		WHERE projectid=@i
	END TRY

	BEGIN CATCH
		;
		THROW 50001, 'Cannot delete the value', 1
	END CATCH
GO

--User Defined Function(UDF)
CREATE FUNCTION fnProjectData (@projectname NVARCHAR(40)) RETURNS TABLE
AS
RETURN
(
	SELECT P.projectid, P.manager, P.projectname, P.budget, D.departmentid, D.departmentname, El.employeeid,El.employeename
	FROM Projects P					--Table1
	INNER JOIN EmployeesList El		--Table2
		ON P.projectid=El.projectid
	INNER JOIN Departments D		--Table3
		ON D.departmentid=El.departmentid
	WHERE P.projectname= @projectname
)
GO


---(UDF)Scalar Function
CREATE FUNCTION fnScalar(@projectid INT ) RETURNS INT
AS
	BEGIN
		DECLARE @n INT 
		SELECT @n = COUNT(*) FROM Projects
		WHERE projectid =@projectid
		RETURN @n
	END
GO
--Create Trigger on Project
CREATE TRIGGER TriProject
ON Projects FOR INSERT
AS
BEGIN
	DECLARE @m NVARCHAR(40)
	SELECT @m = manager FROM inserted
	IF EXISTS (SELECT 1 FROM Projects WHERE manager = @m)
	BEGIN
		ROLLBACK TRANSACTION
		;
		THROW 50001, 'Manager already assigned to another project.', 1
	END
END
GO
