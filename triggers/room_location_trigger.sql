CREATE OR REPLACE FUNCTION check_exemplar_room_museum()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM room r
        JOIN location_table l ON r.id_museum = l.id
        WHERE r.id = NEW.id_room AND l.id != NEW.id_location
    ) THEN
        RAISE EXCEPTION 'Cannot assign room from a different museum to the exemplar!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to enforce the check on room museum before updating exemplar
CREATE TRIGGER prevent_room_museum_mismatch
BEFORE UPDATE OF id_room ON exemplar
FOR EACH ROW
EXECUTE FUNCTION check_exemplar_room_museum();
