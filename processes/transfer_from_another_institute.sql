-- update the owner of the exemplar
UPDATE exemplar
SET id_owner = (
    SELECT id
    FROM owner_table
    WHERE owner_table.owner_name = 'Galleria dell Accademia'
)
WHERE name = 'Dante s Death Mask';

-- the owner is successfully changed to Galleria dell Accademia if exists
SELECT
    e.name,
    e.validation_time,
    condt.current_condition,
    ot.owner_name,
    cat.category_name,
    loct.location_institute_name
FROM exemplar as e
    LEFT JOIN condition_table condt on e.id_condition = condt.id
    LEFT JOIN owner_table ot on e.id_owner = ot.id
    LEFT JOIN category_table cat on e.id_category = cat.id
    LEFT JOIN location_table loct on e.id_location = loct.id
;

-- Insert a transit record and capture its ID to delivery it to the new owner
WITH inserted_row AS (
    INSERT INTO transit_table (id_location, delivery_timestamp)
    VALUES (
        (SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'),
        CURRENT_TIMESTAMP + INTERVAL '2 days'
    )
    RETURNING id
)
UPDATE exemplar
SET id_transit = (
    SELECT id
    FROM inserted_row
)
WHERE name = 'Dante s Death Mask';

INSERT INTO condition_table (current_condition, description)
VALUES (
    'Good',
    'Validation after transfer from Palazzo Vecchio'
);

-- lets try to add entry to validation History, it wont work, because the estimated delivery and validation time has not passed yet
INSERT INTO validation_history (id_condition, id_exemplar, date, duration)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'Validation after transfer from Palazzo Vecchio'),
    (SELECT id FROM exemplar WHERE name = 'Dante s Death Mask'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + (SELECT validation_time FROM exemplar WHERE name = 'Dante s Death Mask')
);

-- let's change the delivery interval to be a smaller number than value expected delivery + validation time to simulate delivery
UPDATE transit_table
SET delivery_timestamp = CURRENT_TIMESTAMP - INTERVAL '5 days' -- Change delivery time here
WHERE id = 1;

-- lets try to add entry to validation History, it wont work, because the estimated delivery and validation time has not passed yet
INSERT INTO validation_history (id_condition, id_exemplar, date, duration)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'Validation after transfer from Palazzo Vecchio'),
    (SELECT id FROM exemplar WHERE name = 'Dante s Death Mask'),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + (SELECT validation_time FROM exemplar WHERE name = 'Dante s Death Mask')
);

