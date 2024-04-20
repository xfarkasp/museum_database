-- Trigger to set state to 'Active' when the current time equals the start date
CREATE OR REPLACE FUNCTION set_exposition_active()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.start_date = CURRENT_TIMESTAMP THEN
        NEW.current_state = 'Active';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER exposition_active_trigger
BEFORE INSERT ON exposition
FOR EACH ROW
EXECUTE FUNCTION set_exposition_active();