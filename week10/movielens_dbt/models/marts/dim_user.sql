SELECT
    u.user_id,
    u.gender,
    u.zip_code,
    COALESCE(a.age_group_name, 'unknown') AS age_group,
    COALESCE(o.occupation_name, 'unknown') AS occupation
FROM {{ ref('stg_users') }} u
LEFT JOIN {{ ref('stg_age_groups') }} a
    ON a.age_group_id = u.age
LEFT JOIN {{ ref('stg_occupations') }} o
    ON o.occupation_id = u.occupation_id
ORDER BY u.user_id