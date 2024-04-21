CREATE OR REPLACE FUNCTION set_exemplar_exposition_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_room IS NOT NULL THEN
        -- Fetch the exposition ID of the room
        SELECT id_exposition INTO NEW.id_exposition FROM room WHERE id = NEW.id_room;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_exemplar_exposition_id
BEFORE UPDATE ON exemplar
FOR EACH ROW
EXECUTE FUNCTION set_exemplar_exposition_id();
