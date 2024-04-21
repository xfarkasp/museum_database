CREATE OR REPLACE FUNCTION validate_delivery_time()
RETURNS TRIGGER AS $$
DECLARE
    estimated_delivery_time TIMESTAMP;
BEGIN
    -- Calculate the estimated delivery time by adding the transit delivery timestamp and exemplar validation time
    SELECT (t.delivery_timestamp + e.validation_time)
    INTO estimated_delivery_time
    FROM transit_table t
    JOIN exemplar e ON t.id = e.id_transit -- Join on id_transit directly
    WHERE e.id = NEW.id_exemplar; -- Assuming the NEW record has a field named id_exemplar



    -- Check if the estimated delivery time is greater than or equal to the current time
    IF estimated_delivery_time <= CURRENT_TIMESTAMP THEN
        UPDATE exemplar SET id_transit = NULL WHERE id = NEW.id_exemplar;
        RETURN NEW; -- Allow insertion
    ELSE
        RAISE EXCEPTION 'Estimated delivery and Validation time has not passed yet';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to enforce validation of estimated delivery time
CREATE TRIGGER validate_delivery_trigger
BEFORE INSERT ON validation_history
FOR EACH ROW
EXECUTE FUNCTION validate_delivery_time();
