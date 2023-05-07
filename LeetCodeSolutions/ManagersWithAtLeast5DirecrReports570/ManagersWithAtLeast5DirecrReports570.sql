IF OBJECT_ID('tempdb.dbo.#Employee', 'U') IS NOT NULL
  DROP TABLE #Employee;

CREATE TABLE #Employee (
    id int NOT NULL PRIMARY KEY,
    [name] varchar(256),
    department varchar(256),
    managerId int
);

INSERT INTO #Employee
    VALUES
        (101, 'John', 'A', NULL),
        (102, 'Dan', 'A', 101),
        (103, 'James', 'A', 101),
        (104, 'Amy', 'A', 101),
        (105, 'Anne', 'A', 101),
        (106, 'Ron', 'B', 101);

WITH CTE (managerId) AS (
    SELECT managerId
        FROM #Employee
        GROUP BY managerId
        HAVING COUNT(*) >= 5
)
SELECT E.name
    FROM #Employee AS E
    WHERE E.id IN (SELECT managerId FROM CTE);