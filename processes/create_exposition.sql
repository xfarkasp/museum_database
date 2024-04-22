-- create an exhibition called mona lisa
INSERT INTO exposition (name, start_date, end_date, current_state)
VALUES ('Mona Lisa Exhibition', NOW(), NOW() + INTERVAL '100 years', 'Active');

-- add a zone to exhibition
UPDATE room
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name IN ('Salle des États', 'Salle des Caryatides');

-- Update the exemplar entry for "Mona Lisa" to assign it to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name IN ('Mona Lisa', 'Hercules Statue');

UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    JOIN exposition ON room.id_exposition = exposition.id
    WHERE room.name = 'Salle des États'
    AND exposition.name = 'Mona Lisa Exhibition'
)
WHERE name = 'Mona Lisa';

UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    JOIN exposition ON room.id_exposition = exposition.id
    WHERE room.name = 'Salle des Caryatides'
    AND exposition.name = 'Mona Lisa Exhibition'
)
WHERE name = 'Hercules Statue';

-- Update the exemplar entry for "The Statue of David" to assign it to the exhibition
-- This wont work, because the statue is not in the Louvre
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'The Statue of David';

-- put Winged Victory of Samothrace   in to transit to be send to another museum
-- this wont work, because the exemplar is being sent away

-- Insert a transit record and capture its ID
-- Mona Lisa can not be added to the transit, because an exemplar can not be transported when part of exemplar
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
WHERE name = 'Mona Lisa';

-- lets add to transit Winged Victory of Samothrace
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
WHERE name = 'Winged Victory of Samothrace';

-- Now we try to assign the the exemplar to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Mona Lisa Exhibition'
)
WHERE name = 'Winged Victory of Samothrace';

-- try to add exposition to the same room before previous exposition ended
-- this wont work, because only 1 exposition can be active in the same zone/room
-- create a new exposition
INSERT INTO exposition (name, start_date, end_date, current_state)
VALUES ('Another exposition', NOW(), NOW() + INTERVAL '2 days', 'Planed');

-- try to assign room to an exposition, which has a start date during an on-going exposition
UPDATE room
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Another exposition'
)
WHERE name = 'Salle des États';

-- change the exposition start date after the end date of the ongoing exposition
UPDATE exposition
SET start_date = NOW() + INTERVAL '100 years 3 days'
WHERE name = 'Another exposition';

-- the room can now be assigned to that room
UPDATE room
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Another exposition'
)
WHERE name = 'Salle des États';

-- only exemplars which are part of the exhibition at the current time
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
    room r ON r.id = e.id_room
WHERE
    ex.name = 'Mona Lisa Exhibition';

-- when exemplar exposition id is changed, the exemplar id with associated exposition id is saved to
-- exemplar_exposition_history for history tracking
-- lets remove exemplar Mona Lisa and Hercules Statue from Mona Lisa Exhibition do demonstrate history function
UPDATE exemplar
SET id_exposition = null
WHERE name = 'Hercules Statue';

UPDATE exemplar
SET id_exposition = null
WHERE name = 'Mona Lisa';

-- all of the exemplars which were and are the part of the given exposition
SELECT
    exh.id_exemplar AS exemplar_id,
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
    exemplar_exposition_history exh
LEFT JOIN
    exemplar e ON exh.id_exemplar = e.id
LEFT JOIN
    condition_table co ON e.id_condition = co.id
LEFT JOIN
    owner_table o ON e.id_owner = o.id
LEFT JOIN
    category_table c ON e.id_category = c.id
LEFT JOIN
    location_table l ON e.id_location = l.id
LEFT JOIN
    exposition ex ON exh.id_exposition = ex.id
LEFT JOIN
    room r ON r.id = e.id_room
WHERE
    ex.name = 'Mona Lisa Exhibition';

-- show all the room which are the part of Mona Lisa Exhibition with time stamps
SELECT
    exh.id_room AS room_id,
    r.name AS room_name,
    ex.name AS exhibition_name,
    ex.start_date AS exhibition_start_date,
    ex.end_date AS exhibition_end_date
FROM
    room_exposition_history exh
LEFT JOIN
    room r ON exh.id_room = r.id
LEFT JOIN
    location_table l ON r.id_museum = l.id
LEFT JOIN
    exposition ex ON exh.id_exposition = ex.id
WHERE
    ex.name = 'Mona Lisa Exhibition';

-- show all the room which are the part of Mona Lisa Exhibition with time stamps
SELECT
    exh.id_room AS room_id,
    r.name AS room_name,
    ex.name AS exhibition_name,
    ex.start_date AS exhibition_start_date,
    ex.end_date AS exhibition_end_date
FROM
    room_exposition_history exh
LEFT JOIN
    room r ON exh.id_room = r.id
LEFT JOIN
    location_table l ON r.id_museum = l.id
LEFT JOIN
    exposition ex ON exh.id_exposition = ex.id
WHERE
    ex.name = 'Another exposition';
