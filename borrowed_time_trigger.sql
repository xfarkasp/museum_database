CREATE OR REPLACE FUNCTION validate_borrowed_time_before_update()
RETURNS TRIGGER AS $$
DECLARE
    exposition_end_date TIMESTAMP;
BEGIN
    -- Fetch the end date of the new exposition associated with the exemplar
    SELECT end_date INTO exposition_end_date
    FROM exposition
    WHERE id = NEW.id_exposition;

    -- Check if the borrowed time is greater than the exposition end date
    IF NEW.borrowed_until < exposition_end_date THEN
        RAISE EXCEPTION 'Borrowed time exceeds exposition end date';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to validate borrowed time before updating the exposition ID of the exemplar
CREATE TRIGGER validate_borrowed_time_before_update_trigger
BEFORE UPDATE ON exemplar
FOR EACH ROW
EXECUTE FUNCTION validate_borrowed_time_before_update();
