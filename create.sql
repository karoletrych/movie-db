create schema filmdb;

CREATE TABLE filmdb.dzial (
                dzial_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT dzial_pk PRIMARY KEY (dzial_id)
);


CREATE TABLE filmdb.praca (
                praca_id INTEGER NOT NULL,
                dzial_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT praca_pk PRIMARY KEY (praca_id)
);


CREATE TABLE filmdb.gatunek (
                gatunek_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT gatunek_pk PRIMARY KEY (gatunek_id)
);


CREATE TABLE filmdb.uzytkownik (
                id_uzytkownik INTEGER NOT NULL,
                login VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                hash_hasla VARCHAR NOT NULL,
                CONSTRAINT uzytkownik_pk PRIMARY KEY (id_uzytkownik)
);


CREATE TABLE filmdb.czlowiek (
                czlowiek_id INTEGER NOT NULL,
                data_urodzenia DATE,
                data_zgonu DATE,
                biografia VARCHAR NOT NULL,
                plec INTEGER NOT NULL,
                miejsce_urodzenia VARCHAR NOT NULL,
                nazwisko VARCHAR NOT NULL,
                CONSTRAINT czlowiek_pk PRIMARY KEY (czlowiek_id)
);


CREATE TABLE filmdb.film (
                film_id INTEGER NOT NULL,
                data_premiery DATE,
                status VARCHAR NOT NULL,
                dochod NUMERIC,
                url_plakatu VARCHAR,
                tytul VARCHAR NOT NULL,
                CONSTRAINT film_pk PRIMARY KEY (film_id)
);


CREATE SEQUENCE filmdb.ekipa_ekipa_id_seq;

CREATE TABLE filmdb.ekipa (
                ekipa_id INTEGER NOT NULL DEFAULT nextval('filmdb.ekipa_ekipa_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                praca_id INTEGER NOT NULL,
                CONSTRAINT ekipa_pk PRIMARY KEY (ekipa_id)
);


ALTER SEQUENCE filmdb.ekipa_ekipa_id_seq OWNED BY filmdb.ekipa.ekipa_id;

CREATE SEQUENCE filmdb.film_gatunek_film_gatunek_id_seq;

CREATE TABLE filmdb.film_gatunek (
                film_gatunek_id INTEGER NOT NULL DEFAULT nextval('filmdb.film_gatunek_film_gatunek_id_seq'),
                film_id INTEGER NOT NULL,
                gatunek_id INTEGER NOT NULL,
                CONSTRAINT film_gatunek_pk PRIMARY KEY (film_gatunek_id)
);


ALTER SEQUENCE filmdb.film_gatunek_film_gatunek_id_seq OWNED BY filmdb.film_gatunek.film_gatunek_id;

CREATE TABLE filmdb.recenzja (
                id_uzytkownik INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                tresc VARCHAR NOT NULL,
                ocena INTEGER NOT NULL,
                CONSTRAINT recenzja_pk PRIMARY KEY (id_uzytkownik, film_id)
);


CREATE SEQUENCE filmdb.obsada_obsada_id_seq;

CREATE TABLE filmdb.obsada (
                obsada_id INTEGER NOT NULL DEFAULT nextval('filmdb.obsada_obsada_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                postac VARCHAR NOT NULL,
                CONSTRAINT obsada_pk PRIMARY KEY (obsada_id)
);


ALTER SEQUENCE filmdb.obsada_obsada_id_seq OWNED BY filmdb.obsada.obsada_id;

CREATE TABLE filmdb.kraj (
                kraj_id VARCHAR NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT kraj_pk PRIMARY KEY (kraj_id)
);


CREATE SEQUENCE filmdb.kraj_pochodzenia_kraj_pochodzenia_id_seq;

CREATE TABLE filmdb.kraj_pochodzenia (
                kraj_pochodzenia_id INTEGER NOT NULL DEFAULT nextval('filmdb.kraj_pochodzenia_kraj_pochodzenia_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                kraj_id VARCHAR NOT NULL,
                CONSTRAINT kraj_pochodzenia_pk PRIMARY KEY (kraj_pochodzenia_id)
);


ALTER SEQUENCE filmdb.kraj_pochodzenia_kraj_pochodzenia_id_seq OWNED BY filmdb.kraj_pochodzenia.kraj_pochodzenia_id;

CREATE SEQUENCE filmdb.film_krajprodukcji_film_krajprodukcji_id_seq;

CREATE TABLE filmdb.film_krajprodukcji (
                film_krajprodukcji_id INTEGER NOT NULL DEFAULT nextval('filmdb.film_krajprodukcji_film_krajprodukcji_id_seq'),
                kraj_id VARCHAR NOT NULL,
                film_id INTEGER NOT NULL,
                CONSTRAINT film_krajprodukcji_pk PRIMARY KEY (film_krajprodukcji_id)
);


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
