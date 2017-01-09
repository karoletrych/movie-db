
CREATE TABLE moviedb.dzial (
                dzial_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT dzial_pk PRIMARY KEY (dzial_id)
);


CREATE TABLE moviedb.praca (
                praca_id INTEGER NOT NULL,
                dzial_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT praca_pk PRIMARY KEY (praca_id)
);


CREATE TABLE moviedb.gatunek (
                gatunek_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT gatunek_pk PRIMARY KEY (gatunek_id)
);


CREATE TABLE moviedb.uzytkownik (
                id_uzytkownik INTEGER NOT NULL,
                login VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                hash_hasla VARCHAR NOT NULL,
                CONSTRAINT uzytkownik_pk PRIMARY KEY (id_uzytkownik)
);


CREATE TABLE moviedb.czlowiek (
                czlowiek_id INTEGER NOT NULL,
                data_urodzenia DATE,
                data_zgonu DATE,
                biografia VARCHAR NOT NULL,
                plec INTEGER NOT NULL,
                miejsce_urodzenia VARCHAR NOT NULL,
                nazwisko VARCHAR NOT NULL,
                CONSTRAINT czlowiek_pk PRIMARY KEY (czlowiek_id)
);


CREATE TABLE moviedb.film (
                film_id INTEGER NOT NULL,
                data_premiery DATE,
                status INTEGER NOT NULL,
                dochod NUMERIC,
                url_okladki VARCHAR,
                tytul VARCHAR NOT NULL,
                CONSTRAINT film_pk PRIMARY KEY (film_id)
);


CREATE SEQUENCE moviedb.ekipa_ekipa_id_seq;

CREATE TABLE moviedb.ekipa (
                ekipa_id INTEGER NOT NULL DEFAULT nextval('moviedb.ekipa_ekipa_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                praca_id INTEGER NOT NULL,
                CONSTRAINT ekipa_pk PRIMARY KEY (ekipa_id)
);


ALTER SEQUENCE moviedb.ekipa_ekipa_id_seq OWNED BY moviedb.ekipa.ekipa_id;

CREATE SEQUENCE moviedb.film_gatunek_film_gatunek_id_seq;

CREATE TABLE moviedb.film_gatunek (
                film_gatunek_id INTEGER NOT NULL DEFAULT nextval('moviedb.film_gatunek_film_gatunek_id_seq'),
                film_id INTEGER NOT NULL,
                gatunek_id INTEGER NOT NULL,
                CONSTRAINT film_gatunek_pk PRIMARY KEY (film_gatunek_id)
);


ALTER SEQUENCE moviedb.film_gatunek_film_gatunek_id_seq OWNED BY moviedb.film_gatunek.film_gatunek_id;

CREATE TABLE moviedb.recenzja (
                id_uzytkownik INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                tresc VARCHAR NOT NULL,
                ocena INTEGER NOT NULL,
                CONSTRAINT recenzja_pk PRIMARY KEY (id_uzytkownik, film_id)
);


CREATE SEQUENCE moviedb.obsada_obsada_id_seq;

CREATE TABLE moviedb.obsada (
                obsada_id INTEGER NOT NULL DEFAULT nextval('moviedb.obsada_obsada_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                postac VARCHAR NOT NULL,
                CONSTRAINT obsada_pk PRIMARY KEY (obsada_id)
);


ALTER SEQUENCE moviedb.obsada_obsada_id_seq OWNED BY moviedb.obsada.obsada_id;

CREATE TABLE moviedb.kraj (
                kraj_id INTEGER NOT NULL,
                nazwa VARCHAR NOT NULL,
                CONSTRAINT kraj_pk PRIMARY KEY (kraj_id)
);


CREATE SEQUENCE moviedb.kraj_pochodzenia_kraj_pochodzenia_id_seq;

CREATE TABLE moviedb.kraj_pochodzenia (
                kraj_pochodzenia_id INTEGER NOT NULL DEFAULT nextval('moviedb.kraj_pochodzenia_kraj_pochodzenia_id_seq'),
                czlowiek_id INTEGER NOT NULL,
                kraj_id INTEGER NOT NULL,
                CONSTRAINT kraj_pochodzenia_pk PRIMARY KEY (kraj_pochodzenia_id)
);


ALTER SEQUENCE moviedb.kraj_pochodzenia_kraj_pochodzenia_id_seq OWNED BY moviedb.kraj_pochodzenia.kraj_pochodzenia_id;

CREATE SEQUENCE moviedb.film_krajprodukcji_film_krajprodukcji_id_seq;

CREATE TABLE moviedb.film_krajprodukcji (
                film_krajprodukcji_id INTEGER NOT NULL DEFAULT nextval('moviedb.film_krajprodukcji_film_krajprodukcji_id_seq'),
                kraj_id INTEGER NOT NULL,
                film_id INTEGER NOT NULL,
                CONSTRAINT film_krajprodukcji_pk PRIMARY KEY (film_krajprodukcji_id)
);


ALTER SEQUENCE moviedb.film_krajprodukcji_film_krajprodukcji_id_seq OWNED BY moviedb.film_krajprodukcji.film_krajprodukcji_id;

ALTER TABLE moviedb.praca ADD CONSTRAINT dzial_praca_fk
FOREIGN KEY (dzial_id)
REFERENCES moviedb.dzial (dzial_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.ekipa ADD CONSTRAINT praca_ekipa_fk
FOREIGN KEY (praca_id)
REFERENCES moviedb.praca (praca_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.film_gatunek ADD CONSTRAINT gatunek_film_gatunek_fk
FOREIGN KEY (gatunek_id)
REFERENCES moviedb.gatunek (gatunek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.recenzja ADD CONSTRAINT uzytkownik_recenzja_fk
FOREIGN KEY (id_uzytkownik)
REFERENCES moviedb.uzytkownik (id_uzytkownik)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.obsada ADD CONSTRAINT czlowiek_obsada_fk
FOREIGN KEY (czlowiek_id)
REFERENCES moviedb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.ekipa ADD CONSTRAINT czlowiek_ekipa_fk
FOREIGN KEY (czlowiek_id)
REFERENCES moviedb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.kraj_pochodzenia ADD CONSTRAINT czlowiek_kraj_pochodzenia_fk
FOREIGN KEY (czlowiek_id)
REFERENCES moviedb.czlowiek (czlowiek_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.film_krajprodukcji ADD CONSTRAINT film_film_krajprodukcji_fk
FOREIGN KEY (film_id)
REFERENCES moviedb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.obsada ADD CONSTRAINT film_obsada_fk
FOREIGN KEY (film_id)
REFERENCES moviedb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.recenzja ADD CONSTRAINT film_recenzja_fk
FOREIGN KEY (film_id)
REFERENCES moviedb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.film_gatunek ADD CONSTRAINT film_film_gatunek_fk
FOREIGN KEY (film_id)
REFERENCES moviedb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.ekipa ADD CONSTRAINT film_ekipa_fk
FOREIGN KEY (film_id)
REFERENCES moviedb.film (film_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.film_krajprodukcji ADD CONSTRAINT kraj_film_krajprodukcji_fk
FOREIGN KEY (kraj_id)
REFERENCES moviedb.kraj (kraj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE moviedb.kraj_pochodzenia ADD CONSTRAINT kraj_kraj_pochodzenia_fk
FOREIGN KEY (kraj_id)
REFERENCES moviedb.kraj (kraj_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
