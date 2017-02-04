
ALTER TABLE moviedb.job ADD CONSTRAINT dzial_praca_fk
FOREIGN KEY (department_id)
REFERENCES moviedb.department (department_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.crew ADD CONSTRAINT praca_ekipa_fk
FOREIGN KEY (job_name)
REFERENCES moviedb.job (job_name)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.movie_genre ADD CONSTRAINT gatunek_film_gatunek_fk
FOREIGN KEY (genre_id)
REFERENCES moviedb.genre (genre_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.review ADD CONSTRAINT uzytkownik_recenzja_fk
FOREIGN KEY (member_login)
REFERENCES moviedb.member (member_login)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb._cast ADD CONSTRAINT czlowiek_obsada_fk
FOREIGN KEY (person_id)
REFERENCES moviedb.person (person_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.crew ADD CONSTRAINT czlowiek_ekipa_fk
FOREIGN KEY (person_id)
REFERENCES moviedb.person (person_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.movie_productioncountry ADD CONSTRAINT film_film_krajprodukcji_fk
FOREIGN KEY (movie_id)
REFERENCES moviedb.movie (movie_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb._cast ADD CONSTRAINT film_obsada_fk
FOREIGN KEY (movie_id)
REFERENCES moviedb.movie (movie_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.review ADD CONSTRAINT film_recenzja_fk
FOREIGN KEY (movie_id)
REFERENCES moviedb.movie (movie_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.movie_genre ADD CONSTRAINT film_film_gatunek_fk
FOREIGN KEY (movie_id)
REFERENCES moviedb.movie (movie_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.crew ADD CONSTRAINT film_ekipa_fk
FOREIGN KEY (movie_id)
REFERENCES moviedb.movie (movie_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.movie_productioncountry ADD CONSTRAINT kraj_film_krajprodukcji_fk
FOREIGN KEY (country_id)
REFERENCES moviedb.country (country_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
