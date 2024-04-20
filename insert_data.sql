-- location
INSERT INTO location_table (institute, location_institute_name, description, street_address, city,  postal_code, country)
VALUES
    ('Museum', 'Musée du Louvre',
     'The Louvre Museum, or Musée du Louvre, is a renowned museum located in Paris, France. Situated along the banks of the Seine River, it occupies a significant portion of the Louvre Palace.',
     '1 Avenue du Général Lemonier', 'Paris', '75001', 'France'
    ),
    ('Museum', 'Galleria dell Accademia',
     'The Galleria dell Accademia, located in Florence, Italy, is renowned for housing Michelangelo s iconic sculpture, David. With its rich collection of Renaissance art and masterpieces, the museum offers visitors an immersive experience in Italian artistic heritage.',
     'Via Ricasoli, 58/60', 'Firenze', '50129', 'Italy'
    ),
    ('Museum', 'Opera del Duomo Museum',
     'The Opera del Duomo Museum, situated in Florence, Italy, showcases an extensive collection of artworks and sculptures from the Cathedral of Santa Maria del Fiore and other historic monuments of the city.',
     'Piazza del Duomo', 'Firenze', '50122', 'Italy'
    ),
    ('Museum', 'Palazzo Vecchio',
    'Palazzo Vecchio, also known as the Old Palace, is a historic building located in Florence, Italy. It has served as the town hall of Florence since the Middle Ages and is a symbol of the city s political and cultural heritage. With its impressive architecture and rich history, Palazzo Vecchio is a must-visit attraction for tourists and history enthusiasts alike.',
     'P.za della Signoria', 'Firenze', '50122', 'Italy'
    ),
    ('Museum', 'St. Mark’s Museum',
     'The St. Mark s Museum, located in Venice, Italy, is renowned for its collection of historical artifacts, religious art, and treasures associated with St. Mark s Basilica. This museum offers visitors a glimpse into the rich history and cultural significance of Venice, featuring exquisite Byzantine mosaics, ancient manuscripts, and religious relics.',
     'P.za San Marco 328', 'Venezia', '30124', 'Italy'
    );


-- Insert rooms for Musée du Louvre
INSERT INTO room (id_museum, name)
VALUES
    ((SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'), 'Salle des États'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'), 'Salle des Caryatides'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'), 'Salle des Sept-Cheminées');

-- Insert rooms for Galleria dell Accademia
INSERT INTO room (id_museum, name)
VALUES
    ((SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'), 'Sala della Tribuna'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'), 'Sala dei Prigioni'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'), 'Sala dell''Arte Gotica Fiorentina');

-- Insert rooms for Opera del Duomo Museum
INSERT INTO room (id_museum, name)
VALUES
    ((SELECT id FROM location_table WHERE location_institute_name = 'Opera del Duomo Museum'), 'Sala della Maddalena'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Opera del Duomo Museum'), 'Sala della Galleria'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Opera del Duomo Museum'), 'Sala della Pietà');

-- Insert rooms for Palazzo Vecchio
INSERT INTO room (id_museum, name)
VALUES
    ((SELECT id FROM location_table WHERE location_institute_name = 'Palazzo Vecchio'), 'Sala di Dante'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Palazzo Vecchio'), 'Sala dei Gigli'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'Palazzo Vecchio'), 'Sala dei Cinquecento');

-- Insert rooms for St. Mark’s Museum
INSERT INTO room (id_museum, name)
VALUES
    ((SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'), 'Gallery of Byzantine Art'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'), 'Treasury Room'),
    ((SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'), 'Sacristy');

-- Insert conditions
INSERT INTO condition_table (current_condition, description)
VALUES
    ('Perfect', 'The exemplar is in perfect condition.'),
    ('Commendable', 'The exemplar is in commendable condition.'),
    ('Good', 'The exemplar is in good condition.'),
    ('Sufficient', 'The exemplar is in sufficient condition.'),
    ('Insufficient', 'The exemplar is in insufficient condition.');

-- Insert categories
INSERT INTO category_table (category_name, description)
VALUES
    ('Paintings', 'Category for paintings.'),
    ('Sculptures', 'Category for sculptures.'),
    ('Literary Relics', 'Category for ancient artifacts.'),
    ('Renaissance Art', 'Category for Renaissance Art.'),
    ('Historical Artifacts', 'Category for Historical Artifacts.');

-- Insert owners
INSERT INTO owner_table (owner_name, description)
VALUES
    ('Musée du Louvre', 'The Louvre Museum, or Musée du Louvre, is a renowned museum located in Paris, France.'),
    ('Galleria dell Accademia', 'The Galleria dell Accademia, located in Florence, Italy, is renowned for housing Michelangelo’s iconic sculpture, David.'),
    ('Opera del Duomo Museum', 'The Opera del Duomo Museum, situated in Florence, Italy, showcases an extensive collection of artworks and sculptures from the Cathedral of Santa Maria del Fiore and other historic monuments of the city.'),
    ('St. Mark’s Museum', 'The St. Mark’s Museum, located in Venice, Italy, is renowned for its collection of historical artifacts, religious art, and treasures associated with St. Mark’s Basilica.'),
    ('Palazzo Vecchio', 'Palazzo Vecchio, also known as the Vecchio Palace, is a historic building located in Florence, Italy.');


-- Exemplars

-- Exemplars for Musée du Louvre
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
    (SELECT id FROM category_table WHERE category_name = 'Paintings'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
    'Mona Lisa',
    '1 days'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'The exemplar is in good condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
    (SELECT id FROM category_table WHERE category_name = 'Historical Artifacts'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
    'Winged Victory of Samothrace',
    '20 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Musée du Louvre'),
    (SELECT id FROM category_table WHERE category_name = 'Sculptures'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Musée du Louvre'),
    'Hercules Statue',
    '2 hours'::INTERVAL
);

-- Exemplars for Galleria dell'Accademia
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Galleria dell Accademia'),
    (SELECT id FROM category_table WHERE category_name = 'Sculptures'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'),
    'Prisoners (Michelangelo)',
    '16 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'The exemplar is in good condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Galleria dell Accademia'),
    (SELECT id FROM category_table WHERE category_name = 'Renaissance Art'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'),
    'Madonna of the Steps',
    '5 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Galleria dell Accademia'),
    (SELECT id FROM category_table WHERE category_name = 'Sculptures'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Galleria dell Accademia'),
    'The Statue of David',
    '3 days'::INTERVAL
);

-- Insert exemplars for Opera del Duomo Museum
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'The exemplar is in good condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Opera del Duomo Museum'),
    (SELECT id FROM category_table WHERE category_name = 'Sculptures'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Opera del Duomo Museum'),
    'Magdalena Penitent',
    '23 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Sufficient' AND description = 'The exemplar is in sufficient condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Opera del Duomo Museum'),
    (SELECT id FROM category_table WHERE category_name = 'Renaissance Art'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Opera del Duomo Museum'),
    'The Gates of Paradise',
    '10 hours'::INTERVAL
);

-- Insert exemplars for St. Mark’s Museum
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'The exemplar is in good condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'St. Mark’s Museum'),
    (SELECT id FROM category_table WHERE category_name = 'Historical Artifacts'),
    (SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'),
    'Reliquary of the True Cross',
    '16 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'St. Mark’s Museum'),
    (SELECT id FROM category_table WHERE category_name = 'Historical Artifacts'),
    (SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'),
    'Pala d Oro',
    '20 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Good' AND description = 'The exemplar is in good condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'St. Mark’s Museum'),
    (SELECT id FROM category_table WHERE category_name = 'Sculptures'),
    (SELECT id FROM location_table WHERE location_institute_name = 'St. Mark’s Museum'),
    'Horses of Saint Mark',
    '12 hours'::INTERVAL
);

-- Insert exemplar for Palazzo Vecchio
INSERT INTO exemplar (id_condition, id_owner, id_category, id_location, name, validation_time)
VALUES (
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Palazzo Vecchio'),
    (SELECT id FROM category_table WHERE category_name = 'Historical Artifacts'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Palazzo Vecchio'),
    'Dante s Death Mask',
    '6 hours'::INTERVAL
),
(
    (SELECT id FROM condition_table WHERE current_condition = 'Perfect' AND description = 'The exemplar is in perfect condition.'),
    (SELECT id FROM owner_table WHERE owner_name = 'Palazzo Vecchio'),
    (SELECT id FROM category_table WHERE category_name = 'Historical Artifacts'),
    (SELECT id FROM location_table WHERE location_institute_name = 'Palazzo Vecchio'),
    'The Genius of Victory',
    '3 hours'::INTERVAL
);