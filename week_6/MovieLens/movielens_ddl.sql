CREATE DATABASE MovieLens;

CREATE TABLE dim_user (
    user_id INTEGER PRIMARY KEY,
    age INTEGER,
    gender CHAR(1),
    zip_code VARCHAR(255),
    usercol VARCHAR(45),
    age_group VARCHAR(45),
    occupation VARCHAR(255)
);

CREATE TABLE dim_movie (
    movie_id INTEGER PRIMARY KEY,
    title VARCHAR(255),
    release_year CHAR(4)
);

CREATE TABLE dim_date (
    date_id INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_of_month SMALLINT NOT NULL,
    month_number SMALLINT NOT NULL,
    quarter_number SMALLINT NOT NULL,
    year_number SMALLINT NOT NULL
);

CREATE TABLE fact_ratings (
    rating_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    date_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    rated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES dim_user(user_id),
    CONSTRAINT fk_ratings_movie FOREIGN KEY (movie_id) REFERENCES dim_movie(movie_id),
    CONSTRAINT fk_ratings_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

CREATE TABLE dim_genre (
    genre_id INTEGER PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE bridge_movie_genre (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_bridge_movie FOREIGN KEY (movie_id) REFERENCES dim_movie(movie_id),
    CONSTRAINT fk_bridge_genre FOREIGN KEY (genre_id) REFERENCES dim_genre(genre_id)
);

CREATE INDEX idx_fact_ratings_user ON fact_ratings(user_id);
CREATE INDEX idx_fact_ratings_movie ON fact_ratings(movie_id);
CREATE INDEX idx_fact_ratings_date ON fact_ratings(date_id);
CREATE INDEX idx_bridge_movie_genre_genre ON bridge_movie_genre(genre_id);