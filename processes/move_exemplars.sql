-- move the Mona Lisa to Salle des Caryatides
UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    WHERE room.name = 'Salle des Caryatides'
)
WHERE name = 'Mona Lisa';
-- move the Mona Lisa to  Salle des États
UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    WHERE room.name = 'Salle des États'
)
WHERE name = 'Mona Lisa';

UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    WHERE room.name = 'Salle des Sept-Cheminées'
)
WHERE name = 'Mona Lisa';

-- try to move the Mona Lisa to Sala di Dante which is not located at the Louvre
-- this will fail, because the trigger which checks if room location is the same as the exemplar location
UPDATE exemplar
SET id_room = (
    SELECT room.id
    FROM room
    WHERE room.name = 'Sala di Dante'
)
WHERE name = 'Mona Lisa';

SELECT
    e.name,
    e.validation_time,
    COALESCE(active_exposition.name, 'No active exposition') AS exhibition_name,
    condt.current_condition,
    ot.owner_name,
    cat.category_name,
    loct.location_institute_name,
    COALESCE(rt.name, 'Not yet displayed') AS room_name
FROM
    exemplar AS e
LEFT JOIN
    condition_table AS condt ON e.id_condition = condt.id
LEFT JOIN
    owner_table AS ot ON e.id_owner = ot.id
LEFT JOIN
    category_table AS cat ON e.id_category = cat.id
LEFT JOIN
    location_table AS loct ON e.id_location = loct.id
LEFT JOIN
    room AS rt ON e.id_room = rt.id
LEFT JOIN
    (
        SELECT
            id_room,
            ex.name
        FROM
            room_exposition_history AS reh
        JOIN
            exposition AS ex ON reh.id_exposition = ex.id
        WHERE
            ex.current_state = 'Active'
    ) AS active_exposition ON e.id_room = active_exposition.id_room;
