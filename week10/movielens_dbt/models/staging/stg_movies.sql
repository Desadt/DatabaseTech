SELECT
    NULLIF(TRIM(id), '')::INT AS movie_id,
    NULLIF(TRIM(title), '') AS title,
    NULLIF(TRIM(release_year), '')::INT AS release_year
FROM FROM {{ source('bronze', 'movies') }}