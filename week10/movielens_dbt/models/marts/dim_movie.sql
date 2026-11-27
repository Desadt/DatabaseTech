SELECT
    m.movie_id,
    m.title,
    m.release_year,
    STRING_AGG(
        DISTINCT g.genre_name,
        ', ' ORDER BY g.genre_name
    ) AS genres
FROM {{ ref('stg_movies') }} m
LEFT JOIN {{ ref('stg_genres_movies') }} gm ON gm.movie_id = m.movie_id
LEFT JOIN {{ ref('stg_genres') }} g ON g.genre_id = gm.genre_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
ORDER BY m.movie_id;