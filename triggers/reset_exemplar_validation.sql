CREATE OR REPLACE FUNCTION set_exemplar_validation_state()
RETURNS TRIGGER AS $$
DECLARE
    transit_record transit_table%ROWTYPE;
    estimated_delivery_time TIMESTAMP;
BEGIN
    -- Fetch transit record associated with the exemplar
    SELECT *
    INTO transit_record
    FROM transit_table
    WHERE id = NEW.id_transit;

    -- Check if transit record exists and exemplar is in transit
    IF FOUND THEN
        -- Set validation state to 'Not_validated'
        NEW.validation := 'Not_validated';

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_exemplar_validation_state
BEFORE INSERT OR UPDATE ON exemplar
FOR EACH ROW
EXECUTE FUNCTION set_exemplar_validation_state();
