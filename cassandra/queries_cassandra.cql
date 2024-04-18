-- HALL OF FAME
-- LECTURA
CONSISTENCY QUORUM;
SELECT * FROM hall_of_fame 
WHERE country = 'es_ES' 
LIMIT 5;

-- ESCRITURA
-- es algo inneficiente pero sirve ya que en hall_of_fame no es necesario tener unas unas politicas de consistencia perfecta.
-- primero, extraer el top 5 del hall of fame de un pais y en la dungeon del usuario que acababa de hacer.

SELECT * FROM hall_of_fame WHERE country = 'es_ES' AND dungeon_id=0 LIMIT 5;


-- segundo, ver si el time del usuario es mas bajo que los que ya estan.
            si no, break
            si si, continuamos
-- tercero, insertamos el nuevo valor
-- cuatro, si queremos conservar el top 5 por cada dungeon, deberemos hacer periodicamnete la querie primera para ir haciendo
-- un delete de los usuarios cuyos tiempos sean menores que el top 5.

-- esta logica se puede crear con, por ejemplo, SQLAlchemy en python. no lo vamos hacer porque no es el problema a resolver.


-- USER STATISTICS
-- LECTURA
CONSISTENCY ONE;
SELECT * FROM user_statistics WHERE email = 'abellahector@example.org' AND dungeon_id = 1;

-- ESCRITURA
CONSISTENCY QUORUM;
INSERT INTO user_statistics (dungeon_id, email, time_minute, date)
VALUES (1, 'usuario1@example.com', 30, '2024-04-15 12:00:00');


-- TOP HORDE
-- LECTURA
CONSISTENCY LOCAL_ONE;
SELECT * FROM top_horde 
WHERE country = 'es_ES' 
    AND event_id = 1 
LIMIT 5;


-- ESCRITURA

CONSISTENCY QUORUM;
UPDATE top_horde 
SET n_kills = n_kills + 1 
where country = 'es_ES' 
    AND event_id = 1 
    AND email = 'abellahector@example.org' 
    AND username = 'paula29';