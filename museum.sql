-- Drop tables if they exist
DROP TABLE IF EXISTS exemplar CASCADE;
DROP TABLE IF EXISTS transit_table CASCADE;
DROP TABLE IF EXISTS location_table CASCADE;
DROP TABLE IF EXISTS exposition CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS category_table CASCADE;
DROP TABLE IF EXISTS owner_table CASCADE;
DROP TABLE IF EXISTS condition_table CASCADE;
DROP TABLE IF EXISTS validation_history CASCADE;
DROP TABLE IF EXISTS exemplar_exposition_history CASCADE;
DROP TABLE IF EXISTS room_exposition_history CASCADE;
DROP TABLE IF EXISTS lent_table CASCADE;

--create type validation_state as enum ('Not_validated', 'Validating', 'Validated');
create type lent_type as enum ('Borrowed', 'Lent');

-- Create tables
CREATE TABLE condition_table (
    id serial NOT NULL PRIMARY KEY,
    current_condition condition NOT NULL CHECK (current_condition IN ('Perfect', 'Commendable', 'Good', 'Sufficient', 'Insufficient')),
    description TEXT NOT NULL UNIQUE
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
    delivery_timestamp TIMESTAMP NOT NULL,
     --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_transit_location FOREIGN KEY (id_location) REFERENCES location_table(id)
);

CREATE TABLE exposition (
    id serial NOT NULL PRIMARY KEY,
    name varchar(256) NOT NULL UNIQUE,
    start_date TIMESTAMP NOT NULL CHECK (start_date >= CURRENT_TIMESTAMP),
    end_date TIMESTAMP NOT NULL CHECK (end_date >= CURRENT_TIMESTAMP),
    current_state state NOT NULL DEFAULT 'Planed'
);

CREATE TABLE room (
    id serial NOT NULL PRIMARY KEY,
    id_museum INT NOT NULL REFERENCES location_table(id),
    id_exposition INT REFERENCES exposition(id),
    name varchar(256) NOT NULL UNIQUE,
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_room_museum FOREIGN KEY (id_museum) REFERENCES location_table(id),
    CONSTRAINT fk_room_exposition FOREIGN KEY (id_exposition) REFERENCES exposition(id)
);


CREATE TABLE exemplar (
    id serial NOT NULL PRIMARY KEY,
    id_condition INT NOT NULL REFERENCES condition_table(id),
    id_owner INT NOT NULL REFERENCES owner_table(id),
    id_category INT NOT NULL REFERENCES category_table(id),
    id_location INT NOT NULL REFERENCES location_table(id),
    id_transit INT REFERENCES transit_table(id),
    id_exposition INT REFERENCES exposition(id),
    id_room INT REFERENCES room(id),
    name varchar(256) NOT NULL,
    validation_time INTERVAL NOT NULL,
    borrowed_until TIMESTAMP,
    validation validation_state NOT NULL DEFAULT 'Validated',
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_exemplar_condition FOREIGN KEY (id_condition) REFERENCES condition_table(id),
    CONSTRAINT fk_exemplar_owner FOREIGN KEY (id_owner) REFERENCES owner_table(id),
    CONSTRAINT fk_exemplar_category FOREIGN KEY (id_category) REFERENCES category_table(id),
    CONSTRAINT fk_exemplar_location FOREIGN KEY (id_location) REFERENCES location_table(id),
    CONSTRAINT fk_exemplar_transit FOREIGN KEY (id_transit) REFERENCES transit_table(id),
    CONSTRAINT fk_exemplar_exposition FOREIGN KEY (id_exposition) REFERENCES exposition(id),
    CONSTRAINT check_transit_and_exposition CHECK (id_transit IS NULL OR id_exposition IS NULL)
);

-- Create a history table to track changes in exemplar-exposition association
CREATE TABLE exemplar_exposition_history (
    id serial PRIMARY KEY,
    id_exemplar INT,
    id_exposition INT NOT NULL ,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- preventing duplicate  entries
    CONSTRAINT unique_exposition_history UNIQUE (id_exemplar, id_exposition),
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_exemplar_history_id_exemplar FOREIGN KEY (id_exemplar) REFERENCES exemplar(id),
    CONSTRAINT fk_exemplar_history_id_exposition FOREIGN KEY (id_exposition) REFERENCES exposition(id)
);

-- Create the room exposition history table
CREATE TABLE room_exposition_history (
    id serial PRIMARY KEY,
    id_room INT,
    id_exposition INT NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- preventing duplicate  entries
    CONSTRAINT unique_room_exposition_history UNIQUE (id_room, id_exposition),
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_room_history_id_room FOREIGN KEY (id_room) REFERENCES room(id),
    CONSTRAINT fk_room_history_id_exposition FOREIGN KEY (id_exposition) REFERENCES exposition(id)
);

CREATE TABLE validation_history (
    id serial NOT NULL PRIMARY KEY,
    id_condition INT REFERENCES condition_table(id),
    id_exemplar INT REFERENCES exemplar(id),
    date TIMESTAMP NOT NULL,
    duration TIMESTAMP NOT NULL,
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_validation_history_condition FOREIGN KEY (id_condition) REFERENCES condition_table(id),
    CONSTRAINT fk_validation_history_exemplar FOREIGN KEY (id_exemplar) REFERENCES exemplar(id)
);

CREATE TABLE lent_table (
    id serial NOT NULL PRIMARY KEY,
    id_museum INT REFERENCES location_table(id),
    id_exemplar INT REFERENCES exemplar(id),
    type lent_type NOT NULL,
    --constraints ensures that the foreign key columns in the exemplar table references valid values from other tables
    CONSTRAINT fk_lent_museum_id FOREIGN KEY (id_museum) REFERENCES location_table(id),
    CONSTRAINT fk_lent_id_exemplar FOREIGN KEY (id_exemplar) REFERENCES exemplar(id),
    -- ensure that uniqueness
    CONSTRAINT unique_lent_entry UNIQUE (id_museum, id_exemplar, type)
);
