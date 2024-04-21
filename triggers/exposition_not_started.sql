-- Trigger to set state to 'Planed' if the start date is in the future
CREATE OR REPLACE FUNCTION set_exposition_planed()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.start_date > CURRENT_TIMESTAMP THEN
        NEW.current_state := 'Planed';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to activate when a new exposition is inserted or updated
CREATE TRIGGER exposition_planed_trigger
BEFORE INSERT OR UPDATE OF start_date ON exposition
FOR EACH ROW
EXECUTE FUNCTION set_exposition_planed();
