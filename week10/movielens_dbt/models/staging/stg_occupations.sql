SELECT
    NULLIF(TRIM(id), '')::INT AS occupation_id,
    NULLIF(TRIM(name), '') AS occupation_name
FROM {{ source('bronze', 'occupations') }}