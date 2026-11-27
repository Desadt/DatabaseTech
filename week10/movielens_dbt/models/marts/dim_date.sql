SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_id,
    d::DATE AS rated_at,
    EXTRACT(DAY FROM d)::INT AS day,
    EXTRACT(MONTH FROM d)::INT AS month,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(ISODOW FROM d)::INT AS day_of_week,
    TRIM(TO_CHAR(d, 'Day')) AS day_name,
    EXTRACT(WEEK FROM d)::INT AS week,
    TRIM(TO_CHAR(d, 'Month')) AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter
FROM GENERATE_SERIES(
    (SELECT MIN(rated_at)::DATE
     FROM {{ ref('stg_ratings') }}),
    (SELECT MAX(rated_at)::DATE
     FROM {{ ref('stg_ratings') }}),
    INTERVAL '1 day'
) AS gs(d)