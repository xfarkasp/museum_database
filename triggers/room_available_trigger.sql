CREATE OR REPLACE FUNCTION check_exposition_validity()
RETURNS TRIGGER AS $$
DECLARE
    previous_exhibition_end TIMESTAMP;
BEGIN
    IF NEW.id_exposition IS NOT NULL THEN
        SELECT end_date INTO previous_exhibition_end
        FROM room r
        JOIN exposition e ON r.id_exposition = e.id
        WHERE r.id = NEW.id AND e.end_date > CURRENT_TIMESTAMP
        ORDER BY e.end_date DESC
        LIMIT 1;

        IF previous_exhibition_end >= (SELECT start_date FROM exposition WHERE id = NEW.id_exposition) THEN
            RAISE EXCEPTION 'Start of new exhibition must be after the end of the previous one in the same room';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_exposition_invalid
BEFORE INSERT OR UPDATE of id_exposition ON  room
FOR EACH ROW
EXECUTE FUNCTION check_exposition_validity();