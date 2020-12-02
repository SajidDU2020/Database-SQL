USE NGOProfile
GO
INSERT INTO Departments VALUES  (1, 'Humanitarian/GBV'), 
								(2, 'FirstAid'), 
								(3, 'WASH'), 
								(4, 'Supply Chain Management'),
								(5, 'Maternal Health'),
								(6, 'Social Work')
GO
INSERT INTO Projects
VALUES
(1, 'Education For All', 'Maliha Binte Mohiuddin', 900000.00),
(2, 'Turn It Down', 'Khalid Hasan', 650000.00),
(3, 'Food Safety', 'Syed Tajbiha Rony', 900000.00),
(4, 'Stop Harrassment', 'Saima Kaniz', 800000.00),
(5, 'Happy Family', 'Kamruzzaman', 560000.00)
GO
INSERT INTO EmployeesList
VALUES
(1, 'Foysal', 25000.00, 3, 1),
(2, 'Delowar Hossain', 20000.00, 6, 1),
(3, 'Mahbub Islam', 16000.00, 5, 1),
(4, 'Salehin', 18000.00, 4, 3),
(5, 'Emamul Islam', 12000.00, 1, 2),
(6, 'Humayun Kabir', 15000.00, 6, 4),
(7, 'Afroza Ruma', 22000.00, 6, 5),
(8, 'Talha Rahman', 22000.00, 2, 2),
(9, 'Kaniz Sultana', 27000.00, 6, 3),
(10, 'Rashed Rahman', 30000.00, 5, 4),
(11, 'Bishal Hasan', 21000.00, 1, 4),
(12, 'Sumon Murmu', 12000.00, 6, 5),
(13, 'Mushfiqur Rahman', 32000.00, 3, 5),
(14, 'Farzana Sumi', 22000.00, 5, 5),
(15, 'Dipok Kumar Roy', 13000.00, 4, 5)
GO

--To See the Table data
SELECT * FROM EmployeesList
SELECT * FROM Projects
SELECT * FROM Departments
GO
--JOIN query to see all table
SELECT P.projectid, P.manager, P.projectname, P.budget, D.departmentid, D.departmentname, El.employeeid,El.employeename
FROM Projects P						--Table1
INNER JOIN EmployeesList El			--Table2
	ON P.projectid=El.projectid
INNER JOIN Departments D			--Table3
	ON D.departmentid=El.departmentid
GO
--Filtered query
SELECT P.projectid, P.projectname, D.departmentname
FROM Projects P						--Table1
INNER JOIN EmployeesList El			--Table2
	ON P.projectid=El.projectid
INNER JOIN Departments D			--Table3
	ON D.departmentid=El.departmentid
WHERE D.departmentname = 'Social Work'
GO
--SubQuery
SELECT P.projectname, (SELECT COUNT(*) FROM EmployeesList El WHERE El.projectid= P.projectid) 'Number of Employees'
FROM Projects P
GO
--CTE
WITH cte
AS
(
	SELECT COUNT(*) 'count', projectid FROM EmployeesList
	GROUP BY projectid
)
SELECT P.projectname, ct.count 'No. of employee'
FROM Projects P
INNER JOIN cte ct
	ON P.projectid = ct.projectid
GO
--Test view
SELECT * FROM viewNGOProfile
GO
--Test func
SELECT * FROM fnProjectData ('Education For All')
GO
--Test scalar 
SELECT dbo.fnScalar(1)
GO
--Test trigger
INSERT INTO Projects
VALUES
(11, 'Women Empowerment', 'Maliha Binte Mohiuddin', 900000.00)
--Manger in another project 