INSERT INTO halls (serial_number, seats)
VALUES
    ('HALL001', 150),
    ('HALL002', 200),
    ('HALL003', 120);


INSERT INTO films (age_restrictions, description, title, year)
VALUES (13, 'Thriller about dreams', 'Inception', 2010),
       (18, 'Crime drama', 'The Departed', 2006),
       (0, 'Family adventure', 'The Incredibles', 2004),
       (0, 'Animated classic', 'Toy Story', 1995),
       (13, 'Superhero action', 'The Avengers', 2012);

INSERT INTO sessions (ticket_cost, session_time, film_id, hall_id)
VALUES (10.99, '2024-07-15 18:00:00', 1, 1),
       (12.99, '2024-07-16 20:00:00', 2, 2);
