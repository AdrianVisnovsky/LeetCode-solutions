IF OBJECT_ID('tempdb.dbo.#Activity', 'U') IS NOT NULL
  DROP TABLE #Activity;

CREATE TABLE #Activity (
    player_id int NOT NULL,
    device_id int,
    event_date date NOT NULL,
    games_played int,
    CONSTRAINT cst PRIMARY KEY (player_id, event_date)
);

INSERT INTO #Activity
    VALUES
        (1, 2, '2016-03-01', 5),
        (1, 2, '2016-03-02', 6),
        (2, 3, '2017-06-25', 1),
        (3, 1, '2016-03-02', 0),
        (3, 4, '2018-07-03', 5),
        (3, 4, '2018-07-04', 5);

-- Solution 1
WITH logged_again_total (player_id, event_date, logged_again) AS (
        SELECT A.player_id, A.event_date,
            CASE
                WHEN DATEDIFF(DAY, A.event_date, LEAD(A.event_date) OVER (PARTITION BY A.player_id ORDER BY A.event_date)) = 1 THEN 1
                ELSE 0
            END AS [logged_again]
            FROM #Activity AS A
    ),
    player_first_login (player_id, event_date) AS (
        SELECT player_id, MIN(event_date)
            FROM logged_again_total
            GROUP BY player_id
    ),
    players_logged_again_after_first_day (player_id, logged_again) AS (
        SELECT PFL.player_id, LA.logged_again
            FROM player_first_login AS PFL
                INNER JOIN logged_again_total AS LA ON LA.player_id = PFL.player_id AND LA.event_date = PFL.event_date
    )
SELECT ROUND((SELECT COUNT(*) FROM players_logged_again_after_first_day WHERE logged_again = 1) / CAST(COUNT(*) AS float), 2) AS [fraction]
    FROM players_logged_again_after_first_day;

-- Solution 2
WITH player_first_login (player_id, event_date) AS (
        SELECT player_id, MIN(event_date)
            FROM #Activity
            GROUP BY player_id
    ),
    number_of_players_logged_again (logged_again_count) AS (
        SELECT COUNT(*) [logged_again_count]
            FROM player_first_login AS PFL
                INNER JOIN #Activity AS A ON A.player_id = PFL.player_id AND A.event_date = DATEADD(DAY, 1, PFL.event_date)
    )
SELECT ROUND(NOPLA.logged_again_count / (SELECT CAST(COUNT(*) AS float) FROM player_first_login), 2) AS [fraction]
    FROM number_of_players_logged_again AS NOPLA;