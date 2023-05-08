IF OBJECT_ID('tempdb.dbo.#Employee', 'U') IS NOT NULL
  DROP TABLE #Employee;

CREATE TABLE #Employee (
    id int NOT NULL PRIMARY KEY,
    [name] varchar(256),
    salary int,
    departmentId int,
);

INSERT INTO #Employee
    VALUES
        (1, 'Joe', 85000, 1),
        (2, 'Henry', 80000, 2),
        (3, 'Sam', 60000, 2),
        (4, 'Max', 90000, 1),
        (5, 'Janet', 69000, 1),
        (6, 'Randy', 85000, 1),
        (7, 'Will', 70000, 1);

IF OBJECT_ID('tempdb.dbo.#Department', 'U') IS NOT NULL
  DROP TABLE #Department;

CREATE TABLE #Department (
    id int NOT NULL PRIMARY KEY,
    [name] varchar(256)
);

INSERT INTO #Department
    VALUES
        (1, 'IT'),
        (2, 'Sales');

WITH CTE AS (
        SELECT D.[name] AS [department], E.[name] AS Employee, E.salary AS Salary,
            DENSE_RANK() OVER (PARTITION BY E.departmentId ORDER BY E.salary DESC) SalaryRank
        FROM #Employee AS E
            JOIN #Department AS D ON D.id = E.departmentId
    )
SELECT CTE.Department, CTE.Employee, CTE.Salary
   FROM CTE
   WHERE SalaryRank < 4
    ORDER BY CTE.department, CTE.salary DESC, CTE.Employee;

