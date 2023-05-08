IF OBJECT_ID('tempdb.dbo.#Employee', 'U') IS NOT NULL
  DROP TABLE #Employee;

CREATE TABLE #Employee (
    empId int NOT NULL PRIMARY KEY,
    [name] varchar(256),
    supervisor int,
    salary int,
);

INSERT INTO #Employee
    VALUES
        (3, 'Brad', NULL, 4000),
        (1, 'John', 3, 1000),
        (2, 'Dan', 3, 2000),
        (4, 'Thomas', 3, 4000);

IF OBJECT_ID('tempdb.dbo.#Bonus', 'U') IS NOT NULL
  DROP TABLE #Bonus;

CREATE TABLE #Bonus (
    empId int NOT NULL PRIMARY KEY,
    bonus int,
);

INSERT INTO #Bonus
    VALUES
        (2, 500),
        (4, 2000);

SELECT E.name, B.bonus
    FROM #Employee AS E
        LEFT JOIN #Bonus AS B ON B.empId = E.empId
    WHERE ISNULL(B.bonus, 0) < 1000;