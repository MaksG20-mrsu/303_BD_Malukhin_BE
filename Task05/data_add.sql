PRAGMA foreign_keys = ON;

INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES ('Богдан', 'Малухин', 'maluxin_bogdan@example.com', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));
INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES ('Илья', 'Марусин', 'marusin_ilia@example.com', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));
INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES ('Даниил', 'Меньшаков', 'menshakov_daniilv@example.com', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));
INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES ('Михаил', 'Мехонцев', 'mehontcev_mihail@example.com', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));
INSERT INTO users (first_name, last_name, email, gender, register_date, occupation_id)
VALUES ('Сергей', 'Мишакин', 'mishakin_sergei1488@example.com', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));

INSERT INTO movies (title, year) VALUES ('Interstellar', 2014);
INSERT INTO movies (title, year) VALUES ('Pulp Fiction', 1994);
INSERT INTO movies (title, year) VALUES ('Zootopia', 2016);

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m, genres g
WHERE m.title = 'Interstellar' AND m.year = 2014 AND g.name IN ('Sci-Fi', 'Adventure', 'Drama');

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m, genres g
WHERE m.title = 'Pulp Fiction' AND m.year = 1994 AND g.name IN ('Comedy', 'Crime', 'Drama', 'Thriller');

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m, genres g
WHERE m.title = 'Zootopia' AND m.year = 2016 AND g.name IN ('Animation', 'Children', 'Comedy');

INSERT INTO ratings (user_id, movie_id, rating)
VALUES ((SELECT id FROM users WHERE email = 'maluxin_bogdan@example.com'),
        (SELECT id FROM movies WHERE title = 'Interstellar' AND year = 2014), 3);

INSERT INTO ratings (user_id, movie_id, rating)
VALUES ((SELECT id FROM users WHERE email = 'maluxin_bogdan@example.com'),
        (SELECT id FROM movies WHERE title = 'Pulp Fiction' AND year = 1994), 4);

INSERT INTO ratings (user_id, movie_id, rating)
VALUES ((SELECT id FROM users WHERE email = 'maluxin_bogdan@example.com'),
        (SELECT id FROM movies WHERE title = 'Zootopia' AND year = 2016), 5);
