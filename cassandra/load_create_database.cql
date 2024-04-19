-- Creamos el schema de la base de datos "Dungeons" con un sistema de replicación SimpleStrategy y un factor de replicación de 2.
CREATE KEYSPACE IF NOT EXISTS Dungeons WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};

USE dungeons;

-- CONSISTENCY ALL; -- Puede ser mas lento pero la consistencia es maxima

-- TABLAS LECTURA

-- Tabla hall_of_fame
CREATE TABLE IF NOT EXISTS hall_of_fame (
    country TEXT,
    dungeon_id INT,
    dungeon_name VARCHAR,
    email TEXT,
    username VARCHAR,
    time_minutes INT,
    date TIMESTAMP, -- es mejor formato
    PRIMARY KEY (country, dungeon_id, time_minutes, email, date)
);

-- Tabla user_statistics
CREATE TABLE IF NOT EXISTS user_statistics (
    dungeon_id INT,
    email TEXT,
    time_minute INT,
    date TIMESTAMP, -- es mejor formato
    PRIMARY KEY (email, dungeon_id, time_minute, date)
) WITH CLUSTERING ORDER BY (dungeon_id ASC, time_minute ASC);

-- Tabla top_horde
CREATE TABLE IF NOT EXISTS top_horde (
    country TEXT,
    event_id INT,
    email TEXT,
    username VARCHAR,
    n_kills COUNTER,
    PRIMARY KEY (country, event_id, email, username)
);


-- Cargamos los datos en las tablas
COPY hall_of_fame (email, country, dungeon_id, time_minutes, date, dungeon_name, username) 
FROM '/csv_folder/hall_of_fame.csv' WITH HEADER = false;

COPY user_statistics (email, dungeon_id, time_minute, date) 
FROM '/csv_folder/user_statictics.csv' WITH HEADER = false;

COPY top_horde (country, event_id, email, n_kills) 
FROM '/csv_folder/top_horde.csv' WITH HEADER = false;