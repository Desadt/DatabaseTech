SELECT
    r.rating_id,
    r.user_id,
    r.movie_id,
    TO_CHAR(r.rated_at, 'YYYYMMDD')::INT,
    EXTRACT(HOUR FROM r.rated_at)::INT * 10000
        + EXTRACT(MINUTE FROM r.rated_at)::INT * 100
        + FLOOR(EXTRACT(SECOND FROM r.rated_at))::INT,
    r.rating
FROM {{ ref('stg_ratings') }} r
ORDER BY r.rating_id;