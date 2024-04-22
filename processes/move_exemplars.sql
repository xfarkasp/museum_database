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
    COALESCE(ex.name, 'room has no exposition'),
    loct.location_institute_name,
    COALESCE(rt.name, 'Not yet displayed') AS room_name

FROM exemplar as e
    LEFT JOIN location_table loct on e.id_location = loct.id
    LEFT JOIN room rt on e.id_room = rt.id
    LEFT JOIN exposition ex on e.id_exposition = ex.id;
