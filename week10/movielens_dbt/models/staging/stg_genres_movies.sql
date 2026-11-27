SELECT
    NULLIF(TRIM(id), '')::INT AS genre_movie_id,
    NULLIF(TRIM(movie_id), '')::INT AS movie_id,
    NULLIF(TRIM(genre_id), '')::INT AS genre_id
FROM {{ source('bronze', 'genres_movies') }}