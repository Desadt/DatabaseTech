-- Active: 1790168926319@@127.0.0.1@5432@movielens_elt
CREATE DATABASE movielens_elt; -- vykonajte samostatne mimo skriptu

SELECT * FROM bronze.users LIMIT 10;

SELECT 'users' AS tabulka, COUNT(*) AS pocet FROM bronze.users
UNION ALL
SELECT 'ratings', COUNT(*) FROM bronze.ratings
UNION ALL
SELECT 'movies', COUNT(*) FROM bronze.movies
UNION ALL
SELECT 'occupations', COUNT(*) FROM bronze.occupations
UNION ALL
SELECT 'age_group', COUNT(*) FROM bronze.age_group
UNION ALL
SELECT 'genres', COUNT(*) FROM bronze.genres
UNION ALL
SELECT 'genres_movies', COUNT(*) FROM bronze.genres_movies;

SELECT * FROM bronze.movies
LIMIT 10;