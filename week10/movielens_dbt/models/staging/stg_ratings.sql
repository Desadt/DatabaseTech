SELECT
    NULLIF(TRIM(id), '')::INT AS rating_id,
    NULLIF(TRIM(user_id), '')::INT AS user_id,
    NULLIF(TRIM(movie_id), '')::INT AS movie_id,
    NULLIF(TRIM(rating), '')::NUMERIC(4,2) AS rating,
    NULLIF(TRIM(rated_at), '')::TIMESTAMP AS rated_at
FROM {{ source('bronze', 'ratings') }}