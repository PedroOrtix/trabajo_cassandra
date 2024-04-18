--  Se presentan los datos y tiempos de todos los jugadores para cada nivel del juego en un país específico.
SELECT t.email, t.country, t.idD, t.lowest_time, t.date, t.name, t.userName
FROM (
    SELECT
        w.email,
        w.country,
        d.idD,
        MIN(cd.time) AS lowest_time,
        w.date,
        d.name,
        w.userName,
        ROW_NUMBER() OVER 
			(PARTITION BY w.country, d.idD 
			ORDER BY MIN(cd.time), w.email) 
			AS indx
    FROM WebUser w
    JOIN CompletedDungeons cd ON cd.email = w.email
    JOIN Dungeon d ON cd.idD = d.idD
    GROUP BY w.email, d.idD, w.country, w.date, d.name, w.userName
) AS t
WHERE t.indx <= 5
ORDER BY t.country, t.idD, t.lowest_time, t.email
INTO OUTFILE '/var/lib/mysql-files/hall_of_fame.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';



-- Lista de los tiempos que un jugador ha tomado para completar una mazmorra en particular, 
-- organizados en orden ascendente, desde los más bajos hasta los más altos.
SELECT cd.email, cd.idD, cd.time, cd.date
FROM CompletedDungeons cd
ORDER BY
    cd.email,
    cd.idD,
    cd.time ASC
INTO OUTFILE '/var/lib/mysql-files/user_statistics.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';



-- Clasificacion de las hordas
SELECT W.country, K.idE, W.email, COUNT(*) AS n_kills
FROM Kills K
JOIN WebUser W ON K.email = W.email
GROUP BY K.idE, W.country, W.email
ORDER BY
    W.country ASC,
    K.idE ASC,
    n_kills DESC,
INTO OUTFILE '/var/lib/mysql-files/top_horde.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';
