-- Create a trigger to insert into the history table before updating room exposition id
CREATE OR REPLACE FUNCTION track_room_exposition_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- If the old and new exposition ids are different, and old id_exposition is not null, insert into the history table
    IF OLD.id_exposition IS NOT NULL AND OLD.id_exposition IS DISTINCT FROM NEW.id_exposition THEN
        INSERT INTO room_exposition_history (id_room, id_exposition)
        VALUES (OLD.id, OLD.id_exposition);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger for room exposition changes
CREATE TRIGGER track_room_exposition_changes_trigger
BEFORE UPDATE OF id_exposition ON room
FOR EACH ROW
EXECUTE FUNCTION track_room_exposition_changes();