CREATE OR REPLACE FUNCTION validate_delivery_time()
RETURNS TRIGGER AS $$
DECLARE
    estimated_delivery_time TIMESTAMP;
    transit_location_id INT;
BEGIN
    -- Calculate the estimated delivery time by adding the transit delivery timestamp and exemplar validation time
    SELECT (t.delivery_timestamp + e.validation_time)
    INTO estimated_delivery_time
    FROM transit_table t
    JOIN exemplar e ON t.id = e.id_transit
    WHERE e.id = NEW.id_exemplar;

    -- Check if the estimated delivery time is greater than or equal to the current time
    IF estimated_delivery_time <= CURRENT_TIMESTAMP THEN

        SELECT id_transit INTO transit_location_id
        FROM exemplar
        WHERE id = NEW.id_exemplar;
        -- if time passed, set transit id of exemplar to null and set location to new museum
        UPDATE exemplar SET id_transit = NULL, id_location = transit_location_id WHERE id = NEW.id_exemplar;

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
