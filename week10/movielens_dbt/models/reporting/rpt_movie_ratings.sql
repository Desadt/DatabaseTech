SELECT
    m.movie_id,
    m.title,
    COUNT(*) AS rating_count,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM {{ ref('fact_rating') }} r
JOIN {{ ref('dim_movie') }} m
    ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title