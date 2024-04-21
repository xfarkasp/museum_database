-- Trigger to set state to 'Ended' when the current time is larger than the end time
CREATE OR REPLACE FUNCTION set_exposition_ended()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.end_date < CURRENT_TIMESTAMP THEN
        NEW.current_state = 'Ended';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exposition_ended_trigger
BEFORE INSERT OR UPDATE ON exposition
FOR EACH ROW
EXECUTE FUNCTION set_exposition_ended();