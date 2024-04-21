CREATE OR REPLACE FUNCTION check_exemplar_exposition()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_transit IS NULL THEN
        -- Check if the new exposition is in the same museum's location
        IF EXISTS (
            SELECT 1
            FROM room r
            JOIN location_table l ON r.id_museum = l.id
            JOIN exposition ex ON r.id_exposition = ex.id
            WHERE ex.id = NEW.id_exposition AND l.id != NEW.id_location
        ) THEN
            RAISE EXCEPTION 'Cannot set exemplar to an exposition that is not in this museum!';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER prevent_exemplar_exposition_change
BEFORE UPDATE ON exemplar
FOR EACH ROW
EXECUTE FUNCTION check_exemplar_exposition();