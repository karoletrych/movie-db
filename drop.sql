DROP schema filmdb;

DROP TABLE filmdb.dzial cascade;


DROP TABLE filmdb.praca cascade;


DROP TABLE filmdb.gatunek cascade;


DROP TABLE filmdb.uzytkownik  cascade;


DROP TABLE filmdb.czlowiek cascade;


DROP TABLE filmdb.film  cascade;


DROP SEQUENCE filmdb.ekipa_ekipa_id_seq cascade;

DROP TABLE filmdb.ekipa  cascade;


ALTER SEQUENCE filmdb.ekipa_ekipa_id_seq OWNED BY filmdb.ekipa.ekipa_id cascade;

DROP SEQUENCE filmdb.film_gatunek_film_gatunek_id_seq cascade;

DROP TABLE filmdb.film_gatunek  cascade;


ALTER SEQUENCE filmdb.film_gatunek_film_gatunek_id_seq OWNED BY filmdb.film_gatunek.film_gatunek_id cascade;

DROP TABLE filmdb.recenzja  cascade;


DROP SEQUENCE filmdb.obsada_obsada_id_seq cascade;

DROP TABLE filmdb.obsada  cascade;


ALTER SEQUENCE filmdb.obsada_obsada_id_seq OWNED BY filmdb.obsada.obsada_id cascade;

DROP TABLE filmdb.kraj  cascade;


DROP SEQUENCE filmdb.kraj_pochodzenia_kraj_pochodzenia_id_seq cascade;

DROP TABLE filmdb.kraj_pochodzenia  cascade;


ALTER SEQUENCE filmdb.kraj_pochodzenia_kraj_pochodzenia_id_seq OWNED BY filmdb.kraj_pochodzenia.kraj_pochodzenia_id;

DROP SEQUENCE filmdb.film_krajprodukcji_film_krajprodukcji_id_seq cascade;

DROP TABLE filmdb.film_krajprodukcji  cascade;


ALTER SEQUENCE filmdb.film_krajprodukcji_film_krajprodukcji_id_seq OWNED BY filmdb.film_krajprodukcji.film_krajprodukcji_id;

ALTER TABLE filmdb.praca ADD CONSTRAINT dzial_praca_fk
FOREIGN KEY (dzial_id)
REFERENCES filmdb.dzial (dzial_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.ekipa ADD CONSTRAINT praca_ekipa_fk
FOREIGN KEY (praca_id)
REFERENCES filmdb.praca (praca_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.film_gatunek ADD CONSTRAINT gatunek_film_gatunek_fk
FOREIGN KEY (gatunek_id)
REFERENCES filmdb.gatunek (gatunek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.recenzja ADD CONSTRAINT uzytkownik_recenzja_fk
FOREIGN KEY (id_uzytkownik)
REFERENCES filmdb.uzytkownik (id_uzytkownik)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.obsada ADD CONSTRAINT czlowiek_obsada_fk
FOREIGN KEY (czlowiek_id)
REFERENCES filmdb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.ekipa ADD CONSTRAINT czlowiek_ekipa_fk
FOREIGN KEY (czlowiek_id)
REFERENCES filmdb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.kraj_pochodzenia ADD CONSTRAINT czlowiek_kraj_pochodzenia_fk
FOREIGN KEY (czlowiek_id)
REFERENCES filmdb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.film_krajprodukcji ADD CONSTRAINT film_film_krajprodukcji_fk
FOREIGN KEY (film_id)
REFERENCES filmdb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.obsada ADD CONSTRAINT film_obsada_fk
FOREIGN KEY (film_id)
REFERENCES filmdb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.recenzja ADD CONSTRAINT film_recenzja_fk
FOREIGN KEY (film_id)
REFERENCES filmdb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.film_gatunek ADD CONSTRAINT film_film_gatunek_fk
FOREIGN KEY (film_id)
REFERENCES filmdb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.ekipa ADD CONSTRAINT film_ekipa_fk
FOREIGN KEY (film_id)
REFERENCES filmdb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.film_krajprodukcji ADD CONSTRAINT kraj_film_krajprodukcji_fk
FOREIGN KEY (kraj_id)
REFERENCES filmdb.kraj (kraj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE filmdb.kraj_pochodzenia ADD CONSTRAINT kraj_kraj_pochodzenia_fk
FOREIGN KEY (kraj_id)
REFERENCES filmdb.kraj (kraj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
