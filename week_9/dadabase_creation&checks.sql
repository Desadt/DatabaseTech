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

SELECT table_name
FROM information_schema.views
WHERE table_schema = 'silver'
ORDER BY table_name;

SELECT * FROM silver.stg_users LIMIT 10;
SELECT * FROM silver.stg_ratings LIMIT 10;
SELECT * FROM silver.stg_movies LIMIT 10;
SELECT * FROM silver.stg_occupations LIMIT 10;
SELECT * FROM silver.stg_age_group LIMIT 10;
SELECT * FROM silver.stg_genres LIMIT 10;
SELECT * FROM silver.stg_genres_movies LIMIT 10;

SELECT 'users' AS tabulka,
    (SELECT COUNT(*) FROM bronze.users) AS bronze,
    (SELECT COUNT(*) FROM silver.stg_users) AS silver
UNION ALL
SELECT 'ratings',
    (SELECT COUNT(*) FROM bronze.ratings),
    (SELECT COUNT(*) FROM silver.stg_ratings)
UNION ALL
SELECT 'movies',
    (SELECT COUNT(*) FROM bronze.movies),
    (SELECT COUNT(*) FROM silver.stg_movies)
UNION ALL
SELECT 'occupations',
    (SELECT COUNT(*) FROM bronze.occupations),
    (SELECT COUNT(*) FROM silver.stg_occupations)
UNION ALL
SELECT 'age_group',
    (SELECT COUNT(*) FROM bronze.age_group),
    (SELECT COUNT(*) FROM silver.stg_age_group)
UNION ALL
SELECT 'genres',
    (SELECT COUNT(*) FROM bronze.genres),
    (SELECT COUNT(*) FROM silver.stg_genres)
UNION ALL
SELECT 'genres_movies',
    (SELECT COUNT(*) FROM bronze.genres_movies),
    (SELECT COUNT(*) FROM silver.stg_genres_movies);
