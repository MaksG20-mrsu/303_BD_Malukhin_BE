#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм (без дубликатов и пар с самим собой). Первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT u1.name AS user1, u2.name AS user2, m.title AS movie
FROM ratings r1
JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id
JOIN users u1 ON u1.id = r1.user_id
JOIN users u2 ON u2.id = r2.user_id
JOIN movies m ON m.id = r1.movie_id
ORDER BY m.title, u1.name, u2.name
LIMIT 100"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей (фильм, пользователь, оценка, дата ГГГГ-ММ-ДД)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH last_rating AS (
    SELECT user_id, movie_id, rating, timestamp,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp DESC) AS rn
    FROM ratings
)
SELECT m.title AS movie, u.name AS user, lr.rating,
       date(lr.timestamp, 'unixepoch') AS review_date
FROM last_rating lr
JOIN users u ON u.id = lr.user_id
JOIN movies m ON m.id = lr.movie_id
WHERE lr.rn = 1
ORDER BY lr.timestamp DESC
LIMIT 10"
echo " "

echo "3. Все фильмы с максимальным и минимальным средним рейтингом, колонка Рекомендуем (Да/Нет), сортировка по году и названию."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH avg_r AS (
    SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating
    FROM movies m
    JOIN ratings r ON r.movie_id = m.id
    GROUP BY m.id, m.title, m.year
)
SELECT title, year, ROUND(avg_rating, 2) AS avg_rating,
       CASE WHEN avg_rating = (SELECT MAX(avg_rating) FROM avg_r) THEN 'Да' ELSE 'Нет' END AS 'Рекомендуем'
FROM avg_r
WHERE avg_rating = (SELECT MAX(avg_rating) FROM avg_r)
   OR avg_rating = (SELECT MIN(avg_rating) FROM avg_r)
ORDER BY year, title"
echo " "

echo "4. Количество оценок и средняя оценка, которую дали фильмам женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) AS ratings_count, ROUND(AVG(r.rating), 2) AS avg_rating
FROM ratings r
JOIN users u ON u.id = r.user_id
WHERE u.gender = 'female'
  AND strftime('%Y', r.timestamp, 'unixepoch') BETWEEN '2010' AND '2012'"
echo " "

echo "5. Список фильмов со средней оценкой и местом в рейтинге, сортировка по году и названию, первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, ROUND(AVG(r.rating), 2) AS avg_rating,
       RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rating_place
FROM movies m
JOIN ratings r ON r.movie_id = m.id
GROUP BY m.id, m.title, m.year
ORDER BY m.year, m.title
LIMIT 20"
echo " "

echo "6. 10 последних зарегистрированных пользователей в формате Фамилия Имя|Дата регистрации."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT substr(name, instr(name, ' ') + 1) || ' ' || substr(name, 1, instr(name, ' ') - 1)
       || '|' || register_date AS user_info
FROM users
ORDER BY register_date DESC, id DESC
LIMIT 10"
echo " "

echo "7. Таблица умножения от 1 до 10 с помощью рекурсивного CTE."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE nums(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
)
SELECT a.n || 'x' || b.n || '=' || (a.n * b.n) AS multiplication
FROM nums a, nums b
ORDER BY a.n, b.n"
echo " "

echo "8. Все жанры фильмов из таблицы movies с помощью рекурсивного CTE."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split(genre, rest) AS (
    SELECT '', genres || '|' FROM movies
    UNION ALL
    SELECT substr(rest, 1, instr(rest, '|') - 1), substr(rest, instr(rest, '|') + 1)
    FROM split
    WHERE rest <> ''
)
SELECT DISTINCT genre
FROM split
WHERE genre <> '' AND genre <> '(no genres listed)'
ORDER BY genre"
echo " "