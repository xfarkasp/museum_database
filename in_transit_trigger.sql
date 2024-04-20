CREATE OR REPLACE FUNCTION check_transit_not_null()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_transit IS NOT NULL THEN
        RAISE EXCEPTION 'Exemplar is in transit!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER prevent_transit_not_null
BEFORE UPDATE OF id_exposition ON exemplar -- Specify the column to watch for updates
FOR EACH ROW
EXECUTE FUNCTION check_transit_not_null(); -- Execute the trigger function


