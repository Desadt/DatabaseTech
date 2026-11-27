SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT,
    d::DATE,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(ISODOW FROM d)::INT,
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(WEEK FROM d)::INT,
    TRIM(TO_CHAR(d, 'Month')),
    EXTRACT(QUARTER FROM d)::INT
FROM GENERATE_SERIES(
    (SELECT MIN(rated_at)::DATE
     FROM {{ ref('stg_ratings') }}),
    (SELECT MAX(rated_at)::DATE
     FROM {{ ref('stg_ratings') }}),
    INTERVAL '1 day'
) AS gs(d);