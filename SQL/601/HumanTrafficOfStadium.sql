IF OBJECT_ID('tempdb.dbo.#Stadium', 'U') IS NOT NULL
  DROP TABLE #Stadium;

CREATE TABLE #Stadium (
    id int NOT NULL PRIMARY KEY,
    visit_date date,
    people int
);

INSERT INTO #Stadium
    VALUES
        (1, '2017-01-01', 10),
        (2, '2017-01-02', 109),
        (3, '2017-01-03', 150),
        (4, '2017-01-04', 99),
        (5, '2017-01-05', 145),
        (6, '2017-01-06', 1455),
        (7, '2017-01-07', 199),
        (8, '2017-01-09', 188);

WITH groups (id, visit_date, people, [group]) AS (
    SELECT S.id, S.visit_date, S.people,
            id - ROW_NUMBER() OVER(ORDER BY visit_date) AS [group]
        FROM #Stadium AS S
        WHERE S.people >= 100
    ),
    result_groups ([group]) AS (
        SELECT [group]
            FROM groups
            GROUP BY [group]
            HAVING COUNT(*) >= 3
    )
SELECT G.id, G.visit_date, G.people
    FROM groups AS G
    WHERE G.[group] IN (SELECT RG.[group] FROM result_groups AS RG)