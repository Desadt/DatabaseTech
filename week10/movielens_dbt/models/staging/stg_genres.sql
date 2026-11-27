SELECT
    NULLIF(TRIM(id), '')::INT AS genre_id,
    NULLIF(TRIM(name), '') AS genre_name
FROM {{ source('bronze', 'genres') }}