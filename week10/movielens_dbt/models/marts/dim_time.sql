SELECT
    (sec / 3600) * 10000
        + ((sec / 60) % 60) * 100
        + (sec % 60),
    MAKE_TIME(
        sec / 3600,
        (sec / 60) % 60,
        sec % 60
    ),
    sec / 3600,
    (sec / 60) % 60,
    sec % 60,
    CASE
        WHEN sec / 3600 BETWEEN 5 AND 11
            THEN 'morning'
        WHEN sec / 3600 BETWEEN 12 AND 17
            THEN 'afternoon'
        WHEN sec / 3600 BETWEEN 18 AND 21
            THEN 'evening'
        ELSE 'night'
    END
FROM GENERATE_SERIES(0, 86399) AS gs(sec);