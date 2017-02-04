
CREATE TABLE moviedb.department (
                department_id INTEGER NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT department_pk PRIMARY KEY (department_id)
);


CREATE TABLE moviedb.job (
                job_name VARCHAR NOT NULL,
                department_id INTEGER NOT NULL,
                CONSTRAINT job_pk PRIMARY KEY (job_name)
);


CREATE TABLE moviedb.genre (
                genre_id INTEGER NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT genre_pk PRIMARY KEY (genre_id)
);


CREATE TABLE moviedb.member (
                member_login VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password_hash VARCHAR NOT NULL,
                CONSTRAINT member_pk PRIMARY KEY (member_login)
);


CREATE TABLE moviedb.person (
                person_id INTEGER NOT NULL,
                birthday DATE,
                deathday DATE,
                biography VARCHAR NOT NULL,
                gender INTEGER NOT NULL,
                place_of_birth VARCHAR NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT person_pk PRIMARY KEY (person_id)
);


CREATE TABLE moviedb.movie (
                movie_id INTEGER NOT NULL,
                release_date DATE,
                status VARCHAR NOT NULL,
                revenue NUMERIC,
                poster_url VARCHAR,
                title VARCHAR NOT NULL,
                vote_average REAL,
                CONSTRAINT movie_pk PRIMARY KEY (movie_id)
);


CREATE TABLE moviedb.crew (
                person_id INTEGER NOT NULL,
                movie_id INTEGER NOT NULL,
                job_name VARCHAR NOT NULL,
                CONSTRAINT crew_pk PRIMARY KEY (person_id, movie_id, job_name)
);


CREATE TABLE moviedb.movie_genre (
                movie_id INTEGER NOT NULL,
                genre_id INTEGER NOT NULL,
                CONSTRAINT movie_genre_pk PRIMARY KEY (movie_id, genre_id)
);


CREATE TABLE moviedb.review (
                movie_id INTEGER NOT NULL,
                member_login VARCHAR NOT NULL,
                content VARCHAR NOT NULL,
                vote INTEGER NOT NULL,
                CONSTRAINT review_pk PRIMARY KEY (movie_id, member_login)
);


CREATE TABLE moviedb._cast (
                character VARCHAR NOT NULL,
                person_id INTEGER NOT NULL,
                movie_id INTEGER NOT NULL,
                CONSTRAINT _cast_pk PRIMARY KEY (character, person_id, movie_id)
);


CREATE TABLE moviedb.country (
                country_id CHAR(2) NOT NULL,
                name VARCHAR NOT NULL,
                CONSTRAINT country_pk PRIMARY KEY (country_id)
);


CREATE TABLE moviedb.movie_productioncountry (
                country_id CHAR(2) NOT NULL,
                movie_id INTEGER NOT NULL,
                CONSTRAINT movie_productioncountry_pk PRIMARY KEY (country_id, movie_id)
);

