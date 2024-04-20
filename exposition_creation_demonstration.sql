-- location
INSERT INTO location_table (institute, location_institute_name, description, street_address, city,  postal_code, country)
VALUES ('Museum', 'Musée du Louvre', 'Musée du Louvre je múzeum v Paríži. Zaberá veľkú časť paláca Louvre pozdĺž brehu Seiny. Je najnavštevovanejším a patrí k najslávnejším múzeám na svete.', '1 Avenue du Général Lemonier', 'Paris',  '75001', 'France');

-- Insert the room into the room table
INSERT INTO room (id_museum, name)
VALUES (
    (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
    'Salle des États'
);

-- owner creation
INSERT INTO owner_table (owner_name, description)
VALUES ('Musée du Louvre', 'Honosne muzeum v Parizi');

-- condition
INSERT INTO condition_table (current_condition, description)
VALUES ('Perfect', 'Velmi dobre to je');

-- category
INSERT INTO category_table (category_name, description)
VALUES ('Leonardo da Vinci Paintings', 'Paintings created by Leo');

-- create an exemplar
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
        (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Velmi dobre to je'),
        (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
        (SELECT id FROM category_table WHERE category_name = 'Leonardo da Vinci Paintings'),
        (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
        'Mona Lisa',
        '2 hours'::INTERVAL
       );

-- create an exhibition
INSERT INTO exposition (name, start_date, end_date, current_state)
VALUES ('Mona Lisa Exhibition', NOW(), NOW() + INTERVAL '100 years', 'Active');

-- add a zone to exhibition
UPDATE room
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'Salle des États';

-- Update the exemplar entry for "Mona Lisa" to assign it to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'Mona Lisa';

SELECT
    e.id AS exemplar_id,
    e.name AS exemplar_name,
    e.validation_time AS exemplar_validation_time,
    c.category_name,
    co.current_condition,
    o.owner_name,
    l.location_institute_name,
    l.street_address,
    l.city,
    l.postal_code,
    l.country,
    ex.name AS exhibition_name,
    ex.current_state,
    r.name AS room_name,
    ex.start_date AS exhibition_start_date,
    ex.end_date AS exhibition_end_date
FROM
    exemplar e
LEFT JOIN
    condition_table co ON e.id_condition = co.id
LEFT JOIN
    owner_table o ON e.id_owner = o.id
LEFT JOIN
    category_table c ON e.id_category = c.id
LEFT JOIN
    location_table l ON e.id_location = l.id
LEFT JOIN
    exposition ex ON e.id_exposition = ex.id
LEFT JOIN
    room r ON r.id_museum = l.id AND r.id_exposition = ex.id
WHERE
    ex.name = 'Mona Lisa Exhibition';


INSERT INTO location_table (institute, location_institute_name, description, street_address, city,  postal_code, country)
VALUES ('Museum', 'Galleria dell Accademia', 'Muzeum kde maju Davida', 'Via Ricasoli, 58/60', 'Firenze',  '50129', 'Italy');

-- owner creation
INSERT INTO owner_table (owner_name, description)
VALUES ('Galleria dell Accademia', 'Honosne muzeum vo Florencii');

-- condition do do, nedovolit 2x dat ten isty condition
-- INSERT INTO condition_table (current_condition, description)
-- VALUES ('Perfect', 'Velmi dobre to je');

-- category
INSERT INTO category_table (category_name, description)
VALUES ('Michelangelo Buonarroti statues', 'Statues created by Michelangelo Buonarroti');

-- create an exemplar
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
        (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Velmi dobre to je'),
        (SELECT id FROM owner_table WHERE owner_name = 'Galleria dell Accademia'),
        (SELECT id FROM category_table WHERE category_name = 'Michelangelo Buonarroti statues'),
        (SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'),
        'Statue of David',
        '3 days'::INTERVAL
       );


-- Update the exemplar entry for "Statue of David" to assign it to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'Statue of David';

-- create an exemplar
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
        (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Velmi dobre to je'),
        (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
        (SELECT id FROM category_table WHERE category_name = 'Leonardo da Vinci Paintings'),
        (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
        'The Virgin of the Rocks',
        '1 days'::INTERVAL
       );

-- Insert a transit record and capture its ID
WITH inserted_row AS (
    INSERT INTO transit_table (id_location, delivery_timestamp)
    VALUES (
        (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
        CURRENT_TIMESTAMP + INTERVAL '2 days'
    )
    RETURNING id
)
UPDATE exemplar
SET id_transit = (
    SELECT id
    FROM inserted_row
)
WHERE name = 'The Virgin of the Rocks';

-- Update the exemplar entry for "Statue of David" to assign it to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'The Virgin of the Rocks';