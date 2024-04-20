-- Drop tables if they exist
DROP TABLE IF EXISTS exposition_history CASCADE;
DROP TABLE IF EXISTS exemplar CASCADE;
DROP TABLE IF EXISTS transit_table CASCADE;
DROP TABLE IF EXISTS location_table CASCADE;
DROP TABLE IF EXISTS exposition CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS category_table CASCADE;
DROP TABLE IF EXISTS owner_table CASCADE;
DROP TABLE IF EXISTS condition_table CASCADE;
DROP TABLE IF EXISTS validation_history CASCADE;
DROP TABLE IF EXISTS lent_table CASCADE;

-- Create tables
CREATE TABLE condition_table (
    id serial NOT NULL PRIMARY KEY,
    current_condition condition NOT NULL CHECK (current_condition IN ('Perfect', 'Commendable', 'Good', 'Sufficient', 'Insufficient')),
    description TEXT NOT NULL
);

CREATE TABLE owner_table (
    id serial NOT NULL PRIMARY KEY,
    owner_name varchar(256) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE category_table (
    id serial NOT NULL PRIMARY KEY,
    category_name varchar(128) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE location_table (
    id serial NOT NULL PRIMARY KEY,
    institute institute_type NOT NULL CHECK (institute IN ('Museum', 'Store', 'Collection')),
    location_institute_name varchar(256) NOT NULL UNIQUE,
    description TEXT,
    street_address VARCHAR(256) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL
);

CREATE TABLE transit_table (
    id serial NOT NULL PRIMARY KEY,
    id_location INT NOT NULL REFERENCES location_table(id),
    delivery_timestamp TIMESTAMP NOT NULL
);

CREATE TABLE exposition (
    id serial NOT NULL PRIMARY KEY,
    name varchar(256) NOT NULL UNIQUE,
    start_date TIMESTAMP NOT NULL CHECK (start_date >= CURRENT_TIMESTAMP),
    end_date TIMESTAMP NOT NULL CHECK (end_date > CURRENT_TIMESTAMP),
    current_state state NOT NULL
);

CREATE TABLE room (
    id serial NOT NULL PRIMARY KEY,
    id_museum INT NOT NULL REFERENCES location_table(id),
    id_exposition INT REFERENCES exposition(id),
    name varchar(256) NOT NULL
);

CREATE TABLE exemplar (
    id serial NOT NULL PRIMARY KEY,
    id_condition INT NOT NULL REFERENCES condition_table(id),
    id_owner INT NOT NULL REFERENCES owner_table(id),
    id_category INT NOT NULL REFERENCES category_table(id),
    id_location INT NOT NULL REFERENCES location_table(id),
    id_transit INT REFERENCES transit_table(id),
    id_exposition INT REFERENCES exposition(id) CHECK (id_transit IS NULL),
    name varchar(256) NOT NULL,
    validation_time INTERVAL NOT NULL,
    borrowed_until TIMESTAMP,
    CONSTRAINT fk_exemplar_condition FOREIGN KEY (id_condition) REFERENCES condition_table(id),
    CONSTRAINT fk_exemplar_owner FOREIGN KEY (id_owner) REFERENCES owner_table(id),
    CONSTRAINT fk_exemplar_category FOREIGN KEY (id_category) REFERENCES category_table(id),
    CONSTRAINT fk_exemplar_location FOREIGN KEY (id_location) REFERENCES location_table(id),
    CONSTRAINT fk_exemplar_transit FOREIGN KEY (id_transit) REFERENCES transit_table(id),
    CONSTRAINT fk_exemplar_exposition FOREIGN KEY (id_exposition) REFERENCES exposition(id),
    CONSTRAINT check_transit_and_exposition CHECK (id_transit IS NULL OR id_exposition IS NULL)
);

CREATE TABLE exposition_history (
    id serial NOT NULL PRIMARY KEY,
    id_exposition INT REFERENCES exposition(id),
    id_exemplar INT REFERENCES exemplar(id),
    CONSTRAINT check_exposition_exemplar CHECK (
        (id_exposition IS NOT NULL AND id_exemplar IS NULL) OR
        (id_exposition IS NULL AND id_exemplar IS NOT NULL)
    )
);

CREATE TABLE validation_history (
    id serial NOT NULL PRIMARY KEY,
    id_condition INT REFERENCES condition_table(id),
    date TIMESTAMP NOT NULL,
    duration TIMESTAMP NOT NULL
);

CREATE TABLE lent_table (
    id serial NOT NULL PRIMARY KEY,
    id_museum INT REFERENCES location_table(id)
);
