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
WHERE name = 'The Statue of David';

INSERT INTO condition_table (current_condition, description)
VALUES (
    -- Replace these values with the condition details
    'Perfect', -- Current condition
    'Validation after delivery to Louvre from Italy' -- Description
);

INSERT INTO validation_history (id_condition, id_exemplar, date, duration)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'Validation after delivery to Louvre from Italy'),
    (SELECT id FROM exemplar WHERE name = 'The Statue of David'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + (SELECT validation_time FROM exemplar WHERE name = 'The Statue of David')
);


UPDATE transit_table
SET delivery_timestamp = CURRENT_TIMESTAMP - INTERVAL '5 days' -- Change delivery time here
WHERE id = 1;

SELECT *
FROM exemplar
WHERE id_transit = 1;



SELECT *
FROM transit_table;