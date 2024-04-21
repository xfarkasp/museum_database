-- Create a trigger to insert into the history table before updating exemplar exposition id
CREATE OR REPLACE FUNCTION track_exemplar_exposition_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- If the old and new exposition ids are different, and old id_exposition is not null, insert into the history table
    IF OLD.id_exposition IS NOT NULL AND OLD.id_exposition IS DISTINCT FROM NEW.id_exposition THEN
        INSERT INTO exemplar_exposition_history (id_exemplar, id_exposition)
        VALUES (OLD.id, OLD.id_exposition);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER track_exemplar_exposition_changes_trigger
BEFORE UPDATE OF id_exposition ON exemplar
FOR EACH ROW
EXECUTE FUNCTION track_exemplar_exposition_changes();