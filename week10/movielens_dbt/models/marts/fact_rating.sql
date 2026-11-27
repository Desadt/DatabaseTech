{{ config(
    indexes=[
        {'columns': ['user_id']},
        {'columns': ['movie_id']},
        {'columns': ['date_id']},
        {'columns': ['time_id']}
    ]
) }}

SELECT
    r.rating_id,
    du.user_id,
    dm.movie_id,
    TO_CHAR(r.rated_at, 'YYYYMMDD')::INT AS date_id,
    TO_CHAR(r.rated_at, 'HH24MISS')::INT AS time_id,
    r.rating,
    COUNT(*) OVER (PARTITION BY r.movie_id)::INT AS rating_count,
    (r.rating / 5 * 100)::INT AS rating_percentage
FROM {{ ref('stg_ratings') }} r
JOIN {{ ref('dim_user') }} du ON du.user_id = r.user_id
JOIN {{ ref('dim_movie') }} dm ON dm.movie_id = r.movie_id