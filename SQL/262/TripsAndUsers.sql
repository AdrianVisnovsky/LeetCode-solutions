IF OBJECT_ID('tempdb.dbo.#Trips', 'U') IS NOT NULL
  DROP TABLE #Trips;

CREATE TABLE #Trips (
    id int NOT NULL PRIMARY KEY,
    client_id int,
    driver_id int,
    city_id int,
    [status] varchar(256),
    request_at date
);

INSERT INTO #Trips
    VALUES
        (1, 1, 10, 1, 'completed', '2013-10-01'),
        (2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
        (3, 3, 12, 6, 'completed', '2013-10-01'),
        (4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
        (5, 1, 10, 1, 'completed', '2013-10-02'),
        (6, 2, 11, 6, 'completed', '2013-10-02'),
        (7, 3, 12, 6, 'completed', '2013-10-02'),
        (8, 2, 12, 12, 'completed', '2013-10-03'),
        (9, 3, 10, 12, 'completed', '2013-10-03'),
        (10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03'),
        (11, 3, 10, 6, 'cancelled_by_driver', '2013-10-02'),
        (12, 5, 12, 12, 'cancelled_by_client', '2013-10-01'),
        (13, 4, 13, 1, 'cancelled_by_driver', '2013-10-03');

IF OBJECT_ID('tempdb.dbo.#Users', 'U') IS NOT NULL
  DROP TABLE #Users;

CREATE TABLE #Users (
    users_id int NOT NULL PRIMARY KEY,
    banned varchar(8),
    [role] varchar(64)
);

INSERT INTO #Users
    VALUES
        (1, 'No', 'client'),
        (2, 'Yes', 'client'),
        (3, 'No', 'client'),
        (4, 'No', 'client'),
        (5, 'Yes', 'client'),
        (10, 'No', 'driver'),
        (11, 'No', 'driver'),
        (12, 'No', 'driver'),
        (13, 'No', 'driver');

-- Solution 1
WITH valid_trips (id, [status], request_at) AS (
        SELECT T.id, T.[status], T.request_at
            FROM #Trips AS T
                INNER JOIN #Users AS U_CLIENT ON U_CLIENT.users_id = T.client_id AND U_CLIENT.banned = 'No'
                INNER JOIN #Users AS U_DRIVER ON U_DRIVER.users_id = T.driver_id AND U_DRIVER.banned = 'No'
            WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
    ),
    trips_by_status (request_at, [status], [Num]) AS (
        SELECT request_at, [status], COUNT(*) [Num]
            FROM valid_trips
            GROUP BY request_at, [status]
    ),
    trip_dates (request_at) AS (
        SELECT TBS.request_at
            FROM trips_by_status AS TBS
            GROUP BY TBS.request_at
    )
SELECT TD.request_at [Day], ROUND(tCancelledTrips.cancelled_trips / CAST(tTotalTrips.total_trips AS float), 2) AS [Cancellation Rate]
    FROM trip_dates AS TD

        CROSS APPLY (

            SELECT COUNT(*) AS [total_trips]
                FROM valid_trips AS t_TBS
                WHERE t_TBS.request_at = TD.request_at

        ) tTotalTrips

        CROSS APPLY (
            
            SELECT ISNULL(SUM(t_TBS.Num), 0) AS [cancelled_trips]
                FROM trips_by_status AS t_TBS
                WHERE t_TBS.request_at = TD.request_at AND t_TBS.[status] <> 'completed'

        ) tCancelledTrips;

-- Solution 2
SELECT T.request_at AS [Day],
        ROUND(
            SUM(
                CASE
                    WHEN T.[status] <> 'completed' THEN 1
                    ELSE 0
                END
            ) / CAST(COUNT(*) AS float), 2) AS [Cancellation Rate]
    FROM #Trips AS T
        INNER JOIN #Users AS U_CLIENT ON U_CLIENT.users_id = T.client_id AND U_CLIENT.banned = 'No'
        INNER JOIN #Users AS U_DRIVER ON U_DRIVER.users_id = T.driver_id AND U_DRIVER.banned = 'No'
    WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
    GROUP BY T.request_at;
