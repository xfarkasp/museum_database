-- Before sending the exemplar to the new location, add it to lent table of current museum and set enum to lent
INSERT INTO lent_table(id_museum, id_exemplar, type)
VALUES (
    (SELECT id FROM location_table WHERE id IN (SELECT id_location FROM exemplar WHERE name = 'The Statue of David')),
    (SELECT id FROM exemplar WHERE name = 'The Statue of David'),
    'Borrowed'
);


-- Set borrowed until timestamp
UPDATE exemplar
SET borrowed_until = CURRENT_TIMESTAMP + INTERVAL '1 days'
WHERE name = 'The Statue of David';

-- Insert a transit record and capture its ID
WITH inserted_row AS (
    INSERT INTO transit_table (id_location, delivery_timestamp)
    VALUES (
        (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
        CURRENT_TIMESTAMP + INTERVAL '2 days'
    )
    RETURNING id
)
-- Assign the transit to the exemplar
UPDATE exemplar
SET id_transit = (
    SELECT id
    FROM inserted_row
)
WHERE name = 'The Statue of David';

-- Create a new validation entry for the exemplar
INSERT INTO condition_table (current_condition, description)
VALUES (
    'Perfect',
    'Validation after delivery to Louvre from Italy'
);

-- Create a new exposition where we will be adding the new exemplar
INSERT INTO exposition (name, start_date, end_date, current_state)
VALUES ('Michelangelo exposition', NOW(), NOW() + INTERVAL '1 years', 'Active');

-- assign a zone for the exemplar
UPDATE room
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Michelangelo exposition'
)
WHERE name IN ('Salle des Sept-Cheminées');

-- Update the exemplar entry for "David" to assign it to the exhibition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Michelangelo exposition'
)
WHERE name IN ('The Statue of David');

-- lets try to add entry to validation History, it wont work, because the estimated delivery and validation time has not passed yet
INSERT INTO validation_history (id_condition, id_exemplar, date, duration)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Validation after delivery to Louvre from Italy'),
    (SELECT id FROM exemplar WHERE name = 'The Statue of David'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + (SELECT validation_time FROM exemplar WHERE name = 'The Statue of David')
);

-- let's change the delivery interval to be a smaller number than value expected delivery + validation time
UPDATE transit_table
SET delivery_timestamp = CURRENT_TIMESTAMP - INTERVAL '5 days' -- Change delivery time here
WHERE id = (SELECT id_transit FROM exemplar WHERE name = 'The Statue of David');

-- lets try again to add same entry to validation History, it will work now, because the estimated delivery and validation time has passed
INSERT INTO validation_history (id_condition, id_exemplar, date, duration)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Validation after delivery to Louvre from Italy'),
    (SELECT id FROM exemplar WHERE name = 'The Statue of David'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + (SELECT validation_time FROM exemplar WHERE name = 'The Statue of David')
);

-- Now we have to add the exemplar to the lent table of the new museum with enu lent
INSERT INTO lent_table(id_museum, id_exemplar, type)
VALUES (
    (SELECT id FROM location_table WHERE id IN (SELECT id_location FROM exemplar WHERE name = 'The Statue of David')),
    (SELECT id FROM exemplar WHERE name = 'The Statue of David'),
    'Lent'
);

-- Lets try to update again the exemplar entry for "David" to assign it to the exhibition
-- this wont work, because the duration of the exposition is longer than the borrowed time of the exposition
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Michelangelo exposition'
)
WHERE name IN ('The Statue of David');

-- Prolong the exemplar borrowed time to fit with the exposition length
UPDATE exemplar
SET borrowed_until = CURRENT_TIMESTAMP + INTERVAL '1years 1 days'
WHERE name = 'The Statue of David';

-- now the addition will work
UPDATE exemplar
SET id_exposition = (
    SELECT id
    FROM exposition
    WHERE name = 'Michelangelo exposition'
)
WHERE name IN ('The Statue of David');


-- show exemplars from Michelangelo exposition
SELECT
    e.id AS exemplar_id,
    e.name AS exemplar_name,
    e.validation_time AS exemplar_validation_time,
    e.borrowed_until as borrowed_until,
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
    ex.name = 'Michelangelo exposition';

-- show lent table
SELECT
    e.name,
    i.location_institute_name,
    e.borrowed_until,
    l.type
FROM lent_table l
JOIN exemplar e ON e.id = l.id_exemplar
JOIN location_table i ON i.id = l.id_museum;