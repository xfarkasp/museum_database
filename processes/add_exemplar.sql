-- print all of the exemplars to demonstrate, that the new exemplar is not yet in the DB
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


-- insert a new exemplar to the DB
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
    (SELECT id FROM category_table WHERE category_name = 'Paintings'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
    'The Coronation of Napoleon',
    '1 days'::INTERVAL
);

-- call first query again to demonstrate that the new exemplar has been added