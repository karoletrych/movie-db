--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

-- Started on 2017-02-02 19:12:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2241 (class 1262 OID 12401)
-- Dependencies: 2240
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 9 (class 2615 OID 45369)
-- Name: moviedb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA moviedb;


ALTER SCHEMA moviedb OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 12387)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2243 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2244 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = moviedb, pg_catalog;

--
-- TOC entry 216 (class 1255 OID 45521)
-- Name: create_member(character varying, character varying, character varying); Type: FUNCTION; Schema: moviedb; Owner: postgres
--

CREATE FUNCTION create_member(new_login character varying, email character varying, password character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
	BEGIN 
		IF length (new_login) < 5 OR length (new_login) > 20 THEN raise 'Incorrect login length. Should be 5-20 characters long.';
		END IF;
		IF length (password) < 5 OR length (password) > 20 THEN raise 'Incorrect password length. Should be 5-20 characters long.';
		END IF;
		IF new_login NOT SIMILAR TO '[a-z0-9A-Z]*' THEN raise 'Incorrect login value.';
		END IF;
		IF password NOT SIMILAR TO '[a-z0-9A-Z]*' THEN raise 'Incorrect password value.';
		END IF;
		IF email NOT SIMILAR TO '\S+@\S+' THEN raise 'Incorrect email value. Should contain @ character.';
		END IF;

		INSERT INTO moviedb.member(member_login,email, password_hash) VALUES(new_login, email, MD5(password));
		EXCEPTION
		WHEN unique_violation THEN raise 'User already exists.';
	END;
$$;


ALTER FUNCTION moviedb.create_member(new_login character varying, email character varying, password character varying) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 45522)
-- Name: login_member(character varying, character varying); Type: FUNCTION; Schema: moviedb; Owner: postgres
--

CREATE FUNCTION login_member(login character varying, password character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    DECLARE
        logged_user varchar;
    BEGIN
        SELECT member_login FROM moviedb.member  WHERE member_login=login AND password_hash=MD5(password) INTO logged_user;
        RETURN logged_user ;
    END;
$$;


ALTER FUNCTION moviedb.login_member(login character varying, password character varying) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 45520)
-- Name: vote_average(); Type: FUNCTION; Schema: moviedb; Owner: postgres
--

CREATE FUNCTION vote_average() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ DECLARE average FLOAT;
BEGIN
SELECT
    avg (r.vote)
    INTO average
FROM
    moviedb.movie m
    JOIN moviedb.review r ON m.movie_id = r.movie_id
WHERE
    m.movie_id = new.movie_id;
UPDATE moviedb.movie
SET
    vote_average = average
WHERE
    movie_id = new.movie_id;
RETURN NEW;
END;
$$;


ALTER FUNCTION moviedb.vote_average() OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 213 (class 1255 OID 16702)
-- Name: before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE  
    new_stan_opanowania_id integer;  
    BEGIN
     SELECT stan_opanowania_id INTO new_stan_opanowania_id FROM kompetencja WHERE  
      projektant_id = NEW.pracownik_id AND technologia_id = OLD.technologia_id;
     RAISE NOTICE 'aaaa ID --> %', new_stan_opanowania_id;
     RAISE NOTICE 'aaaa ID --> %', OLD.stan_opanowania_id;
     IF new_stan_opanowania_id >= OLD.stan_opanowania_id THEN
       RETURN NEW;
     ELSE
       RAISE EXCEPTION 'Niewystarczajace kompetencje'; 
     END IF;
    END;     
    $$;


ALTER FUNCTION public.before_update() OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 25581)
-- Name: vote_average(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vote_average() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
average float;
BEGIN
SELECT AVG(r.vote) INTO average
FROM moviedb.movie m JOIN moviedb.review r ON m.movie_id = r.movie_id
WHERE m.movie_id = 157;
UPDATE moviedb.movie SET vote_average = average
WHERE movie_id = 157;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.vote_average() OWNER TO postgres;

SET search_path = moviedb, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 45439)
-- Name: _cast; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE _cast (
    "character" character varying NOT NULL,
    person_id integer NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE _cast OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 45447)
-- Name: country; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE country (
    country_id character(2) NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE country OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 45418)
-- Name: crew; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE crew (
    person_id integer NOT NULL,
    movie_id integer NOT NULL,
    job_name character varying NOT NULL
);


ALTER TABLE crew OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 45370)
-- Name: department; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE department (
    department_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE department OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 45386)
-- Name: genre; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE genre (
    genre_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE genre OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 45378)
-- Name: job; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE job (
    job_name character varying NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE job OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 45394)
-- Name: member; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE member (
    member_login character varying NOT NULL,
    email character varying NOT NULL,
    password_hash character varying NOT NULL
);


ALTER TABLE member OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 45410)
-- Name: movie; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE movie (
    movie_id integer NOT NULL,
    release_date date,
    status character varying NOT NULL,
    revenue numeric,
    poster_url character varying,
    title character varying NOT NULL,
    vote_average real
);


ALTER TABLE movie OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 45426)
-- Name: movie_genre; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE movie_genre (
    movie_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE movie_genre OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 45455)
-- Name: movie_productioncountry; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE movie_productioncountry (
    country_id character(2) NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE movie_productioncountry OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 45402)
-- Name: person; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE person (
    person_id integer NOT NULL,
    birthday date,
    deathday date,
    biography character varying NOT NULL,
    gender integer NOT NULL,
    place_of_birth character varying NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE person OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 45431)
-- Name: review; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE review (
    movie_id integer NOT NULL,
    member_login character varying NOT NULL,
    content character varying NOT NULL,
    vote integer NOT NULL
);


ALTER TABLE review OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 45524)
-- Name: top100; Type: VIEW; Schema: moviedb; Owner: postgres
--

CREATE VIEW top100 AS
 SELECT movie.movie_id,
    movie.release_date,
    movie.status,
    movie.revenue,
    movie.poster_url,
    movie.title,
    movie.vote_average
   FROM movie
  WHERE (movie.movie_id IN ( SELECT r.movie_id
           FROM (movie m
             JOIN review r ON ((r.movie_id = m.movie_id)))
          GROUP BY r.movie_id
         HAVING (count(r.movie_id) >= 10)))
  ORDER BY movie.vote_average DESC
 LIMIT 100;


ALTER TABLE top100 OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 45529)
-- Name: top100director; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE top100director (
    person_id integer,
    name character varying,
    vote_average double precision
);

ALTER TABLE ONLY top100director REPLICA IDENTITY NOTHING;


ALTER TABLE top100director OWNER TO postgres;

--
-- TOC entry 2233 (class 0 OID 45439)
-- Dependencies: 196
-- Data for Name: _cast; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY _cast ("character", person_id, movie_id) FROM stdin;
Taisto Olavi Kasurinen	54768	2
Irmeli Katariina Pihlaja	54769	2
Mikkonen	4826	2
Riku	54770	2
Nikander	4826	3
Ilona Rajamäki	5999	3
Melartin	4828	3
Co-worker	53508	3
Ilona's Girlfriend	1086499	3
Shop Steward	222320	3
Third Man	1086500	3
Korben Dallas	62	18
Jean-Baptiste Emmanuel Zorg	64	18
Father Vito Cornelius	65	18
Leeloo	63	18
Ruby Rhod	66	18
Billy	8395	18
General Munro	591	18
President Lindberg	8396	18
Fog	7400	18
David	8397	18
Right Arm	183500	18
General Staedert	12642	18
Professor Pacoli	8398	18
Mugger	2406	18
Mactilburgh	8399	18
Mr. Kim	8400	18
Major Iceborg	28897	18
General Tudor	10208	18
Diva Plavalaguna	64210	18
Flying Cop	33403	18
VIP Stewardess	232174	18
Stewardess	1588721	18
Cop	53246	18
Hefty Man	8445	18
Joel Barish	206	38
Clementine Kruczynski	204	38
Patrick	109	38
Stan	103	38
Mary	205	38
Dr. Howard Mierzwiak	207	38
Young Joel	208	38
Carrie	209	38
Joel's mother	211	38
Rob	212	38
Train Conducter	213	38
Young Bully	214	38
Young Bully	216	38
Young Bully	217	38
Young Clementine	220	38
Young Bully	210	38
Hollis	77013	38
Rollerblader	221	38
Dr. Dave Bowman	245	62
HAL 9000 (voice)	253	62
Dr. Frank Poole	246	62
Dr. Heywood R. Floyd	247	62
Moon-Watcher	248	62
Dr. Andrei Smyslov	249	62
Elena	250	62
Dr. Ralph Halvorsen	251	62
Dr. Bill Michaels	252	62
Astronaut	24278	62
Aries-1B Lunar Shuttle Captain	108277	62
Poole's Father	93948	62
Poole's Mother	107445	62
Aries-1B Stewardess	117540	62
Mission Controller (voice)	102573	62
Astronaut	948173	62
Stewardess	127363	62
Stewardess	1102076	62
Astronaut	1330785	62
Ape	1330786	62
Ape	1330787	62
Ape	1330788	62
Ape	1330789	62
Ape	1330790	62
Ape	1330791	62
Ape Attacked by Leopard	1330792	62
Ape	1330793	62
Ape	1330794	62
Ape	1330795	62
Ape	1330796	62
Ape	1330797	62
Ape	1330798	62
Ape	1330799	62
Ape	1330800	62
Nausicaä (Voice)	613	81
Jihl (Voice)	614	81
Oh-Baba (Voice)	615	81
Yupa (Voice)	616	81
Mito (Voice)	617	81
Goru (Voice)	618	81
Gikkuri (Voice)	619	81
Niga (Voice)	620	81
Teto / Girl C (Voice)	621	81
Asbel (Voice)	622	81
Rastel (Voice)	623	81
Kushana (Voice)	624	81
Kurotowa (Voice)	625	81
Commando (Voice)	626	81
Major Alan 'Dutch' Schaeffer	1100	106
Major George Dillon	1101	106
Anna	1102	106
Sergeant 'Mac' Eliot	1103	106
Blain	1104	106
Billy	1105	106
Poncho Ramirez	1106	106
General Phillips	1107	106
Hawkins	1108	106
Helicopter Pilot / Predator	1109	106
Russian Officer (uncredited)	20761	106
Turkish	976	107
Mickey O'Neil	287	107
Bullet Tooth Tony	980	107
Abraham 'Cousin Avi' Denovitz	1117	107
Franky Four Fingers	1121	107
Himself (as The Rolling Stones)	1428	132
Himself (as The Rolling Stones)	1430	132
Himself (as The Rolling Stones)	1429	132
Himself (as The Rolling Stones)	1431	132
Himself (as The Rolling Stones)	1432	132
Himself (as Jefferson Airplane)	1433	132
Himself	1435	132
Himself	1436	132
Himself	1437	132
Himself (as Jefferson Airplane)	1438	132
Himself (as The Flying Burrito Brotthers)	1439	132
Himself	1440	132
Himself (as Jefferson Airplane)	1441	132
Himself (as The Grateful Dead)	1442	132
Himself (as The Flying Burrito Brothers)	1443	132
Himself (black youth stabbed by Hell's Angel)	1444	132
Himself (as Jefferson Airplane)	1445	132
Himself (as Jefferson Airplane)	1446	132
Himself (as The Flying Burrito Brothers)	1447	132
Himself (concert organizer)	1448	132
Himself (as The Flying Burrito Brothers)	1449	132
Himself (as The Flying Burrito Brothers)	1451	132
Himself (Hell's Angel who stabs Meredith Hunter)	1452	132
Himself	1422	132
Himself	1454	132
Himself (as Santana band member)	1455	132
Herself (as Jefferson Airplane)	1456	132
Himself on KFRC	1457	132
Himself	1458	132
Herself	1459	132
Himself (uncredited)	1418	132
Himself (uncredited)	1460	132
Himself (as The Grateful Dead)	556171	132
Danny Ocean	1461	161
Rusty Ryan	287	161
Linus Caldwell	1892	161
Terry Benedict	1271	161
Tess Ocean	1204	161
Virgil Malloy	1893	161
Turk Malloy	1894	161
Saul Bloom	1895	161
Frank Catton	1897	161
Reuben Tishkoff	827	161
Livingston Dell	1898	161
Yen	1900	161
Bulldog, the Bruiser	1906	161
Head Goon	240770	161
Boxing Spectator	14731	161
Holly	26469	161
Vault-Bombing Thief	1884	161
Security Guard	1655618	161
Security Officer #1	235346	161
Basher Tarr (uncredited)	1896	161
Admiral/Captain James T. Kirk	1748	168
Captain Spock	1749	168
Dr. Leonard McCoy	1750	168
Montgomery Scott	1751	168
Cmdr. Hikaru Sulu	1752	168
Cmdr. Pavel Chekov	1754	168
Cmdr. Uhura	1753	168
Amanda	2021	168
Dr. Gillian Taylor	2022	168
Ambassador Sarek	1820	168
Lt. Saavik	1819	168
Federation Council President	2647	168
Klingon Ambassador	24046	168
Admiral Cartwright	2112	168
Starfleet Communications Officer	1219391	168
Marv	2295	189
Nancy	56731	189
Dwight	16851	189
Johnny	24045	189
Gail	5916	189
Hartigan	62	189
Ava	10912	189
Senator Roark	6280	189
Manute	352	189
Joey	11477	189
Mort	22227	189
Bob	12799	189
Kroenig	1062	189
Goldie / Wendy	5915	189
Sally	36594	189
Wallenquist	825	189
Damien Lord	20982	189
Lt. Liebowitz	8693	189
Miho	78324	189
Bertha	237405	189
Gilda	57674	189
Marcie	936970	189
Louie	968889	189
Dallas	3133	189
Flint	84791	189
Buzz	90553	189
Frat Boy #3	1129413	189
Frat Boy #4	1406568	189
Lillian	1406570	189
Tony	60674	189
Abdul	1393520	189
Luigi	1406674	189
Gordo	1025370	189
Joey's Wife	55269	189
Mulgrew	1406676	189
Captain Jean-Luc Picard	2387	200
Commander William T. Riker	2388	200
Lt. Commander Data	1213786	200
Lt. Commander Geordi La Forge	2390	200
Doctor Beverly Crusher	2392	200
Counselor Deanna Troi	2393	200
Ad'har Ru'afo	1164	200
Vice-Adm. Dougherty	2516	200
Anij	2517	200
Gallatin	2518	200
Lt. Commander Worf	2391	200
Raimunda	955	219
Abuela Irene	2744	219
Sole	2759	219
Agustina	3480	219
Paula	3481	219
Tía Paula	3482	219
Paco	3483	219
Emilio	4363	219
Regina	4364	219
Inés	4365	219
Auxiliar	4366	219
Presentadora TV	4367	219
Carlos	4368	219
Vecina	4369	219
Vecina	4370	219
Vecina	4371	219
Vecina	4372	219
Vecina	4373	219
Vecina	4374	219
Vecina	4375	219
Vecina	1621575	219
Vecina	954664	219
Empleado ferretería (uncredited)	952	219
Vecina (uncredited)	1077948	219
Make-up Artist (uncredited)	1348364	219
Muriel Heslop / Mariel Heslop-Van Arckle	3051	236
Bill Heslop	23	236
Rhonda Epinstalk	3052	236
Tania Degano	3053	236
Cheryl	3054	236
Janine	3057	236
Nicole	3059	236
Betty Heslop	3060	236
Perry Heslop	3062	236
Joanie Heslop	3066	236
Deidre Chambers	3067	236
Brice Nobes	3068	236
Coach Ken Blundell	3070	236
David Van Arckle	3072	236
Joe Taylor	3061	237
Ella Gault	3063	237
Les Gault	3064	237
Antoine Doinel	1653	258
Christine Doinel	3507	258
Monsieur Darbon	3509	258
Madame Darbon	3510	258
Kyoko	3572	258
Ténor	3573	258
Silvana	3574	258
Monique	3575	258
L'étrangleur	3577	258
Ginette	3579	258
Madame Martin	3580	258
Drunken Man	3581	258
Newspaper Seller	1650	258
Cadger	35249	258
Césarin	70142	258
Christophe	1372429	258
L'ami de Césarin	36915	258
L'ami de S.O.S.	126234	258
La mère de Marianne	1372430	258
Le contractuel	1372431	258
Le ricaneur	35898	258
M. Max	35958	258
Marianne	1372433	258
Marie	1372437	258
Monsieur Desbois	39443	258
Madame Martin	1372438	258
	40586	258
Jan	3872	276
Jule	3932	276
Peter	3933	276
Justus Hardenberg	3934	276
Villenbesitzer	3935	276
Villenbesitzerin	3936	276
Tochter	3937	276
Sohn	3938	276
Globalisierungsgegner	3939	276
Vermieter	169	276
Paolo	88442	276
Jules Chef	36468	276
Selene	3967	277
Michael Corvin	100	277
Lucian	3968	277
Terminator	1100	296
John Connor	6408	296
Kate Brewster	6194	296
T-X	7218	296
Robert Brewster	7219	296
Scott Petersen	7220	296
Dr. Peter Silberman	2716	296
Betsy	7221	296
Chief Engineer	7222	296
Brewser's Aide	7223	296
Bill's Girlfriend	7226	296
Engineer	27738	296
Jose Barrera	1444239	296
Roadhouse Clubgoer	1178376	296
David 'Noodles' Aaronson	380	311
Maximilian 'Max' Bercovicz	4512	311
Deborah Gelly	4513	311
Carol	4514	311
James Conway O'Donnell	4515	311
Patrick 'Patsy' Goldberg	4516	311
Frankie Minaldi	4517	311
'Fat' Moe Gelly	4518	311
Police Chief Vincent Aiello	1004	311
Philip 'Cockeye' Stein	4520	311
Joe	4521	311
Young Noodles	4750	311
Young Max / David Bailey	4751	311
Young Cockeye	4752	311
Young Patsy	4753	311
Dominic	4754	311
Eve	4761	311
Young 'Fat' Moe Gelly	4773	311
Young Deborah	6161	311
Al Capuano	17921	311
Beefy	1373773	311
Bugsy	785	311
Chicken Joe	3174	311
Crowning	151943	311
doublure de Jennifer Connelly	1373775	311
Fred Capuano	1373776	311
Irving Gold	1373778	311
Johnny Capuano	61236	311
l'ami de Deborah jeune	1373779	311
Rahul Seth	86213	333
Sue (Sunita) Singh	52969	333
Mummy ji	111808	333
Grandma ji	105652	333
Mr. Singh	53377	333
Rocky	106461	333
Kimberly	82096	333
Twinky	52975	333
Bobby	111809	333
Go (Govind)	111810	333
Lucy	111811	333
Mrs. Singh	111812	333
Killer Khalsa (as Killer Khalsa)	111813	333
Daddy ji	111814	333
Ronica	111815	333
Brian	111816	333
Stevie Sood (as Damon D'Olivera)	111817	333
Bobby's Mom	111818	333
Nicole	111819	333
Young Rahul	111820	333
Veronica	111821	333
Rahul's Friend at Wedding	111822	333
Reporter	111823	333
Bobby's Sister	111824	333
Pauline	111825	333
Himself	87328	333
Linda Partridge	1231	334
Donnie Smith	3905	334
Cahit Tomruk	5117	363
Sibel Güner	5118	363
Maren	5119	363
Seref	5120	363
Selma	5121	363
Nico	5122	363
Yunus Güner/ Vater	5123	363
Yilmaz Güner/ Bruder	5124	363
Birsen Güner/ Mutter	5134	363
Mann am Tresen	1075606	363
Stammkundin Zoe Bar	1123057	363
Patient	42451	363
Patient	53845	363
Barfrau in der Fabrik	45906	363
Dr. Schiller	1075570	363
Busfahrer	563496	363
Beamter Trauung	34190	363
Barmann	5498	363
Barmann Istanbul	5496	363
Osman 1	1088662	363
Taxifahrer	145402	363
Bayerischer Taxifahrer	18734	363
Musiker	5500	363
Musiker	974178	363
Musiker	1267485	363
Tom Reagan	5168	379
Verna Bernbaum	4726	379
Bernie Bernbaum	1241	379
Johnny Caspar	4253	379
Eddie Dane	5169	379
Liam 'Leo' O'Bannon	3926	379
Frankie	5170	379
Tic-Tac	5171	379
Mayor Dale Levander	5172	379
O'Doole	5173	379
Mink	884	379
Clarence "Drop" Johnson	176958	379
Tad	53573	379
Adolph	2169	379
Terry	3204	379
Mrs. Caspar	1126347	379
Johnny Caspar, Jr.	1281525	379
Cop - Brian	16459	379
Cop - Delahanty	27513	379
Screaming Lady	1281526	379
Landlady	1281527	379
Gunman in Leo's House	1281528	379
Gunman in Leo's House	142160	379
Rug Daniels	1281529	379
Street Urchin	1281530	379
Caspar's Driver	1010	379
Caspar's Butler	1281531	379
Caspar's Cousin	1281532	379
Caspar's Cousin	1281533	379
Hitman at Verna's	71659	379
Hitman #2	1281535	379
Lazarre's Messenger	35022	379
Lazarre's Tough	1281536	379
Lazarre's Tough	1281537	379
Man with Pipe Bomb	1190852	379
Phillip Winter	5266	390
Friedrich Monroe	5274	390
Truck Driver	5275	390
Zé	5276	390
Sofia	5277	390
Vera	5278	390
Beta	5279	390
Ricardo	5280	390
Joe	190	391
Marisol	16309	391
Ramón Rojo	14276	391
John Baxter	16310	391
Silvanito	16311	391
Esteban Rojo	16312	391
Don Miguel Rojo	16313	391
Consuelo Baxter	16314	391
Julián	16316	391
Bruce Wayne / Batman	5576	414
Harvey Dent / Two-Face	2176	414
Edward Nygma / The Riddler	206	414
Dr. Chase Meridian	2227	414
Dick Grayson / Robin	5577	414
Alfred Pennyworth	3796	414
Commissioner Gordon	3798	414
Sugar	69597	414
Spice	5578	414
Gossip Gerty	5579	414
Dr. Burton	9807	414
Bank Guard	4887	414
Male Newscaster	1235	414
Female Newscaster	156689	414
Crime Boss Moroni	162556	414
Gang Leader	106745	414
	25336	414
Eric Wynn	5918	438
Cassandra Rains	5919	438
Jax	5920	438
Haskell	5921	438
Dodd	5922	438
Meyerhold	5923	438
Bartok	5924	438
Finn	5925	438
Jellico	5926	438
Owen	5927	438
Quigley	142193	438
Sissi, Kaiserin Elisabeth von Österreich	6250	459
Franz Joseph, Kaiser von Österreich	6251	459
Herzogin Ludovika von Bayern	6252	459
Herzog Max von Bayern	6254	459
Néné, Prinzessin Helene von Bayern	6253	459
Graf Andrassy	6809	459
Erzherzogin Sophie	6255	459
Major Böckl	6256	459
Gräfin Bellegarde	6810	459
Erzherzog Franz-Karl	6257	459
Dr. Seeburger	6811	459
Henriette Mendel	6815	459
Prinz Ludwig	6816	459
Helena auf Korfu	1291313	459
Jackie Zucker	6093	460
Marlene	6263	460
Samuel	6264	460
Golda	6265	460
Tono	6523	481
Richi	6534	481
Policía	6535	481
Herself	6536	481
Muriel Moreno	6537	481
Paz Padilla	6538	481
Patri	6539	481
Santacana	6540	481
John Shaft	6487	482
Bumpy Jonas	6561	482
Vic Androzzi	6354	482
Ben Buford	6562	482
Ellie Moore	6563	482
Sergeant Tom Hannon	6564	482
Charlie	6565	482
Marcy	6566	482
Aileen	6885	504
Selby	6886	504
Thomas	6905	504
Vincent Corey	6906	504
Donna	6907	504
Will/Daddy "John"	6908	504
Lawyer	6909	504
Bartender	6910	504
Justy	95749	504
Michaela Klingler	7152	523
Karl Klingler	3934	523
Marianne Klingler	7153	523
Helga Klingler	7154	523
Hanna Imhof	7155	523
Stefan Weiser	7156	523
Gerhart Landauer	7157	523
Martin Borchert	7158	523
Professor	7159	523
Heimleiterin	7160	523
Krankenschwester	7161	523
Sam 'Ace' Rothstein	380	524
Ginger McKenna	4430	524
Nicky Santoro	4517	524
Lester Diamond	4512	524
Billy Sherbert	7167	524
Andy Stone	7169	524
Phillip Green	7166	524
Remo Gaggi	7165	524
Reverand Scott	193	551
Mike Rogo	7502	551
James Martin	7503	551
Nonnie Parry	7504	551
Acres	7505	551
Linda Rogo	7631	551
Belle Rosen	7632	551
Manny Rosen	3461	551
Captain Harrison	7633	551
Susan Shelby	7634	551
Robin Shelby	7635	551
Mr. Linarcos	7636	551
Woman (uncredited)	1407179	551
Chaplain	857	551
Nurse	6865	551
Doctor	151536	551
Purser	88170	551
Chief Engineer	15693	551
M. C.	34973	551
Mr. Tinkham	1401253	551
First Officer Larsen	151689	551
Anaïs Pingot	7705	570
Elena Pingot	7706	570
Fernando	7707	570
Mère	7708	570
Père	7709	570
La mère de Fernando	7710	570
Killer	7711	570
Robert Langdon	31	591
Sophie Neveu	2405	591
Sir Leigh Teabing	1327	591
Silas	6162	591
Captain Bezu Fache	1003	591
Manuel Aringarosa	658	591
André Vernet	920	591
Rémy Jean	34259	591
Jacques Saunier	20795	591
Sœur Sandrine	38885	591
Ritual Priestress	28186	591
Mother of Silas	38886	591
Father of Silas	38887	591
Michael	38888	591
Lt. Collet	150792	591
PTS Agent (uncredited)	129014	591
London Police	1278517	591
Avner	8783	612
Steve	8784	612
Carl	8785	612
Robert	2406	612
Hans	169	612
Daphna	8786	612
Ephraim	118	612
Avner's Mother	8787	612
Louis	8789	612
Andreas	677	612
Sylvie	5077	612
Yvonne	8790	612
Jeanette	8791	612
Tony	2245	612
Golda Meir	8792	612
General Zamir	8793	612
Papa	2369	612
Mahmoud Hamshari	41316	612
Sgt. J.J. Sefton	8252	632
Lt. James Dunbar	9108	632
Oberst von Scherbach	834	632
Sgt. Stanislaus 'Animal' Kuzawa	7347	632
Sgt. Harry Shapiro	9109	632
Sgt. 'Hoffy' Hoffman	9110	632
Sgt. Frank Price	9111	632
Duke	9112	632
Sgt. Johann Sebastian Schulz	2497	632
Sgt. Manfredi	1511379	632
Sgt. Johnson	34651	632
Joey	1511381	632
Sgt. 'Blondie' Peterson	1511382	632
Marko the Mailman	9113	632
Sgt. Clarence Harvey 'Cookie' Cook	9114	632
Sgt. Bagradian	9115	632
Geneva Man	1195214	632
'Triz' Trzcinski	9099	632
Grigory Vakulinchuk	9609	643
Commander Golikov	9610	643
Chief Officer Giliarovsky	9607	643
Young Sailor	9611	643
Militant Sailor	9727	643
Petty Officer	9728	643
Woman With Baby Carriage	9729	643
Sailor	1308319	643
Odessa Citizen	9603	643
Recruit	86747	643
(uncredited)	275018	643
David	9640	644
Monica Swinton	1518	644
Henry Swinton	8213	644
Martin Swinton	9641	644
Gigolo Joe	9642	644
Prof. Hobby	227	644
Dr. Know (voice)	2157	644
Judah Ben-Hur	10017	665
Quintus Arrius	10018	665
Esther	10019	665
Messala	10020	665
Scheich Ildirim	10021	665
Miriam	10022	665
Tirzah	10023	665
Pontius Pilatus	10025	665
Simonides	10024	665
Malluch	10026	665
Balthasar	10027	665
Sextus	10029	665
Drusus	25687	665
Jewish Slave in the Desert (uncredited)	53660	665
Roman Officer with Messala (uncredited)	15139	665
Flavia (uncredited)	24602	665
Chief of Rowers (uncredited)	10513	665
Guest at Banquet (uncredited)	1090000	665
Galley Officer (uncredited)	39165	665
Gaspar (uncredited)	16055	665
Marius (uncredited)	29659	665
Doctor (uncredited)	14264	665
Captain of Rescue Ship (uncredited)	26557	665
Woman in crowd (uncredited)	14287	665
Man in Nazareth (uncredited)	5404	665
Aide to Tiberius (uncredited)	89064	665
Tiberius Caesar	10028	665
Sportsman (uncredited)	217763	665
Metellus (uncredited)	223601	665
Senator (uncredited)	91817	665
Quaestor (uncredited)	153212	665
Gratus (uncredited)	99514	665
Seaman (uncredited)	82510	665
Roman Soldier Who Brings Crown to Gratus (uncredited)	33820	665
Mary (uncredited)	1046559	665
himself	10275	685
himself	10299	685
himself	10300	685
himself	10301	685
herself	10302	685
himself	10303	685
herself	10304	685
himself	10305	685
herself	10306	685
himself	10307	685
himself	10308	685
himself	10309	685
himself	10310	685
himself	10311	685
himself	10312	685
himself	10313	685
himself	10314	685
himself	245486	685
Eleanor Arroway	1038	686
Palmer Joss	10297	686
Michael Kitz	4512	686
S. R. Hadden	5049	686
David Drumlin	4139	686
Kent Clark	886	686
Elisabeth	6003	742
Rolf	6283	742
Eva	11038	742
Stefan	11039	742
Göran	11040	742
Lena	11041	742
Anna	11042	742
Ted	11043	742
Harry Potter	10980	767
Ron Weasley	10989	767
Hermione Granger	10990	767
Draco Malfoy	10993	767
Molly Weasley	477	767
Professor Horace Slughorn	388	767
Rubeus Hagrid	1923	767
Professor Albus Dumbledore	5658	767
Professor Minerva McGonagall	10978	767
Professor Severus Snape	4566	767
Neville Longbottom	96841	767
Luna Lovegood	140367	767
Cho Chang	234933	767
Fenrir Greyback	60348	767
Lily Potter	10988	767
Ginny Weasley	10991	767
Bellatrix Lestrange	1283	767
Narcissa Malfoy	15737	767
Wormtail	9191	767
George Weasley	140368	767
Fred Weasley	96851	767
Cormac McLaggen	234934	767
Professor Filius Flitwick	11184	767
Argus Filch	11180	767
Remus Lupin	11207	767
Nymphadora Tonks	3300	767
Arthur Weasley	20999	767
Tom Riddle (16 Years)	964834	767
Tom Riddle (11 Years)	1114487	767
Madam Pomfrey	9138	767
Padma Patil	234926	767
Parvati Patil	234925	767
Katie Bell	174398	767
Seamus Finnigan	234922	767
Romilda Vane	234929	767
Dorothy Vallens	6588	793
Jeffrey Beaumont	6677	793
Frank Booth	2778	793
Sandy Williams	4784	793
Mrs. Williams	3382	793
Ben	923	793
Det. John Williams	11792	793
Mrs. Beaumont	11793	793
Aunt Barbara	11794	793
Mike	11796	793
Raymond	1370	793
Paul	6718	793
Hunter	11797	793
Nurse Cindy	11798	793
Mr. Tom Beaumont	1599429	793
Robert Thorn	8487	794
Katherine Thorn	855	794
Keith Jennings	2076	794
David Kessler	14463	814
Nurse Alex Price	14464	814
Jack Goodman	2171	814
Dr. J. S. Hirsch	14465	814
Barmaid	14466	814
Truck Driver	14467	814
Dart Player	939	814
2nd Dart Player	14470	814
Chess Player	14468	814
2nd Chess Player	14469	814
First Werewolf	14471	814
Nurse Susan Gallagher	14472	814
Mr. Collins / Miss Piggy	7908	814
Hospital Porter	14759	814
Inspector Villiers	178097	814
Sergeant McManus	199977	814
Benjamin	1660002	814
Kermit the Frog (archive footage)	55983	814
Rachel Kessler	1660000	814
Max Kessler	1319052	814
Mr. Kessler	185033	814
Mrs. Kessler	1220068	814
Creepy Little Girl	1660009	814
Creepy Little Girl	1660013	814
Naughty Nina	1660014	814
Harry Berman	1226747	814
Judith Browns	1587192	814
Sean	1660018	814
Sean's Wife	1641515	814
Sister Hobbs	1328287	814
Alf	12693	814
Ted	299082	814
Joseph	1660159	814
Usher	1660178	814
Gerald Bringsley	199055	814
Hans Beckert	2094	832
Frau Beckmann	12322	832
Elsie Beckmann	12323	832
Inspector Karl Lohmann	12324	832
Inspector Groeber	79	832
Schränker	12325	832
Franz, der Dieb	12326	832
Falschspieler	28068	832
Taschendieb	219738	832
Bauernfänger	28066	832
Kriminalsekretär	2913	832
Umberto Domenico Ferrari	12336	833
Antonia, la padrona di case	12338	833
La donna nella camera di Umberto	12339	833
La suora all' ospedale	12340	833
Il degente all' ospedale	12341	833
L'amico di Antonia (uncredited)	1336866	833
(uncredited)	42416	833
Maria	224209	833
Eddie Valiant	382	856
Judge Doom	1062	856
Dolores	593	856
Roger Rabbit/Benny The Cab/Greasy/Psycho	12826	856
Jessica Rabbit	3391	856
Marvin Acme	12827	856
R.K. Maroon	12828	856
Lt. Santino	12829	856
Baby Herman	12830	856
Jessica's Performance Model	12831	856
Bugs Bunny/Daffy Duck/Tweety Bird	33923	856
Betty Boop	58530	856
Singer	4347	856
Droopy	116100	856
Mickey Mouse	78076	856
Dumbo	15831	856
Johanna	13534	882
Robert	13535	882
Alex	13536	882
Harald	13537	882
Opa	13538	882
Else	13539	882
Eva	13540	882
Heinz	13541	882
Ulf	13542	882
Leutnant	13543	882
Roberto	4818	883
Steven	3214	883
Good Twin	13602	883
Evil Twin	13603	883
Kellner	884	883
Iggy	13604	883
Tom	2887	883
Joe	13605	883
Vinny	7168	883
Egbert Sousé	13954	911
Agatha Sousé	13962	911
Myrtle Sousé	13963	911
Elsie Mae Adele Brunch Sousé	13964	911
Mrs. Hermisillo Brunch	13965	911
J. Pinkerton Snoopington	13966	911
Joe Guelpe, Bartender	13967	911
Og Oggilby	13968	911
J. Frothingham Waterbury	13969	911
Mackley Q. Greene	13970	911
Mr. Skinner	30216	911
Filthy McNasty	600741	911
Cozy Cochran	103621	911
Otis	102069	911
A. Pismo Clam	120741	911
Assistant Director	30243	911
Francois	34046	911
Miss Plupp	149081	911
Doctor Stall	34238	911
Mr. Cheek (as Bill Alston)	1291801	911
Reporter (uncredited)	33179	911
Lompoc Ladies Auxiliary (uncredited)	981098	911
Francois' Valet	1181440	911
Secretary / Stenographer	103623	911
Old Lady with Dog	1271033	911
Girl	1301730	911
Secretary	1671409	911
Boy	1671411	911
Cop	1492406	911
Young Man	1317082	911
Bank Employee	1671412	911
Boy	78086	911
Mrs. Muckle - Mother in Bank	544971	911
James the Chauffeur	133342	911
Woman	115366	911
Group Capt. Lionel Mandrake / President Merkin Muffley / Dr. Strangelove	12446	935
General "Buck" Turgidson	862	935
Brigadier General Jack D. Ripper	3088	935
Colonel Bat Guano	4966	935
Major "King" Kong	14253	935
Botschafter De Sadesky	6600	935
Lt. Lothar Zogg	15152	935
Miss Scott	126354	935
Mr. Staines	12485	935
Lt. Dietrich	1332529	935
Adm. Randolph	1236452	935
Lt. Kivel	948173	935
Frank	1332531	935
Capt. 'Ace' Owens	10657	935
Burpelson AFB Defense Team Member	186212	935
Lt. Goldberg	185044	935
Burpelson AFB Defense Team Member	1332532	935
Burpelson AFB Defense Team Member	1063405	935
Gen. Faceman	117301	935
Mandrake' aide (uncredited)	184980	935
War Room Aide (uncredited)	1556340	935
Lt. Vincent Hanna	1158	949
Neil McCauley	380	949
Chris Shiherlis	5576	949
Nate	10127	949
Michael Cheritto	3197	949
Justine Hanna	6200	949
Eady	15851	949
Charlene Shiherlis	15852	949
Sergeant Drucker	34	949
Detective Casals	15853	949
Bosko	15854	949
Donald Breedan	352	949
Roger Van Zant	886	949
Lauren Gustafson	524	949
Kelso	119232	949
Richard Torena	31004	949
Alan Marciano	5587	949
Waingro	34839	949
Elaine Cheritto	4158	949
Lillian	17358	949
Trejo	11160	949
Hugh Benny	9290	949
Schwartz	86602	949
Construction Clerk	4790	949
Albert Torena	158452	949
Anna Trejo	181343	949
Hooker's Mother	91756	949
Timmons	160970	949
Dr. Bob	12799	949
Ralph	3982	949
Armoured Guard	81687	949
Children's Hospital Doctor	1090464	949
Dominick	1090465	949
Shooter at Drive-in	175600	949
Driver at Drive-in	12879	949
Col. Dax	2090	975
Cpl. Philippe Paris	14562	975
Gen. George Broulard	14563	975
Gen. Paul Mireau	14564	975
Lt. Roget/Singing man	14565	975
Maj. Saint-Auban	12312	975
Pvt. Pierre Arnaud	592	975
Pvt. Maurice Ferol	2758	975
German Singer	1019259	975
Proprietor of Cafe	117671	975
Narrator of Opening Sequence	3476	975
Father Dupree	14579	975
Sgt. Boulanger	31503	975
Pvt. Lejeune	94031	975
Shell-Shocked Soldier	1077968	975
Capt. Rousseau	1077970	975
Capt. Nichols	1077971	975
Maj. Gouderc (uncredited)	49435	975
Private in the Attack (uncredited)	3349	975
\.


--
-- TOC entry 2234 (class 0 OID 45447)
-- Dependencies: 197
-- Data for Name: country; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY country (country_id, name) FROM stdin;
FI	Finland
FR	France
US	United States of America
GB	United Kingdom
JP	Japan
ES	Spain
AU	Australia
AT	Austria
DE	Germany
IT	Italy
CA	Canada
RU	Russia
SE	Sweden
\.


--
-- TOC entry 2230 (class 0 OID 45418)
-- Dependencies: 193
-- Data for Name: crew; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY crew (person_id, movie_id, job_name) FROM stdin;
16767	2	Screenplay
16767	2	Director
16769	2	Director of Photography
54766	2	Editor
53836	2	Production Design
54771	2	Costume Design
16767	3	Director
16767	3	Screenplay
545412	3	Camera Operator
54766	3	Editor
54767	3	Producer
1084614	3	Art Direction
1084612	3	Art Direction
16769	3	Compositors
59	18	Director
60	18	Producer
61	18	Screenplay
996	18	Original Music Composer
998	18	Editor
1113	18	Casting
1000	18	Production Design
8378	18	Art Direction
8379	18	Art Direction
8380	18	Art Direction
4475	38	Editor
201	38	Director
312	38	Original Music Composer
313	38	Director of Photography
321	38	Producer
322	38	Producer
4340	38	Camera Operator
202	38	Screenplay
202	38	Story
201	38	Story
222	38	Story
7496	38	Production Design
546	38	Casting
33439	38	Costume Design
608	81	Director
608	81	Author
627	81	Producer
628	81	Producer
629	81	Director of Photography
630	81	Director of Photography
631	81	Casting
632	81	Editor
633	81	Editor
634	81	Editor
635	81	Sound Director
608	81	Editor
636	81	Original Music Composer
608	81	Screenplay
631	81	Producer
1131668	81	Executive Producer
1131693	81	Executive Producer
19595	81	Executive Producer
549551	81	Art Direction
1090	106	Director
1091	106	Producer
1092	106	Producer
1093	106	Producer
1092	106	Author
1094	106	Author
1095	106	Director of Photography
37	106	Original Music Composer
1096	106	Production Design
1097	106	Casting
1098	106	Editor
1099	106	Editor
7719	106	Costume Design
1884	161	Director
1885	161	Author
1886	161	Screenplay
1887	161	Author
1888	161	Producer
1884	161	Director of Photography
1889	161	Original Music Composer
1890	161	Production Design
495	161	Casting
1891	161	Editor
1629525	161	Driver
1629533	161	Stand In
1296	161	Executive Producer
57295	161	Executive Producer
1749	168	Director
1791	168	Producer
2019	168	Screenplay
2020	168	Screenplay
1791	168	Screenplay
1788	168	Screenplay
9614	168	Director of Photography
2024	168	Art Direction
2025	168	Art Direction
2026	168	Art Direction
796	168	Set Decoration
1801	168	Costume Design
2027	168	Original Music Composer
2031	168	Casting
2032	168	Production Design
2026	168	Production Design
2033	168	Editor
2388	200	Director
2381	200	Producer
2504	200	Executive Producer
2383	200	Producer
2514	200	Producer
2387	200	Producer
2514	200	Screenplay
2507	200	Director of Photography
2508	200	Art Direction
796	200	Set Decoration
2519	200	Costume Design
1760	200	Original Music Composer
2522	200	Additional Soundtrack
2083	200	Production Design
2399	200	Casting
2400	200	Casting
2033	200	Editor
1319747	200	Costume Supervisor
2397	200	Costume Design
1551320	200	Sound Recordist
309	219	Director
309	219	Author
93	219	Producer
952	219	Executive Producer
405	219	Original Music Composer
4376	219	Director of Photography
413	219	Editor
4378	219	Casting
4379	219	Production Design
3045	236	Director
3046	236	Producer
3047	236	Producer
9344	236	Art Direction
3048	236	Original Music Composer
3049	236	Director of Photography
3050	236	Editor
3108	236	Casting
3109	236	Production Design
672646	236	Associate Producer
1322883	236	Associate Producer
3045	236	Writer
1650	258	Director
1650	258	Author
3531	258	Author
3532	258	Author
1650	258	Producer
3524	258	Producer
3529	258	Original Music Composer
3722	276	Director
3927	276	Producer
3928	276	Producer
3929	276	Producer
3722	276	Author
3931	276	Author
3871	276	Director of Photography
3940	276	Director of Photography
3941	276	Original Music Composer
3879	276	Editor
3941	276	Editor
3943	276	Casting
3944	276	Casting
3722	276	Producer
7213	296	Director
7214	296	Screenplay
7215	296	Screenplay
7227	296	Producer
7228	296	Producer
3986	296	Producer
7229	296	Original Music Composer
36	296	Director of Photography
7230	296	Editor
7231	296	Editor
7232	296	Casting
7233	296	Production Design
7234	296	Art Direction
7235	296	Art Direction
7236	296	Art Direction
7237	296	Set Decoration
7238	296	Costume Design
1305	296	Music Editor
7239	296	Sound Effects Editor
7240	296	Boom Operator
4385	311	Director
1304	311	Costume Design
4656	311	Special Effects
4657	311	Special Effects
4658	311	Special Effects
4760	333	Director
2303	390	Director
2303	390	Screenplay
2303	390	Producer
5267	390	Producer
5268	390	Producer
5269	390	Line Producer
2308	390	Original Music Composer
5270	390	Art Direction
5271	390	Director of Photography
2309	390	Editor
5272	390	Editor
5273	390	Special Effects
5572	414	Director
5573	414	Story
5574	414	Story
3794	414	Characters
5575	414	Screenplay
510	414	Producer
5580	414	Producer
5581	414	Original Music Composer
5582	414	Director of Photography
5583	414	Editor
5584	414	Editor
1262	414	Casting
5585	414	Production Design
406204	414	Makeup Artist
1115051	414	Associate Producer
5917	438	Director
5917	438	Author
5928	438	Producer
5929	438	Producer
5930	438	Original Music Composer
5931	438	Director of Photography
5932	438	Editor
5933	438	Editor
5934	438	Casting
5929	438	Production Design
933333	438	Casting
957026	438	Costume Design
1415136	438	Hairstylist
1415173	438	Makeup Artist
1415174	438	Makeup Effects
1415175	438	Production Manager
1415176	438	Assistant Art Director
1407243	438	Assistant Art Director
170353	438	Construction Coordinator
1415177	438	Set Designer
1415178	438	Scenic Artist
1415181	438	Scenic Artist
1375604	438	Dialogue Editor
6241	459	Director
6241	459	Screenplay
6241	459	Producer
6242	459	Producer
6243	459	Original Music Composer
6244	459	Director of Photography
6245	459	Editor
6813	459	Production Design
6813	459	Set Decoration
6247	459	Costume Design
6248	459	Costume Design
6521	481	Director
6522	481	Screenplay
6521	481	Screenplay
6524	481	Producer
6525	481	Executive Producer
6526	481	Original Music Composer
6527	481	Original Music Composer
6528	481	Director of Photography
6529	481	Editor
6530	481	Casting
6531	481	Casting
6532	481	Art Direction
6533	481	Costume Design
6884	504	Director
6884	504	Screenplay
6885	504	Producer
6887	504	Producer
6888	504	Producer
6889	504	Producer
6891	504	Executive Producer
6892	504	Executive Producer
6893	504	Executive Producer
6894	504	Executive Producer
6895	504	Executive Producer
6896	504	Producer
6897	504	Producer
6898	504	Original Music Composer
6899	504	Director of Photography
800	504	Editor
6900	504	Editor
2045	504	Casting
6901	504	Production Design
6902	504	Art Direction
6903	504	Set Decoration
6904	504	Costume Design
6890	504	Producer
113844	504	Music Supervisor
1534687	504	Music Editor
6094	523	Director
7149	523	Screenplay
6096	523	Director of Photography
5195	523	Editor
7150	523	Editor
7151	523	Sound Designer
6094	523	Producer
6097	523	Set Designer
4557	523	Executive Producer
7212	523	Costume Design
7501	551	Director
6855	551	Novel
844	551	Screenplay
6779	551	Screenplay
7506	551	Producer
7507	551	Producer
7508	551	Producer
491	551	Original Music Composer
7509	551	Director of Photography
7510	551	Editor
7511	551	Casting
7512	551	Production Design
7513	551	Set Decoration
6295	570	Director
6295	570	Screenplay
7695	570	Producer
7700	570	Producer
7701	570	Editor
7702	570	Production Design
7704	570	Sound
20572	570	Director of Photography
1647226	570	Casting
1647227	570	Casting
16932	570	Casting
1476491	570	Casting
7703	570	Casting
1267834	570	Set Decoration
1647229	570	Set Decoration
1647230	570	Set Decoration
1647231	570	Set Decoration
1647232	570	Set Decoration
1647233	570	Set Decoration
552348	570	Set Decoration
7297	570	Costume Design
20597	570	Costume Design
1647235	570	Production Manager
6159	591	Director
5575	591	Screenplay
8406	591	Producer
8404	591	Executive Producer
339	591	Producer
6184	591	Executive Producer
6159	591	Producer
6186	591	Producer
6188	591	Producer
947	591	Original Music Composer
8408	591	Director of Photography
6189	591	Editor
6190	591	Editor
2874	591	Casting
1325	591	Casting
7732	591	Production Design
7787	591	Art Direction
1031561	612	Casting
1312252	612	Casting
474	612	Casting
488	612	Director
489	612	Producer
488	612	Producer
5664	612	Producer
8780	612	Screenplay
491	612	Original Music Composer
492	612	Director of Photography
493	612	Editor
496	612	Production Design
8794	612	Art Direction
8795	612	Art Direction
498	612	Costume Design
3146	632	Writer
9098	632	Theatre Play
9099	632	Theatre Play
3146	632	Screenplay
3146	632	Producer
9103	632	Director of Photography
2655	632	Editor
9104	632	Art Direction
5188	632	Art Direction
7687	632	Set Decoration
7688	632	Set Decoration
7689	632	Makeup Artist
9100	632	Writer
3146	632	Director
8619	632	Original Music Composer
9101	632	Associate Producer
9603	643	Director
9604	643	Producer
9605	643	Director of Photography
9607	643	Editor
9603	643	Editor
9608	643	Art Direction
2793	643	Original Music Composer
9606	643	Director of Photography
947665	643	Writer
9603	643	Screenplay
9607	643	Assistant Director
10139	685	Director
10139	685	Screenplay
10139	685	Producer
10139	685	Editor
10145	685	Original Music Composer
5602	793	Director
5602	793	Screenplay
11789	793	Producer
11790	793	Executive Producer
5628	793	Original Music Composer
4434	793	Director of Photography
6592	793	Editor
8971	793	Casting
3686	793	Casting
5634	793	Production Design
11791	793	Set Decoration
68	832	Director
68	832	Screenplay
157	832	Screenplay
9836	832	Director of Photography
11578	832	Editor
12319	832	Art Direction
12320	832	Art Direction
12321	832	Sound Designer
13902	832	Producer
24	856	Director
12821	856	Novel
12100	856	Screenplay
12101	856	Screenplay
12824	856	Producer
489	856	Executive Producer
664	856	Producer
488	856	Executive Producer
30	856	Producer
711	856	Producer
37	856	Original Music Composer
1060	856	Director of Photography
38	856	Editor
12825	856	Production Design
715	856	Production Design
498	856	Costume Design
1143354	856	Script Supervisor
1450331	856	Animation
13527	882	Director
13527	882	Screenplay
13529	882	Producer
13531	882	Music
13532	882	Music
5639	882	Director of Photography
13533	882	Editor
13544	882	Producer
13545	882	Sound Designer
13546	882	Production Design
240	935	Director
240	935	Screenplay
8950	935	Screenplay
14250	935	Screenplay
240	935	Producer
257	935	Producer
14251	935	Executive Producer
14252	935	Original Music Composer
7753	935	Director of Photography
12009	935	Editor
9869	935	Production Design
14250	935	Novel
9918	935	Art Direction
240	975	Director
14554	975	Novel
240	975	Screenplay
240	975	Producer
10769	975	Screenplay
3335	975	Screenplay
2090	975	Producer
3349	975	Producer
3350	975	Original Music Composer
14555	975	Director of Photography
14556	975	Editor
14557	975	Art Direction
11926	975	Costume Design
\.


--
-- TOC entry 2224 (class 0 OID 45370)
-- Dependencies: 187
-- Data for Name: department; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY department (department_id, name) FROM stdin;
0	Writing
1	Directing
2	Actors
3	Camera
4	Editing
5	Art
6	Costume & Make-Up
7	Production
8	Sound
9	Visual Effects
10	Crew
11	Lighting
\.


--
-- TOC entry 2226 (class 0 OID 45386)
-- Dependencies: 189
-- Data for Name: genre; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY genre (genre_id, name) FROM stdin;
28	Action
12	Adventure
16	Animation
35	Comedy
80	Crime
99	Documentary
18	Drama
10751	Family
14	Fantasy
36	History
27	Horror
10402	Music
9648	Mystery
10749	Romance
878	Science Fiction
10770	TV Movie
53	Thriller
10752	War
37	Western
10769	Foreign
\.


--
-- TOC entry 2225 (class 0 OID 45378)
-- Dependencies: 188
-- Data for Name: job; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY job (job_name, department_id) FROM stdin;
Screenplay	0
Author	0
Novel	0
Characters	0
Theatre Play	0
Adaptation	0
Dialogue	0
Writer	0
Other	0
Storyboard	0
Original Story	0
Scenario Writer	0
Screenstory	0
Musical	0
Idea	0
Story	0
Creative Producer	0
Teleplay	0
Opera	0
Co-Writer	0
Book	0
Comic Book	0
Short Story	0
Series Composition	0
Script Editor	0
Script Consultant	0
Story Editor	0
Director	1
Script Supervisor	1
Layout	1
Script Coordinator	1
Special Guest Director	1
Assistant Director	1
Co-Director	1
Continuity	1
First Assistant Director	1
Second Assistant Director	1
Third Assistant Director	1
Actor	2
Stunt Double	2
Voice	2
Cameo	2
Special Guest	2
Director of Photography	3
Underwater Camera	3
Camera Operator	3
Still Photographer	3
Camera Department Manager	3
Camera Supervisor	3
Camera Technician	3
Grip	3
Steadicam Operator	3
Additional Camera	3
Camera Intern	3
Additional Photography	3
Helicopter Camera	3
First Assistant Camera	3
Additional Still Photographer	3
Aerial Camera	3
Aerial Camera Technician	3
Aerial Director of Photography	3
Camera Loader	3
Dolly Grip	3
Epk Camera Operator	3
Key Grip	3
Russian Arm Operator	3
Second Unit Director of Photography	3
Ultimate Arm Operator	3
Underwater Director of Photography	3
Editor	4
Supervising Film Editor	4
Additional Editing	4
Editorial Manager	4
First Assistant Editor	4
Additional Editorial Assistant	4
Editorial Coordinator	4
Editorial Production Assistant	4
Editorial Services	4
Dialogue Editor	4
Archival Footage Coordinator	4
Archival Footage Research	4
Color Timer	4
Digital Intermediate	4
Assistant Editor	4
Associate Editor	4
Co-Editor	4
Negative Cutter	4
Production Design	5
Art Direction	5
Set Decoration	5
Set Designer	5
Conceptual Design	5
Interior Designer	5
Settings	5
Assistant Art Director	5
Art Department Coordinator	5
Assistant Property Master	5
Art Department Manager	5
Sculptor	5
Art Department Assistant	5
Background Designer	5
Co-Art Director	5
Set Decoration Buyer	5
Production Illustrator	5
Standby Painter	5
Property Master	5
Location Scout	5
Supervising Art Director	5
Leadman	5
Greensman	5
Gun Wrangler	5
Construction Coordinator	5
Construction Foreman	5
Lead Painter	5
Sign Painter	5
Painter	5
Assistant Set Dresser	5
Conceptual Illustrator	5
Draughtsman	5
Lead Set Dresser	5
Prop Designer	5
Set Decorating Coordinator	5
Set Dresser	5
Storyboard Designer	5
Title Designer	5
Costume Design	6
Makeup Artist	6
Hairstylist	6
Set Dressing Artist	6
Set Dressing Supervisor	6
Set Dressing Manager	6
Set Dressing Production Assistant	6
Facial Setup Artist	6
Hair Setup	6
Costume Supervisor	6
Set Costumer	6
Makeup Department Head	6
Wigmaker	6
Shoe Design	6
Co-Costume Designer	6
Hair Department Head	6
Hair Designer	6
Makeup Designer	6
Assistant Costume Designer	6
Prosthetic Supervisor	6
Seamstress	6
Key Hair Stylist	6
Ager/Dyer	6
Costume Consultant	6
Costume Coordinator	6
Costume Illustrator	6
Hair Supervisor	6
Key Costumer	6
Key Makeup Artist	6
Key Set Costumer	6
Makeup Effects Designer	6
Makeup Supervisor	6
Prosthetic Designer	6
Prosthetic Makeup Artist	6
Tailor	6
Tattoo Designer	6
Wardrobe Supervisor	6
Wig Designer	6
Producer	7
Executive Producer	7
Casting	7
Production Manager	7
Unit Production Manager	7
Line Producer	7
Location Manager	7
Production Supervisor	7
Production Accountant	7
Production Office Coordinator	7
Finance	7
Executive Consultant	7
Character Technical Supervisor	7
Development Manager	7
Administration	7
Executive In Charge Of Post Production	7
Production Director	7
Executive In Charge Of Production	7
Publicist	7
Associate Producer	7
Co-Producer	7
Co-Executive Producer	7
Casting Associate	7
Researcher	7
Production Coordinator	7
Consulting Producer	7
Supervising Producer	7
Senior Executive Consultant	7
Unit Manager	7
ADR Voice Casting	7
Assistant Production Coordinator	7
Assistant Production Manager	7
Casting Assistant	7
Casting Consultant	7
Coordinating Producer	7
Local Casting	7
Script Researcher	7
Original Music Composer	8
Sound Designer	8
Sound Editor	8
Sound Director	8
Sound Mixer	8
Music Editor	8
Sound Effects Editor	8
Production Sound Mixer	8
Additional Soundtrack	8
Supervising Sound Editor	8
Supervising Sound Effects Editor	8
Sound Re-Recording Mixer	8
Recording Supervision	8
Boom Operator	8
Sound Montage Associate	8
Songs	8
Music	8
ADR & Dubbing	8
Sound Recordist	8
Sound Engineer	8
Foley	8
Additional Music Supervisor	8
First Assistant Sound Editor	8
Scoring Mixer	8
Dolby Consultant	8
Music Director	8
Orchestrator	8
Vocal Coach	8
Music Supervisor	8
Sound	8
Musician	8
Additional Sound Re-Recording Mixer	8
Additional Sound Re-Recordist	8
ADR Editor	8
ADR Supervisor	8
Apprentice Sound Editor	8
Assistant Music Supervisor	8
Assistant Sound Editor	8
Conductor	8
Foley Editor	8
Music Programmer	8
Music Score Producer	8
Playback Singer	8
Sound Effects	8
Sound Effects Designer	8
Supervising ADR Editor	8
Supervising Dialogue Editor	8
Supervising Music Editor	8
Theme Song Performance	8
Utility Sound	8
Animation	9
Visual Effects	9
Chief Technician / Stop-Motion Expert	9
Creature Design	9
Shading	9
Modeling	9
CG Painter	9
Visual Development	9
Animation Manager	9
Animation Director	9
Fix Animator	9
Animation Department Coordinator	9
Animation Fix Coordinator	9
Animation Production Assistant	9
Visual Effects Supervisor	9
Mechanical & Creature Designer	9
Battle Motion Coordinator	9
Animation Supervisor	9
VFX Supervisor	9
Cloth Setup	9
VFX Artist	9
CG Engineer	9
24 Frame Playback	9
Imaging Science	9
I/O Supervisor	9
Visual Effects Producer	9
VFX Production Coordinator	9
I/O Manager	9
Additional Effects Development	9
Color Designer	9
Simulation & Effects Production Assistant	9
Simulation & Effects Artist	9
Pyrotechnic Supervisor	9
Special Effects Supervisor	9
3D Supervisor	9
3D Director	9
Digital Compositors	9
Visual Effects Coordinator	9
VFX Editor	9
2D Artist	9
2D Supervisor	9
3D Animator	9
3D Artist	9
3D Coordinator	9
3D Generalist	9
3D Modeller	9
3D Sequence Supervisor	9
3D Tracking Layout	9
CG Animator	9
CGI Director	9
Character Designer	9
Character Modelling Supervisor	9
Creature Technical Director	9
Digital Effects Producer	9
Key Animation	9
Lead Animator	9
Lead Character Designer	9
Matchmove Supervisor	9
Mechanical Designer	9
Opening/Ending Animation	9
Pre-Visualization Supervisor	9
Roto Supervisor	9
Stereoscopic Coordinator	9
VFX Director of Photography	9
VFX Lighting Artist	9
Visual Effects Designer	9
Visual Effects Technical Director	9
Special Effects	10
Post Production Supervisor	10
Second Unit	10
Choreographer	10
Stunts	10
Stunt Coordinator	10
Special Effects Coordinator	10
Supervising Technical Director	10
Supervising Animator	10
Production Artist	10
Sequence Leads	10
Second Film Editor	10
Temp Music Editor	10
Temp Sound Editor	10
Sequence Supervisor	10
Software Team Lead	10
Software Engineer	10
Documentation & Support	10
Machinist	10
Photoscience Manager	10
Department Administrator	10
Schedule Coordinator	10
Supervisor of Production Resources	10
Production Office Assistant	10
Information Systems Manager	10
Systems Administrators & Support	10
Projection	10
Post Production Assistant	10
Sound Design Assistant	10
Mix Technician	10
Motion Actor	10
Sets & Props Supervisor	10
Compositors	10
Tattooist	10
Sets & Props Artist	10
Motion Capture Artist	10
Sequence Artist	10
Mixing Engineer	10
Special Sound Effects	10
Post-Production Manager	10
Dialect Coach	10
Picture Car Coordinator	10
Cableman	10
Set Production Assistant	10
Video Assist Operator	10
Unit Publicist	10
Set Medic	10
Stand In	10
Transportation Coordinator	10
Transportation Captain	10
Post Production Consulting	10
Production Intern	10
Utility Stunts	10
Actor's Assistant	10
Set Production Intern	10
Production Controller	10
Studio Teachers	10
Chef	10
Craft Service	10
Scenic Artist	10
Propmaker	10
Prop Maker	10
Transportation Co-Captain	10
Driver	10
Security	10
Second Unit Cinematographer	10
Loader	10
Manager of Operations	10
Quality Control Supervisor	10
Legal Services	10
Public Relations	10
Score Engineer	10
Translator	10
Title Graphics	10
Telecine Colorist	10
Animatronic and Prosthetic Effects	10
Martial Arts Choreographer	10
Cinematography	10
Steadycam	10
Executive Visual Effects Producer	10
Visual Effects Design Consultant	10
Digital Effects Supervisor	10
Digital Producer	10
CG Supervisor	10
Visual Effects Art Director	10
Visual Effects Editor	10
Executive in Charge of Finance	10
Associate Choreographer	10
Makeup Effects	10
Treatment	10
Dramaturgy	10
Lighting Camera	10
Technical Supervisor	10
CGI Supervisor	10
Creative Consultant	10
Script	10
Executive Music Producer	10
Commissioning Editor	10
Additional Writing	10
Additional Music	10
Poem	10
Thanks	10
Creator	10
Additional Dialogue	10
Video Game	10
Graphic Novel Illustrator	10
Series Writer	10
Radio Play	10
Armorer	10
Carpenter	10
Editorial Staff	10
Aerial Coordinator	10
Animal Coordinator	10
Animal Wrangler	10
Animatronics Designer	10
Drone Operator	10
In Memory Of	10
Pilot	10
Presenter	10
Animatronics Supervisor	10
Armory Coordinator	10
Fight Choreographer	10
Marine Coordinator	10
Pyrotechnician	10
Techno Crane Operator	10
Lighting Technician	11
Best Boy Electric	11
Gaffer	11
Rigging Gaffer	11
Lighting Supervisor	11
Lighting Manager	11
Directing Lighting Artist	11
Master Lighting Artist	11
Lighting Artist	11
Lighting Coordinator	11
Lighting Production Assistant	11
Best Boy Electrician	11
Electrician	11
Rigging Grip	11
Chief Lighting Technician	11
Lighting Director	11
Rigging Supervisor	11
Underwater Gaffer	11
\.


--
-- TOC entry 2227 (class 0 OID 45394)
-- Dependencies: 190
-- Data for Name: member; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY member (member_login, email, password_hash) FROM stdin;
N7ZLC5KXCJ	FQQFP@I64H	7ddd4cf42a5612c4e8f509ca7fd0e772
98DH79U5RR	SIN1Q@K8PV	3ca5f695c28d26bae8e4d5f8d6cff8d5
LMV5KHMJIQ	BMPNY@TI9U	ad1de6555d375379d10912181668f9c9
BKEZFGXSRI	XAZ9T@U1KQ	cd4f0a221ffabc26f5206e70085c09f3
PIW2O1HZHS	QB107@5S6I	f56e00293f9b72ef1e2f39ac3b42c493
LRYG3OO7V2	V4U29@8UH3	e8b1e2b06d15fbbdea732ccdde41139a
0I32H8MU6T	U86DX@QBGX	8a9203b0a2891bf5bdb8ceefb69da39d
98YTCMB2VA	TNXYJ@QG7K	77fbc39bc692c9d344ad50e8fd7cb40f
0IIQTWJMBK	SYPFE@1C2X	3f6ed71d3c15d180d8c15c11f0019f69
5KUMKKEHEX	XDFX2@8DQW	c54bc3afbf475b66a55d9c4e74bddaad
7FQKPIDC53	5U7FA@6SIJ	84ca6b9165a0ae7ccfc3663f906bf091
I6JF0RW5IU	F5IX0@Q2SK	0c6753304d7360a9fd6d1abc782acdc9
5CPJU9L2PT	2BKYE@M9TJ	f5ca65d7ffd1b6667bc8d39f9088e178
8P3KYCP9C1	WYN9R@IKUW	88b84168e5ed2bafe083e295984fd9ac
B09BUMIAAB	KN61W@GS4E	a809c9263560d73560521dca883ccf54
SMUHZ6ZLPE	QIKSL@X5FV	7a1ffd2455b4699794f8e064b3f73201
UIXWT83ZC0	W4D0X@MS41	384ede11664922408d22876a16d788c7
G6YJUIUX8N	383O8@8SWH	6e16276ed7ff156a280c9115ffb6e9bc
4T71U0G3GP	XYUQ8@EQ38	bc8231fc0188a84904b4a696db69e8b8
5ZJ4TJAB4I	DFMHT@XR6U	c85566f75fc77c321020474586e083a5
\.


--
-- TOC entry 2229 (class 0 OID 45410)
-- Dependencies: 192
-- Data for Name: movie; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie (movie_id, release_date, status, revenue, poster_url, title, vote_average) FROM stdin;
81	1984-03-11	Released	3301446	/y2rl0OkMfZHpBaQYPfSJmLMOxwp.jpg	Nausicaä of the Valley of the Wind	5
551	1972-12-01	Released	84563118	/3Ypk0OLrECSp7tqQFLMppGBrHfo.jpg	The Poseidon Adventure	4.94999981
767	2009-07-07	Released	933959197	/bFXys2nhALwDvpkF3dP3Vvdfn8b.jpg	Harry Potter and the Half-Blood Prince	5.0999999
643	1925-12-24	Released	45100	/A5kk0FA4kS9sHLYzC6NI72OOhPc.jpg	Battleship Potemkin	4.3499999
189	2014-08-20	Released	39407616	/k80qKrJ0qQ6ocVo5N932stNSg6j.jpg	Sin City: A Dame to Kill For	5.3499999
258	1970-08-31	Released	0	/x0IRPIQsjESTJaxwKlwNZof8siG.jpg	Bed and Board	5
38	2004-03-19	Released	72258126	/7y3eYvTsGjxPYDtSnumCLIMDkrV.jpg	Eternal Sunshine of the Spotless Mind	4.94999981
460	2005-01-06	Released	0	/vSkpSVJwp2R5DDcGNDmgV83uLO8.jpg	Go for Zucker	4.80000019
2	1988-10-21	Released	0	/gZCJZOn4l0Zj5hAxsMbxoS6CL0u.jpg	Ariel	4.6500001
524	1995-11-22	Released	116112375	/xo517ibXBDdYQY81j0WIG7BVcWq.jpg	Casino	5.05000019
632	1953-05-29	Released	0	/vyXFk2b6X4cEBJvKMBoi3fdlFgC.jpg	Stalag 17	4.3499999
161	2001-12-07	Released	450717150	/o0h76DVXvk5OKjmNez5YY0GODC2.jpg	Ocean's Eleven	4.5999999
106	1987-06-11	Released	98235548	/bj7A0teF2TWxxNGZjWTXiGrvCu2.jpg	Predator	5.1500001
665	1959-12-26	Released	146900000	/syPMBvvZsADTTRu3UKuxO1Wflq.jpg	Ben-Hur	5.94999981
482	1971-07-02	Released	12121618	/ez5aGeyOvG2F1QzKYHzkMmkDuM2.jpg	Shaft	4.44999981
390	1994-12-16	Released	0	/4qidXmPSVgUtM0LLBTduwNTDbKN.jpg	Lisbon Story	4.6500001
236	1994-09-29	Released	15119639	/qoZShHm8QTrHAR80LypwI0SYp8I.jpg	Muriel's Wedding	4.55000019
363	2004-03-11	Released	11030861	/pWtiFfRGADUv9s4bqgKWSqdVxk9.jpg	Head-On	4
296	2003-07-02	Released	435000000	/lz4xYdF1n09lyiCfZWtWT44SZiG.jpg	Terminator 3: Rise of the Machines	5.55000019
62	1968-04-05	Released	68700000	/90T7b2LIrL07ndYQBmSm09yqVEH.jpg	2001: A Space Odyssey	5.0999999
3	1986-10-16	Released	0	/7ad4iku8cYBuB08g9yAU7tHJik5.jpg	Shadows in Paradise	5
333	2002-01-01	Released	0	/n8J2PfCcgErDWSMhjdmJBBmQIDY.jpg	Bollywood - Hollywood	4.5
200	1998-12-10	Released	118000000	/sQdiBAMZ8mq9Eb9fQX1Z7HZHUVs.jpg	Star Trek: Insurrection	5
201	2002-12-12	Released	67312826	/n4TpLWPi062AofIq4kwmaPNBSvA.jpg	Star Trek: Nemesis	6.0999999
414	1995-05-31	Released	336529144	/eTMrHEhlFPHNxpqGwpGGTdAa0xV.jpg	Batman Forever	4.1500001
107	2000-09-01	Released	83557872	/on9JlbGEccLsYkjeEph2Whm1DIp.jpg	Snatch	3.70000005
276	2004-10-25	Released	0	/jmjX2tV91uU6GBKUAx3otsYgMBG.jpg	The Edukators	5.69999981
168	1986-11-25	Released	133000000	/62nATuMKuaLhd5VHKumHOrJnCZa.jpg	Star Trek IV: The Voyage Home	4.9000001
169	1990-11-20	Released	57120318	/zvliTkCns7f37iUeedDdo7rFyYH.jpg	Predator 2	5.80000019
644	2001-06-29	Released	235926552	/sbQofoGqJ6AqayGKorNgXjIYEZO.jpg	A.I. Artificial Intelligence	5.19999981
612	2005-12-22	Released	130358911	/3pnsX1egUElYvgmAcCqYvXVOY9O.jpg	Munich	6.0999999
18	1997-05-07	Released	263920180	/zaFa1NRZEnFgRTv5OVXkNIZO78O.jpg	The Fifth Element	5.19999981
459	1957-12-18	Released	0	/kfdkl2YbZdsgnnlcJ5MHYyddR0E.jpg	Sissi: The Fateful Years of an Empress	5.0999999
237	2003-09-26	Released	2500000	/eZDKfjjI5IhqKCOLHonTvKpPnNr.jpg	Young Adam	5.30000019
833	1952-01-20	Released	0	/zwslsX98Hp4GyJGoVI4mZMU9mDO.jpg	Umberto D.	4.94999981
591	2006-05-17	Released	758239851	/e5Tlc0mNhb9TvgCZknmnd3XaaKU.jpg	The Da Vinci Code	5.1500001
523	2006-03-02	Released	0	/vVjWshl7SyhcE2kYWkMLZV6e6uz.jpg	Requiem	5.0999999
219	2006-03-16	Released	85582407	/wjiEyTi7EnkdtC3MhH446esjCLF.jpg	Volver	5.0999999
132	1970-12-06	Released	0	/3UR6YSrz1nIQ84inth4emIPcEOT.jpg	Gimme Shelter	5.30000019
311	1984-02-17	Released	0	/fqP3Q7DWMFqW7mh11hWXbNwN9rz.jpg	Once Upon a Time in America	4.94999981
935	1964-01-29	Released	9440272	/ls9r2SG2IHJyCfpT0vxZZiT7ynF.jpg	Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb	4.9000001
481	2005-10-14	Released	0	/vRbhOYl4Z3fuI7lCosyM8VRHW1u.jpg	7 Virgins	4.6500001
379	1990-09-21	Released	5080409	/gmUAhNHY4bxQzgHjXci5JAW7u62.jpg	Miller's Crossing	4.44999981
334	1999-12-08	Released	48451803	/jxkHxPiMfGiFvxSOduNV4oIKJI5.jpg	Magnolia	4.69999981
277	2003-09-19	Released	95708457	/rdkxl5iXdpVU188cL1LLG3sy6z4.jpg	Underworld	4.55000019
391	1964-09-12	Released	14500000	/sFLgxvtK9vxbNq502peVJ847Owp.jpg	A Fistful of Dollars	4
685	1938-04-20	Released	0	/wt0eMmmw7GZTRhtrnGEXNRcCThP.jpg	Olympia Part Two: Festival of Beauty	4.75
570	2001-03-07	Released	0	/lbVrGZtS0uZ23L0svFP98bgqvKg.jpg	Fat Girl	5.94999981
571	1963-03-28	Released	11403529	/oFmlUPoPKFAzA9avylrEUs1FLj0.jpg	The Birds	7.0999999
438	2004-10-15	Released	0	/m6Vn1rysx6vmgJuy78Ih9QxFoOy.jpg	Cube Zero	5.05000019
832	1931-05-11	Released	0	/7a1Wx3gI13I1Svrme94DfbzxMHo.jpg	M	5.25
686	1997-07-11	Released	171120329	/yRF1qpaQPZJjiORDsR7eUHzSHbf.jpg	Contact	5.9000001
504	2003-11-16	Released	60378584	/uIVrPwor7fgSm5MRMj8IWs76gpk.jpg	Monster	4.5999999
793	1986-08-01	Released	8551228	/pxC4YsYIL4eSg1zDwrQQuxJegjA.jpg	Blue Velvet	5.1500001
742	2000-08-25	Released	0	/y6yk8fNyfXMJcviD6zxZE2qC0lJ.jpg	Together	5.44999981
856	1988-06-21	Released	329803958	/hSycHavBDjY9Qk3h5B4oXWTEqp1.jpg	Who Framed Roger Rabbit	5.30000019
814	1981-08-21	Released	31973249	/a8doVE7sXezmIeAFyXJcI3hPna5.jpg	An American Werewolf in London	4.75
975	1957-09-18	Released	0	/f3DEXseCs3WBtvCv9pVPCtoluuG.jpg	Paths of Glory	5.5999999
949	1995-12-15	Released	187436818	/zMyfPUelumio3tiDKPffaUpsQTD.jpg	Heat	5.3499999
883	2003-09-05	Released	7897645	/4IZ9SR6quqjUTghphn0oTBjnQKi.jpg	Coffee and Cigarettes	5.05000019
794	1976-06-06	Released	60922980	/uY14zS4Sm2DdvFXeczFKgLgkQUP.jpg	The Omen	5.44999981
882	1984-11-16	Released	0	/HBDlmaMVYAnLepGwwCaahi8Nvp.jpg	Flussfahrt Mit Huhn	4.8499999
911	1940-11-29	Released	0	/4K9k4dbYiLmxjFG132ZCwc9uHjC.jpg	The Bank Dick	5.05000019
\.


--
-- TOC entry 2231 (class 0 OID 45426)
-- Dependencies: 194
-- Data for Name: movie_genre; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie_genre (movie_id, genre_id) FROM stdin;
2	18
3	35
3	18
3	10769
18	12
18	14
18	28
18	53
18	878
38	878
38	18
38	10749
62	878
62	9648
62	12
81	12
81	14
81	16
81	28
81	878
106	878
106	28
106	12
106	53
107	53
107	80
132	99
132	10402
161	53
161	80
168	878
168	12
189	80
189	53
200	878
200	28
200	12
200	53
219	35
219	18
219	10749
236	18
236	35
236	10749
237	18
237	53
237	80
237	10749
258	35
258	18
258	10749
276	18
276	35
277	14
277	28
277	53
296	28
296	53
296	878
311	18
311	80
333	18
333	35
333	10402
333	10749
334	18
363	18
363	10749
379	18
379	53
379	80
390	18
390	10769
390	53
391	37
414	878
414	14
414	28
414	80
438	9648
438	878
438	53
459	10749
459	18
460	35
460	10769
481	18
482	12
482	28
482	53
482	80
504	80
504	18
523	18
523	27
524	18
524	80
551	28
551	12
570	18
591	53
591	9648
612	18
612	28
612	36
612	53
632	35
632	18
632	10752
643	18
643	36
644	18
644	878
644	12
665	12
665	18
665	28
665	36
685	99
686	18
686	878
686	9648
742	18
742	35
742	10749
767	12
767	14
767	10751
793	80
793	18
793	53
793	27
793	9648
794	27
794	53
814	27
814	35
832	18
832	28
832	53
832	80
833	18
856	14
856	16
856	35
856	80
856	10751
882	12
883	35
883	18
911	35
935	18
935	35
935	10752
949	28
949	80
949	18
949	53
975	18
975	10752
\.


--
-- TOC entry 2235 (class 0 OID 45455)
-- Dependencies: 198
-- Data for Name: movie_productioncountry; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie_productioncountry (country_id, movie_id) FROM stdin;
FI	2
FI	3
FR	18
US	38
GB	62
JP	81
US	106
GB	107
US	132
US	161
US	168
US	169
US	189
US	200
US	201
ES	219
AU	236
FR	237
FR	258
AT	276
DE	277
DE	296
IT	311
CA	333
US	334
DE	363
US	379
DE	390
IT	391
GB	414
CA	438
DE	459
DE	460
ES	481
US	482
US	504
DE	523
FR	524
US	551
FR	570
US	571
US	591
CA	612
US	632
RU	643
US	644
US	665
DE	685
US	686
SE	742
GB	767
US	793
GB	794
GB	814
DE	832
IT	833
US	856
DE	882
US	883
US	911
GB	935
US	949
US	975
FR	2
\.


--
-- TOC entry 2228 (class 0 OID 45402)
-- Dependencies: 191
-- Data for Name: person; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY person (person_id, birthday, deathday, biography, gender, place_of_birth, name) FROM stdin;
54768	1955-11-16	2007-02-28		0	Joutseno, Finland	Turo Pajala
54769	1957-10-20	\N	From Wikipedia, the free encyclopedia\n\nSusanna Haavisto (born 20 October 1957, Helsinki) is a Finnish actress and singer.\n\nShe has taken part in several movies and TV programs. She was UNICEF National Ambassador in 1980.\n\nDescription above from the Wikipedia article Susanna Haavisto, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Helsinki, Finland	Susanna Haavisto
4826	1951-03-28	1995-07-13	From Wikipedia, the free encyclopedia\n\nMatti Pellonpää (28 March 1951 in Helsinki – 13 July 1995 in Vaasa) was an award-winning Finnish actor and a musician. He rose to international fame with his roles in both Aki Kaurismäki's and Mika Kaurismäki's films; particularly being a regular in Aki's films, appearing in 18 of them.\n\nHe started his career in 1962 as a radio actor at the Finnish state-owned broadcasting company YLE. He performed as an actor during the 70s in many amateur theatres, at the same time that he studied at the Finnish Theatre Academy, where he completed his studies in the year 1977.\n\nHe was nominated Best Actor by European Film Academy for his role as Rodolfo in La Vie de Boheme and won the Felix at the European Film Awards in 1992. He also starred in Jim Jarmusch's 1991 film Night on Earth.\n\nDescription above from the Wikipedia article Matti Pellonpää, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Helsinki, Finland	Matti Pellonpää
54770	\N	\N		0		Eetu Hilkamo
16767	1957-04-04	\N	From Wikipedia, the free encyclopedia\n\nAki Olavi Kaurismäki (born 4 April 1957, Orimattila, Finland) is a Finnish script writer and film director.\n\nDescription above from the Wikipedia article Aki Kaurismäki, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Orimattila, Finland	Aki Kaurismäki
16769	1952-07-11	\N		0		Timo Salminen
54766	\N	\N		0		Raija Talvio
53836	1959-11-24	\N		2	Suomenniemi, Finland	Risto Karhula
54771	\N	\N		0		Tuula Hilkamo
5999	1961-08-17	\N	From Wikipedia, the free encyclopedia\n\nAnna Katriina Outinen (born August 17, 1961), is a Finnish actress who has often played leading female roles in Aki Kaurismäki's films.\n\nOutinen was born in Helsinki. Having studied under Jouko Turkka during his "reign" of drama studies in Finland, she nevertheless has never been associated with the "turkkalaisuus" school of acting methodology. Her breakthrough role was as a tough girl in the generational classic youth film Täältä tullaan elämä by Tapio Suominen.\n\nIn 1984, she appeared in Aikalainen.\n\nBesides a strong domestic reputation gained through a widely varied list of roles in theater and television drama, film director Aki Kaurismäki's films have brought Outinen international attention and even adulation, particularly in Germany and France.\n\nAt the 2002 Cannes Film Festival, Outinen won the award for Best Actress for the Kaurismäki film The Man Without a Past.\n\nDescription above from the Wikipedia article Kati Outinen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Helsinki, Finland	Kati Outinen
4828	1956-09-06	\N	From Wikipedia, the free encyclopedia\n\nSakari Jyrki Kuosmanen (born 6 September 1956 in Helsinki) is a Finnish singer and actor. He has recorded several solo albums and has also done work with Sleepy Sleepers and Leningrad Cowboys. He appeared as himself on the Finnish television series Aaken ja Sakun kesäkeittiö in 1999.\n\nDescription above from the Wikipedia article Sakari Kuosmanen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Finland	Sakari Kuosmanen
53508	1938-11-23	2006-12-17	From Wikipedia, the free encyclopedia.\n\nEsko Nikkari (23 November 1938 Lapua, Finland – 17 December 2006 in Seinäjoki, Finland) was a prolific Finnish actor who made more than 70 appearances on film and television. He debuted in 1974 in the movie Karvat.\n\nNikkari was a workhorse of the Kaurismäki brothers, with whom he first worked on Rikos ja rangaistus in 1983. His last role with Aki Kaurismäki was in Man without a Past in 2002. He starred in the 1994 film Aapo opposite actors such as Taisto Reimaluoto, Ulla Koivuranta and Kai Lehtinen. More recently, he has appeared in a number of Timo Koivusalo films such as Kaksipäisen kotkan varjossa (2005), which is the last full-length movie he appeared in.\n\nDescription above from the Wikipedia article Esko Nikkari, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Lapua, Finland	Esko Nikkari
1086499	\N	\N		0		Kylli Köngäs
222320	1943-05-14	\N		2	Helsinki, Finland	Pekka Laiho
1086500	\N	\N		0		Jukka-Pekka Palo
545412	\N	\N		0		Albert Collins
54767	1955-09-21	\N	He is the elder brother of Aki Kaurismäki, and the father of Maria Kaurismäki, who graduated from Tampere School of Art and Media in 2008 with her movie Sideline.[1][2]\n\nMika Kaurismäki has lived in Brazil since approximately 1992	2	Orimattila, Finland	Mika Kaurismäki
1084614	\N	\N		0		Pertti Hilkamo
1084612	\N	\N		0		Heikki Ukkonen
62	1955-03-19	\N	Walter Bruce Willis, better known as Bruce Willis, is an American actor and producer. His career began in television in the 1980s and has continued both in television and film since, including comedic, dramatic, and action roles. He is well known for the role of John McClane in the Die Hard series.\n\nWillis was born in Idar-Oberstein, West Germany, the son of a Kassel-born German, Marlene, who worked in a bank, and David Willis, an American soldier. Willis is the eldest of four children.\n\nAt the premiere for the film Stakeout, Willis met actress Demi Moore. They married on November 21, 1987 and had three daughters before the couple divorced on October 18, 2000.\n\nSince the divorce he has dated models Maria Bravo Rosado and Emily Sandberg; he was engaged to Brooke Burns until they broke up in 2004 after ten months together. He married Emma Heming on March 21, 2009.	2	Idar-Oberstein, Germany	Bruce Willis
8396	1958-06-24	\N	Tommy "Tiny" Lister (born Thomas Lister, Jr.; June 24, 1958) is a character actor and former wrestler best known for his role as the neighborhood bully Deebo in the Friday series of movies. He also had a short-lived professional wrestling career, wrestling Hulk Hogan in the World Wrestling Federation (WWF) after appearing as "Zeus" in Hogan's movie No Holds Barred. Lister is blind in his right eye.  Lister has had numerous guest appearances in TV series, including playing Klaang (the first Klingon ever to make contact with humans, not counting Worf in Star Trek: First Contact) in the pilot episode of Star Trek: Enterprise. He also co-starred in an episode of the courtroom series Matlock as Mr. Matlock's in-prison bodyguard.  Lister also appeared as Sancho in the music video for Sublime's song "Santeria". He was also in the video for Michael Jackson's song "Remember the Time". He also made a guest appearance in Austin Powers in Goldmember, as a prisoner in the Hard Knock Life spoof.	2	Compton, California, USA	Tommy 'Tiny' Lister
7400	1964-02-25	\N	From Wikipedia, the free encyclopedia\n\nLee Evans (born 25 February 1964) is an English stand-up comedian, writer, actor and musician.\n\nDescription above from the Wikipedia article Lee Evans (comedian), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Avonmouth, Bristol, England, UK	Lee Evans
8397	1972-03-24	\N		2	Nottingham, Nottinghamshire, England, UK	Charlie Creed-Miles
183500	1968-01-27	\N		0	London, United Kingdom	Tricky
64	1958-03-21	\N	Gary Leonard Oldman (born 21 March 1958) is an English actor, filmmaker and musician, well-known to audiences for his portrayals of dark and morally ambiguous characters. He has starred in films such as Sid and Nancy, Prick Up Your Ears, JFK, Dracula, True Romance, Léon, The Fifth Element, The Contender, the Harry Potter film series and the Batman film series, as well as in television shows such as Friends and Fallen Angels.\n\nOldman came to prominence in the mid-1980s with a string of performances that prompted pre-eminent film critic, Roger Ebert, to describe him as "the best young British actor around". He has been cited as an influence by a number of successful actors. In addition to leading and central supporting roles in big-budget Hollywood films, Oldman has frequently acted in independent films and television shows. Aside from acting, he directed, wrote and co-produced Nil by Mouth, a film partially based on his own childhood, and served as a producer on several films.\n\nAmong other accolades, Oldman has received Emmy-, Screen Actors Guild-, BAFTA- and Independent Spirit Award nominations for his acting work, and has been described as one of the greatest actors never nominated for an Academy Award. His contributions to the science fiction genre have won him a Saturn Award, with a further two nominations. He was also nominated for the 1997 Palme d'Or and won two BAFTA Awards for his filmmaking on Nil By Mouth. In 2011, Empire readers voted Oldman an "Icon of Film", in recognition of his contributions to cinema.\n\nDescription above from the Wikipedia article Gary Oldman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Gary Oldman
65	1931-09-12	\N	Sir Ian Holm, CBE (born 12 September 1931) is a British actor known for his stage work and for many film roles. He received the 1967 Tony Award for Best Featured Actor for his performance as Lenny in The Homecoming and the 1998 Laurence Olivier Award for Best Actor for his performance in the title role of King Lear. He was nominated for the 1981 Academy Award for Best Supporting Actor for his role as athletics trainer Sam Mussabini in Chariots of Fire. Other well-known film roles include the android Ash in Alien, Father Vito Cornelius in The Fifth Element, and the hobbit Bilbo Baggins in the first and third films of the Lord of the Rings film trilogy.\n\nDescription above from the Wikipedia article Ian Holm, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Goodmayes, Essex, England, UK	Ian Holm
63	1975-12-17	\N	Milla Jovovich, born as Milica Natasha Jovovich, is an Ukrainian-born actress, an American supermodel, musician, and fashion designer.\n\nOver her career, she has appeared in a number of science fiction and action themed films, for which music channel VH1 has referred to her as the "reigning queen of kick-butt". Born on 17th December, 1975, Milla has appeared on the cover of more than a hundred magazines, and has also starred in films such as The Fifth Element (1997), Ultraviolet (2006), and the 'Resident Evil' franchise.\n\nJovovich began modeling at eleven, when Richard Avedon featured her in Revlon's "Most Unforgettable Women in the World" advertisements, and she continued her career with other campaigns for L'Oréal cosmetics, Banana Republic, Christian Dior, Donna Karan, and Versace. In 1988, she had her first professional acting role in the television film The Night Train to Kathmandu, and later that year she appeared in her first feature film, Two Moon Junction.\n\nFollowing more small television appearances such as the "Fair Exchange" (1989) and a 1989 role as a French girl (she was 14 at the time then) on a Married with Children episode and film roles, she gained notoriety with the romance film Return to the Blue Lagoon (1991). She appeared in 1993's Dazed and Confused alongside Ben Affleck and Matthew McConaughey. Jovovich then acted alongside Bruce Willis in the science fiction film The Fifth Element (1997), and later played the title role in The Messenger: The Story of Joan of Arc (1999). In 2002, she starred in the video game adaptation Resident Evil, which spawned three sequels: Resident Evil: Apocalypse (2004), Resident Evil: Extinction (2007) and Resident Evil: Afterlife (2010).\n\nIn addition to her modelling and acting career, Jovovich released a music album, The Divine Comedy in 1994. She continues to release demos for other songs on her official website and contributes to film soundtracks as well; Jovovich has yet to release another album. In 2003, she and model Carmen Hawk created the clothing line Jovovich-Hawk, which ceased operations in early 2008. In its third season prior to its demise, the pieces could be found at Fred Segal in Los Angeles, Harvey Nichols, and over 50 stores around the world.	1	Kiev, Ukraine	Milla Jovovich
66	1972-08-31	\N	Christopher "Chris" Tucker (born August 31, 1972) is an American actor and comedian, best known for his roles as Detective James Carter in the Rush Hour trilogy and Smokey in the 1995 film Friday.  Tucker was born in Atlanta, Georgia, the youngest son of Mary Louise and Norris Tucker. Tucker was raised in Decatur, Georgia. After graduating from Columbia High School, he moved to Los Angeles to pursue a career in comedy and movies. In 1992, Tucker was a frequent performer on Def Comedy Jam. He made his cinematic debut in House Party 3, and gained greater film recognition alongside rapper Ice Cube in the 1995 film Friday. In 1997, he co-starred with Charlie Sheen in Money Talks, and alongside Bruce Willis in The Fifth Element. Tucker did not reprise his role of Smokey in Next Friday (2000) because he had become a born-again Christian after filming Money Talks (1997).He later starred in the 1998 martial arts action comedy Rush Hour and its sequels, Rush Hour 2 and Rush Hour 3, in which he played James Carter, an abrasive wise-cracking detective.  Tucker is good friends with fellow Rush Hour star Jackie Chan, and was also close friends with the late singer Michael Jackson, introducing and dancing with him at his 30th Anniversary Special, appearing in Jackson's video "You Rock My World" from his 2001 album Invincible and attending Jackson's memorial service. A friend of Bill Clinton, Tucker has traveled with the former President overseas, though he endorsed Barack Obama rather than Hillary Clinton in the 2008 primaries. On February 13, 2009, Tucker participated in the NBA All-Star Weekend's Celebrity Game.	0	Atlanta, Georgia	Chris Tucker
8395	1965-10-11	\N	Luke Perry (born Coy Luther Perry III; October 11, 1965) is an American actor. Perry starred as Dylan McKay on the TV series Beverly Hills, 90210, a role he played from 1990–95, and then from 1998–2000. Much publicity was garnered over the fact that even though he was playing a sixteen-year-old when 90210 began, Perry was actually in his mid twenties at that time. Perry returned to 90210 in 1998 (this time billed as a permanent "Special Guest Star") and remained with the series until its conclusion in 2000.	2	Mansfield - Ohio - USA	Luke Perry
591	1945-02-20	1999-08-07	From Wikipedia, the free encyclopedia\n\nBrion Howard James (February 20, 1945 – August 7, 1999) was an American character actor. Known for playing the character of Leon Kowalski in the movie Blade Runner, James portrayed a variety of colorful roles in well-known American films such as 48 Hrs., Another 48 Hours, Tango &amp; Cash, Silverado, Red Heat, The Player and The Fifth Element. James' commanding screen presence and formidable physique at 6 feet 3 inches (1.91 m) tall[1] usually resulted in his casting as a heavy, appearing more frequently in lower budget horror and action films throughout the 1980s and 1990s. James appeared in more than 100 films before he died of a heart attack aged 54.\n\nDescription above from the Wikipedia article Brion James, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Redlands, California, USA	Brion James
212	1964-04-04	\N	​From Wikipedia, the free encyclopedia.\n\nDavid Cross (born April 4, 1964) is an American actor, writer and stand-up comedian perhaps best known for his work on HBO's sketch comedy series Mr. Show and for his role as Tobias Fünke in the Fox sitcom Arrested Development. Cross currently stars in The Increasingly Poor Decisions of Todd Margaret and recently had a recurring role in the 2010 FOX sitcom Running Wilde.	0	Atlanta - Georgia - USA	David Cross
1439	\N	\N		0		Mike Clarke
12642	1925-05-02	2011-11-19	John Neville, OBE, CM was an English theatre and film actor who moved to Canada with his family in 1972. He enjoyed a resurgence of international attention as a result of his starring role in Terry Gilliam's "The Adventures of Baron Munchausen".\n\nHe was appointed to the Order of Canada, that nation's highest civilian honor, in 2006.\n\nAccording to publicists at Canada's Stratford Shakespeare Festival, Neville died "peacefully surrounded by family" on 19 November 2011, aged 86. Neville suffered with Alzheimer's disease in his latter years. He is survived by his wife, Caroline (née Hopper), and their six children.\n\nAbove description from the Wikipedia article John Neville (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Willesden, London, England, UK	John Neville
8398	1929-08-12	\N		0		John Bluthal
2406	1967-08-03	\N	From Wikipedia, the free encyclopedia.\n\nMathieu Kassovitz (born 3 August 1967) is a French director, screenwriter, producer and actor, best known for his Cannes-winning drama La Haine. Kassovitz is also the founder of MNP Entreprise, a film production company.\n\nDescription above from the Wikipedia article Mathieu Kassovitz, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Paris, France	Mathieu Kassovitz
8399	1953-10-04	\N	Christopher Fairbank (sometimes credited as Chris Fairbank; born 4 October 1953) is an English actor best known for his role as Moxey in the hit comedy-drama series Auf Wiedersehen, Pet. Fairbank was born in Hertfordshire, England. He has numerous television credits to his name, notably in Sapphire and Steel, The Professionals, The Scarlet Pimpernel and provided minor voice talent for both the hit Wallace and Gromit feature-length film Curse of the Were-Rabbit and Flushed Away (both produced by Aardman). Fairbank also appeared as one of the pair of muggers who rob an out-of-town family, heralding the first appearance of the Batman in Tim Burton's 1989 film. Fairbank also had roles as Mactilburgh the scientist in the film The Fifth Element, the prisoner Murphy in Alien 3, and the Player Queen in the Franco Zeffirelli version of Hamlet, opposite Mel Gibson. Recently, he provided the voice of Old King Doran in the video game Demon's Souls and provides a number of voice accents in the PS2 video game Prisoner of War. Chris also appeared in Goal! trilogy in the character of a Newcastle United fan. In 2010, Chris appeared as a detective in the BBC Drama, Five Daughters, and as Alfred "Freddie" Lennon in the biopicLennon Naked with Christopher Eccleston. In 2011 Fairbank starred in Pirates of the Caribbean: On Stranger Tidesas a pirate called Ezekiel. In 2012 he appeared as an Australian in Sky 1's Starlings.	2	Hertfordshire - England - UK	Christopher Fairbank
8400	1917-12-28	2008-10-05		0		Kim Chan
28897	1961-05-28	\N		0		Julie T. Wallace
10208	1942-11-21	\N		2	Brooklyn, New York City, New York, USA	Al Matthews
64210	1976-04-17	\N	​From Wikipedia, the free encyclopedia.  \n\nMaïwenn Le Besco (born April 17, 1976 in Les Lilas, Seine-Saint-Denis, Île-de-France) is a French actress and film director, sometimes credited as Maïwenn.\n\nDescription above from the Wikipedia article Maïwenn Le Besco, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Les Lilas, Seine-Saint-Denis, France	Maïwenn
33403	1948-06-18	\N	From Wikipedia, the free encyclopedia\n\nMac McDonald (born Terence McDonald, 18 June 1949, in Long Island, New York, USA) is an American actor. He is best known for playing Captain Hollister on the BBC TV series Red Dwarf and frequently plays American characters in other British TV shows. He has also had many movie roles in films such as Aliens, Batman and The Fifth Element, all of which were filmed in England.\n\nDescription above from the Wikipedia article Mac McDonald, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Long Island, New York	Mac McDonald
232174	\N	\N		0	London, United Kingdom	Indra Ové
1588721	1974-09-06	\N		1	Durban, South Africa	Genevieve Maylam
53246	1962-04-24	\N		2	London - England - UK	Jason Salkey
8445	\N	\N	Michael Culkin is an English theatre, film, and television actor probably best known for his role as Judge Buller in the BBC drama Garrow's Law. Among his other credits include a role in the children's drama M. I. High as a solicitor, and Hugo Blandford in Doctors. He also had a role in the 2009 film Dorian Gray.	0		Michael Culkin
59	1959-03-18	\N	Luc Besson is a French film director, writer, and producer known for making highly visual thriller and action films.  Besson has been nominated for, and won, numerous awards and honors from the foreign press, and is often credited as inventing the so-called "Cinema du look" movement in French film.  \n\nBorn in Paris, Besson spent his childhood traveling Europe with his parents and developing an enthusiasm for ocean diving, before an accident would push him toward the world of cinema.  After taking odd jobs in the Parisian film scene of the time, Besson began writing stories which would eventually evolve into some of his greatest film successes: The Fifth Element and Le Grand Bleu.  \n\nIn 1980 he founded his own production company, Les Films du Loup later Les Films du Dauphin,and later still EuropaCorp film company with his longtime collaborator, Pierre-Ange Le Poga. Besson's work stretches over twenty-six years and encompasses at least fifty-films.  .	2	Paris, France	Luc Besson
60	\N	\N		0		Patrice Ledoux
61	\N	\N	Robert Mark Kamen is a screenwriter who has been writing for major motion pictures for over twenty-five years. He is also one of the collaborators of French writer, director and producer Luc Besson. He is originally from the Bronx borough of New York City.	0	The Bronx, New York, United States	Robert Mark Kamen
996	1959-09-09	\N		0		Eric Serra
998	\N	\N		0		Sylvie Landra
1113	\N	\N		1		Lucinda Syson
1000	\N	\N		0		Dan Weil
8378	\N	\N		0		Ira Gilford
8379	\N	\N		0		Ron Gress
8380	\N	\N		0		Michael Lamont
213	\N	\N	Gerry Robert Byrne is a production manager and actor.  He is best known as a production manager for the hit feature films Eternal Sunshine of the Spotless Mind (2004), Man on the Moon (1999), Brokeback Mountain (2005), The People vs. Larry Flynt (1996).	0		Gerry Robert Byrne
214	\N	\N		0		Brian Price
216	1994-08-25	\N	​From Wikipedia, the free encyclopedia.  \n\nJoshua Alexander Flitter (born August 25, 1994) is an American actor. He is known for playing Corky in Nancy Drew, Eddie in The Greatest Game Ever Played, and voiced Rudy in the 2008 animated film Horton Hears a Who!.\n\nDescription above from the Wikipedia article Josh Flitter, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Josh Flitter
217	1995-04-17	\N		0		Paul Litowsky
220	\N	\N		0		Lola Daehler
210	1996-03-13	\N	Amir Ali Said is an actor.	0	Brooklyn - New York - USA	Amir Ali Said
1440	\N	\N		0		Sam Cutler
1441	\N	\N		0		Spencer Dryden
2508	\N	\N		0		Ron Wilkinson
2519	1958-09-19	\N		1	Croatia	Sanja Milkovic Hays
6525	\N	\N		0		José Antonio Félez
6526	\N	\N		0		Julio de la Rosa
206	1962-01-17	\N	James Eugene "Jim" Carrey is a Canadian-American actor, comedian, singer and writer. He has received two Golden Globe Awards and has also been nominated on four occasions.\n\nCarrey began stand-up comedy in 1979, performing at Yuk Yuk's in Toronto, Ontario. After gaining prominence in 1981, he began working at The Comedy Store in Los Angeles where he was soon noticed by comedian Rodney Dangerfield, who immediately signed him to open his tour performances.\n\nCarrey, long interested in film and television, developed a close friendship with comedian Damon Wayans, which landed him a role in the sketch comedy hit In Living Color, in which he portrayed various characters during the show's 1990 season. Having had little success in television movies and several low-budget films, Carrey was cast as the title character in Ace Ventura: Pet Detective which premiered in February, 1994, making more than $72 million domestically. The film spawned a sequel, Ace Ventura: When Nature Calls (1995), in which he reprised the role of Ventura.\n\nHigh profile roles followed when he was cast as Stanley Ipkiss in The Mask (1994) for which he gained a Golden Globe Award nomination for Best Actor in a Musical or Comedy, and as Lloyd Christmas in the comedy film Dumb and Dumber (1994). Between 1996 and 1999, Carrey continued his success after earning lead roles in several highly popular films including The Cable Guy (1996), Liar Liar (1997), in which he was nominated for another Golden Globe Award and in the critically acclaimed films The Truman Show and Man on the Moon, in 1998 and 1999, respectively. Both films earned Carrey Golden Globe awards. Since earning both awards — the only two in his three-decade career— Carrey continued to star in comedy films, including How the Grinch Stole Christmas (2000) where he played the title character, Bruce Almighty (2003) where he portrayed the role of unlucky TV reporter Bruce Nolan, Lemony Snicket's A Series of Unfortunate Events (2004), Fun with Dick and Jane (2005), Yes Man (2008), and A Christmas Carol (2009).\n\nCarrey has also taken on more serious roles including Joel Barish in Eternal Sunshine of the Spotless Mind (2004) alongside Kate Winslet and Kirsten Dunst, which earned him another Golden Globe nomination, and Steven Jay Russell in I Love You Phillip Morris (2009) alongside Ewan McGregor.   Description above from the Wikipedia article Jim Carrey, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Newmarket, Ontario, Canada	Jim Carrey
204	1975-10-05	\N	Kate Elizabeth Winslet (born 5 October 1975) is an English actress and occasional singer. She has received multiple awards and nominations. She is the youngest person to accrue six Academy Award nominations, and won the Academy Award for Best Actress for The Reader (2008).\n\nWinslet has been acclaimed for both dramatic and comedic work in projects ranging from period to contemporary films, and from major Hollywood productions to less publicised indie films. She has won awards from the Screen Actors Guild, British Academy of Film and Television Arts, and the Hollywood Foreign Press Association among others, and has been nominated for an Emmy Award for television acting. Raised in Berkshire, Winslet studied drama from childhood, and began her career in British television in 1991.\n\nShe made her film debut in Heavenly Creatures (1994), for which she received her first notable critical praise. She achieved recognition for her subsequent work in a supporting role in Sense and Sensibility (1995) and for her leading role in Titanic (1997), the highest grossing film at the time. Since 2000, Winslet's performances have continued to draw positive comments from film critics, and she has been nominated for various awards for her work in such films as Quills (2000), Iris (2001), Eternal Sunshine of the Spotless Mind (2004), Finding Neverland (2004), Little Children (2006), The Reader (2008) and Revolutionary Road (2008). Her performance in the latter prompted New York magazine to describe her as "the best English-speaking film actress of her generation". The romantic comedy The Holiday and the animated film Flushed Away (both 2006) were among the biggest commercial successes of her career.\n\nWinslet was awarded a Grammy Award for Best Spoken Word Album for Children in 2000. She has been included as a vocalist on some soundtracks of works she has performed in, and the single "What If" from the soundtrack for Christmas Carol: The Movie (2001), was a hit single in several European countries. Winslet has a daughter with her former husband, Jim Threapleton, and a son with her second husband, Sam Mendes, from whom she is separated. She lives in New York City. Description above from the Wikipedia article Kate Winslet, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Reading, UK	Kate Winslet
109	1981-01-28	\N	Elijah Jordan Wood ( born January 28, 1981) is an American actor. He made his film debut with a minor part in Back to the Future Part II (1989), then landed a succession of larger roles that made him a critically acclaimed child actor by age 9. He is best known for his high-profile role as Frodo Baggins in Peter Jackson's critically acclaimed The Lord of the Rings trilogy. Since then, he has resisted typecasting by choosing varied roles in critically acclaimed films such as Bobby, Eternal Sunshine of the Spotless Mind, Sin City, Green Street and Everything Is Illuminated. He starred in the film Day Zero (2007) and provided the voice of the main character, Mumble, in the award-winning animated film Happy Feet. He played an American tourist turned vampire in Paris, je t'aime. In 2005, he started his own record label, Simian Records. He was cast in the lead role of an Iggy Pop biopic to be called The Passenger, but after years of development, the project now appears to be shelved.\n\nDescription above from the Wikipedia article Elijah Wood, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Cedar Rapids, Iowa, USA	Elijah Wood
103	1967-11-22	\N	Mark Alan Ruffalo (born November 22, 1967) is an American actor, director, producer and screenwriter. He has worked in films including Eternal Sunshine of the Spotless Mind, Zodiac, Shutter Island, Just Like Heaven, You Can Count on Me and The Kids Are All Right for which he received an Academy Award nomination for Best Supporting Actor.\n\nDescription above from the Wikipedia article Mark Ruffalo, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Kenosha, Wisconsin, USA	Mark Ruffalo
205	1982-04-30	\N	Kirsten Caroline Dunst (born April 30, 1982) is an American actress, singer and model. She made her film debut in Oedipus Wrecks, a short film directed by Woody Allen for the anthology New York Stories (1989). At the age of 12, Dunst gained widespread recognition playing the role of vampire Claudia in Interview with the Vampire (1994), a performance for which she was nominated for a Golden Globe Award for Best Supporting Actress. The same year she appeared in Little Women, to further acclaim. Dunst achieved international fame as a result of her portrayal of Mary Jane Watson in the Spider-Man trilogy (2002–07). Since then her films have included the romantic comedy Wimbledon (2004), the romantic science fiction Eternal Sunshine of the Spotless Mind (2004) and Cameron Crowe's tragicomedy Elizabethtown (2005). She played the title role in Sofia Coppola's Marie Antoinette (2006) and starred in the comedy How to Lose Friends &amp; Alienate People (2008). She won the Best Actress Award at the Cannes Film Festival in 2011 for her performance in Lars von Trier's Melancholia.\n\nIn 2001, Dunst made her singing debut in the film Get Over It, in which she performed two songs. She also sang the jazz song "After You've Gone" for the end credits of the film The Cat's Meow (2001).\n\nDescription above from the Wikipedia article Kirsten Dunst, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Point Pleasant, New Jersey	Kirsten Dunst
207	1948-02-05	\N	From Wikipedia, the free encyclopedia\n\nThomas Geoffrey "Tom" Wilkinson, OBE (born 5 February 1948) is an English actor. He has twice been nominated for an Academy Award for his roles in In The Bedroom and Michael Clayton. In 2009, he won The Golden Globe and Primetime Emmy Award for best Supporting Actor in a Miniseries or Movie for John Adams.\n\nDescription above from the Wikipedia article Tom Wilkinson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Leeds - West Yorkshire - England - UK	Tom Wilkinson
208	\N	\N		0		Ryan Whitney
209	1965-04-01	\N	Jane Adams (born April 1, 1965) is an American film, television and theatre actress.	0	Washington, D.C., United States	Jane Adams
211	\N	\N		1		Debbon Ayer
3070	1948-07-24	\N	From Wikipedia, the free encyclopedia. Chris Haywood (born 24 July 1948) is an English-born, Australian-based film and televisionactor/producer.\n\nDescription above from the Wikipedia article Chris Haywood, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Billericay - Essex - England	Chris Haywood
3072	1970-04-16	\N		0		Daniel Lapaine
77013	\N	\N	Deirdre O'Connell is an American character actress who has worked extensively on stage, screen, and television. O'Connell began her career at Stage One, an experimental theatre at the Boston Center for the Arts. She made herBroadway debut in the 1986 revival of The Front Page, and was nominated for the 1991 Drama Desk Award for Outstanding Featured Actress in a Play for her performance in the off-Broadway production Love and Anger. She is the recipient of two Drama-Logue Awards and a Los Angeles Drama Critics Circle Award for her stage work in Los Angeles. O'Connell made her screen debut in Tin Men. Additional film credits include State of Grace, Straight Talk, Leaving Normal,Fearless, City of Angels, Hearts in Atlantis, Imaginary Heroes, Eternal Sunshine of the Spotless Mind, Wendy and Lucy,What Happens in Vegas, Secondhand Lions, and Synecdoche, New York. O'Connell's first television credit was Fernwood 2 Night in 1977. She was a regular on L.A. Doctors and has made numerous guest appearances on series such as Kate &amp; Allie, Chicago Hope, Law &amp; Order, The Practice, Six Feet Under,Law &amp; Order: Criminal Intent, and Nurse Jackie. (Wikipedia)	0		Deirdre O'Connell
221	\N	\N		0		Lauren Adler
4475	\N	\N		0		Valdís Óskarsdóttir
201	1963-05-08	\N	From Wikipedia, the free encyclopedia.\n\nMichel Gondry (born May 8, 1963) is a French film, commercial, and music video director and a screenwriter. He is noted for his inventive visual style and manipulation of mise en scène.\n\nDescription above from the Wikipedia article Michel Gondry, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Versailles, France	Michel Gondry
312	\N	\N		0		Jon Brion
313	1959-07-10	\N	Ellen Kuras ASC (born July 10, 1959 in New Jersey) is an American cinematographer and director. She has collaborated several times with directors Michel Gondry and Spike Lee. In 2013 she was a member of the jury at the 63rd Berlin International Film Festival.\n\nDescription above from the Wikipedia article Ellen Kuras, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New Jersey, USA 	Ellen Kuras
321	\N	\N		0		Anthony Bregman
322	\N	\N		0		Steve Golin
4340	\N	\N		0		Chris Norr
202	1958-11-19	\N	From Wikipedia, the free encyclopedia\n\nCharles Stuart "Charlie" Kaufman (born November 19, 1958) is an American screenwriter, producer, and director. His works include Being John Malkovich, Human Nature, Adaptation, Eternal Sunshine of the Spotless Mind and Synecdoche, New York. He won the Academy Award for Best Original Screenplay for Eternal Sunshine of the Spotless Mind.\n\nDescription above from the Wikipedia article Charlie Kaufman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York	Charlie Kaufman
222	\N	\N		0		Pierre Bismuth
7496	\N	\N		0		Dan Leigh
546	\N	\N		0		Jeanne McCarthy
33439	\N	\N		0		Melissa Toth
245	1936-05-30	\N	From Wikipedia, the free encyclopedia.\n\nKeir Dullea (born May 30, 1936) is an American actor best known for the character of astronaut David Bowman, whom he portrayed in the 1968 film 2001: A Space Odyssey and in 1984's 2010: The Year We Make Contact, as well as his roles in the films Bunny Lake is Missing (1965) and Black Christmas (1974).	0	Cleveland - Ohio - USA	Keir Dullea
253	1928-03-13	\N	From Wikipedia, the free encyclopedia.\n\nDouglas Rain (born 1928) is a Canadian actor and narrator. He is primarily a stage actor, but his best known film role was as the voice of the HAL 9000 computer in 2001: A Space Odyssey (1968) and its sequel 2010 (1984).\n\nRain was born in Winnipeg, Manitoba. He studied acting at the Banff School of Fine Arts in Banff, Alberta as well as in London at the Old Vic School. As a stage actor, his long association with the Stratford Festival of Canada that spans more than four decades. He has performed in many diverse roles on stage, most notably recognized for his performance at Stratford, Ontario in Henry V which was made into a television production in 1966.\n\nRain was also nominated for Broadway's 1972 Tony Award as Best Supporting or Featured Actor (Dramatic) for his performance in Vivat! Vivat Regina!\n\nDescription above from the Wikipedia article Douglas Rain, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Winnipeg, Manitoba, Canada	Douglas Rain
246	1937-02-21	\N	From Wikipedia, the free encyclopedia.\n\nGary Lockwood (born February 21, 1937) is an American actor perhaps best known for his iconic 1968 role as the astronaut Dr. Frank Poole in 2001: A Space Odyssey. He is father of the actress Samantha Lockwood. Both currently live in Los Angeles.\n\nDescription above from the Wikipedia article Gary Lockwood, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Van Nuys, California, USA	Gary Lockwood
247	1922-01-31	1995-01-25	From Wikipedia, the free encyclopedia.\n\nWilliam Sylvester (January 31, 1922 – January 25, 1995) was an American TV and film actor. His most famous film credit was Dr. Heywood Floyd in Stanley Kubrick's 2001 A Space Odyssey (1968). Born in Oakland, California and married at one time to the British actress Veronica Hurst, he moved to England after the Second World War and became a staple of British B films at a time when American and Canadian actors were much in demand in order to give indigenous films some appeal in the US.\n\nAs a result, he gained top billing in one of his very first films, House of Blackmail (1953), directed by the veteran filmmaker Maurice Elvey, for whom he also made What Every Woman Wants the following year. He also starred in such minor films as The Stranger Came Home (1954, for Hammer), Dublin Nightmare (1958), Offbeat (1960), Information Received (1961), Incident at Midnight, Ring of Spies and Blind Corner (all 1963). There were also lead roles in four British horror films: Gorgo (1960), Devil Doll (1963), Devils of Darkness (1964) and The Hand of Night (1966). Among his many TV credits were a 1959 BBC version of Shakespeare's Julius Caesar (playing Mark Antony), The Saint, The Baron, The High Chaparral, Harry O and The Six Million Dollar Man.\n\nHis later films included You Only Live Twice (1967) and, back in the USA after his prominent role for Kubrick, Busting (1973), The Hindenburg (1975) and Heaven Can Wait (1978). He died in Sacramento, California in 1995, aged 72.\n\nDescription above from the Wikipedia article William Sylvester, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Oakland, California, USA	William Sylvester
248	\N	\N		0		Daniel Richter
249	1926-10-21	1984-10-05	From Wikipedia, the free encyclopedia.  Leonard Rossiter (21 October 1926 – 5 October 1984) was an English actor known for his roles as Rupert Rigsby, in the British comedy television series Rising Damp (1974–78), and Reginald Iolanthe Perrin, in The Fall and Rise of Reginald Perrin (1976–79). He also had a long and distinguished career in the theatre and gained some notoriety for a series of Cinzano commercials (1978–1983), with Joan Collins.\n\nDescription above from the Wikipedia article Leonard Rossiter, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Wavertree, Liverpool, England, UK	Leonard Rossiter
250	1931-09-09	2011-06-25		1	Essex, England	Margaret Tyzack
3929	\N	\N		2		Antonin Svoboda
3931	\N	\N		0		Katharina Held
3871	\N	\N		0		Matthias Schellenberg
3940	\N	\N		1		Daniela Knapp
251	1909-10-19	1992-03-03	From Wikipedia, the free encyclopedia\n\nRobert Beatty (19 October 1909 – 3 March 1992) was a Canadian actor who worked in film, television and radio for most of his career and was especially known in the UK.\n\nDescription above from the Wikipedia article Robert Beatty, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hamilton, Ontario, Canada	Robert Beatty
252	1921-12-26	1985-07-03		0	 Toronto, Ontario, Canada	Sean Sullivan
24278	\N	\N		0		Bill Weston
108277	1932-06-11	2005-06-08		0	Brooklyn - New York - USA	Ed Bishop
93948	1911-03-11	1989-03-20		0		Alan Gifford
107445	1927-02-12	\N	Ann Gillis was born Alma Mabel Conner on February 12, 1927, in Little  Rock, Arkansas. At age seven, she appeared in her first film, Men in White  (1934), as an extra. During the next two years, she had uncredited  appearances in six more films until she received her first major role in  King of Hockey (1936). Warner Brothers Studios gave significant screen time to Gillis in this movie, in hopes that she would become another Shirley Temple.  Although (like all child stars of the 1930s) she never achieved  Temple's level of fame, for the next several years Gillis starred in  many films, almost always playing a spoiled, bratty character. She had  two rare sympathetic roles as Becky Thatcher in The Adventures of Tom Sawyer (1938) and as the title character in Little Orphan Annie  (1938). One scene in The Adventures of Tom Sawyer called for her to go  into screaming hysterics when her character was trapped in a cave of  bats, and Gillis delivered in a powerful performance that is probably  the most memorable scene of her film career. As Gillis grew older,  however, her career slowed down, and she left Hollywood in 1947. When  she left Hollywood she married Paul Ziebold and had 2 sons. She then  divorced, relocated to New York City and married Richard Fraser,  a Scottish-born actor (they had a son born in 1958). During the 1950s  and '60s, Gillis made sporadic television appearances, and in 1959, she  hosted a national telecast presentation of The Adventures of Tom Sawyer.  Gillis and her husband moved to England in 1961, and they were living  in London when they heard of a casting call for 2001: A Space Odyssey  (1968) that called for an American actress living in the city. Gillis  auditioned and got the role; it remains her final film to date.	1	Little Rock, Arkansas, USA	Ann Gillis
117540	\N	\N		0		Edwina Carroll
102573	\N	\N		0		Frank Miller
948173	1935-06-01	\N		0		Glenn Beck
127363	\N	\N		0		Penny Brahms
1102076	\N	\N		0		Heather Downham
1330785	\N	\N		0		Mike Lovell
1330786	\N	\N		0		John Ashley
1330787	\N	\N		0		Jimmy Bell
1330788	\N	\N		0		David Charkham
1330789	\N	\N		0		Simon Davis
1330790	\N	\N		0		Jonathan Daw
1330791	\N	\N		0		Péter Delmár
1330792	\N	\N		0		Terry Duggan
1330793	\N	\N		0		David Fleetwood
1330794	\N	\N		0		Danny Grover
1330795	\N	\N		0		Brian Hawley
1330796	\N	\N		0		David Hines
1330797	\N	\N		0		Tony Jackson
1330798	\N	\N		0		John Jordan
1330799	\N	\N		0		Scott MacKee
1330800	\N	\N		0		Laurence Marchant
613	1954-12-08	\N	Sumi Shimamoto is a Japanese voice actress.	0	Kōchi, Japan	Sumi Shimamoto
614	\N	\N		0		Mahito Tsujimura
615	1935-02-22	\N		1	Tokyo, Japan	Hisako Kyouda
616	1929-11-17	2013-03-05	Gorō Naya (納谷悟朗) was a Japanese actor, voice actor, narrator, and theater director.  He is most famous for voicing Inspector Kōichi Zenigata in the "Lupin III" anime series, and for his Japanese voice-overs of roles played by Clark Gable, Charlton Heston, and John Wayne.  He died in 2013 due to chronic respiratory failure.	2	Hakodate, Hokkaido, Japan	Gorō Naya
617	1931-05-10	2014-01-27		0	Osaka, Japan	Ichirō Nagai
618	\N	\N		0		Kōhei Miyauchi
619	1931-08-30	\N	Jōji Yanami (八奈見 乗児), born Shigemitsu Shirato (白土 繁満),is a Japanese voice actor.	2	 Tokyo, Japan	Jōji Yanami
620	\N	\N		0		Minoru Yada
621	1949-01-24	\N		0		Rihoko Yoshida
622	\N	\N		0		Yōji Matsuda
623	\N	\N		0		Mîna Tominaga
624	1956-05-31	\N		0		Yoshiko Sakakibara
625	1932-10-31	\N	​From Wikipedia, the free encyclopedia.\n\nIemasa Kayumi  (born October 31, 1932) is a Japanese voice actor, actor, and narrator from the Tokyo Metropolitan area. He is currently affiliated with 81 Produce.\n\nDescription above from the Wikipedia article Iemasa Kayumi, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Tokyo, Japan	Iemasa Kayumi
626	\N	\N		0		Tetsuo Mizutori
608	1941-01-05	\N	Hayao Miyazaki (Miyazaki Hayao, born January 5, 1941) is a Japanese manga artist and prominent film director and animator of many popular anime feature films. Through a career that has spanned nearly five decades, Miyazaki has attained international acclaim as a maker of animated feature films and, along with Isao Takahata, co-founded Studio Ghibli, an animation studio and production company. The success of Miyazaki's films has invited comparisons with American animator Walt Disney, British animator Nick Park as well as Robert Zemeckis, who pioneered Motion Capture animation, and he has been named one of the most influential people by Time Magazine.\n\nMiyazaki began his career at Toei Animation as an in-between artist for Gulliver's Travels Beyond the Moon where he pitched his own ideas that eventually became the movie's ending. He continued to work in various roles in the animation industry over the decade until he was able to direct his first feature film Lupin III: The Castle of Cagliostro which was published in 1979. After the success of his next film, Nausicaä of the Valley of the Wind, he co-founded Studio Ghibli where he continued to produce many feature films until Princess Mononoke whereafter he temporarily retired.\n\nWhile Miyazaki's films have long enjoyed both commercial and critical success in Japan, he remained largely unknown to the West until Miramax released his 1997 film, Princess Mononoke. Princess Mononoke was the highest-grossing film in Japan—until it was eclipsed by another 1997 film, Titanic—and the first animated film to win Picture of the Year at the Japanese Academy Awards. Miyazaki returned to animation with Spirited Away. The film topped Titanic's sales at the Japanese box office, also won Picture of the Year at the Japanese Academy Awards and was the first anime film to win an American Academy Award.\n\nMiyazaki's films often incorporate recurrent themes, such as humanity's relationship to nature and technology, and the difficulty of maintaining a pacifist ethic. Reflecting Miyazaki's feminism, the protagonists of his films are often strong, independent girls or young women. Miyazaki is a vocal critic of capitalism and globalization.[3] While two of his films, The Castle of Cagliostro and Castle in the Sky, involve traditional villains, his other films such as Nausicaa or Princess Mononoke present morally ambiguous antagonists with redeeming qualities.	2	Tokyo	Hayao Miyazaki
627	\N	\N		0		Rick Dempsey
5916	1979-05-09	\N	Rosario Dawson (born May 9, 1979) is an American actress, singer, and writer. She has appeared in films such as Kids, Men in Black II, 25th Hour, Sin City, Clerks II, Rent, Death Proof, The Rundown, Eagle Eye, Alexander, Seven Pounds, Percy Jackson and the Olympians: The Lightning Thief and Unstoppable.\n\nFrom Wikipedia, the free encyclopedia.	1	New York City, New York, USA	Rosario Dawson
3941	\N	\N		0		Andreas Wodraschke
3879	\N	\N		0		Dirk Oetelshoven
3943	\N	\N		0		Silke Koch
3944	\N	\N		0		Suse Marquardt
628	1935-10-29	\N	Isao Takahata is a Japanese film director, animator, screenwriter and producer who has earned critical international acclaim for his work as a director of anime films. Takahata is the co-founder of Studio Ghibli along with long-time collaborative partner Hayao Miyazaki. He has directed films such as the grim, war-themed Grave of the Fireflies, the romantic drama Only Yesterday, the ecological adventure Pom Poko, and the comedy My Neighbors the Yamadas. Unlike most anime directors, Takahata does not draw and never worked as an animator before becoming a full-fledged director. Takahata's most recent film is The Tale of the Princess Kaguya, which was nominated for an Academy Award in the category Best Animated Feature Film at the 87th Academy Awards.\n\nAccording to Hayao Miyazaki, "Music and study are his hobbies". He was born in the same town as fellow director Kon Ichikawa, while Japanese film giant Yasujiro Ozu was raised by his father in nearby Matsusaka.	0	Mie Prefecture, Japan	Isao Takahata
629	\N	\N		0		Hideshi Kyonen
630	\N	\N		0		Mark Henley
631	\N	\N		0		Ned Lott
632	\N	\N		0		Naoki Kaneko
633	\N	\N		0		Tomoko Kida
634	\N	\N		0		Shôji Sakai
635	\N	\N		0		Shigeharu Shiba
636	1950-12-06	\N	Mamoru Fujisawa (藤澤 守, Fujisawa Mamoru?), known professionally as Joe Hisaishi (久石 譲, Hisaishi Jō?, born December 6, 1950), is a composer and director known for over 100 film scores and solo albums dating back to 1981.\n\nWhile possessing a stylistically distinct sound, Hisaishi's music has been known to explore and incorporate different genres, including minimalist, experimental electronic, European classical, and Japanese classical. Lesser known are the other musical roles he plays; he is also a typesetter, author, arranger, and head of an orchestra.\n\nHe is best known for his work with animator Hayao Miyazaki, having composed scores for many of his films including Nausicaä of the Valley of the Wind (1984), My Neighbor Totoro (1988), Kiki's Delivery Service (1989), Princess Mononoke (1997), Spirited Away (2001), Howl's Moving Castle (2004) and Ponyo on the Cliff by the Sea (2008). He is also recognized for the soundtracks he has provided for filmmaker 'Beat' Takeshi Kitano, including Dolls (2002), Kikujiro (1999), Hana-bi (1997), Kids Return (1996) and Sonatine (1993).	2	Nagano Prefecture, Japan	Joe Hisaishi
1131668	\N	\N		0		Toru Hara
1131693	\N	\N		0		Michio Kondô
19595	1921-10-25	2000-09-20		2		Yasuyoshi Tokuma
549551	\N	\N		0		Mitsuki Nakamura
1100	1947-07-30	\N	Arnold Alois Schwarzenegger (born July 30, 1947) is an Austrian-American former professional bodybuilder, actor, model, businessman and politician who served as the 38th Governor of California (2003–2011). Schwarzenegger began weight training at 15. He was awarded the title of Mr. Universe at age 20 and went on to win the Mr. Olympia contest a total of seven times. Schwarzenegger has remained a prominent presence in the sport of bodybuilding and has written several books and numerous articles on the sport. Schwarzenegger gained worldwide fame as a Hollywood action film icon, noted for his lead roles in such films as Conan the Barbarian, The Terminator, Commando and Predator. He was nicknamed the "Austrian Oak" and the "Styrian Oak" in his bodybuilding days, "Arnie" during his acting career and more recently the "Governator" (a portmanteau of "Governor" and "Terminator"). As a Republican, he was first elected on October 7, 2003, in a special recall election (referred to in Schwarzenegger campaign propaganda as a "Total Recall") to replace then-Governor Gray Davis. Schwarzenegger was sworn in on November 17, 2003, to serve the remainder of Davis's term. Schwarzenegger was then re-elected on November 7, 2006, in California's 2006 gubernatorial election, to serve a full term as governor, defeating Democrat Phil Angelides, who was California State Treasurer at the time. Schwarzenegger was sworn in for his second term on January 5, 2007.\n\nDescription above from the Wikipedia article Arnold Schwarzenegger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Thal, Styria, Austria	Arnold Schwarzenegger
1101	1948-01-14	\N	​From Wikipedia, the free encyclopedia.\n\nCarl Weathers (born January 14, 1948) is an American actor, as well as former professional football player in the United States and Canada. He is best known for playing Apollo Creed in the Rocky series of films. He also played Dillon in the first Predator movie, Chubbs Peterson in Happy Gilmore and Little Nicky, and played a fictionalized version of himself in the television series Arrested Development.\n\nDescription above from the Wikipedia article Carl Weathers, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	New Orleans, Louisiana, USA	Carl Weathers
1102	1961-04-16	\N	​From Wikipedia, the free encyclopedia.  \n\nElpidia Carrillo (born August 16, 1961) is a Mexican actress who has appeared in various acclaimed Latin-American films and television shows, in addition to some Hollywood films. She is also credited as Elpedia Carrillo on some of her films. Carrillo was born in Parácuaro, Michoacán, Mexico. Perhaps her best acted role in Hollywood to date has been that of "Maria" in the 1986 movie Salvador, where she acted alongside James Woods. Arguably, though, her best known role would be as the survivor, Anna, in Predator with Arnold Schwarzenegger and a cameo in Predator 2. In American cinema, she has also worked with Jimmy Smits and many other stars.\n\nDescription above from the Wikipedia article Elpidia Carrillo , licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paracuaro, Michoacan, Mexico	Elpidia Carrillo
1103	1943-02-26	\N	William Henry "Bill" Duke, Jr. (born February 26, 1943) is an American actor and film director with over 30 years of experience. Known for his physically imposing frame, Duke's work frequently dwells within the action/crime and drama genres but also includes comedy.\n\nDescription above from the Wikipedia article Bill Duke , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Poughkeepsie, New York, USA	Bill Duke
1098	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nMark Helfrich is an ACE (American Cinema Editor)-certified film editor. He has edited over thirty films, such as the cult classic Showgirls (1995) with Mark Goldblatt. Helfrich is also the primary editor for director Brett Ratner's films, such as Money Talks (1997), Rush Hour (1998), The Family Man (2000), Rush Hour 2 (2001), Red Dragon (2002), and After the Sunset (2004), X-Men: The Last Stand (2006) with Mark Goldblatt and Julia Wong. After that, he directed his first feature, Good Luck Chuck, using Julia Wong as his editor.\n\nHe has also edited with Brett Ratner's direction a version of the Bollywood film production titled Kites:The Remix aka Kites (film) (2010), and he edited the pilot episode for Prison Break, an American based TV prison drama series produced by Brett Ratner. He also edited Brett Ratner's music video "Beautiful Stranger" for Madonna.\n\nDescription above from the Wikipedia article Mark Helfrich, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Mark Helfrich
1099	\N	\N		0		John F. Link
7719	\N	\N		0		Marilyn Vance
6527	\N	\N		0		Miguel Ángel Hernando Trillo
6528	\N	\N		0		Alex Catalán
6529	\N	\N		0		J. Manuel G. Moyano
6530	\N	\N		0		Eva Leira
1104	1951-07-15	\N	James George Jano, better known by his stage name, Jesse Ventura, is an American politician, actor, author, naval veteran, and former professional wrestler who served as the 38th Governor of Minnesota from 1999 to 2003.\n\nBorn James George Janos, Ventura served as a U.S. Navy Underwater Demolition Team member during the period of the Vietnam War. After leaving the military, he embarked on a professional wrestling career from 1975 to 1986, taking the ring name Jesse "The Body" Ventura. He had a long tenure in the World Wrestling Federation as a performer and color commentator, and was inducted into the Federation's Hall of Fame in 2004. Apart from wrestling, Ventura also pursued a film career, appearing in films such as Predator (1987).\n\nVentura first entered politics as Mayor of Brooklyn Park, Minnesota, from 1991 to 1995. Four years after his mayoral term ended, Ventura was the Reform Party candidate in the Minnesota gubernatorial election of 1998, running a low-budget campaign centered on grassroots events and unusual ads that urged citizens not to "vote for politics as usual". Ventura's campaign was successful, with him narrowly and unexpectedly defeating both the Democratic and Republican candidates. The highest elected official to ever win an election on a Reform Party ticket, Ventura left the Reform Party a year after taking office amid internal fights for control over the party.\n\nAs governor, Ventura oversaw reforms of Minnesota's property tax as well as the state's first sales tax rebate. Other initiatives taken under Ventura included construction of the METRO Blue Line light rail in the Minneapolis–Saint Paul metropolitan area, and cuts in income taxes.\n\nVentura left office in 2003, deciding not to run for re-election. After leaving office, Ventura became a visiting fellow at Harvard University's John F. Kennedy School of Government in 2004. He has since also hosted a number of television shows and has written several political books. Ventura remains politically active and currently hosts a show on Ora TV called Off the Grid. He has publicly contemplated a run for President of the United States in 2016.	0	Minneapolis - Minnesota - USA	Jesse Ventura
1105	1941-02-11	\N	William M. "Sonny" Landham (born February 11, 1941) is an American movie actor and political candidate.\n\nDescription above from the Wikipedia article Sonny Landham, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Canton, Georgia, United States	Sonny Landham
1106	1951-10-09	\N		0		Richard Chaves
1107	1917-04-07	2012-07-27	​From Wikipedia, the free encyclopedia.  \n\nRobert Golden "R.G." Armstrong (born April 7, 1917) is an American actor and playwright. A veteran character actor who appeared in dozens of Westerns over the course of his 40-year career, he may be best remembered for his work with director Sam Peckinpah.\n\nDescription above from the Wikipedia article R. G. Armstrong, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Birmingham, Alabama, U.S.	R. G. Armstrong
1108	1961-12-16	\N	From Wikipedia, the free encyclopedia.\n\nShane Black (born December 16, 1961) is an American actor, screenwriter and film director. He contributed to some of the biggest blockbuster action films of the late 1980s and early 1990s, including work on Lethal Weapon and The Last Boy Scout.\n\nDescription above from the Wikipedia article Shane Black, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Pittsburgh, Pennsylvania, USA	Shane Black
1109	1955-05-09	1991-04-10	​From Wikipedia, the free encyclopedia.  \n\nKevin Peter Hall (May 9, 1955 – April 10, 1991) was an American actor known for his roles in Misfits of Science, Prophecy, Without Warning, and Harry and the Hendersons. He was also best known as the title character in the first two films in the Predator franchise.\n\nDescription above from the Wikipedia article Kevin Peter Hall, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Pittsburgh, Pennsylvania, U.S.	Kevin Peter Hall
20761	1944-09-24	\N		0		Sven-Ole Thorsen
1090	1951-01-08	\N	From Wikipedia, the free encyclopedia.\n\nJohn Campbell McTiernan, Jr. (born January 8, 1951) is an American film director and producer, best known for his action films and most identifiable with the three films he directed back-to-back: Predator, Die Hard, and The Hunt for Red October, along with later movies such as Last Action Hero, Die Hard With A Vengeance, and The Thomas Crown Affair. More recently, McTiernan was in the news for his criminal conviction in the Anthony Pellicano wiretapping scandal.\n\nDescription above from the Wikipedia article John McTiernan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Albany, New York, USA	John McTiernan
1091	1952-07-14	\N	From Wikipedia, the free encyclopedia.\n\nJoel Silver (born July 14, 1952) is an American film producer, known for action films like Lethal Weapon and Die Hard. He is owner of Silver Pictures and co-founder of Dark Castle Entertainment.\n\nSilver grew up in South Orange, New Jersey, the son of a writer and a public relations executive. He attended Columbia High School in Maplewood, New Jersey, where he is credited with inventing the sport of Ultimate (then known as "Ultimate Frisbee"). In 1970, he entered Lafayette College, where he formed the first collegiate Ultimate team. He finished his undergraduate studies at the New York University's Tisch School of the Arts. Silver began his career at Lawrence Gordon Productions, where he eventually became president of motion pictures for the company. He earned his first screen credit as the associate producer on The Warriors and, with Gordon, produced 48 Hrs.,Streets of Fire and Brewster's Millions. In 1985, he formed Silver Pictures and produced successful action films such as Commando (1985), the Lethal Weapon franchise, the first two films of the Die Hard series and the The Matrix franchise of action films. Silver appears on-screen at the beginning of Who Framed Roger Rabbit as Raoul J. Raoul, the director of the animated short Something's Cookin. Silver directed "Split Personality", (1992), an episode of the HBO horror anthology, Tales from the Crypt. He currently runs two production companies, Silver Pictures and Dark Castle Entertainment co-owned by Robert Zemeckis. Along with Jared Kass, Silver was co-creator of the sport of Ultimate. On July 10, 1999, Silver married his production assistant Karyn Fields.\n\nDescription above from the Wikipedia article Joel Silver, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	South Orange, New Jersey, USA	Joel Silver
1092	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nJames E. "Jim" Thomas is a screenwriter based in California. With his brother John Thomas, he wrote or was substantially involved in the screenplays of the following films: Predator (1987), Predator 2 (1990), Executive Decision (1996), Wild Wild West (1999), Mission to Mars (2000), and Behind Enemy Lines (2001). He also used to be a math teacher at Metuchen High School.\n\nDescription above from the Wikipedia article Jim Thomas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Jim Thomas
1093	1936-03-25	\N		2	Yazoo City, Mississippi, USA	Lawrence Gordon
1094	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nJohn C. Thomas is an American screenwriter based in California. With his brother Jim Thomas, he wrote or was substantially involved in the screenplays of the following films: Predator (1987), Predator 2 (1990), Executive Decision (1996), Wild Wild West (1999), Mission to Mars (2000), and Behind Enemy Lines (2001).\n\nDescription above from the Wikipedia article John Thomas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		John Thomas
1095	\N	\N		0		Donald McAlpine
37	1950-03-26	\N		2		Alan Silvestri
1096	1953-06-23	2004-03-15		0		John Vallone
1097	\N	\N		0		Jackie Burch
1433	\N	\N		0		Marty Balin
1435	\N	\N		0		Sonny Barger
1436	1907-07-29	1996-07-09		0		Melvin Belli
1437	\N	\N		0		Dick Carter
1438	\N	\N		0		Jack Casady
976	1967-07-26	\N	Jason Statham (born 26. Juli 1967) is an English actor and martial artist, known for his roles in the Guy Ritchie crime films Lock, Stock and Two Smoking Barrels; Revolver; and Snatch.\n\nStatham appeared in supporting roles in several American films, such as The Italian Job, as well as playing the lead role in The Transporter, Crank, The Bank Job, War (opposite martial arts star Jet Li), and Death Race. Statham solidified his status as an action hero by appearing alongside established action film actors Sylvester Stallone, Arnold Schwarzenegger, Bruce Willis, Jet Li and Dolph Lundgren in The Expendables. He normally performs his own fight scenes and stunts.\n\nDescription above from the Wikipedia article Jason Statham, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Shirebrook, Derbyshire, England, UK	Jason Statham
287	1963-12-18	\N	William Bradley "Brad" Pitt (born December 18, 1963) is an American actor and film producer. Pitt has received two Academy Award nominations and four Golden Globe Award nominations, winning one. He has been described as one of the world's most attractive men, a label for which he has received substantial media attention. Pitt began his acting career with television guest appearances, including a role on the CBS prime-time soap opera Dallas in 1987. He later gained recognition as the cowboy hitchhiker who seduces Geena Davis's character in the 1991 road movie Thelma &amp; Louise. Pitt's first leading roles in big-budget productions came with A River Runs Through It (1992) and Interview with the Vampire (1994). He was cast opposite Anthony Hopkins in the 1994 drama Legends of the Fall, which earned him his first Golden Globe nomination. In 1995 he gave critically acclaimed performances in the crime thriller Seven and the science fiction film 12 Monkeys, the latter securing him a Golden Globe Award for Best Supporting Actor and an Academy Award nomination.\n\nFour years later, in 1999, Pitt starred in the cult hit Fight Club. He then starred in the major international hit as Rusty Ryan in Ocean's Eleven (2001) and its sequels, Ocean's Twelve (2004) and Ocean's Thirteen (2007). His greatest commercial successes have been Troy (2004) and Mr. &amp; Mrs. Smith (2005).\n\nPitt received his second Academy Award nomination for his title role performance in the 2008 film The Curious Case of Benjamin Button. Following a high-profile relationship with actress Gwyneth Paltrow, Pitt was married to actress Jennifer Aniston for five years. Pitt lives with actress Angelina Jolie in a relationship that has generated wide publicity. He and Jolie have six children—Maddox, Pax, Zahara, Shiloh, Knox, and Vivienne.\n\nSince beginning his relationship with Jolie, he has become increasingly involved in social issues both in the United States and internationally. Pitt owns a production company named Plan B Entertainment, whose productions include the 2007 Academy Award winning Best Picture, The Departed.	2	Shawnee - Oklahoma - USA	Brad Pitt
980	1965-01-05	\N	From Wikipedia, the free encyclopedia.\n\nVincent Peter "Vinnie" Jones (born 5 January 1965) is a retired British footballer and film actor.\n\nJones represented and captained the Welsh national football team, having qualified via a Welsh grandparent. He also previously played for Chelsea and Leeds United. As a member of the "Crazy Gang", Jones won the 1988 FA Cup Final with Wimbledon. Jones appeared in the 7th and final series of UK gameshow Celebrity Big Brother finishing in 3rd place behind Dane Bowers and Alex Reid.\n\nHe has capitalised on his tough man image as a footballer and is known as an actor for his aggressive style and intimidating demeanour, often being typecast into roles as coaches, hooligans and violent criminals.\n\nDescription above from the Wikipedia article Vinnie Jones, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Watford - Hertfordshire - England - UK	Vinnie Jones
1117	1944-02-29	2013-07-22	​\n\nDennis Farina was one of Hollywood's busiest actors and a familiar face  to moviegoers and television viewers alike. Recently, he appeared in the  feature films, "The Grand," a comedy about a Vegas poker tournament  with Woody Harrelson, Cheryl Hines and Ray Romano; "Bottle Shock," also  starring Alan Rickman, Bill Pullman and Bradley Whitford; and Fox's  "What Happens in Vegas," in which Dennis starred as Cameron Diaz's boss.  Farina also appeared on the NBC series "Law and Order" and in the HBO  miniseries, "Empire Falls," for which he won a Golden Globe Award for  Best Mini-Series.\n\nFarina is well remembered for his role in  memorable features such as Steven Soderbergh's "Out of Sight," in which  he played the retired lawman father of Jennifer Lopez's character. This  was Farina's second outing in an Elmore Leonard best seller, the  previous one being "Get Shorty," directed by Barry Sonnenfeld and  co-starring John Travolta, Rene Russo and Gene Hackman. Farina received  an American Comedy Award for Funniest Supporting Male for his  performance as "Ray 'Bones' Barboni."\n\nIn 1998's "Saving Private  Ryan," directed by Steven Spielberg, Farina played "Col. Anderson," a  pivotal role in the film. It is this character who convinces Tom Hanks  character to lead a squad deep into Nazi territory to rescue "Pvt.  Ryan." He also co-starred with Brad Pitt and Oscar-winner Benicio Del  Toro in the darkly comedic crime drama "Snatch," directed by Guy  Ritchie.\n\nFarina's numerous other screen credits include John  Frankenheimer's "Reindeer Games," "Paparazzi," Martin Brest's "Midnight  Run," the Michael Mann film "Manhunter", among many other feature films.  Farina is also recognized for his role in the critically acclaimed  television series, NBC's "Crime Story". A veteran of the Chicago  theater, Farina has appeared in Joseph Mantegna's "Bleacher Bums," and  "A Prayer For My Daughter," directed by John Malkovich, and many others.  He died on July 22, 2013 in Scottsdale, Arizona at age 69.	0	Chicago, Illinois, USA	Dennis Farina
1121	1967-02-19	\N	Benicio Monserrate Rafael del Toro Sánchez (born February 19, 1967) is a Puerto Rican actor and film producer. His awards include the Academy Award, Golden Globe, Screen Actors Guild (SAG) Award and British Academy of Film and Television Arts (BAFTA) Award. He is known for his roles as Fred Fenster in The Usual Suspects, Javier Rodríguez in Traffic (his Oscar-winning role), Jack 'Jackie Boy' Rafferty in Sin City, Dr. Gonzo in Fear and Loathing in Las Vegas, Franky Four Fingers in Snatch, and Che Guevara in Che. He is the third Puerto Rican to win an Academy Award.\n\nDescription above from the Wikipedia article Benicio del Toro, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Santurce, Puerto Rico	Benicio del Toro
1428	1943-07-26	\N	​From Wikipedia, the free encyclopedia.  \n\nSir Michael Philip "Mick" Jagger (born 26 July 1943) is an English musician, singer-songwriter, actor, and producer, best known as the lead vocalist of rock band, The Rolling Stones. Jagger has also acted in and produced several films. The Rolling Stones started in the early 1960s as a rhythm and blues cover band with Jagger as frontman. Beginning in 1964, Jagger and guitarist Keith Richards developed a songwriting partnership, and by the mid-1960s the group had evolved into a major rock band. Frequent conflict with the authorities (including alleged drug use and his romantic involvements) ensured that during this time Jagger was never far from the headlines, and he was often portrayed as a counterculture figure. In the late 1960s Jagger began acting in films (starting with Performance and Ned Kelly), to mixed reception. In the 1970s, Jagger, with the rest of the Stones, became tax exiles, consolidated their global position and gained more control over their business affairs with the formation of the Rolling Stones Records label. During this time, Jagger was also known for his high-profile marriages to Bianca Jagger and later to Jerry Hall. In the 1980s Jagger released his first solo album, She's the Boss. He was knighted in 2003. Jagger's career has spanned over 50 years. His performance style has been said to have "opened up definitions of gendered masculinity and so laid the foundations for self-invention and sexual plasticity which are now an integral part of contemporary youth culture". In 2006, he was ranked by Hit Parader as the fifteenth greatest heavy metal singer of all time, despite not being associated with the genre. Allmusic has described Jagger as "one of the most popular and influential frontmen in the history of rock &amp; roll". His distinctive voice and performance, along with Keith Richards' guitar style, have been the trademark of The Rolling Stones throughout their career.\n\nDescription above from the Wikipedia article Mick Jagger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Dartford, Kent, England	Mick Jagger
1430	1943-12-18	\N	From Wikipedia, the free encyclopedia.  \n\nKeith Richards (born 18 December 1943) is an English musician, songwriter, and founding member of the rock band the Rolling Stones ranked by Rolling Stone magazine as the "10th greatest guitarist of all time." Fourteen songs Richards wrote with songwriting partner and the Rolling Stones' vocalist Mick Jagger were listed on Rolling Stone's "500 Greatest Songs of All Time".\n\nDescription above from the Wikipedia article Keith Richards, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dartford, Kent, England, United Kingdom	Keith Richards
1429	1941-06-02	\N	​From Wikipedia, the free encyclopedia.  \n\nCharles Robert "Charlie" Watts (born 2 June 1941) is an English drummer, best known as a member of The Rolling Stones. He is also the leader of a jazz band, as well as a record producer, commercial artist, and horse breeder.\n\nDescription above from the Wikipedia article Charlie Watts, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England	Charlie Watts
1431	1936-10-24	\N	​From Wikipedia, the free encyclopedia.  \n\nBill Wyman (born William George Perks; 24 October 1936) is an English musician best known as the bass guitarist for the English rock and roll band The Rolling Stones from 1962 until 1992. Since 1997, he has recorded and toured with his own band, Bill Wyman's Rhythm Kings. He has worked producing both records and film, and has scored music for film in movies and television.\n\nWyman has kept a journal since he was a child after World War II. It has been useful to him as an author who has written seven books, selling two million copies. Wyman's love of art has additionally led to his proficiency in photography and his photographs have hung in galleries around the world.[1] Wyman's lack of funds in his early years led him to create and build his own fretless bass guitar. He became an amateur archaeologist and enjoys relic hunting; The Times published a letter about his hobby (Friday 2 March 2007). He designed and markets a patented "Bill Wyman signature metal detector", which he has used to find relics dating back to era of the Roman Empire in the English countryside. As a businessman, he owns several establishments including the famous Sticky Fingers Café, a rock &amp; roll-themed bistro serving American cuisine first opened in 1989 in the Kensington area of London and later, two additional locations in Cambridge and Manchester, England.\n\nDescription above from the Wikipedia article Bill Wyman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lewisham, London, England United Kingdom	Bill Wyman
1432	1948-01-17	\N	​From Wikipedia, the free encyclopedia.  \n\nMichael Kevin "Mick" Taylor (born 17 January 1949 in Welwyn Garden City, Hertfordshire) is an English musician, best known as a former member of John Mayall's Bluesbreakers (1966–69) and The Rolling Stones (1969–74). During his tenure with those bands, Taylor gained a reputation as a reliable technical guitarist with a preference for blues, rhythm and blues, and rock and roll, and a talent for slide guitar. Since his resignation from the Rolling Stones in December 1974 at age 25, Taylor has worked with numerous other artists as well as releasing a number of solo albums.\n\nDescription above from the Wikipedia article Mick Taylor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Welwyn Garden City, England United Kingdom	Mick Taylor
1442	1942-08-01	1995-08-09	From Wikipedia, the free encyclopedia.  Jerome John "Jerry" Garcia (August 1, 1942 – August 9, 1995) was an American musician best known for his lead guitar work, singing and songwriting with the band the Grateful Dead.Though he vehemently disavowed the role, Garcia was viewed by many as the leader or "spokesman" of the group. \n\nOne of its founders, Garcia performed with the Grateful Dead for their entire three-decade career \n\n(1965–1995). Garcia also founded and participated in a variety of side projects, including the Saunders-Garcia Band (with longtime friend Merl Saunders), Jerry Garcia Band, Old and in the Way, the Garcia/Grisman acoustic duo, Legion of Mary, and the New Riders of the Purple Sage (which Garcia co-founded with John Dawson and David Nelson).  He also released several solo albums, and contributed to a number of albums by other artists over the years as a session musician. He was well known by many for his distinctive guitar playing and was ranked 13th in Rolling Stone's "100 Greatest Guitarists of All Time" cover story. Later in life, Garcia was sometimes ill because of his unstable weight, and in 1986 went into a diabetic coma that nearly cost him his life. Although his overall health improved somewhat after that, he also struggled with heroin addiction,  and was staying in a California drug rehabilitation facility when he died of a heart  attack in August 1995.  Description above from the Wikipedia article Jerry Garcia, licensed under CC-BY-SA,full list of contributors on Wikipedia. \n\n  \n\n 	0	San Francisco, California, U.S.	Jerry Garcia
1443	\N	\N		0		Chris Hillman
1444	\N	\N		0		Meredith Hunter
1445	\N	\N		0		Paul Kantner
1446	\N	\N		0		Jorma Kaukonen
1447	\N	\N		0		Pete Kleinow
1448	\N	\N		0		Michael Lang
1449	\N	\N		0		Bernie Leadon
1451	\N	\N		0		Gram Parsons
1452	\N	\N		0		Alan Passaro
1422	\N	\N		0		Roland Schneider
1454	\N	\N		0		Rock Scully
1455	\N	\N		0		Michael Shrieve
1456	\N	\N		0		Grace Slick
1457	1938-07-05	2007-06-20		2	Rapid City, South Dakota, USA	Frank Terry
1458	1931-11-05	2007-12-12		0	Clarksdale - Mississippi - USA	Ike Turner
1459	1939-11-26	\N	​From Wikipedia, the free encyclopedia.\n\nTina Turner  (born Anna Mae Bullock; November 26, 1939) is an American singer and actress whose career has spanned more than 50 years. She has won numerous awards and her achievements in the rock music genre have earned her the title The Queen of Rock 'n' Roll. Turner started out her music career with husband Ike Turner as a member of the Ike &amp; Tina Turner Revue. Success followed with a string of hits including "River Deep, Mountain High" and the 1971 hit "Proud Mary". With the publication of her autobiography I, Tina (1986), Turner revealed severe instances of spousal abuse against her by Ike Turner prior to their 1976 split and subsequent 1978 divorce. After virtually disappearing from the music scene for several years following her divorce from Ike Turner, she rebuilt her career, launching a string of hits beginning in 1983 with the single "Let's Stay Together" and the 1984 release of her fifth solo album Private Dancer.\n\nHer musical career led to film roles, beginning with a prominent role as The Acid Queen in the 1975 film Tommy, and an appearance in Sgt. Pepper's Lonely Hearts Club Band. She starred opposite Mel Gibson as Aunty Entity in Mad Max Beyond Thunderdome for which she received the NAACP Image Award for Outstanding Actress in a Motion Picture, and her version of the film's theme, "We Don't Need Another Hero", was a hit single. She appeared in the 1993 film Last Action Hero.\n\nOne of the world's most popular entertainers, Turner has been called the most successful female rock artist and was named "one of the greatest singers of all time" by Rolling Stone. Her combined album and single sales total approximately 180 million copies worldwide. She has sold more concert tickets than any other solo music performer in history. She is known for her energetic stage presence, powerful vocals, career longevity, and widespread appeal. In 2008, Turner left semi-retirement to embark on her Tina!: 50th Anniversary Tour. Turner's tour became one of the highest selling ticketed shows of 2008-2009. Turner was born a Baptist, but converted to Buddhism and credits the spiritual chants with giving her the strength that she needed to get through the rough times.\n\nDescription above from the Wikipedia article Tina Turner, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Nutbush, Tennessee, USA	Tina Turner
1418	1926-11-26	\N	From Wikipedia, the free encyclopedia\n\nAlbert (born November 26, \n\n1926, Boston, Massachusetts) and David Maysles (rhymes with "hazels", \n\nborn 10 January 1932, Boston, Massachusetts) were a documentary \n\nfilmmaking team whose cinéma vérité works include Salesman (1968), Gimme\n\n Shelter (1970) and Grey Gardens (1976). Their 1964 film on The Beatles \n\nforms the backbone of the DVD, The Beatles: The First U.S. Visit. \n\nSeveral Maysles films document art projects by Christo and Jeanne-Claude\n\n over a three-decade period, from 1974 when Christo's Valley Curtain was\n\n nominated for an Academy Award to 2005 when The Gates headlined New \n\nYork's Tribeca Film Festival.\n\nDavid Maysles, the younger brother,\n\n died of a stroke on January 3, 1987, in New York. Albert Maysles \n\ngraduated in 1949 with a BA from Syracuse University and later earned a \n\nmasters degree at Boston University. Albert has continued to make films \n\non his own since his brother's death. Jean-Luc Godard once called Albert\n\n Maysles "the best American cameraman". In 2005 Maysles was given a \n\nlifetime achievement award at the Czech film festival AFO (Academia Film\n\n Olomouc). He is working on his own autobiographical documentary.\n\nIn\n\n 2005 he founded the Maysles Institute, a nonprofit organization that \n\nprovides training and apprenticeships to underprivileged individuals. \n\nAlbert is a patron of Shooting People, a filmmakers' community.\n\nDescription\n\n above from the Wikipedia article Albert and David Maysles, licensed \n\nunder CC-BY-SA, full list of contributors on Wikipedia.	0	Brookline, Massachusetts, USA	Albert Maysles
1460	\N	\N		0		Ian Stewart
556171	1940-03-15	\N	From Wikipedia, the free encyclopedia.  Phillip Chapman Lesh (born March 15, 1940 in Berkeley, California) is a musician and a founding member of the Grateful Dead, with whom he played bass guitar throughout their 30-year career.\n\nAfter the band's disbanding in 1995, Lesh continued the tradition of Grateful Dead family music with side project Phil Lesh and Friends, which paid homage to the Dead's music by playing their originals, common covers, and the songs of the members of his band. Phil &amp; Friends helped keep a legitimate entity for the band's music to continue but have been on hiatus since 2008. Recently, Lesh has been performing with Furthur alongside former Dead bandmate Bob Weir.\n\nDescription above from the Wikipedia article Phil Lesh, licensed under CC-BY-SA,full list of contributors on Wikipedia. \n\n  \n\n 	0	Berkeley, California, USA	Phil Lesh
1461	1961-05-06	\N	Timothy Clooney (born May 6, 1961) is an American actor, film director, producer, and screenwriter. He has received three Golden Globe Awards for his work as an actor and two Academy Awards—one for acting and the other for producing. Clooney is also noted for his political activism and has served as one of the United Nations Messengers of Peace since January 31, 2008.\n\nBorn in Lexington, Kentucky, as son of Nick Clooney, a TV newscaster of many years, who hosted a talk show at Cincinnati and often invited George into the studios already at the age of 5. Avoiding competition with his father, he quit his job as broadcast journalist after a short time.\n\nStudied a few years at Northern Kentucky University. Failed to join the Cincinnati Reds baseball team. He came to acting when his cousin, Miguel Ferrer, got him a small part in a feature film. After that, he moved to L.A. in 1982 and tried a whole year to get a role while he slept in a friend's closet. His first movie, together with Charlie Sheen, stayed unreleased but got him the producers' attention for later contracts.	2	Lexington, Kentucky, USA	George Clooney
1892	1970-10-08	\N	Matthew Paige "Matt" Damon (born October 8, 1970) is an American actor, screenwriter, and philanthropist.\n\nHis career launched following the success of the film Good Will Hunting (1997) from a screenplay he co-wrote with friend Ben Affleck. The pair won an Academy Award for Best Original Screenplay and a Golden Globe Award for Best Screenplay for their work. Damon alone received multiple Best Actor nominations, including an Academy Award nomination for his lead performance in the film. Damon has since starred in commercially successful films such as Saving Private Ryan (1998), the Ocean's trilogy, and the first three films in the Bourne series, while also gaining critical acclaim for his performances in dramas such as Syriana (2005), The Good Shepherd (2006), and The Departed (2006). He garnered a Golden Globe nomination for portraying the title character in The Talented Mr. Ripley (1999) and was nominated for an Academy Award for Best Supporting Actor in Invictus (2009).\n\nHe is one of the top 40 highest grossing actors of all time. In 2007, Damon received a star on the Hollywood Walk of Fame and was named Sexiest Man Alive by People magazine. Damon has been actively involved in charitable work, including the ONE Campaign, H2O Africa Foundation, and Water.org.	2	Boston, Massachusetts, USA	Matt Damon
6531	\N	\N		0		Yolanda Serrano
6532	\N	\N		0		Javier López
6533	\N	\N		0		Fernando García
5634	1931-03-22	2015-02-20		1	California, USA	Patricia Norris
1271	1956-04-12	\N	Andrés Arturo García Menéndez (born April 12, 1956), professionally known as Andy García, is a Cuban American actor. He became known in the late 1980s and 1990s, having appeared in several successful Hollywood films, including The Godfather: Part III, The Untouchables, Internal Affairs and When a Man Loves a Woman. More recently, he has starred in Ocean's Eleven and its sequels, Ocean's Twelve and Ocean's Thirteen, and The Lost City. García was nominated for the Academy Award for Best Supporting Actor for his role as Vincent Mancini in The Godfather Part III.\n\nDescription above from the Wikipedia article Andy Garcia, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Havana, Cuba	Andy García
1204	1967-10-28	\N	Julia Fiona Roberts was born on October 28, 1967 in Atlanta Georgia. Her brother Eric Roberts, sister Lisa Roberts Gillan and niece Emma Roberts, are also actors. She became a Hollywood star after headlining the 1990's romantic comedy Pretty Woman, which grossed $464 million worldwide. After receiving Academy Award nominations for Steel Magnolias in 1990 and Pretty Woman in 1991, she won the Academy Award for Best Actress in 2001 for her performance in Erin Brockovich.  Roberts made her first big screen appearance in the film Satisfaction, released on February 12, 1988. She had previously performed a small role opposite her brother, Eric, in Blood Red. Her first critical success with moviegoers was her performance in the independent film Mystic Pizza in 1988. The following year, she was featured in Steel Magnolias as a young bride with diabetes and got her first Academy Award nomination as Best Supporting Actress. Roberts became known to worldwide audiences when she co-starred with Richard Gere in Pretty Woman in 1990. The role also earned her a second Oscar nomination, this time as Best Actress. Her next box office success was the thriller Sleeping with the Enemy (1991). Also in 1991, She played Tinkerbell in Steven Spielberg's Hook and also played a nurse in the film Dying Young. This work was followed by a two-year hiatus, during which she made no films other than a cameo appearance in Robert Altman's The Player (1992). In 1993, she co-starred with Denzel Washington in The Pelican Brief, based on the John Grisham novel. In 1994, she starred in the comedy I Love Trouble and in the 1995 comedy-drama Something to Talk About. She then starred alongside Liam Neeson in the 1996 film Michael Collins. Robert’s next commercial and critical success was the film, My Best Friend's Wedding in 1997. She starred with Hugh Grant in the 1999 film Notting Hill. That same year, she also starred in Runaway Bride, her second film with Richard Gere. Also in 1999, she starred in the critically panned film Stepmom alongside Susan Sarandon. In 2001, Roberts received the Academy Award for Best Actress for her portrayal of Erin Brockovich. Later in 2001, she starred in the road gangster comedy The Mexican alongside her longtime friend Brad Pitt. She then starred in the romantic comedy America’s Sweethearts that same year. Roberts would team up with Erin Brockovich director Steven Soderbergh for three more films: Ocean's Eleven (2001), Full Frontal (2002), and Ocean's Twelve (2004). In 2003, Roberts was paid an unprecedented $25 million for her role in the film, Mona Lisa Smile. The following year, she starred alongside Clive Owen, Natalie Portman and Jude Law in the critically acclaimed film Closer (2004), based on the 1997 award winning play by Patrick Marber. Roberts had two films released in 2006, The Ant Bully and Charlotte's Web. Both films were animated features for which she provided voice acting. Also in 2006, Roberts made her Broadway debut as Nan in a revival of Richard Greenberg's 1997 play Three Days of Rain opposite Bradley Cooper and Paul Rudd. Her next film was Charlie Wilson's War, with Tom Hanks (2007) and in 2008; she starred alongside Ryan Reynolds and Willem Dafoe in Fireflies in the Garden, which was released at the Berlin International Film Festival. In her next film, Roberts again starred with Clive Owen in the comedy-thriller Duplicity for which she received her seventh Golden Globe nomination. In 2010, she appeared in the ensemble romantic comedy Valentine's Day, with Bradley Cooper, and starred in the film adaptation of Eat Pray Love. As of 2011, Roberts is set to star alongside Tom Hanks in comedy-drama Larry Crowne. In addition to acting, Roberts has brought to life some of the books from American Girl as films, serving as executive producer alongside her sister Lisa. Roberts had become one of the highest-paid actresses in the world, topping the Hollywood Reporter's annual "power list" of top-earning female stars from 2005 to 2006. As of 2010, Roberts's net worth was estimated to be $140 million. Roberts is married to cameraman Daniel Moder. Together they have three children.	1	Smyrna, Georgia, USA	Julia Roberts
1893	1975-08-12	\N	Caleb Casey McGuire Affleck-Boldt (born August 12, 1975), best known as Casey Affleck is an American actor and film director. Throughout the 1990s and early 2000s, he played supporting roles in mainstream hits like Good Will Hunting (1997) and Ocean's Eleven (2001) as well as in critically acclaimed independent films such as Chasing Amy (1997). During this time, he became known as the younger brother of actor and director Ben Affleck, with whom he has frequently collaborated professionally. In 2007, his breakout year, Affleck gained recognition and critical acclaim for his work in Gone Baby Gone and The Assassination of Jesse James by the Coward Robert Ford, which gained him an Academy Award nomination for Best Supporting Actor.\n\nDescription above from the Wikipedia article Casey Affleck, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Falmouth, Massachusetts, USA	Casey Affleck
1894	1976-08-23	\N	Scott Andrew Caan (born August 23, 1976) is an American actor. He stars in the CBS television series Hawaii Five-0. He is the son of actor James Caan.\n\nDescription above from the Wikipedia article Scott Caan, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Los Angeles - California - USA	Scott Caan
1895	1922-03-20	\N	From Wikipedia, the free encyclopedia.\n\nCarl Reiner (born March 20, 1922) is an American actor, film director, producer, writer and comedian. He has won nine Emmy Awards and one Grammy Award during this career. He has the distinction of being the only person to appear on the The Tonight Show with each of its five hosts.\n\nDescription above from the Wikipedia article Carl Reiner, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Bronx, New York, U.S.	Carl Reiner
1897	1957-10-05	2008-08-09	Bernard Jeffrey McCullough (October 5, 1957 – August 9, 2008), better known by his stage name, Bernie Mac, was an American actor and comedian. Born and raised on the South Side of Chicago, Mac gained popularity as a stand-up comedian. He joined comedians Steve Harvey, Cedric the Entertainer, and D. L. Hughley as The Original Kings of Comedy. After briefly hosting the HBO show Midnight Mac, Mac appeared in several films in smaller roles. His most noted film role was as Frank Catton in the remake Ocean's Eleven and the titular character of Mr. 3000. He was the star of The Bernie Mac Show, which ran from 2001 through 2006, earning him two Emmy Award nominations for Outstanding Lead Actor in a Comedy Series. His other films included starring roles in Booty Call, Friday, The Players Club, Head of State, Charlie's Angels: Full Throttle, Bad Santa, Guess Who, Pride, Soul Men, Transformers and Madagascar: Escape 2 Africa.\n\nMac suffered from sarcoidosis, an inflammatory lung disease that produces tiny lumps of cells in the solid organs, but had said the condition was in remission in 2005. His death on August 9, 2008, was caused by complications from pneumonia.\n\nDescription above from the Wikipedia article Bernie Mac, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Chicago - Illinois - USA	Bernie Mac
827	1938-08-29	\N	Elliott Gould (born Elliot Goldstein; August 29, 1938) is an American actor. He began acting in Hollywood films during the 1960s, and has remained prolific ever since. Some of his most notable films include MAS*H and Bob &amp; Carol &amp; Ted &amp; Alice, for which he received an Oscar nomination. In recent years, he has starred as Reuben Tishkoff in Ocean's Eleven, Ocean's Twelve, and Ocean's Thirteen.\n\nDescription above from the Wikipedia article Elliott Gould, licensed under CC-BY-SA, full list of contributors on Wikipedia​	2	Brooklyn - New York - USA	Elliott Gould
1898	\N	\N		0		Eddie Jemison
1900	\N	\N		0		Shaobo Qin
1906	\N	\N		0		Scott L. Schwartz
240770	\N	\N		0		Scott Beringer
14731	1928-09-15	\N	From Wikipedia, the free encyclopedia\n\nHenry Silva (born September 23, 1928) is an American actor who has played a wide variety of movie roles.\n\nDescription above from the Wikipedia article Henry Silva, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Brooklyn, New York, USA	Henry Silva
26469	1973-12-03	\N	​From Wikipedia, the free encyclopedia.\n\nHolly Marie Combs  (born December 3, 1973) is an American film and television actress and producer whose roles have included a portrayal in Charmed as Piper Halliwell and another in Picket Fences, where she received a Young Artist Award for her role, as Kimberly Brock. She stars in the ABC Family original series Pretty Little Liars as Ella Montgomery. She was in the movie, Sins of Silence.\n\nDescription above from the Wikipedia article Holly Marie Combs, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	San Diego, California, USA	Holly Marie Combs
1884	1963-01-14	\N	From Wikipedia, the free encyclopedia.  Steven Andrew Soderbergh ( born January 14, 1963) is an American film producer, screenwriter, cinematographer, editor, and an Academy Award-winning film director. He is best known for directing commercial Hollywood films like Erin Brockovich, Traffic, and Ocean's Eleven, but he has also directed smaller less conventional and commercialized works such as Sex, Lies, and Videotape, Schizopolis, Bubble, and Che.\n\nDescription above from the Wikipedia article Steven Soderbergh, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Atlanta, Georgia, USA	Steven Soderbergh
1655618	\N	\N		2		Tim Perez
235346	1957-10-01	\N		0	Pittsburgh, Pennsylvania, USA	Rusty Meyers
1751	1920-03-03	2005-07-20	From Wikipedia, the free encyclopedia.  James Montgomery "Jimmy" Doohan ( March 3, 1920 – July 20, 2005) was a Canadian character and voice actor best known for his role as Montgomery "Scotty" Scott in the television and film series Star Trek. Doohan's characterization of the Scottish Chief Engineer of the Starship Enterprise was one of the most recognizable elements in the Star Trek franchise, for which he also made several contributions behind the scenes. Many of the characterizations, mannerisms, and expressions that he established for Scotty and other Star Trek characters have become entrenched in popular culture.  Following his success with Star Trek, he supplemented his income and showed continued support for his fans by making numerous public appearances. Doohan often went to great lengths to buoy the large number of fans who have been inspired to make their own accomplishments in engineering and other fields, as a result of Doohan's work and his encouragement.  Description above from the Wikipedia article James Doohan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Vancouver, British Columbia, Canada	James Doohan
6903	\N	\N		0		Shawn R. McFall
6904	\N	\N		0		Rhona Meyers
1896	1964-11-29	\N	Donald Frank "Don" Cheadle, Jr. was on born November 29, 1964 in Kansas City, Missouri. He is an American film actor as well as producer. Cheadle first received widespread notice for his portrayal of Mouse Alexander in the film Devil in a Blue Dress, for which he won Best Supporting Actor awards from the Los Angeles Film Critics Association and the National Society of Film Critics and was nominated for similar awards from the Screen Actors Guild and the NAACP Image Awards.\n\nFollowing soon thereafter was his performance in the title role of the 1996 HBO TV movie, Rebound: The Legend of Earl "The Goat" Manigault. He also starred in the 1997 film Volcano, directed by Mick Jackson. Cheadle continued his rise to prominence in the late 1990s and the early 2000s for his supporting roles in the Steven Soderbergh-directed films Out of Sight, Traffic, and Ocean's Eleven. In 2004, his lead role as Rwandan hotel manager Paul Rusesabagina in the genocide drama film Hotel Rwanda earned him an Academy Award nomination for Best Actor. He also starred in, and was one of the producers of Crash, which won the 2005 Academy Award for Best Picture.\n\nIn 2010, Cheadle assumed the role of James Rhodes in the film Iron Man 2, replacing Terrence Howard, his Crash co-star. He also campaigns for the end of genocide in Darfur, Sudan, and co-authored a book concerning the issue titled Not On Our Watch: The Mission To End Genocide In Darfur And Beyond. In 2007, Cheadle was awarded the BET Humanitarian award of the year for his numerous humanitarian services he rendered for the cause of the people of Darfur and Rwanda. In 2010, Cheadle was named U.N. Environment Program Goodwill Ambassador.	2	Kansas City, Missouri, USA 	Don Cheadle
1885	1929-07-10	2015-12-25	From Wikipedia, the free encyclopedia.\n\nGeorge Clayton Johnson (born July 10, 1929 in Cheyenne, Wyoming) is an American science fiction writer most famous for co-writing the novel Logan's Run with William F. Nolan (basis for the 1976 film). He is also known for his work in television, writing screenplays for such noted series as The Twilight Zone, such as "Nothing in the Dark", "Kick the Can", "A Game of Pool and "A Penny for Your Thoughts", and Star Trek, the first aired episode of the series, "The Man Trap". He also wrote the story on which the 1960 and 2001 films Ocean's Eleven were based. He was proprietor of Cafe Frankenstein.\n\nDescription above from the Wikipedia article Sarah George Clayton Johnson, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Cheyenne, Wyoming, USA	George Clayton Johnson
1886	\N	\N		0		Ted Griffin
1887	\N	\N		0		Jack Golden Russell
1888	1937-09-26	\N		0		Jerry Weintraub
1889	1969-02-14	\N		0		David Holmes
1890	\N	\N		0		Philip Messina
495	\N	\N		0		Debra Zane
1891	1969-02-17	\N		0		Stephen Mirrione
1629525	\N	\N		0		Jarod Abbatoye
1629533	\N	\N		0		Zeen Jones
1296	\N	\N	Bruce Berman is an American film industry executive and producer. He is the chairman and CEO of Village Roadshow Pictures, a position he has held since 1997. His credits as an executive producer include American Sniper, The Lego Movie, The Great Gatsby, the Ocean's trilogy, Sherlock Holmes and its sequel, Sherlock Holmes: A Game of Shadows, Happy Feet and The Matrix trilogy.\n\nBerman is noted for his collection of contemporary American  photographs. In 2004, he was listed among the world’s top 25 photography  collectors by ARTNews.	2		Bruce Berman
57295	1959-08-26	\N		0		Susan Ekins
1748	1931-03-22	\N	From Wikipedia, the free encyclopedia\n\nWilliam Shatner (born March 22, 1931) is a Canadian actor, musician, singer, author, film director, spokesman and comedian. He gained worldwide fame and became a cultural icon for his portrayal of Captain James Tiberius Kirk, commander of the Federation starship USS Enterprise, in the science fiction television series Star Trek, from 1966 to 1969; Star Trek: The Animated Series from 1973 to 1974, and in seven of the subsequent Star Trek feature films from 1979 to 1994. He has written a series of books chronicling his experiences playing Captain Kirk and being a part of Star Trek, and has co-written several novels set in the Star Trek universe. He has also authored a series of science fiction novels called TekWar that were adapted for television.\n\nShatner also played the eponymous veteran police sergeant in T. J. Hooker from 1982 to 1986. Afterwards, he hosted the reality-based television series Rescue 911 from 1989 to 1996, which won a People's Choice Award for Favorite New TV Dramatic Series. He has since worked as a musician, author, director and celebrity pitchman. From 2004 to 2008, he starred as attorney Denny Crane in the television dramas The Practice and its spin-off Boston Legal, for which he won two Emmy Awards and a Golden Globe Award.	2	Montreal, Quebec, Canada	William Shatner
1749	1931-03-26	2015-02-27	Leonard Nimoy was an American actor, film director, poet, musician and photographer. Nimoy's most famous role is that of Spock in the original Star Trek series 1966–1969, multiple films, television and video game sequels.\n\nNimoy began his career in his early twenties, teaching acting classes in Hollywood and making minor film and television appearances through the 1950s, as well as playing the title role in Kid Monk Baroni. In 1953, he served in the United States Army. In 1965, he made his first appearance in the rejected Star Trek pilot, "The Cage", and would go on to play the character of Mr. Spock until 1969, followed by seven further films and a number of guest slots in various sequels. His character of Spock generated a significant cultural impact and three Emmy Award nominations; TV Guide named Spock one of the 50 greatest TV characters. Nimoy also had a recurring role in Mission: Impossible and a narrating role in Civilization IV, as well as several well-received stage appearances. Nimoy's fame as Spock is such that both his autobiographies, I Am Not Spock (1977) and I Am Spock (1995) detail his existence as being shared between the character and himself.\n\nNimoy was born to Yiddish-speaking Orthodox Jewish immigrants from Iziaslav, Ukraine. His father, Max Nimoy, owned a barbershop in the Mattapan section of the city. His mother, Dora Nimoy (née Spinner), was a homemaker. Nimoy began acting at the age of eight in children's and neighborhood theater. His parents wanted him to attend college and pursue a stable career, or even learn to play the accordion—which, his father advised, Nimoy could always make a living with—but his grandfather encouraged him to become an actor. His first major role was at 17, as Ralphie in an amateur production of Clifford Odets' Awake and Sing!. Nimoy took Drama classes at Boston College in 1953 but failed to complete his studies, and in the 1970s studied photography at the University of California, Los Angeles. He has an MA in Education and an honorary doctorate from Antioch University in Ohio. Nimoy served as a sergeant in the U.S. Army from 1953 through 1955, alongside fellow actor Ken Berry and architect Frank Gehry.	2	Boston, Massachusetts, USA	Leonard Nimoy
1750	1920-01-20	1999-06-11	From Wikipedia, the free encyclopedia\n\nJackson DeForest Kelley  (January 20, 1920 – June 11, 1999) was an American actor, screenwriter,  poet and singer known for his iconic roles in Westerns and as Dr. Leonard "Bones" McCoy of the USS Enterprise in the television and film series Star Trek.Kelley was delivered by his uncle at his parents' home in Atlanta, the son of Clora (née Casey) and Ernest David Kelley, who was a Baptist minister of Irish and Southern ancestry. DeForest was named after the pioneering electronics engineerLee De Forest, and later named his Star Trek character's father "David" after his own. Kelley had an older brother, Ernest Casey Kelley.As a child, he often played outside for hours at a time. Kelley was immersed in his father's mission in Conyers  and promised his father failure would mean "wreck and ruin". Before the  end of his first year at Conyers, Kelley was introduced into the  congregation to his musical talents and often sang solo in morning  church services.Eventually, this led to an appearance on the radio station WSB AM in Atlanta, Georgia. As a result of his radio work, he won an engagement with Lew Forbes and his orchestra at the Paramount Theater.In  1934, the family left Conyers for the community of Decatur. He attended  the Decatur Boys High School where he played on the Decatur Bantams  baseball team. Kelley also played football and other sports. Before his  graduation, Kelley got a job as a drugstore car hop. He spent his  weekends working in the local theatres. Kelley graduated in 1938.During World War II, Kelley served as an enlisted man in the United States Army Air Forces between March 10, 1943, and January 28, 1946, assigned to the First Motion Picture Unit. After an extended stay in Long Beach, California,  Kelley decided to pursue an acting career and relocate to southern  California permanently, living for a time with his uncle Casey. He  worked as an usher in a local theater in order to earn enough money for  the move. Kelley's mother encouraged her son in his new career goal, but  his father disliked the idea. While in California, Kelley was spotted  by a Paramount Pictures scout while doing a United States Navy training film.	0	Atlanta, Georgia, USA	DeForest Kelley
1752	1937-04-20	\N	George Hosato Takei Altman (born April 20, 1937) is an American actor of Japanese descent, best known for his role in the television series Star Trek, in which he played Hikaru Sulu, helmsman of the USS Enterprise. He is a proponent of gay rights and active in state and local politics as well as continuing his acting career. He has won several awards and accolades in his work on human rights and Japanese-American relations, including his work with the Japanese American National Museum. Description above from the Wikipedia article George Takei, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles - California - USA	George Takei
1754	1936-09-14	\N	Walter Marvin Koenig is an American actor, writer, teacher and director, known for his roles as Pavel Chekov in Star Trek and Alfred Bester in Babylon 5. He wrote the script for the 2008 science fiction legal thriller InAlienable.	2	Chicago, Illinois USA	Walter Koenig
1753	1932-12-28	\N	​From Wikipedia, the free encyclopedia.    Nichelle Nichols (born Grace Nichols; December 28, 1932) is an American actress, singer and voice artist. She sang with Duke Ellington and Lionel Hampton before turning to acting. Her most famous role is that of communications officer Lieutenant Uhura aboard the USS Enterprise in the popular Star Trek television series, as well as the succeeding motion pictures, where her character was eventually promoted in Starfleet to the rank of commander. In 2006, she added executive producer to her résumé.  Description above from the Wikipedia article Nichelle Nichols, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Robbins, Illinois, USA	Nichelle Nichols
2021	1910-08-12	2006-10-20	From Wikipedia\n\nJane Wyatt (August 12, 1910 – October 20, 2006) was an American actress best known for her role as the housewife and mother on the NBC and CBS television comedy series, Father Knows Best, and as Amanda Grayson, the human mother of Spock on the science fiction television series Star Trek. Wyatt was a three-time Emmy Award-winner.\n\nJane Waddington Wyatt was born on August 12, 1910 in Mahwah, New Jersey, but raised in Manhattan. Her father, Christopher Billopp Wyatt, Jr., was a Wall Street investment banker, and her mother, the former Euphemia Van Rensselaer Waddington, was a drama critic for the Catholic World. Both of her parents were Roman Catholic converts.\n\nShe made her film debut in 1934 in One More River. In arguably her most famous role, she co-starred as Ronald Colman's character's love interest in Frank Capra's Columbia Pictures film Lost Horizon (1937).\n\nOther film appearances included Gentleman's Agreement with Gregory Peck, None but the Lonely Heart with Cary Grant, Boomerang with Dana Andrews, and Our Very Own. Her film career suffered because of her outspoken opposition to Senator Joseph McCarthy, the chief figure in the anti-Communist investigations of that era, and was temporarily derailed for having assisted in hosting a performance by the Bolshoi Ballet during the Second World War, even though it was at the request of President Franklin D. Roosevelt. Wyatt returned to her roots on the New York stage for a time and appeared in such plays as Lillian Hellman's The Autumn Garden, opposite Fredric March.\n\nFor many people, Wyatt is best remembered as Margaret Anderson on Father Knows Best, which aired from 1954 to 1960. She played opposite Robert Young as the devoted wife and mother of the Anderson family in the Midwestern town of Springfield. This role won Wyatt three Emmy Awards for best actress in a comedy series. After Father Knows Best, Wyatt guest starred in several other series.\n\nOn June 13, 1962, she was cast in the lead in "The Heather Mahoney Story" on NBC's Wagon Train. In 1963, she portrayed Kitty McMullen in "Don't Forget to Say Goodbye" on the ABC drama, Going My Way, with Gene Kelly and Leo G. Carroll, a series about the Catholic priesthood in New York City. In 1965, Wyatt was cast as Anne White in "The Monkey's Paw – A Retelling" on CBS's The Alfred Hitchcock Hour.\n\nWyatt was married to investment broker Edgar Bethune Ward from November 9, 1935, until his death on November 8, 2000, just one day short of the couple's 65th wedding anniversary. The couple reportedly met in the late 1920s when both were weekend houseguests of Franklin D. Roosevelt at Hyde Park, New York. Ward later converted to the Catholic faith of his wife. Wyatt suffered a mild stroke in the 1990s, but recovered well. She remained in relatively good health for the rest of her life\n\nJane Wyatt died on October 20, 2006 of natural causes at her home in Bel-Air, California, aged 96. She was interred at San Fernando Mission Cemetery, next to her husband.	0	Campgaw - New Jersey - USA	Jane Wyatt
2022	1951-08-06	\N	​From Wikipedia, the free encyclopedia.   Catherine Mary Hicks (born August 6, 1951) is an American stage, film, television actress and singer. She is best known for her role as Annie Camden on the long-running television series 7th Heaven. Description above from the Wikipedia article Catherine Hicks, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, United States	Catherine Hicks
1820	1924-10-15	1996-11-22		0		Mark Lenard
1819	1956-06-15	\N		0		Robin Curtis
2647	1923-06-18	2010-10-28		0		Robert Ellenstein
24046	1940-02-04	\N	From Wikipedia, the free encyclopedia.\n\nConrad John Schuck Jr. (born February 4, 1940) is an American actor, primarily in stage, movies and television. He is best-known for his roles as police commissioner Rock Hudson's mildly slow-witted assistant, Sgt. Charles Enright in the 1970s crime drama McMillan &amp; Wife, and as Lee Meriwether's husband, Herman Munster in the 1980s sitcom, The Munsters Today. Schuck is also known for his work on Star Trek movies and television series, often playing a Klingon character, as well as his recurring roles as Draal on Babylon 5 and as Chief of Detectives Muldrew of the New York City Police Department in the Law &amp; Order programs, especially Law &amp; Order: Special Victims Unit.\n\nDescription above from the Wikipedia article John Schuck, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Boston, Massachusetts, U.S.	John Schuck
2112	1927-07-02	2005-08-23		0		Brock Peters
1219391	\N	\N		0		Michael Snyder
1791	1930-08-17	\N	From Wikipedia, the free encyclopedia.  Harve Bennett (born Chaim Fishman  on August 17, 1930 in Chicago, Illinois) is an American television and film producer and screenwriter.  Description above from the Wikipedia article Harve Bennett, licensed under CC-BY-SA, full list of contributors on Wikipedia.     	0	Chicago, Illinois, USA	Harve Bennett
2019	\N	\N		0		Steve Meerson
2020	\N	\N		0		Peter Krikes
1788	1945-12-24	\N	From Wikipedia, the free encyclopedia.  Nicholas Meyer (born December 24, 1945 in New York City, New York) is an American screenwriter, producer, director and novelist, known best for his best-selling novel The Seven-Per-Cent Solution, and for directing the films Time After Time, two of the Star Trek feature film series, and the 1983 television movie The Day After.  Meyer graduated from the University of Iowa with a degree in theater and filmmaking.  Description above from the Wikipedia article Nicholas Meyer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Nicholas Meyer
9614	1932-01-02	2011-02-05		0		Donald Peterman
2024	\N	\N		0		Joe Aubel
2025	\N	\N		0		Nilo Rodis-Jamero
2026	\N	\N		0		Peter Landsdown Smith
796	\N	\N		0		John M. Dwyer
1801	1922-08-23	\N		2	Cedar Rapids, Iowa, USA	Robert Fletcher
2027	1924-09-07	2008-03-04		0		Leonard Rosenman
2031	\N	\N		1		Amanda Mackey
2032	1923-01-12	1998-02-01		0		Jack T. Collis
2033	\N	\N		0		Peter E. Berger
2295	1952-09-16	\N	Philip Andre "Mickey" Rourke, Jr. (born September 16, 1952) is an American actor and screenwriter who has appeared primarily as a leading man in action, drama, and thriller films.\n\nTrained as a boxer in his early years, Rourke had a short stint as a professional boxer in the 1990s. He won a 2009 Golden Globe award and a BAFTA award, and was nominated for a Screen Actors Guild Award and an Academy Award for his work in the film The Wrestler. He appears as the main villain Whiplash in Iron Man 2 along with Robert Downey Jr., Don Cheadle, and Sam Rockwell and is also well known for playing Marv in Sin City.	2	Schenectady, New York, U.S.	Mickey Rourke
56731	1981-04-28	\N	Jessica Marie Alba (born April 28, 1981) is an American television and film actress. She began her television and movie appearances at age 13 in Camp Nowhere and The Secret World of Alex Mack (1994). Alba rose to prominence as the lead actress in the television series Dark Angel (2000–2002). Alba later appeared in various films including Honey (2003), Sin City (2005), Fantastic Four (2005), Into the Blue (2005), Fantastic Four: Rise of the Silver Surfer and Good Luck Chuck both in 2007.\n\nAlba is considered a sex symbol and often generates media attention for her looks. She appears on the "Hot 100" section of Maxim and was voted number one on AskMen.com's list of "99 Most Desirable Women" in 2006, as well as "Sexiest Woman in the World" by FHM in 2007. The use of her image on the cover of the March 2006 Playboy sparked a lawsuit by her, which was later dropped. She has also won various awards for her acting, including the Choice Actress Teen Choice Award and Saturn Award for Best Actress on Television, and a Golden Globe nomination for her lead role in the television series Dark Angel.	1	Pomona, California, USA	Jessica Alba
16851	1968-02-12	\N	Josh James Brolin (born February 12, 1968) is an American actor. He has acted in theater, film and television roles since 1985, and won acting awards for his roles in the films W., No Country for Old Men, Milk and Wall Street: Money Never Sleeps. He appeared in True Grit, a 2010 western film adaptation of the 1968 novel by Charles Portis.\n\nDescription above from the Wikipedia article Josh Brolin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Los Angeles - California - USA	Josh Brolin
24045	1981-02-17	\N	Joseph Leonard Gordon-Levitt (born February 17, 1981) is an American actor whose career as both a child and adult has included television series and theatrical films. He is known for his roles in the 2009 indie (500) Days of Summer and Christopher Nolan's sci-fi Inception. The former earned him a Golden Globe nomination. Beginning in commercials as a young child he made his film debut in 1992's Beethoven. Gordon-Levitt subsequently co-starred in the television sitcom 3rd Rock from the Sun (1996–2001) as the young Tommy Solomon. After a hiatus during which he attended Columbia University, Gordon-Levitt left television for film acting, appearing in various independent films, beginning with the 2001 film Manic, followed by the acclaimed roles in 2004's Mysterious Skin and 2005's Brick. He runs an online collaborative production company titled HitRECord.\n\nDescription above from the Wikipedia article Joseph Gordon-Levitt, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Los Angeles, California, USA	Joseph Gordon-Levitt
11791	\N	\N		0		Edward 'Tantar' LeViseur
8487	1916-04-05	2003-06-12		2	La Jolla, California, USA	Gregory Peck
10912	1980-07-06	\N	Eva Gaëlle Green, born July 6th 1980, is a French actress and model. She started her career in theatre before making her film debut in 2003 in Bernardo Bertolucci's controversial The Dreamers. She achieved international recognition when she appeared in Ridley Scott's Kingdom of Heaven, and portrayed Vesper Lynd in the James Bond film Casino Royale. In 2006, Green was awarded the BAFTA Rising Star Award.	1	Paris, France	Eva Green
6280	1948-06-01	\N	From Wikipedia, the free encyclopedia.\n\nPowers Allen Boothe (born June 1, 1948) is an American television and film actor. Some of his most notable roles include his Emmy-winning 1980 portrayal of Jim Jones and his turn as Cy Tolliver on Deadwood, as well as Vice-President Noah Daniels on 24.\n\nDescription above from the Wikipedia article Powers Boothe, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Snyder, Texas, U.S.	Powers Boothe
352	1954-06-02	\N	Dennis Dexter Haysbert (born June 2, 1954) is an American film and television actor. He is known for portraying baseball player Pedro Cerrano in the Major League film trilogy, President David Palmer on the American television series 24, and Sergeant Major Jonas Blane on the drama series The Unit, as well as his work in commercials for Allstate Insurance. He is also known for his authoritative, bass voice.\n\nDescription above from the Wikipedia article Dennis Haysbert, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	San Mateo - California - USA	Dennis Haysbert
11477	1954-12-18	\N	Raymond Allen "Ray" Liotta (born December 18, 1954) is an American actor, best known for his portrayal of Henry Hill in the crime-drama Goodfellas, directed by Martin Scorsese and his role as Shoeless Joe Jackson in Field of Dreams. He has won an Emmy Award and been nominated for a Golden Globe Award. Also, Ray has voiced Tommy Vercetti in the video game Grand Theft Auto:Vice City.\n\nDescription above from the Wikipedia article Ray Liotta, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Newark, New Jersey, USA	Ray Liotta
22227	1961-04-02	\N	Christopher Peter Meloni (born April 2, 1961) is an American actor. He is best known for his television roles as NYPD Detective Elliot Stabler on the NBC police drama Law &amp; Order: Special Victims Unit, and as inmate Chris Keller on the HBO prison drama Oz. Description above from the Wikipedia article Christopher Meloni, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Washington - D.C. - USA	Christopher Meloni
12799	1965-07-26	\N	Jeremy Samuel Piven (born July 26, 1965) is an American film producer and actor best known for his role as Ari Gold in the television series Entourage for which he has won three Primetime Emmy Awards as well as several other nominations for Best Supporting Actor.\n\nDescription above from the Wikipedia article Jeremy Piven, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	Jeremy Piven
1062	1938-10-22	\N	From Wikipedia, the free encyclopedia. Christopher Allen Lloyd (born October 22, 1938) is an American actor. He is best known for playing Doc Brown in the Back to the Future trilogy, Uncle Fester in The Addams Family films, and Judge Doom in Who Framed Roger Rabbit. He played Reverend Jim Ignatowski in the television series Taxi and most recently Mr. Goodman in Piranha 3D. He also starred in the short-lived television series Deadly Games, and also was a regular in the short-lived TV series Stacked, in the mid-2000s. Lloyd has used his vocal talents in animation, frequently voicing villains. He currently voices the character Hacker on the animated PBS series Cyberchase. Lloyd has won three Primetime Emmy Awards and an Independent Spirit Award, and has been nominated for two Saturn Awards and a Daytime Emmy Award. Description above from the Wikipedia article Christopher Lloyd, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Stamford, Connecticut, USA	Christopher Lloyd
5915	1979-04-23	\N	From Wikipedia, the free encyclopedia\n\nJaime King (born April 23, 1979) is an American actress and model. In her modeling career and early film roles, she used the names Jamie King and James King, which was a childhood nickname given to King by her parents, because her agency already represented another Jaime — the older, then more famous model Jaime Rishar.\n\nCalled by Complex magazine "one of the original model-turned-actresses", King appeared in Vogue, Mademoiselle, and Harper's Bazaar, among other fashion magazines. Afterwards, she began taking small film roles. Her first larger role was in Pearl Harbor (2001). Her first starring movie role was in Bulletproof Monk (2003). She has appeared as a lead in other films, gaining more note after Sin City (2005).	1	Omaha - Nebraska - USA	Jaime King
36594	1989-07-21	\N	​From Wikipedia, the free encyclopedia.  \n\nJuno Violet Temple (born 21 July 1989) is an English actress.	1	London, England	Juno Temple
825	1941-06-02	\N	Walter Stacy Keach, Jr. (born June 2, 1941) is an American actor and narrator. He is most famous for his dramatic roles; however, he has done narration work in educational programming on PBS and the Discovery Channel, as well as some comedy (particularly his role in the FOX sitcom Titus as Ken, the hard-drinking, chain-smoking, womanizing father of comedian Christopher Titus) and musical roles.\n\nDescription above from the Wikipedia article Stacy Keach, licensed under CC-BY-SA, full list of contributors on Wikipedia​	2	Savannah - Georgia - USA	Stacy Keach
20982	1966-06-30	\N	Marton Csokas (born 30 June 1966) is a New Zealand film and television actor.\n\nDescription above from the Wikipedia article Marton Csokas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Invercargill, New Zealand	Marton Csokas
8693	1947-11-30	\N	Richard Jude Ciccolella (born November 30, 1947), better known as Jude Ciccolella, is an American character actor.\n\n Ciccolella was born in Nassau County, New York. He graduated from Brown University, class of 1969 where he acted in student productions. He studied at Temple University with a Master of Fine Arts degree in theatre. His film roles include parts in The Shawshank Redemption as Mert, Boys on the Side as Jerry, Night Falls on Manhattan as Lieutenant Wilson, Star Trek Nemesis as Romulan Commander Suran, Down With Love as the private eye, The Terminal as Karl Iverson, the 2004 Director's Cut DVD of Daredevil, the 2004 remake of The Manchurian Candidate as David Donovan, and the 2005 Sin City movie adaptation as Liebowitz.  After guest starring roles in Law &amp; Order, NYPD Blue, CSI: NY and ER, Ciccolella took a recurring guest role on 24. During the show's first and second seasons (2001–2003), he played Mike Novick, Chief of Staff to President David Palmer (Dennis Haysbert). He has also guest starred as Principal Raymond on Everybody Hates Chris; however, he was replaced upon reprising his role as Mike Novick in the last eight episodes of Season 4 of 24.  He appeared in the 1992 James Foley and David Mamet film Glengarry Glen Ross as the Detective. He appeared in the scene where Al Pacino was having an argument with Kevin Spacey about the "six-thousand dollars" owed to him.  Ciccolella was also seen in the episode of Nickelodeon's The Adventures of Pete &amp; Pete titled "Tool and Die," where he plays the shop class teacher Mr Slurm, whose missing left hand stirred nothing but hearsay and rumors. Mr. Ciccolella did not reprise his role as Mr. Slurm in the season 3 episode, "Road Warrior."  In 24's fourth season (2005), Ciccolella returned for the last 8 episodes. Mike had become an advisor to Acting President Charles Logan (Gregory Itzin), who had taken over after the downing of Air Force One critically injured President John Keeler (Geoff Pierson). He had continued this role in the show's fifth season (2006). However, he did not appear in the sixth season.  In 2007, he guest-starred on NBC freshman drama Life. He also appeared in the 2007 film, The Wager.  In 2008, he portrayed Phillip Davenport, a fictional Secretary of the Navy on the 6th season of the CBS show NCIS. Two years later, he appeared one more time for the last episode of the 8th season.  In the "Supporting Players" featurette on the 24 season 5 DVD, actress Jean Smart reveals that Ciccolella is a folk singer.	0	Burlington - Vermont - USA	Jude Ciccolella
78324	1983-04-10	\N	​From Wikipedia, the free encyclopedia\n\nJamie Jilynn Chung (born April 10, 1983) is an American actress known to reality television audiences as a cast member on the MTV reality television series, The Real World: San Diego and its spin-off show, Real World/Road Rules Challenge: The Inferno II, and for her appearances in TV and films, such as I Now Pronounce You Chuck and Larry, Sorority Row, and Sucker Punch.	1	San Francisco, California, USA	Jamie Chung
237405	1986-03-28	\N	From Wikipedia, the free encyclopedia\n\nStefani Joanne Angelina Germanotta (born March 28, 1986, height 5' 1" (1,55 m)), better known by her stage name Lady Gaga, is an American pop singer-songwriter. After performing in the rock music scene of New York City's Lower East Side in 2003 and later enrolling at New York University's Tisch School of the Arts, she soon signed with Streamline Records, an imprint of Interscope Records. During her early time at Interscope, she worked as a songwriter for fellow label artists and captured the attention of recording artist Akon, who recognized her vocal abilities, and signed her to his own label, Kon Live Distribution.\n\nGaga came to prominence following the release of her debut studio album The Fame (2008), which was a critical and commercial success and achieved international popularity with the singles "Just Dance" and "Poker Face". The album reached number one on the record charts of six countries, topped the Billboard Dance/Electronic Albums chart while simultaneously peaking at number two on the Billboard 200 chart in the United States and accomplished positions within the top ten worldwide. Achieving similar worldwide success, The Fame Monster (2009), its follow-up, produced a further two global chart-topping singles "Bad Romance" and "Telephone" and allowed her to embark on her second global concert tour, The Monster Ball Tour, just months after having finished her first, The Fame Ball Tour. Her second studio album Born This Way, released in May 2011, topped the charts in all major musical markets, after the arrival of its eponymous lead single "Born This Way", which achieved the number-one spot in countries worldwide and was the fastest-selling single in the history of iTunes, selling one million copies in five days.\n\nInspired by glam rock artists like David Bowie, Elton John and Queen, as well as pop singers such as Madonna and Michael Jackson, Gaga is well-recognized for her outré sense of style in fashion, in performance and in her music videos. Her contributions to the music industry have garnered her numerous achievements including five Grammy Awards, among twelve nominations; two Guinness World Records; and the estimated sale of 15 million albums and 51 million singles worldwide. Billboard named her the Artist of the Year in 2010, ranking her as the 73rd Artist of the 2000s decade. Gaga has been included in Time magazine's annual Time 100 list of the most influential people in the world as well as being listed in a number of Forbes' annual lists including the 100 most powerful and influential celebrities in the world and attained the number one spot on their annual list of the 100 most powerful celebrities..\n\nDescription above from the Wikipedia article Lady Gaga, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City - New York - USA	Lady Gaga
2391	1952-12-09	\N	From Wikipedia, the free encyclopedia.\n\nMichael Dorn (born December 9, 1952, height 6' 2½" (1,89 m)) is an American actor and voice artist who is best known for his role as the Klingon Worf from the Star Trek franchise.\n\nDorn was born in Luling, Texas, the son of Allie Lee (née Nauls) and Fentress Dorn, Jr. He grew up in Pasadena, California. He studied radio and television production at the Pasadena City College. From there he pursued a career in music as a performer with several different rock music bands, travelling to San Francisco and then back to Los Angeles.Dorn first appeared in Rocky (1976) as Apollo Creed's bodyguard, though he was not credited. He first appeared as a guest on the television show W.E.B. in 1978. The producer was impressed with his work, so he introduced Michael to an agent who introduced him to acting teacher Charles Conrad to study acting for six months. He then landed a regular role on the television series CHiPs.	0	Luling - Texas - USA	Michael Dorn
2381	1945-12-25	\N		0		Rick Berman
2504	1932-08-15	2013-12-19		2	USA	Marty Hornstein
2383	\N	\N		0		Peter Lauritson
57674	1988-08-27	\N	From Wikipedia, the free encyclopedia.\n\nAlexa Ellesse Pena-Vega (born August 27, 1988) is an American actress, singer and pianist. She is best known for playing Carmen Cortez in Spy Kids film series and Shilo Wallace in the movie Repo! the Genetic Opera. In 2009, she starred as the title character Ruby Gallagher in the ABC Family series Ruby &amp; The Rockits.\n\nEarly life\n\nAlexa Vega was born in Miami, Florida. Her father is Colombian and her mother, Gina Rue, is an American former model. Vega has six siblings: paternal half-sister Margaux Vega (b. 1981), sister Krizia Vega (b. 1990), sister Makenzie Vega (b. 1994), maternal half-sister Greylin James (b. 2000), maternal half-brother Jet James (b. 2005), and maternal half-brother Cruz Hudson Rue (b. 2009). She moved with her family to California when she was four years old.\n\nPersonal life\n\nVega married film producer Sean Covel on October 10, 2010 in a ceremony held in his hometown of Lead, South Dakota. She wore an Ian Stuart gown and was walked down the aisle by Robert Rodriguez. In July 2012, Vega announced on Twitter that she had divorced Covel.\n\nPersonal life\n\nIn August 2013, while on a cruise with friends, Vega became engaged to actor and singer Carlos Pena, Jr. The couple married on January 4, 2014 in Puerto Vallarta, Mexico, and changed their surname to PenaVega.Vega is a Christian. Vega says her faith is the most important thing in her life. Vega enjoys freshwater fishing, can speak Spanish fluently, and is an experienced gymnastVega is close friends with Nikki Reed and was the maid of honor at Reed's wedding to Paul McDonald.	1	Miami - Florida - USA	Alexa PenaVega
936970	1994-02-01	\N	Julia Garner is an American actress. She has appeared in the films Martha Marcy May Marlene, The Perks of Being a Wallflower, Sin City: A Dame to Kill For, and We Are What We Are. Wikipedia	1	New York City - New York - USA	Julia Garner
968889	\N	\N	Born in El Paso, TX and related to the great Edgar Allan Poe, Billy knew what he wanted to do at the ripe age of 5 after experiencing Sesame Street and KISS. He comes from a musical background. His great grandfather led his big band during the early 1900's in Mexico performing for some of history's greatest figures such as Pancho Villa. He also had uncles and cousins, all which played in big bands and symphonies.\n\nFor all of Billy's life, he was dedicated to music and still proceeds to endeavor this lifestyle. Being in numerous bands, he would experience touring the nation, playing in clubs, theaters, arenas and amphitheaters; fulfilling the dream and opening for some of the biggest names of rock.\n\nBy the mid 90's, Billy decided to pursue in acting. He would develop his skills in theater at Richland College in Richardson, TX and would resume with taking private lessons from the greatest acting coaches in Texas. Building his resume with small, local indie films. Landing in a national commercial, then booking roles in bigger films like Jonah Hex starring Josh Brolin. He is known for some of his great work in films like The Last Stand starring Arnold Schwarzenegger and Robert Rodriguez's Machete, Machete Kills and Sin City: A Dame To Kill For.  - IMDb Mini Biography	0	El Paso - Texas - USA	Billy Blair
3133	\N	\N	Patricia Vonne is an American singer and actress. A native of San Antonio, Texas, Vonne, born Patricia Rodriguez, moved to New York City in 1990-2001 to pursue her artistic ambitions. She worked extensively in Europe and America and was featured in national/international commercials, and film work. She formed her own musical band, which performed on the New York circuit from 1998-2001. She then relocated to her native Texas where she currently tours extensively in the U.S., Mexico and Europe. She toured as a member of Tito &amp; Tarantula, the band featured in the film From Dusk Till Dawn in 2002. Her song, "Traeme Paz", was featured in the film Once Upon a Time in Mexico. Her song "Mudpies and Gasoline" is featured in the Quentin Tarantino presented film Hell Ride. She is the sister of Angela Lanza, Marcel Rodriguez and Robert Rodriguez.	1	San Antonio - Texas - USA	Patricia Vonne
84791	\N	\N		0		Bart Fletcher
90553	\N	\N	Alejandro Rose-Garcia is an actor.	0		Alejandro Rose-Garcia
1129413	\N	\N	Samuel Davis is an actor. 	0		Samuel Davis
1406568	\N	\N		0		Mike Davis
1406570	\N	\N	Kimberly Cox is an actress.	0		Kimberly Cox
60674	\N	\N	Alcides Dias is an actor and producer.	0		Alcides Dias
1393520	\N	\N	Vincent's first introduction to acting was at the age of seven at an acting school in Texas called APM Studios. Then later excelled in Theater Arts programs in middle school, learning about stage and improv became a passion. Vincent Fuentes is known for Machete Kills, Killer Women, The Iceman and soon to be released Sin City A Dame To Kill For.  - IMDb Mini Biography	0	Texas - USA	Vincent Fuentes
1406674	\N	\N		0		Rob Franco
1025370	\N	\N		0		Daylon Walton
55269	1957-05-13	\N	Texas native Eloise DeJoria made her film debut in Songwriter, starring Willie Nelson. Other feature credits include Weekend at Bernie's, Grand Champion, Don't Mess with the Zohan, Wall Street (Money Never Sleeps), and Wild Hearts. Her latest picture, When Angels Sing, based on Turk Pipkin's classic Christmas story, stars Texas greats Willie Nelson, Lyle Lovett, Marcia Ball, Kris Kristofferson, and Harry Connick, Jr. (from next-door Louisiana). The movie was directed by Tim McCanlies, and was produced by Austinites Elizabeth Avelan, Shannon Macintosh and Fred Miller.\n\nEloise's lifestyle has been featured on 20/20 with Barbara Walters, "E" Entertainment, and in many national and international publications. She is widely recognized as the spokes model for Paul Mitchell Hair care products in television and print ads. Her number one priority and joy is raising John Anthony, her 14 year-old son with John Paul De Joria, and being mother and grandmother to their large combined family. She enjoys the outdoors, staying fit, and eating healthy.\n\nEloise is proud of her work at The Arbor Recovery Center in Georgetown, Texas, where she partners with her son Justin and recovery expert Jim Walker. She loves her time spent with eldest son Michael, who lives nearby with his family and works in the family business, John Paul Pet.\n\nShe is also known for her contributions and charitable work with local groups including Help Clifford Help Kids, The Palmer Drug Abuse Program, The Austin Recovery Center, The Austin Children's Shelter, Helping Hands, as well as Club 100, Long Center for the Performing Arts, The Paramount Theater, and The Austin Film Society.\n\n- IMDb Mini Biography	0	Houston - Texas - USA	Eloise DeJoria
1406676	1955-02-02	\N	From Wikipedia, the free encyclopedia.\n\nBob Schreck (born February 2, 1955) is an American comic book writer and editor, known for his work for publishers including Marvel Comics,Dark Horse Comics, Oni Press, DC Comics, and Legendary Comics.\n\n One of Shreck's earliest jobs in comics was working with Creation Entertainment on their Creation conventions. He later served as administrative director at Comico Comics. For much of the 1990s Schreck was an editor at Dark Horse Comics, and went on to found Oni Press in 1997. Then he went over to work as an editor at DC Comics, where he worked on the Batman comics and the All Star titles, but was laid off in January 2009. Schreck writes the comic book series Jurassic Park: Redemption, as well as being an editor, for IDW Publishing.  In 2011, he served as the editor-in-chief to the new Legendary Comics, a graphic novel venture from Legendary Pictures.	0		Bob Schreck
2514	1948-05-30	2005-11-01		0		Michael Piller
2387	1940-07-13	\N	Sir Patrick Hewes Stewart is an English film, television and stage actor. He has had a distinguished career in theatre and television for around half a century. He is most widely known for his television and film roles, as Captain Jean-Luc Picard in Star Trek: The Next Generation and as Professor Charles Xavier in the X-Men films.\n\nStewart was born in Mirfield near Dewsbury in the West Riding of Yorkshire, England, the son of Gladys, a weaver and textile worker, and Alfred Stewart, a Regimental Sergeant Major in the British Army who served with the King's Own Yorkshire Light Infantry and previously worked as a general labourer and as a postman. Stewart and his first wife, Sheila Falconer, have two children: Daniel Freedom and Sophie Alexandra. Stewart and Falconer divorced in 1990. In 1997, he became engaged to Wendy Neuss, one of the producers of Star Trek: The Next Generation, and they married on 25 August 2000, divorcing three years later. Four months prior to his divorce from Neuss, Stewart played opposite actress Lisa Dillon in a production of The Master Builder. The two dated for four years, but are no longer together. He is now seeing Sunny Ozell; at 31, she is younger than his daughter. "I just don't meet women of my age," he explains.\n\nStewart has been a prolific actor in performances by the Royal Shakespeare Company, appearing in over 60 productions.	2	Mirfield, West Yorkshire, England	Patrick Stewart
2388	1952-08-19	\N	From Wikipedia, the free encyclopedia.\n\nJonathan Scott Frakes (born August 19, 1952) is an American actor, author and director. Frakes is best known for his portrayal of Commander William T. Riker in the television series Star Trek: The Next Generation and subsequent films. Frakes also hosted the television series Beyond Belief: Fact or Fiction, challenging viewers to discern his stories of fact-based phenomena and fabricated tales. In June 2011, Frakes narrated the History Channel documentary Lee and Grant. He was also the voice actor of David Xanatos in the Disney television series Gargoyles.\n\nFrakes directed and also starred in Star Trek: First Contact as well as Star Trek: Insurrection. He is also the author of a book called The Abductors: Conspiracy.	0	Bellefonte - Pennsylvania - USA	Jonathan Frakes
1213786	1949-02-02	\N	From Wikipedia, the free encyclopedia.\n\nBrent Jay Spiner (/ˈspaɪnər/, born February 2, 1949, height 5' 10" (1,78 m)) is an American actor, best known for his portrayal of the android Lieutenant Commander Data in the television series Star Trek: The Next Generation and four subsequent films. His portrayal of Data in Star Trek: First Contact and of Dr. Brackish Okun in Independence Day, both in 1996, earned him a Saturn Award and Saturn Award nomination respectively.\n\nHe has also enjoyed a career in the theatre and as a musician.\n\nBrent Jay Spiner was born February 2, 1949 in Houston, Texas to Sylvia and Jack Spiner, who owned a furniture store. After his father's death, Spiner was adopted by Sylvia's second husband, Sol Mintz, whose surname he used between 1955 and 1975. Spiner was raised Jewish. He attended Bellaire High School, Bellaire, Texas. Spiner became active on the Bellaire Speech team, winning the national championship in dramatic interpretation. He attended the University of Houston where he performed in local theatre.	2	Houston - Texas - USA	Brent Spiner
2390	1957-02-16	\N	From Wikipedia, the free encyclopedia.\n\nLevardis Robert Martyn Burton, Jr. (born February 16, 1957, height 5' 7" (1,70 m)) professionally known as LeVar Burton, is an American actor, director, producer and author who first came to prominence portraying Kunta Kinte in the 1977 award-winning ABC television miniseries Roots, based on the novel by Alex Haley.\n\nHe is also well known for his portrayal of Geordi La Forge on the syndicated science fiction series Star Trek: The Next Generation and as the host of the PBS children's program Reading Rainbow.	0	Landstuhl - Rhineland-Palatinate - Germany	LeVar Burton
2392	1949-03-02	\N	From Wikipedia, the free encyclopedia.\n\nCheryl Gates McFadden (born March 2, 1949), usually credited as Gates McFadden, is an American actress and choreographer.\n\nShe is best known for portraying the character of Dr. Beverly Crusher in the television and film series Star Trek: The Next Generation. She attended Brandeis University earning B.A Cum Laude in Theater Arts. After graduating from Brandeis, she moved to Paris and studied theater with actor Jacques LeCoq. Before Star Trek: The Next Generation, she was mostly known as a choreographer, often working on Jim Henson productions including the films The Dark Crystal, for which she was a choreographer, Labyrinth, for which she served as Director of Choreography and Puppet Movement, and The Muppets Take Manhattan, in which she has a brief on-screen appearance.\n\nAs a way of distinguishing her acting work from her choreography, she is usually credited as "Gates McFadden" as an actress and "Cheryl McFadden" as a choreographer. She appeared briefly in the Woody Allen film Stardust Memories, and in The Hunt for Red October as Jack Ryan's wife Cathy, though most of her scenes were cut in post-production. In 1987, McFadden was cast as Dr. Beverly Crusher on Star Trek: The Next Generation.\n\nThe Crusher character was slated to be Captain Jean-Luc Picard's love interest, and this aspect of the character is what attracted McFadden to the role. Another important aspect of the character was being a widow balancing motherhood and a career. McFadden left after the first season, in part because series executive producer Gene Roddenberry was never enthusiastic about casting McFadden in the first place.\n\nRoddenberry also wanted to give the role of ship's doctor to actress Diana Muldaur, with whom he had worked on the original Star Trek series and other occasions. Muldaur's character, Dr. Katherine Pulaski, proved very unpopular with fans and left the show after the second season. McFadden was approached to return for the third season. At first she was hesitant, but after a phone call from co-star Patrick Stewart, McFadden was persuaded to reprise her role.	1	Cuyahoga Falls, Ohio, USA	Gates McFadden
2393	1955-03-29	\N	From Wikipedia, the free encyclopedia.\n\nMarina Sirtis (born 29 March 1955, height 5' 4½" (1,64 m)) is an English-American actress. She is best known for her role as Counselor Deanna Troi on the television series Star Trek: The Next Generation and the four feature films that followed.\n\nBiography\n\nMarina Sirtis was born in the East End of London, the daughter of working class Greek parents Despina, a tailor's assistant, and John Sirtis. She was brought up in Harringay, North London and emigrated to the U.S. in 1986, later becoming a naturalized U.S. citizen. She auditioned for drama school against her parents' wishes, ultimately being accepted to the Guildhall School of Music and Drama. She is married to rock guitarist Michael Lamper (21 June 1992 – present). Her younger brother, Steve, played football in Greece and played for Columbia University in the early 1980s. Marina herself is an avowed supporter of Tottenham Hotspur F.C.\n\nCareer\n\nSirtis started her career as a member of the repertory company at the Connaught Theatre, Worthing, West Sussex in 1976. Directed by Nic Young, she appeared in Joe Orton's What the Butler Saw and as Ophelia in Hamlet.\n\nBefore her role in Star Trek, Sirtis was featured in supporting roles in several films. In the 1983 Faye Dunaway film The Wicked Lady, she engaged in a whip fight with Dunaway. In the Charles Bronson sequel Death Wish 3, Sirtis's character is a rape victim. In the film Blind Date, she appears as a prostitute who is murdered by a madman.\n\nOther early works include numerous guest starring roles on British television series. Sirtis appeared in Raffles (1977), Hazell (1978), Minder (1979), the Jim Davidson sitcom Up the Elephant and Round the Castle (1985) and The Return of Sherlock Holmes (1986) among other things. She also played the stewardess in the famous 1979 Cinzano Bianco television commercial starring Leonard Rossiter and Joan Collins, in which Collins was splattered with drink.	0	London - England - UK	Marina Sirtis
1164	1939-10-24	\N	From Wikipedia, the free encyclopedia.\n\nFahrid Murray Abraham (born October 24, 1939) is an American actor. He became known during the 1980s after winning the Academy Award for Best Actor for his role as Antonio Salieri in Amadeus. He has appeared in many roles, both leading and supporting, in films such as All the President's Men and Scarface. He is also known for his television and theatre work.	2	Pittsburgh, Pennsylvania, USA	F. Murray Abraham
2516	1936-05-20	\N	From Wikipedia, the free encyclopedia.\n\nAnthony Jared Zerbe (born May 20, 1936) is an American stage, film and Emmy-winning television actor. Notable film roles include the post-apocalyptic cult leader Matthias in The Omega Man, a 1971 film adaptation of Richard Matheson's 1954 novel, I Am Legend; Milton Krest in the 1989 James Bond film Licence to Kill; and Rosie in The Turning Point.\n\nDescription above from the Wikipedia article Anthony Zerbe, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Long Beach, California	Anthony Zerbe
2517	1959-03-07	\N	​From Wikipedia, the free encyclopedia\n\nDonna Murphy (born March 7, 1958) is an American stage, film, television actress and singer. Murphy has won two Tony Awards for Best Actress in a Musical for her roles in Passion as Fosca and in The King and I as Anna Leonowens. She received three more Tony Award nominations for Best Actress in a Musical for her performances in Wonderful Town as Ruth Sherwood,Lovemusik as Lotte Lenya and The People in the Picture as Raisel/Bubbie. She is known, most recently, for her role as Mother Gothel in the animated Disney film Tangled (2010), Anij, Captain Jean-Luc Picard's love interest, in Star Trek: Insurrection (1998) and her numerous stage roles in musical theatre.\n\nDescription above from the Wikipedia article Donna Murphy, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Corona, New York, USA	Donna Murphy
2518	1952-05-06	\N	From Wikipedia, the free encyclopedia.\n\nGregg Lee Henry (born May 6, 1952) is an American theatre, film and television character actor and rock, blues and country musician.	0	Lakewood - Colorado - USA	Gregg Henry
2507	1941-07-31	\N		2	Los Angeles, California, USA	Matthew F. Leonetti
1760	1929-02-10	2004-07-21	Jerrald King "Jerry" Goldsmith (February 10, 1929 – July 21, 2004) was an American composer and conductor most known for his work in film and television scoring. He composed scores for such noteworthy films as The Sand Pebbles, Logan's Run, Planet of the Apes, Patton, Papillon, Chinatown, The Wind and the Lion, The Omen, The Boys from Brazil, Capricorn One, Alien, Poltergeist, The Secret of NIMH, Gremlins, Hoosiers, Total Recall, Basic Instinct, Rudy, Air Force One, L.A. Confidential, Mulan, The Mummy, three Rambo films, and five Star Trek films.\n\nHe collaborated with some of film history's most accomplished directors, including Robert Wise, Howard Hawks, Otto Preminger, Joe Dante, Richard Donner, Roman Polanski, Ridley Scott, Steven Spielberg, Paul Verhoeven, and Franklin J. Schaffner.\n\nGoldsmith was nominated for six Grammy Awards, five Primetime Emmy Awards, nine Golden Globe Awards, four British Academy Film Awards, and eighteen Academy Awards (he won only one, in 1976, for The Omen).	2	Pasadena, California, USA	Jerry Goldsmith
2522	1770-12-17	1827-03-26	From Wikipedia, the free encyclopedia\n\nLudwig van Beethoven (Listeni/ˈlʊdvɪɡ væn ˈbeɪˌtoʊvən/, /ˈbeɪtˌhoʊvən/; German: [ˈluːtvɪç fan ˈbeːtˌhoˑfn̩] ( listen); baptised 17 December 1770 – 26 March 1827) was a German composer. A crucial figure in the transition between the Classical and Romantic eras in Western art music, he remains one of the most famous and influential of all composers. His best-known compositions include 9 symphonies, 5 piano concertos, 1 violin concerto, 32 piano sonatas, 16 string quartets, his great Mass the Missa solemnis and an opera, Fidelio.\n\nBorn in Bonn, then the capital of the Electorate of Cologne and part of the Holy Roman Empire, Beethoven displayed his musical talents at an early age and was taught by his father Johann van Beethoven and by composer and conductor Christian Gottlob Neefe. At the age of 21 he moved to Vienna, where he began studying composition with Joseph Haydn, and gained a reputation as a virtuoso pianist. He lived in Vienna until his death. By his late 20s his hearing began to deteriorate, and by the last decade of his life he was almost totally deaf. In 1811 he gave up conducting and performing in public but continued to compose; many of his most admired works come from these last 15 years of his life.	2	Bonn, Kurfürstentum Köln	Ludwig van Beethoven
2083	1935-04-19	\N		0		Herman F. Zimmerman
2399	\N	\N		0		Junie Lowry-Johnson
2400	\N	\N		0		Ron Surma
1319747	\N	\N		0		Garet Reilly
2397	\N	\N		0		Robert Blackman
1551320	\N	\N	Jack started in the sound transfer department of Goldwyn Sound at Warner Hollywood Studios cleaning film. In 1985, he became the second Recordist in Stage D. In 1990 he became the lead Recordist in Stage A. Jack left Stage A in 1998 to become a Mixer and Sound Effects Editor in the new DVD Mastering Department. During that time he was directly involved in formatting soundtracks for DVD release, the department restored and remastered most of the Warner Brothers catalog. He continued in that capacity until he retired on May 1, 2013. He and his wife Sara live in Valencia California	0		Jack Keller
955	1974-04-28	\N	Penélope Cruz Sánchez is a Spanish actress and model, signed at age 15, made her acting debut at 16 on television and her feature film debut the following year in Jamón, jamón (1992), to critical acclaim.  Cruz achieved recognition for her lead roles in the 2001 films Vanilla Sky and Blow.\n\nShe has since built a successful career, appearing in films from a range of genres, from thrillers to family friendly holiday features. She has received critical acclaim for her roles in Volver (2006) and Nine (2009) receiving Golden Globe and Academy Award nominations for each. She won the Academy Award for Best Supporting Actress in 2008 for Vicky Cristina Barcelona (2008). She was the first Spanish actress in history to receive an Academy Award and the first Spanish actress to receive a star at the Hollywood Walk of Fame.\n\nCruz has modeled for companies such as Mango, Ralph Lauren and L'Oréal. Penélope and her younger sister Mónica Cruz have designed items for Mango.  Cruz has volunteered in Uganda and India; she donated her salary from The Hi-Lo Country to help fund the late nun's mission. A wax sculpture of Cruz will be placed in a premier spot in the Grevin Wax Museum in Paris.\n\nModified from Wikipedia, the free encyclopedia.	1	Madrid - Spain	Penélope Cruz
2744	1945-09-15	\N	From Wikipedia, the free encyclopedia.\n\nCarmen García Maura (born September 15, 1945) is a Spanish actress. In a career that has spanned six decades, Maura is best known for her collaborations with noted Spanish film director Pedro Almodóvar.\n\nDescription above from the Wikipedia article Carmen Maura, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Madrid, Spain	Carmen Maura
2759	1971-10-06	\N	From Wikipedia, the free encyclopedia.\n\nLola Dueñas (born October 6, 1971) is a Spanish actress.\n\nShe is the daughter of Nicolás Dueñas and studied in the Institut del Teatre of Barcelona.\n\nDescription above from the Wikipedia article Lola Dueñas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Barcelona, Spain	Lola Dueñas
3480	1963-06-15	\N	From Wikipedia, the free encyclopedia.\n\nBlanca Portillo (born June 15, 1963) is a Spanish actress.\n\nDescription above from the Wikipedia article Blanca Portillo, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Madrid, Spain	Blanca Portillo
3481	1985-01-12	\N		0		Yohana Cobo
3482	1930-12-11	2016-04-04	María Jesús Lampreave Pérez (11 December 1930 – 4 April 2016), known as Chus Lampreave, was a Spanish actress. Born in Madrid, she began appearing in films in 1958, but she became internationally known thanks to her roles in films by Pedro Almodóvar, where she played old ladies with maternal or pastoral traits. She died in Almería in 2016 at the age of 85.	1	Madrid - Spain	Chus Lampreave
3483	1968-01-18	\N		0	Málaga, Andalucía, Spain	Antonio de la Torre
4363	\N	\N		0		Carlos Blanco
4364	1964-07-04	\N		1		María Isabel Díaz
4365	\N	\N		0		Neus Sanz
4366	\N	\N		0		Leandro Rivera
4367	1968-09-04	\N		0	Barcelona, Catalonia, Spain	Yolanda Ramos
4368	\N	\N		0		Carlos García Cambero
4369	\N	\N		0		Natalia Roig
4370	\N	\N		0		Eli Iranzo
4371	\N	\N		1		Fanny de Castro
4372	1963-10-07	\N		0	Madrid, Spain	Concha Galán
4373	\N	\N		0		Magdalena Brotto
4374	\N	\N		0		Pepa Aniorte
4375	\N	\N		0		Isabel Ayúcar
1621575	\N	\N		0		Elvira Cuadrupani
954664	\N	\N		1		María Alfonsa Rosso
7215	1961-01-29	\N	From Wikipedia, the free encyclopedia.  John Brancato and Michael Ferris are a pair of American screenwriters, whose works include The Game, Terminator 3: Rise of the Machines, Terminator Salvation and Surrogates.  They met while at college, where both were editors of The Harvard Lampoon.  Description above from the Wikipedia article John Brancato and Michael Ferris, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	USA	Michael Ferris
7227	\N	\N		0		Hal Lieberman
7228	\N	\N		0		Joel B. Michaels
3986	1951-10-10	\N		0		Mario Kassar
952	\N	\N	Agustín Almodóvar Caballero is a film producer and younger brother of filmmaker Pedro Almodóvar. He was born in Calzada de Calatrava and obtained a degree in chemistry from the Complutense University of Madrid. He began his career in film production as a messenger in Fernando Trueba's film Sé infiel y no mires con quién. In 1986, he and Pedro founded their own production company, El Deseo S.A. Through this company he has produced all of Pedro's films since 1986, and several French co-productions. He is a member of the Academy of Cinematographic Arts and Sciences of Spain.  en.wikipedia.org · Text under CC-BY-SA license	0	Calzada de Calatrava, Spain, EU	Agustín Almodóvar
1077948	\N	\N		0		Mila Espiga
1348364	\N	\N		0		Valeria Vereau
309	1949-09-24	\N	From Wikipedia, the free encyclopedia.\n\nPedro Almodóvar Caballero (born 25 September 1949) is a Spanish film director, screenwriter and producer.\n\nAlmodóvar is arguably the most successful and internationally known Spanish filmmaker of his generation. His films, marked by complex narratives, employ the codes of melodrama and use elements of pop culture, popular songs, irreverent humor, strong colors, glossy décor and LGBT themes. Desire, passion, family and identity are among Almodóvar’s most prevalent themes. His films enjoy a worldwide following and he has become a major figure on the stage of world cinema.\n\nHe founded Spanish film production company El Deseo S.A. with his younger brother Agustín Almodóvar who has produced almost all of Pedro’s films. He was elected a Foreign Honorary Member of the American Academy of Arts and Sciences in 2001.\n\nDescription above from the Wikipedia article Pedro Almodóvar, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Calzada de Calatrava, Ciudad Real, Castilla-La Mancha, Spain	Pedro Almodóvar
93	\N	\N		0		Esther García
405	\N	\N		0		Alberto Iglesias
4376	1938-12-26	\N		2	Tangier, Morocco	José Luis Alcaine
413	\N	\N		0		José Salcedo
4378	\N	\N		0		Luis San Narciso
4379	\N	\N		0		Salvador Parra
3051	1972-11-01	\N	From Wikipedia, the free encyclopedia.\n\nAntonia "Toni" Collette (born 1 November 1972) is an Australian actress and musician, known for her acting work on stage, television and film as well as a secondary career as the lead singer of the band Toni Collette &amp; the Finish.\n\nCollette's acting career began in the early 1990s with comedic roles in films such as Spotswood (1992) and Muriel's Wedding (1994), for which she was nominated for a Golden Globe Award for Best Actress. Following her performances in Emma (1996) and The Boys (1998), Collette achieved international recognition as a result of her Academy Award-nominated portrayal of Lynn Sear in The Sixth Sense (1999). She has appeared in thrillers such as Shaft (2000) and Changing Lanes (2002) and independent comedy films like About a Boy (2002), In Her Shoes (2005) and Little Miss Sunshine (2006).\n\nIn 2009, she began playing the lead role in the television series United States of Tara, for which she won a Primetime Emmy Award and a Golden Globe Award for Best Actress – Television Series Musical or Comedy in 2010.	1	Sydney, New South Wales, Australia	Toni Collette
23	1940-02-27	2011-05-21	​From Wikipedia, the free encyclopedia.  \n\nWilliam John "Bill" Hunter (27 February 1940 – 21 May 2011) was an Australian actor of film, stage and television. He appeared in more than 60 films and won two Australian Film Institute Awards.\n\nDescription above from the Wikipedia article Bill Hunter (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Ballarat, Victoria, Australia	Bill Hunter
3052	1968-12-18	\N	Rachel Anne Griffiths is an Australian film and television actress. She came to prominence with the 1994 film Muriel's Wedding and her Academy Award nominated performance in Hilary and Jackie (1998). She is best known for her portrayals of Brenda Chenowith in the HBO series Six Feet Under and Sarah Walker Laurent on the ABC primetime drama Brothers &amp; Sisters. Her work in film and television has earned her a Golden Globe Award, two Screen Actors Guild Awards and three Australian Film Institute Awards.\n\nGriffith attended Melbourne University, studying philosophy, before attending the drama department at Victoria School of the Art.  After college, she began working with the touring youth company Woolly Jumpers Theater Company, as well as the Melbourne Theater Company, where she appeared in numerous dramas.  \n\nGriffiths made a name for herself in 1991 when she wrote and performed in the short film "Barbie Gets Hip,” which was screened at the Melbourne International Film Festival. She landed a few TV spots before she was cast as Rhonda, Toni Collette's sidekick in P.J. Hogan's "Muriel's Wedding" (1994), winning her an Australian Film Institute Award for Best Supporting Actress. These successes jump-started her career, landing her numerous dramatic and comedic roles in overseas productions, before making her American cinema debut with her second P.J. Hogan collaboration, "My Best Friend's Wedding” (1997).\n\nIn the fall of 2001, Griffiths accepted her first major television series role and came aboard Alan Ball’s HBO series "Six Feet Under."  Griffith stayed with the show during its five years of critical acclaim, while at the same time, continued to appear an lend her voice to screen and direct-to-video features before returning to telvision to star in "Brothers and Sisters" to much similar acclaim. 	1	Melbourne, Victoria, Australia	Rachel Griffiths
3053	1968-08-07	\N	From Wikipedia, the free encyclopedia.\n\nSophie Lee (born 7 August 1968 in Newcastle, New South Wales) is an Australian film, stage and television actress and author.\n\nDescription above from the Wikipedia article Sophie Lee, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Newcastle, New South Wales, Australia	Sophie Lee
3054	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nRosalind Hammond was born in Western Australia, often credited as Ros or Roz, is an Australian comic actress and writer.\n\nDescription above from the Wikipedia article  Rosalind Hammond, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Roz Hammond
3057	\N	\N		0		Belinda Jarrett
3059	1970-09-12	\N	From Wikipedia, the free encyclopedia.\n\nPippa Jody Grandison (born 12 September 1970 in Perth, Australia) is an Australian musical theatre performer. She currently lives in Sydney, with husband Steve Le Marquand and daughter Charlie.\n\nDescription above from the Wikipedia article Pippa Grandison, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Perth, Western Australia, Australia	Pippa Grandison
3060	\N	\N		0		Jeanie Drynan
3062	\N	\N		2		Daniel Wyllie
3066	\N	\N		0		Gabby Millgate
3067	\N	\N		0		Gennie Nevinson
3068	1971-09-28	\N	​From Wikipedia, the free encyclopedia.  \n\nMatthew "Matt" Day (born 28 September 1971) is an Australian actor best known for his film and television roles.\n\nDescription above from the Wikipedia article Matt Day,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Melbourne, Australia	Matt Day
7229	1966-10-07	\N		0		Marco Beltrami
36	\N	\N		0		Don Burgess
7230	\N	\N		0		Nicolas De Toth
7231	1936-10-12	2012-03-28		0		Neil Travis
7232	\N	\N		0		Sarah Finn
3045	1962-11-30	\N	From Wikipedia, the free encyclopedia. Paul John "P. J." Hogan (born 30 November 1962 ) is an Australian film director.\n\nHogan was born in Brisbane, Queensland. As a teenager, Hogan lived on the North Coast of New South Wales and attended Mt St Patrick's College and was said to have had a difficult time in high school as he was a victim of bullying.\n\nHis first big hit was the 1994 Australian film Muriel's Wedding, which helped launch the careers of actors Toni Collette and Rachel Griffiths. The success of the film also led him to be chosen by Julia Roberts to direct his 1997 American debut My Best Friend's Wedding, which also starred Cameron Diaz and Dermot Mulroney.\n\nHogan followed up My Best Friend's Wedding with the comedy Unconditional Love (which was filmed in 1999 but not released until 2003), and 2003's big budget adaptation of Peter Pan starring Jason Isaacs as Captain Hook, Jeremy Sumpter as Peter Pan and Rachel Hurd-Wood as Wendy. The following year he directed a pilot for a remake of the cult soap opera Dark Shadows, which was not picked up for broadcast, and created the story for the 2008 musical film The American Mall. He then directed Confessions of a Shopaholic (starring Isla Fisher), an adaptation of the novel The Secret Dreamworld of a Shopaholic. He will be directing a film of Blue Balliett's book Chasing Vermeer in the future.  \n\nHogan is married to film director Jocelyn Moorhouse.\n\nDescription above from the Wikipedia article P. J. Hogan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brisbane, Queensland, Australia	P.J. Hogan
3046	\N	\N		0		Lynda House
3047	1960-09-04	\N		0		Jocelyn Moorhouse
9344	\N	\N		0		Hugh Bateup
3048	1943-10-18	\N		0		Peter Best
3049	\N	\N		0		Martin McGrath
3050	\N	\N		0		Jill Bilcock
3108	\N	\N		0		Alison Barrett
3109	\N	\N		0		Paddy Reardon
672646	\N	\N		0		Michael D. Aglion
1322883	\N	\N		0		Tony Mahood
3061	1971-03-31	\N	Ewan Gordon McGregor was born 31 March 1971 in Crieff, Scotland. At 16, he left Crieff and Morrison Academy to join the Perth Repertory Theatre. His parents encouraged him to leave school and pursue his acting goals rather than be unhappy. McGregor studied drama for a year at Kirkcaldly in Fife, then enrolled at London's Guildhall School of Music and Drama for a three-year course. He studied alongside Daniel Craig and Alistair McGowan among others, and left right before graduating after snagging the role of Private Mick Hopper in Dennis Potter's 1993 six-part Channel 4 series "Lipstick on Your Collar" (1993).\n\nHis first notable role was that of Alex Law in Shallow Grave (1994), directed by Danny Boyle, written by John Hodge and produced by Andrew MacDonald. This was followed by The Pillow Book (1996) and Trainspotting (1996), the latter of which brought him to the public's attention.\n\nHe is now one of the most critically acclaimed actors of his generation, and portrays Obi-wan Kenobi in the first three Star Wars episodes. McGregor is married to French production designer Eve Mavrakis, whom he met while working on the TV show "Kavanagh QC" (1995). They married in France in the summer of 1995 and have two daughters, Clara Mathilde and Esther Rose. McGregor has formed a production company with friends Jonny Lee Miller, Sean Pertwee, Jude Law and Sadie Frost. Called Natural Nylon, they hope it will make innovative films that do not conform to Hollywood standards.	2	Perth, Scotland, UK	Ewan McGregor
3063	1960-11-05	\N	Katherine Mathilda "Tilda" Swinton (born 5 November 1960) is a British actress known for both arthouse and mainstream films. She won the Academy Award for Best Supporting Actress for her performance in Michael Clayton.\n\nDescription above from the Wikipedia article Tilda Swinton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	London, United Kingdom	Tilda Swinton
3064	1959-11-02	\N	From Wikipedia, the free encyclopedia.\n\nPeter Mullan (born 2 November 1959) is a Scottish actor and film-maker who has been appearing in films since 1990.\n\nDescription above from the Wikipedia article Peter Mullan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Peterhead, Scotland, UK	Peter Mullan
1653	1944-05-28	\N	​From Wikipedia, the free encyclopedia\n\nJean-Pierre Léaud (born 28 May 1944) is a French actor. \n\nDescription above from the Wikipedia article Jean-Pierre Léaud, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Paris, France	Jean-Pierre Léaud
3507	1948-10-08	2006-12-01	​From Wikipedia, the free encyclopedia.  \n\nClaude Marcelle Jorré, better known as Claude Jade (8 October 1948 – 1 December 2006), was a French actress, known for starring as Christine in François Truffaut's three films Stolen Kisses (1968), Bed and Board (1970) and Love on the Run (1979). Jade acted in theatre, film and television. Her film work outside of France included the Soviet Union, the United States, Italy and Japan.\n\nDescription above from the Wikipedia article Claude Jade, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dijon, France	Claude Jade
3509	1927-07-25	2003-03-27	From Wikipedia, the free encyclopedia\n\nDaniel Ceccaldi (July 25, 1927 – March 27, 2003) was a French actor.\n\nHe was born in Meaux, Seine-et-Marne, France. The mild-mannered Daniel Ceccaldi is famous as Claude Jade's father Lucien Darbon in François Truffaut's movies Stolen Kisses and Bed &amp; Board.Note: Christine refers to him twice as "Lucien", not papa, indicating perhaps that he is not her biological father, echoing Truffaut's own experience. The American critics Bob Wade wrote about Ceccaldi in 'Stolen Kisses': "Claude Jade's parents are memorably played by Daniel Ceccaldi and Claire Duhamel. Ceccaldi’s role may represent the most pleasant and neurosis-free father in any movie of the era. He overflows with Dickensian warmth and geniality."\n\nDescription above from the Wikipedia article Daniel Ceccaldi, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Meaux, Seine-et-Marne, France	Daniel Ceccaldi
3510	1925-09-06	2014-02-07		1	Vineuil-Saint-Firmin, Oise, France	Claire Duhamel
3572	1936-01-01	2003-06-21		1	Tokyo, Japan	Hiroko Berghauer
3573	1922-01-24	2014-10-27	From Wikipedia, the free encyclopedia. Daniel Boulanger (Compiègne, Oise, 24 January 1922) is a French novelist, playwright, poet and screenwriter. He has also played secondary roles in films and has been a member of the Académie Goncourt since 1983. Description above from the Wikipedia article Daniel Boulanger , licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Compiègne, Oise, France	Daniel Boulanger
3574	1931-09-29	\N		0		Silvana Blasi
3575	1920-07-30	1988-05-21		1	Menthon-Saint-Bernard, Haute Savoie, France	Barbara Laage
3577	1930-06-02	\N		2	Paris, France	Claude Véga
3579	\N	\N		0		Danièle Girard
3580	\N	\N		0		Marie Irakane
7233	1965-08-28	\N		2	San Diego, California, United States	Jeff Mann
7234	1968-08-28	\N		0	New York City, New York, USA	Shepherd Frankel
7235	\N	\N		0		Beat Frutiger
7236	\N	\N		0		Andrew Menzies
7237	\N	\N		0		Jay Hart
7238	1932-10-31	\N		1		April Ferry
1305	\N	\N		0		Bill Abbott
7239	\N	\N		0		Peter Brown
7240	\N	\N		0		Cary Weitz
3581	1940-08-28	2001-08-25	From Wikipedia, the free encyclopedia.\n\nPhilippe Léotard ( born Ange Philippe Paul André Léotard-Tomasi August 28, 1940 - died August 25, 2001) was a French actor, poet, and singer.\n\nHe was born in Nice , one of seven children - four girls, then three boys, of which he was the oldest - and was the brother of politician François Léotard. His childhood was normal except for an illness (rheumatic fever) which struck him and forced him to spend days in bed during which time he read a great many books. He was particularly fond of the poets - Baudelaire, Rimbaud, Lautréamont, Blaise Cendrars. He met Ariane Mnouchkine at the Sorbonne and in 1964 they formed the théâtre du soleil.\n\nHe played Philippe, the tormented son of a women with terminal illness, in the 1974 drama film La Gueule ouverte, by the controversial director Maurice Pialat. He won a César Award for Best Actor for his role in the 1982 movie La Balance.\n\nOne of his few English-language roles was a cameo in the 1973 thriller The Day of the Jackal and he co-starred as "Jacques" in the 1975 John Frankenheimer movie French Connection II which starred Gene Hackman and Fernando Rey, (sequel to The French Connection).\n\nLéotard died in 2001 of respiratory failure in Paris at the age of 60. He was interred at the Père Lachaise Cemetery in Paris.\n\nDescription above from the Wikipedia article Philippe Léotard, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Nice, France	Philippe Léotard
1650	1932-02-06	1984-10-21	From Wikipedia, the free encyclopedia.\n\nFrançois Roland Truffaut (6 February 1932 – 21 October 1984) was an influential film critic and filmmaker and one of the founders of the French New Wave. In a film career lasting over a quarter of a century, he remains an icon of the French film industry. He was also a screenwriter, producer, and actor working on over twenty-five films. Along with Jean-Luc Godard, Truffaut was one of the most influential figures of the French New Wave, inspiring directors such as Steven Spielberg, Quentin Tarantino, Brian De Palma, Martin Scorsese, &amp; Wes Anderson.\n\nDescription above from the Wikipedia article François Truffaut, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Paris, France	François Truffaut
35249	1935-03-06	\N		2	Coutances, France	Jacques Robiolles
70142	1926-10-03	2011-07-18	Jacques Jouanneau est un acteur français né le 3 octobre 1926 à Angers (Maine-et-Loire) et mort le 18 juillet 2011 à Nîmes (Gard).	0		Jacques Jouanneau
1372429	\N	\N		0		Christophe Vesque
36915	1933-09-03	2010-07-10		2	Labruguière, France (Tarn)	Pierre Maguelon
126234	1924-10-05	\N		2	Lyon, France	Guy Piérauld
1372430	\N	\N		0		Annick Asty
1372431	\N	\N		0		Yvon Lec
35898	1933-10-14	2006-03-23		2	Wimereux, France	Pierre Fabre
35958	1923-02-17	1992-11-28	Billy Kearns was born on February 17, 1923 in Seattle, Washington, USA as William R. Kearns. He was an actor, known for Plein soleil (1960), Marathon Man (1976) andPlaytime (1967). He died on November 28, 1992 in Château d'Oex, Switzerland.	0	Seattle - Washington - USA	Billy Kearns
1372433	\N	\N		0		Marianne Piketti
1372437	\N	\N		0		Marie Dedieu
39443	1923-08-01	1986-02-09		2	Belvès, Dordogne, France	Jacques Rispal
1372438	\N	\N		0		Marie Iracane
40586	\N	\N		0		Christian de Tillière
3531	1933-04-07	\N	From Wikipedia, the free encyclopedia.  Claude de Givray (born 7 April 1933) is a French film director and screenwriter. He directed the 1965 film Un mari à un prix fixe, which starred Anna Karina.  Description above from the Wikipedia article Claude de Givray, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Nice, France	Claude de Givray
3532	\N	\N		0		Bernard Revon
3524	1922-12-25	\N	Marcel Berbert est un directeur de production, producteur et acteur français, né le 25 décembre 1922 à Paris.\n\nMarcel Berbert fut, pendant plus de vingt ans, le producteur des Films du Carrosse, la société de production de François Truffaut. Il l'assiste dès le tournage des Quatre Cents coups, et travaillera avec Truffaut pendant plus de vingt ans.	0	Paris - France	Marcel Berbert
3529	1925-07-30	\N		0		Antoine Duhamel
3872	1978-06-16	\N	​From Wikipedia, the free encyclopedia\n\nDaniel César Martín Brühl González Domingo ( born 16 June 1978) is a German actor. He is best known as Daniel Brühl.\n\nDescription above from the Wikipedia article Daniel Brühl, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\nDaniel speak Spanish, German and Català.	2	Barcelona, Barcelona, Catalonia, Spain	Daniel Brühl
3932	1978-02-20	\N	Julia Jentsch (born February 20, 1978) , is a Silver Bear, two-time European Film Award, and Lola winning German actress. She is best known as the title character in Sophie Scholl – The Final Days, Jule in The Edukators and, Liza in I Served the King of England.\n\n​Jentsch was born to a family of lawyers in Berlin and began her acting education there at Hochschule Ernst Busch, a university for drama. Her first prominent screen role was in the 2004 cult film The Edukators, starring opposite Daniel Brühl. Jentsch garnered further attention playing the title role in the 2005 film Sophie Scholl – The Final Days, which was nominated for an Academy Award for Best Foreign Language Film. In an interview, Jentsch said that the role was "an honor".[1] For her role as Sophie Scholl she won the best actress at the European Film Awards, best actress at the German Film Awards (Lolas), along with the Silver Bear for best actress at theBerlin Film Festival.	1	Berlin, Germany	Julia Jentsch
3933	1974-10-30	\N		0		Stipe Erceg
3934	1949-09-13	\N	Burghart Klaußner (born 13 September 1949) is a German film actor. He has appeared in 50 films since 1983.\n\nDescription above from the Wikipedia article Burghart Klaußner, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Berlin, Germany	Burghart Klaußner
3935	1958-12-09	\N		2	Frankfurt am Main, Germany	Peer Martiny
3936	1957-12-23	\N	Petra Zieser was born on December 23, 1957 in Munich, Germany. She is an actress, known for Die fetten Jahre sind vorbei (2004), Erleuchtung garantiert (1999) and Urlaub vom Leben (2005).	0	München-Germany	Petra Zieser
3937	\N	\N		0		Laura Schmidt
3938	\N	\N		0		Sebastian Butz
3939	1977-05-11	\N		0	Berlin - Germany	Oliver Bröcker
169	1947-06-18	\N	From Wikipedia, the free encyclopedia.\n\nHanns Zischler (born 18 June 1947) is a German actor most famous in America for his portrayal of Hans in Steven Spielberg's film Munich. According to the Internet Movie Database, Zischler has appeared in 171 movies since 1968.\n\nKnown in Sweden for his role as Josef Hillman in the second season of the Martin Beck movies, though his voice is dubbed.\n\nHe is sometimes credited as Hans Zischler, Johann Zischler, or Zischler.\n\nDescription above from the Wikipedia article Hanns Zischler, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Nürnberg-Germany	Hanns Zischler
88442	\N	\N		0		Claudio Caiolo
36468	1965-02-06	\N		0		Bernhard Bettermann
3722	1970-11-02	\N		2	Feldkirch, Austria	Hans Weingartner
3927	\N	\N		0		Sabine Holtgreve
3928	\N	\N		0		Georg Steinert
3967	1973-07-26	\N	Kathryn Bailey "Kate" Beckinsale is an English actress. She first gained notice, while a student at Oxford University, for making her debut in the film adaptation of Shakespeare's Much Ado About Nothing. Throughout the 1990s, she worked on both film and television, most notably by portraying the title character in the 1996 BBC television series Emma. In 2001, Beckinsale garnered international recognition when she was cast as the romantic lead opposite Ben Affleck in her breakthrough film, Pearl Harbor (2001). Since then, she has portrayed a variety of characters in projects such as Underworld (2003), The Aviator (2004), and Van Helsing (2004). In 2008, she earned a Critic's Choice Award nomination for her performance in Nothing But the Truth. Born in Finsbury Park, London, Beckinsale is the daughter of actor Richard Beckinsale, who died from a heart attack in 1979, and actress Judy Loe. She has a paternal half-sister, Samantha, who is also an actress. Her paternal grandfather was half Burmese, and she has said that she was "very oriental-looking" as a child.	1	Finsbury Park, London, UK	Kate Beckinsale
100	1975-09-01	\N	Scott Speedman (born September 1, 1975) is a British-born Canadian film and television actor. He is best known for playing Ben Covington in the coming-of-age television drama Felicity and Lycan-Vampire hybrid Michael Corvin in the gothic horror/action Underworld films.\n\nDescription above from the Wikipedia article Scott Speedman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Scott Speedman
3968	1969-02-05	\N	Michael Christopher Sheen, OBE (born 5 February 1969) is a Welsh film and stage actor. Having worked with screenwriter Peter Morgan on five films, Sheen has become known for his portrayals of well-known public figures: Tony Blair in "The Deal", "The Queen" and "The Special Relationship", David Frost in the stage production and film version of "Frost/Nixon", and Brian Clough in "The Damned United". He also played the Lycan Lucian in all three of the "Underworld" films, the vampire Aro in "The Twilight Saga: New Moon", and more recently, the role of Castor in "Tron: Legacy".\n\nDescription above from the Wikipedia article Michael Sheen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Newport, Monmouthshire, Wales, UK	Michael Sheen
6408	1979-12-05	\N	From Wikipedia, the free encyclopedia.  Nicolas Kent "Nick" Stahl (born December 5, 1979) is an American actor. Starting out as a child actor, he gained recognition for his performance in the 1993 film The Man Without a Face and then embarked on a successful career as a child actor. He later transitioned into his adult career with roles in Bully, Sin City, In the Bedroom, the HBO series Carnivàle, and the film Terminator 3: Rise of the Machines, in which he took over the role of John Connor, originally played by Edward Furlong. He also recently starred in the film Mirrors 2.  Description above from the Wikipedia article Nick Stahl, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Harlingen, Texas, USA	Nick Stahl
6194	1979-04-12	\N	Claire Catherine Danes (born April 12, 1979) is an American actress of television, stage and film. She has appeared in roles as diverse as Angela Chase in My So-Called Life, as Juliet in Baz Luhrmann's Romeo + Juliet, as Yvaine in Stardust and as Temple Grandin in the HBO TV film Temple Grandin.\n\nDescription above from the Wikipedia article Claire Danes, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Manhattan, New York, USA	Claire Danes
7218	1979-10-08	\N	Kristanna Sommer Loken (born October 8, 1979) is an American actress known for her work in both film and television, and as a fashion model.\n\nDescription above from the Wikipedia article Kristanna Loken, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Ghent, New York, USA	Kristanna Loken
7219	1952-11-02	\N	From Wikipedia, the free encyclopedia.\n\nDavid Andrews (born 1952) is an American actor, best known for his role as General Robert Brewster in Terminator 3: Rise of the Machines. Andrews was born in Baton Rouge, Louisiana. His attended the Louisiana State University as an undergraduate and followed with a year at the Duke University School of Law and two at Stanford Law School, from which he graduated in the late 1970s. He set his career off in style by starring in the 1984 horror classic A Nightmare on Elm Street. For the rest of the 80s Andrews did not have any major hits, mainly focusing on a TV career. In 1990 he starred in Stephen King's Graveyard Shift and in 1994 he was James Earp in Kevin Costners Wyatt Earp. His career was boosted by starring in the TV series Mann &amp; Machine. In 1995 he played astronaut Pete Conrad, alongside Tom Hanks, Kevin Bacon and Bill Paxton in the classic space drama Apollo 13.\n\nIn the late 90s Andrews concentrated on more television projects and starred in TV films such as Our Son, the Matchmaker, Fifteen and Pregnant, which also starred Kirsten Dunst, and the hit TV film Switched at Birth. In 1998 he played another astronaut, Frank Borman, in the HBO miniseries From the Earth to the Moon. He had a brief role as Major General Eldridge G. Chapman, commander of the 13th Airborne Division, in the Band of Brothers miniseries. 1999 was a great year for Andrews: not only that he did get the success from Switched at Birth but also Fight Club, which starred Brad Pitt and Edward Norton. Andrews started off the millennium by starring in Navigating the Heart before moving on to the sequel of the cannibal series Hannibal, starring Anthony Hopkins.\n\nIn 2002 he appeared in A Walk to Remember, and in 2003 he starred in Two Soldiers, The Chester Story and Terminator 3: Rise of the Machines. He also replaced John M. Jackson in the final season of JAG, playing Judge Advocate General Major General Gordon 'Biff' Cresswell. He was Edwin Jensen in the TV Movie The Jensen Project. Andrews played the role of Scooter Libby in the 2010 film, Fair Game, based on the Valerie Plame affair.	0	Baton Rouge - Louisiana - USA	David Andrews
7220	1979-09-26	\N	Mark Famiglietti is an actor and produce.	0	Providence - Rhode Island - USA	Mark Famiglietti
2716	1945-11-07	\N		2	New York City, New York, USA	Earl Boen
7221	1954-07-20	\N		0		Moira Harris
7222	\N	\N		0		Chopper Bernet
7223	1955-03-29	\N	From Wikipedia, the free encyclopedia Christopher Kennedy Lawford (born March 29, 1955) is an American author, actor and activist and member of the prominent Kennedy family. Description above from the Wikipedia article Christopher Lawford, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Santa Monica, California, USA	Christopher Lawford
7226	1980-05-05	\N		0		Alana Curry
27738	1971-11-23	\N	​From Wikipedia, the free encyclopedia.\n\nChristopher Ryan "Chris" Hardwick (born November 23, 1971) is an American actor, television personality, writer, musician, and comedian.\n\nDescription above from the Wikipedia article Chris Hardwick, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	 Louisville, Kentucky, USA	Chris Hardwick
1444239	\N	\N		0		Robert Alonzo
1178376	1950-04-25	\N		1	Detroit, Michigan, USA 	Susan Merson
7213	1961-11-28	\N	From Wikipedia, the free encyclopedia.\n\nJonathan Mostow (born November 28, 1961, in Woodbridge, Connecticut) is an American film director, writer and producer.	0	Woodbridge - Connecticut - USA	Jonathan Mostow
7214	\N	\N	From Wikipedia, the free encyclopedia.  John Brancato and Michael Ferris are a pair of American screenwriters, whose works include The Game, Terminator 3: Rise of the Machines, Terminator Salvation and Surrogates.  They met while at college, where both were editors of The Harvard Lampoon.  Description above from the Wikipedia article John Brancato and Michael Ferris, licensed under CC-BY-SA, full list of contributors on Wikipedia	0		John D. Brancato
380	1943-08-17	\N	Robert De Niro, Jr. (born August 17, 1943) is an American actor, director, and producer. His first major film role was in 1973's Bang the Drum Slowly. In 1974, he played the young Vito Corleone in The Godfather Part II, a role that won him the Academy Award for Best Supporting Actor. His longtime collaboration with Martin Scorsese began with 1973's Mean Streets, and earned De Niro an Academy Award for Best Actor for his portrayal of Jake LaMotta in the 1980 film, Raging Bull. He was also nominated for an Academy Award for his roles in Scorsese's Taxi Driver (1976) and Cape Fear (1991). In addition, he received nominations for his acting in Michael Cimino's The Deer Hunter (1978) and Penny Marshall's Awakenings (1990). He has received high critical praise in Scorsese's films such as for his portrayals as Travis Bickle in Taxi Driver, Jake Lamotta in Raging Bull, and as Jimmy Conway in Goodfellas. He has earned four nominations for the Golden Globe Award for Best Actor – Motion Picture Musical or Comedy: New York, New York (1977), Midnight Run (1988), Analyze This (1999) and Meet the Parents (2000). He directed A Bronx Tale (1993) and The Good Shepherd (2006).\n\nDescription above from the Wikipedia article Robert De Niro, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	Robert De Niro
4512	1947-04-18	\N	James Howard Woods (born April 18, 1947) is an American film, stage and television actor. Woods is known for starring in critically acclaimed films such as Once Upon a Time in America, Salvador, Nixon, Ghosts of Mississippi, Casino, Hercules, and in the television legal drama Shark. He has won two Emmy Awards, and has gained two Academy Award nominations.\n\nDescription above from the Wikipedia article James Woods, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Vernal, Utah, USA	James Woods
4513	1961-07-18	\N	​From Wikipedia, the free encyclopedia.  \n\nElizabeth McGovern (born July 18, 1961) is an American film, television, and theater actor.\n\nIn 1980, while studying at Juilliard, McGovern was offered a part in her first film, Ordinary People, in which she played the girlfriend of troubled teenager Timothy Hutton.\n\nThe following year she completed her education as an actress at the American Conservatory Theatre and at The Juilliard School, and began to appear in plays, first Off-Broadway and later in famous theaters.\n\nIn 1981, she earned an Academy Award nomination for Best Supporting Actress for her role as Evelyn Nesbit in the film Ragtime.\n\nIn 1984, she starred in Sergio Leone's gangster epic Once Upon a Time in America as Robert De Niro's romantic interest, Deborah Gelly. In 1989, she played Mickey Rourke's girlfriend in Johnny Handsome, directed by Walter Hill, and the same year she appeared as a rebellious lesbian in Volker Schlöndorff's thriller The Handmaid's Tale.\n\nDescription above from the Wikipedia article Elizabeth McGovern, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Evanston, Illinois, USA	Elizabeth McGovern
4514	1943-08-27	\N	Tuesday Weld (born August 27, 1943) is an American actress.\n\nWeld began her acting career as a child, and progressed to more mature roles during the late 1950s. She won a Golden Globe Award for Most Promising Female Newcomer in 1960. Over the following decade she established a career playing dramatic roles in films.\n\nAs a featured performer in supporting roles, her work was acknowledged with nominations for a Golden Globe Award for Play It As It Lays (1972), an Academy Award for Best Supporting Actress for Looking for Mr. Goodbar (1978), an Emmy Award for The Winter of Our Discontent (1983), and a BAFTA for Once Upon a Time in America (1984).\n\nSince the end of the 1980s, her acting appearances have been infrequent.\n\nDescription above from the Wikipedia article Tuesday Weld, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, USA	Tuesday Weld
4515	1951-12-01	\N	Richard Treat Williams (born December 1, 1951) is a Screen Actors Guild Award-nominated American actor who has appeared on film, stage and television. From 2002 to 2006, he was the star of the television series Everwood.	0	Rowayton - Connecticut - USA	Treat Williams
4516	1953-11-25	1983-11-08		0		James Hayden
4517	1943-02-09	\N	From Wikipedia, the free encyclopedia\n\nJoseph Frank "Joe" Pesci (born February 9, 1943) is an American actor, comedian, singer and musician. He is known for his roles as violent mobsters, funnymen, comic foils and quirky sidekicks. Pesci has starred in a number of high profile films such as Goodfellas, Casino, Raging Bull, Once Upon a Time in America, My Cousin Vinny, Easy Money, JFK, Moonwalker, Home Alone, Home Alone 2: Lost in New York, and the 2nd, 3rd, and 4th Lethal Weapon films.\n\nIn 1990, Pesci won the Academy Award for Best Supporting Actor for his role as the psychopathic mobster Tommy DeVito in Goodfellas, ten years after receiving a nomination in the same category for Raging Bull.\n\nDescription above from the Wikipedia article Joe Pesci, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Newark, New Jersey, USA 	Joe Pesci
4518	\N	\N		0		Larry Rapp
1004	1933-06-20	\N	​From Wikipedia, the free encyclopedia.\n\nDaniel Louis "Danny" Aiello, Jr.  (born June 20, 1933) is an American actor who has appeared in numerous motion pictures, including Once Upon a Time in America, Ruby, The Godfather: Part II, Hudson Hawk, The Purple Rose of Cairo, Moonstruck, Léon, Two Days in the Valley, and Dinner Rush. He had a pivotal role in the 1989 Spike Lee film Do the Right Thing, earning a nomination for a Best Supporting Actor Academy Award for his portrayal of Salvatore 'Sal' Frangione, the pizzeria owner, and also as Don Domenico Clericuzio in the miniseries Mario Puzo's The Last Don.\n\nDescription above from the Wikipedia article Danny Aiello, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New York City, New York, USA	Danny Aiello
4520	1955-06-07	\N	William Forsythe  (born June 7, 1955) is an American actor, known for playing "tough guy" roles.\n\nDescription above from the Wikipedia article William Forsythe, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Bedford-Stuyvesant, Brooklyn, New York, USA	William Forsythe
4521	1940-04-30	\N	​From Wikipedia, the free encyclopedia.\n\nBurt Young (born April 30, 1940) is an American actor, painter, and author. He is best-known for his Academy Award-nominated role as Sylvester Stallone's brother-in-law and friend Paulie in the Rocky film series.\n\nDescription above from the Wikipedia article Burt Young, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New York City, New York, USA	Burt Young
4750	\N	\N		0		Scott Schutzman Tiler
4751	\N	\N		0		Rusty Jacobs
4752	\N	\N		0		Adrian Curran
52969	1972-04-04	\N	​From Wikipedia, the free encyclopedia.\n\nLisa Ray  (born 4 April 1972), is a Canadian actress and former Model.\n\nDescription above from the Wikipedia article Lisa Ray, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Toronto, Canada	Lisa Ray
111808	1948-04-26	\N	From Wikipedia, the free encyclopedia.\n\nMoushumi Chatterjee (26 April 1948) is a Bollywood actress, who has also acted in Bengali cinema. She worked with actors like Dharmendra, Amitabh Bachchan, Jeetendra and Vinod Mehra.\n\nDescription above from the Wikipedia article Moushumi Chatterjee, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Jabalpur, India	Moushumi Chatterjee
4753	1970-06-30	\N	Brian Keith Bloom is an American actor, voice actor, and screenwriter. Bloom was born in Merrick, New York, the brother of producer/actor Scott Bloom and musician Mike Bloom. Bloom had an early interest in acting, including appearing in several commercials as a child, but made his big break in theSergio Leone film Once Upon a Time in America. From there, he was offered the role of Dusty Donovan in the hit soap opera As the World Turns, which he played for several years. During that run, Bloom became the youngest winner of a Daytime Emmy Award in the category of Outstanding Young Leading Man during the 12th Daytime Emmy Awards show for his performance on the series. Despite his success, he soon grew tired of the scheduling involved in that field and eventually left the series to star in several television movies and myriad guest appearances.	0	Long Island - New York - USA	Brian Bloom
4754	\N	\N		0		Noah Moazezi
4761	1958-11-25	\N	​From Wikipedia, the free encyclopedia.\n\nDarlanne Fluegel born in Wilkes-Barre, Pennsylvania on November 25, 1953.  She is an American actress.\n\nFluegel appeared in the TV series Crime Story and the final season of Hunter. She was featured in Sergio Leone's 1984 film Once Upon a Time in America as Robert De Niro's girlfriend Eve (credited as "Darlanne Fleugel"),[1] and in 1986's Tough Guys as Kirk Douglas' girlfriend. In 1985 she appeared in To Live And Die In L.A. as Ruth Lanier, the love interest (and snitch) of William Petersen's main character Secret Service Agent Richard Chance. Not long afterward, in early 1986, she portrayed Billy Crystal's ex-wife, Anna, in the hit buddy-cop action comedy Running Scared.\n\nFluegel also appeared in numerous other performances and appearances on network television (such as The Tonight Show), major advertising campaigns and music videos, as well as “cover girl” and other national and international professional modeling (represented for 15 years by The Ford Agency, New York).\n\nFluegel taught acting as a professor at the University of Central Florida from 2002 to 2007.\n\nDescription above from the Wikipedia article Darlanne Fluegel, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Pasadena, California, USA	Darlanne Fluegel
4773	\N	\N		0		Mike Monetti
6161	1970-12-12	\N	Jennifer Lynn Connelly (born December 12, 1970), is an American film actress and former child model who started modeling after a friend of her parents suggested an audition.\n\nShe subsequently appeared in magazine, newspaper and television advertising. Connelly made her motion picture debut in the 1984 crime film Once Upon a Time in America, then, while continuing her career as a model, starred as a teenager in films such as Labyrinth and Career Opportunities. She gained critical acclaim following her work in the 1998 science fiction film Dark City and for her portrayal of Marion Silver in Darren Aronofsky's 2000 drama, Requiem for a Dream. In 2002, Connelly won an Academy Award for Best Supporting Actress along with many other awards for her role as Alicia Nash in Ron Howard's 2001 biopic A Beautiful Mind. Other film credits include the 2003 Marvel superhero film Hulk, the 2005 thriller Dark Water, the drama Blood Diamond, the remake of The Day the Earth Stood Still and the romantic comedy He's Just Not That Into You. Since 2005, Connelly has served as the Amnesty International Ambassador for Human Rights Education for the United States. Magazines, including Time, Vanity Fair, Esquire, and the Los Angeles Times, have included her on their lists of the world's most beautiful women.\n\nDescription above from the Wikipedia article Jennifer Connelly, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Catskill Mountains, New York, USA	Jennifer Connelly
17921	\N	\N		0		Clem Caserta
1373773	\N	\N		0		Frank Gio
785	1953-04-23	\N	From Wikipedia, the free encyclopedia\n\nJames Vincent Russo (born April 23, 1953) is an American film and television actor. He has starred in over 90 films in three decades.\n\nDescription above from the Wikipedia article James Russo, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	James Russo
3174	1937-06-28	2006-02-18	​From Wikipedia, the free encyclopedia.  \n\nRichard J. Bright (June 28, 1937 – February 18, 2006) was an American actor best known for his role as Al Neri in the The Godfather films.\n\nDescription above from the Wikipedia article Richard Bright, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Brooklyn, New York, U.S.	Richard Bright
151943	\N	\N		0		Gerard Murphy
1373775	\N	\N		0		Margherita Pace
1373776	\N	\N		0		Frank Sisto
1373778	\N	\N		0		Mike Gendel
61236	\N	\N		0		Jerry Strivelli
1373779	\N	\N		0		Sandra Solberg
4385	1929-01-03	1989-04-30	Sergio Leone (January 3, 1929 – April 30, 1989) was an Italian film director, producer and screenwriter most associated with the "Spaghetti Western" genre. Leone's film-making style includes juxtaposing extreme close-up shots with lengthy long shots. His movies include The Colossus of Rhodes, the Dollars Trilogy (A Fistful of Dollars; For a Few Dollars More; and The Good, the Bad and the Ugly), Once Upon a Time in the West; Duck, You Sucker!; and Once Upon a Time in America.\n\nDescription above from the Wikipedia article Sergio Leone,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Rome, Italy	Sergio Leone
1304	\N	\N	Gabriella Pescucci (born 1941 in Rosignano Solvay, Tuscany) is an Italian costume designer. She has worked with directors Pier Paolo Pasolini, Federico Fellini, Sergio Leone, Terry Gilliam, Martin Scorsese, Tim Burton and Neil Jordan. In 1993 she won an Oscarfor The Age of Innocence.\n\nGabriella Pescucci was born in Tuscany in the province of Livorno. She studied Art at Accademia, Florence. In 1966 moved to Rome with the express intention of becoming a costume designer for the cinema. She began her career as an assistant to Piero Tosi on the sets of Visconti’s Medea and Death in Venice. Pescucci took her first steps in cinema withGiuseppe Patroni Griffi at the start of the 70s, designing costumes that took inspiration from paintings by Carpaccio and Leonardo.\n\nHer international debut was in 1984 with Once Upon a Time in America, for which she won the first of her two BAFTA Awards, the second being for The Adventures of Baron Munchausen by director Terry Gilliam and scenographer Dante Ferretti.\n\nShe received many other nominations and awards, among which a David di Donatello with The Name of the Rose and an Oscar for The Age of Innocence in 1993. Some of her most popular works include costume design on Charlie and the Chocolate Factory, Les Misérables and Agora.\n\nIn addition to her film and television work she has designed for the Opera, notably La Traviata at La Scala, Un ballo in maschera at the Kennedy Centre in Washington, D.C., and La bohème in Florence.\n\nDescription above from the Wikipedia article Gabriella Pescucci, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Rosignano Solvay, Tuscany, Italy	Gabriella Pescucci
4656	\N	\N		0		Gabe Videla
4657	\N	\N		0		Louis Craig
4658	\N	\N		0		Danilo Bollettini
86213	1972-06-20	\N	From Wikipedia, the free encyclopedia.\n\nRahul Khanna (is an Indian actor, event host &amp; television presenter.	2	Bombay, Maharashtra, India	Rahul Khanna
5119	1966-04-18	\N		0	Vienna, Austria	Catrin Striebeck
105652	1922-03-04	2008-10-11	From Wikipedia, the free encyclopedia.\n\nDina Pathak or Deena Pathak née Gandhi (4 March 1922 - 11 October 2002) was a veteran actor and director of Gujarati theatre and also a film actor. She was also a woman activist and remained the President of the 'National Federation of Indian Women' (NIFW). A doyen of Hindi and Gujarati films as well as theatre, Dina Pathak acted in over 120 films in a career spanning over six decades; her production Mena Gurjari in Bhavai folk theatre style, ran successfully for many years, and is now an part of its repertoire.\n\nShe is best known for her memorable roles in the Hindi films Gol Maal and Khubsoorat. She was a favourite of the Art Cinema in India where she essayed powerful roles in films like Koshish, Umrao Jaan, Mirch Masala and Mohan Joshi Hazir Ho!.\n\nHer notable Gujarati films were Moti Ba, Malela Jeev, and Bhavani Bhavai while her well-known plays include Dinglegar, Doll's House, Vijan Sheni and Girish Karnad's Hayavadana, directed by Satyadev Dubey.\n\nDescription above from the Wikipedia article Dina Pathak, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Bhavnagar, Gujarat, India	Dina Pathak
53377	1944-10-21	\N		0		Kulbhushan Kharbanda
106461	\N	\N		0		Ranjit Chowdhry
82096	1980-12-05	\N	Jessica Paré (born December 5, 1980) is a Canadian film and television actress. She has appeared in the films Stardom (2000), Lost and Delirious (2001), Wicker Park (2004), Hot Tub Time Machine (2010), and co-starred in the vampire horror-comedy Suck (2009). She plays Megan on the fourth season of the American TV series Mad Men.	1	Montréal - Québec - Canada	Jessica Paré
52975	\N	\N		0		Rishma Malik
111809	1974-04-01	\N		0		Jazz Mann
111810	\N	\N		0		Arjun Lombardi-Singh
111811	\N	\N		0		Leesa Gaspari
111812	\N	\N		0		Neelam Mansingh
111813	\N	\N		0		Mike Deol
111814	\N	\N		0		Jolly Bader
111815	\N	\N		0		Ronica Sajnani
111816	\N	\N		0		Jeremy Chow
111817	\N	\N		0		Damon D'Oliveira
111818	\N	\N		0		Nicky Gill
111819	\N	\N		0		Nicole Innis
111820	1982-01-16	\N		0		Rohan Bader
111821	\N	\N		0		Terry Stevens
111822	\N	\N		0		Rupinder Nagra
111823	\N	\N		0		Anne Mroczkowski
111824	\N	\N		0		Monisha Randhawa
111825	\N	\N		0		Pragna Desai
87328	1975-03-28	\N	​From Wikipedia, the free encyclopedia.  \n\nAkshaye Khanna  (born 28 March 1975 in Mumbai, India) is a critically acclaimed Indian film actor who works in Hindi cinema. Known for his impeccable acting talent and flawless diction, Khanna has worked with the best names in Indian cinema.\n\nDescription above from the Wikipedia article Akshaye Khanna licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Mumbai, Maharashtra, India	Akshaye Khanna
4760	1950-01-01	\N	From Wikipedia, the free encyclopedia.\n\nDeepa Mehta, LLD (born 1 January 1950 in Amritsar, Punjab, India) is a Genie Award-winning and Academy Award-nominated Indian-born Canadian film director and screenwriter, most known for her Elements Trilogy, Fire (1996), Earth (1998), and Water (2005), which was nominated for Academy Award for Best Foreign Language Film. She also co-founded Hamilton-Mehta Productions, with her husband, producer David Hamilton in 1996.\n\nDescription above from the Wikipedia article Deepa Mehta, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Amritsar, India	Deepa Mehta
1231	1960-12-03	\N	Julianne Moore (born Julie Anne Smith; December 3, 1960) is an American actress and a children's book author. Throughout her career she has been nominated for four Oscars, six Golden Globes, three BAFTAs and nine Screen Actors Guild Awards. Moore began her acting career in 1983 in minor roles, before joining the cast of the soap opera As the World Turns, for which she won a Daytime Emmy Award in 1988. She began to appear in supporting roles in films during the early 1990s, in films such as The Hand That Rocks the Cradle and The Fugitive. Her performance in Short Cuts (1993) won her and the rest of the cast a Golden Globe for their ensemble performance, and her performance in Boogie Nights (1997) brought her widespread attention and nominations for several major acting awards.\n\nHer success continued with films such as The Big Lebowski (1998), The End of the Affair (1999) and Magnolia (1999). She was acclaimed for her portrayal of a betrayed wife in Far from Heaven (2002), winning several critic awards as best actress of the year, in addition to several other nominations, including the Academy Award, Golden Globe, and Screen Actors Guild Award. The same year she was also nominated for several awards as best supporting actress for her work in The Hours. In 2010 Moore starred in the comedy drama The Kids Are All Right, for which she received a Golden Globe and BAFTA nomination.\n\nDescription above from the Wikipedia article Julianne Moore, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Fayetteville, North Carolina, USA	Julianne Moore
3905	1950-03-13	\N	From Wikipedia, the free encyclopedia.\n\nWilliam Hall Macy, Jr. (born March 13, 1950) is an American actor and writer. He was nominated for an Academy Award for his role as Jerry Lundegaard in Fargo. He is also a teacher and director in theater, film and television. His film career has been built mostly on his appearances in small, independent films, though he has appeared in summer action films as well. Macy has described his screen persona as "sort of a Middle American, WASPy, Lutheran kind of guy... Everyman". He has won two Emmy Awards and a Screen Actors Guild Award, being nominated for nine Emmy Awards and seven Screen Actors Guild Awards in total. He is also a three-time Golden Globe Award nominee.	2	Miami - Florida  USA	William H. Macy
5117	1961-08-18	\N	From Wikipedia, the free encyclopedia.\n\nBirol Ünel (born 18 August 1961) is a German actor of Turkish descent. He has acted in a number of German and Turkish films, TV series and theatrical productions. His name, "Birol", means "unique" in Turkish.\n\nÜnel was born in Mersin in southern Turkey. In 1968, his family moved to Brinkum near Bremen in Germany. He studied acting at Hanover Conservatory.\n\nÜnel began as a theatre actor at the Berliner Tacheles where he played the lead and also directed the play "Caligula". Ünel made his film debut in 1988's The Passenger. He played a private detective in the film Dealer which he followed up with a role in Fatih Akın's Im Juli. Birol then acted in the award winning Gegen die Wand as Cahit Tomruk. He won the German film prize for best actor for this role.\n\nHis latest films have been Transylvania, Seven Heroes and Soul Kitchen. Ünel also acted in the hit Turkish film Hırsız var! in 2005.\n\nDescription above from the Wikipedia article Birol Ünel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Silifke, Mersin, Turkey	Birol Ünel
5118	1980-06-16	\N	From Wikipedia, the free encyclopedia.\n\nSibel Kekilli (born 16 June 1980) is a German actress. She gained public attention after starring in the 2004 film Head-On (German: Gegen die Wand). For her performances, she was awarded twice with the most prestigious German movie award, the Lola.\n\nDescription above from the Wikipedia article Sibel Kekilli, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Heilbronn, Germany	Sibel Kekilli
5120	1960-01-01	\N	​Güven Kıraç (d. 1960) Tiyatro ve sinema oyuncusu. Mimar Sinan Üniversitesi Devlet Konservatuvarı Tiyatro Bölümü mezunudur. 1960 yılında İstanbul'da dünyaya geldi. Abhaz kökenlidir .1986 yılından beri birçok televizyon dizisi, reklam filmi ve sinema filminde rol aldı. İki yıl devlet tiyatrosu sanatçısı olarak çalıştıktan sonra istifa etti. Adana Devlet Tiyatrosu'nda Ağrı Dağı Efsanesi, İki Kalas Bir Heves ve Sıkıyönetim; Gülriz Sururi Tiyatrosu'nda ise Tiyatrocu, Sokak Kızı İrma, Hamlet ve Tiyatro Stüdyosu'nda Balkon adlı tiyatro oyunlarında oynamıştır. 1997 yılında Zeki Demirkubuz'un yönettiği "Masumiyet" adlı filmde Yusuf karakteriyle, ÇASOD, MGD ve İsrail Uluslararası Film Festivali'nde En İyi Erkek Oyuncu ödüllerini almıştır. 1998'de Erkan Can ile birlikte Gemide adlı filmde rol aldı. Aynı yıl Laleli'de Bir Azize adlı filmde Aziz karakteriyle karşımıza çıktı. 1999 yılında Salkım Hanım'ın Taneleri adlı filmle 19. İstanbul Film Festivali 'nde En İyi Erkek Oyuncu ödülünü aldı. Aynı yıl Evimiz Olacak Mı? ve Hayat Bağları adlı televizyon dizilerinde rol aldı. 2001 yılında Yeditepe İstanbul adlı filmde Berber Remzi karakterini canlandırdı. 2002 yılında Abdülhamit Düşerken, 2003 yılında Fatih Akın'ın yönettiği Duvara Karşı adlı filmlerde yer aldı. 2004'de Yavuz Turgul'un Gönül Yarası, 2005'de Takva, Hacivat Karagöz Neden Öldürüldü?, Kebab Connection adlı filmlerde rol aldı. 2006 yılında Ömer Faruk Sorak'ın "Sınav" adlı filminde Rafet 69 adlı karakterle karşımıza çıktı.	0	İstanbul, Türkiye	Güven Kıraç
5121	1970-11-05	\N	​Meltem Cumbul (d. 11 Kasım 1970, İzmir), Türk sinema ve dizi oyuncusu.  1988 yılında İzmir Türk Koleji'nden ,1991'de Mimar Sinan Üniversitesi Devlet Konservatuarı Drama Ana Sanat Dalı'ndan mezun oldu. Ardından Londra'daki Şekspir Tiyatro Kumpanyası'nda (Shakespeare Company oyuncu olarak çalıştı. Daha sonra televizyonda bir kariyere adım atarak Aşağı Yukarı (ATV) ve Nereden başlasak? (Kanal D) programlarının sunuculuğunu yaptı. Bu arada filmlerde yardımcı roller de oynadı (Bay E ve Böcek gibi). 1996'da Sahte Dünyalar televizyon dizisinde başrol oynadı.  1997'de televizyonda kendi ismini taşıyan The Meltem Cumbul Show programını başlattı. Bu arada Karışık Pizza, Geboren in Absurdistan ve Anlat Şehrazat Anlat (müzikal) gibi filmlerde başroller aldı.Türk televizyonunda izleyici rekorları kıran Yılan Hikayesi dizisinde başrol oynadı.Daha sonra Biz size aşık olduk, Beşik Kertmesi ve Gurbet Kadını gibi televizyon dizilerin de rol aldı. Abdülhamit Düşerken filmindeki rolüyle Antalya Film Festivali'nde Altın Portakal ödülünü aldı. Mucizeler Komedisi'nde (müzikal), Şener Şen'le birlikte rol aldı.  1998 Eurovision Şarkı Yarışması'nda 2. olan Imaani'nin seslendirdiği Where Are You adlı parçayı Seninleydim ismiyle söyleyip klip çekti. 2004 Eurovision Şarkı Yarışması'nda ise yaptığı sunuculukla beğeni topladı. En son Aşk Yakar dizisinde rol almıştır. Meltem Cumbul aslen Konya Akşehirlidir.	0		Meltem Cumbul
5122	\N	\N		0		Stefan Gebelhoff
5123	1937-07-15	2012-03-22		0		Demir Gökgöl
5124	\N	\N		0		Cem Akin
5134	\N	\N		0		Aysel Iscan
1075606	\N	\N		0		Francesco Fiannaca
1123057	\N	\N		0		Mona Mur
42451	1959-09-22	\N		0		Ralph Misske
53845	\N	\N		0		Philipp Baltus
45906	1981-04-09	\N		1		Zarah Jane McKenzie
1075570	1939-02-07	2005-03-28	Hermann Lause was born on February 7, 1939 in Meppen, Germany. He was an actor, known for Gegen die Wand (2004), Schtonk! (1992) and Jede Menge Kohle (1981). He died on March 28, 2005 in Hamburg, Germany.	0	Meppen	Hermann Lause
563496	\N	\N		0		Orhan Güner
34190	\N	2006-09-23		0		Andreas Thiel
5498	1974-01-25	\N		0	Hamburg, West Germany	Adam Bousdoukos
5496	1972-04-27	\N	Kurtuluş was born in Uşak, Turkey, and moved at the age of 18 months to Germany, where he grew up with his brother, Tekin, in Salzgitter, Lower Saxony.  He performed several minor television roles in episodes of different TV shows and continued working in theater until his big-screen debut in his main role as the young Turkish boy Gabriel in Fatih Akın's filmKurz und schmerzlos (Short Sharp Shock). After his breakthrough he appeared in the successful TV mini-series Der Tunnel, of Roland Suso Richter, where he performed alongside Heino Ferch and Nicolette Krebitz. Doris Dörrie chose him for her sex comedy Naked. He went back to working in television with the love film Eine Liebe in Saigon (Love in Saigon) with Luxembourgian actress Désirée Nosbusch (to whom Kurtuluş is engaged).  Kurtuluş played the main detective role in six episodes of the cult German television series Tatort. He announced afterwards that he would be working on international projects.  --- Source: wikipedia	0	Salzgitter, Lower Saxony, Germany	Mehmet Kurtulus
1088662	\N	\N		0		Feridun Koc
145402	\N	\N		0		Selim Erdoğan
18734	1971-08-10	\N		2	Yildizeli, Turkey	Tim Seyfi
5500	1971-08-01	\N		0	Berlin - Germany	İdil Üner
974178	\N	\N		0		Maceo Parker
1267485	\N	\N		0		Fanfare Ciocarlia
5168	1950-05-12	\N	​From Wikipedia, the free encyclopedia.    Gabriel James Byrne (born May 12, 1950) is an Irish actor, film director, film producer, writer, cultural ambassador and audiobook narrator. His acting career began in the Focus Theatre before he joined London’s Royal Court Theatre in 1979. Byrne's screen début came in the Irish soap opera The Riordans and the spin-off show Bracken. The actor has now starred in over 35 feature films, such as The Usual Suspects, Miller's Crossing and Stigmata, in addition to writing two. Byrne's producing credits include the Academy Award-nominated In the Name of the Father. Currently, he is receiving much critical acclaim for his role as Dr. Paul Weston in the HBO drama In Treatment.  Description above from the Wikipedia article Gabriel Byrne, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Dublin, Ireland	Gabriel Byrne
4726	1959-08-14	\N	Marcia Gay Harden (born August 14, 1959) is an American film and theatre actress. Harden's breakthrough role was in The First Wives Club (1996) which was followed by several roles which gained her wider fame including the hit comedy Flubber (1997) and Meet Joe Black (1998). She received an Academy Award for Best Supporting Actress for her role as Lee Krasner in Pollock (2000). She has starred in a string of successful mainstream and independent movies, such as Space Cowboys (2000), Into the Wild (2007) and The Mist (2007). Harden’s recent credits include Lasse Hallstrom’s film, The Hoax, opposite Richard Gere, and The Walt Disney Company’s The Invisible, directed by David S Goyer. She was also recently seen in Lakeshore Entertainment’s The Dead Girl, directed by Karen Moncrief and starring Toni Colette, Kerry Washington, Mary Steenburgen and Brittany Murphy. In 2009, Harden received a Tony Award for the Broadway play God of Carnage. She has been nominated for an Emmy Award and the Screen Actors Guild Award two times.\n\nDescription above from the Wikipedia article Marcia Gay Harden, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	La Jolla, California, USA	Marcia Gay Harden
156689	1963-02-19	\N	Jessica Tuck is an actress.	1	New York City - New York - USA	Jessica Tuck
1241	1957-02-28	\N	John Michael Turturro (born February 28, 1957) is an American actor, writer, and director known for his roles in the films Barton Fink (1991), Quiz Show (1994), The Big Lebowski (1998), and O Brother, Where Art Thou? (2000). He has appeared in over sixty films, and has worked frequently with the Coen brothers, Adam Sandler, and Spike Lee.\n\nDescription above from the Wikipedia article John Turturro, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Brooklyn, New York, USA	John Turturro
4253	1950-12-29	\N	From Wikipedia, the free encyclopedia.\n\nJon Polito (born December 29, 1950) is an American actor, known for working with the Coen Brothers, most notably in the major supporting role of Italian gangster Johnny Caspar in Miller's Crossing. He also appeared in the first two seasons of Homicide: Life on the Street and on the first season of Crime Story. Polito won the Maverick Spirit Event Award at Cinequest Film Festival in 2005.\n\nHe portrays Orren Boyle in Atlas Shrugged (2011), the film adaptation of Ayn Rand's novel of the same name.\n\nPolito is the partner of actor and musician Darryl Armbruster.	0	Philadelphia - Pennsylvania - USA	Jon Polito
5169	1946-02-02	\N	J.E. Freeman (born February 2, 1946) is an American actor, often cast in tough guy roles. His first movie appearance was in the early 80's actionner An Eye for an Eye in which he plays a tow truck driver who minces words with Chuck Norris.\n\nHe is especially known for his menacing characters roles : the evil gangster Marcelles Santos in David Lynch's Wild at Heart, the terrifying Eddie Dane, ferocious gay hitman from Miller's Crossing, and the infamous scientist Mason Wren in Alien Resurrection. Other notable apparitions in : Ruthless People, Patriot Games, Copycat and Go.\n\nHe is openly gay. In 2009, he published a letter to the editor on sfgate.com, detailing his reminiscences of the 1969 Stonewall riots.\n\nDescription above from the Wikipedia article J. E. Freeman, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Brooklyn - New York - USA	J.E. Freeman
3926	1936-05-09	\N	Albert Finney came from the theatre, where he was especially successful in plays of William Shakespeare, to the movies. There he became a leading figure of the young Free Cinema. His debut in cinema was in 1960 with The Entertainer (1960) of Tony Richardson who had directed him also in theatre plays various times before. His typical role were young prolets like, e.g. Arthur Seaton in Saturday Night and Sunday Morning (1960).  IMDb Mini Biography By:  Volker Boehm	0	Salford, Greater Manchester, England, UK	Albert Finney
5170	1950-07-29	\N	From Wikipedia, the free encyclopedia.\n\nMichael "Mike" Starr Born on July 29, 1950 is an American actor. Known for his large size at 6' 3" or 190 cm, he has typically been typecast as playing thugs or henchmen.\n\nStarr was born in Flushing, Queens, New York to a retail employee mother and a meatpacker father. His older brother Beau Starr is also an actor. Mike Starr is a graduate of Hofstra University. He and his family reside in Riverdale, New York.	2	Queens, New York City, New York, USA	Mike Starr
5171	1932-11-13	2007-11-12		0		Al Mancini
5172	\N	\N		0		Richard Woods
5173	\N	\N		0		Thomas Toner
884	1957-12-13	\N	Steven Vincent "Steve" Buscemi is an American actor, writer and film director. He was born in Brooklyn, New York, the son of Dorothy, who worked as a hostess at Howard Johnson's, and John Buscemi, a sanitation worker and Korean War veteran. Buscemi's father was Sicilian American and his mother Irish American. He has three brothers: Jon, Ken, and Michael. Buscemi was raised Roman Catholic.\n\nIn April 2001, while shooting the film Domestic Disturbance in Wilmington, North Carolina, Buscemi was stabbed three times while intervening in a bar fight at Firebelly Lounge between his friend Vince Vaughn, screenwriter Scott Rosenberg and a local man, who allegedly instigated the brawl.\n\nBuscemi has one son, Lucian, with his wife Jo Andres.	2	New York City, New York, USA	Steve Buscemi
176958	\N	\N		0		Mario Todisco
53573	1955-08-31	\N	Aleksander Krupa, often credited as Olek Krupa, born August 31, 1955, is a Polish actor best known for playing villains and/or criminals, such as in Blue Streak and Home Alone 3. He also notably portrayed a Serb general engaged in genocide against Bosnian Muslims in 2001's Behind Enemy Lines.\n\nOn television he appears in many Law &amp; Order episodes.	2	Rybnik - Slaskie - Poland	Olek Krupa
2169	1952-08-26	2003-03-30	From Wikipedia, the free encyclopedia.\n\nMichael Jeter (August 26, 1952 – March 30, 2003) was an American actor.\n\nDescription above from the Wikipedia article Michael Jeter, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lawrenceburg, Tennessee, USA	Michael Jeter
3204	1942-07-27	\N		0		Lanny Flaherty
1126347	\N	\N		0		Jeanette Kontomitras
1281525	\N	\N		0		Louis Charles Mounicou III
16459	1958-11-13	\N	​From Wikipedia, the free encyclopedia\n\nJohn McConnell (born November 13, 1958), aka John "Spud" McConnell, is an American actor and radio personality based in New Orleans, Louisiana. McConnell is a character actor who has appeared in more than 40 films, ranging from obscure independent films (mostly filmed locally in New Orleans, or elsewhere set in the Gulf Coast region) to major cinematic release movies (such as the Coen Brothers production O Brother, Where Art Thou?). McConnell has also appeared in numerous plays, including an off-Broadway run in the one-man show The Kingfish, wherein he portrays colorful Louisiana Governor Huey P. Long. He is perhaps best-known for having portrayed Ignatius J. Reilly from the Pulitzer Prize winning novel A Confederacy of Dunces, and in that role was the model for a life-sized bronze statue of the fictitious character on historic Canal Street in downtown New Orleans. On television, McConnell made appearances over three seasons of Roseanne, with good friend and colleague John Goodman. Most recently, McConnell is featured in a recurring role on the FX series The Riches, starring Eddie Izzard and Minnie Driver. McConnell is a conservative afternoon radio personality, hosting a daily call-in talk show, "The Spud Show", on WWL 870 AM and 105.3 FM.\n\nDescription above from the Wikipedia article John McConnell (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Baton Rouge, Louisiana	John McConnell
27513	\N	\N		2		Danny Aiello III
1281526	\N	\N		0		Helen Jolly
1281527	\N	\N		0		Hilda McLean
1281528	\N	\N		0		Monte Starr
142160	\N	\N		0		Don Picard
1281529	\N	\N		0		Salvatore H. Tornabene
1281530	\N	\N		0		Kevin Dearie
162556	\N	\N		0		Dennis Paladino
106745	1954-09-10	\N	From Wikipedia, the free encyclopedia\n\nDon "The Dragon" Wilson (born September 10, 1954) is an American champion kickboxer and actor. He is most famous for his acting roles in action/adventure films, including eight titles in Roger Corman's Bloodfist series.\n\nDescription above from the Wikipedia article Don "The Dragon" Wilson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Cocoa Beach, Florida, USA	Don Wilson
1010	1954-12-20	\N	From Wikipedia, the free encyclopedia.\n\nMichael Badalucco (born December 20, 1954) is an American actor most famous for his role as lawyer Jimmy Berluti on the ABC legal drama The Practice. He won the 1999 Emmy for Best Supporting Actor for his role on the show.\n\nBadalucco, an Italian American, was born in Flatbush, Brooklyn, New York, the son of Jean, a homemaker, and Joe Badalucco, a set dresser, movie set carpenter and property person.[1] His brother is Joseph Badalucco Jr., whose most notable role was Jimmy Altieri in the show The Sopranos.\n\nHe attended Xaverian High School in Brooklyn, graduating in 1972. He was the guest speaker at the 2005 commencement. He later attended SUNY New Paltz in New Paltz, New York.\n\nHe is married to Brenda Heyob.\n\nDescription above from the Wikipedia article Michael Badalucco, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Brooklyn, New York, U.S.	Michael Badalucco
1281531	\N	\N		0		Charles Ferrara
1281532	\N	\N		0		Esteban Fernandez
1281533	\N	\N		0		George Fernandez
71659	1951-04-12	2002-12-11		0		Charles Gunning
1281535	\N	\N		0		Dave Drinkx
35022	\N	\N		0		David Darlow
1281536	\N	\N		0		Robert LaBrosse
1281537	\N	\N		0		Carl Rooney
1190852	\N	\N		0		Jack Harris
5266	1942-05-14	\N		0	Warthausen	Rüdiger Vogler
5274	1938-12-06	\N	From Wikipedia, the free encyclopedia.\n\nPatrick Nicolas Jean Sixte Ghislain Bauchau (born 6 December 1938) is a Belgian actor.	0	Brussels - Belgium	Patrick Bauchau
5275	\N	\N		0		Vasco Sequeira
5276	\N	\N		0		Joel Cunha Ferreira
5277	\N	\N		0		Sofia Bénard da Costa
5278	\N	\N		0		Vera Cunha Rocha
5279	\N	\N		0		Elisabete Cunha Rocha
5280	\N	\N		0		Ricardo Colares
2303	1945-08-14	\N	From Wikipedia, the free encyclopedia\n\nErnst Wilhelm "Wim" Wenders (born 14 August 1945) is a German film director, playwright, author, photographer and producer.	2	Düsseldorf, North Rhine-Westphalia, Germany	Wim Wenders
5267	\N	\N		0		Ulrich Felsberg
5268	1950-06-03	\N		2		Paulo Branco
5269	1957-12-10	\N	João Canijo is a Portuguese film director. His film Get a Life was screened in the Un Certain Regard section at the 2001 Cannes Film Festival. His 2011 film Blood of My Blood was selected as the Portuguese entry for the Best Foreign Language Oscar at the 85th Academy Awards, but it did not make the final shortlist.	0	Porto	João Canijo
2308	\N	\N		0		Jürgen Knieper
5270	\N	\N		0		Zé Branco
5271	\N	\N		1		Lisa Rinzler
2309	1941-10-26	2011-10-02		0		Peter Przygodda
5272	\N	\N		0		Anne Schnee
5273	\N	\N		0		Jaime Brito
190	1930-05-31	\N	Clinton "Clint" Eastwood, Jr. (born May 31, 1930) is an American film actor, director, producer, composer and politician. Following his breakthrough role on the TV series Rawhide (1959–65), Eastwood starred as the Man with No Name in Sergio Leone's Dollars Trilogy of spaghetti westerns (A Fistful of Dollars, For a Few Dollars More, and The Good, the Bad and the Ugly) in the 1960s, and as San Francisco Police Department Inspector Harry Callahan in the Dirty Harry films (Dirty Harry, Magnum Force, The Enforcer, Sudden Impact, and The Dead Pool) during the 1970s and 1980s. These roles, along with several others in which he plays tough-talking no-nonsense police officers, have made him an enduring cultural icon of masculinity.\n\nEastwood won Academy Awards for Best Director and Producer of the Best Picture, as well as receiving nominations for Best Actor, for his work in the films Unforgiven (1992) and Million Dollar Baby (2004). These films in particular, as well as others including Play Misty for Me (1971), The Outlaw Josey Wales (1976), Pale Rider (1985), In the Line of Fire (1993), The Bridges of Madison County (1995), and Gran Torino (2008), have all received commercial success and/or critical acclaim. Eastwood's only comedies have been Every Which Way but Loose (1978) and its sequel Any Which Way You Can (1980); despite being widely panned by critics they are the two highest-grossing films of his career after adjusting for inflation.\n\nEastwood has directed most of his own star vehicles, but he has also directed films in which he did not appear such as Mystic River (2003) and Letters from Iwo Jima (2006), for which he received Academy Award nominations and Changeling (2008), which received Golden Globe Award nominations. He has received considerable critical praise in France in particular, including for several of his films which were panned in the United States, and was awarded two of France's highest honors: in 1994 he received the Ordre des Arts et des Lettres medal and in 2007 was awarded the Légion d'honneur medal. In 2000 he was awarded the Italian Venice Film Festival Golden Lion for lifetime achievement.\n\nSince 1967 Eastwood has run his own production company, Malpaso, which has produced the vast majority of his films. He also served as the nonpartisan mayor of Carmel-by-the-Sea, California, from 1986 to 1988. Eastwood has seven children by five women, although he has only married twice. An audiophile, Eastwood is also associated with jazz and has composed and performed pieces in several films along with his eldest son, Kyle Eastwood.\n\nDescription above from the Wikipedia article Clint Eastwood, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Francisco, California, USA	Clint Eastwood
16309	1931-08-19	\N	From Wikipedia, the free encyclopedia.\n\nMarianne Koch (born August 19, 1931 in Munich) is a retired German actress of the 1950s and 1960s, best known for her appearances in spaghetti westerns and adventure films of the 1960s. She later worked as a television host and as a physician.\n\nBetween 1950 and 1971, Koch appeared in more than 65 films. In the haunting 1954 espionage thriller Night People she starred alongside Gregory Peck. Sergio Leone's 1964 production A Fistful of Dollars showcased her alongside Clint Eastwood as a civilian tormented by ruthless local gangsters, torn between her husband and child and the villains. In Germany she was probably best-loved for her many years of participation in the highly popular TV game show Was bin ich which ran from the 1950s until 1988 and achieved ratings of up to 75% at its peak.\n\nIn 1971, she resumed the medical studies she had broken off in the early 1950s to become an actress. She got her MD in 1974 and practiced medicine until 1997 as a specialist in Munich. In 1976, she was one of the initial hosts of Germany's pioneering talk show 3 nach 9 [Three After Nine], for which she was awarded one of the most prestigious awards of the German television industry, the Grimme Preis. She also hosted other television shows and had a medical advice program on radio.\n\nIn 1953, she married the physician Gerhard Freund, with whom she has two sons. The marriage ended in 1973 after Freund began an affair with Miss World 1956, Petra Schürmann, whom he later wed.\n\nMarianne Koch is in a relationship with the publicist Peter Hamm since the mid 1980s.\n\nDescription above from the Wikipedia article Marianne Koch, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Munich, Germany	Marianne Koch
14276	1933-04-09	1994-12-06	From Wikipedia, the free encyclopedia.\n\nGian Maria Volonté (9 April 1933 – 6 December 1994) was an Italian actor. He is perhaps most famous outside of Italy for his roles as the main villain in Sergio Leone's A Fistful of Dollars (credited in the USA as "Johnny Wels") and For a Few Dollars More.\n\nDescription above from the Wikipedia article Gian Maria Volonté, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Milan, Italy	Gian Maria Volonté
16310	1905-10-19	1983-07-10	From Wikipedia, the free encyclopedia.\n\nWolfgang Lukschy (born 19 October 1905 - 10 July 1983 in Berlin) was a German actor and dubber. He performed in theater, film and television.\n\nHe made over 75 film and TV appearances between 1940 and 1979. Possibly his most noted performances worldwide were his roles as Alfred Jodl in the 1962 American war film The Longest Day and as John Baxter in Sergio Leone's 1964 production A Fistful of Dollars alongside Clint Eastwood and Gian Maria Volonté.\n\nDescription above from the Wikipedia article Wolfgang Lukschy, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Berlin, Germany	Wolfgang Lukschy
16311	1916-03-03	1980-05-16	José Calvo (March 3, 1916 – May 16, 1980) was a Spanish film actor best known for his roles in western films or historical dramas.\n\nHe made around 150 appearances mostly in films between 1952 and his death in 1980. He entered film in 1952 and was prolific as an actor throughout the 1950s and 1960s. He made many appearances in crime dramas, often with a historical theme and appeared in a high number of western films.\n\nIn 1964 he starred as the innkeeper Silvanito in Sergio Leone's Spaghetti Western production A Fistful of Dollars as one of Clint Eastwood's few "amigos" in the town of San Miguel. He later appeared in westerns such as I Giorni dell'ira (1967) opposite Lee Van Cleef, Anda muchacho, spara! (1971) and Dust in the Sun (1973) etc.\n\nHowever, after the Spaghetti western era of the late 1960s, in the 1970s he returned to appearing in primarily Spanish films and in contrast to the roles which dominated much of his career did appear in several Spanish comedy films often with slapstick humor as that genre grew popular in Latin cinema during this period.\n\nHe died in Gran Canaria on May 16, 1980 aged 64.\n\nDescription above from the Wikipedia article José Calvo, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Madrid, Spain	José Calvo
16312	1931-06-14	2015-07-20		2		Sieghardt Rupp
16313	1926-05-26	2011-07-14		0		Antonio Prieto
16314	1931-02-14	\N		0		Margarita Lozano
16316	1935-05-12	2009-09-28		0	Cartagena, Murcia, Spain	Daniel Martín
6524	\N	\N		0		Gervasio Iglesias
5576	1959-12-31	\N	Val Edward Kilmer (born December 31, 1959) is an American actor. Originally a stage actor, Kilmer became popular in the mid-1980s after a string of appearances in comedy films, starting with Top Secret! (1984), then the cult classic Real Genius (1985), as well as blockbuster action films, including a role in Top Gun and a lead role in Willow.\n\nDuring the 1990s, Kilmer gained critical respect after a series of films that were also commercially successful, including his roles as Jim Morrison in The Doors, Doc Holliday in 1993's Tombstone, Batman in 1995's Batman Forever, Chris Shiherlis in 1995's Heat and Simon Templar in 1997's The Saint. During the early 2000s, Kilmer appeared in several well-received roles, including The Salton Sea, Spartan, and supporting performances in Kiss Kiss Bang Bang, Alexander, and as the voice of KITT in Knight Rider.\n\nDescription above from the Wikipedia article Val Kilmer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles - California - USA	Val Kilmer
2176	1946-09-15	\N	Tommy Lee Jones (born September 15, 1946) is an American actor and film director.\n\nHe has received three Academy Award nominations, winning one as Best Supporting Actor for the 1993 thriller film The Fugitive. His notable film roles include federal marshal Samuel Gerard in The Fugitive and its sequel U.S. Marshals, the villain "Two-Face" in Batman Forever, terrorist William Strannix in Under Siege, Agent K in the Men in Black films, former Texas Ranger Woodrow F. Call in Lonesome Dove, Ed Tom Bell in No Country for Old Men, a Texas Ranger in Man of the House and rancher Pete Perkins in The Three Burials of Melquiades Estrada. Jones has also portrayed real-life figures such as businessman Howard Hughes, executed murderer Gary Gilmore, Oliver Lynn in Coal Miner's Daughter and baseball great Ty Cobb.\n\nDescription above from the Wikipedia article Tommy Lee Jones, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Saba, Texas, USA	Tommy Lee Jones
2227	1967-06-20	\N	Nicole Mary Kidman, AC (born 20 June 1967) is an American-born Australian actress, fashion model, singer and humanitarian.\n\nAfter starring in a number of small Australian films and TV shows, Kidman's breakthrough was in the 1989 thriller Dead Calm. Her performances in films such as To Die For (1995) and Moulin Rouge! (2001) received critical acclaim, and her performance in The Hours (2002) brought her the Academy Award for Best Actress, a BAFTA Award and a Golden Globe Award. Her other films include To Die For (1995), The Portrait of a Lady (1996), Eyes Wide Shut (1999), The Others (2001), Cold Mountain (2003), Birth (2004), The Interpreter (2005), Stoker (2013) and Paddington (2014).\n\nKidman has been a Goodwill Ambassador for UNICEF Australia since 1994. In 2003, Kidman received her star on the Walk of Fame. In 2006, Kidman was made a Companion of the Order of Australia, Australia's highest civilian honour, and was also the highest-paid actress in the motion picture industry.\n\nShe is also known for her marriage to Tom Cruise, to whom she was married for 11 years and adopted two children, and her current marriage to country musician Keith Urban, with whom she has two biological daughters.\n\nAs a result of being born to Australian parents in Hawaii, Kidman has dual citizenship in Australia and the United States.	1	Honolulu, Hawaii, U.S	Nicole Kidman
5577	1970-06-26	\N	Chris O' Donnell was born on June 26th, 1970. He is the youngest child \n\nin his family with four sisters and two brothers. He first started \n\nmodeling at the age of thirteen and continued until the age of sixteen, \n\nwhen he appeared in commercials. When he was seventeen, he was preparing\n\n to stop acting and modeling, but was asked to audition for what would \n\nbe his first film, Men Don't Leave\n\n (1990). He didn't want to go to the audition, but his mother bribed him\n\n by saying she would buy him a new car if he went and he duly got the \n\nrole.\n\nEver since that moment in his life, Chris has appeared in some major motion pictures including Fried Green Tomatoes (1991), Scent of a Woman (1992), Mad Love (1995) and Vertical Limit (2000). He played a part in Kinsey (2004), which appeared in theaters in the year 2004.\n\nChris\n\n took time off from acting to spend time with his wife, Caroline, son, \n\nChris Jr., and his daughter Lilly. He also spent two months in New York \n\nperforming in Arthur Miller's "The Man Who Had All the Luck".	0	Winnetka, Illinois, U.S.	Chris O'Donnell
3796	1916-11-23	2011-03-17	From Wikipedia, the free encyclopedia Michael Gough (23 November 1916 – 17 March 2011) was an English character actor who appeared in over 150 films. He is perhaps best known to international audiences for his roles in the Hammer Horror films from 1958, and for his recurring role as Alfred Pennyworth in all four movies of the Burton/Schumacher Batman franchise, beginning with Batman (1989). Description above from the Wikipedia article Michael Gough, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Kuala Lumpur, Malaya	Michael Gough
3798	1924-07-19	2009-01-03	​From Wikipedia, the free encyclopedia.  \n\nMartin Patterson "Pat" Hingle (July 19, 1924 – January 3, 2009) was an American actor.Hingle was traditionally known for playing judges, police officers, and other authority figures. He was a guest star on the early NBC legal drama Justice, based on case histories of the Legal Aid Society of New York.\n\nDescription above from the Wikipedia article Pat Hingle, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Miami, Florida, USA	Pat Hingle
69597	1975-02-22	\N	Drew Blyth Barrymore (born February 22, 1975) is an American film actress, producer, and director. She is a member of the Barrymore family of American actors and granddaughter of John Barrymore. She first appeared in an advertisement when she was 11 months old. Barrymore made her film debut in Altered States in 1980. Afterwards, she starred in her breakout role in E.T. the Extra-Terrestrial. She quickly became one of Hollywood's most recognized child actors, going on to establish herself in mainly comic roles. Following a turbulent childhood which was marked by drug and alcohol abuse and two stints in rehab, Barrymore wrote the 1990 autobiography, Little Girl Lost. She successfully made the transition from child star to adult actress with a number of films including Poison Ivy, Bad Girls, Boys on the Side, and Everyone Says I Love You. Subsequently, she established herself in romantic comedies such as The Wedding Singer and Lucky You. In 1995, she and business partner Nancy Juvonen formed the production company Flower Films, with its first production the 1999 Barrymore film Never Been Kissed. Flower Films has gone on to produce the Barrymore vehicle films Charlie's Angels, 50 First Dates, and Music and Lyrics, as well as the cult film Donnie Darko. Barrymore's more recent projects include He's Just Not That into You, Beverly Hills Chihuahua, Everybody's Fine and Going the Distance. A recipient of a star on the Hollywood Walk of Fame, Barrymore appeared on the cover of the 2007 People magazine's 100 Most Beautiful issue. Barrymore was named Ambassador Against Hunger for the United Nations World Food Programme (WFP). Since then, she has donated over $1 million to the program. In 2007, she became both CoverGirl's newest model and spokeswoman for the cosmetic and the face for Gucci's newest jewelry line. In 2010, she was awarded the Screen Actors Guild Award and the Golden Globe Award for Best Actress in a Miniseries or Television Film for her portrayal of Little Edie in Grey Gardens. Description above from the Wikipedia article Drew Barrymore , licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Culver City, California, USA	Drew Barrymore
5578	1964-08-13	\N	​From Wikipedia, the free encyclopedia.\n\nDeborah "Debi" Mazar (born August 13, 1964) is an American actress, perhaps best known for her trademark Jersey Girl-type appearances, and as edgy, sharp-tongued women in independent films and her recurring role on the HBO series Entourage as Shauna Roberts.	1	Queens, New York, USA	Debi Mazar
5579	\N	\N		0		Elizabeth Sanders
9807	1940-06-01	\N	From Wikipedia, the free encyclopedia\n\nRené Murat Auberjonois (born June 1, 1940) is an American actor, known for portraying Father Mulcahy in the movie version of M*A*S*H and for creating a number of characters in long-running television series, including Clayton Endicott III on Benson (for which he was nominated for an Emmy Award), Odo on Star Trek: Deep Space Nine, and attorney Paul Lewiston on Boston Legal.\n\nDescription above from the Wikipedia article René Auberjonois (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Rene Auberjonois
4887	1944-06-14	\N	From Wikipedia, the free encyclopedia.\n\nJoseph G. "Joe" Grifasi (born June 14, 1944) is an American character actor of film, stage and television. Grifasi was born in Buffalo, New York, the son of Patricia (née Gaglione) and Joseph J. Grifasi, a skilled laborer. Grifasi graduated from Bishop Fallon High School, a now defunct Catholic high school in Buffalo. He played football and acted in many of the school's plays. Grifasi briefly attended Canisius College in Buffalo before joining the United States Army. He went on to study at the Yale School of Drama. While at the Yale School of Drama, he met his future wife, the jazz soprano saxophonist Jane Ira Bloom. Grifasi has played two separate members of the Baseball Hall of Fame who played for the New York Yankees. In 61, set in 1961, he played Phil Rizzuto; in The Bronx Is Burning, set in 1977, he played Yogi Berra. Paul Borghese played Berra in 61, while actual 1977 broadcast recordings of Rizzuto were used in The Bronx Is Burning.	0	Buffalo - New York - USA	Joe Grifasi
1235	\N	\N		0		Philip Moon
25336	\N	\N	From Wikipedia, the free encyclopedia.\n\nBob Zmuda (born December 12, 1949) is an American writer, comedian, producer and director best known as the sidekick, co-writer and friend of cult personality Andy Kaufman.\n\nBob Zmuda occasionally portrayed Kaufman's Tony Clifton character on stage and for television appearances. In a 2006 interview, Zmuda told the Opie and Anthony Show that it was him as Tony Clifton with David Letterman, and that Letterman did not find out until years after.\n\nIn 1986, Zmuda founded the American version of Comic Relief, an annual event that raises money to help the homeless in the United States. The event was televised on HBO, and was hosted by comedians Robin Williams, Billy Crystal and Whoopi Goldberg.\n\nIn 1999, Zmuda wrote a book about Kaufman's life, entitled Andy Kaufman Revealed!, which purported to unveil many tricks and hoaxes that the two pulled off in front of audiences and television cameras in the 1980s. One critic praised the book as "the ultimate insider's look at Kaufman's life," while some of Kaufman's fans and members of Kaufman's family criticized it for inaccuracies about Kaufman.\n\nLater that year, Miloš Forman directed Man on the Moon, the story of Kaufman's life. Zmuda created the "Tony Clifton" makeup for the film, and made a brief appearance portraying comedian Jack Burns, one of the producers, who gets into a brawl on stage during one of Kaufman's appearances on the 1980-82 ABC Fridays. Zmuda was also Man on the Moon's co-executive producer. On camera, the character of Bob Zmuda was played by Paul Giamatti. Stanley Kaufman, Andy's father, criticized Zmuda's influence on the film shortly after its release, writing in the form of Andy speaking from beyond the grave.\n\nDescription above from the Wikipedia article Bob Zmuda, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Bob Zmuda
5572	1939-08-28	\N	From Wikipedia, the free encyclopedia\n\nJoel T. Schumacher (born August 29, 1939) is an American film director, screenwriter and producer.\n\nDescription above from the Wikipedia article Joel Schumacher, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	New York City - New York - USA	Joel Schumacher
5573	1950-11-22	\N		0	USA	Lee Batchler
5574	1956-02-05	\N		0	USA	Janet Scott Batchler
3794	1915-10-24	1998-11-03	Bob Kane (born Robert Kahn; October 24, 1915 – November 3, 1998) was an American comic book artist and writer, credited as the creator of the DC Comics superhero Batman. He was inducted into both the comic book industry's Jack Kirby Hall of Fame in 1994 and the Will Eisner Comic Book Hall of Fame in 1996.\n\nDescription above from the Wikipedia article Bob Kane, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	New York City, New York, USA	Bob Kane
5575	1962-07-07	\N	Akiva J. Goldsman (born July 7, 1962) is an American screenwriter and producer in the motion picture industry. He received an Academy Award for Best Adapted Screenplay for the 2001 film, A Beautiful Mind, which also won the Oscar for Best Picture.\n\nGoldsman has been involved specifically with Hollywood films. His filmography includes the films A Beautiful Mind, I am Legend and Cinderella Man, as well as more serious dramas, and numerous rewrites both credited and uncredited. In 2006 Goldsman re-teamed with A Beautiful Mind director Ron Howard for a high profile project, adapting Dan Brown's novel The Da Vinci Code for Howard's much-anticipated film version, receiving mixed reviews for his work. Goldsman currently directs and writes many episodes of the JJ Abrams produced science fiction drama Fringe.\n\nDescription above from the Wikipedia article Akiva Goldsman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City - New York - USA	Akiva Goldsman
510	1958-08-25	\N	Timothy Walter "Tim" Burton (born August 25, 1958) is an American film director, film producer, writer and artist. He is famous for dark, quirky-themed movies such as Beetlejuice, Edward Scissorhands, The Nightmare Before Christmas, Sleepy Hollow, Corpse Bride and Sweeney Todd: The Demon Barber of Fleet Street, and for blockbusters such as Pee-wee's Big Adventure, Batman, Batman Returns, Planet of the Apes, Charlie and the Chocolate Factory and Alice in Wonderland, his most recent film, that was the second highest-grossing film of 2010 as well as the sixth highest-grossing film of all time. Among Burton's many collaborators are Johnny Depp, who became a close friend since their film together, musician Danny Elfman (who has composed for all but five of the films Burton has directed and/or produced) and domestic partner Helena Bonham Carter. He also wrote and illustrated the poetry book The Melancholy Death of Oyster Boy &amp; Other Stories, published in 1997, and a compilation of his drawings, entitled The Art of Tim Burton, was released in 2009. Burton has directed 14 films as of 2010, and has produced 10 as of 2009. His next films are a film adaptation of soap opera Dark Shadows, which is slated to begin production in January 2011 and a remake of his short Frankenweenie, which will be released on October 5, 2012. Description above from the Wikipedia article Tim Burton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Burbank, California, USA	Tim Burton
5580	\N	\N		0		Peter Macgregor-Scott
5581	1954-05-02	\N	Elliot Goldenthal (born May 2, 1954) is an American composer of contemporary classical music. He was a student of Aaron Copland and John Corigliano, and is best known for his distinctive style and ability to blend various musical styles and techniques in original and inventive ways. He is also a film-music composer, and won the Academy Award for Best Original Score in 2002 for his score to the motion picture Frida, directed by his long-time partner Julie Taymor.	2	Brooklyn, NY	Elliot Goldenthal
5582	\N	\N		0		Stephen Goldblatt
5583	\N	\N		0		Mark Stevens
5584	\N	\N		0		Dennis Virkler
1262	1938-03-08	2007-11-28	Mali Finn (March 8, 1938 – November 28, 2007), born Mary Alice Mann, was an American casting director and former English and drama teacher. She cast numerous actors in successful films, including Edward Furlong, Leonardo DiCaprio, and Russell Crowe.	0	Danville, Illinois	Mali Finn
5585	\N	\N		0		Barbara Ling
406204	\N	\N	Ve Neill (born Mary Flores) is an American makeup artist. She has won three Academy Awards, for the films Beetlejuice, Mrs. Doubtfire and Ed Wood. She has been nominated for eight Oscars total.[1]  Neill serves as a judge on the 2011 Syfy original series Face Off which features makeup artists competing for $100,000.[2]  Ve Neill has worked on all of the films of the Pirates of the Caribbean franchise. Other notable films she has worked on are Austin Powers in Goldmember, A.I. Artificial Intelligence, Hook, and Edward Scissorhands.	0		Ve Neill
1115051	\N	\N		0		Mitchell E. Dauterive
5918	1980-02-17	\N	From Wikipedia, the free encyclopedia.\n\nZachary Bennett (born February 17, 1980) is a Canadian actor and musician in Toronto, Ontario, who is best known for playing Felix King in Road to Avonlea. He also co-starred in the 2006 TV film Jekyll + Hyde.\n\nHe was born in London, Ontario. He is the second youngest of four children, and his siblings are fellow actors Garreth Bennett, Mairon Bennett, and Sophie Bennett.\n\nZachary Bennett formed the indie rock band Yonder in 2004, which was renamed Tin Star Orphans in 2008.\n\nDescription above from the Wikipedia article Zachary Bennett, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	London, Ontario, Canada	Zachary Bennett
5919	1970-07-14	\N	From Wikipedia, the free encyclopedia.\n\nStephanie Moore (born July 14, 1970) is a Canadian actress. She is best known for her roles on P2 as Lorraine (voice) and in the films Cube Zero, Angel Eyes and John Q.\n\nDescription above from the Wikipedia article Stephanie Moore, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Ottawa, Ontario, Canada	Stephanie Moore
5920	1962-02-04	\N	From Wikipedia, the free encyclopedia.\n\nMichael Riley (born February 4, 1962 in London, Ontario) is a Canadian actor and graduate of the National Theatre School in Montreal, Canada in 1984. Riley's first appearance was in the film No Man's Land (1987). He has acted in over 40 films and television series, including This Is Wonderland, for which he received a Gemini Award, and the Emmy-nominated BBC / Discovery Channel co-production Supervolcano. He also portrays a leading character on the 2009 CBC Television series Being Erica.\n\nHe has voiced the animated title character of Ace Lightning.\n\nDescription above from the Wikipedia article Michael Riley, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	London, Ontario	Michael Riley
5921	1962-07-15	\N	From Wikipedia, the free encyclopedia.\n\nMartin Jamie Roach is a Canadian actor. He is perhaps best known for his roles on Aaron Stone as T. Abner Hall and in the films Cube Zero, Diary of the Dead, and The Lookout.\n\nDescription above from the Wikipedia article Martin Roach, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	 Toronto, Ontario, Canada 	Martin Roach
5922	\N	\N		0		David Huband
5923	\N	\N		0		Mike 'Nug' Nahrgang
5924	\N	\N		0		Richard McMillan
5925	1965-12-04	\N	​From Wikipedia, the free encyclopedia.  \n\nJoshua Peace also known as Josh Peace is a Canadian actor. He is best known for his roles on Devil as Detective Markowitz and in the films Cube Zero, You Might as Well Live and Survival of the Dead.\n\nDescription above from the Wikipedia article Joshua Peace,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Calgary - Alberta - Canada	Joshua Peace
5926	\N	\N		0		Terri Hawkes
5927	1965-12-04	\N	Tony Munch is an actor.	0	Calgary - Alberta - Canada	Tony Munch
142193	\N	\N		2		Diego Klattenhoff
5917	1947-01-29	\N	From Wikipedia, the free encyclopedia\n\nErnie Barbarash is a movie producer, perhaps best known as co-producer of the films American Psycho, Cube 2: Hypercube, Prisoner of Love, The First 9½ Weeks and The Cat's Meow. Barbarash also wrote and directed Cube Zero and Stir of Echoes: The Dead Speak. He also directed the Canadian horror/thriller They Wait.\n\nDescription above from the Wikipedia article Ernie Barbarash, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Baltimore, Maryland, USA	Ernie Barbarash
5928	\N	\N		0		Suzanne Colvin
5929	\N	\N		0		Jon P. Goulding
5930	\N	\N		0		Norman Orenstein
5931	\N	\N		0		François Dagenais
5932	\N	\N		0		Mitch Lackie
5933	\N	\N		0		Mark Sanders
5934	\N	\N		0		Danis Goulet
933333	\N	\N		0		John Buchan
957026	\N	\N		0		Donna Wong
1415136	\N	\N		0		George Aywaz
1415173	\N	\N		0		Daisy Lee Bijac
1415174	\N	\N		0		A. Scott Hamilton
1415175	\N	\N		0		Randy Kumano
1415176	\N	\N		0		Man Lan Chan
1407243	\N	\N		0		Ian Patrick McAllister
170353	1982-02-05	\N		0		Brian Jones
1415177	\N	\N		0		Emir Geljo
1415178	\N	\N		0		Matthew Brewster
1415181	\N	\N		0		David Fuller
1375604	\N	\N		0		Janice Ierulli
6250	1938-09-23	1982-05-29	​From Wikipedia, the free encyclopedia.  Romy Schneider (23 September 1938 – 29 May 1982) was an Austrian-born German film actress who also held French citizenship.  Description above from the Wikipedia article Romy Schneider, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Vienna, Austria	Romy Schneider
6251	1928-03-16	2014-05-29	Karlheinz Böhm  (born 16 March 1928 in Darmstadt, Germany) is an Austrian actor. The son of conductor Karl Böhm, he is best known internationally for his role as Mark, the psychopathic protagonist of Peeping Tom, directed by Michael Powell. Before that, he had played the young Emperor Franz Joseph I of Austria in the three Sissi movies. He made three notable U.S. films in 1962. He played Jakob Grimm in the 1962 MGM-Cinerama spectacular The Wonderful World of the Brothers Grimm and Ludwig van Beethoven in the Walt Disney film The Magnificent Rebel. (The latter film was made especially for the Disney anthology television series, but was released theatrically in Europe.) He appeared in a villainous role as the Nazi-sympathizing son of Paul Lukas in the MGM film Four Horsemen of the Apocalypse, a Technicolor, widescreen remake of the 1921 silent Rudolph Valentino film. Between 1974 and 1975, Böhm appeared prominently in four consecutive films from prolific New German Cinema director Rainer Werner Fassbinder: Martha, Effi Briest, Faustrecht der Freiheit (aka Fistfight of Freedom or Fox and His Friends), and Mutter Küsters' Fahrt zum Himmel (Mother Küsters' Trip to Heaven). In 2009 he provided the German voice for Charles Muntz, villain in Pixar's tenth animated feature Up. Since 1981, when he founded Menschen für Menschen ("Humans for Humans"), Böhm has been actively involved in charitable work in Ethiopia, for which in 2007 he was awarded the Balzan Prize for Humanity, Peace and Brotherhood among Peoples. Karlheinz Böhm has been married to Almaz Böhm, a native of Ethiopia, since 1991. They have two children, Nicolas (born 1990) and Aida (born 1993). Böhm has five more children from previous marriages, among them, the actress Katharina Böhm (born 1964). In 2011 Almaz and Karlheinz Böhm were awarded the Essl Social Prize for the project Menschen für Menschen\n\nDescription above from the Wikipedia article Karlheinz Böhm, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Darmstadt, Germany	Karlheinz Böhm
6252	1909-05-17	1996-07-30	Magda Schneider ou Magdalena Schneider, de son vrai nom Maria Magdalena Schneider (Augsbourg, 17 mai 1909 – Berchtesgaden, 30 juillet 1996), était une comédienne et chanteuseallemande, mère de l'actrice Romy Schneider.	0	Augsbourg	Magda Schneider
6254	1901-07-07	1987-02-01		0		Gustav Knuth
6253	1935-09-19	2012-08-17		0		Uta Franz
6809	1922-09-04	1999-09-06		2	Hall in Tirol, Austria	Walter Reyer
6255	1911-11-17	1992-05-03		0		Vilma Degischer
6256	1913-04-21	1996-02-18		0	wien	Josef Meinrad
6810	1924-05-10	\N		0		Senta Wengraf
6257	1906-02-20	1976-08-26		0		Erich Nikowitz
6811	\N	\N		0		Hans Ziegler
6815	\N	\N		0		Sonia Sorel
6816	1935-08-26	2012-04-26		2	Hamburg, Germany	Klaus Knuth
1291313	1936-03-15	\N		1	Zürich, Switzerland	Chariklia Baxevanos
6241	1893-02-02	1963-05-12		0		Ernst Marischka
6242	\N	\N		0		Karl Ehrlich
6243	\N	\N		0		Anton Profes
6244	\N	\N		0		Bruno Mondi
6245	\N	\N		0		Alfred Srp
6813	\N	\N		0		Fritz Jüptner-Jonstorff
6247	\N	\N		0		Leo Bei
6248	\N	\N		0		Gerdago
6093	1947-02-20	\N		2	Berlin - Germany	Henry Hübchen
6263	1942-07-26	\N		1	Burghausen, Germany	Hannelore Elsner
6264	1953-06-25	\N		0		Udo Samel
6265	1949-08-02	\N		0		Golda Tencer
6523	\N	\N	Juan José Ballesta debuta en la pequeña pantalla, en 1997, con sólo 8 años en la serie ‘Querido maestro’, protagonizada por Imanol Arias. Dos años después se une al reparto de la ficciónn televisiva ‘Compañeros’. Pero será en el año 2000 cuando empieza a ser popular entre el público tras conseguir el papel protagonista en el drama de Achero Mañas ‘El bola’, por el que se alza con el Goya al mejor actor revelación. En 2003, interpreta a un niño enfermo de cáncer que saca fuerzas para seguir adelante en ‘Planta 4ª’, de Antonio Mercero. Después de un tiempo alejado del cine, regresa en 2005 con ‘7 vírgenes’, por la que gana al Conchad de Plata al mejor actor. En 2010, el actor protagoniza el drama histórico ‘Bruc. El desafío’, y regresa a la pequeña pantalla para unirse al reparto de la ficciónn histórica ‘Hispania’, donde da vida a Paulo.	0		Juan José Ballesta
6534	\N	\N		0		Jesús Carroza
6535	1960-02-16	\N		0	Seville, Andalucía, Spain	Antonio Dechent
6536	1950-08-01	\N		0		Loles León
6537	\N	\N		0		Muriel
6538	\N	\N		0		Iride Barroso
6539	\N	\N		0		Alba Rodríguez
6540	\N	\N		0		Vicente Romero
6521	\N	\N		0		Alberto Rodríguez
6522	\N	\N		0		Rafael Cobos
6487	1942-07-09	\N	​From Wikipedia, the free encyclopedia.  \n\nRichard Roundtree (born July 9, 1942) is an American actor and former fashion model. He is best known for his portrayal of private detective John Shaft in the 1971 film Shaft and in its two sequels, Shaft's Big Score (1972) and Shaft in Africa (1973).\n\nDescription above from the Wikipedia article Richard Roundtree, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New Rochelle, New York, USA	Richard Roundtree
6561	1929-10-02	1993-12-16	From Wikipedia, the free encyclopedia.\n\nMoses Gunn (October 2, 1929 – December 17, 1993) was an American actor. An Obie Award-winning stage player, he co-founded the Negro Ensemble Company in the 1960s. His 1962 Broadway debut was in Jean Genet's The Blacks. He was nominated for a 1976 Tony Award as Best Actor (Play) for The Poison Tree and played Othello on Broadway in 1970.\n\nDescription above from the Wikipedia article Moses Gunn, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	St. Louis, Missouri, U.S.	Moses Gunn
6354	1935-10-31	\N	From Wikipedia, the free encyclopedia.\n\nCharles Cioffi (born 31 October 1935), also credited as Charles M. Cioffi, is an American television actor.\n\nDescription above from the Wikipedia article Charles Cioffi, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	New York City, New York, USA	Charles Cioffi
6562	1966-07-15	\N	From Wikipedia, the free encyclopedia.\n\nChristopher St. John (sometimes credited at Chris St. John) is an African-American film and television actor. He is also a film producer, film director and screenwriter. He also played a minor role in Remington Steele.\n\nDescription above from the Wikipedia article Christopher St. John, licensed under CC-BY-SA, full list of contributors on Wikipedia	0		Christopher St. John
6563	\N	\N		0		Gwenn Mitchell
6564	1939-07-10	\N		2		Lawrence Pressman
6565	1936-07-01	\N		0		Victor Arnold
6566	\N	\N		0		Sherri Brewer
6885	1975-08-08	\N	Charlize Theron (born 7 August 1975) is a South African actress, film producer and former fashion model.\n\nShe rose to fame in the late 1990s following roles in the films The Devil's Advocate (1997), Mighty Joe Young (1998), and The Cider House Rules (1999). Theron received critical acclaim for her portrayal of serial killer Aileen Wuornos in Monster (2003), for which she won the Silver Bear, Golden Globe Award, Screen Actors Guild Award, and Academy Award for Best Actress among several other accolades, becoming the first South African to win an Academy Award in a major acting category. In recent years, she has moved into the field of producing, both in television and film.\n\nShe received further Academy Award and Golden Globe Award nominations for her performance in North Country in 2005, and a Golden Globe Award nomination for her performance in Young Adult in 2011. In 2012, she appeared in Snow White &amp; the Huntsman and Prometheus, both of which were box office successes. Theron became a U.S. citizen in 2007, while retaining her South African citizenship.\n\nTheron was born in Benoni, in the then-Transvaal Province of South Africa, the only child of Gerda (née Maritz) and Charles Theron (born 27 November 1947). Second Boer War figure Danie Theron was her great-great-uncle. Her ancestry includes French, German, and Dutch; her French forebears were early Huguenot settlers in South Africa. "Theron" is an Occitan surname (originally spelled Théron) pronounced in Afrikaans as [tɜːron], although she has said that the way she pronounces it in South Africa is [θron]. She changed the pronunciation when she moved to the U.S. to give it a more "American" sound.\n\nShe grew up on her parents' farm in Benoni, near Johannesburg. On 21 June 1991, Theron's father, an alcoholic, physically attacked her mother and threatened both her mother and her while drunk; Theron's mother then shot and killed him. The shooting was legally adjudged to have been self-defense and her mother faced no charges.\n\nTheron attended Putfontein Primary School (Laerskool Putfontein), a period she later characterised as not "fitting in". At 13, Theron was sent to boarding school and began her studies at the National School of the Arts in Johannesburg. Although Theron is fluent in English, her first language is Afrikaans.	1	Benoni, Gauteng, South Africa	Charlize Theron
6886	1980-02-12	\N	Christina Ricci (born February 12, 1980) is an American actress. Ricci received initial recognition and praise as a child star for her performance as Wednesday Addams in The Addams Family (1991) and Addams Family Values (1993), and her role as Kat Harvey in Casper (1995). Ricci made a transition into more adult-oriented roles with The Ice Storm (1997), followed by an acclaimed performance in The Opposite of Sex (1998), for which she received a Golden Globe nomination for Best Actress. She continued her success with well-received performances in Sleepy Hollow (1999) and Monster (2003). Ricci has appeared in the films Black Snake Moan (2007), Penelope (2008), Speed Racer (2008), New York, I Love You (2009) and After.Life (2009) opposite Liam Neeson.	1	Santa Monica, California, USA	Christina Ricci
6905	1936-06-04	\N	From Wikipedia, the free encyclopedia\n\nBruce MacLeish Dern (born June 4, 1936) is an American film actor. He also appeared as a guest star in numerous television shows. He frequently takes roles as a character actor, often playing unstable and villainous characters. Dern appeared in more than 80 feature films and made for TV movies.   Description above from the Wikipedia article Bruce Dern, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Chicago, Illinois, USA	Bruce Dern
6906	1965-07-08	\N		2	Ivoryton - Connecticut - USA	Lee Tergesen
6907	\N	\N	From Wikipedia, the free encyclopedia. Annie Corley is an American actress who has appeared in a wide variety of films and television shows since 1990. Her most notable role to date was playing Meryl Streep's daughter in the film The Bridges of Madison County.\n\nA graduate of DePauw University in Indiana, she first appeared in Malcolm X. Since then, she has been featured in several other Oscar-nominated films, such as The Cider House Rules, Seabiscuit, 21 Grams, and Monster. She co-starred in The Lucky Ones and 2009's Crazy Heart. She also played Judge Burch in Law Abiding Citizen.\n\nAmong her television appearances, she has guest starred on The Closer, NYPD Blue, as the mother of Zachary Quinto on Touched by an Angel, conservative Christian pundit Mary Marsh on The West Wing, Without a Trace, Murder, She Wrote, CSI: Crime Scene Investigation and The Practice. Description above from the Wikipedia article Annie Corley, licensed under CC-BY-SA, full list of contributors on Wikipedia.  	1		Annie Corley
6908	1957-10-13	\N		0		Marc Macaulay
6909	\N	\N		0		Stephan Jones
6910	\N	\N		0		T. Robert Pigott
95749	\N	\N		0		Catherine Mangan
6884	1971-07-24	\N	Patricia Lea "Patty" Jenkins is an American film director and screenwriter. She is best known for directing Monster (2003).\n\nDescription above from the Wikipedia Patty Jenkins licensed under CC-BY-SA, full list of contributors on Wikipedia.	1		Patty Jenkins
6887	\N	\N		2		Brad Wyman
6888	\N	\N		0		Clark Peterson
6889	\N	\N		0		Donald Kushner
6891	1949-06-29	\N		2	Munich, Germany	Andreas Grosch
6892	\N	\N		0		Stewart Hall
6893	\N	\N		0		Sammy Lee
6894	\N	\N		0		Meagan Riley-Grant
6895	\N	\N		2		Andreas Schmid
6896	1963-02-04	\N		0	Los Angeles	Brent Morris
6897	\N	\N		0		David Alvarado
6898	1970-10-04	\N		2		BT
6899	\N	\N		0		Steven Bernstein
800	\N	\N		2		Arthur Coburn
6900	\N	\N		0		Jane Kurson
2045	\N	\N		0		Ferne Cassel
6901	1890-06-29	1973-04-17		0		Edward T. McAvoy
6902	\N	\N		0		Orvis Rigsby
6890	1933-04-22	\N	From Wikipedia, the free encyclopedia\n\nMark Damon (born Alan Harris on April 22, 1933, in Chicago, Illinois) is an American film actor and producer. He started his career in his native country, appearing in such films as Young and Dangerous (1957) and Roger Corman's House of Usher. In an attempt to boost his career, he relocated to Italy, where he starred in several spaghetti westerns and B-movies, playing either the hero or the antagonist. He eventually gave up acting in the mid-1970s to become a film producer.\n\nDescription above from the Wikipedia article Mark Damon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chicago, Illinois	Mark Damon
113844	\N	\N		0		Howard Paar
1534687	\N	\N		0		Brian Bulman
7152	\N	\N	From Wikipedia, the free encyclopedia\n\nSandra Hüller, (born in 1978 in Suhl, Germany) studied theater from 1996-2000 at the Hochschule Für Schauspielkunst "Ernst Busch", Berlin. She appeared from 1999-2001 at the Jena Theater, Thuringia and then for one year at the Schauspielhaus Leipzig. It was Oliver Held who finally recommended her to the Theatre Basel, Switzerland where, (as of 2006), she still appears. She currently lives in Basel.\n\nShe is best known for her role as Michaela Klingler in Hans-Christian Schmid's German-language film, Requiem.\n\nDescription above from the Wikipedia article Sandra Hüller, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Suhl, Germany	Sandra Hüller
7153	1957-02-08	\N		1	Berlin, Germany	Imogen Kogge
7154	\N	\N		0		Friederike Adolph
7155	1978-08-17	\N		0		Anna Blomeier
7156	1980-09-24	\N		2	Kempen, Germany	Nicholas Reinke
7157	1933-04-28	2013-09-28		0		Walter Schmidinger
7158	1972-03-14	\N		2		Jens Harzer
7159	1946-06-24	\N		2	Babenhausen, Germany	Johann Adam Oest
7160	\N	\N		0		Irene Kugler
7161	1972-04-26	\N		1	Waiblingen, Baden-Württemberg, Germany	Eva Löbau
6094	1965-08-19	\N	Hans-Christian Schmid (1965, Altötting) is a German film director and screenwriter.\n\nDescription above from the Wikipedia article Hans-Christian Schmid, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Altötting, Germany	Hans-Christian Schmid
7149	\N	\N		0		Bernd Lange
6096	\N	\N		0		Bogumil Godfrejow
5195	\N	\N		0		Hansjörg Weißbrich
7150	\N	\N		0		Bernd Schlegel
7151	\N	\N		0		Marc Parisotto
6097	\N	\N		0		Christian M. Goldbeck
4557	\N	\N		0		Ulrike Putz
7212	\N	\N		0		Bettina Marx
4430	1958-03-10	\N	Sharon Yvonne Stone (born March 10, 1958) is an American actress, film producer, and former fashion model. She achieved international recognition for her role in the erotic thriller Basic Instinct. She was nominated for an Academy Award for Best Actress and won a Golden Globe Award for Best Actress in a Motion Picture Drama for her performance in Casino.\n\nDescription above from the Wikipedia article Sharon Stone, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Meadville, Pennsylvania, USA	Sharon Stone
7167	1926-05-08	\N	From Wikipedia, the free encyclopedia.  Donald Jay "Don" Rickles (born May 8, 1926) is an American stand-up comedian and actor. A frequent guest on The Tonight Show Starring Johnny Carson, Rickles has acted in comedic and dramatic roles, but is best known as an insult comic. However, unlike many insult comics who only find short-lived success, Rickles has enjoyed a sustained career, thanks to a distinct sense of humor, a very sharp wit and impeccable timing.\n\nIt is well known that Rickles has nothing against the people that he insults during his routine, and that it's all just part of the act. Although sarcastically nicknamed "Mr. Warmth" due to his offensive and insensitive stage personality, in reality most know him to be actually quite genial and pleasant. It has been said that being insulted by Rickles is like "wearing a badge of honor".  Description above from the Wikipedia article Don Rickles, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Queens, New York, U.S.	Don Rickles
7169	1927-12-26	2004-05-09		0		Alan King
7166	1957-10-30	\N	Kevin Elliot Pollak (born October 30, 1957) is an American actor, impressionist, game show host, and comedian. He started performing stand-up comedy at the age of 10 and touring professionally at the age of 20. In 1988, Pollak landed a role in George Lucas’ Willow, directed by Ron Howard, and began his acting career.	2	San Francisco, California, USA	Kevin Pollak
7165	1921-08-19	2000-10-24		0		Pasquale Cajano
193	1930-01-30	\N	Eugene Allen "Gene" Hackman (born January 30, 1930) is a retired American actor and novelist.\n\nNominated for five Academy Awards, winning two, Hackman has also won three Golden Globes and two BAFTAs in a career that spanned four decades. He first came to fame in 1967 with his performance as Buck Barrow in Bonnie and Clyde. His major subsequent films include I Never Sang for My Father (1970); his role as Jimmy "Popeye" Doyle in The French Connection (1971) and its sequel French Connection II (1975); The Poseidon Adventure (1972); The Conversation (1974); A Bridge Too Far (1977); his role as arch-villain Lex Luthor in Superman (1978), Superman II (1980), and Superman IV: The Quest for Peace (1987); Under Fire (1983); Twice in a Lifetime (1985); Hoosiers (1986); No Way Out (1987); Mississippi Burning (1987); Unforgiven (1992); Wyatt Earp (1994); The Quick and the Dead, Crimson Tide and Get Shorty (all 1995); Enemy of the State (1998); The Royal Tenenbaums (2001); and his final film role before retirement, in Welcome to Mooseport (2004).\n\nDescription above from the Wikipedia article Gene Hackman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Bernardino - California - USA	Gene Hackman
7502	1917-01-24	2012-07-08	Ernest Borgnine was born Ermes Effron Borgnino on January 24, 1917 in Hamden, Connecticut. His parents were Charles who had emigrated from Ottiglio (AL), Italy and Anna who had emigrated from Carpi (MO), Italy. As an only child, Ernest enjoyed most sports, especially boxing, but took no real interest in acting. At age 18, after graduating from high school in New Haven, and undecided about his future career, he joined the United States Navy, where he stayed for ten years until leaving in 1945. After a few factory jobs, his mother suggested that his forceful personality could make him suitable for a career in acting, and Borgnine promptly enrolled at the Randall School of Drama in Hartford. After completing the course, he joined Robert Porterfield's famous Barter Theatre in Abingdon, Virginia, staying there for four years, undertaking odd jobs and playing every type of role imaginable. His big break came in 1949, when he made his acting debut on Broadway playing a male nurse in "Harvey".\n\nIn 1951, Borgnine moved to Los Angeles to pursue a movie career, and made his film debut as Bill Street in The Whistle at Eaton Falls (1951). His career took off in 1953 when he was cast in the role of Sergeant "Fatso" Judson in From Here to Eternity (1953). This memorable performance led to numerous supporting roles as "heavies" in a steady string of dramas and westerns. He played against type in 1955 by securing the lead role of Marty Piletti, a shy and sensitive butcher, in Marty (1955). He won an Academy Award for Best Actor for his performance, despite strong competition from Spencer Tracy, Frank Sinatra, James Dean and James Cagney. Throughout the 1950s, 1960s and 1970s, Borgnine performed memorably in such films as The Catered Affair (1956), Ice Station Zebra (1968) and Emperor of the North (1973). Between 1962 and 1966, he played Lt. Commander Quinton McHale in the popular television series McHale's Navy (1962). In early 1984, he returned to television as Dominic Santini in the action series Airwolf (1984) co-starring Jan-Michael Vincent, and in 1995, he was cast in the comedy series The Single Guy (1995) as doorman Manny Cordoba. He also appeared in several made-for-TV movies.\n\nErnest Borgnine passed away aged 95 on July 8, 2012, at Cedars-Sinai Medical Center in Los Angeles, California, of renal failure. He is survived by his wife Tova, their children and his younger sister Evelyn.	2	Hamden, Connecticut, USA	Ernest Borgnine
7503	1919-02-05	2006-07-13	From Wikipedia, the free encyclopedia\n\nRed Buttons (February 5, 1919 – July 13, 2006) was an Academy Award-winning American comedian and actor.\n\nDescription above from the Wikipedia article Red Buttons, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Red Buttons
7504	1942-02-13	\N	From Wikipedia, the free encyclopedia\n\nCarol Lynley (born February 13, 1942) is an American actress and former child model.\n\nDescription above from the Wikipedia article Carol Lynley, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	New York City, New York, USA	Carol Lynley
7505	1928-09-17	1998-10-03	From Wikipedia, the free encyclopedia.  Roderick Andrew Anthony Jude "Roddy" McDowall (17 September 1928 – 3 October 1998) was an English-born actor and photographer. His film roles include Cornelius and Caesar in the Planet of the Apes film series.\n\nDescription above from the Wikipedia article Roddy McDowall, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Studio City, California, USA	Roddy McDowall
9112	1920-08-13	1992-04-16	From Wikipedia, the free encyclopedia.  \n\nNeville Brand (August 13, 1920 - April 16, 1992) was an American television and movie actor.\n\nDescription above from the Wikipedia article Neville Brand  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Griswold, Iowa, United States	Neville Brand
7631	1936-10-01	\N	From Wikipedia, the free encyclopedia\n\nStella Stevens (born October 1, 1936 as Estelle Caro Eggleston) is an American film, television and stage actress, who began her acting career in 1959. She is a film producer, director and pin-up girl.\n\nDescription above from the Wikipedia article Stella Stevens, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Yazoo City, Mississippi, USA	Stella Stevens
7632	1920-08-18	2006-01-14	Shelley Winters (August 18, 1920 – January 14, 2006) was an American actress who appeared in dozens of films, as well as on stage and television; her career spanned over 50 years until her death in 2006. A two-time Academy Award winner, Winters is probably most remembered for her roles in A Place in the Sun, The Big Knife, Lolita, The Night of the Hunter, Alfie, and The Poseidon Adventure.\n\nDescription above from the Wikipedia article Shelley Winters licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	St. Louis, Missouri, USA	Shelley Winters
3461	1907-06-16	1981-11-25	From Wikipedia, the free encyclopedia.  Jack Albertson (June 16, 1907 – November 25, 1981) was an American character actor dating to vaudeville.  A comedian, dancer, singer, and musician, Albertson is perhaps best known for his roles as Manny Rosen in The Poseidon Adventure (1972), Grandpa Joe in the 1971 version of Willy Wonka and the Chocolate Factory, Amos Slade in the 1981 animated film "The Fox and the Hound" (1981), and as Ed Brown in the 1974-1978 television sitcom Chico and the Man. For contributions to the television industry, Jack Albertson was honored with a star on the Hollywood Walk of Fame at 6253 Hollywood Boulevard.  Description above from the Wikipedia article Jack Albertson, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Malden, Massachusetts, U.S.	Jack Albertson
7633	1926-02-11	2010-11-28	From Wikipedia, the free encyclopedia.\n\nLeslie William Nielsen, OC (11 February 1926 – 28 November 2010) was a Canadian and naturalized American actor and comedian. Nielsen appeared in over one hundred films and 1,500 television programs over the span of his career, portraying over 220 characters. Born in Regina, Saskatchewan, Nielsen enlisted in the Royal Canadian Air Force and worked as a disc jockey before receiving a scholarship to Neighborhood Playhouse. Making his television debut in 1948, he quickly expanded to over 50 television appearances two years later. Nielsen made his film debut in 1956, and began collecting roles in dramas, westerns, and romance films. Nielsen's performances in the films Forbidden Planet (1956) and The Poseidon Adventure (1972) received positive reviews as a serious actor, though he is primarily known for his comedic roles.\n\nAlthough Nielsen's acting career crossed a variety of genres in both television and films, his deadpan delivery in Airplane! (1980) marked a turning point in his career, one that would make him, in the words of film critic Roger Ebert, "the Olivier of spoofs." Nielsen enjoyed further success with The Naked Gun film series (1988 – 1994), based on a short-lived television series Police Squad! in which he starred earlier. His portrayal of serious characters seemingly oblivious to (and complicit in) their absurd surroundings gave him a reputation as a comedian. In the final years of his career, Nielsen appeared in multiple spoof and parody films, many of which were met poorly by critics, but performed well in box office and home media releases. Nielsen married four times and had two daughters from his second marriage. He was recognized with a variety of awards throughout his career, and was inducted into the Canada and Hollywood Walks of Fame.\n\nDescription above from the Wikipedia article Leslie Nielsen, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Regina, Saskatchewan, Canada	Leslie Nielsen
7634	1953-01-05	\N	Pamela Sue Martin (born January 5, 1953) is an American actress best known for playing Nancy Drew on The Hardy Boys/Nancy Drew MysteriesTV series and Fallon Carrington Colby on the ABC nighttime soap opera Dynasty.\n\n Born in Hartford, Connecticut, and growing up in nearby Westport, Martin began modeling at 17, and appeared in the original film version of The Poseidon Adventure (opposite Gene Hackman) at the age of 19. During the run of Nancy Drew she appeared in a cover-featured pictorial in the July 1978 issue of Playboy magazine, which caused her to be axed from the series.  Martin portrayed feisty and spoiled heiress Fallon Carrington Colby on the ABC nighttime soap opera Dynasty from its debut in 1981 through the end of the fourth season in 1984. Martin left of her own accord and the character was "missing and presumed dead" – the series recast the role with actress Emma Samms at the end of the fifth season in 1985. She hosted Saturday Night Live on February 16, 1985.  In 1984, Martin, who has long been involved in environmental causes, appeared in a public service announcement to help save pink dolphins in the Amazon River. The ad was directed by Clyde Lucas, who appeared on The Hardy Boys/Nancy Drew Mysteries.  Divorced three times and the mother of one son, Martin has written about her struggle with interstitial cystitis. Martin owns a theatre company in Idaho.	0	Hartford - Connecticut - USA	Pamela Sue Martin
7635	1960-02-14	\N	Eric Shea (born February 14, 1960), is an American actor. A professionalchild actor, active from age six through seventeen, he is best known for his roles in the blockbuster feature films Yours, Mine and Ours (1968) and The Poseidon Adventure (1972), as well as his numerous guest-starring appearances throughout the 1960s and 1970s on such popular television series as Batman, Gunsmoke, The Flying Nun, Nanny and the Professor,The Brady Bunch, and Little House on the Prairie, among others.  Shea's brothers Christopher and Stephen both voiced Linus van Pelt for the Peanuts TV animation specials in the 1960s and 1970s, respectively.	0	Los Angeles County - California - USA	Eric Shea
7636	1926-10-21	1994-05-06	Fred Sadoff (October 21, 1926 — May 6, 1994) was an American film, stage and television actor.  Frederick Edward Sadoff was born in Brooklyn, New York to Henry and Bertha Sadoff; his only brother was born five years earlier. He got his start as an actor on Broadway in the late 1940s, appearing in South Pacific in the role of 'Professor'. A life member of The Actors Studio, Salmi also appeared in Camino Real and Wish You Were Here. In 1956, he became personal assistant to Michael Redgrave who starred in and directed a production of The Sleeping Prince.  Sadoff moved to London to form a production company with Redgrave under the name F.E.S. Plays, Ltd. which presented works including The Importance of Being Oscar which had a short run on Broadway in 1961. While in England, he also worked as a director for the BBC and Rediffusion.  Eventually returning to the United States, he found success as an actor in The Poseidon Adventure in 1972 when he was cast as Linarcos, the company representative who ordered Captain Harrison (Leslie Nielsen) full ahead. He also acted in other films, including Papillon (1973), Cinderella Liberty (1973) and The Terminal Man (1974). He also acted in several soap operas, including Ryan's Hope, All My Children and Days of our Lives. On television, he appeared in guess roles on such series as Quincy, M.E., The Streets of San Francisco, The Rockford Files, Barney Miller and Buck Rogers in the 25th Century.  Fred Sadoff died of AIDS on May 6, 1994 in his home in Los Angeles, California at age 67.	0	Brooklyn - New York - USA	Fred Sadoff
1407179	\N	\N		0		Roseann Williams
857	1908-03-29	1981-05-18	Arthur O'Connell (March 29, 1908 – May 18, 1981) was an American stage and film actor. He appeared in films (starting with a small role in Citizen Kane) in 1941 and television programs (mostly guest appearances). Among his screen appearances were Picnic, Anatomy of a Murder, and as the watch-maker who hides Jews during WWII in The Hiding Place.\n\nA veteran vaudevillian, O'Connell, from New York City, made his legitimate stage debut in the mid 1930s, at which time he fell within the orbit of Orson Welles' Mercury Theatre. Welles cast O'Connell in the tiny role of a reporter in the closing scenes of Citizen Kane (1941), a film often referred to as O'Connell's film debut, though in fact he had already appeared in Freshman Year (1939) and had costarred in two Leon Errol short subjects as Leon's conniving brother-in-law.\n\nAfter numerous small movie parts, O'Connell returned to Broadway, where he appeared as the erstwhile middle-aged swain of a spinsterish schoolteacher in Picnic - a role he'd recreate in the 1956 film version, earning an Oscar nomination in the process. Later the jaded looking O'Connell was frequently cast as fortyish losers and alcoholics; in the latter capacity he appeared as James Stewart's boozy attorney mentor in Anatomy of a Murder (1959), and the result was another Oscar nomination. In 1962 O'Connell portrayed the father of Elvis Presley's character in the motion picture Follow That Dream, and in 1964 in the Presley-picture Kissin' Cousins.\n\nO'Connell continued appearing in choice character parts on both TV and films during the 1960s, but avoided a regular television series, holding out until he could be assured top billing. He appeared as Joseph Baylor in the 1964 episode "A Little Anger Is a Good Thing" on the ABC medical drama about psychiatry, Breaking Point. The actor accepted the part of a man who discovers that his 99-year-old father has been frozen in an iceberg on the 1967 sitcom The Second Hundred Years, assuming he'd be billed first per the producers' agreement. Instead, top billing went to newcomer Monte Markham in the dual role of O'Connell's father and his son. O'Connell accepted the demotion to second billing as well as could be expected, but he never again trusted the word of any Hollywood executive.\n\nIll health forced O'Connell to significantly reduce his acting appearances in the mid '70s, but the actor stayed busy as a commercial spokesman, a friendly pharmacist who was a spokesperson for Crest toothpaste. At the time of his death from Alzheimer's disease in California in May 1981, O'Connell was appearing solely in these commercials, by his own choice.\n\nO'Connell was buried in Calvary Cemetery, Queens, New York.\n\nDescription above from the Wikipedia article Arthur O'Connell, licensed under CC-BY-SA, full list of contributors on Wikipedia.    	2	New York City, New York, U.S.	Arthur O'Connell
6865	1929-02-02	2013-11-15	Sheila Mathews Allen (February 2, 1929 – November 15, 2013) was an American actress.\n\nBorn Sheila Marie Mathews in New York City to Christopher Joseph and Elizabeth (née McCloskey) Mathews, she was married to producer Irwin Allen until his death in 1991. She appeared in several of her husband's TV series and movies through to 1986. Appearances include City Beneath the Sea, Lost in Space, Land of the Giants, The Poseidon Adventureand The Towering Inferno. Following his death in 1991 she remained on the board of Irwin Allen Productions up until her death. She also served as a producer on the 2002 television remake of The Time Tunnel and as Executive Producer of the film Poseidon.	0	New York City - New York - USA	Sheila Allen
151536	1913-04-10	1979-05-24	Jan Arvan was born on April 10, 1913 in Wisconsin, USA as Jan Arvanitas. He was an actor.	0	Wisconsin - USA	Jan Arvan
1327	1939-05-25	\N	From Wikipedia, the free encyclopedia.\n\nSir Ian Murray McKellen, CH, CBE (born 25 May 1939) is an English actor. He is the recipient of six Laurence Olivier Awards, a Tony Award, a Golden Globe Award, a Screen Actors Guild Award, a BIF Award, two Saturn Awards, four Drama Desk Awards and two Critics' Choice Awards. He has also received two Academy Award nominations, eight BAFTA film and TV nominations and five Emmy Award nominations. McKellen's work spans genres ranging from Shakespearean and modern theatre to popular fantasy and science fiction. His notable film roles include Gandalf in The Lord of the Rings and The Hobbit trilogies and Magneto in the X-Men films.\n\nMcKellen was appointed Commander of the Order of the British Empire in 1979, was knighted in 1991 for services to the performing arts, and was made a Companion of Honour for services to drama and to equality, in the 2008 New Year Honours.	0	Burnley, England	Ian McKellen
88170	1931-06-14	1991-12-01	Byron Webster made 1951 his film debut in Capitaine sans peur (1951). He moved to the USA in 1952 and settled in Chicago, Illinois. Acting assignments were few in Chicago, and he supplemented his income working for British European Airways. After some local area (Illinois) theatre work, he was cast in the NY company of "The Killing of Sister George," and then in "Funny Girl." Moving to Los Angeles in 1966, he appeared in the film version of "Funny Girl" and others, most notably as The Purser in L'aventure du Poséidon (1972). He toured and co-starred in national companies of "Camelot" and "My Fair Lady". Mr. Webster possessed a beautiful and powerful singing voice that was little used in his film and television appearances. He is perhaps best remembered by television fans as a regular cast member in the TV series Soap (1977). An avid Bridge player, he held Master Points and was often in Bridge tournaments. Always fighting a weight problem, he succumbed to heart failure December 1, 1991, at his home in Sherman Oaks, California.  - IMDb Mini Biography	0	London - England - UK	Byron Webster
15693	1920-09-13	2010-09-21	Burly, handsome and rugged character actor John Crawford appeared in over 200 movies and TV shows combined in a career that spanned over 40 years, usually cast as tough and/or villainous characters.\n\nCrawford was born Cleve Richardson on September 13, 1920, in Colfax, Washington. He was discovered by a Warner Bros. scout while attending the University of Washington's School of Drama. Although he failed his screen test, Crawford nonetheless joined RKO as a laborer. He then got a job building sets at Circle Theater in Los Angeles, and eventually persuaded the producers to cast him in some of their plays. He was soon signed to Columbia Pictures to act in secondary roles in westerns. In the late 1950s he graduated to bigger parts in such films as Ordre de tuer\n\n (1958), La clé (1958) and Un homme pour le bagne (1960), all of which were made in the UK. Crawford returned to America in the early 1960s and began a prolific career in both movies and TV series, up until 1986. His most memorable film roles include the ill-fated chief engineer inL'aventure du Poséidon (1972), the hearty Tom Iverson in La fugue (1975), the bumbling mayor of San Francisco in L'inspecteur ne renonce jamais (1976), hard-nosed police chief Buzz Cavanaugh in Un couple en fuite (1977) and amiable old mine hand Brian Deerling in The Boogens (1981). John had recurring parts as Sheriff Ep Bridges inLa famille des collines (1971) and Capt. Parks on Sergent Anderson (1974). Among the many TV shows he made guest appearances in are The Lone Ranger (1949), Superman(1952), Les espions (1965), La quatrième dimension (1959), Les incorruptibles (1959),La grande caravane (1957), Le fugitif (1963), Star Trek (1966), Perdus dans l'espace(1965), Bonanza (1959), Stalag 13 (1965), Mission impossible (1966), Gunsmoke(1955), Super Jaimie (1976), Dallas (1978) and Dynastie (1981). Crawford died at age 90 following complications from a stroke on September 21, 2010, in Thousand Oaks, California. He's survived by his ex-wife Ann Wakefield, four daughters and two grandchildren.  - IMDb Mini Biography	0	Colfax - Washington - USA	John Crawford
34973	1925-04-18	2014-06-30	Robert "Bob" Francis Hastings (April 18, 1925 – June 30, 2014) was an American radio, film, and television character actor. He also provided voices for animated cartoons. He was best known for his portrayal of annoying suck-up Lt. Elroy Carpenter, on McHale's Navy.\n\n Hastings was born in Brooklyn, New York, a son of Charles and Hazel Hastings, Sr. His father was a salesman. Hastings started in radio on "Coast-to-Coast on a Bus" (NBC). Hastings served during World War II in the United States Army Air Corps. After serving in World War II as a navigator on B-29s, he played the role of Archie Andrews in a series based on the Archie comic book series on the NBC Red Network, later just the NBC Radio Network, after NBC divested itself of its Blue Network in 1942. Archie Andrews was sponsored by Swift &amp; Company food products.  Hastings moved to television in 1949, performing in early science-fiction series, including Atom Squad. His first recurring role was as a lieutenant onPhil Silvers' Sergeant Bilko series in the late 1950s. At that time he guest-starred on Walter Brennan's ABC sitcom The Real McCoys.	0	Brooklyn - New York - USA	Bob Hastings
1401253	\N	\N		0		Erik L. Nelson
151689	1928-01-04	\N		0		Charles Bateman
7501	1911-04-23	2010-06-16	From Wikipedia, the free encyclopedia\n\nRonald Elwin Neame CBE, BSC (23 April 1911 – 16 June 2010) was an English film cinematographer, producer, screenwriter and director.\n\nDescription above from the Wikipedia article Ronald Neame, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England, UK	Ronald Neame
6855	1897-07-26	1976-07-15		0		Paul Gallico
844	1918-07-22	1992-03-28		0		Wendell Mayes
6779	1918-01-16	1996-04-26	From Wikipedia, the free encyclopedia.  Stirling Dale Silliphant (16 January 1918 – 26 April 1996) was an American screenwriter and producer. He was born in Detroit, Michigan, moved to Glendale, California as a child, graduated from Hoover High School, and educated at the University of Southern California. He is probably best known for his screenplay for In the Heat of the Night and co-creating the television series Route 66. Other features as screenwriter include Irwin Allen productions The Towering Inferno and The Poseidon Adventure, adapting both films from previously published novels into one cohesive screenplay each.  Silliphant is also remembered for his now-infamous bet with Hal Warren on whether Warren could make a successful horror film on a limited budget, which was the inspiration for Manos: The Hands of Fate, and he is portrayed in the 2011 documentary / comedy feature film "Hal Warren The Director of Fate" from director Tony Trombo.  He was a close friend of Bruce Lee — under whom he studied martial arts — who was featured in the Silliphant-penned detective movie Marlowe and four episodes of the series Longstreet. Silliphant was involved in the early part of Bruce Lee's movie and TV career in America, and suggested him for action choreography work on productions like A Walk in the Spring Rain, a Silliphant-scripted film.  They had also been writing on a philosophical martial arts script called The Silent Flute (later known as Circle of Iron), with James Coburn. It was to star Lee and Coburn, and the pre-production even went to the extent of all three going to India on a location hunt.  Description above from the Wikipedia article Stirling Silliphant, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Detroit, Michigan	Stirling Silliphant
7506	1916-06-12	1991-11-02	From Wikipedia, the free encyclopedia.  Irwin Allen (June 12, 1916 – November 2, 1991) was a television and film director and producer nicknamed "The Master of Disaster" for his work in the disaster film genre. He was also notable for creating a number of television series.  Description above from the Wikipedia article Irwin Allen,licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	New York, New York, U.S.	Irwin Allen
7507	\N	\N		0		Steve Broidy
7508	\N	\N		0		Sidney Marshall
491	\N	\N		0		John Williams
7509	1903-09-21	1977-11-02		0		Harold E. Stine
7510	1913-06-26	1999-09-18	From Wikipedia, the free encyclopedia\n\nHarold F. Kress (June 26, 1913 – September 18, 1999) was an American film editor with more than fifty feature film credits; he also directed several feature films in the early 1950s. He won the Academy Award for Best Film Editing for How the West Was Won (1962) and again for The Towering Inferno (1974), and was nominated for four additional films; he is among the film editors most recognized by the Academy of Motion Picture Arts &amp; Sciences. He also worked publicly to increase the recognition of editing as a component of Hollywood filmmaking.	2	Pittsburgh, Pennsylvania, USA	Harold F. Kress
7511	\N	\N		0		Jack Baur
7512	1931-07-26	\N		0		William J. Creber
7513	1920-02-07	2011-02-20		0		Raphael Bretton
7705	\N	\N		0		Anaïs Reboux
6162	1971-05-27	\N	Paul Bettany was born into a theatre family. His father, Thane Bettany, is still an actor but his mother, Anne Kettle, has retired from acting. He has an older sister who is a writer and a mother. His maternal grandmother, Olga Gwynne (her maiden and stage name), was a successful actress, while his maternal grandfather, Lesley Kettle, was a musician and promoter. He was brought up in North West London and, after the age of 9, in Hertfordshire (Brookmans Park). Immediately after finishing at Drama Centre, he went into the West End to join the cast of "An Inspector Calls", though when asked to go on tour with this play, he chose to stay in England.	2	Harlesden, London, England, UK 	Paul Bettany
1003	1948-07-30	\N	Jean Reno ( born July 30, 1948) is a French actor. Working in French, English, and Italian, he has appeared not only in numerous successful Hollywood productions such as The Pink Panther, Godzilla, The Da Vinci Code, Mission: Impossible, Ronin and Couples Retreat, but also in European productions such as the French films Les Visiteurs (1993) and Léon (1994) along with the 2005 Italian film The Tiger and the Snow.\n\nDescription above from the Wikipedia article Jean Reno , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Casablanca, Morocco	Jean Reno
7706	1981-10-01	\N	From Wikipedia, the free encyclopedia.\n\nRoxane Mesquida (born 1 October 1981) is a French actress.\n\nBorn in Marseille, Bouches-du-Rhône, France, Mesquida grew up in Le Pradet though, a little town located between Hyères and Toulon in the Var département. She was discovered at the age of 13, while walking on a road in her region, by the director Manuel Pradal who was in the middle of the casting process for his movie Marie Baie des Anges (Mary from the Bay of Angels with Vahina Giocante and Emmanuelle Béart) at the time. She took part in the shooting during the next summer after their encounter.\n\nIn 1998, she played in L'École de la chair by Benoît Jacquot and crossed paths with the controversial director who would make her well-known and, according to Mesquida, who made her learn her craft: Catherine Breillat. First they collaborated in À ma sœur! (Fat Girl), then in Sex Is Comedy, and they worked together again during the spring of 2006 on Une vieille Maîtresse with Asia Argento.\n\nShe wanted to go to Art School (the Beaux-Arts) but finally abandoned the idea to pursue her career in acting. She is still passionate about the Arts and often visits museums. Her favourite painting is The Scream by Norwegian expressionist painter Edvard Munch.\n\nAmong actors of her generation, she admires Romain Duris and Scarlett Johansson but her absolute idol is Romy Schneider and she says she has seen all her movies.\n\nShe says she is fiercely opposed to the idea of ever becoming financially dependent to cinéma and that she'd rather do baby-sitting than accept a role in a commercial movie she would not like.\n\nDescription above from the Wikipedia article Roxane Mesquida, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Marseille, France	Roxane Mesquida
7707	1977-02-24	\N	Libero De Rienzo was born in 1978 in Naples, Campania, Italy. He is an actor and director, known for Fortapàsc (2009), Fat Girl (2001) and Miele (2013).	2		Libero De Rienzo
7708	1958-09-06	\N	From Wikipedia, the free encyclopedia.  Arsinée Khanjian (born 1958 in Beirut, Lebanon Արսինէ Խանճեան) is an Armenian-Canadian actress and producer. In addition to her independent work and stage roles, she is regularly cast by her husband, Canadian filmmaker Atom Egoyan, in his films. She has a bachelor's degree in French and Spanish from Concordia University and a master's degree in political science from the University of Toronto. Her husband, Egoyan, credits her for inspiring him to further explore his Armenian roots. She lives in Toronto with her husband and their son, Arshile.\n\nDescription above from the Wikipedia article Arsinée Khanjian, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Beirut, Lebanon	Arsinée Khanjian
7709	\N	\N		0		Romain Goupil
7710	1927-05-01	2004-07-31		0		Laura Betti
7711	\N	\N		0		Albert Goldberg
6295	1948-07-13	\N	From Wikipedia, the free encyclopedia.\n\nCatherine Breillat (born 13 July 1948 in Bressuire, Deux-Sèvres) is a French filmmaker, novelist and Professor of Auteur Cinema at the European Graduate School.\n\nDescription above from the Wikipedia article Catherine Breillat, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Bressuire, Deux-Sèvres, Poitou-Charentes, France	Catherine Breillat
7695	\N	\N		0		Jean-François Lepetit
7700	\N	\N		0		Conchita Airoldi
7701	\N	\N		0		Pascale Chavance
7702	\N	\N		0		François-Renaud Labarthe
7704	\N	\N		0		Jean Minondo
20572	\N	\N		0		Giorgos Arvanitis
1647226	\N	\N		0		Fabrice Bigot
1647227	\N	\N		0		Gilles Cannatella
16932	\N	\N		0		Olivier Carbone
1476491	\N	\N		0		Nicolas Lublin
7703	\N	\N		2		Michaël Weill
1267834	\N	\N		0		Cécilia Blom
1647229	\N	\N		0		Fabienne David
1647230	\N	\N		0		Christophe Graziani
1647231	\N	\N		0		Fabrice Héraud
1647232	\N	\N		0		Gérald Lemaire
1647233	\N	\N		0		Jean-Luc Molle
552348	\N	\N		0		Yann Richard
7297	\N	\N		0		Ann Dunsford
20597	\N	\N		0		Catherine Meillan
1647235	\N	\N		0		Fredy Lagrost
31	1956-07-09	\N	Thomas Jeffrey "Tom" Hanks (born July 9, 1956) is an American actor, producer, writer and director.\n\nHanks worked in television and family-friendly comedies, gaining wide notice in 1988's Big, before achieving success as a dramatic actor in several notable roles, including Andrew Beckett in Philadelphia, the title role in Forrest Gump, Commander James A. Lovell in Apollo 13, Captain John H. Miller in Saving Private Ryan, Joe Fox in You've Got Mail and Chuck Noland in Cast Away. Hanks won consecutive Best Actor Academy Awards, in 1993 for Philadelphia and in 1994 for Forrest Gump. U.S. domestic box office totals for his films exceed $3.9 billion.	2	Concord - California - USA	Tom Hanks
2405	1976-08-09	\N	From Wikipedia, the free encyclopedia\n\nAudrey Justine Tautou (French pronunciation: [o.dʁɛ to.tu]; born 9 August 1976) is a French actress and model. Signed by an agent at age 17, she made her acting debut at 18 on television and her feature film debut the following year in Venus Beauty Institute (1999), for which she received critical acclaim and won the César Award for Most Promising Actress. Her subsequent roles in the 1990s and 2000s included Le Libertin and Happenstance (2000).\n\nTautou achieved international recognition for her lead role in the 2001 film Amélie, which met with critical acclaim and was a major box-office success. Amélie won Best Film at the European Film Awards, four César Awards (including Best Film and Best Director), two BAFTA Awards (including Best Original Screenplay), and was nominated for five Academy Awards.\n\nTautou has since appeared in films in a range of genres, including the thrillers Dirty Pretty Things and The Da Vinci Code, and the romantic Priceless (2006). She has received critical acclaim for her many roles including the drama A Very Long Engagement (2004) and the biographical drama Coco avant Chanel (2009). She has been nominated three times for the César Award and twice for the BAFTA for Best Actress in a leading role. She became one of the few French actors in history to be invited to join the Academy of Motion Picture Arts and Sciences (AMPAS) in June 2004.\n\nTautou has modeled for Chanel, Montblanc, L'Oréal and many other companies. She is an active supporter of several charities.	1	Beaumont, Puy-de-Dôme, France	Audrey Tautou
658	1953-05-24	\N	Alfred Molina (born 24 May 1953) is a British-American actor. He first came to public attention in the UK for his supporting role in the 1987 film Prick Up Your Ears. He is well known for his roles in Raiders of the Lost Ark, The Man Who Knew Too Little, Spider-Man 2, Maverick, Species, Not Without My Daughter, Chocolat, Frida, Steamboy, The Hoax, Prince of Persia: The Sands of Time, The Da Vinci Code, Little Traitor, An Education and The Sorcerer's Apprentice. He is currently starring as Detective Ricardo Morales on the NBC police/courtroom drama Law &amp; Order: LA.\n\nDescription above from the Wikipedia article Alfred Molina, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Alfred Molina
920	1941-06-10	\N	Jürgen Prochnow is a German actor. His most well-known roles internationally have been as the sympathetic submarine captain in Das Boot (1981), Duke Leto Atreides I in Dune (1984), the minor, but important role of Kazakh dictator General Ivan Radek in Air Force One and the antagonist Maxwell Dent in Beverly Hills Cop II.\n\nProchnow was born in Berlin and brought up in Düsseldorf, the son of an engineer. He has an elder brother, Dieter. He studied acting at the Folkwang Hochschule in Essen. Thanks to his on-screen intensity and his fluency in English, he has become one of the most successful German actors in Hollywood. He portrayed Arnold Schwarzenegger in a film about the actor's political career in California, entitled See Arnold Run; coincidentally, Prochnow was one of the actors considered for the title role in The Terminator. He also appears as the main antagonist in the Broken Lizard film Beerfest, which contains a submarine scene that references his role in Das Boot. He also played a supporting character in the Wing Commander film, Cmdr. Paul Gerald. In addition, he dubbed Sylvester Stallone's voice in the German version of Rocky and Rocky II.\n\nHe was facially scarred following a stunt accident during the filming of Dune. One scene called for Prochnow (as Duke Leto) to be strapped to a black stretcher and drugged. During one take, a high-powered bulb positioned above Prochnow exploded due to heat, raining down molten glass. Remarkably, the actor was able to free himself from the stretcher, moments before glass fused itself to the place he had been strapped. During the filming of the dream sequence, he had a special apparatus attached to his face so that green smoke (simulating poison gas) would emerge from his cheek when the Baron (Kenneth McMillan) scratched it. Although thoroughly tested, the smoke gave Prochnow first and second-degree burns on his cheek. This sequence appears on film in the released version.\n\nIn 1996, he was a member of the jury at the 46th Berlin International Film Festival.\n\nProchnow was married in the 1970s, and had a daughter Johanna, who died in 1987. He married Isabel Goslar in 1982, with whom he has two children: a daughter Mona, and son Roman. They divorced in 1997. He currently divides his time between Los Angeles and Munich. He was involved with Birgit Stein, a German screenwriter and actress. He received American citizenship in 2003.	2	Berlin, Germany	Jürgen Prochnow
34259	1958-08-27	\N		2	Saint-Omer, France	Jean-Yves Berteloot
20795	1932-04-12	\N	​From Wikipedia, the free encyclopedia\n\nJean-Pierre Marielle (born April 12, 1932) is a French actor. He has played in more than a hundred movies in which he brought life to a very large diversity of roles, from the banal citizen (Les Galettes de Pont-Aven), to the serial killer (Sans mobile apparent), to the World War II hero (Les Milles), to the compromised spy (La Valise), to the has-been actor (Les Grands Ducs), acting always with the same excellence whatever the quality of the movie in itself. He is well known for his outspokenness and especially for his warm and cavernous voice which is often imitated by French humorists considering him as the archetype of the French gentleman.\n\nDescription above from the Wikipedia article Jean-Pierre Marielle, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dijon, France	Jean-Pierre Marielle
38885	\N	\N		0		Marie-Françoise Audollent
28186	1946-11-14	\N		0	Paris, France	Agathe Natanson
38886	\N	\N		0		Tina Maskell
38887	\N	\N		0		Peter Pedrero
38888	1981-10-03	\N		0		Seth Gabel
150792	1949-05-05	\N		2	Fécamp, Seine-Maritime, France	Etienne Chicot
129014	1972-02-29	\N	Brièvement joueur de football professionnel, il entame des études en informatique, tout en devenant mannequin pour l'agence parisienne Metropolitan. Devenu assistant du réalisateur Moncef Dhouib, il entre à la Birmingham School of Speech and Drama.\n\nDès 2002, il se lance dans une carrière d'acteur au Royaume-Uni. Il joue dans des séries britanniques comme Dream Team diffusée sur Sky , Spooks sur la BBC et The Bill sur ITV. Au cinéma, il joue le rôle dans le téléfilm controversé The Mark of Cain. Engagé pour jouer un rôle dans le film Da Vinci Code, il est toutefois coupé au montage.\n\nGrâce à son rôle de Dali, dans le feuilleton tunisien Maktoub, il devient une idole pour les femmes tunisiennes, une première pour une personnalité du pays. Diverses marques le choisissent alors pour promouvoir leurs produits, comme la limonade Boga.\n\nInstallé à Londres, il parle couramment l'arabe, le français et l'anglais et possède quelques connaissances en italien et espagnol.	0	tunis, Tunisie	Dhaffer L'Abidine
1278517	\N	\N		2		Mark Roper
6159	1954-03-01	\N	Ronald William "Ron" Howard (born March 1, 1954) is an American actor, director and producer.\n\nHe came to prominence as a child actor, playing Opie Taylor in the sitcom The Andy Griffith Show for eight years, and later as the teenaged Richie Cunningham in the sitcom Happy Days for six years. He made film appearances such as in American Graffiti in 1973 and while starring in Happy Days he also made The Shootist in 1976, as well as making his directorial debut with the 1977 comedy film Grand Theft Auto. He left Happy Days in 1980 to focus on directing, and has since gone on to direct several films, including the Oscar winning Cocoon, Apollo 13, Frost/Nixon, A Beautiful Mind and How the Grinch Stole Christmas. In 2003, he was awarded the National Medal of Arts.	2	Duncan, Oklahoma, USA	Ron Howard
8406	1930-07-08	2011-09-13	John Nicholas Calley (July 8, 1930 – September 13, 2011) was an American film studio executive and producer. He was quite influential during his years at Warner Bros. (where he worked from 1968 to 1981) and "produced a film a month, on average, including commercial successes like The Exorcist and Superman." During his seven years at Sony Pictures Entertainment starting in 1996, five of which he was chairman and chief executive, he was credited with "reinvigorat[ing]" that major film studio.	0	Jersey City - New Jersey - USA	John Calley
8404	1964-06-22	\N	​From Wikipedia, the free encyclopedia.\n\nDan Brown  (born June 22, 1964) is an American author of thriller fiction, best known for the 2003 bestselling novel, The Da Vinci Code. Brown's novels, which are treasure hunts set in a 24-hour time period, feature the recurring themes of cryptography, keys, symbols, codes, and conspiracy theories. His books have been translated into over 40 languages, and as of 2009, sold over 80 million copies. Two of them, The Da Vinci Code and Angels &amp; Demons, have been adapted into feature films. The former opened amid great controversy and poor reviews, while the latter did only slightly better with critics. Brown's novels that feature the lead character Robert Langdon also include historical themes and Christianity as recurring motifs, and as a result, have generated controversy. Brown states on his website that his books are not anti-Christian, though he is on a 'constant spiritual journey' himself, and says that his book The Da Vinci Code is simply "an entertaining story that promotes spiritual discussion and debate" and suggests that the book may be used "as a positive catalyst for introspection and exploration of our faith."\n\nDescription above from the Wikipedia article Dan Brown, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Exeter, New Hampshire, USA	Dan Brown
339	1951-07-12	\N	Academy Award®-winning producer Brian Grazer has been making movies and television programs for more than 25 years. As both a writer and producer, he has been personally nominated for four Academy Awards®, and in 2002 he won the Best Picture Oscar® for A Beautiful Mind. In addition to winning three other Academy Awards®, A Beautiful Mind also won four Golden Globe Awards (including Best Motion Picture Drama) and earned Grazer the first annual Awareness Award from the National Mental Health Awareness Campaign.	0	Los Angeles, California, U.S	Brian Grazer
6184	1952-08-29	\N	Todd Hallowell is an assistant director and producer, known for A Beautiful Mind (2001), X-Men: Days of Future Past (2014) and Apollo 13 (1995).	2	Cambridge, Minnesota	Todd Hallowell
6186	\N	\N		0		Kathleen McGill
6188	\N	\N		0		Louisa Velis
947	1957-09-12	\N	Hans Florian Zimmer born September 12th, 1957) is a German composer and record producer. Since the 1980s, he has composed music for over 150 films. His works include The Lion King, for which he won Academy Award for Best Original Score in 1994, the Pirates of the Caribbean series, The Thin Red Line, Gladiator, The Last Samurai, The Dark Knight Trilogy, Inception, and Interstellar. Zimmer spent the early part of his career in the United Kingdom before moving to the United States. He is the head of the film music division at DreamWorks studios and works with other composers through the company that he founded, Remote Control Productions.[1] Zimmer's works are notable for integrating electronic music sounds with traditional orchestral arrangements. He has received fourGrammy Awards, three Classical BRIT Awards, two Golden Globes, and an Academy Award. He was also named on the list of Top 100 Living Geniuses, published by The Daily Telegraph.[2]	2	Frankfurt am Main, Hesse, Germany	Hans Zimmer
8408	\N	\N	Salvatore Totino is an American cinematographer. He was invited to join AMPAS in 2006, and has been a member of the American Society of Cinematographers (ASC) since 2007.	0		Salvatore Totino
6189	\N	\N		0		Daniel P. Hanley
6190	\N	\N		0		Mike Hill
2874	\N	\N		1		Janet Hirshenson
1325	\N	\N		0		John Hubbard
7732	\N	\N		0		Allan Cameron
7787	\N	\N		0		Giles Masters
8783	1968-08-09	\N	Eric Bana is an Australian film and television actor. He began his career as a comedian in the sketch comedy series Full Frontal before gaining critical recognition in the biopic Chopper (2000). After a decade of roles in Australian TV shows and films, Bana gained Hollywood's attention by playing the role of American Delta Force Sergeant Norm "Hoot" Hooten in Black Hawk Down (2001), the lead role as Bruce Banner in the Ang Lee directed film Hulk (2003), Prince Hector in the movie Troy (2004), the lead in Steven Spielberg's Munich (2005), and the villain Nero in the science-fiction film Star Trek (2009).\n\nAn accomplished dramatic actor and comedian, he received Australia's highest film and television awards for his performances in Chopper, Full Frontal and Romulus, My Father. Bana performs predominantly in leading roles in a variety of low-budget and major studio films, ranging from romantic comedies and drama to science fiction and action thrillers.\n\nEric Bana was the younger of two children; he has a brother, Anthony. He is of Croatian ancestry on his father's side. Bana's paternal grandfather, Mate Banadinović, fled to Argentina after the Second World War, and Bana's paternal grandmother emigrated to Germany and then to Australia in the 1950s with her son, Ivan (Bana's father). His father was a logistics manager for Caterpillar, Inc., and his German-born mother, Eleanor, was a hairdresser. Bana grew up in Melbourne's Tullamarine, a suburban area on the western edge of the city, near the main airport. In a cover story for The Mail on Sunday, he told author Antonella Gambotto-Burke that his family had suffered from racist taunts, and that it had distressed him. "Wog is such a terrible word," he said. He has stated: "I have always been proud of my origin, which had a big influence on my upbringing. I have always been in the company of people of European origin".\n\nShowing acting skill early in life, Bana began doing impressions of family members at the age of six or seven, first mimicking his grandfather's walk, voice and mannerisms. In school, he mimicked his teachers as a means to get out of trouble. As a teen, he watched the Mel Gibson film Mad Max (1979), and decided he wanted to become an actor. However, he did not seriously consider a career in the performing arts until 1991 when he was persuaded to try stand-up comedy while working as a barman at Melbourne's Castle Hotel. His stand-up gigs in inner-city pubs did not provide him with enough income to support himself, so he continued his work as a barman and bussing tables.	2	Melbourne, Australia	Eric Bana
8784	1968-03-02	\N	Daniel Wroughton Craig is an English actor, best known for playing British secret agent James Bond since 2006. Craig is an alumnus of the National Youth Theatre and graduated from the Guildhall School of Music and Drama in London and began his career on stage. His early on screen appearances were in the films Elizabeth, The Power of One and A Kid in King Arthur's Court, and on Sharpe's Eagle and Zorro in television. His appearances in the British films Love Is the Devil, The Trench and Some Voices attracted the industry's attention, leading to roles in bigger productions such as Lara Croft: Tomb Raider, Road to Perdition, Layer Cake and Munich.	2	Chester, Cheshire, England, UK	Daniel Craig
8785	1953-02-09	\N	Ciaran Hinds was born in Belfast, Northern Ireland on February 9, 1953. He was one of five children and the only son. His father was a doctor who hoped to have Ciaran follow in his footsteps, but that was not to be. It was his mother Moya, an amateur actress, who was the real influence behind his decision to become an actor. Though he did enroll in Law at Queens' University of Belfast, he left that in order to train in acting at RADA. He began his stage career at the Glasgow Citizens' Theatre as a pantomime horse in the production of "Cinderella". Staying with the company for several years, he starred in a number of productions, including playing the lead roles in "Arsenic and Old Lace" and "Faust". His stage career has included working with The Field Day Company and a number of world tours. He has starred in a number of productions with the Royal Shakespeare Company, including a world tour in the title role of "Richard III". Hinds' film career began in 1981 in the movie Excalibur (1981), which boasted a cast rich in talented actors including Liam Neeson, Gabriel Byrne and Patrick Stewart. In-between his movie work, he's amassed a large number of television credits. Playing such classic characters as "Mr. Rochester" in Jane Eyre (1997) (TV), and "Captain Wentworth" in Persuasion (1995) has increased his popularity and most definitely given him much increased recognition. As for his personal life, you won't be likely to see his name in the weekly tabloids. He likes to keep his private life private. It is known that he is in a long-term, committed relationship with a French-Vietnamese actress named Hélène Patarot and they have a daughter together and live in Paris. He is in very high demand and his reputation as a quality, professional actor is sure to keep him busy for as long as he chooses. IMDb Mini Biography By: Sheryl Reeder	2	Belfast, Northern Ireland, UK	Ciarán Hinds
8786	1969-06-28	\N	Ayelet Zurer ( born 28 June 1969) is an Israeli actress, perhaps best known for her roles in Nina’s Tragedies, Adam Resurrected, Munich, and Angels &amp; Demons.\n\nZurer, who has appeared in many Israeli films and television series, is one of the most acclaimed Israeli actresses of her day. She was nominated for awards at the Jerusalem Film Festival, the Israeli Academy Awards and the Israeli Television Academy Awards. She won Best Actress awards for her roles in the Israeli film Nina’s Tragedies and Betipul, an Israeli drama series which was adapted into the award winning HBO series, In Treatment. Aside from Betipul, her past television roles include Israeli series Inyan Shel Zman, Florentin, Zinzana, Hadar Milhama and others.\n\nDescription above from the Wikipedia article Ayelet Zurer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	 Tel Aviv, Israel	Ayelet Zurer
118	1951-07-06	\N	​From Wikipedia, the free encyclopedia.  \n\nGeoffrey Roy Rush (born 6 July 1951) is an Australian actor and film producer. As of November 2009, he was one of 25 people to have won the "Triple Crown of Acting": an Academy Award, a Tony Award and an Emmy Award. Apart from being nominated for 4 Academy Awards for acting (winning 1) and 5 BAFTA Awards (winning 3), he has also won 2 Golden Globe and 3 Screen Actors Guild Awards.\n\nDescription above from the Wikipedia article Geoffrey Rush, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Toowoomba, Queensland, Australia	Geoffrey Rush
8787	1939-07-22	\N		0		Gila Almagor
8789	1965-10-25	\N	​From Wikipedia, the free encyclopedia.  \n\nMathieu Amalric (born 25 October 1965) is a French actor and film director, perhaps best known internationally for his performance in The Diving Bell and the Butterfly, for which he drew critical acclaim. He also has won the Étoile d'or and the Lumière Award.\n\nDescription above from the Wikipedia article Mathieu Amalric, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Neuilly-sur-Seine, Hauts-de-Seine, France	Mathieu Amalric
677	1971-08-13	\N	Moritz Bleibtreu (born August 13, 1971) is a German actor. Bleibtreu was born in Munich, the son of actors Monica Bleibtreu and Hans Brenner, and the great-grand-nephew of the actress Hedwig Bleibtreu. Bleibtreu grew up in Hamburg. His first appearance on TV was in the late seventies on a children's television series called Neues aus Uhlenbusch, written by his mother Monica and Rainer Boldt. This was followed by a role in Boldt's Ich hatte einen Traum and alongside his mother in the miniseries Mit meinen heißen Tränen. After he left school when he was 16, he lived in Paris and New York City where he attended acting school. In 1992 he began his acting career at the Schauspielhaus in Hamburg. He also had numerous small parts in television productions. His roles include the Gray Ghost in the film Speed Racer, Andreas Baader in The Baader Meinhof Complex, Manni in Run Lola Run, and Tarek Fahd in the psychological thriller Das Experiment.\n\nDescription above from the Wikipedia article Moritz Bleibtreu, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Munich, Germany	Moritz Bleibtreu
5077	1964-11-16	\N	Valeria Bruni Tedeschi, également orthographié Valeria Bruni-Tedeschi, née à Turin le 16 novembre 1964 (50 ans), est uneactrice italo-française, également scénariste et réalisatrice.	0		Valeria Bruni Tedeschi
8790	1969-01-15	\N		1	Bremen, Germany	Meret Becker
8791	1970-02-23	\N	From Wikipedia, the free encyclopedia.\n\nMarie-Josée Croze ( born February 23, 1970) is a Canadian actress.\n\nDescription above from the Wikipedia article Marie-Josée Croze, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Montreal, Quebec, Canada	Marie-Josée Croze
2245	1965-01-04	\N	​From Wikipedia, the free encyclopedia\n\nYvan Attal (born 4 January 1965) is an Israeli-born French actor and director.\n\nDescription above from the Wikipedia article Yvan Attal, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Tel-Aviv, Israel	Yvan Attal
8792	1933-08-10	\N		0	Kansas City, Kansas, USA	Lynn Cohen
8793	\N	\N		0		Ami Weinberg
9111	1926-03-18	2010-03-14	Peter Graves was born Peter Duesler Aurness on March 18, 1926 on Minneapolis, Minnesota. While growing up in Minnesota, he excelled at sports and music (as a saxophonist), and by age 16, he was a radio announcer at WMIN in Minneapolis. After two years in the United States Air Force, he studied drama at the University of Minnesota and then headed to Hollywood, where he first appeared on television and later made his film debut in Rogue River (1951). Numerous film appearances followed, especially in Westerns. However, Graves is primarily recognized for his television work, particularly as Jim Phelps in Mission: Impossible (1966). Peter Graves died of a heart attack on March 14, 2010, just four days before his 84th birthday.	0	Minneapolis, Minnesota, United States	Peter Graves
2369	1931-05-24	\N	​From Wikipedia, the free encyclopedia.  \n\nMichael Lonsdale (born May 24, 1931), sometimes billed as Michel Lonsdale, is a French actor who has appeared in over 180 films and television shows.\n\nLonsdale was raised by an Irish mother and an English father, initially in London and on Jersey, and later during the Second World War in Casablanca, Morocco. He moved to Paris to study painting in 1947 but was drawn in to the world of acting instead, first appearing on stage at the age of 24.\n\nLonsdale is bilingual and is in demand for English-language and French productions. He is best known in the English-speaking world for his roles as the villainous Sir Hugo Drax in the 1979 James Bond film, Moonraker, the astute French detective Lebel in The Day of the Jackal, and M Dupont d'Ivry in The Remains of the Day.\n\nOn 25 February 2011, he won a Caesar award, his first, as a best supporting actor in Of Gods and Men.\n\nDescription above from the Wikipedia article Michael Lonsdale, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Paris, France	Michael Lonsdale
41316	\N	\N		0	Giv'atayim, Israel	Igal Naor
1031561	\N	\N		0		Lucky Englander
1312252	\N	\N		0		Fritz Fleischhacker
474	\N	\N		0		Jina Jay
488	1946-12-18	\N	Steven Allan Spielberg (born December 18, 1946) is an American film director, screenwriter, producer, and studio entrepreneur.\n\nIn a career of more than four decades, Spielberg's films have covered many themes and genres. Spielberg's early science-fiction and adventure films were seen as archetypes of modern Hollywood blockbuster filmmaking. In later years, his films began addressing issues such as the Holocaust, the Transatlantic slave trade, war, and terrorism. He is considered one of the most popular and influential filmmakers in the history of cinema. He is also one of the co-founders of DreamWorks movie studio.\n\nSpielberg won the Academy Award for Best Director for Schindler's List (1993) and Saving Private Ryan (1998). Three of Spielberg's films—Jaws (1975), E.T. the Extra-Terrestrial (1982), and Jurassic Park (1993)—achieved box office records, each becoming the highest-grossing film made at the time. To date, the unadjusted gross of all Spielberg-directed films exceeds $8.5 billion worldwide. Forbes puts Spielberg's wealth at $3.2 billion.	2	Cincinnati - Ohio - USA	Steven Spielberg
489	1953-06-05	\N		0	Berkeley, California, USA	Kathleen Kennedy
5664	\N	\N		0		Barry Mendel
8780	1956-07-16	\N	Tony Kushner is a Jewish American playwright and screenwriter.  His best known work is the 1993 Pulitzer Prize winning play Angels in America, which was later adapted into an Emmy Winning HBO series of the same name.  	0	 New York City, New York	Tony Kushner
492	1959-06-27	\N		0		Janusz Kaminski
493	\N	\N		0		Michael Kahn
496	\N	\N		0		Rick Carter
8794	\N	\N		0		Tony Fanning
8795	\N	\N		0		Anne Seibel
498	\N	\N		0		Joanna Johnston
8252	1918-04-17	1981-11-16	From Wikipedia, the free encyclopedia William Holden (April 17, 1918 – November 12, 1981) was an American actor. Holden won the Academy Award for Best Actor in 1953 and the Emmy Award for Best Actor in 1974. One of the biggest box office draws of the 1950s, he was named one of the "Top 10 Stars of the Year" six times (1954–1958, 1961) and appeared on the American Film Institute's AFI's 100 Years…100 Stars list as #25.   Description above from the Wikipedia article William Holden, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	O'Fallon, Illinois, USA	William Holden
9108	1920-12-13	1998-12-29	From Wikipedia, the free encyclopedia.\n\nDon Taylor (December 13, 1920 – December 29, 1998) was an American movie actor and director best known for his performances in 1950s classics like Stalag 17 and Father of the Bride and the 1948 film noir The Naked City. He later turned to directing films such as Escape from the Planet of the Apes (1971) and Tom Sawyer (1973).\n\nDescription above from the Wikipedia article Don Taylor (actor/director), licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Freeport, Pennsylvania, USA	Don Taylor
834	1906-12-05	1986-04-23	From Wikipedia, the free encyclopedia.\n\nOtto Ludwig Preminger (5 December 1905 – 23 April 1986) was an Austro–Hungarian-American theatre and film director.\n\nAfter moving from the theatre to Hollywood, he directed over 35 feature films in a five-decade career. He rose to prominence for stylish film noir mysteries such as Laura (1944) and Fallen Angel (1945). In the 1950s and 1960s, he directed a number of high-profile adaptations of popular novels and stage works. Several of these pushed the boundaries of censorship by dealing with topics which were then taboo in Hollywood, such as drug addiction (The Man with the Golden Arm, 1955), rape (Anatomy of a Murder, 1959), and homosexuality (Advise &amp; Consent, 1962). He was twice nominated for the Best Director Academy Award. He also had a few acting roles.\n\nDescription above from the Wikipedia article Otto Preminger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Wiznitz, Bukovina, Austria-Hungary	Otto Preminger
7347	1913-11-08	1975-02-20	From Wikipedia, the free encyclopedia\n\nRobert Strauss (November 8, 1913 – February 20, 1975) was a gravel-voiced American actor.\n\nDescription above from the Wikipedia article Robert Strauss (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	New York City, New York, U.S.	Robert Strauss
9109	1923-04-15	1982-01-05	​From Wikipedia, the free encyclopedia.  \n\nHarvey Lembeck (April 15, 1923 – January 5, 1982) was an American comedic actor best remembered for his role as Cpl. Rocco Barbella on The Phil Silvers Show (a.k.a. Sgt. Bilko) in the late 1950s, and as the stumbling, overconfident outlaw biker Eric Von Zipper in the beach party movie series during the 1960s. He also turned in noteworthy performances in both the stage and screen versions of Stalag 17. He was the father of actor/director Michael Lembeck and actress Helaine Lembeck.\n\nDescription above from the Wikipedia article  Harvey Lembeck, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, USA	Harvey Lembeck
9110	1925-06-01	\N	Richard Erdman (born Richard Erdmann June 1, 1925, in Enid, Oklahoma) is an American film and television actor and director.\n\nIn a career that has spanned seven decades, his best known roles are that of the barracks chief Hoffy in Stalag 17, and McNulty in the classic Twilight Zone episode "A Kind of a Stopwatch". In Tora Tora Tora he played Colonel Edward F. French, the officer who responded to the failure to transmit the warning to Pearl Harbor using Army radio to instead use commercial telegraph rather than using the Navy or FBI radio systems.\n\nErdman appeared as the blackmailer, Arthur Binney, in the Perry Mason first season TV episode "The Case Of The Gilded Lily" aired May 24, 1958. In 1960, he co-starred with Tab Hunter in the short-lived The Tab Hunter Show on NBC, which aired opposite The Ed Sullivan Show on CBS and Lawman with John Russell on ABC. He was very funny when he appeared as a Broadway wardrobe man named Buck Brown on "The Dick Van Dyke Show". In 1962, Erdman had a recurring role as Klugie, the photographer, in the short-lived Nick Adams-John Larkin NBC series Saints and Sinners.	2	Enid - Oklahoma - USA	Richard Erdman
2497	1884-10-11	1967-02-14	From Wikipedia, the free encyclopedia.\n\nSig Ruman (October 11, 1884 – February 14, 1967) was a German-American actor known for his comic portrayals of pompous villains.\n\nDescription above from the Wikipedia article Sig Ruman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hamburg, Germany	Sig Ruman
1511379	1925-05-28	\N		0		Michael Moore
34651	1931-01-11	\N	From Wikipedia, the free encyclopedia.\n\nPeter Baldwin (born January 11, 1931) is an American director, producer, actor, and screenwriter for television.\n\nBaldwin started his career as a contract player at Paramount Studios. He played the character Johnson in Stalag 17. He eventually became a television director with an extensive résumé. As well as directing all of the episode's of ABC's Other hit sitcom The Brady Bunch. He also directed a few episodes of ABC's Hit Sitcom The Partridge Family from 1970 to 1971. He also helped direct a few episodes of Family Ties in 1987. He won an Emmy in 1988 for television series The Wonder Years. He lives with his wife in Pebble Beach, California.\n\nDescription above from the Wikipedia article Peter Baldwin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Winnetka, Illinois, United States	Peter Baldwin
1511381	\N	\N		0		Robinson Stone
1511382	\N	\N		0		Robert Shawley
9113	1926-07-17	2004-08-27		0		William Pierson
9114	1922-06-02	2008-10-11	From Wikipedia, the free encyclopedia.\n\nGil Stratton Jr. (June 2, 1922-October 11, 2008) was an actor and sportscaster who was born in Brooklyn, New York. He most recently resided in Toluca Lake, California until his death from congestive heart failure.\n\nDescription above from the Wikipedia article Gil Stratton Jr., licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Brooklyn, New York City, New York, USA	Gil Stratton
9115	1924-04-24	1987-06-18		0		Jay Lawrence
1195214	1883-02-22	1958-03-26		0		Erwin Kalser
9099	\N	\N		0		Edmund Trzcinski
3146	1906-06-22	2002-03-27	From Wikipedia, the free encyclopedia.  Billy Wilder (22 June 1906 – 27 March 2002) was an Austria/Hungarian-born American filmmaker, screenwriter, producer, artist, and journalist, whose career spanned more than 50 years and 60 films. He is regarded as one of the most brilliant and versatile filmmakers of Hollywood's golden age. Wilder is one of only five people who have won Academy Awards as producer, director, and writer for the same film (The Apartment).\n\nWilder became a screenwriter in the late 1920s while living in Berlin. After the rise of Adolf Hitler, Wilder, who was Jewish, left for Paris, where he made his directorial debut. He relocated to Hollywood in 1933, and in 1939 he had a hit as a co-writer of the screenplay to the screwball comedy Ninotchka. Wilder established his directorial reputation after helming Double Indemnity (1944), a film noir he co-wrote with mystery novelist Raymond Chandler. Wilder earned the Best Director and Best Screenplay Academy Awards for the adaptation of a Charles R. Jackson story The Lost Weekend, about alcoholism. In 1950, Wilder co-wrote and directed the critically acclaimed Sunset Boulevard.\n\nFrom the mid-1950s on, Wilder made mostly comedies. Among the classics Wilder created in this period are the farces The Seven Year Itch (1955) and Some Like It Hot (1959), satires such as The Apartment (1960), and the romantic comedy Sabrina (1954). He directed fourteen different actors in Oscar-nominated performances. Wilder was recognized with the AFI Life Achievement Award in 1986. In 1988, Wilder was awarded the Irving G. Thalberg Memorial Award. In 1993, he was awarded the National Medal of Arts. Wilder holds a significant place in the history of Hollywood censorship for expanding the range of acceptable subject matter.\n\nDescription above from the Wikipedia article Billy Wilder, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Sucha, Galicia, Austria-Hungary	Billy Wilder
9098	\N	\N		0		Donald Bevan
9103	1898-04-23	1984-01-06		2	Budapest, Austria-Hungary [now Hungary]	Ernest Laszlo
2655	1909-04-20	1964-11-22	George Tomasini (April 20, 1909 – November 22, 1964) was an American film editor, born in Springfield, Massachusetts who had a decade long collaboration with director Alfred Hitchcock, editing nine of his movies between 1954-1964. Tomasini edited many of Hitchcock's best-known works, such as the horror film classics The Birds (1963) and Psycho (1960), the spy thriller North by Northwest (1959), the director's masterpieces Vertigo (1958) and Rear Window (1954), as well as other memorable films such as the original Cape Fear (1962). On a 2012 listing of the 75 best edited films of all time, compiled by the Motion Picture Editors Guild based on a survey of its members, four films edited by Tomasini for Hitchcock appear. No other editor appeared more than three times on this listing. The listed films were Psycho, Vertigo, Rear Window, and North by Northwest.\n\nGeorge Tomasini was known for his innovative film editing which, together with Hitchcock's stunning techniques, redefined cinematic language. Tomasini's cutting was always stylish and experimental, all the while pursuing the focus of the story and the characters.[citation needed] Hitchcock and Tomasini's editing of Rear Window has been treated at length in Valerie Orpen's monograph, Film Editing: The Art of the Expressive. His dialogue overlapping and use of jump cuts for exclamation points was dynamic and innovative (such as in the scene in The Birds where the car blows up at the gas station and Tippi Hedren's character watches from a window, as well as the infamous "shower scene" in Psycho). George Tomasini's techniques would influence many subsequent film editors and filmmakers.\n\nGeorge Tomasini was nominated for the Academy Award for Film Editing for North by Northwest, but Ben-Hur's editors won the award that year.	2	Springfield, Massachusetts, USA	George Tomasini
9104	1895-11-10	1980-05-26		0	Germany	Franz Bachelin
5188	1905-04-29	1983-12-17	From Wikipedia, the free encyclopedia\n\nHal Pereira (April 29, 1905, Chicago, Illinois - December 17, 1983, Los Angeles, California) was an American art director, production designer, and occasional architect.\n\nIn the 1940s through the 1960s he worked on more than 200 films as an art director and production designer. He was nominated for 23 Oscars, having won only one for his work on The Rose Tattoo. He served, along with Earl Hedrick, as artistic director of the popular TV series Bonanza. Pereira started out in theater design in Chicago before moving to Los Angeles and working for Paramount Studios as a unit art director. In 1944 he was art designer for the great film noir "Double Indemnity." By 1950, he was supervising art director for the studio, working on such films as the classic Western Shane and The Greatest Show on Earth, which won the Oscar for Best Picture. In 1955 Pereira won the Oscar for best art direction for a black and white film for The Rose Tattoo. In addition, he was the art director on almost all of the important Alfred Hitchcock films of the 1950s.\n\nPereira was educated at the University of Illinois and is brother of architect (and occasional film art director) William L. Pereira.	2	 Chicago, Illinois, U.S.	Hal Pereira
7687	1893-07-13	1974-12-27		0		Sam Comer
7688	1898-02-21	1986-02-06		2		Ray Moyer
7689	1906-02-13	1973-07-03		0		Wally Westmore
9100	\N	\N		0		Edwin Blum
8619	1906-12-24	1967-02-24		2	Königshütte, Upper Silesia, Germany	Franz Waxman
9101	\N	\N		0		William Schorr
9609	1898-02-13	1962-11-26	From Wikipedia, the free encyclopedia\n\nAleksandr Pavlovich Antonov (1898 – 1962) was a Russian film actor who had a lengthy career, stretching from the silent era to the 1950s.\n\nHis best known role was as Grigory Vakulinchuk in Sergei Eisenstein's film The Battleship Potemkin. He also had a part in another Eisenstein film, Strike.\n\nDescription above from the Wikipedia article Aleksandr Pavlovich Antonov, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Moscow, Russian Empire	Aleksandr Antonov
9610	1889-01-01	1936-01-24		0		Vladimir Barsky
9607	1903-01-23	1983-12-16	Grigori Vasilyevich Aleksandrov or Alexandrov (original family name was Mormonenko; 23 January 1903 - 16 December 1983) was a prominent Soviet film director who was named a People's Artist of the USSR in 1947 and a Hero of Socialist Labor in 1973. He was awarded the Stalin Prizes for 1941 and 1950.\n\nInitially associated with Sergei Eisenstein, with whom he worked as a co-director, screenwriter and actor, Aleksandrov became a major director in his own right in the 1930s, when he directed Jolly Fellows and a string of other musical comedies starring his wife Lyubov Orlova.\n\nThough Aleksandrov remained active until his death, his musicals, amongst the first made in the Soviet Union, remain his most popular films. They rival Ivan Pyryev's films as the most effective and light-hearted showcase ever designed for Stalin-era USSR.\n\nDescription above from the Wikipedia article Grigori Aleksandrov, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Yekaterinburg, Russian Empire	Grigori Aleksandrov
9611	\N	\N		0		Ivan Bobrov
9727	\N	\N		0		Mikhail Gomorov
9728	\N	\N		0		Aleksandr Levshin
9729	\N	\N		0		Beatrice Vitoldi
1308319	\N	\N		0		Daniil Antonovich
9603	1898-01-23	1948-02-11	From Wikipedia, the free encyclopedia\n\nSergei Mikhailovich Eisenstein (January 23, 1898 – February 11, 1948) was a pioneering Soviet Russian film director and film theorist, often considered to be the "Father of Montage." He is noted in particular for his silent films Strike (1924), Battleship Potemkin (1925) and October (1927), as well as the historical epics Alexander Nevsky (1938) and Ivan the Terrible (1944, 1958). His work profoundly influenced early filmmakers owing to his innovative use of and writings about montage.\n\nDescription above from the Wikipedia article Sergei Eisenstein, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Riga, Russian Empire	Sergei M. Eisenstein
86747	1903-08-29	1976-01-17		2	Nizhny Novgorod, Russian Empire [now Russia]	Andrey Fayt
275018	1887-08-28	1955-05-15		0	Orenburg, Orenburg Governorate, Russian Empire [now Orenburg Oblast, Russia]	Vladimir Uralsky
9604	\N	\N		0		Brian Shirey
9605	\N	\N		0		Vladimir Popov
9608	\N	\N		0		Vasili Rakhals
2793	\N	\N		0		Edmund Meisel
9606	\N	\N		0		Eduard Tisse
947665	\N	\N		0		Nina Agadzhanova
9640	1988-04-10	\N	Haley Joel Osment (born April 10, 1988) is an American actor. After a series of roles in television and film during the 1990s, including a small part in Forrest Gump playing the title character’s son, Osment rose to fame with his performance as Cole Sear in M. Night Shyamalan’s thriller film The Sixth Sense that earned him a nomination for Academy Award for Best Supporting Actor. He subsequently appeared in leading roles in several high-profile Hollywood films including Steven Spielberg's A.I. Artificial Intelligence and Mimi Leder's Pay it Forward. He made his Broadway debut in 2008 in a revival of American Buffalo, co-starring with John Leguizamo and Cedric the Entertainer.\n\nDescription above from the Wikipedia article Haley Joel Osment, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Los Angeles - California - USA	Haley Joel Osment
1518	1967-06-12	\N	Frances O'Connor (born 12 June 1967) is an Australian actress.\n\nDescription above from the Wikipedia article Frances O'Connor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Wantage, Oxfordshire, England, UK	Frances O'Connor
8213	1961-12-16	\N	From Wikipedia, the free encyclopedia.\n\nSam Prideaux Robards (born December 16, 1961) is an American actor.	2	New York City - New York - USA	Sam Robards
9641	1990-01-30	\N		2		Jake Thomas
9642	1972-12-29	\N	David Jude Heyworth Law (born 29 December 1972), known professionally as Jude Law, is an English actor, film producer and director.\n\nHe began acting with the National Youth Music Theatre in 1987, and had his first television role in 1989. After starring in films directed by Andrew Niccol, Clint Eastwood and David Cronenberg, he was nominated for the Academy Award for Best Supporting Actor in 1999 for his performance in Anthony Minghella's The Talented Mr. Ripley. In 2000 he won a Best Supporting Actor BAFTA Award for his work in the film. In 2003, he was nominated for the Academy Award for Best Actor for his performance in another Minghella film, Cold Mountain.\n\nIn 2006, he was one of the top ten most bankable movie stars in Hollywood. In 2007, he received an Honorary César and he was named a Chevalier of the Ordre des Arts et des Lettres by the French government. In April 2011, it was announced that he would be a member of the main competition jury at the 2011 Cannes Film Festival.\n\nDescription above from the Wikipedia article Jude Law, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Lewisham, London, England, UK	Jude Law
227	1950-03-20	\N	William M. Hurt (born March 20, 1950) is an American actor. He received his acting training at the Juilliard School, and began acting on stage in the 1970s. Hurt made his film debut as a troubled scientist in the science-fiction feature Altered States (1980), for which he received a Golden Globe nomination for New Star of the Year. He subsequently played the leading role of a sleazy lawyer in the well-received film noir Body Heat (1981).\n\nIn 1985, Hurt garnered substantial critical acclaim and multiple acting awards, including an Academy and a BAFTA Award for Best Actor, for portraying an effeminate homosexual in Kiss of the Spider Woman. He went on to receive another two Academy Award nominations for his lead performances in Children of a Lesser God (1986) and Broadcast News (1987). Hurt remained an active stage actor throughout the 1980s, appearing in numerous Off-Broadway productions including Henry V, Fifth of July, Richard II, and A Midsummer Night's Dream. Hurt received his first Tony Award nomination in 1985 for the Broadway production of Hurlyburly.\n\nAfter playing a diversity of character roles in the following decade, Hurt earned his fourth Academy Award nomination for his supporting performance in David Cronenberg's crime thriller A History of Violence (2005). Other notable films in recent years have included A.I. Artificial Intelligence (2001), Syriana (2005), The Good Shepherd (2006), Mr. Brooks (2007), Into the Wild (2007), The Incredible Hulk (2008), and Robin Hood (2010).\n\nDescription above from the Wikipedia article William Hurt, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Washington - D.C. - USA	William Hurt
2157	1951-07-21	2014-08-11	From Wikipedia, the free encyclopedia.\n\nRobin McLaurin Williams (July 21, 1951 – August 11, 2014) was an  American actor and stand-up comedian. Rising to fame with his role as  the alien Mork in the TV series Mork &amp; Mindy  (1978–1982), Williams  went on to establish a successful career in both  stand-up comedy and  feature film acting. His film career included such  acclaimed films as  "The World According to Garp" (1982), Good Morning, Vietnam (1987), Dead  Poets Society (1989), Awakenings (1990), The Fisher King (1991), and  Good Will Hunting (1997), as well as financial successes such as Popeye  (1980), Hook (1991), Aladdin (1992), Mrs. Doubtfire (1993), Jumanji  (1995), The Birdcage (1996), Night at the Museum (2006), and Happy Feet  (2006).\n\nHe also appeared in the video "Don't Worry, Be Happy" by Bobby  McFerrin.  Nominated for the Academy Award for Best Actor three times, Williams  received the Academy Award for Best Supporting Actor for his performance  in Good Will Hunting (1997). He also received two Emmy Awards, four  Golden Globe Awards, two Screen Actors Guild Awards and five Grammy  Awards.\n\nOn August 11, 2014, Williams was found unconscious at his residence and  was pronounced dead at the scene. The Marin County, California,  coroner's office said they believe the cause of death was asphyxiation.	2	Chicago - Illinois - USA	Robin Williams
10017	1923-10-04	2008-04-05	From Wikipedia, the free encyclopedia.\n\nCharlton Heston (October 4, 1923 – April 5, 2008) was an American actor of film, theatre and television. Heston is known for heroic roles in films such as The Ten Commandments, Planet of the Apes and Ben-Hur, for which he won the Academy Award for Best Actor. Heston was also known for his political activism. In the 1950s and 1960s he was one of a handful of Hollywood actors to speak openly against racism and was an active supporter of the Civil Rights Movement. Initially a moderate Democrat, he later supported conservative Republican policies and was president of the National Rifle Association from 1998 to 2003.	0	Evanston - Illinois - USA	Charlton Heston
10018	1910-09-14	1973-07-18	From Wikipedia, the free encyclopedia\n\nColonel John Edward "Jack" Hawkins CBE (14 September 1910 - 18 July 1973) was an English film actor of the 1950s, 1960s and early 1970s.   Description above from the Wikipedia article Jack Hawkins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Wood Green, London, England, UK	Jack Hawkins
10019	1931-09-20	\N	From Wikipedia, the free encyclopedia\n\nHaya Harareet (sometimes credited as Haya Hararit; born 20 September 1931 in Haifa) is an Israeli actress.\n\nHarareet began her career in Israeli films with Hill 24 Doesn't Answer (1955), but her most widely seen performance in international cinema was as Esther in Ben Hur (1959) opposite Charlton Heston. She also starred in Edgar G. Ulmer's Journey Beneath The Desert (1961) with Jean-Louis Trintignant. Her career, however, was short-lived and, after a few films, ended in 1964. She co-wrote the screenplay for Our Mother's House (1967) from the novel of the same name by Julian Gloag. The film starred Dirk Bogarde.\n\nShe was married to the British film director Jack Clayton until his death on February 26, 1995. As of 2010 she is the only leading actor from Ben-Hur to remain alive.\n\nShe also starred opposite Stewart Granger in Basil Dearden's film The Secret Partner (1961).\n\nShe played the role of Dr. Madolyn Bruckner in The Interns (1962). She also played opposite Virna Lisi in Francesco Maselli's La donna del giorno (1956) ("The Doll that Took the Town"), and Edgar G. Ulmer's L'Atlantide (1961) ("Journey Beneath The Desert", AKA "The Lost Kingdom") with Jean-Louis Trintignant.\n\nMs. Harareet resides in Buckinghamshire, England.\n\n \n\nDescription above from the Wikipedia article Haya Harareet, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Haifa, Palestine	Haya Harareet
10020	1931-07-04	1977-06-02	From Wikipedia, the free encyclopedia\n\nStephen Boyd (4 July 1931 – 2 June 1977) was an American actor, originally from Glengormley, Northern Ireland, who appeared in around sixty films, most notably in the role of Messala in the 1959 film Ben-Hur.\n\n \n\nDescription above from the Wikipedia article Stephen Boyd, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Glengormley, Northern Ireland, UK	Stephen Boyd
10021	1912-05-30	1980-05-14	From Wikipedia, the free encyclopedia\n\nHugh Emrys Griffith (30 May 1912 – 14 May 1980) was an Oscar-winning Welsh film, stage and television actor.\n\n \n\nDescription above from the Wikipedia article Hugh Griffith, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Marian Glas, Anglesey, Wales, UK	Hugh Griffith
10022	1912-09-22	2003-05-28	From Wikipedia, the free encyclopedia\n\nMartha Ellen Scott (September 22, 1912 – May 28, 2003) was an American actress best known for her roles as mother of the lead character in numerous films and television shows.\n\nDescription above from the Wikipedia article Martha Scott, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Jamesport, Missouri, U.S.	Martha Scott
10023	1923-07-06	1970-04-11	Cathy O'Donnell (July 6, 1923 – April 11, 1970) was an American actress, best known for her many roles in film-noir movies.\n\nWhile under contract with Samuel Goldwyn, O'Donnell made her debut in an uncredited role as a nightclub extra in Wonder Man (1945). Her first major role in The Best Years of Our Lives (1946), playing Wilma Cameron, the high-school sweetheart of double amputatee Homer Parrish, played by real-life World War II veteran/amputee Harold Russell.\n\nShe was loaned out to RKO for one of her most memorable films, They Live by Night (1949) starring with Farley Granger, widely considered a classic of the noir genre and on the Guardian's list of the top ten noir films. The film was directed by Nicholas Ray. The two actors later re-teamed for another movie, Side Street (1950).\n\nLater O'Donnell starred in The Miniver Story (also 1950), as Judy Miniver and also had a supporting role in Detective Story (1951). She appeared as Barbara Waggoman, the love interest of James Stewart's character in the western The Man from Laramie (1955). Her final film role was the title character's sister Tirzah in William Wyler's 1959 Academy Award winning Best Picture Ben-Hur (1959).\n\nIn the 1960s, she appeared in TV shows, playing mostly bit parts on shows such as Perry Mason, The Rebel and Man Without a Gun. Her last screen appearance was in 1964, in an episode of Bonanza.\n\nDescription above from the Wikipedia article Cathy O'Donnell, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Siluria, Alabama, USA	Cathy O'Donnell
10025	1926-05-11	1994-12-29		0		Frank Thring
10024	1891-03-10	1984-03-24	From Wikipedia, the free encyclopedia.  \n\nSam Jaffe (March 10, 1891 – March 24, 1984) was an American actor, teacher, musician and engineer. In 1951, he was nominated for the Academy Award for Best Supporting Actor for his performance in The Asphalt Jungle (1950) and appeared in other classic films such as Ben-Hur (1959) and The Day the Earth Stood Still (1951). He may be best remembered for playing the title role in Gunga Din (1939), and the High Lama in Lost Horizon (1937).\n\nDescription above from the Wikipedia article Sam Jaffe  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 New York City, New York, U.S.	Sam Jaffe
10026	1913-02-04	1966-01-03		2		Ady Berber
10027	1878-01-20	1968-05-09	From Wikipedia, the free encyclopedia\n\nFinlay Jefferson Currie (20 January 1878 – 9 May 1968) was a Scottish actor of stage, screen and television.\n\nBorn in Edinburgh, Scotland, Currie's acting career began on the stage. He and his wife Maude Courtney (1884–1959) did a song and dance act in the US in the 1890s. He made his first film (The Old Man) in 1931. He appeared as a priest in the 1943 Ealing World War II movie Undercover. His most famous film role was as the convict Abel Magwitch in David Lean's Great Expectations (1946), based on the novel, 'Great Expectations' by Charles Dickens. He later began to appear in Hollywood film epics, including the 1951 Quo Vadis (as Saint Peter), the multi-Oscar winning 1959 Ben-Hur, as Balthazar, one of the Three Wise Men, and The Fall of the Roman Empire (1964) as an aged, wise senator; He appeared in People Will Talk with Cary Grant; and he also portrayed Robert Taylor's embittered father in MGM's Technicolor 1952 version of Ivanhoe. In 1962, he starred in an episode of The DuPont Show of the Week (NBC) entitled The Ordeal of Dr. Shannon, an adaptation of A. J. Cronin's novel, Shannon's Way. Currie's last role was as Mr. Lundie, the minister, in the 1966 television adaptation of the musical Brigadoon. In one of his very last performances, Currie plays a dying mafioso boss in the two part "Vendetta For The Saint" (1968) starring Roger Moore.\n\nLater in life he became a much respected antiques dealer, specialising in coins and precious metals. He had been a long time collector of the works of Robert Burns.\n\n \n\nDescription above from the Wikipedia article Finlay Currie, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Edinburgh, Scotland, UK	Finlay Currie
10029	1909-08-20	1978-11-28	From Wikipedia, the free encyclopedia\n\nAndré Morell (20 August 1909 – 28 November 1978; sometimes credited as Andre Morell) was a British actor. He appeared frequently in theatre, film and on television from the 1930s to the 1970s. His best known screen roles were as Professor Bernard Quatermass in the BBC Television serial Quatermass and the Pit (1958–59), and as Doctor Watson in the Hammer Film Productions version of The Hound of the Baskervilles (1959). He also appeared in the Academy Award-winning films The Bridge on the River Kwai (1957) and Ben-Hur (1959), in several of Hammer's well-known horror films throughout the 1960s and in the acclaimed ITV historical drama The Caesars (1968).\n\nHis obituary in The Times newspaper described him as possessing a "commanding presence with a rich, responsive voice... whether in the classical or modern theatre he was authoritative and dependable."\n\nDescription above from the Wikipedia article André Morell, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	London, England	André Morell
25687	1922-05-14	2011-04-23		2	Newark-on-Trent - Nottinghamshire - England - UK	Terence Longdon
53660	1935-08-24	\N	From Wikipedia, the free encyclopedia\n\nGerlando Buzzanca (born August 24, 1935 in Palermo) is an Italian comedy actor.\n\nHe left high school in Palermo when he was 16 years old, and moved to Rome to pursue his dream of becoming an actor. In order to survive, he took many jobs: waiter, furniture mover, and a brief appearance as a slave in the film Ben-Hur.\n\nIn his long career he often interpreted the role of the average Italian immigrant from southern Italy, who slowly began to enjoy moderate success during the years of the Italian economic miracle. His films showcased all the freshness of the 1960s, the 1970s and the heavier transition to the 1980s, focusing on the common life in several Italian cities such as Rome, Verona or Milan, balanced between personal happiness and professional achievement.\n\nBuzzanca often interpreted roles of a subordinate white collar worker, with a heavy vein of machismo, as a frustrated employee who tries to redeem his dull existence with his virility. He became famous for his role in the film Il merlo maschio, (The Male Blackbird), where in a provincial environment of cultural importance, the philharmonic orchestra of the Arena di Verona, he vents out his own frustrations, indulging into candaulism when he induces his bride to expose her naked body in the middle of a bridge in Verona.\n\nSome critics, in a lighter vein, have defined Buzzanca as a "Homo eroticus": a human being halfway between Homo erectus and Homo sapiens, who risked extinction in the 1970s because of the harsh struggle with feminism activists. Today, even though much less so, this male type is still found among Italian males.\n\nBuzzanca's fame is greater in foreign countries than in his native land, and in countries as France, Japan, Greece, Israel, Spain and Switzerland he is a renowned international stereotype of the Italian provincialotto, elegant, naif, always causing mischief, and not obtaining anything from it.\n\nDescription above from the Wikipedia article Lando Buzzanca, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Palermo, Sicily, Italy	Lando Buzzanca
15139	1938-09-02	2013-10-01		0		Giuliano Gemma
24602	1924-09-29	2002-10-29	Elena Maureen Bertolini, known as Marina Berti, (29 September 1924 – 29 October 2002) was an English-born Italian film actress.\n\nHer first screen appearance was in the Anna Magnani film, La Fuggitiva in 1941. She appeared mainly in small roles and in the occasional leading role in nearly 100 films both Italian and American. Her appearances include Quo Vadis (1951), Abdulla the Great (1955), Ben Hur (1959), Cleopatra (1963), If It's Tuesday, This Must Be Belgium (1969), What Have They Done to Your Daughters? (1974), Night Train Murders (1975), and the TV miniseries' Moses the Lawgiver (1975) and Jesus of Nazareth (1977). Her last film appearance was in the Costa-Gavras film Amen. in 2002. [Wikipedia]	0	London  	Marina Berti
10513	1921-07-23	2003-11-11		0		Robert Brown
1090000	1899-03-04	1982-03-26		0	Buenos Aires - Argentina	Liana Del Balzo
39165	1908-07-17	1993-03-22	Enzo Fiermonte was an actor and writer. Died on March 22, 1993 (age 84) in Mentana, Lazio, Italy	0	Bari - Puglia - Italy	Enzo Fiermonte
16055	1892-11-16	1981-05-18		0		Richard Hale
29659	1918-06-17	1978-12-19		0		Duncan Lamont
14264	1912-04-05	1983-11-15	From Wikipedia, the free encyclopedia\n\nJohn Le Mesurier (born John Elton Le Mesurier Halliley, 5 April 1912 – 15 November 1983) was a BAFTA Award-winning English actor. He is most famous for his role as Sergeant Arthur Wilson in the popular 1970s BBC comedy Dad's Army.\n\nDescription above from the Wikipedia article John Le Mesurier, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Bedford, Bedfordshire, England	John Le Mesurier
26557	1916-03-11	1998-01-30	From Wikipedia, the free encyclopedia\n\nFerdy Mayne (11 March 1916 – 30 January 1998) was a German actor.\n\nDescription above from the Wikipedia article Ferdy Mayne, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Mainz, Germany	Ferdy Mayne
14287	1899-09-08	1984-04-26	​From Wikipedia, the free encyclopedia\n\nMay McAvoy (September 8, 1899 – April 26, 1984) was an American actress, who worked mainly during the silent film era. She starred in Hollywood's revolutionary part talking film, The Jazz Singer.\n\nDescription above from the Wikipedia article May McAvoy, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, U.S.	May McAvoy
5404	1891-01-21	1964-11-12	From Wikipedia, the free encyclopedia\n\nAldo Silvani (21 January 1891 – 12 November 1964) was an Italian film actor. He appeared in 112 films between 1934 and 1964.\n\nHe was born in Turin, Italy and died in Milan, Italy.\n\nDescription above from the Wikipedia article Aldo Silvani, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Turin, Italy	Aldo Silvani
89064	1900-05-07	1977-10-15		0		Ralph Truman
10028	\N	\N		0		George Relph
217763	\N	\N		0		Joe Canutt
223601	\N	\N		0		Richard Coleman
91817	\N	\N		0		Antonio Corevi
153212	\N	\N		0		David Davies
99514	1903-05-06	2006-05-12		2	Venice, Veneto, Italy	Mino Doro
82510	\N	\N		0		Michael Dugan
33820	1924-03-05	2002-11-10		0		Franco Fantasia
1046559	\N	\N		0		José Greci
10275	\N	\N		0		Jack Beresford
10299	\N	\N		0		Ralf Berzsenyi
10300	\N	\N		0		Ferenc Csík
10301	\N	\N		0		Richard Degener
10302	\N	\N		0		Willemijntje den Ouden
10303	\N	\N		0		Charles des Jammonières
10304	\N	\N		0		Velma Dunn
10305	\N	\N		0		Konrad Frey
10306	\N	\N		0		Marjorie Gestring
10307	\N	\N		0		Albert Greene
10308	\N	\N		0		Tetsuo Hamuro
10309	\N	\N		0		Josef Hasenöhrl
10310	\N	\N		0		Heinz Hax
10311	\N	\N		0		Alois Hudec
10312	\N	\N		0		Cornelius Johnson
10313	\N	\N		0		Adolph Kiefer
10314	\N	\N		0		Masaji Kiyokawa
245486	1912-06-18	1974-01-31	Glenn Morris was the fourth Olympic athlete to play Tarzan. He was the 1936 decathlon champion and won the Sullivan Award (outstanding amateur athlete of the year) over the more famous Olympian Jesse Owens. Sol Lesser cast Morris for an independent Tarzan, filmed on Twentieth Century-Fox back lots. The reviews were so thoroughly bad that Morris never made another movie. He went into the insurance business in Los Angeles. He enlisted in the Navy after Pearl Harbor, was wounded in combat from which he spent much time in San Francisco's Navy Hospital.	0		Glenn Morris
10139	1902-08-22	2003-09-08	Helene Bertha Amalie "Leni" Riefenstahl (22 August 1902 – 8 September 2003) was a German film director, actress and dancer widely noted for her aesthetics and innovations as a filmmaker. Her most famous film was Triumph des Willens (Triumph of the Will), made at the 1934 Nuremberg congress of the Nazi Party. Riefenstahl's prominence in the Third Reich along with her personal friendship with Adolf Hitler thwarted her film career following Germany's defeat in World War II, after which she was arrested but released without any charges.\n\nTriumph of the Will gave Riefenstahl instant and lasting international fame, as well as infamy. Although she directed only eight films, just two of which received significant coverage outside of Germany, Riefenstahl was widely known all her life. The propaganda value of her films made during the 1930s repels most modern commentators but many film histories cite the aesthetics as outstanding. The Economist wrote that Triumph of the Will "sealed her reputation as the greatest female filmmaker of the 20th century".\n\nIn the 1970s Riefenstahl published her still photography of the Nuba tribes in Sudan in several books such as The Last of the Nuba. She was active up until her death and also published marine life stills and released the marine-based film Impressionen unter Wasser in 2002.\n\nAfter her death, the Associated Press described Riefenstahl as an "acclaimed pioneer of film and photographic techniques". Der Tagesspiegel newspaper in Berlin noted, "Leni Riefenstahl conquered new ground in the cinema". The BBC said her documentaries "were hailed as groundbreaking film-making, pioneering techniques involving cranes, tracking rails, and many cameras working at the same time".\n\nDescription above from the Wikipedia article Leni Riefenstahl, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Berlin, German Empire	Leni Riefenstahl
10145	\N	\N		0		Herbert Windt
1038	1962-11-19	\N	Alicia Christian "Jodie" Foster (born November 19, 1962) is an American actress, film director, producer as well as being a former child actress.\n\nFoster began acting in commercials at three years of age, and her first significant role came in the 1976 film Taxi Driver as the preteen prostitute Iris for which she received a nomination for the Academy Award for Best Supporting Actress. Also that year, she starred in the cult film The Little Girl Who Lives Down the Lane. She won an Academy Award for Best Actress in 1989 for playing a rape survivor in The Accused. In 1991, she starred in The Silence of the Lambs as Clarice Starling, a gifted FBI trainee, assisting in a hunt for a serial killer. This performance received international acclaim and her second Academy Award for Best Actress. She received her fourth Academy Award nomination for playing a hermit in Nell (1994). Other popular films include Maverick (1994), Contact (1997), Panic Room (2002), Flightplan (2005), Inside Man (2006), The Brave One (2007), and Nim's Island (2008).\n\nFoster's films have spanned a wide variety of genres, from family films to horror. In addition to her two Academy Awards she has won two BAFTA Awards for three films, two Golden Globe Awards, a Screen Actors Guild Award, a People's Choice Award, and has received two Emmy nominations.\n\nDescription above from the Wikipedia article Jodie Foster, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Los Angeles, California, USA	Jodie Foster
10297	1969-11-04	\N	Matthew David McConaughey (born November 4, 1969) is an American actor. After a series of minor roles in the early 1990s, McConaughey gained notice for his breakout role in Dazed and Confused (1993). It was in this role that he first conceived the idea of his catch-phrase "Well alright, alright." He then appeared in films such as A Time to Kill, Contact, U-571, Tiptoes, Sahara, and We Are Marshall. McConaughey is best known more recently for his performances as a leading man in the romantic comedies The Wedding Planner, How to Lose a Guy in 10 Days, Failure to Launch, Ghosts of Girlfriends Past and Fool's Gold.\n\nDescription above from the Wikipedia article Matthew McConaughey, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Uvalde - Texas - USA	Matthew McConaughey
5049	1940-01-22	2017-01-25	John Vincent Hurt, CBE (born 22 January 1940) was an English actor, known for his leading roles as John Merrick in The Elephant Man, Winston Smith in Nineteen Eighty-Four, Mr. Braddock in The Hit, Stephen Ward in Scandal and Quentin Crisp in The Naked Civil Servant, Caligula in the television series, I, Claudius (TV series), and An Englishman in New York. Recognizable for his distinctive rich voice, he has also enjoyed a successful voice acting career, starring in films such as Watership Down, The Lord of the Rings and Dogville, as well as BBC television series Merlin. Hurt initially came to prominence for his role as Richard Rich in the 1966 film A Man for All Seasons, and has since appeared in such popular motion pictures as: Alien, Midnight Express, Rob Roy, V for Vendetta, Indiana Jones and the Kingdom of the Crystal Skull, the Harry Potter film series and the Hellboy film series. Hurt is one of England's best-known, most prolific and sought-after actors, and has had a versatile film career spanning six decades. He is also known for his many Shakespearean roles. Hurt has received multiple awards and honours throughout his career including three BAFTA Awards and a Golden Globe Award, with six and two nominations respectively, as well as two Academy Award nominations. His character's final scene in Alien is consistently named as one of the most memorable in cinematic history.\n\nDescription above from the Wikipedia article John Hurt , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Shirebrook, Derbyshire, England, UK	John Hurt
4139	1933-08-25	\N	​From Wikipedia, the free encyclopedia\n\nThomas Roy "Tom" Skerritt (born August 25, 1933) is an American actor who has appeared in over 40 films and more than 200 television episodes since 1962.\n\nDescription above from the Wikipedia article Tom Skerritt, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Detroit, Michigan, USA	Tom Skerritt
886	1956-11-27	\N	William Edward Fichtner (born November 27, 1956) is an American actor. He has appeared in a number of notable film and TV series. He is known for his roles as Sheriff Tom Underlay in the cult favorite television series Invasion, Alexander Mahone on Prison Break and Butch Cavendish in The Lone Ranger.\n\nDescription above from the Wikipedia article William Fichtner, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Mitchell Field Air Force Base, East Meadow, Long Island, New York, USA	William Fichtner
6003	\N	\N		0		Lisa Lindgren
855	1935-12-14	1991-07-02	Lee Ann Remick (December 14, 1935 – July 2, 1991) was an American film and television actress. Among her best-known films are Anatomy of a Murder (1959), Days of Wine and Roses (1962), and The Omen (1976).\n\nDescription above from the Wikipedia article Lee Remick, licensed under CC-BY-SA, full list of contributors on Wikipedia​	1	Quincy, Massachusetts, USA	Lee Remick
6283	1960-11-08	\N	Rolf Åke Michael Nyqvist (born November 8, 1960 in Stockholm) is a Swedish actor. Educated at the School of Drama in Malmö, he became well known from his role as police officer Banck in the first series of Beck movies made in 1997. He is recently most recognized for his role in the internationally acclaimed The Girl with the Dragon Tattoo Trilogy as Mikael Blomkvist and is one of Sweden's most beloved actors.\n\nDescription above from the Wikipedia article Michael Nyqvist, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Stockholm, Stockholms län, Sweden	Michael Nyqvist
11038	\N	\N		0		Emma Samuelsson
11039	\N	\N		0		Sam Kessel
11040	1967-09-02	\N		0	 Stockholm, Stockholms län, Sweden	Gustaf Hammarsten
11041	1971-06-07	\N		1	Stockholm, Sweden	Anja Lundkvist
11042	\N	\N		0		Jessica Liedberg
11043	\N	\N		0		Axel Zuber
10980	1989-07-23	\N	Daniel Jacob Radcliffe (born 23 July 1989) is an English actor who rose to prominence playing the titular character in the Harry Potter film series. His work on the series has earned him several awards and more than £60 million.\n\nRadcliffe made his acting debut at age ten in BBC One's television movie David Copperfield (1999), followed by his film debut in 2001's The Tailor of Panama. Cast as Harry at the age of eleven, Radcliffe has starred in seven Harry Potter films since 2001, with the final installment releasing in July 2011. In 2007 Radcliffe began to branch out from the series, starring in the London and New York productions of the play Equus, and the 2011 Broadway revival of the musical How to Succeed in Business Without Really Trying. The Woman in Black (2012) will be his first film project following the final Harry Potter movie.\n\nRadcliffe has contributed to many charities, including Demelza House Children's Hospice and The Trevor Project. He has also made public service announcements for the latter. In 2011 the actor was awarded the Trevor Project's "Hero Award".\n\nDescription above from the Wikipedia article Daniel Radcliffe, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Hammersmith, London, UK	Daniel Radcliffe
10989	1988-08-24	\N	From Wikipedia, the free encyclopedia\n\nRupert Alexander Grint (born 24 August 1988) is an English actor, who rose to prominence playing Ron Weasley, one of the three main characters in the Harry Potter film series. Grint was cast as Ron at the age of 11, having previously acted only in school plays and at his local theatre group. From 2001 to 2010, he starred in eight Harry Potter movies alongside Daniel Radcliffe and Emma Watson.\n\nBeginning in 2002, Grint began to work outside of the Harry Potter franchise, taking on a co-leading role in Thunderpants. He has had starring roles in Driving Lessons, a dramedy released in 2006, and Cherrybomb, a small budgeted drama released in 2010. Grint co-starred with Bill Nighy and Emily Blunt in Wild Target, a comedy. His first project following the end of the Harry Potter series will be Comrade, a 2012 anti-war release in which he stars as the main role.\n\nDescription above from the Wikipedia article Rupert Grint, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Watton-at-Stone, Hertfordshire, United Kingdom	Rupert Grint
10990	1990-04-15	\N	Emma Charlotte Duerre Watson (born 15 April 1990) is an English actress and model who rose to prominence playing Hermione Granger, one of three starring roles in the Harry Potter film series. Watson was cast as Hermione at the age of nine, having previously acted only in school plays. From 2001 to 2011, she starred in eight Harry Potter films alongside Daniel Radcliffe and Rupert Grint. Watson's work on the Harry Potter series has earned her several awards and more than £10 million.\n\nShe made her modelling debut for Burberry's Autumn/Winter campaign in 2009. In 2007, Watson announced her involvement in two non-Harry Potter productions: the television adaptation of the novel Ballet Shoes and an animated film, The Tale of Despereaux. Ballet Shoes was broadcast on 26 December 2007 to an audience of 5.2 million, and The Tale of Despereaux, based on the novel by Kate DiCamillo, was released in 2008 and grossed over US $70 million in worldwide sales. In 2012, she starred in Stephen Chbosky's film adaptation of The Perks of Being a Wallflower, and was cast in the role of Ila in Darren Aronofsky's biblical epic Noah.\n\nDescription above from the Wikipedia article Emma Watson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paris, France	Emma Watson
10993	1987-09-22	\N	​From Wikipedia, the free encyclopedia\n\nThomas Andrew "Tom" Felton (born 22 September 1987) is a British actor and musician. He is best known for playing the role of Draco Malfoy in the Harry Potter film series, the movie adaptations of the best-selling Harry Potter fantasy novels by author J. K. Rowling, for which he auditioned at age twelve. Felton started filming in commercials when he was eight years old and in films at the age of ten, appearing in The Borrowers and Anna and the King. After being cast as Draco Malfoy he has subsequently appeared in all eight Harry Potter films, from 2001 to 2011, and finished filming the last two. A fishing aficionado, he helped form the World Junior Carp Tournament, a "family-friendly" fishing tournament. Felton's portrayal of Draco Malfoy in Harry Potter and the Half-Blood Prince won him the MTV Movie Award for Best Villain in 2010.\n\nDescription above from the Wikipedia article Tom Felton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Kensington, London, United Kingdom	Tom Felton
477	1950-02-22	\N	Julie Walters is an English actress and novelist.\n\nWalters was born as Julia Mary Walters in Smethwick, Sandwell, the daughter of Mary Bridget, a postal clerk of Irish Catholic extraction, and Thomas Walters, a builder and decorator.\n\nWalters met her husband, Grant Roffey, an AA patrol man, in a whirlwind romance. The couple have a daughter, Maisie Mae Roffey (born 1988, City of Westminster, London), but did not marry until 1997, 11 years into their relationship, when they went to New York. The couple live on an organic farm run by Roffey in West Sussex.	1	Smethwick, England, UK	Julie Walters
388	1949-05-24	\N	One of England's most versatile character actors, Jim Broadbent was born on May 24, 1949, in Lincolnshire, the youngest son of furniture maker Roy Broadbent and sculptress Dee Broadbent. Jim attended a Quaker boarding school in Reading before successfully applying for a place at an art school. His heart was in acting, though, and he would later transfer to the London Academy of Music and Dramatic Art (LAMDA). Following his 1972 graduation, he began his professional career on the stage, performing with the Royal National Theatre, the Royal Shakespeare Company, and as part of the National Theatre of Brent, a two-man troupe which he co-founded. In addition to his theatrical work, Broadbent did steady work on television, working for such directors as Mike Newell and Stephen Frears. Broadbent made his film debut in 1978 with a small part in Jerzy Skolimowski's The Shout (1978). He went on to work with Frears again in The Hit (1984) and with Terry Gilliam in Time Bandits (1981) and Brazil (1985), but it was through his collaboration with Mike Leigh that Broadbent first became known to an international film audience. In 1990 he starred in Leigh's Life Is Sweet (1990), a domestic comedy that cast him as a good-natured cook who dreams of running his own business. Broadbent gained further visibility the following year with substantial roles in Neil Jordan's The Crying Game (1992) and Mike Newell's Enchanted April (1992), and he could subsequently be seen in such diverse fare as Woody Allen's Bullets Over Broadway (1994), Widows' Peak (1994), Richard Loncraine's highly acclaimed adaptation of Shakespeare's Richard III (1995) and Little Voice (1998), the last of which cast him as a seedy nightclub owner. Appearing primarily as a character actor in these films, Broadbent took center stage for Leigh's Topsy-Turvy (1999), imbuing the mercurial W.S. Gilbert with emotional complexity and comic poignancy. Jim's breakthrough year was 2001, as he starred in three critically and commercially successful films. Many would consider him the definitive supporting actor of that year. First he starred as Bridget's dad (Colin Jones) in Bridget Jones's Diary (2001), which propelled Renée Zellweger to an Oscar nomination for Best Actress. Next came the multiple Oscar-nominated film (including Best Picture) Moulin Rouge! (2001), for which he won a Best Supporting Actor BAFTA award for his scene-stealing performance as Harold Zidler. Lastly, came the small biopic Iris (2001/I), for which he won the Oscar for Best Supporting Actor as devoted husband John Bayley to Judi Dench's Iris Murdoch, the British novelist who suffered from Alzheimer's disease. The film hit home with Jim, since his own mother had passed away from Alzheimer's in 1995.	2	Lincoln, Lincolnshire, England, UK	Jim Broadbent
1923	1950-03-30	\N	Robbie Coltrane, is a Scottish actor, comedian and author. He is known both for his role as Dr Eddie "Fitz" Fitzgerald in the British TV series Cracker and as Rubeus Hagrid in the Harry Potter films.\n\nColtrane was born Anthony Robert McMillan in Rutherglen, South Lanarkshire, the son of Jean McMillan Ross, a teacher and pianist, and Ian Baxter McMillan, a general practitioner who also served as a forensic police surgeon. He has an older sister, Annie, and a late younger sister, Jane.\n\nColtrane moved into acting in his early twenties, taking the stage name Coltrane (in tribute to jazz saxophonist John Coltrane) and working in theatre and stand-up comedy. Coltrane soon moved into films, obtaining roles in a number of movies such as Flash Gordon. On television, he also appeared as Samuel Johnson in Blackadder.\n\nHis roles went from strength to strength in the 1990s with the TV series Cracker and a BAFTA award as the stepping stone to parts in bigger films such as the James Bond films GoldenEye and The World Is Not Enough and a major supporting role as half-giant Rubeus Hagrid in the Harry Potter films.	2	Rutherglen, South Lanarkshire, Scotland	Robbie Coltrane
12339	\N	\N		0		Ileana Simova
12340	\N	\N		0		Elena Rea
12341	1908-07-24	1980-12-23		2		Memmo Carotenuto
1336866	\N	\N		0		Alberto Albani Barbieri
5658	1940-10-19	\N	Sir Michael Gambon is an Irish-British actor who has worked in theatre, television and film. A highly respected theatre actor, Gambon is recognised for his role in The Singing Detective and for his role as Albus Dumbledore in the Harry Potter film series, replacing the late actor Richard Harris. Gambon was born in Cabra, Dublin during World War II. His father, Edward Gambon, was an engineer, and his mother, Mary, was a seamstress. His father decided to seek work in the rebuilding of London, and so the family moved to Mornington Crescent in North London, when Gambon was five. His father had him made a British citizen - a decision that would later allow Michael to receive an actual, rather than honorary, knighthood. Gambon married Anne Miller when he was 22, but has always been secretive about his personal life, responding to one interviewer's question about her: "What wife?" The couple lived near Gravesend, Kent, where she has a workshop. While filming Gosford Park, Gambon brought Philippa Hart on to the set and introduced her to co-stars as his girlfriend. When the affair was revealed in 2002, he moved out of the marital home and bought a bachelor pad. In February 2007, it was revealed that Hart was pregnant with Gambon's child, and gave birth to son, Michael, in May 2007. On 22 June 2009 she gave birth to her second child, a boy named William, who is Gambon's third child. Gambon is a qualified private pilot and his love of cars led to his appearance on the BBC's Top Gear programme. Gambon raced the Suzuki Liana and was driving so aggressively that it went round the last corner of his timed lap on two wheels. The final corner of the Dunsfold Park track has been named "Gambon" in his honour.	2	Cabra, Dublin, Ireland	Michael Gambon
10978	1934-12-28	\N	From Wikipedia, the free encyclopedia.\n\nDame Margaret Natalie Smith, DBE (born 28 December 1934), better known as Maggie Smith, is an English film, stage, and television actress who made her stage debut in 1952 and is still performing after 59 years. She has won numerous awards for acting, both for the stage and for film, including five BAFTA Awards, two Academy Awards, two Golden Globes, two Emmy Awards, two Laurence Olivier Awards, two SAG Awards, and a Tony Award. Her critically acclaimed films include Othello (1965), The Prime of Miss Jean Brodie (1969), California Suite (1978), Clash of the Titans (1981), A Room with a View (1985), and Gosford Park (2001). She has also appeared in a number of widely-popular films, including Sister Act (1992) and as Professor Minerva McGonagall in the Harry Potter series. Smith has also appeared in the recent hit TV series "Downton Abbey" (2010-2011) as Violet, Dowager Countess of Grantham.\n\nDescription above from the Wikipedia article Maggie Smith, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Ilford Borough, Essex, United Kingdom	Maggie Smith
4566	1946-02-21	2016-01-14	Alan Sidney Patrick Rickman (born 21 February 1946) was  an English actor and theatre director. He was a renowned stage actor in modern and classical productions and a former member of the Royal Shakespeare Company. Rickman was known for his film performances as Hans Gruber in Die Hard, Severus Snape in the Harry Potter film series, Eamon de Valera in Michael Collins, and Metatron in Dogma. He was also known for his prominent roles as the Sheriff of Nottingham in the 1991 film, Robin Hood: Prince of Thieves, and as Colonel Brandon in Ang Lee's 1995 film Sense and Sensibility. More recently he played Judge Turpin in Tim Burton's Sweeney Todd: The Demon Barber of Fleet Street and voiced the Caterpillar in Tim Burton's Alice in Wonderland.\n\nDescription above from the Wikipedia article Alan Rickman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Hammersmith, London, UK	Alan Rickman
96841	1989-06-27	\N	Matthew David Lewis III is an English actor, best known for playing Neville Longbottom in the Harry Potter films.\n\nLewis was born in Horsforth,Leeds,West Yorkshire, England, the son of Adrian and Lynda Lewis. He has two older brothers and a foster sister.\n\nLewis has been acting since he was five years old. He started off with minor parts in television programmes, debuting in Some Kind of Life, and then went on to try out for the part of Neville Longbottom. He has portrayed Neville Longbottom in the first six Harry Potter films and is scheduled to be in the future Harry Potter films. For his role as Neville Longbottom, Lewis wears yellow and crooked false teeth, two-sizes-too-big shoes and has plastic bits placed behind his ears in order to make them stick out more. This is done to give the character a more clownish look.	2	Leeds, West Yorkshire, UK	Matthew Lewis
140367	1991-08-16	\N		1	Termonfeckin, Ireland	Evanna Lynch
234933	1987-08-08	\N	​Katie Liu Leung was born in Scotland to Peter and Kar Wai Li Leung, who are now divorced. She lives at home with her father, two brothers and one sister. She attended one of Scotland's most prestigious private schools, Hamilton College. Katie's father saw an advertisement for a casting call and suggested Katie try out. Katie objected when she saw the length of the line at the casting auditions and said she'd rather go shopping. She waited for a total of 4 hours before she got in. The audition for her only took 5 minutes and the next two weeks, she got called in for a workshop and from then on, she got the part as Cho Chang.	1	Motherwell, Scotland	Katie Leung
60348	1963-10-12	2014-07-06	​From Wikipedia, the free encyclopedia\n\nDavid "Dave" Legeno (born 12 October 1963) is an English actor, boxer, and mixed martial artist.\n\nDescription above from the Wikipedia article Dave Legeno, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Marylebone, London, England, UK	Dave Legeno
10988	1967-05-19	\N	​From Wikipedia, the free encyclopedia.  \n\nGeraldine Margaret Agnew-Somerville (born 19 May 1967) is an Irish actress best known for her roles as Detective Sergeant Jane "Panhandle" Penhaligon in Cracker, and Lily Potter in the Harry Potter film series.\n\nDescription above from the Wikipedia article  Geraldine Margaret Agnew-Somerville , licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	County Meath, Republic of Ireland	Geraldine Somerville
10991	1991-02-17	\N	Bonnie Francesca Wright was born on February 17, 1991 to jewelers Gary Wright and Sheila Teague. Her debut performance was in Harry Potter and the Philosopher's Stone (2001) as Ron Weasley's little sister Ginny Weasley. Bonnie tried out for the film due to her older brother Lewis mentioned she reminded him of Ginny. Her role in the first film was a small cameo like role as Ginny, having bigger part in the second film Harry Potter and the Chamber of Secrets (2002). After shooting the first Potter film, in 2002 Bonnie did the Hallmark television film Stranded (2002) (TV) playing Young Sarah Robinson. Then in 2004 after doing the Harry Potter and the Prisoner of Azkaban (2004) Bonnie was cast in Agatha Christie: A Life in Pictures (2004) (TV) , a BBC TV film as Young Agatha. Then Bonnie was back as Ginny Weasley for Harry Potter and the Goblet of Fire (2005), Harry Potter and the Order of the Phoenix (2007) and for Harry Potter and the Half-Blood Prince (2009) where her role turned supporting as Harry's love interest. In 2007 she guessed voiced for Disney's The Replacements (TV Series 2006-) London Calling (#2.11) as Vanessa. Also that time she voiced Ginny for Harry Potter and the Order of the Phoenix (2007) (VG) as well for Harry Potter and the Half-Blood Prince (2009) (VG) in 2009. While shooting for Harry Potter and the Deathly Hallows: Part 1 (2010), Bonnie was cast as Mia for Geography of the Hapless Heart (2013) a feature length film shot in five international locations about the complexity of love. Bonnie's segment was shot in December 2009 in London. Also during that time and shooting for Harry Potter and the Deathly Hallows: Part 2 (2011) Bonnie was attending London College of Communication to study film. In 2011 Bonnie starred in The Philosophers (2013) with James D'Arcy (I) , Daryl Sabara and with Harry Potter co-star Freddie Stroma. Film to be out in 2012. Bonnie has also written and directed a short film for school called Separate We Come, Separate We Go starring Potter co-star David Thewlis IMDb Mini Biography By: Kgose31788	1	London, United Kingdom	Bonnie Wright
1283	1966-05-26	\N	Helena Bonham Carter (born 26 May 1966) is an English actress of film, stage, and television. She made her film debut in K. M. Peyton's A Pattern of Roses before winning her first leading role as the titular character in Lady Jane. She is known for her roles in films such as A Room with a View, Fight Club, and the Harry Potter series, as well as for frequently collaborating with director Tim Burton, her domestic partner since 2001. Bonham Carter is a two-time Academy Award nominee for her performances in The Wings of the Dove and The King's Speech; her portrayal of Queen Elizabeth in the latter film garnering her a BAFTA Award in 2011.\n\nDescription above from the Wikipedia article Helena Bonham Carter, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Golders Green, London, England, UK	Helena Bonham Carter
15737	1968-08-17	\N	From Wikipedia, the free encyclopedia.\n\nHelen McCrory (born 17 August 1968) is an English actress. She portrayed Cherie Blair in both the 2006 film The Queen and the 2010 film The Special Relationship. She also portrayed Narcissa Malfoy in the final three installments of the Harry Potter movies.\n\nDescription above from the Wikipedia article Helen McCrory, licensed under CC-BY-SA, full list of contributors on Wikipedia  	1	London, England, UK	Helen McCrory
9191	1957-02-27	\N	Timothy Leonard Spall, OBE (born 27 February 1957) is an English character actor and occasional presenter.\n\nDescription above from the Wikipedia article Timothy Spall, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Battersea, London, England, UK	Timothy Spall
140368	1986-02-25	\N		2		Oliver Phelps
96851	1986-02-25	\N		2		James Phelps
234934	1987-01-08	\N	From Wikipedia, the free encyclopedia. \n\n Freddie Stroma (born January 8, 1987) is an English actor and model, best known for playing Cormac McLaggen in the Harry Potter film series. \n\n  Description above from the Wikipedia article Freddie Stroma, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	 London, England, UK	Freddie Stroma
11184	1970-02-03	\N	From Wikipedia, the free encyclopedia. Warwick Ashley Davis (born 3 February 1970) is an English actor. Davis is known for playing the title characters in Willow and the Leprechaun series of films; other prominent roles include Wicket W. Warrick in Star Wars Episode VI: Return of the Jedi, Professor Filius Flitwick and Griphook in the Harry Potter movies, Marvin the Paranoid Android in The Hitchhiker's Guide to the Galaxy, as well as Nikabrik in the Walden Media version of Prince Caspian and Reepicheep in the BBC television versions of Prince Caspian and Voyage of the Dawn Treader and Mr Glimfeather the owl in The Silver Chair. Davis has a condition resulting in dwarfism, and stands at 3 ft 6 in (1.07 m) tall.\n\nDescription above from the Wikipedia article Warwick Davis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Epsom - Surrey - England - UK	Warwick Davis
11180	1942-04-17	\N	David Bradley is an English character actor. He has recently become known for playing the caretaker of Hogwarts, Argus Filch, in the Harry Potter series of films.\n\nBradley was born in York, England. He became an actor in 1971, first appearing on television that year in the successful comedy Nearest and Dearest playing a police officer. He was awarded a Olivier Award in 1991 for his supporting actor role in King Lear at the Royal National Theatre.\n\nBradley appeared in Nicholas Nickleby (2002) and had a small role in the 2007 comedy film Hot Fuzz as a farmer who illegally hoarded weapons, including a sea mine which later proves important to the story.	2	York, North Yorkshire, England, UK	David Bradley
11207	1963-03-20	\N	​From Wikipedia, the free encyclopedia.  \n\nDavid Thewlis (born 20 March 1963) is an English film, television and stage character actor, as well as a writer.\n\nDescription above from the Wikipedia article David Thewlis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Blackpool, Lancashire, England, UK	David Thewlis
3300	1984-11-01	\N		1	 London, England	Natalia Tena
20999	1959-08-22	\N		2		Mark Williams
964834	1991-04-21	\N	(* 21. April 1991 in England) ist ein britischer Schauspieler.  Er ist der Sohn des Schauspielers Stephen Dillane. Dillane verkörpert im Film Harry Potter und der Halbblutprinz den 16-jährigen Tom Riddle. Dies ist seine zweite Filmrolle, nachdem er 1997 in dem Kriegsfilm Welcome to Sarajevo mitgespielt hatte. Seit 2015 ist er in der Serie Fear the Walking Dead zu sehen.	2	England	Frank Dillane
1114487	1997-11-06	\N		0		Hero Fiennes-Tiffin
9138	1942-12-04	\N		1	London, United Kingdom	Gemma Jones
234926	1988-02-12	\N		1	Manchester, England	Afshan Azad
234925	1988-06-20	\N	​Shefali Chowdhury (born 20 June, 1988) is a Welsh actress originally from Denbigh, Wales. She was brought up in a Muslim family, along with five siblings, of whom she is the youngest. Shefali is of Bengali origin; her parents immigrated to England from Sylhet, Bangladesh in the 1980s, when many Bengalis migrated to the UK. She plays Harry Potter's Yule Ball date, Parvati Patil, in Harry Potter and the Goblet of Fire. Daniel Radcliffe, who plays Harry Potter in the film, spoke at the launch of Goblet of Fire in London and said, "I had a dance scene with Shefali. She was completely gorgeous."  \n\n  She also appeared in an uncredited role in a Tamil film Kannathil Muthamittal.  \n\n  Shefali landed the coveted role of Parvati Patil whilst she was still a student in her final year at Waverley School in Birmingham. She did four A Levels, in English Language, Literature, Sociology, and Religious Studies at The Sixth Form College, Solihull. Her studies coincided with shooting of the current instalment of Harry Potter and the Order of the Phoenix, where she reprised her role as Parvati Patil.  \n\n  Despite Parvati's relatively small role in the book, Chowdhury was able to reprise her role for film adaptation of Harry Potter and the Half-Blood Prince.[1]. She did not, however, appear in either part of the adaptation of Harry Potter and the Deathly Hallows.  \n\n  She is currently studying Photography in Birmingham, UK. \n\n((Biography from the Harry Potter Wiki))	0	Denbigh, Wales	Shefali Chowdhury
174398	1990-02-28	\N		0		Georgina Leonidas
234922	1988-10-28	\N		2		Devon Murray
234929	1992-03-15	\N		1		Anna Shaffer
6588	1952-06-18	\N	Isabella Fiorella Elettra Giovanna Rossellini (born 18 June 1952) is an Italian actress, filmmaker, author, philanthropist, and model. Rossellini is noted for her 14-year tenure as a Lancôme model, and for her roles in films such as Blue Velvet and Death Becomes Her.\n\n​From Wikipedia, the free encyclopedia.	1	Rome - Lazio - Italy	Isabella Rossellini
4434	1946-11-04	\N	Frederick Elmes, A.S.C. (born November 4, 1946) is an American cinematographer who has won the Independent Spirit Award for Best Cinematography twice, for Wild at Heart and Night on Earth. Born in Mountain Lakes, New Jersey, Elmes studied photography at the Rochester Institute of Technology, then attended the American Film Institute in Los Angeles, graduating in 1972. He enrolled in the Graduate Film Program at New York University's Department of Film and Television and graduated in 1975. At the American Film Institute, Elmes met aspiring film director David Lynch, who hired him for Eraserhead. Since then the two have collaborated on such films as Blue Velvet, and Wild at Heart.	2	Mountain Lakes, New Jersey, USA	Frederick Elmes
6592	1952-11-17	\N		2	Los Angeles County, California, USA	Duwayne Dunham
6677	1959-02-22	\N	From Wikipedia, the free encyclopedia.\n\nKyle Merritt MacLachlan (/məˈɡlɑːklən/; born February 22, 1959) is an Americanactor. MacLachlan is best known for his roles in cult films such as Blue Velvet as Jeffrey Beaumont, The Hidden as Lloyd Gallagher, as Zack Carey in Showgirls and as Paul Atreides in Dune. He has also had prominent roles in television shows including appearing as Special Agent Dale Cooper in Twin Peaks, Trey MacDougal in Sex and the City, Orson Hodge in Desperate Housewives, The Captain in How I Met Your Mother, and as the Mayor of Portland in Portlandia.\n\nEarly life\n\nMacLachlan was born in Yakima, Washington. His mother, Catherine (née Stone), was a public relations director, and his father, Kent Alan MacLachlan, was a stockbroker and lawyer. He has Scottish, Cornish and German ancestry. He has two younger brothers named Craig and Kent, both of whom live in the Pacific Northwest. MacLachlan graduated from Eisenhower High School in 1977. He graduated from the University of Washington in 1982 and, shortly afterward, moved to Hollywood, California to pursue his career.	2	Yakima - Washington - USA	Kyle MacLachlan
2778	1936-05-17	2010-05-29	Dennis Lee Hopper (May 17, 1936 – May 29, 2010) was an American actor, filmmaker and artist. As a young man, Hopper became interested in acting and eventually became a student of the Actors' Studio. He made his first television appearance in 1954, and appeared in two films featuring James Dean, Rebel Without a Cause (1955) and Giant (1956). During the next 10 years, Hopper appeared frequently on television in guest roles, and by the end of the 1960s had played supporting roles in several films. He directed and starred in Easy Rider (1969), winning an award at the Cannes Film Festival and was nominated for an Academy Award for Best Original Screenplay as co-writer. "With its portrait of counterculture heroes raising their middle fingers to the uptight middle-class hypocrisies, Easy Rider became the cinematic symbol of the 1960s, a celluloid anthem to freedom, macho bravado and anti-establishment rebellion." Film critic Matthew Hays notes that "no other persona better signifies the lost idealism of the 1960s than that of Dennis Hopper." He was unable to build on his success for several years, until a featured role in Apocalypse Now (1979) brought him attention. He subsequently appeared in Rumble Fish (1983) and The Osterman Weekend (1983), and received critical recognition for his work in Blue Velvet and Hoosiers, with the latter film garnering him an Academy Award nomination for Best Supporting Actor. He directed Colors (1988) and played the villain in Speed (1994). Hopper's later work included a leading role in the television series Crash. Hopper's last performance was filmed just before his death: The Last Film Festival, slated for a 2011 release. Hopper was also a prolific and acclaimed photographer, a profession he began in the 1960s.\n\nDescription above from the Wikipedia article Dennis Hopper, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dodge City - Kansas - USA	Dennis Hopper
4784	1967-02-10	\N	Laura Elizabeth Dern (born February 10, 1967) is an American actress, film director and producer. Dern has acted in such films as Smooth Talk (1985), Blue Velvet (1986), Fat Man and Little Boy (1988), Wild at Heart (1990), Jurassic Park (1993) and October Sky (1999). She has won awards for her performance in the 1991 film Rambling Rose, for which she received an Academy Award nomination for Best Actress in a Leading Role. She was awarded a Golden Globe Award for Best Supporting Actress – Series, Miniseries or Television Film for her portrayal of Florida Secretary of State Katherine Harris in the film Recount (2008).\n\nDescription above from the Wikipedia article Laura Dern, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Los Angeles, California, USA	Laura Dern
3382	1933-11-28	2003-12-19	From Wikipedia, the free encyclopedia.\n\nHope Lange (November 28, 1933 – December 19, 2003) was an American film, stage, and television actress.\n\nLange was nominated for the Best Supporting Actress Golden Globe and the Academy Award for Best Supporting Actress for her portrayal of Selena Cross in the 1957 film Peyton Place. In 1969 and 1970, she won the Primetime Emmy Award for Outstanding Lead Actress in a Comedy Series for her role as Carolyn Muir in the sitcom The Ghost &amp; Mrs. Muir.\n\nDescription above from the Wikipedia article Hope Lange, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Redding, Connecticut, USA	Hope Lange
923	1936-03-05	\N	Dean Stockwell (born March 5, 1936) is an American actor of film and television, active for over 60 years. He played Rear Admiral Albert "Al" Calavicci in the NBC television series Quantum Leap and in the Sci Fi Channel revival of Battlestar Galactica as Brother Cavil.\n\nDescription above from the Wikipedia article Dean Stockwell, licensed under CC-BY-SA, full list of contributors on Wikipedia. ​	0	North Hollywood - California - USA	Dean Stockwell
11792	1933-07-25	\N		0		George Dickerson
11793	1924-05-18	\N		0		Priscilla Pointer
11794	1919-01-23	2011-09-15	​From Wikipedia, the free encyclopedia.  \n\nFrances Goffman Bay (born January 23, 1919) is a Canadian-born United States-based character actress known for playing a variety of quirky elderly women on film and television.\n\nDescription above from the Wikipedia article Frances  Bay  , licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Winnipeg, Manitoba, Canada	Frances Bay
11796	\N	\N		0		Ken Stovitz
1370	1950-03-18	\N	From Wikipedia, the free encyclopedia\n\nBradford Claude "Brad" Dourif (born March 18, 1950) is an American film and television actor who gained early fame for his portrayal of Billy Bibbit in One Flew Over the Cuckoo's Nest, and has since appeared in a number of memorable roles, including the voice of Chucky in the Child's Play franchise, Younger Brother in Ragtime, the mentat Piter De Vries in David Lynch's Dune, Gríma Wormtongue in The Lord of the Rings, the homicidal Betazoid Lon Suder in the TV series Star Trek: Voyager, serial killer Charles Dexter/Brother Edward in the acclaimed science fiction television series Babylon 5, and Doc Cochran in the HBO television series Deadwood. Dourif has also worked with renowned film director Werner Herzog at many occasions, appearing in Scream of Stone, The Wild Blue Yonder, Bad Lieutenant: Port of Call New Orleans and My Son, My Son, What Have Ye Done?	2	Huntington, West Virginia, USA	Brad Dourif
6718	1943-12-21	1996-12-30	From Wikipedia, the free encyclopedia.\n\nMarvin John Nance (December 21, 1943 – December 30, 1996), known professionally as Jack Nance and occasionally credited as John Nance, was an American actor of stage and screen, primarily starring in offbeat or avant-garde productions. He was known for his work with director David Lynch, particularly for his roles in Eraserhead, Blue Velvet and Twin Peaks.\n\nDescription above from the Wikipedia article Jack Nance, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Boston, Massachusetts, USA	Jack Nance
11797	\N	\N		0		J. Michael Hunter
11798	\N	\N		0		Selden Smith
1599429	\N	\N		0		Jack Harvey
5602	1946-01-20	\N	From Wikipedia, the free encyclopedia\n\nDavid Keith Lynch (born January 20, 1946) is an American filmmaker, television director, visual artist, musician and occasional actor. Known for his surrealist films, he has developed his own unique cinematic style, which has been dubbed "Lynchian", and which is characterized by its dream imagery and meticulous sound design. Indeed, the surreal and in many cases violent elements to his films have earned them the reputation that they "disturb, offend or mystify" their audiences.\n\nMoving around various parts of the United States as a child within his middle class family, Lynch went on to study painting in Philadelphia, where he first made the transition to producing short films. Deciding to devote himself more fully to this medium, he moved to Los Angeles, where he produced his first motion picture, the surrealist horror Eraserhead (1977). After Eraserhead became a cult classic on the midnight movie circuit, Lynch was employed to direct The Elephant Man (1980), from which he gained mainstream success. Then being employed by the De Laurentiis Entertainment Group, he proceeded to make two films. First, the science-fiction epic Dune (1984), which proved to be a critical and commercial failure, and then a neo-noir crime film, Blue Velvet (1986), which was highly critically acclaimed.\n\nProceeding to create his own television series with Mark Frost, the highly popular murder mystery Twin Peaks (1990–1992), he also created a cinematic prequel, Fire Walk With Me (1992), a road movie, Wild at Heart (1990), and a family film, The Straight Story (1999) in the same period. Turning further towards surrealist filmmaking, three of his following films worked on "dream logic" non-linear narrative structures, Lost Highway (1997), Mulholland Drive (2001) and Inland Empire (2006).\n\nLynch has received three Academy Award nominations for Best Director, for his films The Elephant Man, Blue Velvet and Mulholland Drive, and also received a screenplay Academy Award nomination for The Elephant Man. Lynch has twice won France's César Award for Best Foreign Film, as well as the Palme d'Or at the Cannes Film Festival and a Golden Lion award for lifetime achievement at the Venice Film Festival. The French government awarded him the Legion of Honor, the country's top civilian honor, as a Chevalier in 2002 and then an Officier in 2007, while that same year, The Guardian described Lynch as "the most important director of this era". Allmovie called him "the Renaissance man of modern American filmmaking", whilst the success of his films have led to him being labelled "the first popular Surrealist.\n\nDescription above from the Wikipedia article David Lynch, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Missoula, Montana, USA	David Lynch
11789	\N	\N		0		Fred C. Caruso
11790	\N	\N		0		Richard A. Roth
5628	1937-03-22	\N	​Angelo Badalamenti is an acclaimed and prolific composer who has written some of the most unique film scores of our time. He is widely known for his long-standing collaboration with the director David Lynch, which has produced a creative and inspired body of work.  \n\n  In addition to his music for film, Badalamenti has written distinctive themes for the television series "Twin Peaks" and "Inside the Actors Studio", as well as "The Flaming Arrow" Torch Theme for The Summer Olympic Games in Barcelona. He has collaborated with recording artists David Bowie, Paul McCartney, Pet Shop Boys, Tim Booth, Anthrax, LL Cool J, Michael Jackson, Nancy Wilson, Nina Simone, Della Reese, Mel Tillis, Julee Cruise, Marianne Faithfull, Dolores O'Riordan, Liza Minelli, Roberta Flack and countless others.  \n\n  Born in Brooklyn, New York, Badalamenti studied composition, French horn and piano at the Eastman School of Music and the Manhattan School of Music, where he received a Masters degree. Following his classical training, he worked for five years as a music teacher in Dyker Heights, Brooklyn, while spending summers performing as a pianist for shows. During this period he was also a busy songwriter and orchestrator for many popular performers.  \n\n  Angelo Badalamenti began working in film with his scores for Law and Disorder and Gordon's War. In 1986, he was hired by a young David Lynch to be Isabella Rossellini's vocal coach for Blue Velvet. Badalamenti ended up scoring the film, writing the feature song "Mysteries of Love" with Lynch, and even appears onscreen in the piano bar scene. His close relationship with Lynch served as a springboard and since Blue Velvet Badalamenti has scored Lynch's films and projects, as well as those of many other preeminent directors.  \n\n  Badalamenti has received a Grammy Award for his theme to the groundbreaking TV series "Twin Peaks." The Soundtrack Album from Twin Peaks has achieved gold status in 25 countries. He received an Independent Spirit Award and a Saturn Award for Twin Peaks: Fire Walk With Me and BAFTA's Anthony Asquith Award for his score for The Comfort of Strangers.  \n\n  Badalamenti has received Golden Globe nominations for The Straight Story and Mulholland Drive, three Emmy Award nominations for Twin Peaks, two César Award nominations for A Very Long Engagement and The City of Lost Children, BAFTA and AFI award nominations for Mulholland Drive and an American Video Conference award for Best Original Score for Industrial Symphony #1.  \n\n  Badalamenti received both the Composer of the Year Award in 2005 and the Lifetime Achievement Award in 2008 from the Flanders Film Festival: World Soundtrack Awards. In the summer of 2011, Angelo was honored at the ASCAP Film and Television Awards at the Beverly Hilton Hotel in Los Angeles. There, in the same ballroom where the Golden Globes are held each year, he was presented with the Henry Mancini Lifetime Achievement award and gave a live performance of his selected works.  \n\n  Most recently, Badalamenti has completed a stunning new score for the indie feature, A Late Quartet, a moving drama about the lives of four musicians as they prepare for an upcoming performance of Beethoven's Streichquartett in C# minor, Op. 131 and he's presently composing the score for a new 3D film entitled Stalingrad.	0	New York, City, New York, USA	Angelo Badalamenti
8971	\N	\N		0		Pat Golden
3686	\N	\N		0		Johanna Ray
2076	1941-07-29	\N	​From Wikipedia, the free encyclopedia David Warner (born 29 July 1941) is an English actor, who is known for playing sinister or villainous characters, both in film and animation. Description above from the Wikipedia David Warner (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Manchester, England, UK	David Warner
14463	1951-02-13	\N	From Wikipedia, the free encyclopedia.  \n\nDavid Walsh Naughton (born February 13, 1951) is an American actor and singer best known for his starring roles in the 1981 horror film An American Werewolf in London and the 1980 Walt Disney comedy, Midnight Madness.\n\nDescription above from the Wikipedia article David Walsh Naughton  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hartford, Connecticut, USA	David Naughton
14464	1952-12-20	\N	Jennifer Ann "Jenny" Agutter (born 20 December 1952) is an English film and television actress. She began her career as a child actress in the mid 1960s, starring in the BBC television series The Railway Children and the film adaptation of the same book, before moving on to adult roles and relocating to Hollywood.\n\nShe played Alex Price in An American Werewolf in London, Jessica 6 in Logan's Run, Joanne Simpson in Child's Play 2 and Jill Mason in Equus. Since the 1990s, she has worked in sound recording, and she is a patron of the Cystic Fibrosis Trust. After a break from acting she has appeared in several television series since 2000, including the British series Spooks and Call the Midwife.\n\nDescription above from the Wikipedia article Jenny Agutter, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Taunton, Somerset, England, UK	Jenny Agutter
2171	1955-06-08	\N	Griffin Dunne (born June 8, 1955) is an American actor and film director, known for his roles in An American Werewolf in London (1981) and After Hours (1985).	0	New York City, New York, USA	Griffin Dunne
14465	1929-07-21	\N	From Wikipedia, the free encyclopedia.  \n\nJohn Woodvine (born 21 July 1929) is an English stage and screen actor who has appeared in more than 70 theatre productions, as well as a similar number of television and film roles.\n\nDescription above from the Wikipedia article John Woodvine licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Tyne Dock, South Shields, County Durham, England	John Woodvine
14466	1929-11-07	\N		1		Lila Kaye
14467	\N	\N		2		Joe Belcher
939	\N	\N	From Wikipedia, the free encyclopedia.\n\nDavid Schofield is an English actor who born in Manchester, Lancashire in 1951. He has appeared in numerous television programmes and feature films during his career.\n\nDescription above from the Wikipedia article David Schofield (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Manchester, Lancashire, UK	David Schofield
14470	\N	\N		2		Sean Baker
14468	1934-04-02	1997-07-24		2	Sheffield, South Yorkshire, England, UK	Brian Glover
14469	1958-03-07	2014-06-09	From Wikipedia, the free encyclopedia\n\nRichard Michael "Rik" Mayall (born 7 March 1958) was an English comedian, writer, and actor. He was known for his comedy partnership with Adrian Edmondson, his over-the-top, energetic portrayal of characters, and as a pioneer of alternative comedy in the early 1980s.\n\nDescription above from the Wikipedia article Rik Mayall, licensed under CC-BY-SA, full list of contributors on Wikipedia. ​	0	Harlow, Essex, England	Rik Mayall
14471	\N	\N		2		Paddy Ryan
14472	\N	\N		1		Anne-Marie Davies
7908	1944-05-25	\N	From Wikipedia, the free encyclopedia.\n\nFrank Oz (born Richard Frank Oznowicz; May 25, 1944) is a British-born American film director, actor, voice actor and puppeteer who is known for creating and performing the characters Miss Piggy and Fozzie Bear in The Muppet Show and for directing films, including the 1986 Little Shop Of Horrors remake and Dirty Rotten Scoundrels. He is also the operator and voice of Yoda in the Star Wars series.\n\nDescription above from the Wikipedia article Frank Oz, licensed under CC-BY-SA, full list of contributors on Wikipedia .	2	Hereford, Herefordshire, England, United Kingdom 	Frank Oz
14759	1937-12-19	\N		2	Sri Lanka	Albert Moses
178097	1929-11-14	2005-12-19		2	Carlisle, UK	Don McKillop
199977	1941-07-07	\N		2	Edinburgh, Scotland, UK	Paul Kember
1660002	\N	\N		2		Colin Fernandes
55983	1936-09-24	1990-05-16	Jim Henson was an American film director, television producer and puppeteer, best known as the creator of The Muppets.	2	Greenville, Mississippi, USA	Jim Henson
1660000	\N	\N		0		Michele Brisigotti
1319052	\N	\N		2		Mark Fisher
185033	1923-01-16	\N		2		Gordon Sterne
1220068	\N	\N		1		Paula Jacobs
1660009	\N	\N		1		Claudine Bowyer
1660013	\N	\N		1		Johanna Crayden
1660014	1952-10-04	\N	Nina Carter (born 4 October 1952) is an English former 1970s Page Three  girl and occasional singer. She currently runs an image consultancy and  works as a life coach.\n\nCarter had a cameo in the movie An American Werewolf in London featuring  in a television advertisement for a kiss-and-tell article ('The Secrets  of Naughty Nina') in The News of The World prior to David's first  'transformation' into the titular beast. She formed a musical duo,  Blonde on Blonde, with Jilly Johnson which was successful in Japan.\n\nCarter married former Yes keyboard player Rick Wakeman in 1984, and they  divorced in 2004. Carter has two children with Wakeman: Jemma Kiera (b.  1983) and Oscar (b. 1986). Having overcome drug addiction and anorexia,  she now runs her own image consultancy and life coach business. She  married plastic surgeon Douglas Harrison in June 2010.	1	Solihull, Warwickshire, England, UK	Nina Carter
1226747	1948-12-04	1987-09-30		2	London, UK	Geoffrey Burridge
1587192	\N	\N		1	Eton, Buckinghamshire, England, UK	Brenda Cavendish
1660018	1945-03-09	2014-10-29		2		Christopher Scoular
1641515	\N	\N		1		Mary Tempest
1328287	\N	\N		1		Cynthia Powell
12693	1909-07-24	1987-08-14	Sydney Bromley (24 July 1909 – 14 August 1987) was an English actor. He appeared in more than sixty films and television programmes. On stage, he appeared in the 1924 premiere of Saint Joan, by George Bernard Shaw, as well as the 1957 film of the same name. He appeared in A Midsummer Night's Dream and Twelfth Night during the summer of 1935 at the Open Air Theatre in London.	2	London,  England	Sydney Bromley
42416	1909-08-28	1983-04-22	​From Wikipedia, the free encyclopedia.  \n\nLamberto Maggiorani (28 August 1909; Rome – 22 April 1983; Rome) was an Italian actor notable for his portrayal of Antonio Ricci in Ladri di Biciclette ("Bicycle Thieves"). He was a factory worker (he worked as a turner) and non-professional actor at the time he was cast in this film. After he became famous by his performance in Ladri di Biciclette, he also found himself being unemployed and this forced him to become a full-time actor.\n\nDescription above from the Wikipedia article  Lamberto Maggiorani, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Rome	Lamberto Maggiorani
299082	1913-04-08	1992-09-11	Francis Ethlebert Singuineau (April 8, 1913 - September 11, 1992), known as Frank Singuineau, was a Trinidadian actor of stage and screen who worked in Britain, where he moved from Trinidad and Tobago in the 1940s.\n\nEmployed by the Shell Company, he took an active interest in Amateur Dramatics. Just after the Second World War he gave up his job with Shell, travelled to London and became an actor, acting with the Unity Theatre and the Bristol Old Vic.[1] His London stage debut was in 1948 in Richard Wright's Native Son (1948), and Singuineau's acting career spanned the subsequent decades until his last roles in Lillian Hellman's Watch on the Rhine at the Royal National Theatre and Mustapha Matura's Playboy of the West Indies at the Tricycle Theatre in 1984.\n\nSinguineau also appeared in such films as The Pumpkin Eater, Séance on a Wet Afternoon, Pressure and An American Werewolf in London and in several television series including Z-Cars, Crane, and Doomwatch.\n\nSinguineau retired in the late 1980s. He died on 11 September 1992 in London, England at the age of 79.	2	Port of Spain, Trinidad, Trinidad and Tobago	Frank Singuineau
1660159	\N	\N		2		Will Leighton
1660178	\N	\N		2		Bob Babenia
199055	1947-06-29	\N	Michael Carter (born 29 June 1947) is a Scottish actor of film, stage andtelevision.	2	Dumfries - Scotland - UK	Michael Carter
2094	1904-06-26	1964-03-23	From Wikipedia, the free encyclopedia.\n\nPeter Lorre (26 June 1904 – 23 March 1964) was an Austrian-American actor frequently typecast as a sinister foreigner.\n\nHe caused an international sensation in 1931 with his portrayal of a serial killer who preys on little girls in the German film M. Later he became a popular featured player in Hollywood crime films and mysteries, notably alongside Humphrey Bogart and Sydney Greenstreet, and as the star of the successful Mr. Moto detective series.\n\nDescription above from the Wikipedia article Peter Lorre, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Rózsahegy (now Ružomberok), Austria-Hungary (now Slovakia)	Peter Lorre
12322	1894-12-15	1985-10-22	.	0	Biel/Bienne, Switzerland Switzerland	Ellen Widmann
12323	1922-11-23	1986-05-28	Inge Landgut war eine deutsche Schauspielerin und Synchronsprecherin.\n\nDie Tochter des Kraftfahrers Wilhelm Landgut und seiner Ehefrau Gertrud stand bereits im Alter von drei Jahren vor der Kamera und wirkte als Kinderdarstellerin in knapp 30 Stummfilmen sowie frühen Tonfilmen mit. Hervorzuheben sind dabei ihre Auftritte als Pony Hütchen in der ersten Verfilmung von Emil und die Detektive nach Erich Kästner und als Opfer des Kindermörders in Fritz Langs M.\n\nNach dem Schulabschluss am Gymnasium absolvierte sie die Schauspielschule des Deutschen Theaters Berlin und erhielt Schauspielunterricht von Agnes Windeck. Theaterengagements in Eisenach (1939–1941), Karlsruhe (1941–1944) und Berlin folgten. In späteren Jahren spielte sie vor allem in Fernsehserien und Mehrteilern wie Tadellöser &amp; Wolff nach Walter Kempowski sowie der Fortsetzung Ein Kapitel für sich.\n\nWährend ihre Auftritte in Film- und Fernsehproduktionen seit den 50er Jahren seltener wurden, arbeitete sie ab 1951 umfangreich in der Synchronisation. Dabei lieh sie ihre Stimme bekannten Kolleginnen wie Olivia de Havilland (Verschollen im Bermuda-Dreieck), Barbara Bel Geddes (in der Serie Dallas; nach Landguts Tod übernahm Edith Schneider diese Rolle), Angie Dickinson (Bei Madame Coco), Sophia Loren (Das Gold von Neapel), „Miss Moneypenny“ Lois Maxwell (in Diamantenfieber und Im Geheimdienst Ihrer Majestät), Esther Williams (Sturm über Eden), Shelley Winters (Die größte Geschichte aller Zeiten oder in ihrer Oscar-nominierten Rolle in Die Höllenfahrt der Poseidon) oder als erste Sprecherin der Wilma in der Zeichentrickserie Familie Feuerstein.\n\nVerschiedentlich lieh sie ihre Stimme auch Figuren in Zeichentrickfilmen Walt Disneys, darunter in den deutschen Fassungen von Dumbo, Susi und Strolch und 101 Dalmatiner. Außerdem synchronisierte sie Hermione Baddeley in Mary Poppins.	0	Berlin - Germany	Inge Landgut
12324	1893-09-30	1965-11-07	​From Wikipedia, the free encyclopedia.  \n\nOtto Karl Robert Wernicke (30 September 1893, Osterode am Harz – 7 November 1965) was a German actor. He was best known for his role as police inspector Karl Lohmann in the two Fritz Lang films M and The Testament of Dr. Mabuse. He was the first one to portray Captain Smith in the first "official" Titanic film.\n\nWernicke was married to a Jewish woman. Only due to a special permit was he allowed to continue his work in Nazi Germany.\n\nDescription above from the Wikipedia article Otto Wernicke  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Osterode am Harz	Otto Wernicke
79	1883-05-18	1954-06-27		0	Zwingenberg	Theodor Loos
12325	1899-12-22	1963-10-07		0		Gustaf Gründgens
12326	1892-11-13	1958-05-08		0		Friedrich Gnaß
28068	1890-01-31	1955-05-06	Fritz Odemar war verheiratet mit der Schauspielerin Erika Nymgau und ist  Vater des Schauspielers und Regisseurs Erik Ode	0	Hannover	Fritz Odemar
219738	1896-05-20	1953-08-13		0	Godesberg	Paul Kemp
28066	1903-06-10	1978-11-10	Theo Lingen (* 10. Juni 1903 in Hannover; † 10. November 1978 in Wien; eigentlich Franz Theodor Schmitz) war ein deutscher Schauspieler, Regisseur und Buchautor. Er war seit 1928 mit der Sängerin Marianne Zoff verheiratet, der ersten Frau Bertolt Brechts.	0	Hannover	Theo Lingen
2913	1898-01-08	1986-12-23	Gerhard Max Richard Bienert war ein deutscher Schauspieler, der in zahlreichen Kino- und Fernsehfilmen mitspielte.	0	Berlin - Germany	Gerhard Bienert
68	1890-12-05	1976-08-02	Friedrich Christian Anton "Fritz" Lang (December 5, 1890 – August 2, 1976) was an Austrian-American filmmaker, screenwriter, and occasional film producer and actor. One of the best known émigrés from Germany's school of Expressionism, he was dubbed the "Master of Darkness" by the British Film Institute. His most famous films are the groundbreaking Metropolis (the world's most expensive silent film at the time of its release) and M, made before he moved to the United States, his iconic precursor to the film noir genre.\n\nDescription above from the Wikipedia article Fritz Lang, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Vienna, Austria-Hungary	Fritz Lang
157	1888-12-27	1954-07-01	From Wikipedia, the free encyclopedia.\n\nThea Gabriele von Harbou (December 27, 1888 – July 1, 1954) was a German actress and author of Prussian aristocratic origin. She was born in Tauperlitz in the Kingdom of Bavaria.\n\nDescription above from the Wikipedia article Thea von Harbou, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Tauperlitz, Germany	Thea von Harbou
9836	1894-12-05	1958-08-18		0	Schmiedefeld am Rennsteig, Germany	Fritz Arno Wagner
11578	1903-10-26	1986-01-13		0		Paul Falkenberg
12319	\N	\N		0		Emil Hasler
12320	\N	\N		0		Karl Vollbrecht
12321	\N	\N		0		Adolf Jansen
13902	\N	\N		0		Seymour Nebenzal
12336	1882-10-10	1977-03-06	From Wikipedia, the free encyclopedia\n\nCarlo Battisti (10 October 1882 - 6 March 1977) was an Italian linguist and actor, famed for his starring role in Vittorio de Sica's Umberto D.\n\nDescription above from the Wikipedia article Carlo Battisti, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Trento, Austria-Hungary (now Trento, Trentino-Alto Adige, Italy)	Carlo Battisti
12338	1911-03-22	\N		0	Bologna, Emilia-Romagna, Italy	Lina Gennari
224209	1935-05-05	2012-04-10	From Wikipedia, the free encyclopedia\n\nMaria-Pia Casilio (5 May 1935 – 10 April 2012) was an Italian film actress, best known for her roles in Umberto D. and Un americano a Roma.\n\nBorn in San Pio delle Camere, L'Aquila, Casilio was pretty active between 1952 and 1960, usually with the typical characterization of a querulous and naive small-town girl, then, after her marriage with the voice actor Giuseppe Rinaldi, she semi-retired from acting. On the Criterion Collection DVD release of Umberto D. Vittorio De Sica comments she was a lucky charm to have her in his films.\n\nDescription above from the Wikipedia article Maria Pia Casilio   licensed under CC-BY-SA, full list of contributors on Wikipedia.  	1	L'Aquila, Italia	Maria Pia Casilio
382	1942-10-26	2014-04-29	From Wikipedia, the free encyclopedia\n\nRobert William "Bob" Hoskins, Jr. (born 26 October 1942 – 29 April 2014) is an English actor, known for playing Cockney rough diamonds, psychopaths and gangsters, in films such as The Long Good Friday (1980), and Mona Lisa (1986), and lighter roles in Who Framed Roger Rabbit (1988) and Hook (1991).	2	Bury St. Edmunds, Suffolk, England, UK	Bob Hoskins
593	1945-08-02	\N	Joanna Cassidy (born August 2, 1945, height 5' 9" (1,75 m)) is an American film and television actress. She is known for her role replicant Zhora in the Ridley Scott's film Blade Runner (1982). She also has starred in films such as Under Fire, The Fourth Protocol, Who Framed Roger Rabbit, The Package, Where the Heart Is and Don't Tell Mom the Babysitter's Dead, Vampire in Brooklyn and Ghosts of Mars.	0	Haddonfield - New Jersey - USA	Joanna Cassidy
12826	1950-08-27	\N	​From Wikipedia, the free encyclopedia\n\nCharles Fleischer (born August 27, 1950) is an American actor, stand-up comedian and voice artist.\n\nDescription above from the Wikipedia article Charles Fleischer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Washington, D.C., United States	Charles Fleischer
3391	1954-06-19	\N	​From Wikipedia, the free encyclopedia.  \n\nMary Kathleen Turner (born June 19, 1954) is an American actress. She came to fame during the 1980s, after roles in the Hollywood films Body Heat, Peggy Sue Got Married, Romancing the Stone, The War of the Roses, Who Framed Roger Rabbit and Prizzi's Honor. She also was a guest star in Californication on Showtime.\n\nDescription above from the Wikipedia article Kathleen Turner, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Springfield, Missouri, USA	Kathleen Turner
12827	1918-11-11	1997-12-14		0		Stubby Kaye
12828	1918-11-05	2003-12-17	Alan Tilvern (5 November 1918 – 17 December 2003) was a British film and television actor with a tough-guy image. He is possibly best known for his role as R.K. Maroon in the film Who framed Roger Rabbit. He was born in Whitechapel, in the East End of London, to Jewish Lithuanian parents, who changed their name from Tilovitch. After leaving school he became a barrow boy in Brick Lane. In the Second World War he served in the Army but was invalided out in 1945	0		Alan Tilvern
12829	1946-07-16	2013-04-15		2		Richard LeParmentier
12830	\N	\N	From Wikipedia, the free encyclopedia\n\nLou Hirsch is an actor, born and raised in Brooklyn, New York, and currently based in the United Kingdom. He studied at the University of Miami and The Guildhall School of Music &amp; Drama in London, UK, with future Star Trek actress Marina Sirtis. He has an extensive list of credits in film, TV, and theater going back over 20 years, and his most recent film role was as Headmaster Widdlesome in Thunderbirds. He also appeared as Arnie Kowalski in the BBC comedy My Hero from 2000 to 2006. He is probably best known as the off-screen voice of Baby Herman in the 1988 film Who Framed Roger Rabbit. Hirsch has recently been seen in the new British American sitcom Episodes as Wallace, the security guard at the complex where the main characters live.\n\nHirsch's first significant television appearance was as Hymie in the 1982 series We'll Meet Again.\n\nHe specialises in playing Americans in English television programmes.\n\nDescription above from the Wikipedia article Lou Hirsch, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, USA	Lou Hirsch
12831	1955-09-20	\N	From Wikipedia, the free encyclopedia\n\nBetsy Brantley (born September 20, 1955) is an American actress.\n\nBrantley was born Rutherfordton, North Carolina. She is the older sister of producer/screenwriter Duncan Brantley, and formerly married to Simon Dutton and Steven Soderbergh.\n\nBetsy studied acting at the Central School of Speech and Drama in the United Kingdom. It was there that she was discovered to film a movie with Sean Connery titled, Five Days One Summer. Like Five Days One Summer, most of her films are based in Europe. Her most famous role, perhaps, is her portrayal of Neely Pritt in the cult classic Shock Treatment. She also played alongside Pierce Brosnan and Michael Caine in the film version of "The Fourth Protocol" and enjoyed a cameo in the Ashley Judd movie "Double Jeopardy". Brantley was also the body double for Jessica Rabbit in Who Framed Roger Rabbit?.\n\nAlong with several other films, Betsy has been a cast member in quite a few television shows. These shows include Tour of Duty and Second Noah. On Tour of Duty, she played the role of Dr. Jennifer Seymour (later "Major Jennifer Seymour"). On Second Noah, she played Jesse Beckett, a veterinarian and the mother of eight adopted children.\n\nBrantley played Dolph Lundgren's girlfriend in Dark Angel (retitled I Come in Peace in America).\n\nShe has also appeared as Elsie Cubitt in the Granada Television production of 'The Dancing Men', from The Adventures of Sherlock Holmes by Sir Arthur Conan Doyle.\n\nDescription above from the Wikipedia article Betsy Brantley, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Rutherfordton, North Carolina	Betsy Brantley
33923	1908-05-30	1989-07-10	From Wikipedia, the free encyclopedia.\n\nMel Blanc (May 30, 1908 – July 10, 1989) was an American voice actor and comedian. Although he began his nearly six-decade-long career performing in radio commercials, Blanc is best remembered for his work with Warner Bros. during the "Golden Age of American animation" (and later for Hanna-Barbera television productions) as the voice of such well-known characters as Bugs Bunny, Daffy Duck, Porky Pig, Sylvester the Cat, Tweety Bird, Foghorn Leghorn, Yosemite Sam, Wile E. Coyote, Woody Woodpecker, Barney Rubble, Mr. Spacely, Speed Buggy, Captain Caveman, Heathcliff, Speedy Gonzales, Elmer Fudd and hundreds of others. Having earned the nickname “The Man of a Thousand Voices,” Blanc is regarded as one of the most influential people in the voice-acting industry.  At the time of his death, it was estimated that 20 million people heard his voice every day.  Description above from the Wikipedia article Mel Blanc, licensed under CC-BY-SA, full list of contributors on Wikipedia .	0	San Francisco, California, U.S.	Mel Blanc
58530	1908-09-13	1998-01-04	From Wikipedia, the free encyclopedia.\n\nMae Questel ( September 13, 1908–January 4, 1998) was an American actress and vocal artist best known for providing the voices for the animated characters, Betty Boop and Olive Oyl. She began in vaudeville, and played occasional small roles in films and television later in her career, most notably the role of Aunt Bethany in 1989's National Lampoon's Christmas Vacation.\n\nDescription above from the Wikipedia article Mae Questel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	The Bronx, New York, USA	Mae Questel
4347	1915-12-12	1998-05-14	From Wikipedia, the free encyclopedia.\n\nFrancis Albert "Frank" Sinatra ( December 12, 1915 – May 14, 1998) was an American singer and actor.\n\nBeginning his musical career in the swing era with Harry James and Tommy Dorsey, Sinatra became a successful solo artist in the early to mid-1940s, being the idol of the "bobby soxers". His professional career had stalled by the 1950s, but it was reborn in 1954 after he won the Academy Award for Best Supporting Actor (for his performance in From Here to Eternity).\n\nHe signed with Capitol Records and released several critically lauded albums (such as In the Wee Small Hours, Songs for Swingin' Lovers, Come Fly with Me, Only the Lonely and Nice 'n' Easy). Sinatra left Capitol to found his own record label, Reprise Records (finding success with albums such as Ring-A-Ding-Ding, Sinatra at the Sands and Francis Albert Sinatra &amp; Antonio Carlos Jobim), toured internationally, was a founding member of the Rat Pack and fraternized with celebrities and statesmen, including John F. Kennedy. Sinatra turned 50 in 1965, recorded the retrospective September of My Years, starred in the Emmy-winning television special Frank Sinatra: A Man and His Music, and scored hits with "Strangers in the Night" and "My Way".\n\nWith sales of his music dwindling and after appearing in several poorly received films, Sinatra retired for the first time in 1971. Two years later, however, he came out of retirement and in 1973 recorded several albums, scoring a Top 40 hit with "(Theme From) New York, New York" in 1980. Using his Las Vegas shows as a home base, he toured both within the United States and internationally, until a short time before his death in 1998.\n\nSinatra also forged a successful career as a film actor, winning the Academy Award for Best Supporting Actor for his performance in From Here to Eternity, a nomination for Best Actor for The Man with the Golden Arm, and critical acclaim for his performance in The Manchurian Candidate. He also starred in such musicals as High Society, Pal Joey, Guys and Dolls and On the Town. Sinatra was honored at the Kennedy Center Honors in 1983 and was awarded the Presidential Medal of Freedom by Ronald Reagan in 1985 and the Congressional Gold Medal in 1997. Sinatra was also the recipient of eleven Grammy Awards, including the Grammy Trustees Award, Grammy Legend Award and the Grammy Lifetime Achievement Award.\n\nDescription above from the Wikipedia article Frank Sinatra, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hoboken, NJ	Frank Sinatra
116100	\N	\N		0		Richard Williams
78076	1947-02-07	2009-05-18	From Wikipedia, the free encyclopedia.\n\nWayne Anthony Allwine (February 7, 1947 – May 18, 2009) was an American voice actor, a sound effects editor and foley artist for The Walt Disney Company. He was born in Glendale, California. He was the voice of Mickey Mouse for 32 years, narrowly the longest to date, and was married to voice actress Russi Taylor.\n\nAllwine was the voice of Mickey Mouse from 1977 until his death in 2009. He succeeded Jimmy MacDonald, who in 1947 had taken over from Walt Disney himself, who had performed the role since 1928 as well as supplying Mickey's voice for animated portions of the original Mickey Mouse Club television show (ABC-TV, 1955–59).\n\nAllwine's first appearance as Mickey was voicing the animated lead-ins for The New Mickey Mouse Club in 1977. His first appearance as Mickey for a theatrical release was in the 1983 featurette Mickey's Christmas Carol. In the same film, he voiced a Santa Claus on the street appealing for charity donations at the start of the movie and the two weasel undertakers in the Christmas future scene.\n\nHe also starred in films such as The Prince and the Pauper (1990), and Mickey, Donald, Goofy: The Three Musketeers (2004), and the TV series Mickey Mouse Works (1999-2000), Disney's House of Mouse (2001-2003), and Mickey Mouse Clubhouse (2006-2009) and Who Framed Roger Rabbit. He has provided Mickey's voice for nearly every entry in the popular Kingdom Hearts series of video games, which was done in collaboration with Japanese video game company Square Enix.\n\nIn addition to his voice work, Allwine had also been a sound effects editor on Disney films and TV shows including Splash (1984) and Three Men and a Baby (1987); as well as Innerspace (1987), Alien Nation (1988) and Star Trek V: The Final Frontier for other studios.\n\nDescription above from the Wikipedia article Wayne Allwine, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Glendale, California, USA	Wayne Allwine
15831	1946-03-12	\N	From Wikipedia, the free encyclopedia. Franklin Wendell "Frank" Welker (born March 12, 1946) is an American actor who specializes in voice acting and has contributed character voices and other vocal effects to American television and motion pictures. As of September 2010, Welker had voiced or appeared in 93 films with a combined gross revenue of $5.7 billion making him the top grossing actor by this standard (and over $800 million ahead of the next highest grossing actor, Samuel L. Jackson). Description above from the Wikipedia article Frank Welker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Denver, Colorado, USA	Frank Welker
24	1951-05-14	\N	From Wikipedia, the free encyclopedia.\n\nRobert Lee Zemeckis (born May 14, 1952) is an American film director, producer and screenwriter. Zemeckis first came to public attention in the 1980s as the director of the comedic time-travel Back to the Future film series, as well as the Academy Award-winning live-action/animation epic Who Framed Roger Rabbit (1988), though in the 1990s he diversified into more dramatic fare, including 1994's Forrest Gump, for which he won an Academy Award for Best Director.\n\nHis films are characterized by an interest in state-of-the-art special effects, including the early use of match moving in Back to the Future Part II (1989) and the pioneering performance capture techniques seen in The Polar Express (2004), Beowulf (2007) and A Christmas Carol (2009). Though Zemeckis has often been pigeonholed as a director interested only in effects, his work has been defended by several critics, including David Thomson, who wrote that "No other contemporary director has used special effects to more dramatic and narrative purpose."\n\nDescription above from the Wikipedia article Robert Zemeckis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chicago, Illinois, USA 	Robert Zemeckis
12821	\N	\N		0		Gary K. Wolf
12100	\N	\N		0		Jeffrey Price
12101	\N	\N		0		Peter S. Seaman
12824	\N	\N	From Wikipedia, the free encyclopedia\n\nDon Hahn (born 1955) is an American film producer who has produced some of the most successful Walt Disney animated films of the past 20 years. He currently owns his own film production company called Stone Circle Pictures.\n\nDescription above from the Wikipedia article Don Hahn, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	Chicago, Illinois	Don Hahn
664	1946-09-13	\N	​From Wikipedia, the free encyclopedia.    Frank Wilton Marshall (born September 13, 1946) is an American film producer and director, often working in collaboration with his wife, Kathleen Kennedy. With Kennedy and Steven Spielberg, he was one of the founders of Amblin Entertainment. He is a partner with Kennedy in The Kennedy/Marshall Company, a film production company formed in 1991, which signed a new contract with Columbia Pictures effective April 1, 2009 and in force through to October 31, 2011.  Description above from the Wikipedia article Frank Marshall (film producer), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles, California, USA	Frank Marshall
30	\N	\N		0		Steve Starkey
711	\N	\N		0		Robert Watts
1060	1946-03-12	\N	From Wikipedia, the free encyclopedia.  Dean Raymond Cundey, A.S.C.  (born 12 March 1946) is an American cinematographer.\n\nDescription above from the Wikipedia article Dean Cundey, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Alhambra, California	Dean Cundey
38	\N	\N		0		Arthur Schmidt
12825	\N	\N		0		Roger Cain
715	1915-07-19	1993-10-29		0		Elliot Scott
1143354	\N	\N		0		Frank Tudisco
1450331	\N	\N	British character animator. He was first known for his work on several Walt Disney Animation Studios films, including various characters in Who Framed Roger Rabbit, Rafiki in The Lion King, Belle in Beauty and the Beast, and Quasimodo in The Hunchback of Notre Dame.  After Notre Dame, Baxter moved over to DreamWorks Animation, where he worked on films such as The Prince of Egypt, The Road to El Dorado, Spirit: Stallion of the Cimarron, Shrek 2 and Madagascar. Early in 2005, Baxter left DreamWorks and set out on his own as an independent animator. He became the head of his own studio, James Baxter Animation, in Pasadena, California, where he has directed the animation for the 2007 film Enchanted and the opening credits to Kung Fu Panda, for which he received an Annie Award. As of the summer of 2008, James Baxter Animation has closed and Baxter has returned once again to DreamWorks Animation as a supervising animator.\n\nBaxter has also worked on Tummy Trouble, How to Train Your Dragon and The Croods.\n\nIn May 2013, Baxter was a guest animator for an episode of Adventure Time entitled "James Baxter the Horse".The episode's story focused on the lead characters trying to emulate a  horse who can cheer everyone up by neighing his name (James Baxter) and  balancing on a beach ball. Both the horse's animation (which is visually  distinct from the other characters) and voice were provided by Baxter.  The episode's title card features a drawing of the horse drawing a horse  on a beach ball, while sitting at an animation table. -Wikipedia	0	Bristol - England - UK	James Baxter
13534	\N	\N		0		Julia Martinek
13535	\N	\N		0		David Hoppe
13536	\N	\N		0		Fedor Hoppe
13537	\N	\N		0		Uwe Müller
13538	1923-10-22	\N		2		Hans Beerhenke
13539	1949-08-19	\N		0		Erika Skrotzki
13540	1941-01-04	\N		0		Barbara Stanek
13541	1939-05-17	2015-10-09		2	Berlin, Germany	Andreas Mannkopff
13542	\N	\N		0		Jockel List
13543	\N	\N		0		Julian Moscherosch
13527	\N	\N		0		Arend Agthe
13529	\N	\N		0		Gudrun Ruzicková-Steiner
13531	\N	\N		0		Martin Cyrus
13532	\N	\N		0		Matthias Raue
5639	\N	\N		0		Jürgen Jürges
13533	\N	\N		0		Yvonne Kölsch
13544	\N	\N		0		Michael Smeaton
13545	\N	\N		0		Jochen Hergersberg
13546	\N	\N		0		Tomas Bergfelder
4818	1952-10-27	\N	From Wikipedia, the free encyclopedia\n\nRoberto Remigio Benigni Pronunciation., Knight Grand Cross OMRI (born 27 October 1952) is an Italian actor, comedian, screenwriter and director of film, theatre and television.\n\nDescription above from the Wikipedia article Roberto Benigni, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Manciano La Misericordia, Castiglion Fiorentino, Arezzo, Italia	Roberto Benigni
3214	1955-12-06	\N	From Wikipedia, the free encyclopedia.  \n\nSteven Alexander Wright (born December 6, 1955) is an American comedian, actor and writer. He is known for his distinctly lethargic voice and slow, deadpan delivery of ironic, philosophical and sometimes nonsensical jokes and one-liners with contrived situations.\n\nDescription above from the Wikipedia article Steven Wright, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Steven Wright
13602	1962-06-22	\N	From Wikipedia, the free encyclopedia\n\nJoie Susannah Lee (born June 22, 1962) is an American screenwriter, film producer, film director and actress. She has appeared in many of the films directed by her brother, Spike Lee, including She's Gotta Have It (1986), School Daze (1988), Do the Right Thing (1989), and Mo' Better Blues (1990). She also wrote and produced the film Crooklyn.\n\nLee was born in Brooklyn, New York, the daughter of Jacqueline (née Shelton), a teacher of arts and black literature, and William James Edward Lee III, a jazz musician, bassist, actor and composer.\n\nDescription above from the Wikipedia article Joie Lee, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York City, New York, USA	Joie Lee
13603	\N	\N		0	Brooklyn, New York City, New York, USA	Cinqué Lee
13604	1947-04-21	\N	From Wikipedia, the free encyclopedia.  \n\nIggy Pop (born James Newell "Jim" Osterberg, Jr.; April 21, 1947) is an American singer, songwriter, musician, and occasional actor. He is considered an influential innovator of punk rock, hard rock, and other styles of rock music. Pop began calling himself "Iggy" after his first band in high school (for which he was drummer), The Iguanas. He was lead singer/songwriter of influential protopunk band The Stooges and became known for his outrageous and unpredictable stage antics.\n\nPop's popularity has ebbed and flowed throughout the course of his subsequent solo career. His best-known songs include "Lust for Life" which was featured on the soundtrack of the film Trainspotting, "Search and Destroy", "I Wanna Be Your Dog", "Down on the Street", Kick It (a duet with Peaches) , the Top 40 hits "Real Wild Child" and "Candy" (with vocalist Kate Pierson of The B-52's), "China Girl" (co-written with and famously covered by David Bowie), and "The Passenger".\n\nDescription above from the Wikipedia article Iggy Pop, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Ann Arbor, Michigan, USA	Iggy Pop
2887	1949-12-07	\N	​From Wikipedia, the free encyclopedia.  \n\nThomas Alan "Tom" Waits (born December 7, 1949) is an American singer-songwriter, composer, and actor. Waits has a distinctive voice, described by critic Daniel Durchholz as sounding "like it was soaked in a vat of bourbon, left hanging in the smokehouse for a few months, and then taken outside and run over with a car." With this trademark growl, his incorporation of pre-rock music styles such as blues, jazz, and vaudeville, and experimental tendencies verging on industrial music, Waits has built up a distinctive musical persona. He has worked as a composer for movies and musical plays and as a supporting actor in films, including Down By Law, Bram Stoker's Dracula and Wristcutters: A Love Story. He was nominated for an Academy Award for his soundtrack work on One from the Heart.\n\nLyrically, Waits' songs frequently present atmospheric portrayals of grotesque, often seedy characters and places – although he has also shown a penchant for more conventional ballads. He has a cult following and has influenced subsequent songwriters despite having little radio or music video support. His songs are best-known to the general public in the form of cover versions by more visible artists: "Jersey Girl", performed by Bruce Springsteen, "Ol' 55", performed by the Eagles, and "Downtown Train", performed by Rod Stewart. Although Waits' albums have met with mixed commercial success in his native United States, they have occasionally achieved gold album sales status in other countries. He has been nominated for a number of major music awards and has won Grammy Awards for two albums, Bone Machine and Mule Variations. In 2010, Waits was chosen to be inducted in the Rock and Roll Hall of Fame in 2011.\n\nWaits currently lives in Sonoma County, California with his wife, Kathleen Brennan, and three children.\n\nDescription above from the Wikipedia article Tom Waits, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Pomona, California, USA	Tom Waits
13605	\N	\N		2	New York, New York City, USA	Joseph Rigano
7168	\N	\N		0		Vinny Vella
13954	1880-01-29	1946-12-25		0		W.C. Fields
13962	1890-01-05	1957-11-17		0		Cora Witherspoon
13963	1903-12-10	1986-01-02	​From Wikipedia, the free encyclopedia\n\nUna Merkel (December 10, 1903 – January 2, 1986) was an American film actress.\n\nDescription above from the Wikipedia article Una Merkel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Covington, Kentucky, U.S.	Una Merkel
13964	\N	\N		0		Evelyn Del Rio
13965	1864-11-05	1944-05-30		0		Jessie Ralph
13966	1889-01-23	1958-07-20		0		Franklin Pangborn
13967	1895-03-11	1955-11-22		2	Brooklyn, New York City, New York, USA	Shemp Howard
13968	1906-04-05	1995-09-17		0		Grady Sutton
13969	1895-06-04	1957-06-01	Tall, distinguished-looking Russell Hicks appeared in almost 300 films in his more than 40-year career (although his first known screen appearance was in 1915, he has screenwriting credits as early as 1913, so it's possible his screen debut was earlier than credited). His cultured bearing, grandfatherly appearance and soothing, resonant voice were perfect for the many military officers, attorneys, judges and business executives he excelled at playing. He was especially memorable in an atypical role as oily, fast-talking phony-stock salesman J. Frothington Waterbury in the W.C. Fields classic The Bank Dick (1940). Hicks made his last film in 1956, and died the next year. by frankfob2@yahoo.com	2	Baltimore, Maryland, USA	Russell Hicks
13970	1908-08-06	1944-04-10	From Wikipedia, the free encyclopedia.\n\nDick Purcell (August 6, 1908 - April 10, 1944) was an American actor best known for playing Marvel Comics' Captain America in the 1943 film serial. The strain of filming Captain America had been too much for his heart and he collapsed in the locker room at a Los Angeles country club.\n\nPurcell was born in Greenwich, Connecticut.\n\nDescription above from the Wikipedia article Dick Purcell, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Greenwich, Connecticut, USA	Dick Purcell
30216	1887-12-29	1960-02-03		0		Pierre Watkin
600741	1892-07-14	1954-07-14		0		Al Hill
103621	\N	\N		0		George Moran
102069	\N	\N		0		Bill Wolfe
120741	1889-09-02	1958-10-15		0		Jack Norton
30243	\N	\N		0		Pat West
34046	1911-06-25	1974-12-11	From Wikipedia, the free encyclopedia.\n\nReed Hadley (June 25, 1911 – December 11, 1974) was an American movie, television and radio actor.\n\nReed Hadley was born Reed Herring in Petrolia in Clay County near Wichita Falls, Texas, to Bert Herring, an oil well driller, and his wife Minnie. Hadley had one sister, Bess Brenner. He was reared in Buffalo, New York. He graduated from Bennett High School in Buffalo and was involved in local theater with the Studio Arena Theater. Hadley and his wife, Helen, had one son, Dale. Before moving to Hollywood, he acted in Hamlet on stage in New York City.\n\nThroughout his thirty-five-year career in film, Hadley was cast as both a villain and a hero of the law, in such movies as The Baron of Arizona (1950), The Half-Breed (1952), Highway Dragnet (1954) and Big House, USA (1955). With his bass voice, he narrated a number of documentaries. He starred in two television series, Racket Squad (1950–1953) as Captain Braddock, and The Public Defender (1954–1955) as Bart Matthews, a fictional attorney for the indigent. Hadley also worked on the Red Ryder radio show during the 1940s, being the first actor to portray the title character. In films, among other things, he starred as Zorro in the 1939 serial Zorro's Fighting Legion. He is immortalized on the Hollywood Walk of Fame for his television work.\n\nHe was the voice of cowboy hero Red Ryder on radio and the narrator of several Department of Defense films: "Operation Ivy", about the first hydrogen bomb test, Ivy Mike, "Military Participation on Tumbler/Snapper"; "Military Participation on Buster Jangle"; and "Operation Upshot-Knothole" all of which were produced by Lookout Mountain studios. The films were originally intended for internal military use, but have been "sanitized", edited, and de-classified, and are now available to the public. During the period he narrated these films, Hadley held a Top Secret security clearance.\n\nHadley also served as the narrator on various Hollywood films, including House on 92nd Street (1945), Call Northside 777 (1947) and Boomerang (1947).\n\nHe died at age 63 on December 11, 1974, in Los Angeles, California, of a heart attack. He is buried at Forest Lawn Memorial Park in the Hollywood Hills.\n\nDescription above from the Wikipedia article Reed Hadley, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Petrolia, Clay County Texas, USA	Reed Hadley
149081	\N	\N		0		Heather Wilde
34238	1879-08-17	1952-01-26		0		Harlan Briggs
1291801	\N	\N		0		William Alston
33179	1903-06-03	1956-12-17		2	Caruthersville, Missouri, USA	Eddie Acuff
981098	1878-09-26	1951-05-01		0		Nora Cecil
1181440	\N	\N		0		Lowden Adams
103623	\N	\N		0		Fay Adler
1271033	\N	\N		0		Vangie Beilby
1301730	\N	\N		0		Becky Bohanon
1671409	\N	\N		0		Melinda Boss
1671411	\N	\N		0		Tom Braunger
1492406	\N	\N		0		Jack Rube Clifford
1317082	\N	\N		0		Eddie Coke
1671412	\N	\N		0		Russell Coles
78086	1932-04-23	\N		0		Gene Collins
544971	1881-11-06	1977-03-10		0		Jan Duggan
133342	1896-03-31	1951-05-05	Eddie Dunn was born on March 31, 1896 in Brooklyn, New York, USA as Edward Frank Dunn. He was an actor and director, known for The Great Dictator (1940), I Shot Jesse James (1949) and The Battler (1916). He died on May 5, 1951 in Hollywood, California, USA.	0		Eddie Dunn
115366	1909-06-10	1996-06-12	From Wikipedia\n\nMary Field (June 10, 1909 – June 12, 1996) was an American\n\nfilm actress who primarily appeared in supporting roles.\n\nShe was born in New York City. As a child she never knew her\n\nbiological parents. During her infancy she was left outside the doors of a\n\nchurch with a note pinned to her saying that her name was "Olivia\n\nRockefeller". She would later be adopted.\n\nIn 1937, she was signed under contract to Warner Bros.\n\nStudios and made her film debut in The Prince and the Pauper (1937). Her other\n\nscreen credits include parts in such films as “Jezebel” (1938), “Cowboy from\n\nBrooklyn” (1938), “The Amazing Dr. Clitterhouse” (1938), “Eternally Yours”\n\n(1939), “When Tomorrow Comes” (1939),” Broadway Melody” of 1940, “Ball of Fire”\n\n(1941), “How Green Was My Valley” (1941), “Mrs. Miniver” (1942), “Out of the\n\nPast” (1947), and “Life With Father” (1947). During her time in Hollywood she\n\nstarred in approximately 103 films.\n\nHer TV credits include parts in Gunsmoke, Wagon Train, and\n\nThe Loretta Young Show. In 1963, her last acting role was as a Roman Catholic\n\nnun in the television series, Going My Way, starring Gene Kelly and modeled\n\nafter the 1944 Bing Crosby film of the same name. She appeared in several\n\nepisodes of the television comedy, Topper, as Henrietta Topper's friend Thelma\n\nGibney.\n\nOn June 12, 1996, just two days after her 87th birthday,\n\nMary Field died at her home in Fairfax, Virginia of complications from a\n\nstroke. She lived there with her daughter, Susana Kerstein, and son-in- Law,\n\nBob Kerstein. She had two grandchildren, Sky Kerstein and Kendall Kerstein.	0		Mary Field
12446	1925-09-08	1980-07-24	From Wikipedia, the free encyclopedia.\n\nRichard Henry Sellers, CBE (8 September 1925 – 24 July 1980), known as Peter Sellers, was a British comedian and actor best known as Chief Inspector Clouseau in The Pink Panther film series, for playing three different characters in Dr. Strangelove, as Clare Quilty in Lolita, and as the man-child and TV-addicted Chance the gardener in his penultimate film, Being There. Leading actress Bette Davis once remarked of him, "He isn't an actor—he's a chameleon."  Sellers rose to fame on the BBC Radio comedy series The Goon Show. His ability to speak in different accents (e.g., French, Indian, American, German, as well as British regional accents), along with his talent to portray a range of characters to comic effect, contributed to his success as a radio personality and screen actor and earned him national and international nominations and awards. Many of his characters became ingrained in public perception of his work. Sellers' private life was characterized by turmoil and crises, and included emotional problems and substance abuse. Sellers was married four times, and had three children from the first two marriages.\n\nAn enigmatic figure, he often claimed to have no identity outside the roles that he played, but he left his own portrait since, "he obsessively filmed his homes, his family, people he knew, anything that took his fancy right to the end of his life—intimate film that remained undiscovered until long after his death in 1980." The director Peter Hall has said: "Peter had the ability to identify completely with another person, and think his way physically, mentally and emotionally into their skin. Where does that come from? I have no idea. Is it a curse? Often. I think it's not enough though in this business to have talent. You have to have talent to handle the talent. And that I think Peter did not have."\n\nDescription above from the Wikipedia article Peter Sellers, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Southsea, Hampshire, England, UK	Peter Sellers
862	1927-10-18	1999-09-22	George Campbell Scott  (October 18, 1927 – September 22, 1999) was an American stage and film actor, director and producer. He was best known for his stage work, as well as his portrayal of General George S. Patton in the film Patton, and as General Buck Turgidson in Stanley Kubrick's Dr. Strangelove.	2	Wise, Virginia, USA	George C. Scott
3088	1916-03-26	1986-05-23	From Wikipedia, the free encyclopedia.\n\nSterling Hayden (March 26, 1916 – May 23, 1986) was an American actor and author. For most of his career as a leading man, he specialized in westerns and film noir, such as Johnny Guitar, The Asphalt Jungle and The Killing. Later on he became noted as a character actor for such roles as Gen. Jack D. Ripper in Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb (1964). He also played the Irish policeman, Captain McCluskey, in Francis Ford Coppola's The Godfather in 1972, and the novelist Roger Wade in 1973's The Long Goodbye. Standing 6-feet, 5-inches tall (196 cm), he was taller than most actors.\n\nDescription above from the Wikipedia article Sterling Hayden, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Upper Montclair, New Jersey, USA	Sterling Hayden
4966	1916-07-27	1986-10-14	​From Wikipedia, the free encyclopedia.  \n\nKeenan Wynn (July 27, 1916 – October 14, 1986) was an American character actor. His bristling mustache and expressive face were his stock in trade, and though he rarely had a lead role, he got prominent billing in most of his movie and TV parts.\n\nDescription above from the Wikipedia article  Keenan Wynn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	Keenan Wynn
14253	1919-06-29	1983-12-08	From Wikipedia, the free encyclopedia.\n\nLouis Burton Lindley, Jr. (June 29, 1919 – December 8, 1983), better known by the stage name Slim Pickens, was an American rodeo performer and film and television actor who epitomized the profane, tough, sardonic cowboy, but who is best remembered for his comic roles, notably in Dr. Strangelove, 1941 and Blazing Saddles.\n\nDescription above from the Wikipedia article Slim Pickens, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Kingsburg, California, USA	Slim Pickens
6600	1912-03-21	1984-05-20	From Wikipedia, the free encyclopedia.\n\nPeter Cecil Bull, DSC (21 March 1912 – 20 May 1984) was a British character actor.\n\nDescription above from the Wikipedia article Peter Bull, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0		Peter Bull
15152	1931-01-17	\N	James Earl Jones (born January 17, 1931) is a multi-award-winning American actor of theater and film, well known for his distinctive bass voice and for his portrayal of characters of substance, gravitas and leadership. He is known for providing the voice of Darth Vader in the Star Wars franchise and the tagline for CNN.  James Earl Jones was born in Arkabutla, Mississippi, the son of Ruth (née Connolly) and Robert Earl Jones. At the age of five, he moved to Jackson, Michigan, to be raised by his maternal grandparents, but the adoption was traumatic and he developed a stutter so severe he refused to speak aloud. When he moved to Brethren, Michigan in later years a teacher at the Brethren schools started to help him with his stutter. He remained functionally mute for eight years until he reached high school. He credits his high school teacher, Donald Crouch, who discovered he had a gift for writing poetry, with helping him out of his silence.  Jones attended the University of Michigan where he was a pre-med major. While there, he joined the Reserve Officer Training Corps, and excelled. During the course of his studies, Jones discovered he was not cut out to be a doctor. Instead he focused himself on drama, with the thought of doing something he enjoyed, before, he assumed, he would have to go off to fight in the Korean War. After four years of college, Jones left without his degree. In 1953 he found a part-time stage crew job at the Ramsdell Theatre in Manistee, Michigan, which marked the beginning of his acting career. During the 1955–1957 seasons he was an actor and stage manager. He performed his first portrayal of Shakespeare’s Othello in this theater in 1955. After his discharge from the Military, Jones moved to New York, where he attended the American Theatre Wing to further his training and worked as a janitor to earn a living. His first film role was as a young and trim Lt. Lothar Zogg, the B-52 bombardier in Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb in 1964. His first big role came with his portrayal of boxer Jack Jefferson in the film version of the Broadway play The Great White Hope, which was based on the life of boxer Jack Johnson. For his role, Jones was nominated Best Actor by the Academy of Motion Picture Arts and Sciences, making him the second African-American male performer (following Sidney Poitier) to receive a nomination. In 1969, Jones participated in making test films for a proposed children's television series; these shorts, combined with animated segments were the beginnings of the Sesame Street format. The next year, in the early 1970s, James appeared with Diahann Carroll in the film called Claudine.  While he has appeared in many roles, he is well known as the voice of Darth Vader in the original Star Wars trilogy. Darth Vader was portrayed in costume by David Prowse in the original trilogy, with Jones dubbing Vader's dialogue in postproduction due to Prowse's strong West Country accent being unsuitable for the role. At his own request, he was originally uncredited for the release of the first two films (he would later be credited for the two in the 1997 re-release).  His other voice roles include Mufasa in the 1994 film Disney animated blockbuster The Lion King, and its direct-to-video sequel, The Lion King II: Simba's Pride. He also has done the CNN tagline, "This is CNN", as well as "This is CNN International", and the Bell Atlantic tagline, "Bell Atlantic: The heart of communication". When Bell Atlantic became Verizon, Jones used the tagline greeting of "Welcome to Verizon" or "Verizon 411" right before a phone call would go through. The opening for NBC's coverage of the 2000 and 2004 Summer Olympics; "the Big PI in the Sky" (God) in the computer game Under a Killing Moon; a Claymation film about The Creation; and several guest spots on The Simpsons.  In addition to his film and voice over work, Jones is an accomplished stage actor as well; he has won Tony awards in 1969 for The Great White Hope and in 1987 for Fences. Othello, King Lear, Oberon in A Midsummer Night's Dream, Abhorson in Measure for Measure, and Claudius in Hamlet are Shakespearean roles he has played. He received Kennedy Center Honors in 2002.  Jones has been married to actress Cecilia Hart since 1982. They have one child, Flynn Earl Jones. He was previously married to American actress/singer Julienne Marie (born March 21, 1933, Toledo, Ohio); they had no children. Jones is a registered Republican.	0	Arkabutla, Mississippi, USA	James Earl Jones
126354	1949-10-28	\N		0		Tracy Reed
12485	1926-03-06	2004-03-10		0		Jack Creley
1332529	\N	\N		0		Frank Berry
1236452	\N	\N		0		Robert O'Neill
1332531	\N	\N		0		Roy Stephens
10657	1932-05-28	\N	From Wikipedia, the free encyclopedia.\n\nShane Rimmer (born 1932) is a Canadian actor and voice actor, probably best known as the voice of Scott Tracy in Thunderbirds.\n\nHe has mostly performed in supporting roles, frequently in films and television series filmed in the United Kingdom, having relocated to England in the late 1950s. His appearances include roles in such widely-known films as Dr. Strangelove (1964), Rollerball (1975), The Spy Who Loved Me (1977), Gandhi (1982), Out of Africa (1985) and Crusoe (1989). More recently he has appeared in Spy Game (2001), and Batman Begins (2005). In the earlier years of his career, there were several uncredited performances, among others for films such as You Only Live Twice (1967), Diamonds Are Forever (1971), Star Wars (1977) and Superman II (1980). With the exception of recurring featured cast members he has appeared in more James Bond films than any other actor.\n\nRimmer has a long association with Gerry Anderson. Thunderbirds fans may recognize him as the voice actor behind the character Scott Tracy. He drafted the plotline for the penultimate episode, "Ricochet", which was later turned into a script by Tony Barwick. He also wrote scripts and provided uncredited voices for Captain Scarlet and the Mysterons, Joe 90 and The Secret Service, has made appearances in episodes of Anderson's live-action UFO and The Protectors, has and provided voices for Space: 1999 and has guest-starred in the episode "Space Brain". In later years he starred in the unscreened pilot Space Police (later made into a series with other actors and titled Space Precinct) and provided the voice for Anderson's stop-motion gumshoe Dick Spanner, P.I..\n\nRimmer and fellow Anderson actor Ed Bishop often joked about how often their professional paths crossed and termed themselves "Rent-a-Yanks". They appeared together as NASA operatives in the opening of You Only Live Twice and as USN sailors in The Bedford Incident as well as touring together in live stage shows, including "Death of a Salesman" in the 1990s. He also appeared in Doctor Who in 1966, and in Coronation Street as two different characters: Joe Donnelli (1968–1970), who held Stan Ogden hostage in No. 5 before committing suicide, and Malcolm Reid (1988), father of Audrey Roberts' son Stephen.\n\nHe has made many guest appearances in British television series for ITV, including in Roald Dahl's Tales of the Unexpected, and ITC's The Persuaders!. In 1989 Rimmer was reunited with former Gerry Anderson actors Ed Bishop and Matt Zimmerman in the BBC Radio 4 adaptation of Sir Arthur Conan Doyle's A Study In Scarlet. Rimmer and Bishop also appeared in the BBC drama-documentary Hiroshima completed not long after Bishop's death in 2005. Note: His official website and travel record on the Immigration &amp; Travel section of Ancestry give his year of birth as 1929.\n\nDescription above from the Wikipedia article Shane Rimmer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Shane Rimmer
186212	\N	\N		0		Hal Galili
185044	\N	\N		0		Paul Tamarin
1332532	\N	\N		0		Laurence Herder
1063405	\N	\N		0		John McCarthy
117301	1918-07-17	1983-08-03		0		Gordon Tanner
184980	\N	\N	Burnell Tucker is an actor.	0		Burnell Tucker
1556340	\N	\N		0		Victor Harrington
240	1928-07-26	1999-03-07	Stanley Kubrick (July 26, 1928 – March 7, 1999) was an American film director, writer, producer, and photographer who lived in England during most of the last four decades of his career. Kubrick was noted for the scrupulous care with which he chose his subjects, his slow method of working, the variety of genres he worked in, his technical perfectionism, and his reclusiveness about his films and personal life. He maintained almost complete artistic control, making movies according to his own whims and time constraints, but with the rare advantage of big-studio financial support for all his endeavors. Kubrick's films are characterized by a formal visual style and meticulous attention to detail—his later films often have elements of surrealism and expressionism that eschews structured linear narrative. His films are repeatedly described as slow and methodical, and are often perceived as a reflection of his obsessive and perfectionist nature. A recurring theme in his films is man's inhumanity to man. While often viewed as expressing an ironic pessimism, a few critics feel his films contain a cautious optimism when viewed more carefully.\n\nThe film that first brought him attention to many critics was Paths of Glory, the first of three films of his about the dehumanizing effects of war. Many of his films at first got a lukewarm reception, only to be years later acclaimed as masterpieces that had a seminal influence on many later generations of film-makers. Considered especially groundbreaking was 2001: A Space Odyssey noted for being both one of the most scientifically realistic and visually innovative science-fiction films ever made while maintaining an enigmatic non-linear storyline. He voluntarily withdrew his film A Clockwork Orange from England, after it was accused of inspiring copycat crimes which in turn resulted in threats against Kubrick's family. His films were largely successful at the box-office, although Barry Lyndon performed poorly in the United States. Living authors Anthony Burgess and Stephen King were both unhappy with Kubrick's adaptations of their novels A Clockwork Orange and The Shining respectively, and both authors were engaged with subsequent adaptations. All of Kubrick's films from the mid-1950s to his death except for The Shining were nominated for Oscars, Golden Globes, or BAFTAs. Although he was nominated for an Academy Award as a screenwriter and director on several occasions, his only personal win was for the special effects in 2001: A Space Odyssey.\n\nEven though all of his films, apart from the first two, were adapted from novels or short stories, his works have been described by Jason Ankeny and others as "original and visionary". Although some critics, notably Andrew Sarris and Pauline Kael, frequently disparaged Kubrick's work, Ankeny describes Kubrick as one of the most "universally acclaimed and influential directors of the postwar era" with a "standing unique among the filmmakers of his day."\n\nDescription above from the Wikipedia article Stanley Kubrick, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Manhattan, New York, US	Stanley Kubrick
8950	1924-05-01	1995-10-29	From Wikipedia, the free encyclopedia.   Terry Southern (1 May 1924 – 29 October 1995) was an American author, essayist, screenwriter and university lecturer, noted for his distinctive satirical style. Part of the Paris postwar literary movement in the 1950s and a companion to Beat writers in Greenwich Village, Southern was also at the center of Swinging London in the sixties and helped to change the style and substance of American films in the 1970s. In the 1980s he wrote for Saturday Night Live and lectured on screenwriting at several universities in New York.\n\nSouthern's dark and often absurdist style of satire helped to define the sensibilities of several generations of writers, readers, directors and film goers. He is credited by journalist Tom Wolfe as having invented New Journalism with the publication of "Twirling at Ole Miss" in Esquire in 1962, and his gift for writing memorable film dialogue was evident in Dr. Strangelove, The Loved One, The Cincinnati Kid, Easy Rider, and The Magic Christian. His work on Easy Rider helped create the independent film movement of the 1970s.\n\nDescription above from the Wikipedia article Terry Southern, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Alvarado, Texas, USA	Terry Southern
14250	1924-03-26	1966-06-01		2	Treorchy, Wales, UK	Peter George
257	\N	\N		0		Victor Lyndon
14251	\N	\N		0		Leon Minoff
14252	\N	\N		0		Laurie Johnson
7753	1914-04-12	\N		2		Gilbert Taylor
12009	1931-06-03	\N	From Wikipedia, the free encyclopedia.\n\nAnthony Harvey (born 3 June 1931) is a British filmmaker who started his career in the 1950s as a film editor, and moved into directing in the mid 1960s. Harvey has fifteen film credits as an editor, and he has directed thirteen films. The second film that Harvey directed, The Lion in Winter (1968), earned him a Directors Guild of America Award and a nomination for the Academy Award for Directing.\n\nDescription above from the Wikipedia article Anthony Harvey, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England, UK	Anthony Harvey
9869	1921-02-05	\N		0		Ken Adam
9918	1924-09-24	\N		0		Peter Murton
1158	1940-04-25	\N	Alfredo James "Al" Pacino (born April 25, 1940) is an American film and stage actor and director. He is famous for playing mobsters, including Michael Corleone in The Godfather trilogy, Tony Montana in Scarface, Alphonse "Big Boy" Caprice in Dick Tracy and Carlito Brigante in Carlito's Way, though he has also appeared several times on the other side of the law — as a police officer, detective and a lawyer. His role as Frank Slade in Scent of a Woman won him the Academy Award for Best Actor in 1992 after receiving seven previous Oscar nominations.\n\nHe made his feature film debut in the 1969 film Me, Natalie in a minor supporting role, before playing the leading role in the 1971 drama The Panic in Needle Park. Pacino made his major breakthrough when he was given the role of Michael Corleone in The Godfather in 1972, which earned him an Academy Award nomination for Best Supporting Actor. Other Oscar nominations for Best Supporting Actor were for Dick Tracy and Glengarry Glen Ross. Oscar nominations for Best Actor include The Godfather Part II, Serpico, Dog Day Afternoon, the court room drama ...And Justice for All and Scent of a Woman.\n\nIn addition to a career in film, he has also enjoyed a successful career on stage, picking up Tony Awards for Does a Tiger Wear a Necktie? and The Basic Training of Pavlo Hummel. His love of Shakespeare led him to direct his first film with Looking for Richard, a part documentary on the play Richard III. Pacino has received numerous lifetime achievement awards, including one from the American Film Institute. He is a method actor, taught mainly by Lee Strasberg and Charlie Laughton at the Actors Studio in New York. Although he has never married, Pacino has had several relationships with actresses and has three children.\n\nDescription above from the Wikipedia article Al Pacino, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New York City, New York, USA	Al Pacino
10127	1938-12-29	\N	From Wikipedia, the free encyclopedia\n\nJonathan Vincent "Jon" Voight (born December 29, 1938) is an American actor. He has received an Academy Award, out of four nominations, and three Golden Globe Awards, out of nine nominations.\n\nVoight came to prominence in the late 1960s with his performance as a would-be gigolo in Midnight Cowboy (1969). During the 1970s, he became a Hollywood star with his portrayals of a businessman mixed up with murder in Deliverance (1972), a paraplegic Vietnam veteran in Coming Home (1978), for which he won an Academy Award for Best Actor, and a penniless ex-boxing champion in The Champ (1979).\n\nAlthough his output slowed during the 1980s, Voight received critical acclaim for his performance as a ruthless bank robber in Runaway Train (1985). During the 1990s, he most notably starred as an unscrupulous showman attorney in The Rainmaker (1997).\n\nVoight gave critically acclaimed biographical performances during the 2000s, appearing as sportscaster Howard Cosell in Ali (2001), as Nazi officer Jürgen Stroop in Uprising (2001), and as Pope John Paul II in the television film of the same name (2005).\n\nVoight is the father of actress Angelina Jolie.\n\nDescription above from the Wikipedia article Jon Voight, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Yonkers, New York, USA	Jon Voight
3197	1961-11-29	\N	Tom Sizemore (born November 29, 1961) is an American film and television actor and producer. He is known for his roles in films such as Saving Private Ryan, Pearl Harbor, Heat and Black Hawk Down and supporting roles in well known films such as The Relic, True Romance, Natural Born Killers, Wyatt Earp and Devil in a Blue Dress.	2	Detroit, Michigan, USA	Tom Sizemore
6200	1952-08-10	\N	From Wikipedia, the free encyclopedia\n\nDiane Venora (born August 10, 1952) is an American stage, television, and film actress.\n\nDescription above from the Wikipedia article Diane Venora, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	East Hartford, Connecticut, USA	Diane Venora
15851	1964-06-22	\N	Amy Frederica Brenneman (born June 22, 1964) is an American actress, perhaps best known for her roles in the television series NYPD Blue, Judging Amy and Private Practice. She has also starred in films such as Heat, Fear, Daylight, Nine Lives and 88 Minutes.\n\nDescription above from the Wikipedia article  Amy Brenneman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New London, Connecticut, USA	Amy Brenneman
15852	1968-04-19	\N	Ashley Judd (born April 19, 1968) is an American television and film actress, who has played lead roles in films including Ruby in Paradise, Kiss the Girls, Double Jeopardy, Where the Heart Is and High Crimes. She is active in a number of humanitarian and political causes, including two missions to the Democratic Republic of Congo to campaign against sexual violence against women. Description above from the Wikipedia article Ashley Judd, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Granada Hills, California, USA 	Ashley Judd
34	1957-03-04	\N	Michael T. "Mykelti" Williamson (born March 4, 1957) is an American actor best known for his role as Benjamin Buford (Bubba) Blue in the 1994 film Forrest Gump, as Detective Bobby "Fearless" Smith in the critically acclaimed but commercially unsuccessful crime drama Boomtown, and recently for appearing as the head of CTU for season 8 of the hit TV series 24.	2	Saint Louis, Missouri, USA	Mykelti Williamson
15853	1947-12-17	\N	From Wikipedia, the free encyclopedia.\n\nWesley "Wes" Studi (born December 17, 1947) is an American Cherokee actor, who has earned notability for his portrayals of Native Americans in film. He has appeared in well-received Academy Award-winning films, such as Kevin Costner's Dances with Wolves, Michael Mann's The Last of the Mohicans, the award-winning Geronimo: An American Legend and the Academy Award-nominated film The New World (2005). He most recently portrayed General Linus Abner (an analogue to the biblical Abner) in the NBC series Kings, and Eytukan in James Cameron's box office blockbuster Avatar.	0	Nofire Hollow - Oklahoma - USA	Wes Studi
15854	1957-05-29	\N	Frank Theodore "Ted" Levine (born May 29, 1957) is an American actor. He is known for his roles as Buffalo Bill in The Silence of the Lambs and Captain Leland Stottlemeyer in the television series Monk.	2	Parma, Ohio	Ted Levine
524	1981-06-09	\N	Natalie Portman is an actress with dual American and Israeli citizenship. Her first role was as an orphan taken in by a hitman in the 1994 action film Léon: The Professional, but mainstream success came when she was cast as Padmé Amidala in the Star Wars prequel trilogy (released in 1999, 2002 and 2005). In 1999, she enrolled at Harvard University to study psychology while still working as an actress. She completed her bachelor's degree in 2003.\n\nIn 2001, Portman opened in New York City's Public Theater production of Anton Chekhov's The Seagull. In 2005, Portman won a Golden Globe Award and received an Academy Award nomination for Best Supporting Actress for her performance in the drama Closer. She won a Constellation Award for Best Female Performance and a Saturn Award for Best Actress for her starring role in V for Vendetta (2006). She played leading roles in the historical dramas Goya's Ghosts (2006) and The Other Boleyn Girl (2008). In May 2008, she served as the youngest member of the 61st Annual Cannes Film Festival jury. Portman's directorial debut, Eve, opened the 65th Venice International Film Festival's shorts competition in 2008. Portman directed a segment of the collective film New York, I Love You. Portman is also known for her portrayal as Jane Foster, the love interest of Marvel superhero Thor, in the film adaptation Thor (2011), and its sequel, Thor: The Dark World (2013).\n\nIn 2010, Portman starred in the psychological thriller Black Swan. Her performance received critical praise and earned her a second Golden Globe Award, the Screen Actors Guild Award, the BAFTA Award, the Broadcast Film Critics Association Award and the Academy Award for Best Actress in 2011.	1	Jerusalem, Israel	Natalie Portman
119232	1951-04-12	\N	Tom Noonan (born April 12, 1951) is an American actor and film writer-director. Noonan was born in Greenwich, Connecticut, the son of Rosaleen and Tom Noonan, who worked as a dentist and jazz musician respectively. He has an older brother, John F. Noonan, a playwright, and two sisters, Barbara and Nancy. In 1986, Noonan played Francis Dolarhyde, a serial killer who kills entire families, in Michael Mann's Manhunter, the first movie to feature Hannibal Lecter. Another supporting role, and another collaboration with director Michael Mann was in 1995, as Kelso in Heat. He also played Frankenstein in The Monster Squad. During the 1990s, he wrote various plays, including two that he made into movies, What Happened Was... (1994) and The Wife (1995). In the 2000s, Noonan appeared in various other movies, including a widely praised role as Sammy Barnathan in Synecdoche, New York, Charlie Kaufman's directorial debut. Most recently, he originally voiced one of the Wild Things in director Spike Jonze's Where The Wild Things Are, but was replaced by Chris Cooper.\n\nDescription above from the Wikipedia article Tom Noonan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Greenwich - Connecticut - USA	Tom Noonan
31004	1966-03-03	\N	From Wikipedia, the free encyclopedia.\n\nAnthony Terrell Smith (born March 3, 1966, Los Angeles, California), better known by his stage name Tone Lōc, is an American rapper and actor. He is best known for his deep, gravelly voice and his million-selling hit singles, "Wild Thing" and "Funky Cold Medina". Tone Lōc is also a voice actor, having voiced characters in several cartoon series. He also voiced Fud Wrapper, the host of the animatronic show, Food Rocks, which played at Epcot from 1994 to 2004. In this latter role, he sang the song "Always Read the Wrapper", a parody of his own song "Funky Cold Medina". His song "Ace Is In The House" features in the films "Ace Ventura: Pet Detective" (1994) and "Ace Ventura Jr: Pet Detective" (2009).\n\nHe provided vocals for FeFe Dobson for a track called "Rock It 'Til You Drop It" on her first album, 2003's Fefe Dobson.\n\nDescription above from the Wikipedia article Tone Lōc, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Los Angeles, California, USA	Tone Loc
5587	1964-04-25	\N	From Wikipedia, the free encyclopedia.\n\nHenry Albert "Hank" Azaria  (born April 25, 1964) is an American film, television and stage actor, director and comedian. He is noted for being one of the principal voice actors on the animated television series The Simpsons (1989-present), on which he performs the voices of Moe Szyslak, Apu Nahasapeemapetilon, Police Chief Clancy Wiggum, Comic Book Guy and numerous others. Azaria, who attended Tufts University, joined the show with little voice acting experience, but became a regular in its second season. Many of his characters on the show are based on famous actors and characters; Moe, for example, is based on actor Al Pacino.\n\nAlongside his continued voice acting on The Simpsons, Azaria became more widely known through his appearances in films such as The Birdcage (1996) and Godzilla (1998). He has continued to star in numerous films including Mystery Men (1999), America's Sweethearts (2001), Shattered Glass (2003), Along Came Polly (2004), Run Fatboy Run (2007), Night at the Museum: Battle of the Smithsonian (2009) and The Smurfs (2011). He also had recurring roles on the television series Mad About You and Friends and starred in the drama Huff (2004-2006), playing the titular character, to critical acclaim, as well as appearing in the popular stage musical Spamalot. Originally primarily a comic actor, in recent years Azaria has taken on more dramatic roles including the TV films Tuesdays With Morrie (1999) and Uprising (2001). He has won four Emmys and a Screen Actors Guild Award. Azaria was married to actress Helen Hunt from 1999 to 2000.\n\nDescription above from the Wikipedia article Hank Azaria, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Queens, New York, USA	Hank Azaria
34839	1959-05-26	\N	​From Wikipedia, the free encyclopedia\n\nKevin Gage (born May 26, 1959) is an American actor. He was married to actress Kelly Preston from 1985 to 1987.\n\nGage was born as Kevin Gaede in Wisconsin, where he grew up dividing his time between attending school, working in his grandparents' dairy, and participating in sports. Upon graduating from high school, he hitchhiked his way to Florida, where he saw the ocean for the very first time. He lived and worked there for a time, taking odd jobs to support himself, although ultimately decided to gravitate out west to California. Once in Los Angeles, he was spotted by a theatrical agent and asked if he had ever given any serious thought to becoming an actor. During a subsequent audition, Gage displayed obvious natural abilities, and it was suggested that he enroll in an acting workshop to further develop his talent. He soon came to love the profession, and over time began to find work in playing small parts on series television and low-budget film productions. His breakthrough role eventually came in the DeNiro / Pacino crime epic, Heat, portraying the ominous thrill-killing loose cannon, Waingro. Gage went on from there to give numerous other performances in many films.\n\nOn July 30, 2003, Gage was sentenced to 41 months in federal prison, starting September 29, 2003, for cultivating marijuana despite owning a California-issued license for medicinal marijuana. Gage stated that he cultivated medicinal cannabis to help him cope with chronic pain and stress from injuries suffered in a 1993 car accident, as well as for a sister with cancer and brother with multiple sclerosis. He was released September 21, 2005.\n\nGage was involved in another cannabis-related incident on April 29, 2008 in Annapolis, Maryland. The actor was reportedly arrested for smoking marijuana after police were called to the scene of a loud party. Afterwards, Gage was cited and released on his own recognizance.\n\nDescription above from the Wikipedia article Kevin Gage (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Wisconsin, United States	Kevin Gage
4158	\N	\N		0		Susan Traylor
17358	\N	\N		0		Kim Staunton
14564	1899-08-29	1973-07-02	​From Wikipedia, the free encyclopedia\n\nGeorge Peabody Macready, Jr. (August 29, 1899 – July 2, 1973), was an American stage, film, and television actor often cast in roles as polished villains.\n\nDescription above from the Wikipedia article George Macready, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Providence Rhode Island, USA	George Macready
14565	1914-02-17	1959-09-14	​From Wikipedia, the free encyclopedia.\n\nWayne Morris  (February 17, 1914 – September 14, 1959), born Bert DeWayne Morris in Los Angeles, was an American film and television actor, as well as a decorated World War II fighter ace. He appeared in many notable films, including Paths of Glory (1957), The Bushwackers (1952) and the title role of Kid Galahad in 1937. While filming Flight Angels (1940), Morris became interested in flying and became a pilot. With war in the wind, he joined the Naval Reserve and became a Navy flier in 1942, leaving his film career behind for the duration of the war. Flying the F6F Hellcat off the aircraft carrier USS Essex, Morris shot down seven Japanese planes and contributed to the sinking of five ships. He was awarded four Distinguished Flying Crosses and two Air Medals. Morris was considered by the Navy as physically 'too big' to fly fighters. After being turned down several times as a fighter pilot, he went to his brother in law, Cdr. David McCampbell, imploring him for the chance to fly fighters. Cdr. McCampbell said "Give me a letter." He flew with the VF-15, the famed "McCampbell Heroes." He married Patricia O'Rourke, an Olympic swimmer, and sister to B-movie actress Peggy Stewart. Following the war, Morris returned to films, but his nearly four-year absence had cost him his burgeoning stardom. He continued to act in movies, but the pictures, for the most part, sank in quality. Losing his boyish looks but not demeanor, Morris spent most of the fifties in low-budget westerns. He made an unusual career move in 1957, making his Broadway debut as a washed-up boxing champ in William Saroyan's The Cave Dwellers. He also appeared as a weakling in Stanley Kubrick's Paths of Glory (1957). Morris suffered a massive heart attack while visiting aboard the aircraft carrier USS Bon Homme Richard in San Francisco Bay and was pronounced dead after being transported to Oakland Naval Hospital in Oakland, California. He was 45. He was buried at Arlington National Cemetery.\n\nDescription above from the Wikipedia article Wayne Morris (American actor), licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Los Angeles, California, USA	Wayne Morris
11160	1944-05-16	\N	Dan "Danny" Trejo born May 16, 1944 - Height: 5' 7" (1,70 m)) is an American actor who has appeared in numerous Hollywood films, often as hypermasculine characters, villains and anti-heroes. Some of his notable films include Heat, Con Air, Machete and Desperado, the latter two with frequent collaborator Robert Rodriguez. Early life\n\nDan Trejo was born in- the Echo Park neighborhood of Los Angeles, California. He is the son of Alice Rivera and Dan Trejo, a construction worker. He is of Alice Rivera and Dan Trejo, a construction worker. He is of Mexican descent. He is a second cousin of filmmaker Robert Rodriguez, though the two were unaware that they were related until the filming of Desperado.\n\nThroughout the 1960s, Trejo was in and out of jail and prison in California. There are conflicting accounts of his prison chronology. By one account, his final stint in custody ended in 1972; by another account, he did time in a juvenile offenders' camp and six California prisons between 1959 and 1969. He recalled that his last prison term was five years. While serving in San Quentin Prison, he became a champion boxer in lightweight and welterweight divisions within that prison.During this time, Trejo became a member of a twelve-step program, which he credits with his success in overcoming drug addiction. In 2011, he recalled that he had been sober for 42 years. Upon his final release he enrolled in Pitzer College located in Claremont, California but subsequently left after one semester of attendance.\n\nPersonal life\n\nTrejo is married to Debbie Shreve. He has four children: Danny Boy (b. 1981), Gilbert (b. 1988), Danielle (b. 1990), Jose (b. 1991) who are all from previous relationships. He also has a daughter Esmeralda M. Trejo who is married and has three children in Austin, Texas.\n\nDescription above from the Wikipedia article Danny Trejo, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Echo Park, Los Angeles, California, USA	Danny Trejo
9290	1961-02-13	\N	From Wikipedia, the free encyclopedia\n\nHenry Rollins (born Henry Lawrence Garfield; February 13, 1961) is an American singer-songwriter, spoken word artist, writer, publisher, actor, radio DJ, and activist.\n\nAfter performing for the short-lived Washington D.C.-based band State of Alert in 1980, Rollins fronted the California hardcore punk band Black Flag from August 1981 until early 1986. Following the band's breakup, Rollins soon established the record label and publishing company 2.13.61 to release his spoken word albums, as well as forming the Rollins Band, which toured with a number of lineups until 2003 and during 2006.\n\nSince Black Flag, Rollins has embarked on projects covering a variety of media. He has hosted numerous radio shows, such as Harmony in My Head on Indie 103, and television shows such as The Henry Rollins Show, MTV's 120 Minutes, and Jackass. He had a recurring dramatic role as a white supremacist in the second season of Sons of Anarchy and has also had roles in several films. Rollins has also campaigned for various political causes in the United States, including promoting marriage equality for LGBT couples, World Hunger Relief, and an end to war in particular, and tours overseas with the United Service Organizations to entertain American troops.\n\nDescription above from the Wikipedia article Henry Rollins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Washington, District of Columbia, USA	Henry Rollins
86602	1961-05-12	\N		0		Jerry Trimble
4790	1947-09-29	\N	Martin Ferrero rejoint le California Actors Theater de Los Gatos en Californie. En 1979, il part à Los Angeles pour commencer sa carrière à Hollywood.  Après avoir décroché des petits rôles dans de nombreuses séries télévisées telles que Soap, Capitaine Furillo, Arnold et Willy ou encore Les Jours heureux, il décroche un rôle dans l'épisode pilote de Deux flics à Miami. Il y tient le rôle de Trini DeSoto. Mais il incarnera finalement le personnage d'Izzy Moreno, un indic' qui apparaîtra à plusieurs reprises dans les 5 saisons de la série jusqu'en 1990.  En parallèle, il continue d'apparaître dans d'autres séries comme Les Incorruptibles de Chicago, Clair de lune ou encore La Loi de Los Angeles.  Il décroche de petits rôles au cinéma, par exemple dans Un ticket pour deux (1987) de John Hughes puis dans L'embrouille est dans le sac (1991) de John Landis avec Sylvester Stallone, qu'il retrouvera dans Arrête ou ma mère va tirer ! (1992).  Il se fait surtout connaître du grand public en 1993 grâce à Jurassic Park de Steven Spielberg.  En 1995, il tient un petit rôle dans Get Shorty, Stars et Truands aux côtés de John Travolta, et dans Heat de Michael Mann.  Il retrouve ensuite Don Johnson, son ancien partenaire dans Deux flics à Miami, le temps d'un épisode de Nash Bridges en 1996.  Il apparaît ensuite dans les séries The Practice : Bobby Donnell et Associés et X-Files.  En 2000, il joue dans le 3e volet de la saga Air Bud puis incarne Angelo Dundee, l'entraîneur de Mohamed Ali, dans le téléfilm Ali - Un héros, une légende.  Sa dernière apparition au cinéma est dans Le Tailleur de Panama, sorti en 2001.  Depuis 2008, Ferrero est un membre de la Compagnie Antaeus, une compagnie de théâtre classique basée à Los Angeles.	0	Brockport, NY	Martin Ferrero
158452	\N	\N		0		Ricky Harris
181343	\N	\N		0		Begonya Plaza
91756	1959-02-16	\N		0	Trinidad, West Indies	Hazelle Goodman
160970	1943-08-06	\N		0		Ray Buktenica
3982	1955-12-16	\N	Alexander Harper "Xander" Berkeley (born December 16, 1955) is an American actor. His roles include George Mason on the television series 24.	2	Brooklyn, New York City, New York, USA	Xander Berkeley
81687	\N	\N		0		Rick Avery
1090464	\N	\N		0		Brad Baldridge
1090465	\N	\N		0		Andrew Camuccio
175600	\N	\N		0		Max Daniels
12879	\N	\N		0		Vince Deadrick Jr.
2090	1916-12-09	\N	Kirk Douglas (December 9, 1916) is an American stage and film actor, film producer and author. His popular films include Champion (1949), Ace in the Hole (1951), The Bad and the Beautiful (1952), Lust for Life (1956), Paths of Glory (1957), Gunfight at the O.K. Corral (1957) Spartacus (1960), and Lonely Are the Brave (1962).\n\nHe is #17 on the American Film Institute's list of the greatest male American screen legends of all time. In 1996, he received the Academy Honorary Award "for 50 years as a creative and moral force in the motion picture community."\n\nDescription above from the Wikipedia article Kirk Douglas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Amsterdam, New York, USA	Kirk Douglas
14562	1920-11-21	1988-08-05	From Wikipedia, the free encyclopedia.\n\nRalph Meeker (21 November 1920 – 5 August 1988) was an American stage and film actor best-known for starring in the 1953 Broadway production of Picnic, and in the 1955 film noir cult classic Kiss Me Deadly.\n\nDescription above from the Wikipedia article Ralph Meeker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Minneapolis, Minnesota, United States	Ralph Meeker
14563	1890-02-18	1963-10-29	​From Wikipedia, the free encyclopedia\n\nAdolphe Jean Menjou (February 18, 1890 – October 29, 1963) was an American actor. His career spanned both silent films and talkies, appearing in such films as The Sheik, A Woman of Paris, Morocco, and A Star is Born. He was nominated for an Academy Award for The Front Page in 1931.\n\nDescription above from the Wikipedia article Adolphe Menjou, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Pittsburgh, Pennsylvania, USA	Adolphe Menjou
12312	1926-08-08	\N	Richard Norman Anderson (born August 8, 1926) is an American film and television actor. Among his best-known roles is his portrayal of Oscar Goldman, the boss of Steve Austin (Lee Majors) and Jaime Sommers (Lindsay Wagner) in both The Six Million Dollar Man and The Bionic Woman television series and their subsequent television movies: The Return of the Six-Million-Dollar Man and the Bionic Woman (1987), Bionic Showdown: The Six Million Dollar Man and the Bionic Woman (1989) andBionic Ever After? (1994).	0	Long Branch - New Jersey - USA	Richard Anderson
592	1927-07-15	\N		0	Brooklyn, New York, USA	Joe Turkel
2758	1929-03-11	1994-05-11	Wikipedia:\n\nTimothy Agoglia Carey (born March 11, 1929, Brooklyn, New York – died May 11, 1994, Los Angeles, California) was an American film and television actor.\n\nCarey wrote, produced, directed and starred in the 1962 feature The World's Greatest Sinner which was scored by Frank Zappa. Although it did not have wide commercial release, the film has achieved cult status through repeated screenings at the "midnight movies" in Los Angeles in the 1960s. This movie established Carey as an important figure in independent film.\n\nAs an actor, Carey appeared in the Stanley Kubrick films The Killing and Paths of Glory, and in the John Cassavetes-directed films Minnie and Moskowitz and The Killing of a Chinese Bookie.\n\nHe had roles in East of Eden, The Wild One, One-Eyed Jacks and Beach Blanket Bingo. He played a minor role as the Angel of Death in the comedy film D.C. Cab, and appeared in the Monkees vehicle Head. His final appearance was in the 1986 movie Echo Park. Carey also did a select amount of acting on TV from the 1950s through the 1980s.\n\nCarey's image appears behind George Harrison on the cover of the Beatles album Sgt Pepper's Lonely Hearts Club Band. Unfortunately, his cutout is obscured by Harrison. Outtake photos from the "Pepper" session show his full face from the movie "The Killing".\n\nTimothy Carey died from a stroke in 1994, aged 65.	0		Timothy Carey
1019259	1932-05-10	\N		0		Christiane Kubrick
117671	1909-05-20	1993-04-01		0		Jerry Hausner
3476	1912-09-03	1986-03-03	From Wikipedia, the free encyclopedia.\n\nPeter Capell (3 September 1912 - 3 March 1985) was a German actor who was active on screen from 1945 until 1985.\n\nHis first role was in Winterset, shortly after the end of the Second World War. His final role came a year before his death, when he appeared in Mamas Geburtstag. Both of these were television productions. He also appeared in many films, including Willy Wonka and the Chocolate Factory (1971), in which he played a "tinker" who spoke to Charlie Bucket (Peter Ostrum) at the gates of Willy Wonka's chocolate factory.\n\nCapell died, aged 72, in March 1985.\n\nDescription above from the Wikipedia article Peter Capell, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Berlin, Germany	Peter Capell
14579	1910-08-18	1987-03-19	From Wikipedia, the free encyclopedia.\n\nEmile Meyer (August 18, 1910 – March 19, 1987) was an American actor (born in New Orleans) usually known for tough, aggressive, authoritative characters in Hollywood films from the 1950s era, mostly in westerns or thrillers. He provided such noteworthy performances as Ryker in Shane (1953), as Father Dupree in Paths of Glory (1957) and the corrupt cop in Sweet Smell of Success (1957). He appeared in an episode of the 1961 series The Asphalt Jungle.\n\nHe also appeared on television, including a guest spot on John Payne's The Restless Gun and as a truculently stubborn juror opposite James Garner in the 1957 Maverick episode "Rope of Cards." His guest appearance on the "Restless Gun" episode "Man and Boy" in 1957 included filming on the Iverson Movie Ranch in Chatsworth, Calif. His final film role was in The Legend of Frank Woods (1977).\n\nDescription above from the Wikipedia article Emile Meyer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Emile Meyer
31503	1919-11-03	1994-08-02	​From Wikipedia, the free encyclopedia.  \n\nBert Freed (November 3, 1919 — August 2, 1994) was a prolific American character actor, voice over actor, and the first actor to portray "Detective Columbo" on television.\n\nBorn and raised in The Bronx, New York, Freed began acting while attending Penn State University, and made his Broadway debut in 1942. Following World War II Army service in the European Theatre, he appeared in the Broadway musical The Day Before Spring in 1945 and dozens of television shows between 1947 and 1985. His film debut occurred, oddly enough, in a musical Carnegie Hall (1947). A prominent role was as the villainous Ryker in the television series Shane, in which Freed added a unique touch of realism by beginning the show clean-shaven and growing a beard from one week to the next, never shaving again through the season.\n\nFreed played Columbo in a live 1960 episode of the "Chevy Mystery Theatre" seven years before Peter Falk played the role. Thomas Mitchell also played the part on stage prior to Falk's version, which is probably where many of the eccentric Columbo traits originated; only a few were visible in Freed's straightforward interpretation, although the character as played by Freed is recognizably Columbo.\n\nHe appeared (sometimes more than once) in television shows such as The Rifleman, Bonanza, Gunsmoke, The Big Valley,The Virginian, Mannix, Barnaby Jones, Charlie's Angels, Then Came Bronson, Run For Your Life, Get Smart, The Lucy Show, Hogan's Heroes, Voyage to the Bottom of the Sea, Dr. Kildare, Ben Casey, Perry Mason, Combat!, Petticoat Junction, The Outer Limits, Alfred Hitchcock Presents, Route 66, Ironside, The Green Hornet, The Munsters, and many, many more. He directed one episode of T.H.E. Cat.\n\nFreed appeared as a racist club owner in No Way Out (1950), a gangster in Ma and Pa Kettle Go to Town (1950), a Marine private in Halls of Montezuma (1951 film), an Army sergeant in Take the High Ground! (1953), the Police Chief in Invaders From Mars (1953), Sgt. Boulanger in Paths of Glory (1957), the hangman in Hang 'Em High (1968), Max's father in Wild in the Streets (1968), as Chief of Detectives in Madigan (1968), a homosexual prison guard in There Was a Crooked Man... (1970) and Bernard's father in Billy Jack (1971) in which he got "whumped" on the side of the face by Billy Jack's right foot "just for the hell of it."\n\nHe retired from acting in 1986, and died of a heart attack in Canada in 1994 while on a fishing trip with his son.\n\nDescription above from the Wikipedia article Bert Freed,  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	The Bronx, New York USA	Bert Freed
94031	1917-08-12	1996-03-28		0		Kem Dibbs
1077968	\N	\N		0		Fred Bell
1077970	\N	\N		0		John Stein
1077971	\N	\N		0		Harold Benedict
49435	1920-04-21	1967-12-15		0	Linz, Austria	Paul Bös
3349	\N	\N		0		James B. Harris
14554	\N	\N		0		Humphrey Cobb
10769	1922-12-23	1995-02-21	From Wikipedia, the free encyclopedia\n\nCalder Baynard Willingham, Jr. (December 23, 1922 - February 19, 1995) was an American novelist and screenwriter. He cowrote several notable screenplays, including Paths of Glory (1957) and One-Eyed Jacks (1961).\n\nWillingham and Buck Henry were co-credited (but did not collaborate) on the screenplay for The Graduate (1967), which they adapted separately from a novel by Charles Webb; they won a BAFTA Award for Best Screenplay for their work and were also nominated for an Oscar.\n\nDescription above from the Wikipedia article Caroline D'Amore, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Atlanta, Georgia	Calder Willingham
3335	\N	\N		0		Jim Thompson
3350	1928-02-13	\N		0		Gerald Fried
14555	\N	\N		0		Georg Krause
14556	\N	\N		0		Eva Kroll
14557	\N	\N		0		Ludwig Reiber
11926	\N	\N		0		Ilse Dubois
\.


--
-- TOC entry 2232 (class 0 OID 45431)
-- Dependencies: 195
-- Data for Name: review; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY review (movie_id, member_login, content, vote) FROM stdin;
2	N7ZLC5KXCJ	1M7IT8PZ7Z2CWV5LJPA3LR6MO9X3HKNXSIQ0IDYU97TH1QKPUL9PM0KKPU4TLVSWLETNFEDF1P3N7ZU7YHI6L7L27FKXIEJNP75W	9
2	98DH79U5RR	6KQH3Y767N0A74DNVLN31Q93P7XFQ7937A271YRJN692UXLJG93WS3FQKX26A1P9N6C6CFV63DP5QGI2VO9QDNLE4LXE6VJWQ9PY	6
2	LMV5KHMJIQ	OGAN72ONK9DO9KW1959V8C0SRAI42OQ1UIHH9CGV61UMT06KW5QEPDVMPR66TUU5SL31DP27ZOYHSO90D8I78MMRW41RFKBMGY4H	9
2	BKEZFGXSRI	FGHCTPAOO4BSF2VLW7F9LEJXL1PNLA3U1382B4O7LDIAZ8ARQAU0YHVA7T129XCOAR1M43K1SIYI6I7M076LQD5TH74SDW7XA39I	2
2	PIW2O1HZHS	YWX02HQTNDYVOBC0177VHE682Y6KAHCJZFCLJUY5PA34F6YU56J6CW9TZY7DLFTGAP5I80RGJCGHLC259MOD8GHDGTVUXUUJQX30	1
2	LRYG3OO7V2	QVFPCX9Q2IX5CE81PI4I2CPE6TYR60YIC4T0JX5THWNL8YUQVSAO9SINGAST8RUBUO3HUIR2NKAFYEGH8I6NZJJTVGUIELVZCL1U	8
2	0I32H8MU6T	N5MAIBYRDYB4LUZVGMKEJWOYJXBZLCMNWMVNTMQIVCSRSO306E69QPV1RY1V98GALYH89MB35BTHD6F43K3GGN6G1465V5JW5RG4	2
2	98YTCMB2VA	51TDCEO6NXUT72YF9481AHFQFIA26MW0KX8TJDDIRKOGLLXCUR5WICGYVD74DW9AA3IK3F560ZJ028E4U7IOQ9SHQK7GGJF5KNGS	1
2	0IIQTWJMBK	NJPW95S3Q5W9DKGNUTALA3THZZRUNPO2V0GY22QD9OAOLGD88SZ3FGCUZI6KO8PAQ4NMDRU2C6LW2E6TWSV5ZVWPYW8U6GZA998Q	8
2	5KUMKKEHEX	05R770I4Q1UMNX5NTL5H8XQTA56HLW2GP05XE814OUI5OISS4XPYCJ4DP76B4BT38O6X2HJUUB3NPUF2NNMYHEDG52IGBZ9MAP79	3
2	7FQKPIDC53	50WN4DBPQX42EYRZ5W3K01A9DT4BQN9XFQRWZKMAC0PENN6ARXF3DZUD0WKLJ98DYGXYH49UJ2HAM5VZW4U3HGTP5O6DAA1C1LQH	7
2	I6JF0RW5IU	I3WYUTLSU04AUZPPF5RWI2385UIBEIBPOANA7FXWI7KXBCQLMXWQ8URPAX2AKKNMZPWULOSAH4NLRF73E7YRWUQ4S7AJMXL8T87W	5
2	5CPJU9L2PT	597EVIDGG84085NV50F81BNOJXUSO1THKNI70NAMMXM9FSN18NYH2YY4WT58XV1OOWPVXQ4S02VDZOI0J2UBDLPWYOLHRBY167US	1
2	8P3KYCP9C1	2ESTFR9CUFHLFY5A0LCH26IFWAYE3H13ZXRYCS74PUDJD6MN31FWSLJ56N6E25JMNOVRHG8HNI2I29B0YLLCCELONV1ZW2BUL15Z	3
2	B09BUMIAAB	5FW38JKTBC7LFQRTGKJDGDVOIVUGH7BDMP3FZJE5B5MS4NQMUBEQWWD1UHUMYDLDA39ZXL47GOBL0CU4EIVG2VR0LBVSY1G7TIRB	4
2	SMUHZ6ZLPE	0ZJGGJHU2ARXZHQRFLPLJNV0MJPHE1SUSPNSM9WLJGTAD48U0PO7CZFNDS474APAS6EJ37FFZDBD4VWRK5QYNUS2KAO4EYRJ0SSG	7
2	UIXWT83ZC0	Y02KJI8YCSS5NX9T1X7OM92TKAAW2MLCQ1VEYNEMTEHS681ARZ95U2NZ7J9IHL5ZGPPWB45NTV4H2KWMJ9FDNQSXN6HPN5EIJRLQ	5
2	G6YJUIUX8N	E9W4VL97G6XWX8HG1M071JFXP9XQW8K8G3EASJ1ES0H9U2076BRFVS1538OWYSLHWYP34HXSUVPBBFDWI0TURFNYCIGU4FQ9O9N6	4
2	4T71U0G3GP	6CZO8UADZ3Y41N8910QK11VADYOFPWC1HJMX4GSUNVMOSZC1RAXI6VVERYKKF5XD16XSBKEUI57GPGSOWXXO834WXHGF6IOS7JXV	1
2	5ZJ4TJAB4I	U0H6DABYPZKG5YSHIE7BA43E8Y9RPIFT6MB6QS5238HR58AU5KYEZTBZ6C7OATJGT0JTWW1ZIEICWMJ9YPVEUB3MKM9NVR2KZB7E	7
3	N7ZLC5KXCJ	Q7JS86VL9CU370U8EWS77IJXOE1M7NVOEKHRLWVEIBLJOUY0HLUOOH1IXWE4EINWRGYWTCWRBNY57AI3PAFW2H96T84ZS09AXZ2I	8
3	98DH79U5RR	CHEYDMBT5LXNKOED13JG2DUI69KNYIHH97N3A7Y58MXXGLHM5665TCD8W51DBX5XDPOMAKC3EOIPQ6CU17S1MMY74OGFFV3LR9U0	9
3	LMV5KHMJIQ	4MV4C0E3XS02HMDFEK01QSVD7YTU68QLMX6V67KVTDH6QM8JZGNY39RM0R7OGT7ZCOQTPRIHAEHMKZXUZK50U1RMFT5PA6PAGR3B	8
3	BKEZFGXSRI	O3H8GYZ2ECA3MY5YGEK6EO5W2HEZGF26WYKRY2OD2UAR5VXHTLAMTE1A7VF9U9V8JEHXNOAO0HETNO0HT6G4FPMR7KTCXOT38CI0	4
3	PIW2O1HZHS	A4ELVWLAHXT48QX20231ZZD571LYKVLG92TCBTU3ARZX9IY85AIJO9YK0IO4KXZWMN4F6V0HI90H9Q5ZCM3KMB1ADIL3FZTN2DKW	4
3	LRYG3OO7V2	SBJJAAOIQKKNY174OJKV4BYK7CTQNP6FIMTLTBLBM2W8APQ7VSN3ABTRN9L8R74BNFEMIWLN7IIBO0KSVV55BCEH2C7UZNTO7VU4	3
3	0I32H8MU6T	DZ9HA612RCXY2M6C99LB7TFY0XUZ4E3FPHS56XBGMPLAK56AXM7VI3NUTKQMLC7MIRJV4AGL7FYRIFO50TBRGH7V47MVGZ4JR813	6
3	98YTCMB2VA	LFWFWYDF6LO6VV1BPGBUY06YUFIKO9JNVJPOOMUT3Q7V7ZUDCIB20I7UI8VRP216CAKMGNWDVR0H2K04UFIF7RXML4FQ0DEAYBT7	4
3	0IIQTWJMBK	I7YW8GISZ18I06KUV8UN8BMIGMSN0S102QMHTT9KO3VCGHAG3PDC9UPGVPPVY42GAHPJUCBC9J8EPJB8MLUKPZ1IAFWDDOWUBPC9	8
3	5KUMKKEHEX	0V1OADZWL1LNRJMKR1LPGJPP79VXOCAHCGVZ25OVCWZNL0WFJJUY0UVRFLRBSBHI1ELLXXRVMZNUUCEGNQOESMQSUETQONDAOQWG	4
3	7FQKPIDC53	KRW18LBGB6DHKXCXD0OX30TDAH8VNFDP72C82MTAPLTIQJEZBMK0HTVU8S01NP352YJSVD50GOISHLX0CIUA5NHOHRAJV1W9RXP1	1
3	I6JF0RW5IU	WE8RUT3LDNW5AZE53APQ5LDCVEP1IAT550QEVSK3OCDENNVCREYXALFLA55PEBDC31AJIAJKZVB2H8ZITNJDM55TUFD0X5ZM9BLW	4
3	5CPJU9L2PT	M4R5N8PKNDBGX5129085QYC6TX35Y2FXC4HS2I87QJHBCT998U9LM06X1UM0ETVU8OD2YI911APGQA49X46D24KM8T1H6I36YXDX	5
3	8P3KYCP9C1	HK0VITMK0G10NCKXR1DD14FQ25THTS36GSPTGSUL8BHMAQTFSJG5AUYNFJ2N9E0HN4T4X0R9H2E0W2QLMNYKM76V4CO6ZHL3KA9G	9
3	B09BUMIAAB	YS22GYIP80N3RBVPQ4P779UMUK9QKPV2KOX56SFJYG6LADIFZO4FUI9Y7PH6Y1FSEUSDN0T7ZFJ1DJLRB416VQHCP87QLJU6ANGQ	6
3	SMUHZ6ZLPE	F1946QO8HVYEZ44AI6YNQYP2CWPVN0ZC576C1CYA2DHMJMVOZ52QSCDRMG1KA3VQ5WI282IGIYUNQCT0BB5R8IU23PZVKO99R0RW	1
3	UIXWT83ZC0	2Q7WWI3SZAJXBI88ESXCQ8SCX53YV6ZV6XIV74L90KEOQ8JFABNI4UX37491PF73KY0NANAJHXMG4EWZVXXTTR1M9OXC5UUUMKD2	2
3	G6YJUIUX8N	5FXBDBGIR93IJF1RNJ36ONVZ7NWC13TA4S0SASPQUDSP44WO2C9BK52RU7DZOEQXP2O1PJR43NMK5F5D1HKY3S09ZI8DPZCQW5AB	5
3	4T71U0G3GP	49SVFH6SRWOCA8G4146CPBHLOPEL6X9F3W6I1DYL3QHVTAO15V5BD9A32HGZDVW3WIJNC7CYFVJ84V1NAMPK28B3WDQU68IH4N9L	7
3	5ZJ4TJAB4I	AZ7SG5S0C9HP3Z0GLBXGP18RS1GMBEQWQW9XR1WDTDUEIEDJRATMLELJ0QAPYFY7SU8GZDZTPUXMH4IOY75AVDLMK06B1HONOWVY	2
18	N7ZLC5KXCJ	6TOL970Q9B6HW01KXMOJV68GY2HGK7VIUH1NQZVGU6KZA3FQXD1JGOUAVHXHZUGCQXWO9N380IZZVJG4W1SHFMCGW12JBOQA0IIN	2
18	98DH79U5RR	0RJJ2S7Z5OLB3U8B86EVQ1HUU6M2Y8NA3X5KI7M3EQ1MRHI3S81LE109JZY6FFA6BKIGZX2BUKQ9A5DMYTK0HC6B66ATIQX8Q4KG	9
18	LMV5KHMJIQ	CE4F004K18OVMHW5KY9OHJ2XJ2DWSTFU7NWOPVRLC0F7W86IADGFL222LH68XH2H23Y8VIPZHXMRE5AK54WONAJFV3DHYSY577F3	3
18	BKEZFGXSRI	7W2XQ7XPKXQHVC2UO42TSN2EHAY9RTHZGA7I306CVZKFWADP6KSDMJ1U4YPQIX81Q0AUFU1X7073DWRH6IDHADN7JNNFKP370TZ6	1
18	PIW2O1HZHS	SKLS4FWL7QIGITAU10MNDL1GWNR69CU6VHN81YG80VL6E9B53N93NS7HTF6RYZM56LUBFB3DUOWRA4CWLVDWD0TCKGPW2YKBJPA2	4
18	LRYG3OO7V2	A01U6J86PHYCJFCVZ2F2R19WGL5EVIU4JIL5MBGRUG490TSSHPTX4A7J0ENVN4LGX43B4GJXVXHL696X2M6FZ69IKBEHYVE04XM6	7
18	0I32H8MU6T	RXBG5BG3WM0I02B7GR04V02BC9ATQQIX97LY59352OYZO872D2YGWCE059E5BXMGDDI3RMCGY5BGBDXDCIQX1CB72U36473FBSVL	7
18	98YTCMB2VA	DK00RS0A7Z1LB32GYOBBLA7SGL0B6ETSMN87Z7JUK755CU3DB8MDTJOCMIUF1ZE3FJ9X44R1FR0OFCQWSWA71P8C85VRND3V2BZ2	6
18	0IIQTWJMBK	GJGRV8CSA7K18XEZGB0L6Z8J9NBYFVDNXBMN3QGQ5U88K0PPY5WA8RYQK6RH6OMO37D6L05Z5KPM098J8W9K9DOGN5C698TRHUFN	6
18	5KUMKKEHEX	SD796FYCL0K7HJKOCP0S7TQX90607FG4UXPSBLC80DBE191ZIDEEP5Y8WKAFI7FGUQMU32M1M214SM6A9HR3ABOZ8R51K6Z284UL	6
18	7FQKPIDC53	G5Q0N1XD4QKOAGAPLGSCXVM6UQQC85Y1UN2MBCWJ1WEAUNKZZNXXBJ8UTUF6LVE81T3WNYOITILBRLLHG0NVIAZLPH2R708FRFIB	6
18	I6JF0RW5IU	YLA9OD377CII80UIT013RHF57L3KFTMCKWSOMW366NRFUJ89N78PRHDQFFCDKS2N0F7MIG56647DZALXM46HV7UDTBIHUZWNUEOO	3
18	5CPJU9L2PT	W1HCBSWK91F3O0QVV22U42H7YMGITSVV6M0CZFTP83TJDNG9G29LV4R3TKNZLO0RGT7BAN6QJNWBI73KFHC1TJ9C56TP13DTCCDU	5
18	8P3KYCP9C1	E925SCIHPUWQCUDL986T4GD4RYPJC9G4J4BIJ5AH14PL78YJAHCEGBV858O3W8EQO1HIS4CE7Z19017SAGJ56CXIJCMLQGU2097F	7
18	B09BUMIAAB	Q0FF8GRJVHEB53QZJUMD89QR1X1E8J1311TPEZ75G8X5IJUMDDRPVB2RKXOKOMKMQKJEKAVTWQ7ALUJRCPA52LIZ8BFQLWR3XLO8	9
18	SMUHZ6ZLPE	QBDS73EE2GZN7I9LPTEBUGI5EI98DMAFLRWN7M4SDUF5PDNOSRI1K6PJ3HOY3GAQGTCQVWOCZV79ANPB4UQWDI5OBNUZ8FY7UZZ5	1
18	UIXWT83ZC0	736DGCY8QIP1M4JZOM7YYOIBYDT6APLYUA71UT7GHPVEE7VLPIFN1HMTU4OCS18B71HL6SE5O0QI3E70RHR2J86MYOG0E5XQRUGN	7
18	G6YJUIUX8N	JP7DK8B0D0Q7YULJG1955XSLO0TDA0I7TAH2UY895VUYZ3QKLGL2HR4W6VYUP70NRTNXNTZR39AJC4WVKJ14PQZCFU599OU75HGG	4
18	4T71U0G3GP	262Q49HRUUB9DJGG58B3LR2X0RPPCO4XPFRM8NURSUVA3A6EO09IFNELEF0MT2OGZNT823HRNTL06230VKAMOWSCAGI3XI7ZFPKQ	5
18	5ZJ4TJAB4I	8LUTS5VCNOLLA1J2C1D5R7WVN4FWVVQRNJW8Q2606AW16SWQX7DXHU8AZ9GXZ9Q28470EKLK4M9RK5Z4IZ8YS2K3KWJRWJA7T33C	6
38	N7ZLC5KXCJ	6LNV234VRZ4JLPAA1KFTEPSB4XVLB7RCWKMNVDZ9PH36OHL3A62SXSQQ3L0EHSTTI2XBDXPYVFE6WVWXM1LFF8OE45TJMU26YJYW	6
38	98DH79U5RR	K0MQE7SOT4IYD2PGNOKOSGHDFLBNHIM6ADCB9YBA50KBLUJ2MZK5NIBDTIL25FGKRLY9ZOHZNJS26F2UBJAR8RT1B9R0NIE0TATA	9
38	LMV5KHMJIQ	KC8SVSEZJGNQ00WFYMA267Z6RLEE2I5W2Y1GC9N9OC22EKXRRU4YTH9MNBAJN97AL1YB8QDZ8BN4F71HXWWHOHCUZP2A8DVPF2RN	6
38	BKEZFGXSRI	VTBRFZS4EHQJ3V1MZWDYEMTXC05P8ZMPOVCDVZIRUZUIM1ER4DPFNYRJ9NPO3C6P4A5ITX09NVEO1KKLVOV4JHCZD2DHK3YR3FOM	9
38	PIW2O1HZHS	67GMQ11UDSYCE3PRBGX8FE1TSZU7XVV68PZROS3PKFAKOFFAJ9191N01GX30H46R62DYD7DSMIYAEQFNTTYX3WFVZ8K1ZCHQISNW	1
38	LRYG3OO7V2	Q7L5JWSZZXZRPHYFJYKWS9FXM3KAI2VDSMCWN2U9W59LVJJ5TK84DASR2YTPMSR6BV9DEB2REK9WA4BDTOR830AR3V4YIEXEOCJ9	3
38	0I32H8MU6T	G1RRR02A6Q8WP68ASCKVRKSHDI9X5H7UB4MXAQLAHR7E6C3HZD598O16IKNJ0FFYTNUVTKAC0JOAMOLBP181L7WXCQPZCCKCLIVT	5
38	98YTCMB2VA	HYOC3JY90T49M48HNMV07TD5K9Y9LZD21UHDUYSY8XL6V00HM576A2UYVS13UZXBPBH1W4WZ472JHGKUJRWQ1H19ATSC7YEJ9KQT	5
38	0IIQTWJMBK	8URIICDALQOHHUCCHKIJI1DMU1F2SJ7Z1AK6FISFY8YCD4ZDBH29IJLHRFXQ6KRCTYPHKG681DVJCAI0CB1LQ7RSZDPAVCIOQWTO	4
38	5KUMKKEHEX	R34K4IFYBEQ67N4SFVVH7SG06MZ4G2PR3LUI6BVZM3X99DYYN5LA7HR9WENRTKRJY8CV3WWEA65D4H12YBQLRPUW4UV2YDFBMOKA	1
38	7FQKPIDC53	C41IGAAMNEOMU3S4G1JOQ1IB3P6131Q711VGZCKOTJRQGQDKXHFWBVULW0P1DJSVYRU2HMEDR44GJ24NLWDWV45FGJT9XTLK161Y	8
38	I6JF0RW5IU	LCLCCFH0OC45BPRF593WOV72FQ7TUPNAGSAT2UTYYO2HZDWE4F568CQZFS6WHXG8Y3ZSO7MLQF793ZCB33ZOTRCDBLOJX7QAI3T6	4
38	5CPJU9L2PT	D062TQ3EQ5PQ42O82OH1VQCTDYSY719GGX0C2WAAJ9VP932ECCQPLF2WXNZ57EHY6IJHCMFFOHRW5WTJ5OW5LU4B4DOP7ECE16T0	5
38	8P3KYCP9C1	VCZ6KAEXG1B3PATSMNLNIM870IKEN48C30KL68BU0NYMNWRDTVPTHNLIE2FBZAKL28AZ0IWNM1X4YVTE1GV1PP5POBGD394ZDMUP	6
38	B09BUMIAAB	2NK8BHQ0QUTIBKTPT6NDUKYBSUM771LAER92K2NHOZ7RX51YKKUQGLBRZJQR4S2ZISDUL0E0TFY4MGOX3YWWG532PRDBM5N56HJE	7
38	SMUHZ6ZLPE	HNUF36BXHET42YG6GTNYLE3XDOX228F6J6WLCQN82FINUGTHG90Y6QQCT7CPJI4J9WV5B53ZGP5F5QC74QV2HQA3QT1EO7ZTL9N7	6
38	UIXWT83ZC0	YFLFASRUKHC4EV3XBBSV2PSDZLIZM46DFMGKJWH8TIFMZKJM56J84M2IXIQZJ1IQK9Z2OTNO4UBTKFNOB64PU7I3U7WBGRY2AYB0	6
38	G6YJUIUX8N	R7MT4EKKJ8R4BXN626N15IQ6MIM5JSVEX3U8R6Z37SK9EGE4L5I2Y9ZIRQHV1OB0MNGIDPP6GT3N7Q1FESUNK3PYELRBZDBTRUX1	1
38	4T71U0G3GP	515QLVFFMLAYBRJ3XQS7SE18OHCRJ5N39FI1Z69IKS29QMXW1Z3DF3R197CDSX6Q8HZ6ISE1RKW9L1RCUQ0UBJXFXR1145ZXWLBJ	6
38	5ZJ4TJAB4I	1NIUCW4HSPIQATC7LPZTTI11N6WV9MA0HO3CR99W28EBTL4LW0K6M0DSVRHFAJIGPSIV0APMQC0UE0IBCK8IBENRLKQ913WT08WB	1
62	N7ZLC5KXCJ	JVWK8QJATO5JGDZK9ELE1KPTPUWQH4FDH83ZM7DXER16U0VZ6I03L6M8FC4O333ZI1CHKA8CBXAJSS8Z87T8DL2KW4TKCZ4KYCY2	7
62	98DH79U5RR	OP5JY2X6CQWDFP6J4V681VPQY9M2ZVQ4FAURYYPTFNUO7G6J8A3Q1463AOVYQ4HQA27F4OVFGN3OABTRCC4Y19CLD1RJD0CKGDOE	3
62	LMV5KHMJIQ	0OUPYKOAS285DWOASYB0VCD6MBQKTI7WPJLXKJDYYLU8SN9EYJXPNOWYLXDW4DQK5LP4K00IVMBKREN8BLWKURJAWXMWGQ3U5KDG	9
62	BKEZFGXSRI	F37TP4AMMGGJEUSQGZNBPHXOECESQOGBGA6SY1FXJYKQFMB5LDZU0ES8GTOMZR57AFDEYA2OUZ206GI1BIHNZVLBR7LFM3713NQA	3
62	PIW2O1HZHS	6HKLKAAM2B9KXKQJSHO4BX0ZXC12A7T0ISEB7BPVKZZ6L4YSRSKGBGIJQUYHIIL4SICFFOMQ13TL84N2NIKSWMZCK5VMNIMCN4NC	8
62	LRYG3OO7V2	TMCF3OIX6LWH53A73HFT94K39DTQQ8DRLA36IM38QPNT8FSOMFUWHS2ZCIF051G8HE549EZQOHDUR044VEEKNRJ2HE39HDCYIPM4	3
62	0I32H8MU6T	XPIQDH9PIIMNLF1X6UZ4DW4KZJLEOMBNAU7Y54KJKM96RV58LAM4W9GAU71464B6G8N1HC2CKQU1X73DON3N9G1BO6E7CPNPKD0T	3
62	98YTCMB2VA	E0IIKUGOONXEXQTBY69GLML8494CFQTHK5JWUEZWUX9SR3P94OWH0M61PKOLZDI84P41G6QTHNWYN2RAT5I13MQ88SHK0O6QOAYB	9
62	0IIQTWJMBK	X387DANZINX2N145RER963XYF22QFJMDQC5BK30MDI0EUSNWCV76GCC4FJ2KH6U8BTML63VXOF5YCTEWPGOUMQ7O9B5BBPFHX1DA	2
62	5KUMKKEHEX	B0I9JRBGO1WEF5AR9WVW8M47UV9AYALPDQOQFUC85HUJI66UEZXFROIZ5LPYRBSNQGAYRULOTW001VZXZP59MF7ZIYU4FOR4ZH3B	8
62	7FQKPIDC53	HCUNIV5YR8KW18CFSBKILQ29RJFF5BT1X1SMKVDUCB0ZKIOPOYGGS2U1KV69Q02QOS89QZ5770GKZCZI4Z0H4NJ4H1CZZEDLIKL1	3
62	I6JF0RW5IU	P9Y3JI1VKBH6XF09UVAJD1ZXFI2W4BP179PZBNVERI7Z43B9NMXYKSFXKBXAQF1IWQ8YZA8HA515492MG3JSN0QP31PA0UYMRYDO	8
62	5CPJU9L2PT	NJMNQYO0K3KIK4W5I559T47V7QPGPNF6NS3T7E6CCYS8E1P0CQJ3HPLSL0Q9IHK7XO42AD8D8374M9RGBYE9DMY8HKIGY634OVLZ	9
62	8P3KYCP9C1	WZ8RF4OSQGMJJ8UCL3KZ6V042OBADQ0X1JO9FR7RKQ0E57P8J1C1B9AB9EZ13OPAPZR9TU7452PP4W959C1LN9W1JN9B1GY6B0YG	4
62	B09BUMIAAB	PPY4I5IUUGNE410XDWQD00GU5CYDSOD73PUXCREDNGZGW77P8J8EHDZZID8GGFCGDPLOHCUVRN0TB987FJEJP90Z04O9S86HESDH	6
62	SMUHZ6ZLPE	SI6ZNW3NGYIFBB7A20DZVXMXUCTRSOS60MWBIUCN6MUGG4R78GL2AS945JEKDM41FMOYP52IX02JDFR0UVSLCZ6IM1F8P1KTR3B3	4
62	UIXWT83ZC0	2SDOCFKZ0102N0R3TYPQFMXZ435PI1KEXK1DP79UWSV9PGCB208EVNJQ4NUJJ4Q9RWEC9NOVZ53W1YKX04XS2GTKALJBNZL2CWR3	1
62	G6YJUIUX8N	9BOLMO0TXZGD6SOG7GLD4BYEMI9TBUFGQV12IHP120NVC8QH6VEPG0I7NJ8EPGSCT9XL1V800UKDYCBO12XPQZAZM3P8ILLWHLBD	3
62	4T71U0G3GP	FPKXNYVQEJLHUNXTCW48787G9SPIX5MA8DVMM2CBOJIUE0X7YDFYHENGSEX5IN2I6KJR1KGKT2UX0MCI4STU0Y24ZP3HEH2BQ9Y3	5
62	5ZJ4TJAB4I	GGO64FPU0QGCOA03IRISP1MQ9FMASH0YI1XLFX5TNJ99XFZGBIHSPLCP477Z2PCSZR3XMPXVVZEF2M33PF8K9IJ7ZIRI0G08HQJG	4
81	N7ZLC5KXCJ	C3WUW60G6WRDEJWQ2SRI68E7P4P8G7LDWQNMLZNMS02VAEV6ERP818QDZZF1Q1A9LOQX6KECFFZFGS7KJT4YRNLYAJWWUW51Z2KW	6
81	98DH79U5RR	8A3NN2WIK7H24S76MR7C1XWXSSSK7QNHKXKTALEUZQZMP40D74NLMT5KNG44JMK4T9RGHO5BMNNL8JHY2OMCDB511AF4QJKMF53Q	4
81	LMV5KHMJIQ	T6T8M99FTLD8GC49H0RDZPGIBUCCAGCQ1LJS3D1C6VHYB5JGPN7ELMWDZK7166FNJXH53MGD9PHEHSHGL5XXI7FOYF2SGAFAP4PO	6
81	BKEZFGXSRI	NNDG3F5FS6HD0PAJSFLR3HYTX79JHYNC2T7STQO2JJFIUPQUE07YE74GYTT6FV83TELGSSZB0SHTBQ8HQOFQ0Y84Z14A7RWXKMZQ	2
81	PIW2O1HZHS	JCWB67VZKEIULQ1QSD4GQR1XYEJ5UIZ1SDGMSO40MFPWWQWB5H2I4JY2K8M2YZFBPRBIJO7DJD3KCFBIRHAMQQ6JONBUBBCXANGF	4
81	LRYG3OO7V2	N1RJZ90QN0F6EKRZ2V8U135MNBHBGKY862DPSD0RF3AX6X71V8H2HUXU5E5X2ZKDBHALGBGZ4RO82IQ0EQQHC60LFTTOHDYQS6WY	6
81	0I32H8MU6T	VUT1S8ZFY1XYFSMJCBFQYGXR2R038P5V1DT56PT7AGR15ZCUMGQ5QI9O7B9BH6HI5B6B9QMWSHPSZ5VCOGQ19AFSEE74QRZE8I63	8
81	98YTCMB2VA	BV644NI3RZCQ7XBQPJ46N74SSGARLTQ81KNUU7FX6ZWO5OT4YXT9B7OD1NMXN1S7JDYXKR6RDHAYKPXDXF3X9Q745J3GVRKFHZF1	7
81	0IIQTWJMBK	6UH0B63602L0IAH7482F31AX06V65QVK5N1VW68UE8FRSPNRCHN0MW6ETTAFK6AJGA54JWL79IB5WTFKSE4XD48JRWBC52KH75KR	6
81	5KUMKKEHEX	SHQ6P0DUARAO0WFCMFLCWNWVIBH8470IXZA6N1YD4YQEAYFFEEV09O8EV5YNTFZD020BWIZVQHI76RUU6C30MAIJ15LSDKUY8NNH	9
81	7FQKPIDC53	DT6P9J1GAHDKDRRM900URK07GSGWT9TDMW2S7KM1QC0XHH93DM8WXXQ328IRDFXBY97RY8OZN9DOTCZ9SNTGA6QZF9Z8C5XLPY9I	3
81	I6JF0RW5IU	REE7JJXTCJ0JJ80VQB1TILZIQXSL284CRZBIPI0X2FDZ9Y26709XIYBGP5RW0M1DOX2U7RGHKE1CH9J14WNB9H42X42T1E6POALL	9
81	5CPJU9L2PT	H8QT1ND798QVZ1E8ZEH2A6CZXQFHLYHX75WX7SH305Y6M7BM2RY6DS5K506LI6WL12Y3ERAH6OBEIGMZO2P39KTP9L1GV5V4IMFT	3
81	8P3KYCP9C1	HIKQR9ZQ1CZOH7PR2LQII42Z3VB2H55B3QGUENSL48IJC2O7FNQBYLANPVW576J5GXU015MP3EOKVTWAHDX4P4MSP2FS0XN7YNDO	3
81	B09BUMIAAB	XGKABHU6Z259VX3JPPLLCK803YG1RWHQH2T7N3NW2V0AJTE9TXJ71DFMHTGMB2PDUP13D65VCZTRU8RJUGH3MJYEXHZ3WAV9GWP3	8
81	SMUHZ6ZLPE	L5X2Y5CUX1JC624VW0K0XF6GC8BDTL8SXRILUBYNWU9PQ00I0OT5FCFG9QZZ48AM30OPTTAUC6ECFRZLI2MF1CNVLCLDL8TXUWWZ	3
81	UIXWT83ZC0	KZHN83I8CAS0NRCV4V0N3DQH7JDNQSS5AA7DF22JEXJC3M8RRBZB5MSGI9QZZ5RURX0NT8QC3QIG4NNUKW6O3R9XS14FLCUJFYUG	6
81	G6YJUIUX8N	V8SVWIODLL4W5OD8D0AXD41DK0068BF3G8ZXN2HIUTGPATQXQKB8UTS0GPK5RSEKFBP6ZPVKT1CTYMD1KDPY9HJXQ9R8SL1CP6K8	2
81	4T71U0G3GP	T8BZ0P2Q9B4LTUOCQK821QZ7W2HAAE1BEW1EO8J2QHR7XW91NA8WLGNCIDC8H1P5K2H63JYSBFLT92JA3QXAFF08JY6K5LVZ1WX5	4
81	5ZJ4TJAB4I	C7DLQVF53DQ3CE0EPZECJWENNWZUW2NEOV0STYYUUCPUPQ3G4UM6T3FP30835VIB0LPROHV1ATRGHT763T0BQQVVPKZ205Z84O4E	1
106	N7ZLC5KXCJ	M2X8U59L8IJ2BAM5GVK04BDR2BF3SM2Z35R0DD5UVJRBQ9Y4NDX2TNHKYFGTZG2WPT9GSV2D0ZEUTBB2MKQPYAGPYGB76L4PQ4V6	1
106	98DH79U5RR	SL2LTC4JW0XDNHO0N7PNTRMT4HO4ZDZPE139XDF7LGBPO4SDPZD7GTQA9JRMXAUSBH8VOPCK2SBNQ6E9YLO9A2JUL29OV2JLWSNG	8
106	LMV5KHMJIQ	6Z9X2EXRDUDESYMVUSJ8NKVQXY9I017S8D1VOMHXVDHI6JDE7ZBAEHRWET9DFP1MWUGO61HHKVMKDMUOV4KAZ7N0WFQ5NERGL5WL	1
106	BKEZFGXSRI	ZIGS40S5GS18VSLE0WYGQ11KL3GEF9H0JK5WES4H54PWY62VGCUI7EX7Q5GAUOZHKBZKWY9I1RLVMEVPBU7DO92EX8FJL4WQFILX	2
106	PIW2O1HZHS	S8SCMQP3CVMJ199RV2LIVXYS06744PD28ISVPACSNKUN39U4X9TPAOV4K9MPTV8WRTKSQNBU035KCKY0MDH55Y2TXYLPYW92L85K	7
106	LRYG3OO7V2	CNJ79ZGTK29KWCQND031142CV6D4D8EPOBKZ7768VAM5LFBUTOIHCT8HVHLCVMQLYU5V20QG44F0S61Q4TKZ06M5DDD0V4NITBH0	3
106	0I32H8MU6T	Q127BNINHZZP5HCB1V1IARZX0V9R7GQYAHN1S1YTER5OOKZWKG2PQSJ8CFHQN1QAIAOY3KT96IESVKIP5NG0OBIS7PZNUIFMB5GO	8
106	98YTCMB2VA	B29X3TIO0M161VAU0VG260OVFPYC1R0E4T3UGDVR9EGC7Q2XF2LJ9V9LOORN5FWJWWCI1PNXAZ22TMXZXB79GQFIUSG2VHW4R7PL	4
106	0IIQTWJMBK	T5ZOYJK3G1B0203HXDGR4XJJVB3C8LW6MLDFIUSH5PN0EB3R2W34J3T6VP3WPH55FFOQXY9DV8VPKSETIMJLR1WS2HU2151XURV8	6
106	5KUMKKEHEX	M4EXZJLIDWDKJND8TONT6YQEGMZH7527G76RFY1SLKYUQRRRXZADHP0XOAQNTDKI3FEMRV34W5IW95XZ4HTI4Z00GIDEIO8H9Q1L	4
106	7FQKPIDC53	FAB6GQLGEXSN1TMUCNEONFIRYWI6BWTDLMZGRLYIOUCVV0R5VW7CX6892UITIOFRDPCO3FC0Z693DW67ENLOYRQON0O7DE9AOURF	7
106	I6JF0RW5IU	CBQTHN17E5FXKP4D02W8XBD1FXU69PSF1ICM45RDZRI4JK3ZE6X14HBB7ZOU247ZN96BMSI5LTJG2JR4351C10KTHAOFQ7L4TSRJ	4
106	5CPJU9L2PT	1MWX1QL75IYHT07D47WZM4LECPNIOWJ2HQCTFO9K8WM2Z87HN1YV5UC7ARVMDDTI869CXN8P8L00RTPERF4X7Y7XOFSX3WG5CD33	9
106	8P3KYCP9C1	4T93IWT3MPQCQ57J6LK9MYS5KWLF5XOZVGXV44YBN4CZBVN1IWG2T4WGBESWLN7YB1QKILOCWIVSV33YIT6JRWG1UQUZLB096NXK	2
106	B09BUMIAAB	DT6HEFLIDUIL3O1RYHPUZZ11Z0VSVVIFSTFA9CMQ4SQ6MORX8SHFI0PN2FRNU3XRMC3JI1SW480GJ4PLJ7TDOC72E2H4U96B58UJ	6
106	SMUHZ6ZLPE	HPGAVLJ9JD7ZGEWJTDKFBFPTXB5BYKLKF0BSND21X25YKEO5K2L4KETB9XMTPIL82XUPCE6QKTRIK1JTX9168QAAH9SZ0JLPR66X	5
106	UIXWT83ZC0	83G65U0XK1IO26PRO9MWTICVG0BHC1N4V9ZGUAD5JN6IKL8M58C6TA9Z0UZFSTVTNN22HJ6O6QNGM3L42YMDZRKV99PAK8N02N46	5
106	G6YJUIUX8N	FFWCXADX3N7J4N3GR46CH2H36E7DWN98OLWT0BBQH7GWS0PVTTKT83MM72GTCAAQN85T0KQP3P5JWVKFYMTDCQAU9KV75ROG60IU	8
106	4T71U0G3GP	64JD5ZS8CZMRA4ZQ7N77KTQYSULBYM6M0K2RK9H0RW7UJP4WYZ9MLXUMOUUKORJZ3A10BHG7FHQYW6PCZYN8NTAD0QDZP7LAMH0I	7
106	5ZJ4TJAB4I	EUQTBHDG5ZSFRUZDKMJ9Y9VERSI5PMPFGOUD7PMM6640UU8MW6B4QI9F9LCT8I0TKN8C9VG5A7C2F5T6U6JTKUY7PPEVN3NYFLPH	6
107	N7ZLC5KXCJ	5MAZG4TGG9E2F8C9HIZYAXURVSHTOX3PLLYTI3E0E1IPA3H4LZ7C0TVI2TEXXA2TFYQ4KS0NE9TIOEQ2KMHYZ1Z20Q1ZYQDE9ZKL	4
107	98DH79U5RR	NU29T709M3YCMNK2D3O9XD31AYY6PJY4FP72OZG483NWCXMC2L655LYJ0B84J4TDF466QRNNXUB4ZGYMMVDEM2831XCN1LVDKKRI	7
107	LMV5KHMJIQ	QWL7TILK4UTMVSX0P0M6CE3P9WM97UPZQV682G3UWT7DSBF27M4UFMXL36766MMJE369WY8J71JTHZ68RTBVZ5UE7UF6I6YJHX8Z	2
107	BKEZFGXSRI	FGIOVWNCEDDA9PML0UJJ1BBTCAAC9MT1H3LM2HDIHB3QB6JRL8QDYPNDEZMUWKC2UM2GDASTQBC0IUSF1T1A5QD1PIHD4SW68A6Y	1
107	PIW2O1HZHS	CNLQ6WWNW4UHG3CTC6DIB052PY7PF2HY3CYGPU93QO3NX5YZTM6E2QBMRTAHYHH4X5NDE6ER7J2X7RETAI525D5NAMY5U1FJG801	5
107	LRYG3OO7V2	VVXIOGTXOOAOQHQLO8TAAC1HI7FESQ91NBPXIUQ6MZW7YRDUY829G1RS3PARAOF7PIBO23C4SXYLQ4S13VPUY9UWU632U867UYRP	5
107	0I32H8MU6T	Y2558RTCFC96IYP8VJQYP359JKT1111MDLE3UYZRBTP445LKQ88OB1A566VY82LOKX37UVO7U8W5OAFO8IK22NLLKJ6XCBTIIAUH	1
107	98YTCMB2VA	N05UB4CEFQ51HZZSTV6LSXKY04SONWNQ8MVSOH1SIGE2A64M30ZPX5T0PG4GMX1SCP35EHDL4ODMSRY3AGUW782C25CINUGUPV0V	1
107	0IIQTWJMBK	8IWXNUJ1GH7SAGGCEUEW0CJE48JHT661CZB789UNTKVXE0NOARLBV9N69S3PKBIKKGPKEIEEA0CPQV9EV5HBV5FDMF8PFFCSCLN8	3
107	5KUMKKEHEX	CJ1MGA568PNSZ3P3GYOAL89JY84XTMEHB3SVPZP5KHOZV7QLXZ5X879DKSXHFHMVKFR6L3NRIT0EUJY1STA4RRJD3OL7BHZC42PP	4
107	7FQKPIDC53	UA3MOOPG4TA36ZWHSE36NC6SPPA4YK14JL7SGRCC3795KDFSC5LYVSCSEL68NURT1GUU1DAAB1CQCBHMKS138DI1JPO5VEYJPPDD	5
107	I6JF0RW5IU	V084LW4PWPCDUX52YVY73KMZEP7C3AX7E2Z138XQOLX9L2AQ2Q04PFZKOJZ5Z1VV2F918D907HTRWMNMORKNJ2S8DONTI11XZCHG	8
107	5CPJU9L2PT	JRYQA6HWHYB5MRIQIL9WAYU0PRGQ51UFGUE9V7J6LL50LX5JTGR0IT2V78AS001QD6Z2MI5LBCLZ23O2V67YJ36X1TBX60GUUPWP	9
107	8P3KYCP9C1	C6KLGYFIC2DTI633CGK9CA3GIOL60FNG93T9XNDE1OY08DY3M1RJMP6CDDC2NJS7P6UON4GZCFIXLCIFZRT9XD4T6Q5TLK0S51LB	5
107	B09BUMIAAB	JPSV2GHHI0B47C6ZTJLCAR68WN1OZ1U0HVQBBN57WLX04ZNI43MRA8S1ST9OO2RQFKWLW4XFONPY4FD6ATT6PD0JDYSRORT44GVU	1
107	SMUHZ6ZLPE	BWAFHDWS37MQCO4IUBBUMI7LF064V4XUT387T1HAD1K0FBMDYWJFTA03YZ9RG178K26JP7Y33BQV8GFDN3G8VRATCEI4103L4LQN	2
107	UIXWT83ZC0	DX07QLRTE5ST5DMV8N21NGLZ4BDIE1W019KFQBEGS98I0K5XQ067YV16MBCOHJPNI2262HF6IVJOIC8UFQ1O5YBGHO3P9Z9JUUA8	5
107	G6YJUIUX8N	94JV9ZCMNYKCRJ1SAST0VZON06SWA3XBACGWR259944ZSMRQH0TCQI6KP55CGPMTAIBODFAIWU014Y5NPCOJKVV2G6GW723TRLZJ	3
107	4T71U0G3GP	CNC0LP5RFP1ASXDADJOXJIG8OK31HJT9VCMZMS9FZKAQPWPFZSOCKWB3GDMAVEK562OQLOYUJJ79H0T25YBY4QY8ASTIG8TU9FUW	2
107	5ZJ4TJAB4I	84L342BZCVQTUE7DWBPDPP25QNKZM9CF7U74049YWJ76DYW4WRNEES1TBPNRRMNDTKW9HCM1B0RGR5211QC4V8BO2O2KQSHK64N3	1
132	N7ZLC5KXCJ	WXTFWCOBVBFXWZBKSSUIIG2KCKSTHKXS8YE2SZ96XMHMWW33F9NM3U3P4JCLU44LNXY8VI13TYV69QXPRZNH7KZO4Z7JWXL2R689	9
132	98DH79U5RR	5I6IT3E87QOVX44QXND8KD5LSG5M3ODRYRVRR9NRUQ7JTX93RM4S5AX2MVZN72ETM77FIM9XAVN3GW15HB4RTUVX32F5JAT1LN6V	7
132	LMV5KHMJIQ	3UEMGRKW4WZ34F57XA1MJLPHEOABWR20GEOR0EMDKA9GQBP4Y4YNEJQRE7I2RIAM38XZ1OHTXYBILJ1C8FN13PV7X7M35TVBAXMR	4
132	BKEZFGXSRI	ZDJWEZPHIF5FG3L5ISOM0C3COXDCAIY6JZJCEFYZGZP1RXZZKG1E8EWXJHIRWMHAQ86RUI1D4YGAWCU18N24QT7ECV266HD3SPKS	7
132	PIW2O1HZHS	IFBOXKK7VAHWRSJUMT7A1O8P4HWVNSH1BA0I0P3IXHQUVJPZ4IF5NS93GVTQYZUD3PUR2A470YNU8O4V171FMLNTA6BE5MU7WM1F	7
132	LRYG3OO7V2	763OIFZEP4218Y18O1RCBQ59ZBNDP7WWY64A70EGYOVCJN7X39HVKDXQB4ZG2VZSIGCC40AYWLNW53ZLEZKPZALVJN9DB7NCZC4D	3
132	0I32H8MU6T	53C9T890BUHENCCLJ2H4R2Q06WZ7K628VAJ6HQFCM4I219Y4L1PKWJ3CMLD7IBPE1JSM3GE3XFRWUY9784VTQSMMHGU5NI3KPDAS	5
132	98YTCMB2VA	LBFWWWR1GRXMG9NQ5XJ6GFWVJQPLHGRXQQW3Q6464VAZ6SHJP4UQ1VKGOTNGHGU9AA5ZMU982NCUE7Z0IG5MWA65GQP7TXYYBAZ5	6
132	0IIQTWJMBK	R655VXOTZBR3X7BKHN9EAT5FCPEYOTDI4C1JARAMRMQO7D50XN4XZ1X8A02GS0EF7I9UG2JZMWWXCRH8TOBAZQSCP3IKY441HKRY	2
132	5KUMKKEHEX	LU5EELDE95TS4WEYEQR06ENT9AR25Q2AS4I4F6VFP8Q7Y14HZCC498HGGLED3KJTDTAAOKTI4MK8YP5HGKC2N7ATWCX41RLEZ74E	7
132	7FQKPIDC53	33PT49XXJR1Q77TIQFFTQNLWZRNAGJ1U0QMQWJT7N6NU6N4T26I1YVLQR34MVWRA0G0RVCVGWIGTA10LX4IJA96EE693PGL0OM3Z	6
132	I6JF0RW5IU	M70KCEQP1P0CSZ1OH91KWMZC21P6PFX7AYK6R884QYNRI06RULGNCPAAIXSKZT9W12B4O46JA6479H4B48MD8K5VXJX4PXF6Y0ZQ	7
132	5CPJU9L2PT	CCZP7MFVDBA3RQ0G5YQ7QGFHC3N07IIROM16XYA7ZAUIWB8HP03CJSJ57RND9OY42SPFY4SHXSHPW6UA5FLGPGI5D58FL68KMZQD	6
132	8P3KYCP9C1	2TVHVP0L3JB7MI3DRPVKUC25M50U6D6PQPCW0831STJW7I9YEH4J43B00Z50YFOZMVQ7GHMSV41A2F7E6CPYIWUWNL5ADDCMETJM	8
132	B09BUMIAAB	CR75LYABB7U203W00RZA3T4LMPS1P5J6VM4US368UUMNKHMKQWOCUL8SWVT6FJWFYYHO9BH6U0QIHRAECIL2RGLJNL86KA2K8GZW	1
132	SMUHZ6ZLPE	7LOORS35ZLFVP4773YSM8BXDLWU7FKA2ODE76O9YSOXA3L5F5NESGJC6XLD575ZPKNGLZABPZ34UNWJ91OC2FSVFBIJVKD0WYI0Q	2
132	UIXWT83ZC0	TQ4LZ2NOSTBBEET26J12AJR1QFVDH5E634H8IQQ0I0TZITG9H4189XEK9C5UHJHWOEHK7VTP3BTJ01T68V5NDG7FZ78FU5S8T6LD	3
132	G6YJUIUX8N	6CWKME7E4THT9VVN4THHBU9WO48SV03QPUCTJC1B9B5N1WVK7UZND6KMCA6RGPSE01EOSCE11FHAYW41JXVBAPMTK0QJFK5UT1X9	5
132	4T71U0G3GP	G14Q7V7YJXQFEHS3RDKOVE2W4VRKXQ795KC60VD3P4ADAEBCM0CYNV6C9IVLEWA30QJ4FWD5AQ90DYV0UP77OIWKNA6S91Z24HMT	8
132	5ZJ4TJAB4I	G70XGY6VG8KW51YZCOR49QFZU6I0H56MC5NSHKIUZYHBV5EAAD124Y501ACKPGOKC8UANGR1G7FKJEDY1IZEDDRNAX0HI7ETK68X	3
161	N7ZLC5KXCJ	EW4V9V7TUQX6NSHQJG8RHA0QKTI2WAMFQNXV5SDRT4PGCK4P7CBZ9GDE6NKQNF6UDSQ94VU0CQ7MUTOAZ34T9XGKKTZSHXEO75DU	8
161	98DH79U5RR	4VMRKXSI0TN8K0UKNVQMFZK6CSOMTPYQ4F5HSBYAXCT9MT77UDUKWHYEKQP1IGZL56EF5M2L6QYDFLTSVR1P4O3WQ07CW71QNIEP	4
161	LMV5KHMJIQ	1CILJNGTV8966F0PJQQDSYEOZZ9YI07GED3PSEVAXD518GZ1ABD1XL6D74VTORL5B212LL6F4QQO3NPT9IXGWFS2H0RYSBWG290G	4
161	BKEZFGXSRI	6PZE87H5RKUOCUG3EI5J8VV3IX23KW3WJEC28CYIK7ZQ7KPRQMX156PL356LEOV5Q7F7RN4CUW9B6F68HKN79C1NZ18DFND6L39A	2
161	PIW2O1HZHS	RACSVGI7OOY98D3AY6OG2IZO16HSCZCF53ZKKPN5SPKMKDHJK5X7V3MJKY0Y9Z4YMTDENT0JSTXM8MEXZ7IGCEUCQQ9VYY53UVA0	1
161	LRYG3OO7V2	C50FOPBGAL8UD9BQYWH9BY7UEU3X31MLNWWBSAYZS5QEBBUY4M69319O8GB3VOMI9WGQN98X8RRFI2TCAE3R5NSWXIDL94DETHFO	8
161	0I32H8MU6T	DL4OIBLK3GGX83QU5NVET3E6WYDOMWAWEG639CWMGM3C7YABXTX4TKMKG71U777HFTS16XV20J7G9C97XC038FC44WWBKCOIPW6N	2
161	98YTCMB2VA	IE974EJMFKE8464GDI9QX7KBUSY5Z0NFV1P716EB2SZMRCQFTCMN77SL47MMQOWO68MDR7PHD8XFH7TRCSLWO9IYIDD3T2VO5KQS	7
161	0IIQTWJMBK	MXWXEJ8JND6O5K7D9960Y5O3VYLMJJ6RB1Z4Y9K0JP49GPXSXL5LT2BRJ2BQ8W9EGPNEUCOAZGQJAOWFA3Y8NV8IZHV6832XPZ31	1
161	5KUMKKEHEX	T7V65VNL2Q5F6PE7A0UQEONRSC5O33KV5CQ6DBSAU76100BNXZO9IK8EUEO3Z8R9FJK38H38IU6GSV02AR0DOLNUEMM9XYKWP7VQ	4
161	7FQKPIDC53	IPP6P0XO1W8NW3IHOU460YW53LTKJ1UAJM1CLH8UZFNZNWA5COBM1UZT2UCEHNEAB8DKBF6GWJGUL7RHLYH5ZIIZXHK0E4NMAMXP	5
161	I6JF0RW5IU	036R4ZSNEI4C52SFJK3ZOW35FC154T8KCZU4KO4S0MT9PYJB4H1C30EEABL28WSUJUAFIY44PK8BD3PR3ZBW26QLVQ3JDCUE3804	7
161	5CPJU9L2PT	D3GN6WT2CAGV49IV52MEYU14V1N04HFCU2Z65J5K7TSQXXJDLT7GO09SBL2FJ2845EABJL0W6BGFCLH7SJOKK9Y42G4TR0AEVXUS	6
161	8P3KYCP9C1	H3A2LJMT4Q0D4W9OXU6PGICRGEGBCTO0YLKQOR8ZLK70DQXDB08DYCP90SWHCLRKB9OSMT9FWGE6KMNZRD9LVLCV5LZ550X92XYE	1
161	B09BUMIAAB	E0R02QR8TYOF608LGZ062XA3EK5SEEXXJXNNSU35UXMXL08AZYW78HJR0XWSU93OA06JMV3V55LFKNSOL43QRZZBO5W48KKV37WV	8
161	SMUHZ6ZLPE	ZXE4BBD5EHMFIG0GN7KB44R89WVU0LM07UWGYVQXVGJYKY0ETPPALU94GF5OQSF25WIYTTR2QWPYU2YK6QBK5LONU2ASZBHDBR3X	4
161	UIXWT83ZC0	BUA8WTZEKJORUS9R46TH5D1T8DOPMXD8A445ALI1ZIJSVBETHVGUKQU83R9TFJ2XFPR0XERTX2SX3I7785I0RTYUK6CTMZWQPWMF	5
161	G6YJUIUX8N	O6DEW6S87EUTCVJACGW17P1B7H8FCHH62NU9FV4XGVN1S9JEMPNP0NW8EBGP7M6Z7Y1YBK5QL8VLC9S8742W41FO0V4DPOZ3ZX44	3
161	4T71U0G3GP	VCBT7D12L6FSISCTJ5FSM7QQ2A7J1VOFYZL11D6XNVPYZUG6WJQ1ZL5YWV16GSA0R94SHL2G8RE1S11H4BWSEXPN4XEGLAR5VYHZ	7
161	5ZJ4TJAB4I	YZLRK2HGEF54TCF5SV4UQYTGW489IG3UBRGMLA44HGZRJM27MACDMFJ9FF5Q4H88ML2C63TR0AMK8C6KCAXID0H6HGGGFO9AI1F8	5
168	N7ZLC5KXCJ	ZBSQUMM38ADIUO3UZ4VD54ZWNMMAMCH680M9E1SO5DJFD7VAGPS6T4X4L6CI9MR63GK3B4P8MHI2VUTQ1M46TKMDCRXIYKOTVML6	6
168	98DH79U5RR	18MAUUMW4J1MWRXRVMT4H1THGJB2ZHIIX3ANR59ZARII55C31BAA2CPAOF4LST6XATZ3RJAZN330TLLKGIBYGIPVNA8MAYHQUUIM	2
168	LMV5KHMJIQ	JLRBKW9IZQD3TEKSIR1DEPQLXZYWNF8C9E76UX5WQNXT5TRT78LDRIC34FNV7N4TSA4PHN7UVFX117QEHFYO35V0CEBOJKYDSEA4	7
168	BKEZFGXSRI	BMTB1RLVLB7ZJN2YQZWOEMCLSLLRTIX6VPG3ENCOJE1CEY965OCOOPTZJISPG4BCNAE4H9TCWIE9V9G4LOVFGJSF5QT65WHOCZZE	6
168	PIW2O1HZHS	FY6591FKTDJBYE1J65ER880QWHAAZ76KCJFZZJGRM4LNJ4HSPFG3UWVH8QI21FUWG98O9CUWZWFDWNG2ASUU1DZQY71IBO0HKZGK	8
168	LRYG3OO7V2	3SNUTE8RRVVJQ2JUA5DJSZBKLVK6737G66G9G9H918GMG9VVQXJ3CANDQDJ73CTYXONUVKNAXESUSZEMAYPKTDD5SDSD0KFZPSY2	6
168	0I32H8MU6T	AAGJJG8S2U1967EWJEUKSBR1JJN93FAAM09YIAK7FM0T0E4MBCFOERD9SO9929ZXU0WF7PNI3WEFL8AFPA709W64XAG3ALFGXC9A	5
168	98YTCMB2VA	YOVZ7URM8YTO4T1B8Y832S7JTHSR8RJ9AY1WMBBBPRZMWPG1NFYNBGYGRMFZC9OQOTNG2FY7X6OK3VWEB0D226839UEA5L9PCI7C	1
168	0IIQTWJMBK	A8IQ1ZE2ON6ZBYL6VYSVUGHAYBL78HVXTCA25MBG4BVHIK4XXTRTORR30H1ZOG3G1IG9XTAJXM1SVA1NHYKP0BJCUHBXUL1XHOPA	2
168	5KUMKKEHEX	59ESI6C08H0POR06OP08EOQRMYLUEKGU1JMZF6SEHMV9KIG3B039ZBAQSWGTVRVXAGYEFB1R6V112RHERRTNRH5ZI5GTZ8TZ088E	5
168	7FQKPIDC53	BYA9MCDJIYBOCBD7IG3L86K4I17CCB4SDUQ3TOFE1Q9HFEX6P2R1F3VFOF1UEBHG3SLSVKO4BYTS6CZDEAWJTDNK8KONWVA0I2NW	8
168	I6JF0RW5IU	FLFNX0QKCILQXQDO7X0FBTK5BHQY2KDZCL8ZR66M6A5CD69F6LKFWQ1WAJMPK2R2FWNMRN7B0NIBXI2EIL1Q97CWUMZHTQCESD7R	5
168	5CPJU9L2PT	WXSNJPJI081QIG8AA3HU12EY0RJLDSULLVVXJC0S3O4O70LJDERJ0614T4X1F7EHOQFWVL08DY0N8009G9H9BKVO30EOP8M5KW9R	6
168	8P3KYCP9C1	YY2NTGBGN62DYVG0EGE5024HLSEM5DL0INRKPVRDUIQ4LL0MGEFQ5W454UBABYKKVB5KE5KSYAKSMA5A22G0745WTVQ4URC58FJJ	4
168	B09BUMIAAB	QIK4W24LMT4ZAIJSTM0GJ1SPQ8H8PUH1VVMT56LCAKGCWFTI2MO3SDGYZ5OXU652LDDP6ZXWBXF8VQ2KP8FDFOISOX4ASXSEOO0S	1
168	SMUHZ6ZLPE	DMDZ1148IDICDIV02W74UBI4WENFATG0KHMWCNNWNTFUW7PP6OV12YRBDICXOZ7Y6R2558XOILRA5YIZZ7JW8P8W0KT3L0HYWRXE	2
168	UIXWT83ZC0	TT70GSRGQFO9N8RPL0RTGFVP3DSD3OOBETFNM516QPJEF4710IK0FU8O8S7D9NNB1N532DDQ9VD15QJ9G0NUEX5UU1O38X6DBHN2	9
168	G6YJUIUX8N	D9XE41URHSSI76JA37DRKJAYKSLY9ZXDRAC1ZPJ6KDMJ6VA0XDIKJKX4884LP5RS4P164RKNXHHH611ZRUB6RN3GMI21U8QOW4OR	8
168	4T71U0G3GP	D6F24WCDQ8GGF354UBRWUTWZT2Z02VBNK5OX6DW10D6JVUPEVUB375JTKQJC6MK5636KPH7RP05RXMD8NVFHUIQOW4NQ3U4O2BN2	6
168	5ZJ4TJAB4I	EYOWTOG9267NKYLHCLXNRYV3RX45RYW9LLI60VA4JP37PCT5TGZ0ZOFQCUE6TLSDK8B9POQRK3EC4XOOE9MK86J6F23GQDL770XQ	1
189	N7ZLC5KXCJ	TQF0IP5KCWPGZ2U9HFNYF3XUJAHSGFEA7NUSGU0ROWCGOA1L08ZVJ2502VRHIND7ROJLHB2XO6KS0RFJJ61IPT0FS40VCTJATFYA	7
189	98DH79U5RR	PDZFCGNRM9LPH7LW4R8YE3NLHU4XK9U2FS42BDNMNXF5OF5W7OYYZLWVZO8SM0HNOSKYCTU1DWLQYS7BYI05L6D35IDXE4AXP1Q5	8
189	LMV5KHMJIQ	GTO36UCAG7HR63D9LCSPR34P7WJWYA6CBHSZLCOLB2ZL6GIB6XEZ8PNNZ86JLQMFBEPZLOYJYGOYEST0OHZB6GEV3FANFEAUQTK1	7
189	BKEZFGXSRI	SZS94B1BYIGPF5D0LJ4A35FNKETG3IUI195RGCBFMUF6389J64FKQ07XUEY0RUIQY8XF9VTJHYYJ0JUMEKK8DK2BCI7BNLX2LZH5	3
189	PIW2O1HZHS	3JKK6C1CY6KULVHJJNOGWD0XR56B57ABZBLB9YGHA8OMXRB0QSCM3ZY0TX2AG0G05I5KKGKVGGFXYOAA3FUN5YH9MURM5GBK1XQO	6
189	LRYG3OO7V2	1PKIRGXTBBEX2HAF35HB57ZY8Z9F55A8VOBZKEOSUPLTNZD9AE72JN040WJ1GSYGAGBOFK5ZQYRPVGKJWAE17IZIXH9Y5WLB1FSH	7
189	0I32H8MU6T	Z4ZIILU6LIULAFGN7I2Q207LH34MPYQXDV6GOSY6FMM9OM4RFY3600586OAORHQW17HPIA8OU5LPO8649MH14U6NZ8JARJO75ZHR	2
189	98YTCMB2VA	PIFZPL4OQT8RFPE9Z2GA40J086KQOTZ0O0UECBOJB8JOKSM3K7F6BRJY8O1SAOA64HDP5A7YN786Q5QPURGQN2Z6Q5FXK6IX8MUC	4
189	0IIQTWJMBK	68JARTDTNID8L8THTSCSG995JNRYK7ELN9YS6Q5JVNCXBZ87YQO3RUJ69O0ECPIQE2UMKBKDX3727M4UOT94SK32Z1TSZ1HGFVTI	2
189	5KUMKKEHEX	WXXFKGYXQ9WUGZSPO7381WSS1N5W0XL2VP25MYHDEFI268TBY00YZKN9FFN6LC63X3807WDZZ04VN0W3437A6XDLC20GLK2CJPFC	9
189	7FQKPIDC53	3EBXB89P1VPTUCRF6790XYE66OO82M8VT3BZ5M4ZE5LGLX0IL7NSFLLE9F1XTBXOX491B1JTCKW2N7VIXGW58QPIR600UHGCH6TR	7
189	I6JF0RW5IU	9GTX4Q5ZT1BUS9MO2QHO1JFBS84ETVQODUYADHEAUS8FYGCH3YOQMC6ZBSF5V0F8KXQ8LLLVLG3ILAMM6XK5GABBY89UCJP3NA4B	7
189	5CPJU9L2PT	E5RN3EFIYOAG287QK2KVPJNM0SC1A4KFLW213SM6629T8OJKRNDHUPK4SFWKBNI3D45FGFX2PNZWK3NLJ2KX1CV5L8IX5B4SUGPD	5
189	8P3KYCP9C1	DELZL2G0XUZ1KBJDUBAJ93H796OSGCDNJ2FX87QKOEYOT6U9VP9EP4TJ6O0ONYUVQLRS6VEXVZ45F3NDMO71D88OJ51THB60UD7H	4
189	B09BUMIAAB	CDAKLTZAYECBXB912RSNCJA4VQT3DKC6GYKK6Q1PIOU1ZSUA791VO3L3CGZ5A66NBF481Z4MZDEYYJFC6T5DTRRMNRH016PMRH0T	6
189	SMUHZ6ZLPE	VIHFP5LZXF3AX9QA34TXSVKRDU3Y1GQSVOKKX8DVGW0MNZE78MYNG5FA80C5CX7QYKPIYGM407R648DNP60PSDMZJJM76ITTZKXD	3
189	UIXWT83ZC0	5I2A3WIOIFAWYPF7S7U8Z9P4O8RO8GUKACTX7OYQDLADLKH3OWGMDEV638V5E4QBV0WV5S9DJD4N8LSD0YAL9IH5RX4932LJ58SV	7
189	G6YJUIUX8N	V85WDD9KH7RPREQ4EBNT0EHX9KQ1USA36OEZEZ6FHVKZNULY5P06FC8R0IX3WHZY7YTC910PFHLE3SKP826F2DY4QX95BDSA5W2Z	1
189	4T71U0G3GP	IYEYL0714YI8H44KT639YWM14NCZKIH0VO0E2QQM0CW9174IXZMZ8ZMVLM38YHQVQRN3E0RCPQIWANA7T4CU6R15CE2QWSYTWASJ	6
189	5ZJ4TJAB4I	AD7HJJSQZV8L6P4F5Y80R1A7BQ71Z9A41NS0FMXIJPMS4E0C4O0LUSCJC9G3M010VDUT6DASB0QCORC6Z47LJYKIKJYFG45TYW71	6
200	N7ZLC5KXCJ	HG1NHK3CA4V6KDR2PQ63LIXO4MG47O2TLLSYG7BOQGJODI61O0IFB8J8SMS5D9EWBBV8V3WSOSMF8ILWQPQHFXSNCTF3OGKQCXNB	6
200	98DH79U5RR	7FVDZ0SVD9JA6PXT6QOSI6BX3DII5DL5K8SJ4EP6A18T52R1X7FG8SPAE7KWSKZAYO076NY2ASSQ7R1AVRU87E61TRF643OZC75R	1
200	LMV5KHMJIQ	T5JINGQA8DXGJAAZ1DUS9OOI17GD2OAVK8BWLZT7P1UOR0U3NAK4K8DFQBRQ9NHUDB6L8OOBTWCI390BMNZ2DFKL46FJID8CTALQ	8
200	BKEZFGXSRI	J49WIKY65MRLPDVXPQ70UQCIE3QX9Y2XJHDS0F45WO9TY82AMPDTO0J321RO3A6GT3BIAC7JWBEFQSUGBQLUVJJT7J08YPBVS3A4	9
200	PIW2O1HZHS	TAJS37MWDNKHKNNZMUKUSK0M8VGASXXR0KSQBC1L6746Q1OCY6FI0JOIJ7TI1MDP02QA57YJ38YUQ46GGDMVRO1R5JGDSTUU3OGX	3
200	LRYG3OO7V2	NH0I6P2V31PBMBX9R8LB9EV0U1JOD0CXI636VNV985BR1CFR6ULP4VLJVAXEFORDY12QI1OEMMCDCD9RV2RTPW2WUTKVZQ3UO829	3
200	0I32H8MU6T	ZIFGHDSTHGRBGTN68XC9F5YQ3O5SSZEL9H6TMMHTKDNN3UT7QYQK0AE3UYN2H9BSCGB9X3TVQSZBSKWJ58C3I3U9CC9Y9OLKC5LX	5
200	98YTCMB2VA	UKWF44HLCLJBE7J7HJIVB6V45VBGO9W990LXPYN8MY90ZW5RCN5VCBQXZ2JJ3A6DZKCNWVRT5KJN64EI0UEBEA68JX8WOEFL16BP	6
200	0IIQTWJMBK	R4Q5L022D14XASJ659YOED9X4E0E7VA2ZYIZYF2KDFG5D8NV6P66NBPO52AG9Y4R0B8MKTHZHNL87DT51FISZDPXJ446FVLPLZFB	1
200	5KUMKKEHEX	BLMIGZ90RR1IEP4PM1XWKDPZLUVC5WH8S5035KTOQ71NCXAGQ998SPZ86X7VD644J30IYBTBHIGNLCXXUPW6XJQCG27IN8KTD7DI	9
200	7FQKPIDC53	1RPQ70JJMW39JBYK8HANXC6DLYJ7WJO8O127GQZSG34FDIE6WJFZD4IZULEJRLXCI5VRJ1DSRSG4H1ACUMLMEY5TSCM4LQA4G16I	6
200	I6JF0RW5IU	WX5FWIUYOS3LCYEAK8U9B9HOJHARMXQ52P8ZQGRPK5DTTTI26453MIWWPQ6PHDL0C7SX0OUEQEZF5X5Z8IVS1WTU3LJ9JBIHUNRV	1
200	5CPJU9L2PT	VBRJ1MHSQ02VHR8S38PO74OEU4O6SVSGJYNGDIAKLBMUROCUJZ0OBGD1XMZ77LA5IWMTE1OU8FD6R3WF14W34DECUVT0SCMABRM5	1
200	8P3KYCP9C1	TQRKFP6DHJ4ZTFDYHAERJ8SIXC62C4AQ1DINFSYYH8NMYA86IL4QHN2U8IWDTDAMIN8Q70SYLQKLUFTWD9U09UINKXO65VED7ADK	1
200	B09BUMIAAB	S9S3GE1DR93Z9ATTKNYEVGJLW20MGNUBIUVAB73PRK3YVH6VUUXXPGRLZGGNNP6DP1QPOTRMTJWLMV0P6F1WZ6WCDJL51QBCNZI4	7
200	SMUHZ6ZLPE	QGBCLEGTF8EP1RIXKNSENLFIWUDHU7XM6XP90TO2QT7KHP993PCLZZNFA3P0B88HL1TDBI6090X3N5AHUDOE5MWGJK87EX0SUZ9P	8
200	UIXWT83ZC0	67USMM8BU1F2IF7T4M9EM30K9WL9FJY5VLYG4VSAYEZT3F5S380M9LSCGKTZA96LDJG6R1ZI39QIEHQ303GHSL6K2V9TC39ZIOPT	9
200	G6YJUIUX8N	9BCISSA4K89309H2Z22N6D51GGA919Z17412D8A25PSXA0L426TVXFC5GKCLSBDLIH55HPZ029SQVH1P4GH5QEE125W26YK4MHO2	8
200	4T71U0G3GP	QWMH33XXVK8TWRL3H4EDEDL363DZYDO38UNU4YWKQEGVYJJG8AEMJZ0NKTK9Z89R6EVBD19TI4X970FXT61X9BUI4AJKNWVSFYZT	7
200	5ZJ4TJAB4I	HDHBUDPC0QUOXP2GLS4TMHCSYGVJF4IBV9M3UWO7FGEUY6ZH2L4F4ALAAYNOSG75HT3YD9WYE6OGDS31QOQ3ACGVXL35JAP9IINF	1
219	N7ZLC5KXCJ	BD3YFB8VF7S5V7EZD5ENIA1F1OERP74EXZOKXF4BH9ROL9YCLJEMI24ALX607RGICNI6S3B8BDFJTN420BGF2S554O99IDD02JL7	7
219	98DH79U5RR	2TRIGLFWVR73EA5LBPURMBE4CZ7AOQJC6B8RY7WG0IJ6BGDDHP040QO0PXFQNFIEI46DBOWE2N0E2I25W429ZPLQWHCA1G3VAEYG	3
219	LMV5KHMJIQ	9B32WBNZJ7G4K4TMJP2TQQ3LVNWUFEYTVVW38GDN80NK5GQMKI0Y5X3SHSHJP2UFJXIYHZNDMPUZDTPP6JK6N9Y82DVQ938FGHAI	9
219	BKEZFGXSRI	1EU4XMQDDPXC1MFSY1J8K5EE7DSROT6SGSEFZBZXI5ZY7NHR2XSQ1KW6AP7T48YTSE5JHA3WBW0PGPGT6AY1BP165IEJEF2JGFF2	5
219	PIW2O1HZHS	8J245OFTHZUJNX3J7SCN9N95TS63QIAKNC8167FBVMXTUA0S99IWCPSUK6KMSMD8YJ5LYCNANB1W0PKS2N3Q9OH8TOQ9W2TJJZ4K	2
219	LRYG3OO7V2	O37WIJBX644W1UESW8KC72KVNNVRRMAV9ONT641FGKWTWN4HO1W0UIHWSMI5YTFT3JWNHUW2HF5WF08ASND00KB1H0BUV5QWFD0N	7
219	0I32H8MU6T	RA3E3SONUR1NIMLQO2SH5GQTCHMYIQCAVJBMJV71WOWJJGMTFG0KHF5LTKCVG0EEO119L8H350VQTHK552SB012PN038SLV6JS4R	4
219	98YTCMB2VA	MIH97ORUP1LAH0NHCNX9MWUFIKUFZHBN2QSULC3NL589R8LUHYGEHSC0XC1X3L4HZ8I1H36AUJYQYVXJ898BA7GJN27IKFT9A0JS	7
219	0IIQTWJMBK	TNO1GU74WBBORY4N3H228OO5XZOZYP7MFTPWTJ3NIP00643RZWHTRZ1F8SDRFHGGEZI8JI3UNPUTXX9367ACIO5P1KXAFMHAJUWG	6
219	5KUMKKEHEX	4IR2XGBFIRLTKUIGD8Z33G9V2OAHTKDA2IBYTJVI3JT2MR5193FV7N1YJ69IF3W7NK0BTTX3MRATWGILSIIZFRDPQMPXKMC9WWOC	7
219	7FQKPIDC53	3IPGLJPMHBCXXZ6V726GLVGE9T9OA7A1GUZA2S3IXCILMAWXGOY3S5PIBLG2JBMKALQCA62P8XSIN5196MIWIHIKFR9QLB8W07KA	5
219	I6JF0RW5IU	TXJVJ54NH4FUH572ZC3CF7T6MD6Z5RPV0QMZ8B8MO78W36EGB3A5Q8NWEMJG8FSZPU31SH4YDRYI96DP80XBQTE2C0VV21NIPJGI	1
219	5CPJU9L2PT	NY39M19JEXHJ3IHRQI6QBY1WI6LDQ3Z05NUC4CE1FS7DNM8TF18AK2BY6G0PQ53K7QOQXFWODEKS1YI6728Z5ZQCL6GYLYLKZWF7	9
219	8P3KYCP9C1	S6AEU6FRT7H74RY6EPHALE198CO3A2ESL8O57UK2KV2880QHXNVH76WOFBFRRLQ03ZW5D29TEPZZM2AIVHGXH7UPLAZ6P3K8EBEJ	2
219	B09BUMIAAB	VD4OCCSG6BMA65JF3T6EGUCDCDLE0ULY1EADLJF5BIO9M6S7A2LRIE7AB1L80OPL0YI24G4TOBC8FC0FVND8J3PWHACU7GEX3CIX	6
219	SMUHZ6ZLPE	0D482DHC958AFNMKRC6JVU4DKVH6OEC4CS4KI9Q0HUIEDT231MLAMOBFI0YG5LX42E8XSCCSVGBBMZA03OEC3CRXQYCRKK467OM8	6
219	UIXWT83ZC0	ELZK3OFNA3S07MRGVB0WKH39UHLMEE8NBFZDP19XMKP5T1N7N0LMVMK7RZZWD3I65FY2XN03BCJ918Q34N8O2V2Z41VZBMUTCT9N	1
219	G6YJUIUX8N	UK99SLSCLFSJ62Z43DJN9852B2YS06H8C1JD8OKKJXSVDQFU4YIPZADWOH80WALO7TGFSW6P39ELPKYUXEXBX1ICYXZ1PUYJLEYT	3
219	4T71U0G3GP	9BI23W061HESODRMK0FLER56E9JL49KVFKXCPI4FSF6QVIBRG7BNSIGSGLX4NOB16SNDPO6B6A28UPL672F777D7DE6EVA2DEFUD	8
219	5ZJ4TJAB4I	7B1AARRPI80A16UJE38OP9LS2Q6HY3P5HA90N67QWR5GGE3DH39LVZP80JIUUJ1OS520736H6S28EEMYW3A44DKSVBAEYM5M0RXK	4
236	N7ZLC5KXCJ	CFN72OC7R3V7U81J6UPVJF521TUXPIWRBMTXW7BYHVEHPHEODC47IZC7JUFJ4ORJHE5HOEX8S0NXBYNUOGUNNZILJWNB1233E4AL	3
236	98DH79U5RR	699O5ORLP5VHV4Y4D5S5U810WHZ6USGYCJRGU8SK194013G7F8B9RP18II2YZU16Z7EMMSJENIDUDA82A21VRHGWRT8MG3VHI8B4	7
236	LMV5KHMJIQ	4UXZ6WJMH4HK9X62GOR1R43T77TX6MF9EDGHE5VV6KKY0BHFYOBTTCH91D29CWP4ZIG6RZYK365HTE350N8SKVPB6GPADWSJ5P9S	8
236	BKEZFGXSRI	KY8Z00XH9QWK6IYY7UD3E9KJXGHOVLEFK9PZA2T5236020HN4V755Z0LNYBTTJVYLR9629XFAIALDUR793TAOIJVIEML09LTHIOL	7
236	PIW2O1HZHS	KV5724WYPH3HEUZZVJDHOYXWMOB6RD5FFGZIYDVOX637TEVPW3W8LDMW7IVN3ZGMMXB84QARYZUS40DI3VKXQ64C3DLQSHU7ZQU5	1
236	LRYG3OO7V2	WVF3FJWS41HEMUIPT5P29F0FT9QEX2NFHFGAE4LWIT9MELFWMRGVEDDR5AJF2R5BNB6HNILYU2UPGNBI432GW2AEBZEEUF41Y79C	4
236	0I32H8MU6T	7JEGRAMSYKR8BL8ZYPUA2FXDGEO831IO836UX9E1YVNOXGT45C9ROCW1VB9NVNZ6CC9IOOBZK2LG2IPAUUD120A6GF9WA1FL6QMV	2
236	98YTCMB2VA	LPRAKHV0Q9MV92BJ8ELCDBJOOZTWAJL543JEW0STPF0FWAA8EB8MBTDJGCVVX80GXQ1FS6XHW1W7LD2OYUS8L84L0A8UE66QPTSG	3
236	0IIQTWJMBK	4PHN00K6F8CKH6CP14ZWPPS8DCZ5FR1VVF4EKVVIUPUC5J7A3AYZ3T3O7IKXAO0YGRYCC7EGJQCA5PD3FYCE3C2CLPHCK7HFY65N	6
236	5KUMKKEHEX	5855SPMR2TRFQSLMV5EZW0W0C5LJ6L9UZHK0GIKWPUT5Z64P52DA1Y9ELF3XEDUQU7PIHVGMUSJBH0AFA5NDI83BIFPBPXSM9CL2	5
236	7FQKPIDC53	VHKW0QJO77UEXWIZRHWENACGF6797CEPIYOYDRRSUXKH462AKWS4ZYEVFER4SJR53F58HTW90DT0Z4LID7ZLUJ0UU3S8AX9KGPOY	1
236	I6JF0RW5IU	3209SEVEN6K2I0VTGLUPLOOBX9CEIUKQXHJE9LBEEPG7HG17O1AD3JZPOYMTCR53V4FAQRU4KPK5IR3RHFZRTGWOS40K9RCXUMLN	1
236	5CPJU9L2PT	0Q7GF3O83H654M61NJOH1SW0J53MXL5FQQQY2KONIPZX3PEEG6GC6FKI4G7JABLRL1OO5H8C5B9L28741YG1E2IKGI4WNFMGEILC	1
236	8P3KYCP9C1	ZI87EH5G8P5ICSL4TMSSEIXMMY0Y2GUX43BPH3AVNEH28NKWAMU52U5RUVUPRGN25HOJQ6W0M7EAB5N9NDXQVY4K7T5WJVEH0O61	9
236	B09BUMIAAB	BFEZ4T5P5QYHVBOS6HGNDL7BAR037JW9WAM7T10F94CDGOXTZY3GZN50IDYN2CSV3ZUVZQ9FQANJJ35W3GDJQPJIEVYPCNN7MQJQ	8
236	SMUHZ6ZLPE	C4JZYZYAWROICUV8IFNPLQD2TCDXQ62UO31M4U2ZUISEJHA318DL5BRW1QFVWBUZZ44I2JEYNX4D79SLBK6R2QYMLFVNOGDTY2OP	4
236	UIXWT83ZC0	2AS4O8HGNY183ULED6IGR6XY0KGTLPEUD8JKNWNSQG8Q3PUW2OU5GI55M4EE1X58TG54KA0QTZ0K8H4LZT164IO4CO8TSJ02L97X	5
236	G6YJUIUX8N	ZM2XEMRSU6F92OH69DK2A25CH8J8799JH1AH8I066LSS2U04S5L5W4S7Q0QGDSVU752AOA71NO5ZKNJWIOPCYDXNIC1I1U2O07U7	8
236	4T71U0G3GP	ZQS7URH83XCR48YCS63IO1MIZ93VR8M2L4S86EDVPOPOZ16WEMHA1ZN7DKIUYVR5KJF9PZFO2I2AM7T7CHRF0MBWRV5W6S737UDP	6
236	5ZJ4TJAB4I	7GPG3HS6NUG1KRQELE8HTS44TSJL8C23DLFAB87ETZEAZ4WBQYVQFHCOMVWL7H8K2MY8LPCNG3Y3O3EY6I5JRMY5J1YQMWHL13IM	2
237	N7ZLC5KXCJ	XZAVIJMSJ9TQ8PYMY2PY2ZU1WATWNCUV2SIT4XICLM91FANHS9DA2YN8EI9H00FHO7YPGFRAUNMQZ2WVXLDN8U3DEJOWYBMVG2NH	4
237	98DH79U5RR	8ANRDQPL7JMWOUOW2I4EUL705MSA0J7OPJYKZ55DN1GACAJQ78OTSC1WDWW07OVYL7GE5D76M102E7Y5CBC24N6MRCHCJEF8GSYE	8
237	LMV5KHMJIQ	EV4BSH1L8RG81Y6M238B4X364XHV2WWITC7QI0MFEATUBESQJWNY0D8R28H4AGTM57OY1PDCQ274EJ4ZF1MFI7SQDPYKSRF7QGYD	7
237	BKEZFGXSRI	3Y3SKI7FDNTDSZI4ND8P7VL13T8W9O7U19LCSX7ZUK9CFHA26DCD0Y2INCY1JLGZP8LSOGL0FI4WVJWWTGZ6L43CGDZQ8GQJEKWG	8
237	PIW2O1HZHS	RN01M7S4GXDPCHCVJOVEJMKR5282URKXP0B29E96LIAQVA58NY55ABWFDI6T8ZJYMQ9LGJVFPZ3AL45469O6WPWOE6Z0IP7V9MDE	1
237	LRYG3OO7V2	U2ECZQLIV3IMCX8LNB74VGJT46A1HB9113MHK369KFSDRNG18KVKGKPNSUH2PTBU3RVIK1BUE7TQYGCR0I26PZUQO9YZVET0D7JA	7
237	0I32H8MU6T	7RHJBFI08YMS0CH1FFE6F4LDL8AO3N06CZ30VXNTLZPKMH4BL982FDWDGE7DF47V8PPBIQFR2UVPOA0EE8C3O719C0UR0JOR24L7	7
237	98YTCMB2VA	2344Q9VRHYFN28G1EGAYQ9S6X1SGEXTY3NLFH988FR5BOD7LHZYXLIK3K8GYRPNTFRUPXATEICS9DRRT4H8O95NUCR5J3JQ0EL67	5
237	0IIQTWJMBK	RXHFTPI0LZ3RW4JR8UJD9NFFKL9V142VTAMT0IQQE302C1GOHJG1W3UERB5HQX8R7H7WSZ0ZE29FWNDSFUOSYB8ZPHCZNI9R5J44	8
237	5KUMKKEHEX	U6RTQW34ORE7NC6IQ26JIGKXAM53SKNTJYUX79HOE5B071AGDIOQ7VWNW3SE1AMDEVYYRILRUSEMFT0IMYZJ66VYCGBEQDWDT7WM	1
237	7FQKPIDC53	LZ5776PQJICCJ2CLCHHA9WKHHAR5A3I7NFA93M8AFH288BGKU2QZPMDYOX06PTQPAFYE1CR0JG423MJF3GLINTSBBMVGVBVW1M82	4
237	I6JF0RW5IU	CTRKZPIRL5BOUDJHHCQXXDPRLEHVIAQOQ31W47XDKU0RT1B8MOTKRFZ8DA9UIWJKOX80LWNKONMCN87UDIJ3RG6KE2T47C4XLPC5	8
237	5CPJU9L2PT	KX0BI5D2WVECPRANP2H1YWSCSMMTZ175B12VT2IL3RRHO1SU4K5W4EDXEXS6TUD5YJBXZP3XU67HFLY131ZO6KA7XEQ6JM1JNWTF	7
237	8P3KYCP9C1	55PQHC8G6S391C15Y8NID9U87OIEY3T2TB85J8YIC00WW6SJANZXF6W6KQT333SD9BQ0D6V0KFFNI8LA68EKD5XWOCV3O4OJHWWV	5
237	B09BUMIAAB	1GE28N90IXMES75YHADN3LBK1LP06FVLZTE2ASFSX5GPJZ67TUAWTIXQE3BW7I4CBAO83CYZ5V08FWBBPSHMF82R6XXHRSUOBDNI	3
237	SMUHZ6ZLPE	7EQ5L18RYKS19HPBR7DI6CFORIMAM7CJ30RO0R4H4AHNFPRKFNTGKAO59CODO7F1IJ8IZBKAD5N641JB0C49N582MWPYC0265QE5	5
237	UIXWT83ZC0	JUECTDOXSAH2MMMDFNNKG6DVV7MDQAOXNURRZ642UF3VI6ZNQ3ZC1VLNRSQV0KGRWTP254NJTUZACRNZI8XXKL62JE9HQICK9L9Y	5
237	G6YJUIUX8N	6SVQQTG5KKAE1N2XSHKWWT15F2KSPB0RZILQCG42Z6838CY5JXQEYB4N0ZKXIYQITTPSCLULMS70U86DEPI2VW2XO7ZM5GUAP0JP	6
237	4T71U0G3GP	G37CE2GED223HT3PYW702EEVIPF86K4YRQ7WK0Q4WTKF7TYX0U1DMY4BYM3YWIH28DL1VHF8FDEJ49YZ1SHLT0L2V67862INLRG3	2
237	5ZJ4TJAB4I	6BTP38JTVHZXE7DB6JI2SGZJGBN508M24R4RX5Z2CIAYIK15FMOI8BY0MKJ1UO3X563XCVNAUQZJGAA5JS0OTE422EFNW7HYPM3M	5
258	N7ZLC5KXCJ	E2T9OYSMOULJNSBYOE1CB48QANWIA43GYPFZGPEPMPOT3DJPFAAICKOK4D8ABJLU1FU7MMR99LZWPOW6EGCA3VDOA44DQDOCD32Y	5
258	98DH79U5RR	LC3TBI1U24QQC64GL1FBG7SRNT56XSWV8N2EIR1MM3H9OXNHT52CWWMOUMFSM47JI4RZE08493ZMZSC0FYN10T8LANT5LJ9R681T	2
258	LMV5KHMJIQ	XC378D37AZCKPMYRGTY5FZ0GCSZ3IP10SURVU31QFOAYRV67LA0ODXA8MW5PNAYU7L144D6M2H00YCYQW2SHZNX5USJ78MDE0Q0G	8
258	BKEZFGXSRI	BCHDOW56JKJ8O3USQ4UX5KL39NPEWAILSVVZKEK028LI99UTSWJVGS800ODBG1KIB7P2H4HMT3579C3926V91WF9X495AJUBXCGB	5
258	PIW2O1HZHS	1LXO6BMXB1XUDIJFKQO2QFN5LLKI4J652QBV7V4V3MVCLL6AL5MV2JDV71CV0D21512XHXHZW39DTLUAOJ786KDSMPYGSJ4ZT4GT	5
258	LRYG3OO7V2	J3XYW98K9BWHCGRF44UYJL19BHM8JUZEBQFPKKKLEIMNC9QCNTZ9W4K8BYWPWAAPMRFVBB5TUJTA8O7C1KVZ5ZSGGHOWX4YEH7BU	8
258	0I32H8MU6T	4ALXFPMLJ9X0UXMOKUW88P4XJ6ZVO2BNMI7JKBZKG56H05DGL07NOV4OGXOIZ16R8JOL0DEJ4L2DTX6O3TJY5X80OSCWXRVO8PIQ	5
258	98YTCMB2VA	1PHVXSD205S19PGRHVKLY7HARVN0NFDOP7BDCCHF57XXT5XBP7037F23HGECFMPV1ELBOCPENFQ0KURW7MLQPKQKFH558F9SSC6P	5
258	0IIQTWJMBK	VXMSVQ2ZCTXZRE3B8GRXB6GHTGIG7IHYBDMY8733YUCYHFRAFQT6O2RYQF8PIW24M9YO2EDBMX8R3S9OYHAQYLJJVXH39NVC2ILI	5
258	5KUMKKEHEX	CIBNST13A58FT0AWLFA0P3F6JC8B6YUG07V88CG1RPU2IXPXUQQDLSCJDEEPUZ7MK2PWEBXI8II9JNXWXLQPHR4I5M5480H2SISQ	3
258	7FQKPIDC53	2ST3IECKCA0QR2JIRE27H02G2KIBQRB5HN437W9M272MFOQ77TADZSBB0MA76A4V95ID8QK5EQFJ7PAO3KE6R7FZM2CUWBQ2DHNK	2
258	I6JF0RW5IU	M9RIF9JN1EKMVDV67EBZS1GNZJC9MF0C0IRLWXM86MVY2IA756FDLUWV3ET56JAVNHWMWJJK2D2GFRURIEEPAX1FW5SSEQBWL9KV	6
258	5CPJU9L2PT	XLVX5KH2QPLTCW1EUV0PQ0011FMCG4GH94V3T2EMUNGQH8C3KS0NUFF6U45Z8FWVJETHB8V2RO4DUKU2DS1XE2X4ZYJZ7ONP1UGC	4
258	8P3KYCP9C1	41L686FKBMJKCVQN8RQRZSMZ65CBPM9EROJ1Q1F6RTXM9P427C3D0VYMPWAD3E5ZNF2YMZ7GLT9G5AZQAJEMT5N5Z7L30CCNX894	6
258	B09BUMIAAB	FQIFW2GVSQO7TCU9SFR179PNEQJQWS7B44536H7DHJHQ75G9SNF2RDYFA4AFSZ99TMCZG0DKIOUX29PIJJ8INET1FZ3BG1URKH6U	8
258	SMUHZ6ZLPE	R22K4UDSBNAP26J10VP2LTR7CDQ3CNUD4Q1RG8TUQIEL2VO4L0TWR2R7L4H0DJQX37UME1V2C4MCPFFQYVSM47VC84FL02RG2QS4	1
258	UIXWT83ZC0	C0TF0UWPORFZ1BR1D35LSNKVJBJNFJ9XLOW58HDN9WTMAW809PZXWSTZQ75YKIKFSSNMPV26ZSM537VXCTNZULB357PAMPD0MO4R	3
258	G6YJUIUX8N	WLNX28DFX5SMIV14VVGRUQSG1UKPVSPDDOQIAB1N7XHB6YE3M513XAYF3G5IYYUFQPI3FS4T32T7JQKDQRDZ1VPD0LP3GSZJDCVQ	4
258	4T71U0G3GP	KX3AH95Q16M522GV4N4AED3DBMLCK3G44XF3KYTWUX9PC7NZSYJZ0PLH3Z94X2F70RBEXNKF3IQQEOBE9VUWUQEPM89UZZ81SCZU	8
258	5ZJ4TJAB4I	ICFND6R94CPX45CISMJNW2YO0PEKY8CZRI0TOJRUWQR5T6436T9ZPGJQO0WY2HK5AZGWFT3J5Z0GK243UKNE9MJK8KEYW21OFW44	7
276	N7ZLC5KXCJ	IXN0Z40QDFV63DR4G6YQ6X5OEXC7LAY7ADMXANJRT45FT13ZKU90GN4U29VC22ECQX6Z0432WH6C204N3MX1B81WJ14B1HY1Z2Y5	8
276	98DH79U5RR	D9P1GE8R22CEIIQENBR6KQ892BOTFMAB8S0MH9543EQ926T8HWL1G9UWAQ8FZPLP2AF0SD7NFXCF98H5SQLTAI497DM1BZFN2BH2	7
276	LMV5KHMJIQ	2QEZ8VT6PWBJDXJD2OTFG2O1FMPSZM81OEZ9H4CXKCRQKS7C5KAWXWU9BMTVFBHDYK488J68L64EL8RWPNWOMLD2UZ84KRRJ4O29	7
276	BKEZFGXSRI	8EWNBK11QYC56G1P20MGBOIKBX4OVJ6GR8QJABKALBEA59OKZ4BXP2XT5LLNQNFG26N80SO1QL5AKIOCJTY1HI0ZL6NZZ6U857I9	6
276	PIW2O1HZHS	PUGPJHD7WJX6JE6YO8TGXW3FZCT16EMAPQ38RL7BW1YW02P2XJQ8Y2831B0HXMBR6XQ3K8HDBRT68GP6W1DXYOLWRAHQV0NJ0G0C	3
276	LRYG3OO7V2	WSZBN7GJB5UV3U6JN3SM3LJ11SKEJG1QMV9IOVLQENQFW41GRAMNI0RLI8K4XC95EEJIUX52SBHQ5EE70EWI3NIVDXAPKQ3BOUBS	6
276	0I32H8MU6T	TV3FT5GTBQE4NESP0B06XE6XPSBIGCKCVMGT3DKSBCCH6V6MKVXSLW6PYG0B47N8GBIB79WX1H4VCZ03VY8UP219P14WMIYDZDB5	4
276	98YTCMB2VA	5PK990D1LM8P6QF92TNJIVGF9KTT069Y5QZJYUPBYIDO5GQ2TE6TXVEJIF9YHUAPMKUQ05KHELVAS1J240AW9QBJLPATV04EHYBV	6
276	0IIQTWJMBK	9BX3YOLAE1R5G3QTOQ6JKFK41WNRQ34ZXG5YM2KBZJGYSXO6NU2IFML402CCA3TL72I981HWF5TB8WLEHRE6AVTL4A7TZIA5Z500	4
276	5KUMKKEHEX	O7VNGCK2K6ER74TZXKLI6F73X664YLC5VZ2TST4TJTUE3C1NQFCUPRSJA1ZJGPE83I5ICAHEQ28NU3AUFTNSJRQDGST03UM3PVLV	2
276	7FQKPIDC53	TLQ87EWTFYH1EEXCWYL12BTRQK5PE89RPNWH7TLN4UB4M9YQZ12693OR29RWIGOHZZL0SPECM77IAYFRWPZNFCSW9EP8BZFXF4EW	6
276	I6JF0RW5IU	78KWZTB5GQD3AA2RBBXHZ1NAGBX2KCGUS3YRP0PSQ03YLEAYMGE2RP7GUKPY5JVDJTLHLLBKWE097YYCA9PE8OCD5S6EK0WHF0O2	8
276	5CPJU9L2PT	3MAE3FMY8I6WNX63QE5QIL3P6A5ST3HK5JHXO9EJ0O6JAS6C0OYVTMVRSVH3J4FFAW0EQJORAW03OTPOD31FFW0SXZE32L95J1IN	8
276	8P3KYCP9C1	2WQ9HV7W1D9G3ZQC9AO5HQ1EUZYW4TXKBVLGKF7B266WFX8WT2J14SUL4LOR6L1HQYEHOJ14CNCLUF970BDCK5QTB9M80PEREYGR	5
276	B09BUMIAAB	0IJAOZQPI1ZMR14HZ7UHVFO72EWJUH59SO933B5GAD3HWWJYJJO1VJ7V3MHKDH4A503C1BOYBOHRMGLG479L2ENIRO9R4UD2I2M6	8
276	SMUHZ6ZLPE	G7H50ZHCPIWBBPFHTH0MVVMB74QKOJT4PNY92PCPGGBFMQ2F7VYUVTHUVG86I6XGZ1WX1FPEFLGOUGYQBLM2U8J5FDOVRGGJS4QU	8
276	UIXWT83ZC0	FO1GUPJM3AORR57U5W0S0RX13W9F76ZZDW67UW9TATMD9E9KIZXI0CDX0AN7PEO6LZN59A9IWHRGEU1YXY6IIQ9BSIGUJCD6EP1K	7
276	G6YJUIUX8N	ELIZOWTV7SGJYK1HGY4ZMM03O8TDVCZ2R7TMYS34QPVZALV2MY817UO1VOLQCP943N201OTX4AJ61A2DN116E756S11JHN1AP06X	5
276	4T71U0G3GP	4B7FK77LSAUWHCLYD06S5I9WJPQIJQAEFUTZ303A7V91HXALPLMA9EXVBL64QYCB9PQXSV4M75UKIHOWPF27DAEA67XS48UIT722	2
276	5ZJ4TJAB4I	N23R9CEUNM36KPK5E88KP0U7MS9LL1KPWOCM8QE8AQTV3WTTJNO93R1WH6ERD2IVCOJ5M76Y3AJ8G9DZ8QC8NKVEXPECLW5II8TP	4
277	N7ZLC5KXCJ	YGLQZG3I2QI2OSW0JI12EI623NHFB0IQYMKJ0SXE26496K6EIR8Z1XIQKSWL8YGCH1ECIN91UW9HN76TQD7T1TYAE39H5LFE011F	2
277	98DH79U5RR	454RHEFXACMWD550XLYCD7ON25JQ5RWF0MWHCBUOTMD1WU2QKNDQCCD6QRZL5Y2TQH50IYYV1KS04X0HC2GROFCYJZ0VLIT5UUKP	7
277	LMV5KHMJIQ	CHWZRY2TMC30SICSLEKEHQS7DJS0XGJMLSAUU17QKE7X7539RMIQAKQVZYWHFC6G2RO9IR7TH34DT59IPTJL73LBBO55FZKII05Q	5
277	BKEZFGXSRI	419OZIGQNC3ZO2W2UI8FN73WCOSSW529T1V2J6IVFUYLBG16YPXS6LD67NMK0Y4RK4FWG4TYANA2JSU6XV4GIKDIYZ46U74Q0GBH	1
277	PIW2O1HZHS	E0358STLKWP2QXE3XJA078R9WECSTCDQN5S5AKJ2T6NCPEDK0WC7BQDFJ3J3PB1HT8OUEJ3M9IHAUOUSA2269FP62MVGBQMSFFTR	7
277	LRYG3OO7V2	TFQ3073JCV4J12XI5INTS21XWKT5Y5O4C2RWLDJHVXZ117KXZJK7F7H0N2GPO8UHG9G8LA718F74CA6ZA6GPVRZFV1JS643XDSU1	7
277	0I32H8MU6T	MMZMS9AAMXN6RPS1FVZKBMT0O5EMK1UPF9YUQCDSZEID6WPOK5765QY9287W4X0VD70S18KCSHV6EQ41QZBO3YUZKY2SEQXBOWA8	9
277	98YTCMB2VA	6XMU4NX514LEGGEVL1ONBHCG27CUTSRP55TBZ39K63S3QO8KSPC4VV4ZVF26LDLJN5IKWC6S2EQHYI0O91BEPW4JA3QTBC93SIQU	2
277	0IIQTWJMBK	YXPTUCRFXAMPO7TCH40B9J2WNR0EXYP2FIKEVU4UNDN3EDXEQ0LO0SFO43FDLMS8UUKFXOQWAGY569SJ4WY6NBBWD6J1O0IAVPIT	8
277	5KUMKKEHEX	SRBJZNU4JS5L6JZXVUTSXB0FZHJ7XKR18PMEXWYXR23OOQSRSN94YBGQ06UREWG9AEMQ7VA865A5IM1IY1OKKWC7J5O1CGT5V3NJ	1
277	7FQKPIDC53	BU7MB73AKHNEL2MH6ZOBPHBGJ6ZMFKO9RFXHR8JYJ78XAW0NGXYD9IX3S0CEIQ4A3OXGFE08QZ2SINGXGMFSVK9JR3Z05EQ2D74V	9
277	I6JF0RW5IU	UIB70XJPFVEUP85KLPSONYLP9CLI9PLTUYVEEV4XZ3MIUGQGVR1SMGV56V7YLBPZJV91M1G0U5YUMD52WFXSX2HOC0ISXGLYNW88	2
277	5CPJU9L2PT	Y33LB7QRAT20EBGO7CQOVYWSXCOTAG0E6V7L3GW506CHP2SFFKPURUVAHKX8T7R33X3TD4U1PVYZWOD5UIO01FXMA7DSSYL3OIO1	9
277	8P3KYCP9C1	9BKZYE666N2H2OKS0CXARTF0CI1J4KOAL7UHEBCA0PDULK0JBKYF01QQ5TWPNWBW91643DOZ9WJCPVP1RRITWIKUQELUOXWEORVT	4
277	B09BUMIAAB	6P768FEROAKE486NRA0RLNZ14KM9FY8A5NVCKXXDFDCDBPTY006Q5BCS0GCX3EL0CKIRM3C4MWLILVZO0XIO1RE4KCLEV9JB1MB1	2
277	SMUHZ6ZLPE	CM7XBEI04HERY6F578UFOHKS8INMKR8T7GYLL0ZN6DQ5GW7CEF4NQW34COZ305PMIVTRI3UGIHIK1OLLLKIEWUCLN3J6B6WAYDWV	1
277	UIXWT83ZC0	P4KVYFJNSDXDNRQWLZXSHEOUXELUHWX10I5Q7S8P384ZW3YPGOMN9C6LP08T3YF6Q5NEVAZ21HZJJY83P6O3JK2XMUAHUOWE28J0	4
277	G6YJUIUX8N	T4GYTW1MWC01EE7JLWFD02BARIMVVQLPIO5CIEZXBKZSJQQKY4RLDWZ13FHLKF1G0LT0I5BG6RCPDT0B2B708ALVYEIC7ON5SS17	9
277	4T71U0G3GP	ZC33KOVUKXJPGTIIBH0A8CEW8JSEG6U13EC9D6YVZANQ8X04FXRLA78X7G5B5ROODSVCRJEETEK8YXXKSY8TOJ05GOB7BWZIW9NQ	1
277	5ZJ4TJAB4I	YN6SN15XA9KTUSHS4931Z5CHHC6OCLYJGJ4LCABR4IGP1NRESZ1AUZL2KYLK5RVYKAMLX6Q37L6RZWQ3V26MTYZR7BAOZ1WNXRF0	1
296	N7ZLC5KXCJ	GQVI8CI34DXHSYCUIEVL5NW6CEGZS3HR01PMKEVVRYD7MGGCT3PNUPG23ZG36TKA6GR0J0KETA4GKYT67EFZO47LUWSU71Z8NCBF	7
296	98DH79U5RR	P23SL3UV9SFGK62NVWCJGFXIZG2K63HXNHRLMGDAN0VEMNX56U1Q86SKFU3EBJZGKS2COQBPSB6QUT5LT6OLB1YRZHG2N88DBP44	6
296	LMV5KHMJIQ	UQQTM779BZVYRUE4NES3LNGJJBUC2PFZB09P82Z41SXSUD6O4JXLLAJGKGKKN4GWU6W0VY6UPYC3ZYZFFFIT14NAR2F2SOR6LB7X	5
296	BKEZFGXSRI	F2FMD6X8PRVQEFHVW50TWI2TECAGFSY0BY9NDHY80CBLULNIKLYGHE47AWHA5Q2724PQF4RPG13UHQ83Y1643ST63CMR9XCJJDTZ	8
296	PIW2O1HZHS	7CQ3J9PLJ0TXOMDT8EJLSWDRAQSYTLD7I70YQAUTDVTM23UK9ZK9JONK9833Q128WWORVOD8T0I7C1YG5IZ3ADX4TQZSH1CM2VZG	4
296	LRYG3OO7V2	CZVWLPTGPIIJW7IB87S8U7FYV02Y6ERBS12SDHZYEYEIRIV34K4XGH4FT6AUX5JK0H14FZ71I44637HMF83VK34K6X9HGEBJO3RK	5
296	0I32H8MU6T	0YEMDOMN8LWYXPYBYA6MQ7R00UE3URAP75PKZJHOR78MMSSZMI03U7A2GOVSKT2QLG129OLO2R4S9FNIBPQM1H5A5WDKXYE8FSBG	7
296	98YTCMB2VA	0Z86LACCS3BBNQ5CPZDL06MLB0EN5NREGQLZSQPG27N3BJKHI6Z274A3NW5U6ZHEM646FGT9J6T3TSJ1Q6F9XYHLQRM5V4KD0IRE	4
296	0IIQTWJMBK	NCCM0TALGJ4NDE9UHRYZSQX4YNOWQDLBEMC3CX7EGAJHRRR0LTS13P66OIXMFO5D82J1BFRUUTSSHQMG5YK7UUIZPFP49U92EFJZ	3
296	5KUMKKEHEX	0YFB8HJ6OZ85RRQD8SNUTL50XV9U0NBGX7E9F5WN82BQR8RDSZGX5EZP2OONHZGAX1ITMR7C6AV0JPJYD6BAGOLSIZH1RJGJWA2Z	7
296	7FQKPIDC53	80B1E05T8FNFZKKXF4JQZLWJGVW4LEJWT8EFAICXP9KT4W195WRGTJAXE1VSDBH450V1FEX61VA0ACPU4X8ZWDDK8RBIXTUO1QXD	1
296	I6JF0RW5IU	9309UO8IJWBLBYPDRH2WK3XDOJIBW9UOLT43H0CZFCY5A7V4EKJI5R0GGXUKG6VKBW9R4W51EDQIE2DQXN7LZLT43YXTF2TIQO3N	9
296	5CPJU9L2PT	DASPSE2ARBNUEW29JUZCFYG8MVMUI2Z8ZTUMP6HH14LWJ9BF0JG4DK2P4TD61H2ZMP4UCPUNMSLKMTYMUG38V54P1FS53LPTBWK4	2
296	8P3KYCP9C1	RDKY3SV9RCK50MUN3DRUP377ZTAC1I0J4IDDTK1MJPJDIAD95GIS3KYXFN9JRTHILAARJR4TLEL9T4YZQBHVAHQUUP7GLR40IB1H	9
296	B09BUMIAAB	V0OLZGY8YELYK3QMVIDUQ74TXH3KV1SCR04K2JKA1V5KVSBYNNW2XXSY64YRNON7WIGU9GTM7C25CT7FGF6HEZO4HGO8V3XNH8YM	3
296	SMUHZ6ZLPE	RYH4K5V4WVM7SKHSG274MM21V1EOPYE5U4ZQYN4339VUBBDSQ5AF1S8E5PJS0GP8RRMXU0337DAN1IZTYW8UX8EB5VUJDLDXUWCU	7
296	UIXWT83ZC0	P7ZCGIXSVNXZZ4EH5KTNK29GTZVAM2EFF4IYJSQ0QTKH7TOQ8PZMTHOW7TSRWXF2JSU5VQ8M3261S2JALEB7D1V8QW1ZA9E2NR8O	9
296	G6YJUIUX8N	T5SQMT1KXEFKRFRVIYR6VO9YIM3YDNA34C2JTQ1I3Y2RVPT4WHF2RRNE53I90DGJEMQPMHB17JC7WSD338B6HIMMYYO0I1S0RSNJ	9
296	4T71U0G3GP	DROFN4IPPSMZOG1BJC69D0Y3KTG1MQDF34ZQW14NE7JGBB3V0YHQQJ5N3V43YQC9OH6UQKPSHS5GRR1J0VAXIWYT8MXB7AYX4J14	2
296	5ZJ4TJAB4I	IEQJYJ8NY6L3UDDQO02SMWEWOVG4IMH07FRQTOTN0GKPLHM7UGPS9L2W934DCDFLYV5PVX6AHP2GLYLGIJJB7Z1WM5Q0TPKWA810	4
311	N7ZLC5KXCJ	7M7KOLTTWKLSY524DO94JC0GFQ1EFFN7V4K7L1SNHC0UFI5US27T15C5V1E8UPNR7N73U5TM6VXGLFA7VGWNH4GZ1PLTWT31ZJX2	3
311	98DH79U5RR	B9WIVWFI6TQ0GNN3AJDHHCFU9ZM25RCSIWTH9EWHAQ5553PGP7Y9UVD93CJ5KNNOQ7SU3G45W5G1GJZFKFN72D8XTUN6517XDRP7	3
311	LMV5KHMJIQ	5NJD3MYOL2UNDUEAPVN94BJ27A58TXZ424P2D390JIH13T1G3XX5C7Q3EQG3Q04XDZVIFL6VWW0V4R9NIZF6A324OVXXXGJTOTXD	9
311	BKEZFGXSRI	SAR0CJPG49WR3U1U7XK704TYJ8PNGHK46PZYYG7TMXUWBG4VR8Q5NFHYQ2RE3C9WY2UO4D6100UCK7XDD45I0PQ0HBH5Z30KY77I	6
311	PIW2O1HZHS	Q0OCZFWUFOTFNA9G16JL4G36AC7AKOMAOSXERFBK4FBXYZL20E6BX60J7RBXHVK0BS15M4ZW49RYFGIK0EJGSKNR1OG9DNCI5KVF	9
311	LRYG3OO7V2	PQ6OKGYPBE1J16DMEI0FJE8XZSR7J34UCLLYN1IEZCZKPZMR850C4AZLRIZ1Z0FIKGHPVP8NAWQGPYI9F98ND20BW9GFCQP86R9J	5
311	0I32H8MU6T	76T7NBIUS63AZVZ22ERQG2VI3KTHSK7Y8RIDPQZ0RQDDMFM4ZFDMR3MELKECRACI8FBINWMMP18ZYR5X7ZSMGVGFED2ELXIRN5FH	2
311	98YTCMB2VA	ERC21704WQ3OQE2S0BM86DJ4HA1SRM3LYT2HQTPYPKSX804SQ8X33IIBIHU0FINKWR07LVCHWXTVUV6RFJCSY9SPL19I8YTH7IAQ	1
311	0IIQTWJMBK	7G56QGFZWQWKDU5F4VX9KWUW3I8ELXMUPRIDHWI2NZYKM75EXBDWNRZLVICHIAO8DB5VL28HM4VV7JJ5M4RJU0H827R8TBUMKZHL	1
311	5KUMKKEHEX	J24C5KT5DNM9G4OTEON473OLAXLKIKHC83DBWGZQYCYTE9NGF3GL3QFPNTCH8IX3FJAN1M68Z7F4F4GBKEEPE6IRXYYDERRPP5O5	9
311	7FQKPIDC53	9P27HW6LKJTMA73EHYJBS0DY23HQ0PKQLCLZLR6JMGNOF0EUXKHGE3QJMEEOOQU49CB7VE2Z29YLNYTBZX2PIEMRWBNHNS46WSOC	7
311	I6JF0RW5IU	G8TSROEFE6XUCZ1XEW40ULT0VMJF2Z4JQMSZJ710HMSF0XK2DIR5UMF5O37EE9MOBND0GBOG4ESH2O98CRBUH8ZEHXLQAWWI9DEN	5
311	5CPJU9L2PT	UWC4KAP47C939CX72GCX9TT07GISJHZJWOR59Z68KKJULWBU8KH6BZUBCL6E26UZN0HUU18CKENYJ9OLEXT9A2I63Q2X32FN0THV	4
311	8P3KYCP9C1	RAHMEW7M51D6V9FNVZURK0D9KJR9980135XXMW5FKT8ZZ0I2AAE3WDF06HB5E8N7BLD0MRA84PH12OJTBZ9836F0071EVABMFAXO	6
311	B09BUMIAAB	SQSAG9H6N7R8R4P9ODFFNAO05N4N4V1156TJQ8W683M9JGDFVN16RIKRB2E3F3C2F0CVKFSQQIHTXPQYKY2Q45JXWBIX331E1T3T	2
311	SMUHZ6ZLPE	S4Q4LQIA04VMQSQBV8KQO9J75WWRC1EV6U23LVTOAW5HWLNLKDGVTDZTVS9Y3189ZAQ60XZ9P5Q2DCKUILH8VSC34JI3W4VJY6RW	8
311	UIXWT83ZC0	RUWOHGXW7PSIPPRT9OH7WBRP6MUKGEHVYY11VUOMPG73ZVGOE0YSKYIQCHR4VNQ2H7T0YZ8O94SQDX0LGFFQPZKAQLYOCT1B0EW1	1
311	G6YJUIUX8N	Q0O1KSPF2MOQGXPH9NRWTKMAULQDQZ9B8J0P0YFH54Y9K766L411EESFOOH8BMYCNNS67AQKIK1YWN0XPU2W8I741UBMQHFSGVW6	4
311	4T71U0G3GP	98LNQS3M3TAXUSRUBDFQXFN9E3BEISA13IQVQJRZDR8AAZ6YX8ERQQ04UMJXRZDLTJ3MB5D2WPMGGN8P7MQKNTKNRVBE94HNNXR1	8
311	5ZJ4TJAB4I	TX15L5BDUXGN4ZFI3799Q5P4821H82T6HTNZZPCXJJ6841FECFU0R1OYH76SE3F2EKGKMQTO4M0H8R9HXWF3H3OPFZS1STTPDE3T	6
333	N7ZLC5KXCJ	52WVG5FBGZZ8Z5RYLUL60FW715L2KD4XPW13SHB7JN8A232XB12USX40GY3KUM1D4BSDEYFESNXNGWF8CX1SLKF12BX3N0N6W5F1	3
333	98DH79U5RR	ZTNVYBFARTTT5I7VI1U60LDBL02A00LROXNDN7XJ91KRDKSSQKODV4UOQLK7JFJ0ICFH43HLDK69AV7BIJTQMH5TD9XBX0A4RUJB	2
333	LMV5KHMJIQ	KXXCDAK7UN4OIZ9V3OAGVE5FFYNKCRPM557W6NJHUVSV2XOAAJYGJ4UG1R7PWA5D7SSM1NYQE2V9VKNSJMK23JCBL14PP4VU0PXJ	2
333	BKEZFGXSRI	BJWUHBQIUVQDOFJZCJYPRAATJAKHAJFXDNIDXIVHW21GNLBYM5XF84XAJDKH0IHLP3AA7FC4YQ3YJ4F79W5FWAYJ0H4T7ORNVP0U	3
333	PIW2O1HZHS	A1G22RSA80O8MHENBYPE1JZLS6J9PD3DVX84ZN3SGI2QPVUGMAT0LPT0C5J6ITV57LNZIKYY568TRJ57LCWPUD1FDI13D7KXW7TD	2
333	LRYG3OO7V2	47CL45PQAI39MUF6GK3UHWAS4V7VL6UZ1ZQFUDZHLYD9840NF0QWZTAI7TRI73FEXDIWDAMCVWISSATA4UQUP89IZIHAWQKST8L5	6
333	0I32H8MU6T	DJFOOADLRZ6AROMMUZZDA752MQEL08TYYN0LLGA766HSL9EC7F9JW1WGONB761VSFHLDXBBNY1HD0NQMLBOU9KC71U67FDBELYMD	7
333	98YTCMB2VA	BP6DWV4TTQB6ZW4NAT5FOMCEDIV0C1BAMYKWRQNYHNIE5BPQG1LEQ8JZM29NADR1OATBLH5TGH7AD8IC2ETKP6TOOUKZR9YD6QZ5	5
333	0IIQTWJMBK	OE8528JBJVNT7U6UGMRQFW07GCGS3EXINVO9UOX8KME96FTO2TZEIOL1NBZZ10HF7EGLG691YTG3S1AAS20JOTA8JXVTZ7GTF9B1	9
333	5KUMKKEHEX	HI5U8PYISJWBZH9970OEHCTKPC1NWYSZIAKU5ZPEL01N9S90GUHIXX2FYUE5YLW4162Y7PEILK2QKFL7CBHCQJCVIE5KUTPAE7WC	7
333	7FQKPIDC53	L20P87N4L5SIH3XEUNR4HP2U3X142MMTJH1IQWSLZ07JMBN025UUFIS59GWKGSC9S999CPX74FEQSTH1KAB612OAZ5IJ9HFGX70N	1
333	I6JF0RW5IU	OYNHWZ9DBMQ94AFRGHZV9KGGO8XA82U23Z5MYYFDO7XS1KFG9ZR0B2CERG3YB9FJ2XFEE32RBWGBWYOD2QAJK41BW15R4RBP2O0D	2
333	5CPJU9L2PT	ACG6AYOWBR2105V85876ESM8LXUU0JI8L81O4MKFMPVJCZEVQQ6Q2HBSZIVNE351J4Q2DHETX1TY6C5VT9EKN2FD6JYW17BTT4AI	3
333	8P3KYCP9C1	LRJLN2BYMWWM94FZVORYN54SS1ZZAFCCXMHR58A9EOUXBJ1D638QTT5QX03VCLYHTUZXWX4WNRU8LHQI9W3GGWTDR14EFO620NDR	6
333	B09BUMIAAB	EQI9LCB86EPJUVQSRA7BVG53ZR9V2I8D9Y4FUG4TRFUWO5V2PKIMFQ88VPK4DPGYGLK51L8KFNTQVJO46GFR9V8TZ5UE6AQC85QC	6
333	SMUHZ6ZLPE	ZBEM8H17SNMAQ86KYZUN0G503OF6RR02MJGEAFAOGWHSIDQBU2KF5Y3TGOSTC5PBWTYG12JSYGHE9MS08DMZGU7XPX7WXRMLGF6Y	4
333	UIXWT83ZC0	JK1S2QYRZU352V8S04BVB1D4W4H4683Q3LY3VGOEIG0DD055N2PL4DNSG667J4U00NCR7F6UP7M5B9159LQDTSW07FWYKR5OV9N0	7
333	G6YJUIUX8N	O8I54560SRGFA77NRHI0LU1SHK8C8JBWAHVNIHYWZAOYQTJT7BE2E9M4G0YU742IPTE3MTEJSWBLFCBYAOE6FISA40GRTEY4HFI6	4
333	4T71U0G3GP	QGN64JR8AYEY9TTZ5DHBE8WNX0O7GD94FJUH09L9AC3CC3TUFEMCB4KRUAJE5U16YJTZ9L951HABFTK3G42B172K9DXZZHEQL6N2	3
333	5ZJ4TJAB4I	4V3FQK34JMAZP8A2ZF1RI06YJFUDU0IGSUMI86KW9Q00W9KIDYV1WLBDZF6K00JSD4H5W1324ER2AFCJ5LA6EQUGTIT2AA6JHHW1	8
334	N7ZLC5KXCJ	OWL426R3ICTDWOOZMOWKAMNIB24HIV3SKRRYYCLUCNKFAZNVST439R1BJD3ACJUXJB2F7ZAKCCHXCHHLOIZZ0AS2ZPPVJLR22W69	9
334	98DH79U5RR	IY2SU07KD9C5RV4T57ISAPRKOA0VO5QKIPGU6GFJVSWQN020XI7YXQ62GSDU9L5IT1WCOJXY196R3B6YIA8F71W2SNOODVKKXN7V	1
334	LMV5KHMJIQ	ZLNVJ6YTO9EVPL9NZL1E4TA4JVGYW4QEKUSYUUY48IEOJ2YJL67CFRIGLSMX096USAK42K2FW6FWOVUR66NZ6O83LMNBHAE8LU5J	5
334	BKEZFGXSRI	4RAE2PILW1Z7503VGXEBRSQ718V2HL4ZL9CPNVE8ZSZUXDLJKNE61I9LADM43QEL69W5YOIVTFL925JXWMS3G88CA0OKIKFJNNYY	5
334	PIW2O1HZHS	QV5FTMV6ATF3ZHR7KE7BT57A7MJABVOGVGF0WYXWMGAHIQTCXMDJ0W7VY5HHDU5OE8ITB1LVRLYN5Z1R2HMZSFP8IUB0RQS1LVDK	3
334	LRYG3OO7V2	9A6AR1P8UZ8E0O6IF68SJKRZUEB26CJWRJ3GQZAOA9Y4CW1BWTFYE18ZTGPN0WCRQMXQVZ1Q6USKVWW8N9FM6VSZLDXJJXXN7GO0	9
334	0I32H8MU6T	KQ72Z2TJYD6UQ90RZV447FRBRGI6EMOH69CTITG28QWA0Z2X76HVT6BE96KSTWELYZXR7HJGOC5QSQL2OV9HE3X978TLJYIMMLMB	1
334	98YTCMB2VA	L0ZXBGRBVVSUSE8W6G4BXT8X7603SDHEJ0C4JUDWG8MMB00TKZPER9O21B0EQYSROOL2BEMMDH5YGWWGGGT3YDWKMKCI38GRQ48X	4
334	0IIQTWJMBK	8SFMDBJEZVEPU8JFY3K1AP0BESEBNILY90HYNQUBNGXZ82JA7M1BX5OS1EHV7I0QJQQ31V1HIJO42BDMIDEBQKBDLY6IJ9EEPGPR	4
334	5KUMKKEHEX	PJLUT2ORU00B5M3EZ99PMSCZT8IEJOVVV9242Q7RWV18FGNXLA0HQC97GWBUTJIFEFP5T8LICR211DTMUV2IYOFTA5XFPM7NNV3A	7
334	7FQKPIDC53	SDMYRF8JIFCCY98Q9Q0A65YKF3ZUPNFJTVCSQUGJGJ2ZUC0M96OED94WOBSYPO44A3TD7PAPKQ3XD90DDNUS9AGT0QDOBS32O7Z1	5
334	I6JF0RW5IU	XPT584XGHTPLPUC3L49W9MRLWN1XBIFK8TQ7BXAGSNT6YCV719CDZEUK8HJVC9F9OFN6EE2Y33DV3UXT136BFCU38F93NPDTIUSS	7
334	5CPJU9L2PT	Z3WHNJ6A9RNU03JDD3MUT78F8LNZUMICF3CAK422Y29YWIXW4PF1G7G14QIC5GPWILP70J3IBT608KTZY15FHR5HWLF3WZ6SNNPL	8
334	8P3KYCP9C1	Z5UV6ZWBP3U7SNEKKO0PHKPDAWLXONU4H686LTL1JFGSV5DL1IC8Z5WPQRVJO8XCI0ZWPH91D9FCD7SFS95GKWFMJSQ38BNKREJ5	2
334	B09BUMIAAB	R6TIL500TMS9Q1OCR1WUNM61F2CV4U8XXAADL790PV0G74SJ8IAMXK1F92DS2E59N4LP0L0U25F2W04LK2WWTVANI5DT4Q8K002D	5
334	SMUHZ6ZLPE	CTXRQU1E9TI81H9RJP238H5HH0L75B5802IJ9EDBJJJM5VCJ82RKAJU5YQKZJ4J7XKH990SEL0UZ7SMVXC8CUV8RHNVT3O1OAMZU	4
334	UIXWT83ZC0	CJIKM9JY57FDZBH6GMCLZ2WE9K79FZV31HV2Z1IVZ2MQPPEMTS39WJYKXDLBBJTGLMMRQPHPEQW6QGZTFVPW5WGSSLFVPGUPJFED	1
334	G6YJUIUX8N	X5ELN5GW23RO15P46KZF48EKV976GXKBWQSZKLR0950RXHYKEVN5P7IY04ZO7KPETP1LN0TU28F8IXWOLW1VKOWZH48QVD2ZPV8H	4
334	4T71U0G3GP	M7OC2DQ1KPDILDLS44E3CDT1C9ZFQTWZO88ZNTSLG77O5HJ9RGU13OMJOW92NKK03O3NEWFLM2XFFE55ZZYK855AVYL0TZ75WHUQ	4
334	5ZJ4TJAB4I	645AJOA1HEJ0EDYWA28S31QKO1X42S8UPR342JZQ4JOUB9PVJIWOW7UFOUVR1G9ZFZLXK441DSYUM5JPMBVT6T7R6YPHXHYYKZOM	6
363	N7ZLC5KXCJ	2LOO5LDJA2TLGFZUP2V140WPWD539KXQ71TZHFAI4H5566QC9E462U3BZ911PKK0ECNOVANK2N7X40TZW345P1XM8S9INJ2T7F13	5
363	98DH79U5RR	CQ80UEPXGG9PBEWQOKNOBQDAF7TUN0Z8ZHUM5E5WIZ2LA2LEGDS4NPRVN8VWV4JQRA04UJUKP0FLX2ANVOOKH5VKZ897TIBOPM39	1
363	LMV5KHMJIQ	QU7SHOXJF8U8HBGP9IWPQEVJX0GY15L8AMF4Q19Q8AUAO9LH58QEHUUL8Y5RH8RJWW755L9IIFRQUU4YO933PH0Q13525SI9SKO2	1
363	BKEZFGXSRI	QLU9H5CCE1O3GCIEY4P5QECPGMZ7R7JGBW8YJ4HLYOWCR8ZPA54Q86VLJE25GEVHRI1TEU54WEHCRA8HXK7WC3HFBXOFBMFT2PVI	2
363	PIW2O1HZHS	FLP9A44YS3JFUI6H9FXAWSRF02K8XJCOZBR8RWC9MQS3F9QDJM3K7HUX4KJHT5AJ14PT17ZNCYXG9X90LGZLP2RRQ3DHM4PRPJBL	5
363	LRYG3OO7V2	7MLWQHJTOYGKS5NGZ38M7C73SAIIG00WYHO3NY9VI8CF7638CK0PC8V4PREQ9ANX7UWLRT2A4NE9A26WGJG5AKTZWUO6UTVHUPHM	3
363	0I32H8MU6T	SRSSZUY3V3XUSJZ4RXXB7Z6F6QL17PVUUMY1YNKZ45A01LCJ6ND1ULL3VNWJJ76GICAFU8FDM7GBYFNUOB5TL3AJB4GK0BQ794RY	3
363	98YTCMB2VA	7Y7HAPWEJEP9B5HBM5PC1D015NKRJC4YYKQM7MLNNE101KYGI5W8CWT38FMXFF5HK1L1O5DAUBYWM9AUYDINQ5VC0XN29XIIJTQA	9
363	0IIQTWJMBK	62N2VOA76Q9F18B6R1OFIB0RLA63QN2TAU1L5V4RUE4HOXIZGL12B415B6QUSHRSXPEGH0A667VDGTCY2HWEVARG35J9EJ8NXLT9	5
363	5KUMKKEHEX	BRQL55EJXZR322LUM6X78NMQB2W8HQ4ACF1ZF30EN7GF1FLRX2LO5BUXFAKCJGBG4R0WAVOTGTUAHGY5QFKOFPEBVDUFTX5H59LK	4
363	7FQKPIDC53	YRBN1IMRTQ9MPWD5WBOMZB7BJ9SXNFH5NQ1YIBNH1TBWV2EB1LI767ZXUAD2ZYENJD894PXVYHUG9KQQ5R6B7J9Q0EEI7VRDPXNR	8
363	I6JF0RW5IU	FGLYWJYMTXJTX6I2CQ9ESI0LOYD0R0M69W0KUNKAKDHQ4YKYIKMGOMM6QAJ8G842LNUAG8IYG83OBJR0OORHOFSWJ33UDL4MIOER	1
363	5CPJU9L2PT	JRKCXAPS85GTTU1QXOG480MEYV5ERFXE9WE6HF0ECDL8WBU0C5VA8WFSEFNCEKB2IBT7Q4JSXB15PORXAECVUWGNQV2B1X92BS0U	5
363	8P3KYCP9C1	XKIWDM64KD0X0BAIQIV5FQ4CI09B936Y6FN349RKKSGSBNAW9TVKEZMGQFNMM45QGB1VYGOQ1KVXJMA4ZNCPHVUH3GNYVE7PX0LA	6
363	B09BUMIAAB	P72FET3EY7EFTW82PIVRU2R2Z4WNFATAAIKQJKCC0CEIJTCR8XHR0TCWP9PK6Q8YODFKLSSFFT1RXJTG2FOS2BKRGYAK42FJDQ4F	4
363	SMUHZ6ZLPE	1FPFCLG2U8GQJR1BQ5M3XEXSHKMNRNHON1A98M00DYVZ44VLNHWUSM0XR77183KG01CRQ2DDFVZ9T8YNYB9J0X6ABNRAP82KOO8C	7
363	UIXWT83ZC0	E4VETO6W1DTJTD63BQD5CPDKCYH3PUFAVWUHOEHJ9OKJ80555QM85GZY1KB4HCGG8SX7SZO7I46YF3ML2M88IGFP76PDCMB6HDKP	1
363	G6YJUIUX8N	8MFCOZAKBS780C5EH72NI9WJL4529QBT7I49263QEE6NSFMKG29FSB48050U4ILUQOARH5LKDLJDDI1FSUVHR6A5O5I7FJW53M6E	2
363	4T71U0G3GP	5DKQYBH204REVCJWDCUNFCLXOE4YNJ1MWAWRL1342DYA02UHMI0JL0A21XBTHSPQDFRVP2LMJ0VCOL6VUXLETSB6A30XZJWJXH7V	3
363	5ZJ4TJAB4I	91U7N9UF7OQ1P8UHK7VEUUVBYXAELOHNKKV51HGSQ1CPK6JKCCNJMR0OGSI09Q4THCQFNZPD1CY3SG11NZBIB7A3UGYI8PT96SIH	5
379	N7ZLC5KXCJ	E7NXJSK36591QMJPWSJBWVGAHELTY798TLJ2YV1P09XLYQRDJUK98G3T0NQFG1E96BIFDR0B14LW75L0WHJEW99MS0BLFVI95YOX	3
379	98DH79U5RR	MA13JIE5GV5BZS9RAM6C5XMPP5FWL1IQYRKHRKN15RLEGJPCJR4MSVNYXMONCSTOMONII1909EGNLIIFQCM3768CEVUF59ZN7622	8
379	LMV5KHMJIQ	G4RSEMOO9NPDI69F0RPQKDWH349P2PPQQJKI4L2TUYFIFCWC0IHOMMVCHKYKN8VT78X9W1KOZ56W8OC1H6ZUIADDYHAUWSGVCVKG	4
379	BKEZFGXSRI	XQ973ZQQ8D3I7CQJBL75TKP0Z2GZKUNE5MTQZWOKXXZDHLZP0LAKNL5MAIHAS0FO0ZMUS9TO6WH5ULTOC199TC1UQHPROO26RLMR	9
379	PIW2O1HZHS	F701WN0DA1YY3811G5X81DLUCAS3KNJ9BO74JH7ZAQQP02UPBFLPYTHBVGYV563WSZXPA7S8887KX63KPC2FC3KSH6IDTL3DX46B	2
379	LRYG3OO7V2	FPDXNRZV6OYMOG3DXUYOEIEYPPXF3W292EKWYSYMV6KST0EEAAAKIWA7KPH83U1JVZUK6GOF5L3I7WEYKSF3WS1FEMMJK0SBEA64	2
379	0I32H8MU6T	4I4V4O6329YKTXLP7XC8OFT4F4F21D6ZJRQKLI1E4MMMX80CHWGN462YY9QAIDBYD9BBGAEZ58DC3GHGDCVF6T4NZ2VL2150KXJX	9
379	98YTCMB2VA	Z6GRRS6204R2J6GS51UFXMNP27DCN1G7TJOGOXPA8U98DSS5ZIO5ZSJMS1ZUO3P8YUJAR9DHMTGCNPLKOINFMKHB9BXX84WFFAKT	3
379	0IIQTWJMBK	SNZEHTGLH9DPOFGPJWNMHBPMPIR6B7ME2B54YAF1BZ2CTHUYQZ5O6GBR8NY8BJKJW9XMKL1IQWLSIN2HY2QLB8IWAO6KMG02OSPU	6
379	5KUMKKEHEX	HOF8W7K5TIUUQKI29HY1BM5OQ6J6SD07IXQOLNOA70RFL056R9PK13T5S0R0XNMPSXM334QV3X3K50C0ANOSYPGODV5V6YNUNBXY	4
379	7FQKPIDC53	CDXT3REAJ92X0ZK941CR70I85ZEJI63DNM8J0948BO4VC7F9CUTKUHQM5ZXDN41MFZJO0AI46EPT5W58UEHXNTSG5WOBM1VHWRQN	6
379	I6JF0RW5IU	0JBMYOQ26QJ3ZTIWD9WHDTDWGSFTH7OFSK45FLYEBO8GFIWHMUSS3GUHFPFFI7U9BDKOZNR2KRFZU6R867GXO6LMZWZ0FS5E39EB	9
379	5CPJU9L2PT	HS8DZHMA5XJ7HJL07UF18ZCY0X1VB5U1PBYPITYY9L49Q28JUN6O9K8SPKMCP099CRSGV6SN5R1X4DI8ZSAX9F2FCF97HWIIL468	3
379	8P3KYCP9C1	1XY5SSSSKYMCNN7ZLA6ZMDQ6UFJITL9GJY75M2QXKX1QX53ILT94AJ7YH2KMJJ99YF2ZPCNTTJOZL9IYMA6ALFGA0JXURENAY22R	1
379	B09BUMIAAB	D2JFQK04HMHTWAIN8XS919GO3CP5OBTG0VIHX454PGS7QA5DEXZFJSLEW5MO54PG3B2B2BZE1YTVQJ82GL01MN7IJDV2RR8U0MDP	3
379	SMUHZ6ZLPE	4LD7UNV90XM6UHUDY4PDU1YP7WKZ85EFTTM9X31ALISPI57JOQBRYLYCXX98C6B4THNA4VQ5DO2LIIHCZBKR4XQI5KL9438OHX6B	5
379	UIXWT83ZC0	7O2AGOJSM3OQ7IAVTA50FEUJRAJQNEVLGV1WRRXIHZTQ6S6U73YXBKM23TSFE2EIIDKMRNDCNXTPVDM8DZTUP7K5J8388SDOVKI3	3
379	G6YJUIUX8N	UDTZVJN16HZGTBPJU2K2ODSUFD4TF4K5S0TWA53Y6EM1D1PQXEAS8A4RU8USO3WB74X3S3JZ8W6J00RNYO6A327S6BBBLLJDSL4I	1
379	4T71U0G3GP	V845LTLEU13QG4A7VHE6F7R2HOXM21P6IKCPBESIVNMJHVEQIF6DZL7YRBY768L2M7I52U5QZ5L2UHUVJGEX4MG6MN89QUMWBT7K	4
379	5ZJ4TJAB4I	IXXJQN3AFEJQCXZ4Y890LTPW5AETY0BJKIASQNO8M5GJYTN6W1NU7TBZIBOPIKMPC9G3XGOLUBNPNG7MXH66NQM1GLKO88ZCT0GY	4
390	N7ZLC5KXCJ	TJQNBA6GWMCDB2BOPCVXPXM69MVLL5W9I9D8QTLQPUU9IL7GYXEYVB767TNYPU41ZC5BZC850FH4CMYYPOXX07OHBGB6FXA5Z3JF	4
390	98DH79U5RR	5RVZI8Q3D3U4ZJA7HA2YX9SBBZDEMEJDSIU7B7S97O8MQCQO98S3RR259UYS4LQ9URMQYD5JR20IBFV9JZFOVPVBQY7RJ9EW8829	7
390	LMV5KHMJIQ	AZ5CILY0T348ZJFFBNE5KA9FOASYDKDNVJI9JLNE7K65DSUZ8Q6UXEP9Z0YI2AXI0QNPBG60AA89DEB5Q3ZXOSZR3JKTXEL6XYEX	2
390	BKEZFGXSRI	EY2UFUWGP5UY329LA3I16W25MD5YBLP9O0LF6CI7CKNNZ54MMUX465IR57HCY8EDQUJCQ3O7UKYVIOFRITMQYVDSR3J94FJEGJ6F	6
390	PIW2O1HZHS	15SG0JVHXJQ103EVXP4R0VWUPCPBTO8SA5RX3K8MRL3U2IEMETS3CX4FJ80X4UYIK804MR1MRS9P1C1G8D6A5EPMBLO5UKS7WUK3	5
390	LRYG3OO7V2	J9X1GMTYOOGGTZ1XYMFTN3AC52HAB3H28ZYDJIZ25YW7HZAV0J8HEKDQ9U5NFTWVGOI4AXOPXMXZHC5G2VJ259XXVHDZMLXMBA03	5
390	0I32H8MU6T	FUC5SU1WOJ7YZVTJ40H0UI3UZDLZLYGLCZWBG6MP5AH7GAX0DCGJTC661SGOJCLZDVWA8RD8N24UA5NYQUVJR6192ZKY07G3ZR4U	4
390	98YTCMB2VA	W1W9I61HM65ER8YQCIG3WHJHOHPWB4SA2L339KIAA2Q3OTJ9RMWJX10OSOUAQEGRN4MFE4R29G341P258QEYHJNBUOKUZHU5V8QU	2
390	0IIQTWJMBK	D4X54JR86XCVYC9ARJDRKV0T6C1V7I39IY4VR3NA5DX1H9BFU5EYMC6SED82R5AY4DNAHNTY6DWH78L7BWBCEEWG2MRO5VS9C97E	6
390	5KUMKKEHEX	A7GMP2JQYUG1B1448T0RHI56F3LVWE7BHLAZ4ZYLMZD2LW34XFEPGWP2CJHWRY3UWETZ0F9I5OERFCVS9R7QAR4U6HXUSB3Y5SFG	1
390	7FQKPIDC53	EDSG5U2S7X9XYXA0NUEK83TROZ3UPVW7PP5NPKE7CC8UY63O37S8A6EKUA1G0HCMACIJ2WLDQHH6483R5P1RCY6TLU3OS7G49WTV	7
390	I6JF0RW5IU	UWHWPS3YHPVHKKLQUJMFZ8H27USBM6IOH3L3T5XGD5DEIHIX5OPMHP9VOOY492LLHG9R9S6YVFC34DT0M5F8R6H23ZOEH3GLT27B	2
390	5CPJU9L2PT	1XMS01BNF0K48REWN3K9HXJD1R191KCGSSVH3P0FFPY8DKIMBYG8WCADOI0J9CV5YEMP5727DF329L9RJP7CDDTPRS2UZRFC32J9	9
390	8P3KYCP9C1	2QE6J4RIIECJJAUFS1UV77NEIIW918GBAUQ83G4JCGJN0LPRV7KAZN94C9YAIRRJ7BIZTVMM7LT0Y9O62FO3XFMWUV63S3AVY9QY	1
390	B09BUMIAAB	07AV8DN4IGCU1ICCXW1ZVE8YS4EK8CYTZ3CHNIZC82LP3I0U8SANY9QV9LCD9C6GRT57G4ZP6Z032T5JDTMPBL40MQICGVD55E7K	4
390	SMUHZ6ZLPE	3OD2VQ9IX2QQ2APZQFGYFUZWXJLW48YVV6KEJXP44RZX2VNVXFO91VIIYQFMFNOYE4560KQ30L3Y4C4B508YTY49XBQ3RCZRCAS7	7
390	UIXWT83ZC0	Q4MZUIP1UNVWDQPPZFP95IY4XMXVMV3U6LO5V98QPHDX4GNVKCN5C74IFRCIV3P9TBZ2CT3ZG9UXEAAQ8BLKH8R9QGZD604V2ED2	5
390	G6YJUIUX8N	VT0IXZCMGDFQWJTRF2VT0L54Z3QF94A7I9NSUBTIPWKCUXKQLDXMSI0JX6T4J7NLCHIX6B6DINEDB3JCS935HYOAIE4YRY9SI8AM	4
390	4T71U0G3GP	XUKGTDEDXI4WQMJDSEO3IO2GIVUOW5C37X4PTYXVK6V5ABBLZO04VTGI1D88S0R1FBZ2R3T3Q2TM36GGUJYHEIHORWXQ0ZDTO3Z8	4
390	5ZJ4TJAB4I	I3547N3A4O561NJBJX74LL5FDD1Z97AHH4MP2NH5NNXH2T8M4RFF1EB68003VEA6NXZ7A3I6PCQ7XYMUEP4R24PD3PRCWNJJN03E	8
391	N7ZLC5KXCJ	BLAJIZZXDJKNGZGJTETIVEVMFKC3HU64I0DE4ITF0PZGHZQXD93WK6I6ZYD8X5QTMPEPWBPKVOSGPOFQ3OZH0KULSGOGFUR48G41	6
391	98DH79U5RR	ABBUTA6NCRLSXEJFI2B537QXJEB6YHIUN53NYXGJX7QYDXSPIY0N261DUOKO99Z4I0E1L6RUV1H5Q2UWWVY9R52RD02KN2KXIVPN	5
391	LMV5KHMJIQ	0DLGF2BY6W24Y2NL0NN7XYVDHH3RUX5MGD5RM2LC13GD9QY96MRIBP4BSI978TEJ1QXU6687BLG4SRD0S3VHFXL1J39E2NEHY6MT	8
391	BKEZFGXSRI	EDAOTG0IATAEJPF86EEE5LC64FXG9FVFU7O0U3VQUTIK8AT88I12HO73ADUOSTJ584ULBPNDSXUMD283VZI0N38FAUZRIG8BJMLD	4
391	PIW2O1HZHS	I7T5YJU4VZHF033LTSF6PLQZ64MZTC0R4ON1Y4YUNKO5RMSNFZ03GHA6R39364LS90LLQBWY3VSE6UIUM9T3L6KXNQJ555XS9660	1
391	LRYG3OO7V2	G7DDCAVY5A6VPR7LRHCQY89112779FAYRTFCQ0I6Y9RPNJQOZHRY3KMI7LLKCXY0AHD5M5418F1ZQUORLTI1XL4HG6FEO84AK1OF	2
391	0I32H8MU6T	UC4N00YSX2M738SP6DZM6ZP0ZM9L0OZFIL0RNO7UGYSE2HV9LVOXZ2J5WDXO0M1JCHYSIBBRFEGHGL8S19AF9BPPC45K1S347JBU	5
391	98YTCMB2VA	D1KT6RUWBZLFFX1MWJB1IPNG10XKLK7KN8XH0VCT43AFUEV5CRL993LXOE2G4KL11A2H9TWAGS6POHWXE1H497KUXA3W36YUSJNT	4
391	0IIQTWJMBK	O5T5K2R66IHSFBCCQ240IT8ZAHK3L7F3CLZ5Y8YF2X01VEY4WSBQT2E4735DRYU8CNP4MGNSDZ8U2HD5SQH26YKKH584CUXEC2YI	7
391	5KUMKKEHEX	4SPESM44TBZZ9UBR1CODEXQHTPTB3RAS5HY81YNLPQX3IEDAWXLZKEUGBHVC32ACAH425CZDZCXY9X8OMTPGGLH0WR7UCKSXQU2B	3
391	7FQKPIDC53	KET7H9IR6HNIG0KN36ZADGNFEBPUAIO47EBO5I8M9J0KTL6THJWYDBHE0O3GUYQY2SLBY5RU7MA3PDV3F5M0V01677YQP21K3BSA	1
391	I6JF0RW5IU	45L1B10ANYX29AZL0CB1OE1GBEEV0ANUV2L9A8T9B6TIBXP2C9C9RJVZDE06WFKNKCHHZZK1SCZSVSFNYMT17ODLGV66IWM6VF79	5
391	5CPJU9L2PT	ICMYLQOTDDU9NIJWTQ696AD3OT5Z36PVG7QKGCV7Y1DRL64OCKCZA9TH8TJ2VYZGY93Q19PQ48KE7VSRYQWT30UGNILW23M9C63L	1
391	8P3KYCP9C1	OXC4W4BYPKNB2DECFM7PWCSY3XAWLCB2GOJ3UZH5SR888UA0I76T56QMEOA84PNMJV5O3KSQFC6FEU0IWKNNGR6K77ZFYIBCEVZM	7
391	B09BUMIAAB	W67PQN39LHTX2MTB9G1YVQ5VM17A4AS5NTAOQ8ZDDKWZFS66RBEP8YEFAMDYQ2FKZYJILFVBQXVK4FQ44AT36D7ZO5NE4AXKFLAQ	3
391	SMUHZ6ZLPE	XUMPD8KC3K45J4PJMOW1U4Q2RGPAKETFAWGPGN3FWWUUSIVGHB37OYX3EU76SJ1Y1Z5XXAC8URF7J5JJUJ3JLV1L8MLWP6WM4633	4
391	UIXWT83ZC0	8SH95M7TZUJKYMIQSNF7UYLZPSY42CNBQ6V1WKQI42I2BM1UO6MSX52KHRTMXC0XHH320R4I76D1QSXD1EP604OVELUE0DV1BVU4	5
391	G6YJUIUX8N	937CDV01A3Y4QVTX46M3IYO7ZR3LL0573U2KS3WIX3DS5JKSBEGYHBKLPAMW2PPK80B52IEAKEFOU6BPHKKHTGZ1JR5SRAQIN2TE	3
391	4T71U0G3GP	OZ39FOD550S86OREI01BJVLNWTJX7B2M7H2VRIO2V6O1MUVV9DFB1D82OPMWEQ737GAYV6X9M9PNHUAC8YX460V3JAGB51YE8U3G	5
391	5ZJ4TJAB4I	69DPFZ2YUV4OKYQ3D7HUHOVZWEULKOW04TBYTO1A3FYPMWVDHL4XVVMROO3BEQNG8DT1W1JZGG1B0FN9SRD8U9FJHTJFVZ6M2SRI	1
414	N7ZLC5KXCJ	3QQBEQO3K1IA3SXNOV88KUCRDEQKPJHYE7ZAX6PS0P62BE2HI8N7SK1JN87AAEOBUT663W0SGPH5XKQ9MJBQ5KF4FPWY8OSWB4HR	3
414	98DH79U5RR	6OWI50DC6VCR8Y0C7FJOC0NABT16V43D90P5PIATC1I4THAZ2TDY7DGFAWGM9GQC29SHI5XYF0LKSTQ3TBEC0EF6UK43BYU5LGBU	7
414	LMV5KHMJIQ	2Q66OTH16XRFM27BOLX4VX8B3XQFP8MR5E0VIGMU7EYXNXZ5X474OZDES5C1DBM7K9KIBM3I9C6R8KXG7USVBRDGAWCNDUR521MN	4
414	BKEZFGXSRI	Q3LAZ4L3WFHH63ST0525DHPJQEOVAYH7K3R0HUMX2MOQ4FH19MB5TSJJOBUUPZ277K7DM1MFTFD029PK6XWYWMN1THMFA1HCURSU	3
414	PIW2O1HZHS	EPHA6MOOSQOWJX2DEKV6FTEOGE18AGLQ4C2IOX099MA08T1EP8QG6YDUK341VQOMF71H5TZQUV62SNQWMWTBZEUG9H8V38OT8YVA	8
414	LRYG3OO7V2	UJ5J9WK1KC6MHO87MWANVHXVEXVHN342P42NX20SJOYFBIVTPWVCUWGMVJFMADORHE7NWUJU6SEGTRU5BB11H2H3XP1OWNRF9H87	3
414	0I32H8MU6T	I75MBFCRA2EZJK9LXJP6DZG257SB8GMTWU3D6OGWFLXWXYMDR4M7SAHS0CRDXBT3QUCZQ5PJC302CTFGVOTE4OAVMLN37D8E13GC	6
414	98YTCMB2VA	WWWPD5ZKPPH7KSIRO9BUQNFSVM94WAJNCU826Z0TLL75G6WUZWM3FSFJRE3154XOG440UQVZIRIEQJMZZOEAXPHUOZL259XRYTZL	1
414	0IIQTWJMBK	5AJBXVXKB3H1DBRZX00WKM4F23J41Q7TAY4N58A4TKN5DA28G1A29Z1TFEI3L3TU6Y1PHD3Y05C989B1BKX9PETK6KI10HS0129P	3
414	5KUMKKEHEX	M1D7LCDW1UGCQ1BFTF1EQS65C8TNLIG9WSZTUBECQXFZBYJPRVHXIL234H5NS0LSOHQ8CRUSBYY2NG3OYD50BT0LZ5YNG0TZMWL3	2
414	7FQKPIDC53	LMAAZWTWAQYOQYP4UR5QFIG2HLKF8P059GN05ZL6HYZPA8ZCE42FQNBCGH3NMOYU03OJLY94G8JRT11IWIBDXVOWEKUX68U39EYH	6
414	I6JF0RW5IU	P0Q579SDUSOPU1DNU7FO1FADL7INQRPDTYGRUIZV6SU1GIMGQPPHT32K0MTA1EXCDL56VW2LHTRJUJ6DVB6ACIT0551IZZ415RX5	4
414	5CPJU9L2PT	QU4XDAALT0QPPOZIWA51FB05TWRYZNDVB1FQCN8HSOLFK2JLFTIQ2DGO49DRSLVGW5OYJIFJCXJ0ZVU0MGTGEW27U0WDJQYG3FSO	4
414	8P3KYCP9C1	UB6N9OE4QZJONFM2PBACQETWCAV8C6TDFL1EX2FHYDDANY6LMONERM8QRJL93F2TFGIBNIEX62OMATJOEJWXTPV3NLWNQGNSLU4G	5
414	B09BUMIAAB	48EJZHZ7WQ8A74UTEA0VOYCV1G0P5BQYC7JKSN3H6515YNTL39GTEVBG6SSTRJBU9K79VJA1GSZT6G7NXOV656UQ6CO95KZW3G5N	4
414	SMUHZ6ZLPE	UZT9PMV6SJZVE5CYFYCZQCS5A563CZ0LT8CYC7QT9UO2YO0OW7YR2Y9RHX8TQ132TOCG3OVHIS06Y0HWESGFAIS58VRO96DH0VJK	3
414	UIXWT83ZC0	UVIMQJK7D2RQLO8VY1L6HHH6HILPSFDR6KU672U8H752A7XSFVC37OEMNMEH85O7Z9TA4BX5HMYJLO5KV3J6DJTSGHSVYMAMS8DA	4
414	G6YJUIUX8N	WXD8GVUZ4B9Q4WFVS4QQB4XSCH5ML1NL569FF87X83LGTF4051AEWUM1AV590HODXXV7W9PT62RHSQ86NERU0JYKUHFUC861OIS6	6
414	4T71U0G3GP	6D5LQH4DEJTW9VW03MO9KNP45Q8503K7CMQBVJJB4HP8V7DMKAU5E7JTXBP9I8ML8VTWFVEUCMED7RJ7NWVZIP3FD7NU3J354E99	4
414	5ZJ4TJAB4I	RHZ5A222GWG1RWVNXDT2NTHHT02SJI2SJT6P63HWAN6LG2MXISHBPHA79RLJ9JS73YS80FR3571AW6A1OFK1B1CCT8QOS8W148RS	3
438	N7ZLC5KXCJ	O6CBOGSPALCQU54916CVPO2ZCL6KAFXPSQAIIZXUTWSXN87D21DCP649EM8CKIO5XX8E4V0BISB26FLDO3RICVAVVBD51UKLIX90	1
438	98DH79U5RR	2IHBB364BD9B5YQ0G3CXMS3R5KYH0UIFVDVUKHA1D0U7E4553VB47CXKO0F0FZER44P1D6Q82KUV85NAP2OESOISPKFTBKWNVDDJ	4
438	LMV5KHMJIQ	D27EDCWSCLTMFLMLA8PV7M2066RYG952DVLAQ9PMV9N9WH69JCVEXYR19GIGU8MCQ0JTAL4ASDA893DZ9SODO0EPEUBJ1J1XXKT5	9
438	BKEZFGXSRI	N97IVWUYS1FDTGCTIYZW4OPKUJJLMKYKH1WSQ52EU1V25GICYDOW3JD9TXXMNILIC551UTDN5VCD2XPNAHWI5CQ8YX93HQ0LPN09	3
438	PIW2O1HZHS	QSFAB1HHAH6HJLGVDMAO6D7UJFO40XO7QCUYRH4KJ1XPDW7FU0MBZUONUU16NMQM281H1RD5SZFFPRQXHIKALNH5YGE6Q876KLXE	8
438	LRYG3OO7V2	0ODWQTAPI7DEDYECPAP16SUMGPU2J4E4M2R4GO54GPQJB2MK335KIM8I40PB8IGN2J2KGJ6BFVUQCLLOCK8P94V94JAQ8358JCQ1	1
438	0I32H8MU6T	BDT73EW1RFTOB8YJ0N8X2Q7JPCLZWH94UNAGOSGZ8HMDRB64GZTYREHVFKR037FKFY4X8S4HHIYVD32OFQT6XKMPGPAEAP6BBC82	2
438	98YTCMB2VA	J6Y4LRIQWRMRDUMNIW4LORSR0G1MWTB59G6T5CM3D9T8YW75TY2PDR21OHEF063CQRS6X2SGKBHP7U2DJ5281V1ROFFX8GCHFRRH	2
438	0IIQTWJMBK	AH1FWECKN34OB55D5K4ZASRX4ID99JQCV8IXB2FRZHBMLJ6LHDKGXRESZDLNADKDN12CXHCDFNA2RFMUL2159JPE4Z77R1QV679T	5
438	5KUMKKEHEX	4XABGAJQLBU10BILOEDMYH7JEWO7O5TF2ERF142IFXTYNG0ZHKS35H2W007UWMCPSO9WUDTUL5GBYI675ZZEN0KUL4OA6HW3UEG8	2
438	7FQKPIDC53	EEE07RAB08R49Z7W8B2EOKZYSYEIMQTC701UVNQIJSV67G6SYHWDO323PQHJN1YJOO7I7NBUUT55Y30M1VUF3QYD87EFFH5R4MRT	3
438	I6JF0RW5IU	XULGCS486EWZ5R1HTP803KAI6PNYNBMLHDDBI9183FC2SPKZDJK6T2PNUCKXEGU42LS1N08UXA6YHH0QEXVD1Q1OY0RFZE3XUHAH	9
438	5CPJU9L2PT	SMMK0IT61FMM3SQVQDLTEDXJ34TGJDAHSUVLI2AHIS6UF36VNCDDYX2PYDR5ZNWYFE3J6FMXDDLWGCE9873H96S41FWEKES45IPA	9
438	8P3KYCP9C1	XZIZQAUMGJV8S71UPYIV8R0SIM8VQ07XEALIVRT57SV6AF2G0KPTGOAF8ZRDB95PM84RVT97FMXQ64RCU24FLNRZ9FJ5AQ48WFTC	3
438	B09BUMIAAB	KVHLRO30UJDIPSJF0E8RFSQJD6YSZ31LP0JGW439X8P6GXV7U26AVVF2E7IUZLB0S23YJCS5L93HDTDQL17770Z3VRCZWIJM7YNO	8
438	SMUHZ6ZLPE	7YSJAYW18YV41J8ND31C9C2A3JDZRJPFYWNDPX6BDCW2Q448L934WL445RQ1V6KYJPGF647Q7097PAT8PFNSPUTM1SH8GFQG18SB	7
438	UIXWT83ZC0	ZCQBN75M7P57SLQT2IZ53NNX9J1K3FRRSJZC6QCXYA3DMAY39X8Z3G5LY3BDFVT17OPIVNWLGCH2UKL9V8KGG2XLOOODP9RCRBG7	6
438	G6YJUIUX8N	QHWAXS19C1OSCSHKNVE0D3H8S6HUELSENPF0YFTJ6MLXAUNQK2EQBHQWAXR0LG40IKFWNQWHB431ST88T0KMHBCF8S0BX28ZSVO0	4
438	4T71U0G3GP	0D3F6PHOZEQYTHV6STHHAY40UUI6EI7EIU3WQGLW51JOJMDVN2ABHSOCJDVLGLJQGLQ9O8QLHUMIOPQHRXSLI57ZF0NNUAQUR2H8	9
438	5ZJ4TJAB4I	EHPMY4XFFX4XN4S28ILO13XVC0HD21WHSLMQD8TAJT9DS0HG71SU6TEKT3K7WTNOBXEBRCZAYKEH3TCMTBGBIBL8GB6JYWN0GVC5	6
459	N7ZLC5KXCJ	FY5CS6VO6QA17OVNMG9MF5PFPMC6OBIRH1OMK80FZUJU6S0H2N3ODSPKI0XF4YA5ISTGAICNQ3WVV5I7V4EBH4OYLDEULULBTOMN	9
459	98DH79U5RR	UHTKQ8J64ZNRZT9T9XNE446ESC5SUBGS58AXU015E2RO1CVALSU08ID0LP1ND0L2S4W1SM8I6SACNRMQQ4GCRQTW4KLF9N2NRZ66	4
459	LMV5KHMJIQ	4R9TM3QIBM3DL7IUIKCLA6IA3IS0WVYVQAWNHTFWDN27SCYQU3IO3VP7J8ZDK0WQYHWKK5MZFQHXDKR1UCG2MJ24UYDI3CLN0MIL	4
459	BKEZFGXSRI	NFZQSJMN239Q7SIU4DPP2ZW1E5DF471BGMG6RL3APR24E15TC35J35XXT7MXGHT5C8JVLLDTJOAL71XM9TCBBSHLZTNT8G4H772G	5
459	PIW2O1HZHS	KH10M9O5L02KAXWER3U08628TUDU2NA8Q4ZMLLZS3PN2UI8SHDQDHPTOO2G163D8033G8K2GEB7SSANLWUMY760BKL7SF7W9MOC1	4
459	LRYG3OO7V2	1U7KJ8GSA5OP5FLROB3C25WNJBHP8GD7V54APOX7USKQSDJ2KR7NJZW67UAI11U41R39KLBAO5RKVG4G1PEQI0X6J8C5NOG37PYB	3
459	0I32H8MU6T	KR8Q79NHMK0Z4QMWEVA36ZMIGW9ZYMFR26R8F9K1JZ7XMFS83G34YHMUEZJK9YS9FI789OQEKJTH2Z6BDA5SSL3UT63P091VG7RD	3
459	98YTCMB2VA	U8PZYTOYF2O3IH82AR4OMOCUAOKR8A4I33SBQ231P6OEPWR222GQWY6G64YKI7ZE7F9PY6MIXD9PA7EO6RYG4OVE7MFWDTSRGJHJ	6
459	0IIQTWJMBK	CE5Q73TYQF8ZKO1ITJSU5RL10FEURI00513N307VBPQHG62E1JXAYZ1U3EZ2Y8GIOI4TUOP3M7SPBEU3M93IV0BG9ITYAE6CJH27	1
459	5KUMKKEHEX	ITN43X1GMTZT6PZF8XYHYTM403HAQG3LX1EPQO1CK9XZ4FEZH7KUE0NYHSDAQ0ZFZN6ELJYU6V6Y6XAVYS3S5JH6NPH8K0WTKS9Q	3
459	7FQKPIDC53	9N7J0YT3Z2USSL77HKQGA06C0JF8NOOXTMZF6JEUXCXWXP2OZWCHSKJIR5SRSUQLO68GW2B7F6S7DJOKR1J1LGEJDQXA0XBDVMI0	5
459	I6JF0RW5IU	V16UFCW1LFHQI91LZ9I1YDGEAGR4PL0BY259MGGDSS1KQUSYK16M982SV2U8V2M9OG2PD18S3FJGL5YPY2UXOOBZANOUVHR0G25K	8
459	5CPJU9L2PT	CUS2OS4ZVG0DEK2HYUAECP0NO6WXTAT9NXWIC5A5HAOGXQQ7YSRH5GZW4EOR6GFVX00RXUF2UF6CBTZ7PZ9ASMEH79N8RS9B43T7	7
459	8P3KYCP9C1	9JDNZWZJXVKOQBGHECKWSUYHHLBF5HIA2HQP5X3ZO8JODTBR2400IKIOV6GNVTOQMKVIV0LRIVIUKJEXKUNARR1S9B48RQE4T3B2	9
459	B09BUMIAAB	26BSISXCXEL2SDAGN85SDJT6M92QNAQILZSYLSI8DQL7TG8MDXG4FK4SMFGJ0HYXXDR3UM5506OX8WMGAPM04VCB59LFM9I61YJQ	7
459	SMUHZ6ZLPE	F201KEJ5HU039IK472BAQ7VB0T0XR5JM6R5XV8TR2FXPUMM18C45HPIHGZB1NVNLKO6SNXI9JUHKJFQNG9ZOBOEQIXQ661DH1MEG	4
459	UIXWT83ZC0	3NK44VXH77BJYUO58K5JQJZHLCRRAT7AJ8NVPUG2RJKZOWIHZL2BJ79TYDS1EGGOAA90H2QODD2H8A2Y4K2Z061M837MBPYLC6ZO	6
459	G6YJUIUX8N	S964O8FE2VXK364NRYEIX1O4ENYPRECLOBMK54L7WHGHKBHS37UHVFA0UC0AJ0XXSM62UTSWMGWPUGUCGGVUU5ZIBW02ELY5UTZ7	2
459	4T71U0G3GP	P8KO74PSUGNSX4DEDDXWX0830SBR15BRW71IKGWAK0QPMJQRU0RQCKRYARYO371ZF660D537QXM6JSQQCU6AOVPLQCH3RHGN91KP	4
459	5ZJ4TJAB4I	0NZ6T9P8UORAHMJA0LTRUJAXAPJQ97SHACMGHD4V9N5YZ2K57MIP082QNC6E089W5KAE9D3XR8RHNM7HENTWYDQCK53EGZ5BOI2P	8
460	N7ZLC5KXCJ	F53TV82QVCAEYAMOM82374EJYQ2CP2FUSP9SZCCEXVY32ARZTWBK9V4L1U5FG0A27QWJB3YK5XFLGLRY8CS304U6UY1FH787U55M	4
460	98DH79U5RR	IYZ71OLPSEQCHHDHHCC50ZMCTC8ZI1KPFKZO259PJQBTLC905ZN32QXSLXOYQWH13A77RYOMCWWJX31QDI3SNRWZWHDFQK9WJJZK	2
460	LMV5KHMJIQ	CIGLA0F3O5R67VI2YNMOIKKVJ62XA9OEQLA9WHN1Q5ILVJSY03U5N6628VBE8S3PQNPVVJGRAV7NB899ND7GOS0UPIABFJ28C34I	8
460	BKEZFGXSRI	6DQXD529T0AWB14UWA8W5GMJEL128LID0FQAQTKW8U6R9ODS8OP26W800HS2E9AIR756K4DDZLXKK5J0HJ3U5PGEHZJIASS8UY9C	5
460	PIW2O1HZHS	HHEKLDU8YP582U4GQMC01ZUU5DG2Z0W5GHABZKUMWGSKOKI8Y2DM7M1SWTPI61J8392VT2RG1ZDUGKGU5HE6WK73PRPF4MP46TQO	5
460	LRYG3OO7V2	WO5L7UIIHLLN4NYWMMTB8GCNLLPJJYX41CI2JVYZZVHFD2A80HUH7MUQMR9VF89TYRV2E5N1X3LM86JTLQSBDP7OR2Q1VCU1VYQV	2
460	0I32H8MU6T	H4543TDBHRQHQKYP8PJUGKMPVFUIU1JPYMDWXGK53NKK9TF26MXJHB96SPIX95RQIBTDHC11EN03ABQCA2MHDAHWNGEI8X6864C8	9
460	98YTCMB2VA	BU3U5E4KG6Q8GWGSJMH370A8S3RQ26G9RC9HSXI5MLHKXJ2AZPXS4ECKU5BCXOSJ0RQDX9AVEMRVT0KJBQ0MJYENAYXXVFI837TG	8
460	0IIQTWJMBK	YN0PBNSXR13U2BGXG9CMDC9MNA8ET2VHEQMDA7IKW0T63C3EBKW7R3ZWNOCBPOEYFWQMYCXJ110NTCSKH3CIFXZK00ZV4H5HW41H	6
460	5KUMKKEHEX	QP9WNGZCMCL613VL5TS6FV8MBOU6S0ZKKY0OCW2RAHOXOZDNJ50KILQ5RXU8V2UVMAVCDHJI0A58HK8MKHXWAOC9I56PB35IX2LN	2
460	7FQKPIDC53	AKCWSUIPRXGYIXOF7V88V4HK3H6FXKO9VHK7UAR43U0I003GQD0HMOTGC23KXC1GIGDANRU7DDEAD9TCN0YUUHWGYD42GHH13U9T	6
460	I6JF0RW5IU	229S3DJJSDCI076OGWAU6MJW1066NHTAAPV8YB1EN7GA2UPJKMW8890PSM1CHM5KTCHLL8ZE46G9GJ4HKWWAUVBBYFPMKY6BB5QZ	4
460	5CPJU9L2PT	E8MXSDC20JJST2U05Z8BGWFTN4F9F8K2E5FXJNCR8I86F316LKGFSYGS32KX7CX29RNYW7QSXRC7YJOTCJY42EJQYX4RCOT6VF6X	5
460	8P3KYCP9C1	CKO4XSBVI3TO0VYO3A5I698C9PI7GMSN1CA8J9EWI4P3LDL34S1FBPTCLM5IJDP6LGXXUZE36J9BUE16DOCXUNLLT7X7E5MEPTSE	4
460	B09BUMIAAB	XIEN7I2PSSGV9E5A1L74LEXCHZA65WAWWQQF8KXET6APRMF1RDXHUJESVCFII5U5RU8TYZCRY2LODIV5TJP183BNL7U5FO6YLF77	4
460	SMUHZ6ZLPE	WD1AGT18ZONRJY9P36YSVH1FHMJ6XC8KYS7FX02JJOWSGO5Z7ISIJO2OMW34J5LWQD31131CEOIGVI83QU8OU0BJZS3A68AND9CD	6
460	UIXWT83ZC0	E8EQQD4FW3DYANZ66CZBTBI90GFO4CWG5HLV47DWHDDZ0M5UKRH6MBBCZE0J7PLTH632BEC88C4Q8SINKVEN5Z43GJ5ZH3Y12TS3	5
460	G6YJUIUX8N	DSGOI8JHVDH6M9ML7YSC9W2IM1ENCXPAP4HC88W0UVVFY354MP44A1TQ07CR35E7YGQR2KN8C1SOBWTT6KBW2UAYK0MA6E6YQXRS	4
460	4T71U0G3GP	NBCC62IIFPDOTVT4SEEG2HC7NB7447NFBGTI9U621PFKIWNTN38SNLTF9EZ44NOHC8MMCL47ILONC1Z1XORA942ZWNJ54B7OA7IK	3
460	5ZJ4TJAB4I	BQB9AKB7GDHP8GP5OIHGW0YC9DGOAMFTORW7PA8U02QKBQ64SSWYAEXL2997DX738XARURPNKWP4JOATGM5R0QTK4LFQABRD4XMN	4
481	N7ZLC5KXCJ	PKACIONZ2BN9Q001PCRE0XIM9MIFL9WCWD1B5ORBGVBJ1QUK0LOU4JZ2CYD6FIN2PLMM8Z5AVQ8FV8US28O9VCINO99HLV57HI4Q	2
481	98DH79U5RR	HMBPN8NLTGDDUDH3NHMD9780YY9UA7NEEOUWNTHD4C536D1SYE4ARMFKNK1Z93KW399GSVQ3AJJ6CF4V7R66DMW1IKIC2SEA1I96	2
481	LMV5KHMJIQ	V9CYAAIDIHHQG1R7OTRMH7HMNBSFIF3G7QLS3ICMOYADBVW0WCNZST7Y10K9RC4DNBTZP9EGQE8S6EL1O2TF2EXNTX0D7C4L46ZA	1
481	BKEZFGXSRI	6KX8GINVO1XPSUZTYLJNFG2IBIOKWYAPKZSR5HV6K2E6DYPSF2FVQW60SO784D801HE3CHXR0NDNB6EM35E4SO8Y219RJWBG4OE5	6
481	PIW2O1HZHS	VQ8EY5CSTZWJUF89DIMJPAKIGIDL7SW1J2HPGZ3T5GICMHYRDH0G2WEVFZ8Q11VAD5A18T2NO2NJ1I58TWIZ2Q8WYVJQ1N2EVI8R	2
481	LRYG3OO7V2	6SUOM19J536396ET5IW6ODMJMWBAIXTJO2WEYLPZ8M22NW1QYUZ9MV22GKCZZ9AHKXPHJA5U377BLU6Z5VLY8T72947NIZ99MVSZ	2
481	0I32H8MU6T	UGXYFGOX0RWOM4EXMJ0ZWHPCSLD88ZZCGTLOX93NSFJML8654LAM1ATM0VG3DQZB2UI2TZ9MPMGR8D0TOIDWZNKG98YC29KCPHU1	7
481	98YTCMB2VA	DLELX6P3COX4WO5MCMOJB3VB7TQCEB0S93L69KBR4N7TAHFVO0N5GRYK0CODQMYAYE53D8N1K7PY5BAZN4XOY4MREAG667BSY756	4
481	0IIQTWJMBK	MRQNVUICAOYCY0VYKL31NZC2Q5N5698GENBMHBDKDPDWR4HHP3OVBF9WPX60HNFBQS8LYIRJITX7WQKWXFQCVME8NP7TEMC0JCG9	9
481	5KUMKKEHEX	6TGMFNSSBA9NJDB6CPDN98JL7E5Q6YTJL01WJ0P9WQLP8G5JB4GWDW68K5OBRBVNQZBTMPXMAD0SW4N1IWPBR7GY32MNMOSV588I	2
481	7FQKPIDC53	M7VH4W96OLQSX24VT6TSMZTDJ9WUFXX5EW6Y44WKG2PR65ZVX9LBOZ1WOS749P01XUOA5G1ZJIMUKCHOKA6GMWQO4KKL61L1CY3L	5
481	I6JF0RW5IU	Y0RHW2GNHMMKTU9SUPBD9GV5Q2S7USVI57WJP8Z3KBW78ANHLIRJ1HRRFV04JI2Z0DPW70DVZH37TX7PPKWLAMRXPEE3H5UBI6H4	6
481	5CPJU9L2PT	0JVF5TTOU7SXLO9WQZNV1G3VJN3X1ZXPD3YBBGE27J5GWG6QUP1H3I4UQ96S05X5KCUR07VKUVXSLW9DRNCM7PW49EVBJWCCVA5U	6
481	8P3KYCP9C1	OZX3RXIUMI3A3AN2L75P0SWMUA7SV6L0PRDXPSP1OJX51BQWZJKCAE55DKJQZZ8P7CVL70N2SDBQ50UTUL3MVI0KWHTFI8CZKH8Z	4
481	B09BUMIAAB	EY96RT6COAM006O5W3YLKZ0GITTBMGY25DQW4QEZ3HIHHPSCX3YNKNFO82Y8A50HLU4XQ1BFZ9RCRS93BQNSSKSS7BYB2FY8RA5W	6
481	SMUHZ6ZLPE	4W62SXK5D7P346TRHZBCMZOC9NTKTURXMIG4R09WHW4EIH7JERKK3UHFH32FEAMSP2RWZZ9QZO404K31PKFBKG31BBWY74SGKMYQ	7
481	UIXWT83ZC0	LTPR3UOZRK69BZ34KHJ9ZUYCLS56YPSWNAE00URVOCT0ZY6FYMAFPRB04MFKZSBB2KVAUCD0ZXUXB8NWWZHLPMH59N5OOH65AR7P	1
481	G6YJUIUX8N	5UVIJP16OZ69TYAKZWPD0BGGZMS0YWTA8T0EWDF7P9UY9P4S6VK5SMM4NOS76AH2G5B975YWQSX1QSHKR94DLXSWH51HUIBO12SD	4
481	4T71U0G3GP	5VA6YO9YVN5HIQ6FEQSNP2BEQCIQI9YAD6VO4GXJS7VS5AL1EIXLA09DT6QVFSPVY5DM4RL73I4RGTIQ0RMAMN9M7S570BE9R93A	9
481	5ZJ4TJAB4I	96X7ZR16R69Y94YGPJL51PMVNH1E49HZHU1UZCX5IQPV5J0HQ3C0SFFUUBTS0XBSZKQPDDRMVPXK900EQUXB7RHCPHAXTEFUO76V	8
482	N7ZLC5KXCJ	LDMLZECR4U3KPCF9AUHCNA6D33RKC6B3ELEQL0IMEUUWGMECAUOMYSPLHJR5X2P7SAGD7YYJM583PJ7QYOJRRZEW53IBIMZMFWDG	2
482	98DH79U5RR	AEL6EA3UW58LAGIS7Q35UIEPWBAFVX2G1KYJ8VNYLBJ7K0HFR3HGJLW2A6JD9Y88D1U0S8UMCFTS9GE635Y1QV7PX6JBMJZXDK4T	2
482	LMV5KHMJIQ	RWSJ5DE1D231MKE9GSR4EDVYS93P6PYMV1LIFSUS2YTDPK99UX61MYAOA415KY4YDQFV854Y79BQTSJIA45JS7A717IL0ZHE45A8	2
482	BKEZFGXSRI	OAZ3I3NWU4SVT5Q3VFGQI4BXS7I17VYSKDW3GPKDWKGCZ0H31LJZ3R5T9BKKUVZ8GAKPIWXF4D48X872ZPAWM9Y2IC4EFASBUI6Z	4
482	PIW2O1HZHS	2VEXE40X66ADRUFVCWHLSGF2S94U2NPCIN7358HE8EMG3AXPMQSVYN6WPMFEAF5SQ85EXMZEOCMO498RMOIM53N4QKOT3DE3I3Z5	2
482	LRYG3OO7V2	S2A0NGVBS1QNX2V6TXWUBYM8GLL8TFBJDM3WHVRX237T7FFLT6ZGDLE3PCUC5XRM0HJL88Z7F91H13AAFAPWP4F2IAGFBO1ELU2Z	8
482	0I32H8MU6T	4MUH2ADT6CWBT75I575BRC81U60HX6GAKELX4PX4CIL7UDRR66PX7YO1O2X5K56A6W0PWINQKB9I0AHQPJL0QTDW0TIB21TGMLB8	4
482	98YTCMB2VA	B5XT9N5YFBOVGQBTGTMSDZCALYSR26O9IDNNXGQGH8US4QVKSXG1YPIM2XHL4N6JWOMCCX59DGLFEUG5CI9FZWK35BUA9EM3CL5P	1
482	0IIQTWJMBK	SI41HYRECIIRMJVO0T9ETHBC5984RD2Y01TAEOS82Z23MSX50OL16LULG25HZXW9PT0UZVKMBAL4PI0MMDEC1A2PHI3LSKIFC2N3	8
482	5KUMKKEHEX	DGEE9059068CT5WTUHO0LMQ28302F2W46UJ6982K7PRM4J9PWWRV9CR0ZMFGAD48KDF8WZTVPE355E7Y3KFTKB53DSGX3VJ4VSC1	2
482	7FQKPIDC53	B36C6F4JV4VPQMZ7KYJIL4DS62349JNCGU2RIRN5ATRXVHMJT6L43S2GZOFDL9KMRTI5TIZ3KNH2MQ7YPTLC8SIX2W14LJTBJFFB	9
482	I6JF0RW5IU	R0LGRTPKA3JQRY1YHO9KVD7Q4SA3GTHK6Z8395Q83M22SN4V2MB1G0NN34M9TVEQW8U1Z8YL7ARIKE8RYOB4RPEFMU9FTRPHILGT	8
482	5CPJU9L2PT	C53XZ4FJFDZ64LEUK8G4POF8T2QVJ997PYVTHG2V85HRKIYGKX8MAYNY05E7NU9FE1QGZVMDGU6THXXKDKKWBW70K72MC5HO6BNT	8
482	8P3KYCP9C1	SQZK4GP24QDH34DJNER306239BLMRWGKDSU3VLGQS7PRZFJAEES750BVX5K25CKHK3DKJJYB7BL2RLE42KINDIONR9GZBOVPXHG6	1
482	B09BUMIAAB	814PRA4PJEM1PAU36DBO02KD9ATQ5FJEI33TO8WHU8I447VNAV0DFRKFR0QRRNTD5HTWGBP8R342UPJBOFPJPF90SXBXSE0GOE9W	4
482	SMUHZ6ZLPE	8H9G1WLWSVBROCM7KYZI3DS91QMDYOQQWYP8QDXTXEACAGEBOIDPJOU5Y9OLJI7EEV4ZWNQGBGUYDQ9VLLYQKAGIDUJRZLJPG58P	4
482	UIXWT83ZC0	OPA16OD352IA298TR4DOVVCE9RZ6FSHRUI76XYNWDOI2BR6ML5YB4B02M61PZGYNV0QUCC52QRKGNKCRVMUJ3FXTRET1676704HL	1
482	G6YJUIUX8N	MJJ95UM0UOC3J3MVOTPC7C7SE5SVNQTC1QJDLK8UK270Q7WETLLL1IEJM059B1ND59C3UJKEU52EEHCGJOBBFHLTM91UP8STP34R	8
482	4T71U0G3GP	3TKAG06P9EEYY0XZL8YYSRUS0ZWMJZKMULP41B8QODM4W51H53D5G2MM91KRETGK41DML28K9HJPEZ648ORQVPG29D5A0QM57BA4	8
482	5ZJ4TJAB4I	O6C5359T6HJ5QTZB0YPVLNI67TT4NSCZBBTROU2TGJC5WEJ6W3GNVJQBYG7JMEFOEU4OAIXF55OCKMJ2JWHULZD1VR2IXTGCEX0C	3
504	N7ZLC5KXCJ	56OGBRZ5O0M6E907UDPQC3SPPSLZM8WVHSOZ3NKHN6G1QLSUQETULWIBO91TGASQD0ZWUAEH3HCFX18D91IHOBKVJML4W0BNOZX0	6
504	98DH79U5RR	69PAM1DTDOXAXUO1LBBQEMIYJUCGZ17DISC12GCKGBG8Y49GWVDXVJRU1001Z64LQT1FRW8E91JCFKAPV5TDYKR9AS9CQLUJH4RE	1
504	LMV5KHMJIQ	3Y9W8Y4APOR0LF3N0XGB2F9X6YYH94K25M1HTRZVX8UDSLEF06RHKCKYYMZKAWAVDY48OW3I8UO3U6EVTSQCMDS3CDSG1OVA7993	5
504	BKEZFGXSRI	G1EDIIZYQD2HE1RG8I9GB5KEWRT8N6V6LEM1M9D52EV9Z9WWE490AWPKQ9R1Y0LUS56APZ49FEN6KLOX474T656YYBLMSMGC3AR3	1
504	PIW2O1HZHS	WHP9AV5JTAFU37161YX9HMNOSQ37LDK4UUIZOT6KAPFBG1YPPFBM445K3BRT288Q0L9JYCSH1M82GMH02OSFB890Z75MCNSCRZK4	7
504	LRYG3OO7V2	P0NX4UR6DDQ310NQ2P2LJT1GFFO45KRBN8NYESGNS3W4OTLWEWZKSTR58GSZGWA2VPQ2NZLJIO2Q761V310JVHS3QSZ8ARH533J9	1
504	0I32H8MU6T	SJOKPBE0B7CP65O60GN6WM4ANJ0H7XDX2SKSL8FFOCOVWTEV39CW5DQGPN7GK73O3OWNV6U1AHST7JN4FFN7UQ2ZCDD8B94QJA1I	9
504	98YTCMB2VA	0A6PKWXU6JF9DBFT63MW7KR3W0BMBK6RF7OERSK4FEG37878Z7NGPV8PTD2TUKTVMX4FWBCNTRR3EX5X2DXE70CT88VNZ0K4UUQJ	1
504	0IIQTWJMBK	2LX59X7EFL5HF1RWPYWVKGYQYX2HWITGWTA1AJ7DFO3XZGU93IE64Y3VXHGM40S71YVV0ZWG1TQ5NA0RD3ONDXM70PE2CVIO665B	6
504	5KUMKKEHEX	9IDW8FLI7HWRYIBME3EMX4LV3EFKB9RFY6DUK1FRAZ2IRLNMHC1C0Z7E7S239BG8ZR22FQBMXXL7BDDR13C8HPP989W29LS9T4SA	5
504	7FQKPIDC53	VH0BPPDNAC4PLCG8H1KB23G4JNMELOHUC7FWL729LV861NYIMALDI811B61BC8CW5KMN6TXJ9KZG4JC6ZD2KCEMDGOUPF07NTMAR	1
504	I6JF0RW5IU	KL2NBE7IU7135M9F1T08IGS9IEINMXSIU5O1A7BAO4WQ3VKO7H12KT2E23F75U67OSIA7HF4S0UNUBFW44PE5Z8BCK8H1DE38YCK	4
504	5CPJU9L2PT	JQ0C7KT9OT0XSDAF2BZTH7WI8COV0P594KUNYB7POCX0ITJAEXFWN1FL3RE458I9Y12HSXQ0EJEEK6AO3ORDJIWDFJUH7DTQ4YCQ	7
504	8P3KYCP9C1	BRRHPSDWAB7R0BQRF0PEZCJCJ2AZYKV3TX27A53ZSREHWZHCD9Z8XMB8HO7WSN7ZPE8CJSQJ6ZVH7BQTV8WZVXGHV3ZW7GHFTP2S	7
504	B09BUMIAAB	E3USPB704BG8OBT1IE270RP34LZRQXSJ72QFBGFVIQ11TXTFYNLKAUAXN1YELPJGT7AVUNZC9GZK0YKG1U3DMHIN132KRAK3HVIV	6
504	SMUHZ6ZLPE	8UKXIL3507YRRN1VG3LYX30VPU865CEPYS3ASPD6PRB6D39XSHA177AE3ZHYN79X2J29T1D0ZOJF14RWUKNXCNS1SYG2HPTRROE4	1
504	UIXWT83ZC0	AE1EJBSX4M9IVDCUMVO0AQ4UKTK52XNZWWUGVT2L9DXMHUWMQ6F3ZE9UJH401X5H8JW8T6932D162SNZ67O5RUASW97OYBULIQN7	9
504	G6YJUIUX8N	X3U7MAWMC103E43J90OIEMT9UE0TQYMFP1IE37ETOFTHGUTH0BI08Y3LJVMHJD6OPUNMVZPCV5482L29UT2OPWH1875IU6JLJF2W	2
504	4T71U0G3GP	GVAVGED45S72MXZKR82NWOY4HRYVTYXTG2O812JRE6CP7PHJTA1G9IV26GOZQRKG4OWUJ1SZZLJZLJ71JOCS6QT7HVBVNUAWW6US	8
504	5ZJ4TJAB4I	XA2SCRY85QXJXPCP2JO5YNXZ6LEKWDPZO7VNJA4948LFOLZE8H4WFXEKNCV1MNL2B85Z3YF1POAZBSLVVAMPJ2T13L9HODWQXSDQ	5
523	N7ZLC5KXCJ	AKJBCG1WOI51AFMB6TIOE6SZ8NM2TCTO5EVZDNGV2EODEPO7KP085BMD2UDY48DMYR65UW8SMWWASOUS9ORELUS32R7SJS13ACOX	5
523	98DH79U5RR	SNYQIWJOMVN9VZPR8AE8CDCYPI4439PA79RB3XD8JPP6UTY2MMCCJYQOL9B91OUNFNBWINYL6GZXXFE5UCSR7N0JSC03VDG44C0H	5
523	LMV5KHMJIQ	CU8X0FD830F5FPZ5DQ2W2EFX4Z3952VP6ORRU3GIWLYMU7QYR80W7UZ8PK2AMDCBF0917ILJJU9QP2D7JES6B8RMZTCKAG5TIWG4	9
523	BKEZFGXSRI	Y0JXQNNUISWG50HVF9GIXCOFAJDYQI3VJ9VOJJUVD1QAPDFPY7DXAVLWLDWHJZDAZA75F2L6OVE5VN07DY9SEGVXY8CGWNLOXQLP	2
523	PIW2O1HZHS	JJ5WGIPQPB7NZDVZV5SOKHHZFJBJZIECL13OE688GGJ6F27J0ZCV2A5CBFQ7GF0G65B7KGUY7UID8KUML2SAGTJK51M8QA1AQC9J	7
523	LRYG3OO7V2	99UFNYH22E1UDVNX0ANW1CS3VH63HX6KLVM38524BSDWVONPONZBWX97Q0TG1OUFIQJRIUY5ISUI96HH4QP474YXVPNHMVDW87OF	2
523	0I32H8MU6T	5G3Y42DC18USLLK90HN1V53HRTWP7KBRCD9KVGDCVV4R2YAK2WI0BOS9MWHLFXER7CQIMAOUEKFABMO2SMXLCKQXU9789278QNT0	3
523	98YTCMB2VA	281IYV0JR7AIO2393PWV3XMCPVMNHUY2YT0O6COY0ODC70U9E8W87EPEWY2CJMB7JHU4BOD1A75OUKFZAMJI705TEV2HKLPOMG2Z	2
523	0IIQTWJMBK	Z8Z457AIAUMTCC7C39SMA0PW6QZSRBORPTLNUOC34KEBQYHIRLTGJNF9SC8OHR18F4DT0TRO7ZRZWOGHJQBFSHHBOM5SQXWNTF5V	6
523	5KUMKKEHEX	YS73EJU6PND50F0QVQ8XBFOX98JDEGQSVWV8DMN7XF891WZS567Y77TTEJ3GAQ1I6VKDT1NJDA95GP6NI1HHJ2UXDC44SH7GNZCG	4
523	7FQKPIDC53	W8ETXV78XMZNQ7JJU9EBWAR7S15C3SQMZAW2DYVGWZPZEQBJY7308FZVRGA5Z5EF6NXPLQF5N7O7U12C0WN5Y0NULAL6Y0Q1UK31	8
523	I6JF0RW5IU	V8I17MA12B0N8FDRJQF9DEKFIHXRWNK7AJFXFE0NM3T9UTZVMJL3X2ZQXCS0ZTEP12MY9PMEZ2WJVLUZRCEMBQJITYACVAX3YDI2	2
523	5CPJU9L2PT	AV77GE5FQ5MS2IXP1NKSEFLPJTYE3URD2TQQHP5LOCC2XU22AO607JC5JRYXP1M5OI0J1GHMR9EBCT1Z06EPX1FSQVHZ0I6X0HOO	8
523	8P3KYCP9C1	SA3GUI8EA20Z96TW7HWCH3G9SVJCRK5EM4H6KIDSHNP3Q91LMA3A1LWZ44Y885XZ7VNEZWMYDE53NNSS38ZRR4MAHRBQUFTM0054	6
523	B09BUMIAAB	XV0XF6XQ2MRLGEAFFICJM6IU5D8UTDXRY5GM93M7ZUPEUFOATGUR3VK0NF2B8C7ZZ9XK7XFM5ET2RDA0Z7BMSFYCUP94BL9WWZPV	5
523	SMUHZ6ZLPE	DD6BIVYCSJKEBMBBVHULUZSYKKUF6F1XOIV4ELJT99CGYZ988VBS4J7OUI08ASFMRWZ31H6K7ALUXL9UKWHLEJ3FLHJ6ULSQ40YC	9
523	UIXWT83ZC0	GH0Y0U48M1JJFXOL4HI3USU7AZWR406W6UEOQWNY8H8QAXOXDF9SQJPYX3YB8MDV4WMVTA5H3T4NTE7MK8NZ1NFXFP0X8MZWDNVN	3
523	G6YJUIUX8N	3EDK1Z7OBFT5L0A8O4QQYPDJIJR4IJGSTBR4KP9YIJDKH1WVZXZSF7WOA3BSHCF29BMKJGY951HPM3CQW5EUUXNVOC3QNQQGDLLF	4
523	4T71U0G3GP	MMT90XN0HCH1V5M7VHLX05GMHWOLBMAS6BKSVV4AA5HAWY1VEISD9SYQFG1EJCZ4BY5TV3M9NLX4XF0S42G346SOM3MP4008GM97	8
523	5ZJ4TJAB4I	IAK5S0Y4429PIJQ55AFGQG1Q6FWUZYLG3ZW257LF3USBMAVQKCKM40NBI49MEEEGR3VTXX98Y9M6Y0D6TGKXN8MCLUUB89BZPMTT	4
524	N7ZLC5KXCJ	C2WCLX4NQMS0C273R2SQSHDD8AZ7XQLGTSRNXUBLRZ5HBK5GE58UAD55ZTEL7709BLGTLTG60G83M5BXET31S1GQXWYEQ0OU85G0	1
524	98DH79U5RR	M5UZB33EBT4RQGOD9RJF05Z5CQA2N5QYLT2YJBQ8MLWD4WAUAR9O6UNQGZXV2B0GCFG6NZ47AL3OJVBQPQ166C10GMSUO5FKVQAY	4
524	LMV5KHMJIQ	DGKWBOV19GUYGFMJ3J9NP0BHKTEFS33VMALJRK4YF9GF76IZ3B1GAL9NFCMSJQIGN9LF3D2TOLHPT5JOLPMRCWUBB8EO8MPZ1A28	6
524	BKEZFGXSRI	C5ZJH1ZDU4J27H3D1D0PKE58NVC6SYSDL3ITWI4447RE4VAFVVA6BTJ7A15WZ2V5LGRD8KRSJ5UMX1D2U6L6XWB1ULT5NIFBMV2Y	1
524	PIW2O1HZHS	6HKERXG96JIXCB3RYHZF0TW1WFB0SAC8PYYZA1G842XBKHKGMUYNDSNMUTSLVQR6HKHOMDR6B0K85VQO54O7LY56LLFQJ4MOL04A	9
524	LRYG3OO7V2	63ID1LMIPR8CDQ1CTUSOLCB8AXHN6WE0QO9AF4UNSY54GOFNVM1GMVY32KCDD8M2MIVZR06Y9E6XGH1WR42T48O5ZGI52QJTMDR8	8
524	0I32H8MU6T	Q64PDGHYBWVSQWJG27N3Z9KSB6T5MLDZ33B77D12HGYTWML4ANTFDEDQVLOHXMM0S6ZXULIYGVWSL16YUY4817VZ0VLWZTF547A0	6
524	98YTCMB2VA	YJYE49SRUF4PZX8RN9VKA699W9WQ1YN0FC6OG368CHGQRG96GOQ8PPW1KYS5MB051DJX0TKTCXI20TSP90JNIOL0PEESLAVARKYN	9
524	0IIQTWJMBK	LFXD652H4B0GC5W2NXM2TIWO2IBBHLQ4ESYUWJLTSSUDNLIF9IEWMVNDTILX40ASU6BUHBGDL3JAXSAQA6C8H3STFUBN8XY2SCSR	3
524	5KUMKKEHEX	Y87CAKSLNPAI4X7YCL1NSPWA2FYERSVASGM8E6GS9H1FAFDA0DQ00D1JL6J5WO4549ZYL9UFEJOKXRAXBXNOB4JPOCWIWL5UN6KA	4
524	7FQKPIDC53	PY1SKWRZQV46V48AP390KJIMMT2N370G9HW9W51H207R2LAR6T8DLKFFQOG13D5T5X7NI9OTC27UL1UASLQJ9W5YBQSHZANY4OVE	4
524	I6JF0RW5IU	WJ7FOBTNV4Y4FISXVUI2IM1RH4COJZ7GPW5CTEUVMLPW3MT15BJ3MMFKRQ7T8ED66SPTMPDQ9XQ76FX4KKSHQD3DQUUDGAWHHTZL	9
524	5CPJU9L2PT	AOP724Z5HOL2CIYW5Q3YMC259K8AI0NQL7K5CKXIEHJGIKD28ULC5WV7WU7S5YWQB5RF82TV2UUE3WWZGGBXPKUZMNJSMFNPU2EN	8
524	8P3KYCP9C1	84GBZJLBQEA8IMZX9B1L12UTBJXHEUARJ5HM4W0AJX6JIUD3Y2V1NBCFJXAQVD76DTYNEM2ML0BD6LKRF4TM9JEH3BDHWKOF0AGZ	8
524	B09BUMIAAB	0YL9IQWA8J8NTK1UU63ORUCJV0AL6M6EUVPGHM03RH42E4D9XUFDNKOGVCOSPKDVM3275UNIG96KZKE0WBYLG31JHIUE8HOGDIPL	1
524	SMUHZ6ZLPE	FECG76NODQL8X5OW2PTBS0WAIK8U0HR42YQ6VEJ6O5D1JGKLATK36JTPRC8X72X69QF9ORBXGWXWW50C9XUG6X7TEBPTGV8VHG22	1
524	UIXWT83ZC0	K6TSXXJW72WL5XKIRALSW4NCSQUXCOQC7AZ0AXIAX6HJ2HK7YM0FQKPPTRAGCWTSMTO58UH42L4ZXEJLGX9ZYKWXVJGTXC8BNY6J	8
524	G6YJUIUX8N	P8DF5NFP01PHZAOX44B70JYOXG0M3M9HAR0Y5U27RI5R1L7BTOS35LCGJZRYX2VO2HHHK01JBDQROHWMIY3P3GLYPUOFCDJYWRZT	2
524	4T71U0G3GP	012WJ115U1CDFQ98GVV6T20LVH84157RDIS6A2TOU242LC7XKZQ6DXU8BRBB37EZ4V977C7OBGL0779SKKTBOBNPXU5T1SVWYE70	1
524	5ZJ4TJAB4I	9ZI2B57L4ADRS1SODK3HUKNGNXSVZC39IPKUKJMGQE2T1CI0CIV3ETSZMBOOMLW2HEICR7D37X1PR3PLO2SRR95Z7UII483FSAMX	8
551	N7ZLC5KXCJ	GIFE15Q1DISWCAT2FKHISF7Z5993W7QQ1RITNM0DO74MZV27KMNZEOKALQJ26XFF1C5U2AP2UE4ULU9JHBTJU0LNHHH7D7H12YVX	7
551	98DH79U5RR	HFK6UFAUZZ1QAU4E5VA0SNU2SZW7D2W9LS95JN9VL2RRQQDNMX6DU7I3VRN5SDR7C1FRV84SVOOZ6DLCWJUQ6TOOKGK19EDILUPZ	3
551	LMV5KHMJIQ	V1O2NRGSS6SGLIISAASM0GOXDSRLGNMYW1ARFYSCI51J2UY54ZKT6MUPN1Y5A5MFU4UUI0MMRQE5OF4S4VQQC21KGVEO9XCNTWZ8	1
551	BKEZFGXSRI	DXDM8CPHZAI6FAOO5C1CJNWW8N3O0L2Q6R07MDE0MCRU6S3XX8YU7600AROVIBRNH1AYKQC17BZH5BZPTG01XIS90964YTRLUEME	5
551	PIW2O1HZHS	FNH66W6GT5918BCKZZ9JA7KTHCOTOW0YV7O3S51VW3HE7CZRPA5ON5SICXZ3HM26EKGBXI238NWGZFVEM6DO1LL0PG04G7OJBLAX	9
551	LRYG3OO7V2	Y4HICQ9ILS7CUQLJNF28QWRR7XB9MFOF8HYB6GZ5LRDX32VQCAXFIYQCNZLOPA6GE2DM2JMHQ6W8S3YEBU7MRI6J1VXH4KQLV7SB	7
551	0I32H8MU6T	JX2XPZLCRUUAGN4CUY654VGWFMGQKNUKXP26EYBSVGJBDGY7VIAIWG4XQGRDT51E9JN1V785WNJXMFS9YI4CMLXRVEP7G890PEB4	8
551	98YTCMB2VA	6LYKEWJ6GLLYSOKAZ1YV6GQRAYYNTIHDXH27G1HZOUO2EJYUYZ0NNI504GJQ75M8EHALWN47T8HL1YN0AEZ3R4ZOLCC9R11SHQY6	3
551	0IIQTWJMBK	N7L423PBU8G3SP3GTQJRV9UL4P2GYEL9QRWGN8ZAKN1D5G9M8LYAOOXNN9ANBINPWHMB3W2U1IGIIQPYQQIMPLUC3I2N8M9C9LQY	8
551	5KUMKKEHEX	7SLTEIGHPE7UL6V9AALWJHU4PVPJEI7913S763LCO5OD53XPOC9KFCU08RDS36DHH72ROYCHZJHO3Q8V894BJW4ZJ19PZ2IR1H67	1
551	7FQKPIDC53	FB0A1V54G7RSSU4BB7UDDIWYXR6BZWWTBU38EBRB84C4R7GIOQZJM476OBMKZ4FTL7R8057AQSEIG2HZKXXJ6MGGW7TDYHLEZTST	5
551	I6JF0RW5IU	IRSSZ240Y0W3X9BH5W81KL3L3MJH9TWJXJBGE0HUMQ8G7JBIK736U2G7YGYNTX0FDNFN75CFPOO3NWOULB6CZZZ5DER8B4BZZ2DU	1
551	5CPJU9L2PT	XKO4YRFNMUB1EBR0XQNXKK3NEDUMYDUT4RY0SIAITR1TQH72T9BLZ63MRA0V72ZIAS6XN1IPQFE2TK76F13ZBI38YLJRROK02ST7	3
551	8P3KYCP9C1	KO21W5U2A3HD3PF99G1Z88CS08B5NAA0AW5MB8PNJGXSBOY9E02M2ILLMKAX3ZOA2QCGU28B0NP2LTQMKC0WHY81LUA171TU2W0V	3
551	B09BUMIAAB	ROL20VO2T923XN1813ERL592GE845AY34B2XO4QCU92UH7KO2VB3WDAWPTWWXU7SL88WVDU6MB6LCPVJ4UBK94H1AGI4I4PABJJI	9
551	SMUHZ6ZLPE	X3YAERUGYT97M2CSXTQ0HVO5ZYRW6K3GMKG1MJ5MXUMWI75CMRO02R1BO3KP97KO03VCVLFNYDDXJ1W23PKO5CN4TEMT9QNZK86O	3
551	UIXWT83ZC0	2QALBBZOE2WHRVUX5SXQ0TQ8WOI0OML5HRB9JC4AYQOM0MR42CPPI8VI9CZX38A1R19ATVN2YW1JEEIK6N7M75WJ529HNGH0QX58	4
551	G6YJUIUX8N	RKHYW0WGLE53O1QAY3VEZE1VGORPB3QJJ7PC0XLFACUYEN8P1Z23J3XMTWRHJGESXVURLNKASQEWUDQ3PBYMAW9PKCTDGD638CAS	8
551	4T71U0G3GP	RENO2L3ZA1QFY1HS2RAWFGI4G3PUKYSC7A87L7ILFZJLC8SLYLFUA6XL5SH85JOLJNHX3JH4JYQP771ILE59T7CBNWC2ZJP5L7BZ	7
551	5ZJ4TJAB4I	4RPDLLLPIO709X1OO2LLGKGGOE9JUD95CRQWP5IV0VEIFB0WYR6E0NUUKJYGMC5EOBYSGF8TUZVUF7BNONVDH4FZ65LGGBJX0A3D	4
570	N7ZLC5KXCJ	HPSSNTA1AOMIL19R26U58VK32MTQ74FD79G7CU4KF76R885KKF8DJHOVEZ0BAT4GJJKLUBPICK0BZ344QIF16C4ZVU3M33JVD0HZ	6
570	98DH79U5RR	TZJ00A9RN6K56U2NCJGOU09HDOJAE89VEG7T6BGB4IHYSR7IRIBQBLD3ZBXL18MO6Y0ZXIRADFTLSLYVRAS67TU3DD34O4K56324	7
570	LMV5KHMJIQ	HVI1AM511KONB30QQRME7WTOWWJ4XPZS45KPKF6HZBM3PRNATPPLPZ3UB4FOCADLV6SFTLFLVFP5K09EIIKH9OCECZNPASEY8AIT	9
570	BKEZFGXSRI	HRIJE0KK7KL4AF3Z5LG3ND37ZKCA07JRQEB1C75X23EOBV9MK8CYBZVDXLT3XKTAA3N5ECX8QSBT9O5EL0Z25VQ0T7E0NBARJDOH	2
570	PIW2O1HZHS	DIIKDHSYBEIPPS7U1FPNXMH76UPSTK5AY6IRQR1N8CS26L8TD6S884U0BLNT19F1JH1SJPEJNBPV4OAVW6PW16C3MRQFEHV860SZ	6
570	LRYG3OO7V2	PJX2IU7P96WK275US9NF7G198FGPRYD5LAGW14SLEOMV35LK0NO0FTXIRY4DOR7L21821I3YRBAS3GFC46ZDJMZ1N7ECAP6XQB2C	9
570	0I32H8MU6T	TTSU0JETEPLT1JS24BQBGO3D0XCEMB1ODFLNHTTDVIIS3TJFO5WALA0EZO4CH9HCX6QV8FVKRMQ8FLJGO60RP1CCPGX2YQ6WBG47	1
570	98YTCMB2VA	XHJKLS9U18OEXXLJZX63NG1R2WAQ379QMC1YQHDIDRXIIXA3VNLS8DZRQ1RZSS04882V6W2STY05TTIEVH5QWRSIMKIYZOZU12JK	8
570	0IIQTWJMBK	P68U28JN476TMEKWKHRPTIWOD3F8FE0K7IFK763SI5SMLFMJP8QU14MHKTQ93KIZHWVD89ZNO9HYZJD8Q5THXFSC679NP4Z7X3FZ	6
570	5KUMKKEHEX	ILPIDG2XYSBQSS71ACBDSHBAL8TKJA6EOOHUD8U80OIO877L1GW0DVBBJP6FXROXW6CEKMYCRCND8WBOAHSDOFA2MGKYBPLIAV2B	8
570	7FQKPIDC53	2AOSUJAH8DXOSEP8LJQ5J2EB9AC1EDN39UHGEU35AUODXKTL6KYLLGVA6NSUHJD4Z3O76I40PU5YNBOZQ043PBR38HK1CJY0RTN3	8
570	I6JF0RW5IU	VPYP760K6W482EQOJPYLV9Y8DYF6EH4YU44LGORE0SCUP2KFIMHDZRKW00MJ04GZ2GO7JEI58TUC6ESLNAY2908CUHVQCIO6MM1I	4
570	5CPJU9L2PT	M5DDMFF6HZVHA50GN0CILNCT13ZFY0UMJ7BFVYXU2FMR9IBMX08WZAC93TLSPAIRFI8D4VVZCRPFAUTT2NR817XI5BLBNEE275L1	3
570	8P3KYCP9C1	7RCEJTIV68I920CTJZIVZI2JTL8MXIFJ2I46O3SNPX8DDBUNCIXFDGVZY3U7V58Y29HU6FEPH4FCJZFS1UKOUAFWWFHUJU2TYKLE	8
570	B09BUMIAAB	AR6DI7JATP9YCGBVUD23V718UGXCWN9OAY0DNKMC5VDZI6GO18EGSKID08TBKHNFPVXNP7IK1Z893BZX9ILXJ25ZPXMO0L1YI8JW	3
570	SMUHZ6ZLPE	383Z4P2MJJYI6BB505WZ772U3TQ8J152DPGJS8PNCNGNYF4JZ2RCW6K5GI6K94DRO6FQ42N2QJXU1O6YYGIQJ2FGELDJBEOIJY92	1
570	UIXWT83ZC0	NP7PZWNJZE2LIW3WWIW19MSZD0L5OKCPEXL1KBTG26OHK83SUVXQMBBA6IL9KR4PCNHUKCMVZP9C8LOF62K3XVCDWK4B0T5KC9F7	7
570	G6YJUIUX8N	JHSJC17B8CV4FDRHB1QLE7AHK4FTYA8FRPWV1UV4EBYHJHUPOCAHYVWMGL8HVNN8DPM0Q6PRGWGCJ38DJZFW91R52KOQVNI1YZD4	8
570	4T71U0G3GP	48RWTBCPUDNN476H08M7R8GR952OOOTZDJP0X9PZOPIHAD1PLT7016N629XYIXBFTYJVSFT1SWSBZ9R6EMC4Q27H5S8YL1Q1OCXM	8
570	5ZJ4TJAB4I	F7FAFHENMG2S0T6UGY10CZ9H5P1G1WXMEC8P74LU33TMFFUIUGIN6W1P88E0Q8VZTQOYURXLNG7IGXB04SWVOJQSLTR80VD5H42Z	7
591	N7ZLC5KXCJ	6XDS6AZYSJK6N57LALKA5NB9YV2CCAL4M885TDRI032JGCM0GTHSSZ6TVD3LIWWS7QUP7C263BJBV23WIC6S32MWCOJPJFADHJL0	5
591	98DH79U5RR	73D0KZQP483JGCG0DZED7MS2NWYBF4LQDELJ22SD6GIQQGDC3NDUGWVVKLNXBOKAWNGC177KGBG0DBMGTVH100JQT08RP4CS6H3C	9
591	LMV5KHMJIQ	AL6Q2NFQ4RJ9GDPGSJ6DZTB9Q5M8Y35HJHTJLL7MDAYIYSJ0WMN879KQK7A7BH1AVBZ9UG5HMT9Z52K7VVLMP7KK6C9NLAK6IXXW	8
591	BKEZFGXSRI	KGQRGVN9VVRXCLQ6PVX1PCRGR6MIDQHFXFLO45JL6KLRR0IY4A3C94MHYJ9KJE6ENM96ABBULL5F1AY1XXODXFF22D0U58C1NGDF	7
591	PIW2O1HZHS	MX28I0X9HQYUIXV03RIGGE7LRYNJE1U6TALAVEOOR3UWB9XLQAUY58UH0RRUNO4Q62BILVFYD3ZMTKKRBB2DG6AVPDJDX4BD9D0I	9
591	LRYG3OO7V2	OA456UCIHYQH9SLV1K91P2IMBBJ1WNPUBSWB7IKL8MIP36XLZRI30QSW2S44LKW4I5FQ6KXSAY2DU2SEN8BEFW3UAAJPNP9YZOH7	7
591	0I32H8MU6T	GPP3Z3CYOC99ZRNISYVCUQ6BIEUYEOGVVNGSWKQ316V7JPY8WPHZV5F0TOVUINTA6NOLK4WHI2LY4813QWBYGQA0HQ9IZ5UNNUB5	1
591	98YTCMB2VA	MX13AR2UR5UW2DWM44PNYD45NRMI7KJ651D8K5G9HF0UOV728BS0WSMJ36QTEUWGVY1AAXB9YQFSNJQ1TUK62TKNP4FNPX4XTT90	8
591	0IIQTWJMBK	71K9TCGM46UQY9UKZOCONVGRYUAWS83KZ7W297IQEBU8V70YJN3E6MRMV3L9BT45CK01M2K2FVKMAI613MMEEZNNPKGGWJPUGY5L	2
591	5KUMKKEHEX	9LRCB9KBELN6TFYHZ1N6MLCVEG5GZFLMUU3B5CD0CLL83JCE0MR7SO3YJ674DDL99BL9LXMWXX3BAD15E1QNXO3G1F18EIX99L82	9
591	7FQKPIDC53	C2DA4K5U2XGEB0LX8LVHFIG5NSOA4BYE98B9NM3D7V8RV4CRLLBANU14WHWM55009BEDZLKVRRJUJYJSP7YTAX1OGGNF0QIC5HST	7
591	I6JF0RW5IU	929BPS5KHU77D78HH0LKZ6S8E5BJHZBFZ3PEYRVF6E9VPIWTK4XRHJ9CJB7TRWDRT1HKR3SZFGNV77S6JR8MBU8Q3N5WTBXKARCX	1
591	5CPJU9L2PT	LCRL7MB5NFMSBK9X0Q831QE76FDSDVP4557PRADI7UQHTES0YWJBE4I58TP1IS120RXFNTGZMZ6HA6O1XM4RLO0AXCR8ULAO2XRB	5
591	8P3KYCP9C1	NNEQUYO8B4BEYE5YKRL1WRLCIEBZRPMONKJ8ZB10MCWHP36GE0RGGK45CCHPXYQVSX1N568JZVOT5DWOI4V17FICQN6X3MCXVAZ2	1
591	B09BUMIAAB	TLI1IQU5KA9P2H2DZYMOY6RALPNS085O4MYTN9YZYGGN6IAEKU6LNNNW3HQ3DBELFUVPSJ009X0S0EDDOIIGCTBQ9BZFT5VWB4HM	6
591	SMUHZ6ZLPE	UWA4FM0W56YENO438JWTEQQUUGDBEQ571Q3WHL6GL3EFABGR12DUV2SEFQJ9IYSPA1M7VIVWNPIKLLTTAWJMMLL97ZQ1C77WLZEI	7
591	UIXWT83ZC0	I6TGQHFTH246Z8WOGCZQN9514UQSW9WGL5100F6DGP06V4M8LHFXO2KJA1L60X7IGXU4G6YAGVJ8J9G9HRGP391TVS0839NTSS07	3
591	G6YJUIUX8N	S1PSER2SLAAVMYJQROG6BJYFZHGI0Q1JIZZZ16YS9AJRZNRLDDADTBIIDJ37KU25J1NW8TYVZY6BAHQMZ5EWPX0GRQWSD1HOINH8	1
591	4T71U0G3GP	4MUOPN4EHI52RHPPFPWBGES6GS8RS3W9SM4TUIAJ5BKI0ZWT19C7V7304XH7PMWOV6KEN657PMFE4JGR5PZS0ZNVSEY6BD3SP6W4	4
591	5ZJ4TJAB4I	RF5EFSJ1Y5URZBAXEX6SYWIH86LSWZ8WLCOJ4OVHE34IEPLC35LI0LZ57XFJG0F977FWW12ZBZO519DSUJZ0OZ6AMSLGIMANY5LG	3
612	N7ZLC5KXCJ	YPCDVGA64D7UXY6BOUHBFJEPVRZYBH6X6I64XX3S5DSPOWVYEMJKEFEOLWRDRM5XGJYO1BO11YFB1YB95AUZ7WT1ESTAFZATI5IE	9
612	98DH79U5RR	H7C8RSP9DWWVRHR1GZU07JJSNVCXW36P7BYDS0PDE1A56PXRT1CFYOA7XTU6Q1MK0GXPTNJPKQVFINV78VE5011SB1P8GTXMO0F0	7
612	LMV5KHMJIQ	H7GSW5I25YK8W75XRT9PEO27KI03I0SI5G0X7ND6S0FCFATV2Z7HGKW3FIHOEPTEGCCQHHZEPD7OIZ2JZEAT3LCUT6RYFZ1DGB6C	9
612	BKEZFGXSRI	DNU921DNIUPQ7Y9OAL5AR6LZA8ZL3HH3ZMW1PTAT8HLMCIIB1YGZACQGC583C1TAMW0VCI8QLMBKV8X10YTEAR3X6QYUVGRHXK9Q	5
612	PIW2O1HZHS	W8S00OYBFUEHGCNHOA42CZWUN4E44WL8HJEZAOJDEW05UNODD9IJEXP7M8M5K3HSIFA78YHA01YQ80AAQA14OB3U3HNCCO3KPHXO	4
612	LRYG3OO7V2	RFP2ITN898V8LPJCMEGLQE1KF7M8NB1DVX95MCFSQV3I1E19TICDQD6MNEXLHPV8HSMXPO0J8Y45KSTAGMOF8XWS1WRHP4KA95BI	7
612	0I32H8MU6T	DTFS3E1IBC4UWF4BQ9T54536S4EN35PRKJC3IWFT5J0UXW3ZQ9T5SM7HZJ99ANOFWNKMCA234AAUFIJ5AO74LT97M4D8XGSR5U7J	4
612	98YTCMB2VA	QWPG0ARMMCRAE8VQU3DOMAI74GYRTZUK9TU2SXVSRV91W8SH6AK045APOSMUL92WRGAVN387IU70AQK5XQUSO3QESEOAKAGR2MKP	9
612	0IIQTWJMBK	74DCNSJ7JO7HR74PKHXZ6CIO8WHNQ8XG48ZWRPBLHGJZQ23DLCSFW0B5VYE1K5RL11MSHI74GMSZ2T8F3EBNPSUE63A2KKBLZ78Z	5
612	5KUMKKEHEX	K5DEX8KHLCC097G3D5IHHWOHFU6KHA5UIZTI8J2UJ7U18BLM5RVC0SIYR58CC9ALHSSKO754CY7KBXJEITPZP230Q51CKZSK6JTP	5
612	7FQKPIDC53	B88W09CU7X4W44SUL6OY13TG3TNGWO1D3VHVRDY31FSI7QQ59ZVNF11HP12GW68T502JW7DHHU7WLLJMDRG73O8C4AFZKRH5H9MG	6
612	I6JF0RW5IU	HJCWNFU3E6ESQDEZA0Q2ZPV1O7ZNCPL8CZ6IEKQJOIZEBG4ODFGI5O72XKIPPH1ZUFP0H6V0KHNRZR0HDLJ6ICCY1DU3CA3GQ9U5	7
612	5CPJU9L2PT	DHGTQ8YAQCGUAME74QRD19DL1XJOGAZ74Q9EDM2EOXKBOJBYYJWSC29ED422ZJ3QMJZUMA4RYNYDYC7SWVZ7OG4CR5AIUAOF34YE	5
612	8P3KYCP9C1	RLYPE4ZD5QB7KFET6CGPXCR9W7X8TJ3N28EJBRJME8WP8LK4KV72SZ6O4Y3HG1UVWXELA4RO23KYQCALW3X7MA5DC0ONYCFMOA2K	2
612	B09BUMIAAB	83PDSAYOH72XSUNEWIV2AJKPE0ZY8KQJZEX9H44AGY42WZFS2I11GSFZSA92KAQ6RS7O6N62OVWMOS3OUG5ZTYDH88QH5CZGI8LD	8
612	SMUHZ6ZLPE	1VPM9NV63LAGUHDE0N3PZP86Y6M5PEPGZW2VQNTLRLFWPBK4VBRURYCMXSXCA0QZ53Q8OSXN3R7OKLQXVRJNW4ZBTQ770QK15P1W	6
612	UIXWT83ZC0	MQCOE190YBLC9QSQCCAEPO7V0WMHGT4U4DJBG9SDZL5PW50A2L2N1RF8SRXRO2UEG1I5HQJCT6PESS846MO50R3N8KTYLBZ600I5	6
612	G6YJUIUX8N	52LBZ34BBPAS3VCNZOZ75767U0SHSN2JDHBTD3AX8L75TFSQXSBMT7275OQ8KXSXX0PVUSK5NB8TABOOICU9LPZGPDXZNCML2JH2	7
612	4T71U0G3GP	65EIG8S8I74AB0ICTLHAIGQ4VRLYX104VYLGP1FQHHHF3ZMLEIJ791R0PKXYX3LQHAOMPBX1G03B8KB5E9TOS244GU1EDQ3N6083	3
612	5ZJ4TJAB4I	96DVR1J7Q1EJ1TXK78PGUG4JSYZ7PEIMHVFDQ2AAU6Z2X5L6FD91TX03B3C3BLSMT1BGOU3E8OVXQBVWM31MEQ3U4MBW0H8JONJ6	8
632	N7ZLC5KXCJ	FSVJ53ECCMAHPQITGHC8QLCSGN0PLJD1Z2HKGCJXYS29BPK00ZIGH7O3QDDRCZ02JIRXJ7ND8PK7TCQ1DAZWB6U2NN4D91U82902	9
632	98DH79U5RR	XQ2MEI1XQJNWLOC9E0MYZJ6CKEG4LFULY4PU7J7Y2E7EQQYNS8YIOEHOUZC9B7LLZC8Q8RC43X5VM1V3Q2MMQL7UXB9IH8W52VOO	5
632	LMV5KHMJIQ	HPA64P0IWC2DITJU95OEO27S4W4AA20NHKINLQW5HLB9HE8PNK309KEOSSBHVZH3LO67K6ITIT7C17KZXPX09AN7G343OPKRDHX2	3
632	BKEZFGXSRI	AEQBKRQMBXUHLTFCR4KB91QBPE3JQ8TKSRWLGYYS7UEGKVC5EOWNM1JJYPWFYG6DEKZ46363F2DOWK13C7ECMF70HNW1CS40YBBA	8
632	PIW2O1HZHS	H9LS3HUX4WOX2D1B418N8WSHE0W7M0VI07473UT8MDN1IDKPCY4JCX7VQDNCUWKEAF74J3IKIAA5J18BQH4Y6LFDAJRZGQNZ2I0C	2
632	LRYG3OO7V2	PGJQUBCWBLYELVN1WIZA339MSD1XLCAB64ABVHMJDR972U5597GABCNWG78QKOK9KXIQUMGP5P6L4BT7H6XO6AA4RO4YJ59YHAXF	4
632	0I32H8MU6T	OKX01EWFB2ENAIO05CKWO9FSRFAPHE4ONV3VAXF5OYQWZKIWV8L7MT8PEFJVEG77709PP20I7PIZST2H7O4J26C4WOQ4OT1H1SY9	3
632	98YTCMB2VA	3H2HC97KI6VMCY0MXEAYF2AM54OYA8A535DGCB07FUOR5SM5B5DOXKFAGPMIVJJJ60TGUTKVODSUOSRNRSWF5VHS0DAWZRL6KEVF	9
632	0IIQTWJMBK	GKRURAT2VWX891CWDNKSAQQTY661WKJ7LOLIFVOVX0ERMX00JJG0KW80386UD2FKM0WVP4QS9Z4JL9GAFGSNESWYPUOGY3R5V4EW	1
632	5KUMKKEHEX	FKO3X1V2ZP326O7J2G4E7F4PK4FH8YQ5T9A6DUQ0A6ZFUO2PUW3YJSD9P9S3VN4B88I6OAFIZDDBPZ45C0XM42VB6BQDBXEXCYGV	2
632	7FQKPIDC53	5BTQV8GPBT0FX050SGGNGAMUBGC8P91SIYGZD5J3OW4R08N6J7USAI95Y9OO6H9C2H68UGWW7M8UF54D3FZSPISAZLBEQ47HW2ZS	1
632	I6JF0RW5IU	OMDK7VXJPZ2ELV0RRXTZ6JIESFCP17NGMAO2VIRX41JWI9FJGZFEF2FFE811SIRSLW2KG76JF65EAV5SA3IB2JBT5JYXQZFVJ1LW	2
632	5CPJU9L2PT	4CI369J6AFSDJ1YAPZBVJP7JI2P0J5IKJMF09I5J1W4EGUH7QV3BJB7PF9UDTSWF6I36W8AH423WV3CYVSKYBHAIO0VAX20JAYH7	7
632	8P3KYCP9C1	KLSVWHRHL3L65RBI8EZHVR6MATCBTW7VE8LG1DOATAD6JD1KZBBTS0F2PFVCFQXZ6017F4Q5ZYYUO9D611LSUNCO3S1WSL4CMOAT	4
632	B09BUMIAAB	4E5UG43CUOQCYLNEFETXMEXD4MN3VI99UU7WQ7NSIMJEKU3AR8HJQ590R103Q9QLPRSEN0YH1AOA4S2JTMMXBZSYVGFYGTCI67Z3	1
632	SMUHZ6ZLPE	ZX0K9SQQ8589QKDX3KZ83SGV9AH7FE738I3ZVMBHBIWLGZ0J8VCX94IGQFK8KSK48FAIQNBQIR7V55OKK89UBJ3D9XJPCC7S72NB	7
632	UIXWT83ZC0	R3VTWOS7WKV0AYMT02YM7I3EVOFUOYDRNV3FNAP5KFMMYZBOV9G9YZ1I9R8HI8T8HDNP5GF0M3B16RP6N19PRD3Y4UF6CHWMWOEV	3
632	G6YJUIUX8N	WTO3QX5YAMSBB4R9EREKYVKBIXEHYERM4V0IUVAQ7A4IX5ANENS7ALWBJMU2SY954FGQDIOSQXMY0BONW1CKVUMT8Z9IAH8JA8OR	7
632	4T71U0G3GP	UJ689QM88KH8HG0WYKJ3WRNJGSIZDX2X7YCSFMVEAVAP1J2BHXMYEYBD5W2RHW5KRUBSEHQMYF2BR8S6ZHRPLDSIX8WTTE6NZZ8G	3
632	5ZJ4TJAB4I	K79G9A959V7E51AEP8NC25FV62UJOM19LYPJSJMDTMXNZOYM5JJ1UEPO2OJGPZQX473HM0WGWJSPI25SEHNFCAPGIARD9FX369S1	6
643	N7ZLC5KXCJ	Q9EXDEKV9G9S1BIMLU4SX8MJSHRVZTIJE7XHJS96EUJ4RUHDPRUOYJ8SX5E5WY6Q70O4NAC2V8NCZR18ANGI83V48FUOODJQY261	2
643	98DH79U5RR	M0PO22Z553FDF5JSYRDET5IQYOSZ7O6VA2XX03GB59DLOKIHA7AK2WWQR80OKA8R7UDNHV14LCIU27CNFKY9NV2NGHF1D205AVO3	2
643	LMV5KHMJIQ	5AOGF90NBYU6MI9L8DL10GAQ91TLNTGSIGKKK3HWC9ESU50T1TBSCBQY98GOPOARRCYF8YBF5YZ0CR5EA9U4SYPG0VLLW3GY8WBS	2
643	BKEZFGXSRI	VVCR6WNMZWRDCOQ3G93WRPMNZSCSB1PQM7OOSMWCC4A93IUO042XI6ZGIY1NT5K7GB0E9BK3N0UXONUQ8X1G92HPHIF4UISGTC21	5
643	PIW2O1HZHS	PPYT9JRMC14EKP5DE8O3K705QIEINDMV28SICW9S0DERLZK3WCPDN7HSY2D1EJ99OJLM7XBR96DH2IU18LVLYIH409UJTHNRDFDB	4
643	LRYG3OO7V2	769B7ER49ZPIM33XYKGCRV7C171SWDWFTNAPWJ0DZA0JEBHOT4P4696L86JAN8I6DJY82OBOUCMR4X7Z0M81X2JUQZQZ900014G5	4
643	0I32H8MU6T	IWF2BK4WPQL9TJAAQILAESD7MO4MVZARCMS029WSP7BIF0QQZ0LW54I0TIQXPRAZQ36H1KHRW3VGQ51W8NW5ONVHD2GUS8C77L1L	8
643	98YTCMB2VA	IZPT39CJCJXQ4YB5FLCIYD9DW9X0YJFDQ2ZYHMUNT8BSTEXJAB19YDEF0L64MLV3DTAC9NY30YZ0BQUSLNZWRFPMXT75P0BHMIP9	2
643	0IIQTWJMBK	VKWM8I9NOEJ0OT9W8L7EXOQP2NAXSN3BVNZDDJT6P8JPXFAGBVN7R4RH3GUUIM5AKIFB46SZ1AYYFA1XN3V7A6T06SJ6Z8YDDIEP	9
643	5KUMKKEHEX	9MFCYFRG3B3O6HO08AOZOELXW93LUU66MXNRP4L0CUDQPR21KNEIZZV4ASPZMFVIF6BI37KDYXX3B5HEGBBHQXGXCSQ7PWO694KS	4
643	7FQKPIDC53	T8NCATCC13ELLSKDN1R0OGKQNYCI04GVYYWDYEQDEUKZMWDEE3VC22ANX6ZLR3L7WTWW5HOJLOW45VE0U8E7IE26YJP1OEWKJNC2	9
643	I6JF0RW5IU	RI6OM1OFGRB290TYOYS108V1W4H1LUSSL1DZHS6NN0R1O9PNCW4YUAITXF1STW3V9TQHX4Q52FO9Q4NXO3ZZ047LSTCC0O307524	5
643	5CPJU9L2PT	I0IF95PWJD22DD07E5FVFZD2OEOLXCVCSFGDQT18SYJQJKXKD229WJMSWQ14RD9GRZJ87WRUEHCRQXSERDI4JVPI3YQA26QPZC8T	1
643	8P3KYCP9C1	ZNQLI4PG5C87WMN5E66KBEJGR1H0X2NZ8E201TB0AB8VSCFUDTUGCJ8UEK3QWZTCYJ8STXDU5FK9GXYOWXWDHHXZFIWRZUEKS57I	1
643	B09BUMIAAB	WAQQ9K699NRWO49CP4RWJNLAV4LB9QKZPL9WGWH60ZF4F5KZEHDAQW3JYP5F95ATC1GD5M62WU5UHR50UV61MKJ2SZ701C65ZW1N	7
643	SMUHZ6ZLPE	H32LLN50JBHTFUN8IG2RNVFOFAUX94V0SBM1EPB6OCIY0HWRT6QP86KWYNGK3H0OQRBDIW42F6CLMRY7OCEDNF1V10D0J0CGL3II	2
643	UIXWT83ZC0	TJ6CYKB38JHYI61DXBKZQLRTDTO46ATIP252HAZ4Z12R5BB4KDX27TZH2N8E6H77Z8JQA95XLP9YTAXBSTT2N1L6CYA4BV8S3517	8
643	G6YJUIUX8N	U3KHAQRTAX207WNXEU8XMNM9BV0RR4XIZI7ZJUNK3NBAHDE8U4ZK2KQHRLGO0ABG9TAYZXOTGY38LM17Q16WFNPP2ZI8O8U2M5AY	1
643	4T71U0G3GP	QJ7QFEEQS6ETJ78DPAWEV69PQFIEBWPMD3AS9F9IL9K3DOEBVZ64NUSTKRA969P5Q2QP6QEJAN3VWFLBBGSMZV8TLRHRFAMLTONL	9
643	5ZJ4TJAB4I	YEFUX39167EG98ZRDF536DPIWEABRBH19DMCN1C192PTCLGCX4QISSBUY68T38J40MH6VWDLDD3EY6FL88NXV8JRB2NR3S7BSV30	2
644	N7ZLC5KXCJ	JQB0EEOY6621WV5UVJ1DZ43IWSVF2VDDPHYRM6Q342E5VZG7CQ7LBWOPX2EVTI6K2ZLP6NIY27I7Z7X6MXCLY1B23I4T24KV63D6	4
644	98DH79U5RR	1AZHISDNQZZFIJ6GUWAXSVYTY68XXB640RVWNEQI7PMTEOUUNPLHCJ5FMGTMUQ0P35O0YJ2QG1ZDJEOKMNJHZY1RVPJHUEYRY7ZI	9
644	LMV5KHMJIQ	36EX5BKT26H1J9GGTZED7EI9V5CDHPMPFKSRFU4XR73TCPLESKFHUFCZXEBA8HLNT2W9QYB85RW9KY7GT7U7KE4AH33AS3YKVQ9J	8
644	BKEZFGXSRI	MX3JGLDSDO9H5QBWOCP8W1X5BQB2MN4YYNGJ0YD20RDP43XNXXHNUKGUA8H0KKFZUKSRJ1509WHEYHAH2YFZGQENHWJ1QNSPMN5T	3
644	PIW2O1HZHS	FD61QO7CC627A7WFQTDGFKXSEKVE21KMR7WUJ7ZCGKEZQ3QQ6J541NF5PNXG33KKWQQDKB6T3B94G8CK4FIS6PUD11F5KTJNA3CA	4
644	LRYG3OO7V2	NF4NMB0NKZRLMMYU2NG5MLT6AIJ1W4M5B7Q9NEUO40QCYT7HV2IP5EABW8MD180QMVJP5YGX32AW4QIRLCG4W6977PNP2RX59AZC	3
644	0I32H8MU6T	SM6VVWDDNHG052Y164QWMSPL14LFFX40FG30KIBJ63TIHY6Z8DCFJQ796V30K88ZMPUY87RY3GZT8HED8WGBVYRZJ34YPK974451	1
644	98YTCMB2VA	I0AWOMC0NBYR02Y16EY85PFD2JSH2YEMM9Z6FPGLO851GHYSKG8ZG3H2U73F458Z7LE0C2VQ7NU6TO7UU96V0OFT16LIVBQSAG34	1
644	0IIQTWJMBK	7QSUR13JLJGAJU58M8TFV8FQN466B6NUCRWTNBIWMKQXEIMQVTYHKZR9LBGW57HP6W718LUK063LSRMFSPKRHFJNAXIM4W0OCB1S	3
644	5KUMKKEHEX	VSJ9NRN5GR3ZBEQWZH0MU0KDIPDGOIQ03466AS3Y5S4GOW3RJ1M4AF04HF08NHQ7AC6HITWHNBQC6EZWWV6X5WZYDBZ525KYB6FM	7
644	7FQKPIDC53	WJ0FFQ9YY8DQDL1L3COMIDG41PR02A98N6AMGRZF09PDVOYUTMI419RSD5O08I6X8EDHLPFLMIWIXDJM07HP2FHOORILD9GSC2ER	3
644	I6JF0RW5IU	RIDH6STMJ5AWB9BAQ537Z24H4IMBDG581BJZEH5WYBFVIYB9FSW7LUVYO6NYFRJCAC4A0M6I9GIYXI8FHN5VU7XGPVLH4HQG1CVG	8
644	5CPJU9L2PT	AJ3WN8EL7BF7IR2VXSCOXVEBYO10C6UW2KGEC9H9S5RUFJV0YUETT1GPE178GOIBQSF7KXSYLC62DU5O2BBS2ADBE19KBI3EWQDX	2
644	8P3KYCP9C1	YQABPIQ4NMU6SFFN0JPOD2TYIWDI2GWQIKDUAQM2WG0POOTCY15HYIA57M32EHCHZEXIBUMK6W27BDJ3DAUAKP19JHXYWUYODT0K	7
644	B09BUMIAAB	KADOUKBQD43C9YEXC6JMX936YXM8N3SN9D39RWZF0TFN4VX5T1BWQ8CKGGZ78CDJLPC65EFPGEWE3PCCAQPV267BAS2K72GXQ6CO	5
644	SMUHZ6ZLPE	0APVWPMM8Q0EW6RXRRPSB5ML5SN78X7NXTKQ99GQUZCBCGK6Y99OX6R4XD0EBONKSNQCWBXRK97M3KJYHRI9YT01CP36ICOFM2SY	7
644	UIXWT83ZC0	IJXLRDY9FAM3C6UGNW9XZAGI1IIU19B2U89HUXGPB26PQCGF498FSBAHDPTI5DHF9UJD7MVZPUV7D11YBD02B5JT71EFD7U8U0P6	8
644	G6YJUIUX8N	DHRNI08PDEMX4H1MPEELZFGHQVRAXMML5585JO3EKE3W2RI02WFWLVE7BK7WJ8211A29I6DBL9AUMTP9M0HBH0AK1A49QG5MMC51	7
644	4T71U0G3GP	JR6SELLUTVR48JS01UBASIICEUEEXIJYXKDJLSDOYZHPMES6MWUS31GBJ4OTGH7KL3GYGJOJQXL2A2Z9CI1AY146DB9RDTHQ27ES	9
644	5ZJ4TJAB4I	30DHLBGQOBREPR8Q6WT9KVEK7F7P4ACXHBISX3M0XPYARNYCIA5LUSXIV3KGE1VN836NJQ2DK3M46D2UR5G4E1CYN964SGV54LCY	5
665	N7ZLC5KXCJ	K22H2A1G3MSB0YJU1JG0HAJU8UEHQAVBDDGCOWM0LSTXO22RMLCB57JJTHII6TZ31Q7WSHFE7QPZQWGG1X5F7TFG46THOD422057	8
665	98DH79U5RR	F8FF8EPST36BCQJXU6IK12VY803VX601IKVY099O0XKDWFMXUEI4XWENNQHIL35XCF314V7V63UDRRB3NGBSY6DVGIKJ21D62XBR	4
665	LMV5KHMJIQ	U29GX73CB55PO4F2M9FBHVWKX2F0XK4QUQ3NCLA9JTEMP4O67EPX5PE8FYT41DO0AO57A10A8G1XQJ43OI2S5GVEM4IN2GHGEOMA	9
665	BKEZFGXSRI	Q6GOOZYYRS63ZPSL55431VGTMH28VSC7447MVEQR6Q4MLTC0Z4JTSHH5ZXCG7ZC8Q895SFZ1OM6K03H3FCJ0JSPXWCW8BJUHN66N	6
665	PIW2O1HZHS	HITFREFK6F6PJB5QLY7TMIQT0ZF2Z7374I73ZV2NKM060T2HY0CI84H91AO19MV9M8VAEB0Z5UJAST2H67D84U9AB7BZHAN700U2	9
665	LRYG3OO7V2	2DXAMMNUHRIIH4CJXE18V8G9AS4GLJ18AJD4P7SIVP3Q3R9GKYDV33N46Y93RHI8ZJH80I3ZWSNFF0FTTY6XFGFH6J717Z0OG51T	3
665	0I32H8MU6T	BPC5N9KPHYFSQK3LV2TEACQKB16289K9WJRJ321G41YV2IRP7DUCHPI9813WCSQHOG6G2TR3BMJJN5S2KR45OH1GASKC8FEMKQGV	4
665	98YTCMB2VA	KWNW1B5G9WCIALUXV3GP0FKIO45I696Z7Q95RJWG6AB5I373TZYXAGWFMEH7FWJ90NLUMZGMG9S0DOAU6BYHKJZ034TMBZBJ0BF5	5
665	0IIQTWJMBK	NR4TMQAX6B7EWAD7BZQYU0RG3KR8J9CJFCTT4Y72YC73VIOY7LZMYG7W9YZB8CO69Y8URTDM1Y9R2YUV63A7J0U8F7TG963WYB47	3
665	5KUMKKEHEX	4GNIMUAHP3LEEFFBRWID9PU96N54M314WLCWXY7FU1ZDIC40YVGOV3JPWNL8ZF4WBQR2DSN2ZDTIZQ14SEG1WNJ2CWAJN8QO6DB2	6
665	7FQKPIDC53	CXFHOZRKBZFWQQU9D9YGY0QSEP0WFMWO8JQQATIY1SB74W6S5P3ENV6LHXC985EYD0XG9E9T0APFZTYRSI1ZTRBNNEJMQJZ6NM3D	9
665	I6JF0RW5IU	0S1QJNMG0WX9VR0EPFVZK354WCRKT1N0US2Z9JJEYHWRVN52928GHNY6X74G5CW9J7OCYBEF6RADGNIIHZL02HSG45BCPCIWUXIY	9
665	5CPJU9L2PT	3D7X3K0NV0KYV9G06GCOHH39C03INSTETINWND9723JE1N3DB6YQGJ2VJ8UCQRACHFEMWUM2HEWN8ZIZ60HR4C7KQ1MPT6QL3G7V	3
665	8P3KYCP9C1	RRRT6JBXOXUZ5G0JSIEI464H7JKYKU11WQPJZ7835WCE2ZX0ZBK82NOUWJVW8NM352CO0RUVKKMH30PHVT8JJ39JC4WPLL4SKII9	6
665	B09BUMIAAB	I9IRZYRBG164OBPODUC33M64EJ8Q37VRPVMU02UFRI5D0V7KPEHYGG35DNMPZBHJFOP2Y4YK96MVR2ESLYBZ07LI2QRMPFQPAW7L	2
665	SMUHZ6ZLPE	EWUP6ZJ4HOKJ4DBASSICGAHNM54Q6U442MGCQJ4IBOUBGDVBOPSDZIAEOHDB427XUPQS69TIYAB1QFGIJ3BQC0FTLCXJG3NJQ7R1	6
665	UIXWT83ZC0	DEP5KPZHIXJA41B0QU3J6G4LKB5W1LTXPWGYWV1LQMCOOJLBLS9MYR06KDUITCP7EVUIUNE53R3UDP7B03LJLG985JNSAT1O6FJ2	7
665	G6YJUIUX8N	CR8NETGXF35GTS01FW8WWMK9W4J0PY8FFMXLM6GX3K0QSMRABX0SLGB0H91JJQIR5ZAG5OOJPK3MW3QJNJY27P38L7ENF7NMCIV2	3
665	4T71U0G3GP	KFXIQDANZDNSR5A1PUQ6C58JAES7QKOIX8DDATQL2VV304XBNUWYF6JPHNIMVD6PZF4T2616DEEQJESFRQT5XZD1YY6XLEZYYGEV	9
665	5ZJ4TJAB4I	DJR30VA23FC5C5FUB19CD4E9EU8OP1DA6FNHCB7EC95S32IJUEXOET6JERZFWWMBBC86R8R944AE9VGLMZ3KEZ6NJECVM1SPW4R1	8
685	N7ZLC5KXCJ	L1WXYTJT2JTKN372B7LGUXN55XDMURFDPRA7HXQGW3Q4TK87UXV6FVJYN11AQ69LEP5539VOQFT0HTMUYF166I84IMUP6PZZ4F0D	4
685	98DH79U5RR	CEVCGQ9BSR4OGMKFCP5QBXRPFSBQ36B2IFVBG4Z282Z5ZBZCPU104WNPWF6YOTHWPBFA0J9I0DSJ7WZE28AJEL8V2GOA7ANOUDPY	8
685	LMV5KHMJIQ	YMGVTA0EESAP26QS8SEDUIU48LZZDY4GBIEW4XVLHRXXNUEE75VVLVLP1LWHKABQY4OU23YK635CV6QOGV2HCI4Q7Y4TBNAGQH9T	2
685	BKEZFGXSRI	ULDHLYSZI445IBYI3NP97WD9FJT2YWO76IVJZ91UM1Z4AY2LL8W3UTI8HECBFZAVP78AQPT3W5XG7J9RQHR0AUNN9XBU7ZOW0DOC	7
685	PIW2O1HZHS	256P2GY6CB7EVU8IKV5TVA2N866QBQ3561XLULHNYQ7WEPLEQNPSTSE1DTQ6KI5WHCI46WY9NR5EDGJSU2AYAKMNW5IB4LDQVKOB	2
685	LRYG3OO7V2	RH3ZQFCXAY7K8LSIGV7Z5IAOWECNPS21HLDUG9TFKZVHK16AVIOZRMMJGOCLCYIR5FCXH7BHB2OFW3D5IC1HEDK484N26HCVREME	7
685	0I32H8MU6T	J2XGGXZ8HWNKHDA7BN25IYMUIL4Z2XSR8G9JDA7QV61H9RZEBYQ0UJQUPD8539FTE6LAE13BPLKL6FV1VZXEH16ZZO3ACBXV1IDC	2
685	98YTCMB2VA	YAK4OKI8EYKSGJDLBLM9WKZ739OYYUYBSW7ZNJ2RY1V0SS51TKZ61DSNKMBP6TJU9J9UMN81T5K5Z9PLDWFO42KODTOAINUFRA0J	5
685	0IIQTWJMBK	LOFL7N52XXL70MKO5ZH8UQ397TGKFOZIF21H9C6POWP5DCSBK1WLTK74VGNOHUWJ8D27UCO222U8B865BFAO1OZ457W2ZSH39G6A	3
685	5KUMKKEHEX	UQHM4S0093WKSNCUIRUN7CXQWDKU084B6UQY2C758E5D9SGFFJ1YLWNS31Z1IG9A8UO86N1FUZP2GTQD6EORGG0JH74BMGW2E5EO	2
685	7FQKPIDC53	II2RVEWHULJKW4D1S324E08T03NCXXLPB9Y6W9VCDCXWV00MTAWBMU9RJI120UT6A3JWFHFSIZ1BDM89DBTXBJDR9HWNH3LTT0V1	5
685	I6JF0RW5IU	DGL4D3W38O7K1YZA65002W8V1KONHSM0HS94I27QRYB2YCQEWSW55AZQHZC2OIVQBGDJZ42E7JJEVF6Z4K1Y6R5G3SXS0FCICU1S	9
685	5CPJU9L2PT	GP20S8V1V5C2N7DR6UUK7PGHKO2HABAOOZY588NSKOIXV0MH81FAHHC0IVPDGO1T4XNXJIS7GBASHTVUBUII5AHGX7XMSKM5XY37	4
685	8P3KYCP9C1	Y80JH4FHTTY95CVGSX3QHALVFO6YE4S0YHMWS9YFB9DO8NXH0ZFB9RFYWED28QCZA8LYZ9XT9YOH67W21Y7OZR0HCYAN65HU7ONA	1
685	B09BUMIAAB	9S1BVBLC71YSKAKTX9THEVA8KWEQ4JSTW02FFNDPPEE6L4V46BKO427NR31874IYJE5UHENK6D29QDWPBJU29EZ42PXMVESU6QXH	9
685	SMUHZ6ZLPE	BW2Y9R0987NGL7XKPYFPB12RAY1VHD9QPQAX1EAW844SJGKH4KQ2S27K3KXL0F1577047ASKYSQH6KH3NU07WH7XT03RQY62C9UM	5
685	UIXWT83ZC0	QK41GE9LZNTD47FP3IZ9DKGGB39WXE7Z5N7K5GQD8L3MKOW00NI05MMFDY0MENYUP3HQA5TX2WB2R45XGI5K6H4TA2HHQD9UXI7R	2
685	G6YJUIUX8N	F054U7JKTYJ3CF5RNYI8YPIXMHZWQFI6OQBSAPLJVIRD8ON7DDJUYSRZSHSNHW4OPMOVEMR8N9NQ8EZ741SN5YI58LA278B8NCYW	9
685	4T71U0G3GP	130WLHZEB1NSUTQDQS1DTX3MYAO7PC6QD8C821URT17UWJNOV57T6SQEAO7L22Z846PVQSLZ8KT1ZIZOWALUFNTUS87N4JZ1C8ZZ	8
685	5ZJ4TJAB4I	18DTHVW8YO1YSY1QE3RN5DRU75YV2Z0T9U5BIA717V3TGZLV7L7FIM8YQTWM7BG8XIY730IE5ZPKJ8OITCYR2VKXVGVZOV46O568	1
686	N7ZLC5KXCJ	N2HC2JS7YOSFO24NYGB7BLWET0K5T5OCQHFKQO9M2Z71DU929TZZ4A8BFCTC8WN2AQYGWT6KGZFLO4B80S5AFZIPIEEO47NFME1X	8
686	98DH79U5RR	3FQXPSE4WXLBUMQ1NXLIJ7SPRPJMA9JDOD6NPM0GDUVQ3NKV7O8RPPV5WAF9J24XNIXRPCLA7EEYMCWEFXOWB2X9SB1OH07LZ8CU	7
686	LMV5KHMJIQ	2F4C7UKK7TTOA4VNIWVUY9NL73GH38NABOMRUTDIMYVSH9G5L7QMRAB32SFENDR8FTNWSD2ZSMH9O4E7XK55SBSBNSZBO94JHWNY	6
686	BKEZFGXSRI	UNIF13E2CP7OHQCHWQEAMI9N1KTS821RPKD7X00HOILC1XHS2CVGIXKLO4ORKW4JYP86NFT6Z6VD76WDDB06HUI2A1S3LI72OBNM	7
686	PIW2O1HZHS	KEWSZRMBGNRIKOI68CEGG6WW0UR93Y6TJP36DNSC603NBVB4Y6Q8JFSNS92E9MISR884VM2UUBJPDIVESXK6I7KE7PNDUNDTSL6D	6
686	LRYG3OO7V2	HJME5OH5CJKOYWMCMKUY37F8YAG8072MSRLN82MSCJ4GDZ600RGBMO3KENP5HIFFR85GL8DT7BVUC948EQHI119DYAJVMRL3EZYF	8
686	0I32H8MU6T	ZP1NWDK3JIFSQ11A6N082SKZSHQ01PMKYEOAQ4FXZKO2EC6ZT3HM8HBHEC4PWUB3643LM0UBICISDSUQK0G8IAMRDG6N90BEIV6K	3
686	98YTCMB2VA	UN3IFD68TEWSOE6ODU6SMIG4GBSBEJRVKIZNM0C6QSTCJ5VVEZEAA15MG8BEV44KWAHGOSBNS9C4ZDULQ66OFQVSMNGOY8LVYJPJ	6
686	0IIQTWJMBK	PGVY1SAZBWCO0XY8PEGPZ3BMXYUYQFQYLXB0K0N8U2L0D98KXXIEI48VFJBC8MJ5GODCW8XZ1I47SKIX0JB36LPRYPUAYL9HTPTZ	9
686	5KUMKKEHEX	5YZ9TMA9BC4BNLZLP848WOGNXAQIWND0T05VL4N9PRXNZ9L9K6DQZ1KRRLMS62MX9ESWQD9VU5TE03XXZQ70KWB1QODAR5CWE9NV	5
686	7FQKPIDC53	YTG6R53HG0XYY2P4WMMC0GB99DZ3690QBGA70331IUKYQM3CW1SXAT0SRH7NGALG9HWR1SE3SV3G5NTXKXGERDPSPSQT5QVIIEYI	7
686	I6JF0RW5IU	LKEXZEPZUWEXKCT3GZ62DBJBU7CAV71YL78MBR28A255L6VNBOCO2QWJBCC1BOEX4PMNDG2Y772LGN0YMZ8H4M54KZK8OA7VYIB5	6
686	5CPJU9L2PT	HJ5WOR5YLCYMOPMP72SURCO53J6AGW8M4EEPDUQ5AG9WWWAVUF0PSLCE593EV5RYELRJK6MMMWTKD1JGJLPA5S3TBAUE1LKFYKRK	2
686	8P3KYCP9C1	0LY3OD622BD0W5JPR2WS8IJLIVAMNV2K8BSA1HRP70J8RNEQA0HS52GSBMV2CTOGI32UNJYJKGVH9L44QUMXNKOG598OVYMNMC0Y	6
686	B09BUMIAAB	TC0B7HYG8T0R1MRG128OWZNLJYW3H56UFI6RVVQCZ96QI74M5GVJ2J94ZP2JV58DWFMSQ9VFM5YW27CM3J8AKX25JC2G3GR4A34C	6
686	SMUHZ6ZLPE	M65VP77VMB1NQQL6828NQJOHOMFN4W8C91RNDO405K6AA3M0F7CA5ZECRYHD1T00DYNZ873T8ISFNNGV9PI6T7HJWO5PH09LUF7L	4
686	UIXWT83ZC0	X1HESCWH9ZERVELL3GFRDCUBOLIJGUHQ4FLXA2A5VCWY17VVXA0814MUHGZG3NBOSXWP2YLAFJ6BQ6KQ0WWF4IYA30Q3D4CIBHGE	3
686	G6YJUIUX8N	G29ZZ2S8KEL6IQG05UJ8WVBHR7LHY9IZFGT3XQEQGCSWF74N5RGX7FYU11I2QKKL5V0C6NDPQ21UCPCTD8MG3V29R9C5HM951H0T	2
686	4T71U0G3GP	1QRN0HEODRLZZYS8DRK30U7KIHD3625YSLLS43COXVOS0GSXR6YZP0QHSHFTDKRLWXGNN9EKP6FFGPUBZQM9DFI25D9XXTKMDC5D	9
686	5ZJ4TJAB4I	FJR2OKTULADXD3X8SHQOOSJ9RW6W2BDTQCUG4GZ5ZHTD6AUZXOU5PYUWASL2O72J7TGBJQDMRVZH8GDRBG8OQIE2R7GM57R2PKFM	8
742	N7ZLC5KXCJ	TPHLIN39NY3O40H8O2ZPOTMK0QUD72YA0XS01CI4K2DIM8AGJ3ARQ7P9D6U13ZBVA2YHHQHLU4EVPD72QN3E1HU3HSX4SQBV1SIT	3
742	98DH79U5RR	393VZ6V24U992LP5732I49Z2M2E3T464NSWOASBK9BN8X50EVZ3YPLP4JAJ611IAXFVJZA5P2RI3W1ERC9H4AHOBD2E9JETH2MKS	3
742	LMV5KHMJIQ	QPU3N68CVHS6132UO9P0TF665GX8BBJQWHVTXAWLQ9RUWDRL0XNN420LSY8HJ9BU8CKUII6OMEJUXMJ2YMIOX6V3QKA8CPBR77WU	8
742	BKEZFGXSRI	7CR09A0SGXGPFS71W7BQQD7H8L7D2W0ZZ81J0YX65KKX4T66EZL9VDM3FK1XDX0T6QZG0XB8KFVG3KNPPA8CK1EVV8EP692HU00O	8
742	PIW2O1HZHS	ZFQYNZPRGA46MICYXIELDU2TVBKMNVCT9VZ4SO7CZDP7JSU10T6RVCZEN6DMPCEV8K70SHGJLCWAF4JCQTW4ZU766URVLVWW9498	6
742	LRYG3OO7V2	4ISNXGTQZ8SXA56QJ5NNB380U8ZP9AL5LRWKERBOOQHV98K00FZ8WVUAK22ZQDQYXXLTJVM2498UWM0WX9Z3KNJZ7VALYM7L9S8M	6
742	0I32H8MU6T	0QF36DWW9O8BFBROWNJNWWYUAERBXVENOA6STAOJWD8HCKSKQ7MEZ8AE2V32WU9NJVWFE84W991SXQRZVGV0IAXQ91Z8HVXBDU7R	6
742	98YTCMB2VA	NGRC0EZGRRLDDHP9JFJ7GFMI6POL0ODTACIADXS67JSKN4EOIC4OYURH3IGKZOQCN2DB9O5VXN96XB4CLADYUZ5QUAG5RHGT3P7V	7
742	0IIQTWJMBK	DO4GI1LUUT1OE9ZK2SY7XQ8HAEPHPDIEJKIVIRL7U5ARPQMIQIB6JXDWQWGDMDERKXE31EBKG0N1PR2T1G0HCL4VGVFWKHVQ1TG1	4
742	5KUMKKEHEX	TRLG0ZSKMG94XMFM7O92SWF9PA9F7A6KBGIZOALVML4OG2X5PD3EH837LM100NMLKY2QDP76DNQH112XMDZ3G2DCNLOCJV488TER	9
742	7FQKPIDC53	H1AF6B3RVFTTDNWXSERV0C2A5XRSRIIXLYFMZYK1JU1F5SFHILPOW6IE99JJTK9M66IPIK744ZLFLWFNRKKG34AOPBM0PBI8VOJ8	3
742	I6JF0RW5IU	097OVU7VD2M351IA3TC54AG7GP3RMU6NGE1LN1IKD3LIA7TK9814HDO029HF0PIT68W197XCL12BY87J5TRO3BGDZBSNUCTXU2MC	3
742	5CPJU9L2PT	2KCKYTPKNB4C7KH73041TB7OJSJIEQ6V49DIPDES12LAYLW2LZ0CSK00NXAGJGF6FIH8G9SZVLA0Z7086R7OZ4DUIN52D7IUXO5P	1
742	8P3KYCP9C1	XVLHAQGKAAP6BK2J1HKFXZ2EZWYCPDLCK5I5VHYN6KINP5BWQL5HUKP72HRO1D46ZMWGC6YUS6JNRPY4VBWEHDS9PKDNZKW2PLXD	3
742	B09BUMIAAB	4UTWLZXBCQMTX20R0ZV4W013K4HKR7G1VV0QCR5O58M404BR5KZVCIWD30MQRMUFKV7CBJOI3H9YN7DQ3ZPGIUZM9WXMFO6SOHTE	9
742	SMUHZ6ZLPE	9QW6Q24J7Z5W5X17N705VCOVCDOLQJGN8T4J2J115DB72ZJ1EVAK3JL6BA4NNT3YTRYL3SEEF89RBR3M3XG4I5UYI7I1PNOMJNNK	1
742	UIXWT83ZC0	87WQ6E4J35THRUZM8PY79D5JMY2UXIYETL50TNM00OPCZU83Y9K7ZNB5BNEIMKVVGPXGY93VD7HUX3U1Z95Y70OGJAYGJDNP245J	9
742	G6YJUIUX8N	2EZFZ41FRHI2MSNO7XQAR6YLWL9T1137K574FSH6XA22PO7VAA5GPJP5POTO5HOZNLSRUSJOQUMRE55IONT06XSBQCP193APVCPE	9
742	4T71U0G3GP	QAS1R04670TSL9RYX302QASDRPWT75BQ1M7NA9O7XESL5IX3T07JYLPPSPKCDL9BZD19BEXYO3FMSGHI12AG721P6S4VYM3MFQW2	5
742	5ZJ4TJAB4I	Y2OCJ45GC7LHBKLL2D7LMCTJC9B93HBTO1CAVDY75I4VSOXCRAMMZQFWIEAJ25N5522KHLZYOAPDI81YM9R24Y47VQ1QDPE95800	6
767	N7ZLC5KXCJ	N4GLY7ZBCOKNM63NVBG74Y1TJU95PHJHAC9FLRF0E6TCRC1TLWK6T20YDXBD83V4ECMJ7XCD5P28FYCG3PU37MYIMLCXPC2LKZ7O	7
767	98DH79U5RR	RWXTGAD92SOV5JSI261OE6VVPY3XRXQ1XQM37K1MVIU2YBU2JCS2FAVUACDRHPSFCX7O7YLRFP25M36NEBOOEXVX4134GJEF0P0A	1
767	LMV5KHMJIQ	F4U1BX0HZIHFZNFBDAOBKUG5QK5KXF7D6J8G4XDA5PESWZQ59EWOL83UYYK01PTTKEJQO9GQ7OG5PXJ13ALTTT17QOSFMMJP5UIS	4
767	BKEZFGXSRI	ARA7GQ627EAPT61DAA1MM9ARBDVF195P0L3SLVNC5FSJRZ3PSL5UQGDBQT6C51A8JVYHDI2OWYRHQ19LKFXPEL8UI2C2ZLHDEU96	1
767	PIW2O1HZHS	VMJTQ72Z5UZTV10EV48WE8LGAYLRND61CKZ2N6XNG5NIMIETQ8S0BK6WBDT1VKL2X7QKC71ZGUPJVD31U2APUG02NC1JM525TUUP	7
767	LRYG3OO7V2	3QTH3TQ4XA8K2H2J6HRHY7AGRML1TZBSO90MRI0XJ80B29UYAVXMDHD6QNZRIYK89P62QQ2YR380H8NS1W17BYPG545ESJPUX1CN	1
767	0I32H8MU6T	1HT395JJNYS9GZV6M6LAZ7WUYFIONCP6AQ9PIEB3F7SFNEMT3XK41MM4V8E4X45KJW900GYI5S42OQHU3YU02UEXDE3JAGFKBH61	2
767	98YTCMB2VA	V3X8C9JRUPE1UB8KFSYRLXVMPIYMU1HUQPH571ZV5GTYZSPFHA6ZHJ38HLT4L673IULE4DNN2DVFD6W72TFT4SNGVIXVH5K8I0QF	2
767	0IIQTWJMBK	KLDXS6DYY5LYWB11O80HESVQ1G73W6NQR0RIB5MVJR7NM6V3SH4208B1ZX5M9KC2R5H6UTZSVE7XVID5UDLPBV0TYZSO9AW8PF5R	7
767	5KUMKKEHEX	ZJ8RMGVAOGQTA158W06EXH4ALSVR8HPNWF54N7YPETJSC49I0A2O9MBRO7F4UDBH1D645BVZCRAE8L8QTM18OANKENPQ244ARC19	9
767	7FQKPIDC53	ENYODMSL6TC8YKIMC30ZV0RWF7HW9X6T9SP9CUKX58H4MRDTWXOIAJMN5CJGE5MJXT9F5IKSSD3XSXJX3YALIXSZGBE9KESAW8H3	5
767	I6JF0RW5IU	7XNN507PZ4H3VNQ4AAAAJ94EKIOU3AUQQG5AX8N6VJRG6GZ0CGW7G3H83JCXMNWYK1MPRPHBXDOASYIESXSXOWJW87HO5ZUHW25E	8
767	5CPJU9L2PT	KJW8UKDOHQEA8EY59KYS0QTI3G7THNZ2DKIN5Y4LFI0RCN7U5LXSHWD3ZNFONTG40M7X6L9LQMMRZCFQIMY5ZGUQHOXSTP8WB600	4
767	8P3KYCP9C1	KYUMLC5KVDXIYGA5LEU1QQRXR2AN0Q3LPB7YETOEZGVLAJ4J8001G884G64TCRTEKL2XIL110QCK4GWH70P90BFRCDRHY4BHXQBZ	5
767	B09BUMIAAB	GBW88B05Y9AJXWLCTOIFLVE4UD6O4WNF700Z2B2APVOER7AH0FDC2TFV62O5FMBBV5M75WKSWI00HANWCYXZTLMOUE29W65CTMSV	6
767	SMUHZ6ZLPE	DME5UPU2PO6P13QYMRJS7M04K5ZNXG4R1B8MT3962WF05T5DOOH4IDX0VKUY0HEIUOY04EFSSN0LHA80AW8J99JXOH1JIKGVR6FR	8
767	UIXWT83ZC0	EJKIYM4NMSUL4XDI5JUFAMWM6KIHE3L4R55NYAKXOKBZG7OWCMWWVL42W7MODXITHZ4920T49710K7G85WF2GYJFAC00X5T1CSRQ	1
767	G6YJUIUX8N	P4L22WYUESY1OSRRQMSQZ8ZA3GDNAY2QZ6Q149NBVU6UB9JMCJVF8AMREL9VTKUP0ICRCZXR9Q4FBE8371L0CWRYT9WT92SK9Q43	9
767	4T71U0G3GP	1JMWEGSGHPAMFY194ND1O7DCDRG7UFUKF6FR9D8Q8SMTWG3E0KFD0BS3GJSW9UVC4ZHJSKA0PX25VTQ6YCGJ9QUENLKZULRO6JY7	9
767	5ZJ4TJAB4I	UVQKPYDIXIW2W86NMCOFD5H9KFDGO9M4T7DR09U1Q50DY68MUATHK16ZNQ9JV74X61JZ4PWNSWYHEELNG1VNQEU1AODKAKGTADH6	6
793	N7ZLC5KXCJ	JREOGYYDZUJEVD3LRH1HSYQLMNHPEGA7P06JQ9JP5XL34FOHNIT6PYFVB3B3RI8STMZ4GT4R7LM4NWQH8AC6WER1VLIX7Q8WZ2KS	4
793	98DH79U5RR	UA3NC8EMKHPM34QGC5O58I5LHTQMZEUM81O9JTUGMOKD3KEWSQX75XRLFRFSR2WGWCNCQQ6SKIST81S6P44JRXRLKC42NCYU2ER0	9
793	LMV5KHMJIQ	BFBTEWWE8MO9JCW8MY9VC1NWEFIU803K1ANZ30NB4HMZQ3EABVQQSF4K1OO8OCFHTEHJY7FVK705PXGLBISMKN1WFD7OMPX2BEGL	6
793	BKEZFGXSRI	4LEQ4FUO84DHC7GT27FMUDU90J5K84KR4ZG6O6PHHIHJ3GJRRIIHB9B11E0UKJQETWMM0JF6R7EM6LGT9N3ZVCP5YOEJF5771CZG	8
793	PIW2O1HZHS	71HDL0D4Y5Q8GU6Q1TQHRXLF51WAGV3V9ZCWWWJMMAATYL9KARATI9MJPBHUECXDB59QRK4EJE4RX2RU1LAZUKM9N3GUPZHJM7S2	4
793	LRYG3OO7V2	S2ZX5KEE5WXUX22C8S0S9CYDJZT6VEZKYHITKCYAH4SHT926OGOO1JNPDVNG0HS06M5PUJ1530KEURUJ7XSP0LSO43PZZSKAL1KG	2
793	0I32H8MU6T	MMFOSUA9I5WBDIDZDAV3RU03CGLQK22GNFUKNAH0SPW73XVKGLI1ZMX2VLMLJUYPCPY7X2MD24LB83AOUBJ8UBRAS2ZBX5Q70G4O	9
793	98YTCMB2VA	YWO9E84BV42L70IKZ5B7YP5CKP6NOL18VP6O49QCX977700FIWAL3QKI1MZYBQWKC3ZR33Q0O8JZR7EUZ1F1KQFEFYXRK1BHMX4D	1
793	0IIQTWJMBK	JLOGK64HV14HF8JK59WYUMFG8QW7CN4CBTQQ0UAUK7T62KF316QXIPQ6FHH3J6FI61GVS3UK9COW2IOYK3GF6H4WCTLSNGKN2LAB	1
793	5KUMKKEHEX	TK8MFYFA3E63TSP09MZ7UT8RB721A4RIMU1TH20TYVJPOZ3X5X29LDTALQLI5NA8WYQ916TGVGJ9JTDLDE6NCS7JA1H1RSXKUK2Z	3
793	7FQKPIDC53	469EVNE4U01M9E0QX6E1H8AY2ZDS8O91NDJI7JQE2OQAPOSO637NY8A56KM6KV5F0A964STOP982S9INGZWERVCPCNLX7U4GTKJP	4
793	I6JF0RW5IU	WTNKS7Y9IN6B8ZV90YF8T3QG6R5F2JHZ38UFI48XNP4APV84IG2WER52CGOBBTH8FHI9FP06ZRUE9Q1KSB6VRVVMD1CBP7V4I54H	4
793	5CPJU9L2PT	9Z3Q56W603WPDTAXVRUW55NMYQ26Z5DVT8SMDFVZ8PN8QWMNVHXNKVQELQ1PD0G5ZA5FAXTQ64YQSP6CEOKSI0L8RNAXNFVHISIQ	7
793	8P3KYCP9C1	GM7XGRP7AW6UZKYQYW9Z6YXW6C0JQHAGQK7CM5BI5BR1ECY571U5J04SZL0E0GQ2W0EONWD2U035G5S3N5MZXE7ZPOMBF7SZUYFO	9
793	B09BUMIAAB	JRKX2LS79L4360541FR3O98JCXWIDLS0D5ENBB43O1QCSIIGW53SXVUKSAVFYK4Y3DZBWR2ZKYOXT514OQVIS9DSK35AQZED71JO	5
793	SMUHZ6ZLPE	HTFCDH8G60WJ00IYWG3AG02W1IVUK01WMLG6QFO2EMODI1Z86PLVQOMQ1SK5WO5G9A6PULIQ1B53MZOASWX5OGG780F74TFZRHDH	8
793	UIXWT83ZC0	KOUH43OSSEBEKM9091248Q4GKWI5FMFVGFIHCYUM1PQVD2TGF9RPLN63UO6HUTMG8P8FE1YLHPDTAICSDCZG50K2IOXY1N1HCKWY	8
793	G6YJUIUX8N	NBNKFI5KM2MLOES3FKIEF60E9T3Y5Q0VOYZAL6ZSPS6VLMNJIO69OTYQLJKVOHO6C060OSRJV0ZWAE3WGUPRT1H59IYCVDDIEATU	5
793	4T71U0G3GP	W406XOX4BQGQYP317MLTB0G4PYRWQSAVIGT0YV6MTB82RW7YKQGXHBP6Y5R87ANSPVHR5DDMP8992NM212M9MMNH1XC3D8PSXPM6	4
793	5ZJ4TJAB4I	P3HN4IJBPDKSYHEYOGDHA0HAJIQSQMMBQNM9EWRDEFMT1KP1L4JJJYPZVGDW10VC1JCL4EU2Y9D4NXJ93ZHWCD128WO8S5MNUJ2S	2
794	N7ZLC5KXCJ	D6GJRUKVUL77E3BT89XRKNI0WJ3XZJE401Z3AMVSRGNLQAOCK4WJFB7ZXQXH1X6KGCGMDISVOF9DA6JV51N4X5ZZ39FUYN04KCEO	8
794	98DH79U5RR	B8BMA49B4Z1GCLAKBWLMRSDC76AOF2725132LRXAZX9JOOWC0UIP3BNT49PD4V6B28LLSH8U9KW3T4XTK8XUUR84OK8MCUGE17QP	1
794	LMV5KHMJIQ	LTTVYQSOTAAL5357LRLAQ6HJWRPESCVNIQ8OE96APP4J7AH1KGPQFPWOLK9HBO6ROXDP4R3MVKUBC8LVKY3LWFH24UC49Y9BTN5K	9
794	BKEZFGXSRI	163ND544UMN8O7NUU4JPKVJO9M6LTRZCBXS1A7SKM7JIY5V1VQ8SV4WGXPO08TLDXK60OWUWM9CNLBZD1EZDSGRGALDVT2L3WGVO	9
794	PIW2O1HZHS	4M95LGW1J5VZK943HUQ3ZZDS9DTYJ0FQLE610IGA5P0QS5J3QAOVEUJFJR5IW7STZFOGCCC9NQ8K9X9E30HJMTL041SJM8N76H0N	5
794	LRYG3OO7V2	C0O7OIYW8FWR1O60JGF3XLLU3XPCBO16WX1A3M7LXE6V62UTRHXBVU31P3D02WVUOZ4EX576I3GSPZYBD6U300KC4AV9IGSATMGG	9
794	0I32H8MU6T	Q5VK021NKMZFCX6B13YO1KXK7YCLF9CSRDWA8TA8TYTX53FSW82TS1GGHLMC0QILJGY9A5DH305D09OESTYGGTA07Q2XH7IDQIOZ	2
794	98YTCMB2VA	GR05VZ25CPI6ITG1CE0G7CUDP95S1WRVZ9MB8KV3H44AU09OBMOEYTHE7XQV4KEP8XHJHF31T68DHTTYAQQPIN6F1HDL39960OC7	5
794	0IIQTWJMBK	0H5SWU2UE6OD1VN3YHU0BR9CR7T6CM3QWFJJV6W2EVXLZHCOWDBHRGRIH3AYB5S1D8RWLDI1V2VQ4YMK5FK9KW8PXAB1571ID5H1	7
794	5KUMKKEHEX	PCS4KWZVBOTQ035VSQR9C9KBQ5XAMM9QVVQD1EAAJ4WWSLFD5XUO01WQ1QOO8YIYPC4FN24OQR0IMYTF0TFZ1UZ489LK0WBUV7HP	5
794	7FQKPIDC53	A0D3G8JBODD7IYOTS65NAGNRTY3PFWPQEZZ3B6VVQ2U6HMR7WBDAMCP3NVJSE361XX3T8VRWLJ6HWQKGG62ETPEBJ5QPWDQW62IU	5
794	I6JF0RW5IU	89BTQZCFIH6LCLIB1IIS1KCFBAH2KL3HZXH61UC0B5BYTDT1IVETAB1Y66SQSK57NYWPEMKHFRQ5IOV7QPUZGKHX6TA5BWI1AEK5	5
794	5CPJU9L2PT	EX6L6OSV5PSKU9C0G0DR8SVLOGSJZ5EDZQL1YNJ6YCADRURXFB4NHOTVCU605J5ALOUEXLB2RH35SR44Z5EYB16L60ZERSAOHA2D	9
794	8P3KYCP9C1	M939B5AVXDU0BBAEH8USJH7W7L8GOYRZ04M5KY9560JXENPQAK9BIU0ECHB073H9V49HZE3S9YWT8KRT5SGDYQRGDH2DXJ8CSKBK	4
794	B09BUMIAAB	I15RRCT8HG20R5OWDKFM3DRM0500TAYIHFW1LWHN8H6AAMFNTQP967VEJT0VM2PHSTSMIXKRC1OVHRLN0MHCUYMKURR25VBG2YSQ	8
794	SMUHZ6ZLPE	2F5F76ET972HM59UMW4HI20GSVR0H3S95T7GL7X1H0UTZVS0BVPCXIVAPZXMPOLFP3L383IP9C9RHGQ7C0YVNPLW861WJKL3POE6	3
794	UIXWT83ZC0	Z1IMADVJD3IJ0JYZZ2ARY4BBWFY0FC2CTXM8PINMZN5DSNTBXDZWDOV50G04O4DAAGZC6ZKROY2K98SJVXDCNG8FCRIJSS75K4CM	7
794	G6YJUIUX8N	RE73IHPWK51XRJ10AX4HTAORA8606AF5GUETGIF8TT1WQVBIGEJGIEEQZP2JLZZK05R6FHU1S6YAJ2AP7XT208XBQX30Q5X33Q5V	2
794	4T71U0G3GP	ED8USYLPEH6PNMXF7U2HPQRN3LWJ4G26PL2TVHHJMWLQ7LCT9Y66DNYYVU1GCCU7O9ABTDT0MS53EBQRICJGK63CWD8APBHJBOB7	3
794	5ZJ4TJAB4I	B95EGTVR5UUEK792OXSG8PQFTKKLW109SGHCOBEMIU1SN5FEHRW1S1NVT0V5IJ4D4UVDZ7ONSG8NX72XEGEFF8R02VTYPID8ZXY2	3
814	N7ZLC5KXCJ	BOKCIIM3A8V771BFZ75D4LEN07KC9XAJ9NC24C70E72X70SRB2AZ2ZP0K6MK8J3M7M8UYJLXAF87SQQ9P2AGXKQK8MS7ZW14DQZU	7
814	98DH79U5RR	722RMZW0SI4QN4FJWZX5YWM1N8NND3C05HSAIYKV4TPEYRM1WVQ0CZDLQBEOLIXYFDUFMFA8OCBEGID5VV1RMLXGDGUHU6JV618U	9
814	LMV5KHMJIQ	HPRVSMAX8FH8J2ZQFL3QOBGU3NR2PIOJS8OGK639XSFBMILDUE0PFESFI61F4II008PKOSGIS4366EIUCOILS9EOPI7OFYEOKOLO	8
814	BKEZFGXSRI	AZB8R7KLWJDYGCQ97I03B5GU1D3ZOVR331CZHMAC3D28409VYPNGUU2ESQGODV7B2J4OA12UHYA8DH0BEHA8IKJJ97G0FV8IF1GU	8
814	PIW2O1HZHS	UV7W285U4BLZFK6U82RAUPDUBPW012LBGFTWDMQMNZF54BALBXH8ZTKERMUNMF2BZKS90KRWMEW5KIZAPKYDUMLW5OE01C9I6DFU	5
814	LRYG3OO7V2	AV1GVWU7P4JWU7CRYQN85ELF04JEO8GCFSOY66901ZPU5EHE70IW2WW6KWQ0MPTQYHRBTNU1RWGGY1KVXEHX0UJT5ROJQINMG96Y	6
814	0I32H8MU6T	FVTFQEFPQISM5DII5ZD78GB9KLJJ49Y5W8RTXRKPEDPJ57UEFEKJ20Z9TU4E56UQTXZ6VZUOPY3401DN0ED0YPD5JS9CWFTHS90I	3
814	98YTCMB2VA	YSQT64D74I1RRN1331EU4XDZS1JFVL0B5ECVXH2V97OJHUE11NZIVXNAP0BEU8LSS0WMLFFW8SU6I4S7XRNHWSPH0BG6GXBBV51R	9
814	0IIQTWJMBK	1QVICJCCR1VIERCVD69KOVJ9IQLRTLMCA85B19TJNEJJVYBG8QR92HUFGW9W8UTGOSHFVA3EMZ7JM9OUOETD3NK3O05E97L2VD4C	5
814	5KUMKKEHEX	6V8WNWCKK3GHPI3BPMBHO15FYEPOFXIELDSTUQQ0ITE6Y7TZR0F034CFZ27IHXFWUC6M0JQ96L94W8R1U06OSRLRAM32SHSUORMW	1
814	7FQKPIDC53	H9IJG4S4HS1LGXR10ED0OMNQYQY2PQFV50N0YFLX3W24BQMUB2YNJ5V4V1U0FZP1NFQPJ0DU2P72TTOHDE1W22M9ESE6VVRDGBR6	1
814	I6JF0RW5IU	7KKZDU383LCNMWB829U3QK0VG9H83VSBSHG3Q7YITBLHCTI9QFOC6CTWUYSEM5EH3B4FPIR5KMKP9TTX0IRYHPFPXUJ2OT5X6ENB	7
814	5CPJU9L2PT	DTHYT1T2EWAE5OENQ9N5PR48ZQ1RWS5FS9XYJAYYVWS7IXTF1JQEAFJVZJ8DACGW15W61PDQLZJ2860B6W0MC0FNZB9ABVYTQ6FN	1
814	8P3KYCP9C1	XNLG93L6QW2T6GOL3TBZJGZQCOZAZLC1MBIIOGC73RIOGREOKHXNEX1RY4DUDKGFUBG58F7WRD527LKVKK0RXZWYJ1UUDR3TKD4F	3
814	B09BUMIAAB	IQEKB5A29UNURK2TYR5OSWHVMS9KMR3QEKB4WHW3V6JGH9VGA9WW802WJS7S60PS06PHJ87R4C3VMAOM72JM4HRNRPUDJE74Q1QK	5
814	SMUHZ6ZLPE	N7CCF167HKIDUUDRDXTOC04N3HZE8FUUE3T5GKZPUQKEMAYU3MNE66RXDYI7C18BZY91BIL27D3VPZB3TFKV1QXHL51RB2N2RIPX	1
814	UIXWT83ZC0	6SVBUG2C5HOXPO6RNKIB1QFQ31F0AEHJO2WWYTHK4EPXM4WOQLE8HWJQMFI3ACC1AFJW1K23D8GWASD9E1KYAJB1TGJTLNJ2CYXH	6
814	G6YJUIUX8N	9XGTL4JPWP4BJYJ2N01DRDUAIRZYOUL46OFEEEZO2M60OSCZ99Y85DC5CFL3FUABE9F4SFYIBMLFG3V0PAYO5N92LJB835JHL5WO	4
814	4T71U0G3GP	HG4LP6S27YIUUNF6VF1AMTJDZPFDD3LHGNI33CPQQAOU3NISELZZ5OAX71VA1PYDNANHFLCTZKUMFYJMGX92EWM2NU6CRPZALKH2	1
814	5ZJ4TJAB4I	BN2IG9U3XSJRJ4DQ591YV3UP9BKVUB4QQMEKGT7W290CXUHVVUPKQEOI2NJEY9JWX2B7Z3JMCE5WDS1P4Z99VUAL76R2K2720DO4	5
832	N7ZLC5KXCJ	J52LDILI2FKV3K9AJBD2ZA2LQBJGD69D76U3GYRLYDE1HHQS82QCLC4JDR4C9FF6FGY7ZF3VT1DW5BEJU0HLP624BK0Z3PMS7HVA	5
832	98DH79U5RR	S2385TT8HNBMURI74RJN45POE1DPUYXPD1B8OMUNJ546YMJ8EVD0MWYXNO3DPEOT0WJ3PKSR65E8BS02SFL9V6CQCOUATQ7FRKGC	1
832	LMV5KHMJIQ	PS4CV4QSZV5YAVK2O73T21AZS8P88Q0LXZDWR69CV8M3ZMS5XMDNNSKYSEUXOSUI4TALSXLR8084OG9GPULWNN7FOPEMMMXDOE9F	3
832	BKEZFGXSRI	HM9AVOWUQJLFOH4G74QW56DT9FWD4QKH34IHMV28LU8F2G8E36QJSTQKJPBP2TZA9DLT9X4MCRLK7802HRK89AYKO777UMG148FZ	8
832	PIW2O1HZHS	OFFCEGBIFNLYIILI1A8OBFBZ71ZLTQ92B82ME553XBJUWIME4SD7GK3IDQFMRZZZNTWKQ8E5EE196RCYPVQANBV1ETJX0SM7MTHD	6
832	LRYG3OO7V2	CY6OH3BT3MWOQ76JYML74F6ZQFV23XMK9CN7UVFIUILHXJKVQYXH5G161H7BHJ0G9LONU9ZDGDNW3YBH4AME9EO3LQFMYEAKSFHL	8
832	0I32H8MU6T	6BQ8UB12ECCF0HH6VG56VCD3MPCCCEYR0M795FOCXAGNCH763O68MOJ47XWF9Z0AOVONJHBP12JU500ERFIYH0ELCDBITJD7JG9R	8
832	98YTCMB2VA	UXWMRGUEZ9G6RY4QC2XQCLGF25SZMKY0JL6RWL0UUHND5LCUIQHOLA0JRQTVX52OLQXF1N40CD657CKR37Q5DKOIVX9G1E6ZO92P	7
832	0IIQTWJMBK	635WRLIE4LOFC20O6LBBOTENX98GHQ7K526EVJV8GD1LUBYMGKSY0NJNZR8SNB7NODJK5V3WZC4L222WKWA68JTSSTPELDVEFN7Q	8
832	5KUMKKEHEX	OQUR59YS8U6YLH1BAPEU11LFYLVR0FO4L46FPPCK59U8SPA63DF836AWEP2UNH22GCNRLVVVM4Y1HNXJKZXWAPBO3KAAXR6YG12Q	1
832	7FQKPIDC53	TUISUV8IJP11SJYUF10B8XBVU757AVPUHG1EPEQ4CGU4JIEHIDA9BPE5TW7W0BHX9GULSTFBL681DGML2XZ6UPS1C6V2H4DB865C	7
832	I6JF0RW5IU	3ZZ89YFQM2MKV4DLKDUY2IV7M3R272GLKX97A8U0ML0DIRV9AZY3KN5UE1VGHMSTWBA74GLMT3LRSSY5IR2IENA62P3IMOT92GRH	5
832	5CPJU9L2PT	XF3NLKQCNBVC070UKOJADFPND9EKLYLAQOUM953DU4ONHFWQ3PS1IHNSZQKLFF0ZZVVMNNVPVFQJ1BG7NYR5GU2JACWSUR7ODZYV	5
832	8P3KYCP9C1	KCP4DGC1D0YKM8QY5SF2MLL1C4DIBGBNUNDVCBDNZS7L8IITRZIGS3H81X1JC4Z7ZL0944W3P1C3OA34WT0L8440FE4OJ3K52AVW	5
832	B09BUMIAAB	IZWDO110NT047XTDN84Q93ZAHUVRHAOOGMN4EHTDDA2VDUMG12PB1GSO9V54FJSMFMXUJY8FO0N8BE6XHPZPVNWA485SLZ83RPP1	9
832	SMUHZ6ZLPE	26D3JWB2TN4ZIWZUD02ZWZK3P3Y2UQWYF0PSWVM0VILVA3DDIJOYXBJCWJNP7JHC1GTRHH7ROBEOOY3W0VTLC7BERM6MI63MAI44	3
832	UIXWT83ZC0	W6BL6JW64Y7Q0ZLZ693EPA4KUJSI2OF48NEZS9GXOHWX95RGRWDIBZ3VB00X1OEQTCRNVWH63FZIOHLY1L0FK63JTSX1IS6ACFE6	4
832	G6YJUIUX8N	DU4PGO59VH4PB5PX9FWJI4D8QXLJZGICOKY050ES8K8K2MHXRNCASWFJR58SDVKO92A0HY1JBDL762GEQX2LDHU2EPJA1VOMATLA	3
832	4T71U0G3GP	QP2V39OKIMZZ4BP38L1HIV2P1RPZ97MRF2AH9ZJIGR6CTK6T9TCHT3D4XN4LTYLKAIUCBH4IBSB0Z05RV60Q5E7LZGUV58ZRFVBL	7
832	5ZJ4TJAB4I	4R1Y3GA1MF7SN0X85P5LIN5XIND3UVDYU11O81B86UMAWCRHCSKGGAQQWEPQCHH1BJ8V8IADN7OYA4AF551BK7STKK14LV5YMV9N	2
833	N7ZLC5KXCJ	6J3SG2IV2Q1DKVHQGQE0OLYQF22B0MP5WB8W7TEEJ8S4A0B9XIGE4W0UUMMNAG4PA6RIWVTWMARP23QO02NSGLB9LOBUG0ECDC4D	3
833	98DH79U5RR	2NCZT14FK1058WH3MJY4R7IT8QW5PM09NE8PK2XTH4BWKZID7J03FI25ET0CF807B1S3Y1STWFXX6WJJIS8FV74EMCL1CUNJDDUT	2
833	LMV5KHMJIQ	POG1GG9VF9SKR4X9UME6ORWP0RB1OT2BZC3E2OO04TGD2RU00JT0PW1720AZFIGVGQUOBTHF7OB5KSWJ6LBFABVDL5LBOZUWMU6L	9
833	BKEZFGXSRI	GYHCN3BU6XJD124GBVE5RDGHF1H3OSZWLM0W3CXIUSOHC8X70PL92QODS97VVHGN7X2OCHN886K9Y8EGEKD8H0347WD3FBWMLAJP	2
833	PIW2O1HZHS	I5SCMB6GPOU40QLEHGH38QPET36J8XYYZA5PU64Y7XSHT8OULIE4BVH1POTTEWI105FZV6ULLS6K8HUUOM80T3WE2E9GMLUKP0RY	8
833	LRYG3OO7V2	Y9OX3SSZ73H39E2YSI6IA7R6O8A8V4H060ZMTCZLDP5K2MNG2W7RUP31SSJ4SUDCVQ7IOPEQTVEUBGEBV3G870GQ773B252TL3YL	4
833	0I32H8MU6T	E1MSR88LI0MNIIYOEE5KQLRWCYX3VJIR2XRB4QQ1HFYHRXUWDFHY3B72K0P3KFZ9R4VU1XUYYDCLWJEODBZQBUY1ZY0DAXQCPZZX	1
833	98YTCMB2VA	95QUS9Z8WFBVBZJQJ77F35C6QXBWA57TQLEFI5TV93DSZS98GVF12SJD2TE48C70ISFZUEHOOMG92TH8YDQO0F08CBMY0YX65MKH	4
833	0IIQTWJMBK	JNCO1NQLJLIMGG4WSAC1GXT1SYZZJEPJ9VPZNA92KW20DLTS2KNMHQFW4L5CX1BF59NV0FJSBKQU43XGEH690DBTP35CF6ETUX4E	9
833	5KUMKKEHEX	81XA4L79V1BXY8Q4CO183F7KGNFF79G8THFQJ862DT4B3PQ7YZSJCGF33N4RF1CVUDEQ39UDS94JL6Q16HRHR75MCMW6EOWLRIQ0	3
833	7FQKPIDC53	9EYEP0DM5R76CU8K4EXH1OQNY8DNS2CQ0Q7D2DCG2AG4Z9C3YBWE3STVXKPQX03CPQGVX5R1CQO0HVYY6JZRG7XH7MPRXVTCHEPI	8
833	I6JF0RW5IU	QG2T4CME3NBW0UNAM6R39YLQADQ6MTDGQ5PD68L5KDD8N56AFB4H8O325MT0VP1KK5G4FKEOUVS6UMCEHQ0KY5IBCXITOUJ4L3XR	7
833	5CPJU9L2PT	B557QXM57HSKOTFYRVPXE2RCU99MYV1ZUPFU5NII5FEQZJAADF3HI4UJN3MQXAHMP2Z9OV3DNH19YBML98IS1TR046GBB1U572A6	5
833	8P3KYCP9C1	BWSMZ4BCVUMQARY1ZU6L9ESO1CVW6B5BP18MZFBYPXJL4VAK5DIHEUU6DEUXJOGUZLBJTMCTTH5L5HUGBL123Y65GBJVUOPBRZWS	6
833	B09BUMIAAB	10TBYY6YIB6TOV7XN1BOFCRCQ8E144GVBWJUH1E9AG8ANBG2SOE8UEOZJQUZTE4O4KR1LMPVWBO9DQZO2MJPZIA7IUL0GPP5LTFC	5
833	SMUHZ6ZLPE	OQF9SLTZOV21F7H4OZWKUT1AYOHVSYUKW5N5EQG6RH38T9ASIA64T294ZFKDE7H0BREKTL08S03MZ3QYOYNR10145SG9FC1TAD7C	8
833	UIXWT83ZC0	Z86K8L29WF5YVZPUZ8KZJPAE12P9JMW5O3YZQH3O95INKKTNL9KEWNWK81SF53ZKT9K2B0ESF50OGW4QICXKBRIAGN1YYXTFF84K	1
833	G6YJUIUX8N	1LV5191XIEL7C63FPIB1JWX8P4RMUIH2TQR0CPKRRN8JQ0W1ZA0Z2T1FYWP6RPD96SOVPCDA7UJ5XOSYI0WTSRA9YMCP9N9CK9M7	4
833	4T71U0G3GP	ALX602IK5RKE0Y12TRPSO7CAYAUUHVXBVMIO9W1Z2Z341KJZIJ0R7O7DJWI0HXCJ3ITNQM36ZZ0ZDIIN15M75GEGPFFMNBSEWUAT	7
833	5ZJ4TJAB4I	5I5Q41HXH9BO58MKFOXDM8LHQSYHWCSHZW6WRQBO7SHFE8SCF4RGNPO67YALDABFR3ZJC03YNJG40GCSAVB1VM4JI9Y3QZK6RCXK	3
856	N7ZLC5KXCJ	JAPA22DJUG1VRLR8JTE9QBDBAIX8JMYS2J1VW12T09X36H8O38HSTK2H7NAUFF9HRJ2IU6LS1UJQNJF2JJFLEF8RQTYJ1IOVAQLX	4
856	98DH79U5RR	046WZ18BM4XIHK5AYCMKL1AHC1TGXQ78RNTPIYONAPEZABT7SVLN8MD83ZU8I2O67Z041Q1AY8K5XLGAIVXCET9FJUWTDQFIBH2L	3
856	LMV5KHMJIQ	YFC3LZABILRSU0WEL1NZUVG4I6H3C3PT5ZTPUJ249DAIEBTZTDZPOV0C9IUPRH9O68W4GGUC9S0RU7ZHMSJ9D9EJ8QQMYNN2DWMF	4
856	BKEZFGXSRI	YSMTXQ55JSBSNC87AK63N60ZIOVF8N8VU2X97QQSJOZ8P3KKO5DLPLA22XLI4066TQ8UO99U3NU9G1KODL0DJWFI25HKEHYSR2O8	8
856	PIW2O1HZHS	05P5TRB1BVAM6ET92W7L02T1ZPWZBROMLUNPLI0EDQ0JG7ICETYGRXE7LXFD5MZTHYAM1EXU62IJBKV1GTVR2H5YPQDXCWJ01GBS	9
856	LRYG3OO7V2	6LA6EJZP45BCN6M0H192M6KAASJTRS5JC4KHVVY7FJUUCUYZ7ATPBZUAA95VAF7MA1ASWEFWCBWDLZ8P3TWR9PHMKKHVZC7ALIUK	6
856	0I32H8MU6T	FD347N9CRYLAQ2QTQNUUXIM7U69EW2DFY5XQ3WCCIJ3V6UJKQQ44A06715KAN5QZVFMVFA04LRLNO0B9XZXG7IE88ZY7MBYN3EA0	3
856	98YTCMB2VA	XFPZATTOSSA4KNYHJ1MBNWPL3SJ28UKZK09UHQ7ZVUQGXCBXAGTMXY4BZE6SJ0Q8IKUUOE934XQ3GIY1QW22A8CW574DUOQ4ER8M	5
856	0IIQTWJMBK	RJ5G0SAIB4QPFBX8X7JI7YQK5IPHVZYJLI9M6VJPBN4DNXPN25QUZEU22VKSC3WLFHE6BKBCX3GU3N6H3BOZJEUHYHULK1NI0S8G	5
856	5KUMKKEHEX	TMS4O65799PYCYAP6CAW7H4ZZ16Q83LOZYKZ555IZKZIEXHDM33Q7TWLS2EWAO8FXA8OOLTBH27WSWVCT3EFA4RGC8HC1IIKLTUD	7
856	7FQKPIDC53	3YBJ2IFW935HBDHK3F3T2MPDRK9TWL9BROZEC5HVLUCFL5ZEBASN0U5QJ72SJV9Y43ZXODH78HHIJK2VV4SW2WL7TI4FDZM0UOLR	2
856	I6JF0RW5IU	B082UPTMXH9EG7PCM5IS2EFIB4I5RX58KQTEU3IG1U5B5A627XHSD8M7VZ1ZGY59LA40OKSTWB1IIDMA8Q74QM5MDVT4CSACY6Z5	2
856	5CPJU9L2PT	GNWEY6CHEZRN01Z0BS9ESW21XQEAZTLNQ41CLZ2Q3F96BRM1LLXO01YTV5RH1BRUND669WPL0SKNW6ZGENYN57WZFHRQHUY1XOS8	6
856	8P3KYCP9C1	Q1Z6LXIQL6YFLDONEZQQH01E9EG3TZIO1VXV9QTKOI3K3K5QJOSZBRMZ9U7HQO7VYKO0Q3NXFGB96RLYIZTEHTMJI7WPTM3AKIWT	8
856	B09BUMIAAB	FAQA4T5PN3SJI9043OE7ERSG8E3MBZY423CZDDMAQ45EDGLNCGR4RV0YSKC0ZTOXFXQO6B1ZBEQKVOC22QK4H3NGCNG3BWK7QH8Q	7
856	SMUHZ6ZLPE	6QAP22MEQDEHJ7JITQLKJMS47XP4T3NPWD69JPPAACVKCV1YBY71XGPU7FRENSVXZZUGBJ9EBKJH0H2L50346W1QXMCD7KXRR8VN	1
856	UIXWT83ZC0	VX1Z20N6H4ZNFJXZ01D7ESZH5H1X101WOKKDBED6OTQSMZ1B920HSQ6C8U4V9ZEQCD948UXWXGTUCH5FPZX9AUE8NIERKR7YP9PJ	7
856	G6YJUIUX8N	6CPEDTL7M90ZYGJCEQS8BQZPGMGJ4FD1VOSXH56A3BBIN1VLYVKT7KZPMA71NBCG69DKXV4JTSE9PRBP05VI4U4LZCKH7EW285MO	7
856	4T71U0G3GP	LXC1A9PFZA58SASP4LMF1VULXMO5MBTEW0PITR3UPF9COIPDEMET9J60C1DYUT2YQ0L2VK6MR10WVS6O6K1A7AFN3ZF2NFA5MLVY	9
856	5ZJ4TJAB4I	XS3Q1BITKET4Y2J220QV885EE9M14JK7HRJ27UG964TVW7YN0CUUEC8YWZM2YQYB4VWGSR5IURYEOKSGK9B1YZ2FTUFIINKQFR1A	3
882	N7ZLC5KXCJ	R4IHMAXN4JMGFSYP6ME2RX7MXAGGI87TR62F2UMYF1ZK2BC5WBIEWH2476UL4QF5M3ZIZTWMAPXZ8WTV7KUGZ26JD7H6AA4YW389	3
882	98DH79U5RR	3FCO6EGUD6KM8OT68GU6PF2L0M9V9DFYUKDER23X0ZAB7TBWL1XXND6YN1YUEVV90W2YLOPGM6FZF0OGKNJHQSKQNP00DITEEAKL	7
882	LMV5KHMJIQ	NK7MQKR7GSXNRJ0MOTILLK5XZCDNBVEPCP7CM49H3TH6DMW9220RB9PCPJXNGD6VOHKCMX9TTBS2D9TMQEVI4XNDA4XCGVBZXWS5	1
882	BKEZFGXSRI	UWE3G7ARX9PZL7BSX004HCSA6M792ERRYJ6SQPXZMWM4IN5YAG951B5REE64ABYSS7BCATBICBRUZX1TRJ9WEV0WNONMS3ZL73ML	3
882	PIW2O1HZHS	3XRF12ZUK2RMMM0BCO6GOYWFYZIMFX5KQHYVSQN2ABDW6AGR8J5PQE6EBLQCUNOX6H6EXFTVBDGMU9IYT1O61Q4MLTUGALIXXPZZ	1
882	LRYG3OO7V2	B33ZKOM8TUBD1S39S6PMU3EUNUZ5SZFJTVR7VGRCSO19SDJ2PXETKMTIZIMZYQP4O1TGB6OLON4GCECJL7Q4VV9GBJHM31OB97U0	5
882	0I32H8MU6T	D0SJ2E7SNFUFCO0AUI32NE2YBRX82HFUL0HH7V2QCYYDWG1MXBOY18F874IKQ8ZGAA4LHTC8QMZZPZB40LL12R2MUIJDMRAE8SCV	4
882	98YTCMB2VA	PEE9PHOIQSI2OUEW8OTHS18J9V9MV07WPRLHH1MJODDZBK875R9DTO4YG4A3ICXZVVM6J7PGBJ3OXIIYXCRD13DBXWAN1SBMQNEP	9
882	0IIQTWJMBK	CX7C2CJUPA7VLGGVT81RKIW6BPTIR8JE30UOTB814RHVD2PL516ON7X4BAANSADR132VW1BSA9X3AA3J9IN0B405D0NTAUJ3O04K	9
882	5KUMKKEHEX	4ZDZNOOK33AH0NKXMP6C7R6ORRP03PKFSKESJAXQMUK6MMKH8GBK7HCN2YI68YQOT4YQJ1NM1Q0MH9CFHI1XN9IKH1ZV21RXE5MR	6
882	7FQKPIDC53	37G2ZSRR0F3WCYZ62ATWNJSC2T98CHLXVROKV4YR13QV690D11L524KUPEAFSSOS4FAUJOL8MC5U27F336GL6Q41H45Q4S8IO700	9
882	I6JF0RW5IU	F3NQNS0801S9HMWLDWNLJMPT4D4DWF4GO4XC34S7E2RCNRWFM7LLNPY3O3VJYWLU6MUMYTRIDPHR4MGNRY1Z4T38G4YAJJJRQ7GB	9
882	5CPJU9L2PT	KR2QCI7IH8BXI2A5W0NSVG35Q94GZA7GFQHG8J1L5086XMAQJW4G3SKDY69DN0SGA4S2V36N8CX5H6ID8N7DG1NXFDSBJY7EI262	8
882	8P3KYCP9C1	I5PZQH15P51Y5EA3OAIR5WRL4DKESWPAQJ0SROZTW2ZI1NOU6L41XL9VNE4N7WM3P0IWNSL9KZ4D7JTRZZIG2YNEJFENTMWAP62A	2
882	B09BUMIAAB	1GO94R8Q6XDUNXHOFB1NDMIN8Q7C4XBRSM7S3H7GOYNRB2FZOWJ4AXBO8AAOT5VIWVBBZZU8DU8P90MFKIYIOGQ5KSU3GTXTCE4P	7
882	SMUHZ6ZLPE	E9ZBK1PZWPHX4DKHM3QFG0GE01T7OM567PFJ8GDPBGYDMFLPML0KOKUN3ULTHSKKTL0P7BJG0ADACC2VPDUDWURX42QN5UIT6OTB	4
882	UIXWT83ZC0	6SLCTUNGTL02ZDD7HY93DUFV5KF2UEYS1GTVJACAEQKRZVFREVYZUHLLM0HJPUVPWHBTTRYGW9ZWJY5KEXY8P88T4IIS32UT554S	5
882	G6YJUIUX8N	V8X7SDVSZBY46E16XAYIRZLIFN3OF1O3M0SZAA74NBEGTY6Y3WH4FJB6XO2EKHM8X4RFVB5WD35QUEYRQEUTTTYDYWCWI2UGYGTZ	2
882	4T71U0G3GP	0C10V1LNVLSZLYFW3PDGOR89JOLJZ1OV9KZC2272MZDKU77EOT51PS1JD2RHPCY377ZA8D3ARK4ZNYOLRH5F6XFRTQ8AKZMKBKNW	2
882	5ZJ4TJAB4I	6FL04JEXC6PNF0IGS7K1HQSF3Z18UXDL2DUBUPBNA3QTSWF9DDTMC5APXG7FRGDO2EVBGHWC571OA8WGU24RE0I7DENOR654ZC1O	1
883	N7ZLC5KXCJ	D36QQQFEWPZT0UZMWJC5Y8B3IV9B7Y7HHGR97AYJD3RZY40LFRD2YTMF1DH4REH7RRMUD0OWV225QMFO4Y5PUFSY3LH42329VTHG	5
883	98DH79U5RR	GIPCRG60QZP73A2I1NM9X01TU3192J6E85YPPMD8V7NW2682904G5H4PQ6SXP77H2K97MN2OJNNZNE0X489CP0J1BI8T4PTYAG4R	9
883	LMV5KHMJIQ	AQW8P6S3FBLF43Q751BAH6DOIU33ZZHKJ03SNE93185HWO9WD1EO2RZDMHZ5CYEP3B6E97U12IJJB614UH07V3R2A0FFPE0C3QNV	5
883	BKEZFGXSRI	5XFGNWUHPCPQ4K58G4ATEDJ1PLXRGPUTGMZTU1HH7UVXZZU34EXVMBN1ON1B8DB9S6JRVMOPW3WTRVB004WC28GE87FG9GI3TVF3	4
883	PIW2O1HZHS	DIS0I9TP4J2LBKEQ8HT0ETYHHPQU2A5QIKXVDMU9XZEXM475ENUOWCKTULS2S8W3OLC1WSNWWTDPOA4MSVPPQR4F9EB231RYCKJA	7
883	LRYG3OO7V2	GIW972C95FTQFJ7THN6R71SRU35CPMD14ULM3PSZ1GD8RLXRUF47MT4O0EPE7AUTB2WV8UZ24HZ0YT9JFNRKRGPLZ7WZAO21VU7Z	7
883	0I32H8MU6T	CT9PCCE3D0GEF9TSKB5NL5A7A2QP8EEWKUC3R4PDKRVHQU4PIILSCMOHTBPKWY59WU4V60APW1C3J3RP7AHZ3VT8F4KQOEQWWWV6	7
883	98YTCMB2VA	JSRH55KJU8ZUANWQFFAA6PBQUBSKQGWIVZYR0S70JYU6U5O14FQRU533RBW4N93OMR8KYE0XIK0H4F6YW0QL0FXZ54AY5CMJ5GUD	9
883	0IIQTWJMBK	ECZO3IKFW9LF7IXTSXH3IO4EB1G7RLXV21RX1666NUJ5YT83Z0NSMJZZIVMBCMXKL0MG091V1KQXF8PR3MI18EITB2OFT53A78U8	2
883	5KUMKKEHEX	1CZ811B3BUKG4H0E5LGR2E8UWC5RP0GOQKBJS3HMG0AHE9YXD6BWNQPXEFMZ5UNLN5ZUGQVCE3LCE1PWNINTYUB95OFNRRRWNY4J	3
883	7FQKPIDC53	DRWL9RTFNTNZZLXG3W34ZZ1LHVXMZYP6GMJ10IZCR4S52X1G3PTBAPUOZLDN4GQYEQTMB5QV71M5H6TT3QSJFN6115BPELHKN31M	2
883	I6JF0RW5IU	OE797EJCZG32TTNYGS0T2UG4ARVTCRNFHPOMUKHIWYCYIWU24WGKA2L38D8QT0AH3YVEEBD5LS6DSRVO63ZPKCEODVORM1Z6Y55U	1
883	5CPJU9L2PT	QX2TK9S5ILQSTTZBU60TGATXWTT2AOWWBNQG66ADWT5J783I95E8FB4QDF71PZ53Y4RGDTEY6X6XFKZX0L3EKXQ9T9C08IX6YBUD	5
883	8P3KYCP9C1	WEP0PCSEGL3PKBE60TBNRWDRNZX998DZWFDGNO4V85MYJLYHSA8RTZAAB8MZOSEIHD3E87SMYPOWKPHCAQQ9AVF6FDFPBEGQ0EQF	5
883	B09BUMIAAB	UJVRW3ELOZV0KY8BFHV86941DKTI75G8BUQH5RO2BV1NUY0QIPV64HVUO3OLJ5NSTWYZI0FX336LIRHPUDASKJE4962BDCSGHI47	9
883	SMUHZ6ZLPE	BHRJ8DBLKM7W91G45IJS40M8DT0KZD9XJPS5SIMFCTZT5PELMLMAUPEK5TFON0VHMJMTIKMW5DPLA2CYPO8O09C4LIA8D72M8SHW	1
883	UIXWT83ZC0	VDB90EQ93JDRR992HQNGRIAKNT8LDNSVQU3L6OA4W5R86RV83U0B3PWNC1WHGE6Q1RB7FX52QSUW0CN57ASTWR1B8QIF22YR8AGO	5
883	G6YJUIUX8N	Y2FY7UL49WAN0JGWM4K0A9ZP0AX4DXZ58PIIN4Y6PG84H1BTS5VG6YPZCZ877R1M6FPKA7JSFNK3A5I88ELIBT8KATFX6198PW7B	4
883	4T71U0G3GP	1SUVDBSNVYHRA82FSKNHEKR2VVOOMOO7GVHW1W8RP6O48G63G26LU4IRA1ARXEBHKJLO0GO6M51H5X4OZUIUSCNLNZV9VQ4L5GUY	8
883	5ZJ4TJAB4I	RC9N99YDAVN7W1C5RZH69ABVPL5AQMYDFTISIGSDYINEIB9Y2PORN25QBO8YDYWX6K1CTTWKHDH1X6NNMHIA7HZNY1R4H39AVZH7	3
911	N7ZLC5KXCJ	6FI2DKJUD3EBUM6PV0ZUOO1C2DNDHF7ZPDPBAI37Q2U8N3WRDUA9SN5RNGAA6FM75OWR65ON61EV43Z8Q5AWF7HBH8X4H2AKQWC8	2
911	98DH79U5RR	FVIGWD0JKWUQCUBF028GUJ7HUGD03FI001KJ2QS4Q17LDNFI9F03E1V6XAVQ9AQEO30KK1MJJD03LWEHB51YPOW8FOV15B4QL36J	6
911	LMV5KHMJIQ	47H2QTAB2UB6OPEI2ZAG1E5FUOHIJRSZ4UG7T584W7N4T4QW0HTD6D50CCHCL12LCMC3JGZ60FU41BVZ7VSB8O21ZP5QX6S4EC1G	8
911	BKEZFGXSRI	XNTRWM0SB9AQSE0J1MXULE3LJJ4XZZZJO7KI8TLBBIYQ4AF12UNZEWQSUHINSD2LJ1BU4SLIBWSDQMRIED4FMAF2Q1X0K7T7PMHC	9
911	PIW2O1HZHS	U6JJEXSDNBH0AJOIX9JWIEC4U7DCVXDFPJTGV5HMXZC0QAKYEZ1N7QZQ4PYGTPS08CL0ZIX1169TBMOUXP8650H8TDMFHA3IGM1N	7
911	LRYG3OO7V2	U86BAWARFPRBDTEQW4H4MGW5SU1D0NYUA5DQC45EGRNY5EDRY1USTSMOMBTP470206AIPXO18DX5289NQKO92GASSZDBLPJJ0V88	2
911	0I32H8MU6T	5BAN3TQ4RVOBF9US0AT5SZ0UNPS4NEHABJUINW9XUXBDZ9FQY19UOCWGKQ9NAVQNONA6OLEEB5L4XW4NKCGWEWV8WO86WVX9GYYL	9
911	98YTCMB2VA	ICMX5TT11SXWWC7O4J22BJANHSPILX97SOB939JCCG55KK9SZUMP6T78C9PMDLPDTZEIB8U59ZZ5OED7S6S1LUB8QC74T69101MU	2
911	0IIQTWJMBK	1R19RPG3CU75S3G2Y28YF28A0LD08EX2S01P114F4FNSA8BC28C8N6B9T0JFLQ487EN1C1B78339OPA1KA79BYPWZ15ASY3NKPV5	6
911	5KUMKKEHEX	JAB7EAUCBVD0S5LS46IZ1CK5BPK9PY94FFBA6C6Y4TYG2JA2S4PSMF4HZF6ZZUWMVJUM4LW29U5HNED1PRRVJQRAL3K1GH8K7LUT	7
911	7FQKPIDC53	X8HIXS2KX3UCFKICBDF1UAAA4W2VUJBTTC1SKMV7YZYA0YB60H5IP1EX8GNB0HZN1ASCTZ2YRHC4M9JGU55NN3E18DUD8UHRAKIZ	2
911	I6JF0RW5IU	8NAPG1HZJL86HQ4MM9861EPEY06AV4B1U9WS48GB6CY2WG1EMFYKJ2P3750Q4HDOJHMH4MRN369YPXSR82XQG0R2U2U8H0HZ8KSP	8
911	5CPJU9L2PT	TJAXKRM30OKNIRBTXITZUWB1SFDZKZFEDXPTX25JE84OKV9IGGLC9ZK6IJEEOXTAJFJVCS55MKUV2XQ7G4TEODFNMSLOX04RP3FF	3
911	8P3KYCP9C1	OFXKPZZFZEU2H8TEPWF96IUHRHVPDF9SKW1Z539NQIXO0VQ2KNAH9FPGVQ3HDJCUFBRVH4IVX2TYVFQ513E0E1TFHVDOA1JGGCJZ	2
911	B09BUMIAAB	4VQEPUHW0VP97QKFMPNSMOV03U5SMRS6116IXVZHMSQAXPDK9B3X6G1Q9ZK4YZKJDTIGTCR00FG47VDORVSKX4AU9QI8L4TXHH7E	2
911	SMUHZ6ZLPE	617UD70A7SNW5NDG9VISXGD3TO5VTW0Y8HU3V0U7JUC74LQRQQIWYVT0YDBYBERK2YXX2JVJAKIDDG8H8OFCOEAMX4FRZ56EC1FF	6
911	UIXWT83ZC0	2ZG58VNNQWRE30W9P6XYL97EDUFODAMB2TGZ8GPTW9HIXM5EKFX5RRM21C2OP9JQKQMJU7BIRECL2ZQ0YAD8NQTLHN75OADW007G	1
911	G6YJUIUX8N	VUNEONNOB9CVBZP5KD37ACG9F3QAQVC1KZCQ048DG7GO5KMKY0PXEJATON8U6M7P7LLMW9FQFZ1C52D5RGM0FPWAZTBM5NG3A0RU	9
911	4T71U0G3GP	AXZV9SOS7XVKDD0AHKSYKXD72U1S8CFLT6RSWFF7IS16QC2JQ22P95YMU23P05U4RK0HWHOBEUQ15HRZ1RCFJZLYHE84M0GM86OF	4
911	5ZJ4TJAB4I	VXIO0LOO6RMLDXI3OU29C9SJTZOOE393LMG431SO7JLXVTIC8TTLVGKVF84B79KCRT90QO9WBNB2X4Y9RLQVJXHFCVY46RQ78IFB	6
935	N7ZLC5KXCJ	RWTT6JHER8KK4TWTZ24M3X5ZEZU7D4OZWPAZ6BMN9BVWOUC84NJPLZ0304OHZKBWTVXOT7XXQQM2CILUXVCZV8O6ZH8BWFYY98D2	9
935	98DH79U5RR	XP7ZV94M81RT4TDILBUH0ZM8WAK2Y2DFSXAGF999TU0PRS2WUQY7TVF7D9DUZCYFXMAGS7CLCUXG96QDIXHHEGV6SDDG6PJQ5V2F	5
935	LMV5KHMJIQ	VDXNN48787GS9MB4QBR0DYP36PXLHKOELVWUU40LW8TF6X6CIVPTKOO7Y3R8HX0XTCGOZRKWKGEEEJ7ISUCV5437HZ50M2D9I5V3	5
935	BKEZFGXSRI	SM0L2IEKJ2O6IPXUF1YJJGAVTJSCE6IYD1AHMJCWYX76R3ENQOCD6THLME1S0CFNU03QPPI5ZCUVJEE0FEVZ3E1TUY5HRU5WSUM0	1
935	PIW2O1HZHS	X7AGGO48VCHABNVQPTP8J60UBNFG8DZ2NZSHVTWZ7U8WXHQGKFCA6210GPE3JXARNPWM4O556ZBY7E747862AY5V81AFP3PJUQJI	6
935	LRYG3OO7V2	DL5KHEH1C3CSK5L0HRYTANDOZQDJ1EQ4ZJ3WBS3TY4677WF8ESM9UYU0IRU1B797MI3BBZZZXE4FRFQDLEFI1QJAYDOT7BS158VZ	8
935	0I32H8MU6T	E6O2XMP3OICARQ610G582M8LG1VWDKTU1KHI0PDE4GJ4LTQVW9E1Z1A18DW5030EZSJGJXAKC1EWCDAXLA9DG14AKPKX3HOAQFF2	3
935	98YTCMB2VA	JM883Z8WNY4D9UZ4X77XJ63NNR4MDG77HNBYAEMB6N60PU4XYG2HHFAMSVVM5WTH166VSB3SV615AC73XHX7N00BNYGOSAGK4Y9T	6
935	0IIQTWJMBK	IEXMJWLNEMPY2YX8V4AG4I45OAUZRBLDNFOC9UDDPXIM000LSLI38N39K28JCW6DBMKWKV8B171GASEYJIGF2REAMP2HW3B21ELO	4
935	5KUMKKEHEX	EB7MHCBWX92YJA3P1KTHKK521O758P5HZJFGI3VPCNYPASN3INA41GE3GEU2EGYHDV895WH7ZDF6VP2JBEWVPBPSFLADI2K5ZRLP	5
935	7FQKPIDC53	N7VFCEYBHI0ML09TD2CFQ3TWDZ62JGEDNZYGBPN61Q7DJ17BKMWYJJDTO8CNH52AEX8WC3SYPGO96QNM15R7UP4EVE2CM9Y5Y79W	8
935	I6JF0RW5IU	L9R48JC4DX7V0VMN4QY24A7APLPRTL8R0TQ5ADVF2KRR4QWOLS3RK38KBROX4UL2YQ4GEQN14TAUSQF8YBFARRH7VG4SY8LH9Y2O	6
935	5CPJU9L2PT	QJ5FBW03O2ULP92PKLGJ7V8W4D5H3V3Y1NI2K5P5QEHOJHI9S2YNVEY5KIK80S9286TC1AEO5L33NUMX46YB6QDXYMRCVRE7EOPN	6
935	8P3KYCP9C1	FISXJRJL4RZ5XD4486S36OOSB3OH6Y9F99ZXGNW83L342G7OJDGR7U114AWQDBPGSU6XNGXUKU9UUTZ55A83SRIPH73F1F416XMI	3
935	B09BUMIAAB	JACPVHNUGHKK0UDDVYAMQPPMR3EZHY6GRUVA5N6K44B0T5AV1YK9L633U071DYMSKD3G9DHI10RWOZ3W3T7TN75V11PFQEGGSTQP	1
935	SMUHZ6ZLPE	4WYRCHUOHP56K8T03EMIHPHXC1WTKE5INU87ICKZKGTMUIFGWPYODG4POBOLUBEDUWSZ9WS14W8B54C3VQ64PRFH0TSGX9FJCQ28	7
935	UIXWT83ZC0	PGA76TQH2UU9UZEEJXDQL9QELE4RZ9OCDEFK67S7Z9797HCKAE23ZSOQ05W2Z8S3FR5QT4HMEF1MBQGDBURUGUNV0ZTBK0H0QE4Q	4
935	G6YJUIUX8N	V0G7PZT0BPJYS0FR7WUEJ04KFBO8A56W00Q3LW0545YJJN29CJTSJMD4652OLV0GSX71KLFK5ZKOCUA2JO50MONOXV6P4MUIER0W	4
935	4T71U0G3GP	AY1DIWTCZ2L4AE6Z94EKTEZO0QSFBJU4OMJ0EXD13M73VU4IXTFXWL559MN1EOAQHRQX5GVM0NQHH53FVKRRD7ICQN02JMXPLRWD	2
935	5ZJ4TJAB4I	GMR836J4YYDSHG36TNJJNHRP3COZB6ZJZBO8ATKA8H2ZWJCF3T1EM4194BE0ST32833G1559CIKFO22TAI5SEV75JPD8OTSPOA02	5
949	N7ZLC5KXCJ	6O8X2BDUVUCJV0KXLXM676M26UT040OB9DD374MU3LY4AZ32I1DMN6S9CG0HRMZ4FAJRXQZQL2CWIR1H01SCXCYDVD11EEDRV3YA	5
949	98DH79U5RR	MF1CXAV351UOTQ04WHDMF6TY8LHYVBP300OV0AABCJZMHMUXNW9VVYKPWDDL36I4M1Y2BEDVGCJ6GHRV1TL8B3ICQ99X7ZHFB59P	7
949	LMV5KHMJIQ	1VISNPSOOJOWRTJUJ2TSVMCEQYR4D4KHB698DPYOZXCZUAPF7V2DQ6DPSECZ7YKT8HUVULR3EE37KNTPIL6SBH1E3TP8N8QANS0N	5
949	BKEZFGXSRI	4UWD99LDFFFUWQW22R1PP1A5SPFY3U1WF9O0JOCHQBYOKO1S4IUA98ACT0UU3WKUNSPXB5SNPT9OCWVEYX4UA1XH8LGS4SN31DB1	9
949	PIW2O1HZHS	EQ8ZHVP9W97FP5G2ZUV5HY0Y9T6GFX9U3FUG552FIIMLJNOWHABTP61P0JZYYJ38ANMKL9731QW9MOPWEK8EVQE6OEQVFEQ9ONL5	1
949	LRYG3OO7V2	EKHDI19J1DM4DTOKZNUIP5HTLYX9XU8DTVA91ANYFXWBE1CVCYZ90XVIDY1TD9VGEJKSSOTYA5C2JFPUWC7858M6926CJ3VGBP65	5
949	0I32H8MU6T	TCXFB94V297JG7BCXLF6OS0RQOGK613JTDCAJ349RLG293C6UEOE18CBLGYW2UYBFYZD4A23QGODL7SWMKZ2NZRVBBYDEHG7WFWL	2
949	98YTCMB2VA	9BTLUXVU9ZNYBJS46XQGEB3MZYJ9RQGLGSNJGQ2B6ABLKOC7YCZRGFA7HGV5OVCSTCRT6IYP5OJDASCKVLKP1ZEBSQB947XK7S2H	9
949	0IIQTWJMBK	TBPNJW1566ZELJDKX148QBQHYV808FRZ4NCJ5BRCNFVTM4TXUAK18JRSVIYYYA71P9K8H3PWJ1UKP644BKG8401V6UYXM3OMH4EM	6
949	5KUMKKEHEX	VP0UYRHYGCYN4XN496YIYBXF2KQMIDV2SJP5POGIU60RAJRGBSI7PE5T2V1OA4QCR55UHRPVZQX2LGES2KL04XNNO6D3W2HZQX9E	4
949	7FQKPIDC53	68TDXI9RDIVQIV0T0I3RRGKOV86I7MYGAE5L1WHPO6LYRMNHRG0PGW6ZYFRYL0T1TPQEZO1DANDV5W7IUZ01WJANHFXWFTEXNUEC	8
949	I6JF0RW5IU	JRDOWO2TL4BIIDWA1FKOD6T0F8RJQILS4NLHXN94H36LWO6PSXVP3X1M7MIY7TCDSTN52OMOFQHJAIE1BB13W6YHV8JLEL6Y122C	1
949	5CPJU9L2PT	AXDKHJNPSMZHRW61JRW5FJ3FBJ4TSSIPC0BNYSOXK1DWTDWYA6RLGH5037I7O379EKF1VSD0C9UNGHW7XFTWB6I44KT0KRIQ4ESI	9
949	8P3KYCP9C1	5DR20JHXSUWLLKJKL8HCK6L8NQU0DSCZN81CC3KXBHLZ7P8G9GTGLGX82TPKYQTAR78MTHHRXTADVVB8RN1796OGK2JTNA9VXLHA	5
949	B09BUMIAAB	VX18BS1FUNHSR2KYWBVT1B07YEXUPPJNAR60987NWA0OCB6HZ6BKWQZU64K74H0ED3R96UYYDH60KM5XHP4TO91U2M3FYATPKWKI	5
949	SMUHZ6ZLPE	6LFHNHOU8JU8WZOMGZEC6HU0SADYRPYBXDKEZLA2MA3CIHBKECD6GFXY1OZNDZCTVTLSOKX5ZLZ6ORSL82UPL14RQVMKWXYX7KRZ	8
949	UIXWT83ZC0	T53OIH4P0KK6NOLFXH3Y3B28MJBXC9E92QP61ADTAC0LCOIIMRKCXBCRD5C8GHM1GKE79POXEJX1LR58A2KVYBL1N8357EN3Z8E2	3
949	G6YJUIUX8N	LJ7DW8ONLFV9D7N61CF8NTAVSZ964BMMDYZTMRCC7NC2H64HA6769362IMV79RTJ2I6OI4UKACA9QINW4267DQNJ26KA6EDQ42A8	9
949	4T71U0G3GP	Q8GMX5627LA88CGVVFM5WWLTTN58UFXHPWO3ZVQUQQ4VKB7C64IXYDN3XW2JA8I1Y2TLXN5AZ1PF10JSQ3C07ATLJVGD2GUSID6R	5
949	5ZJ4TJAB4I	VOT8I76YHB6NK3H5S4XIHCCG2HSH66X3194OS1YCXXBTJZSNMW0JJILTMMGAPY1KNCVL92M0FVVTAS7DZE4KGOUSYKCGVXX861FG	1
975	N7ZLC5KXCJ	HOUJADYX1S3PDLK3RE9SDWY0GFR7WXJN09S0KAGL6562J1SMMFOWGYAU04D4V0BEJPZD2TTR8XVH05QPXEVRIWGB98AQ7LZG41T3	1
975	98DH79U5RR	OU3V7YSC234NYHQFT5WJXD4TCTX8PN8MXNIU25K8Y9GEGCIDIBK66UOKZJTNBUWO4RZK95MYUYVY7ZM9LTZODCQD874SM77DM2JY	4
975	LMV5KHMJIQ	7EMYWLI9ZNA6TCR5IL2BWMBB4LX0RMEPYWNOMZQ1IEJT4V34PIDQRX0VCL3KXRRNJUI6ZCTS4A2SCSGJS3KJIX8A61LA6GE0W5KJ	4
975	BKEZFGXSRI	7ENZVWQ4HTUFU23GIEVWI980SWY6C5HH76UY7TXBRFYI15LNKUO0YWE7GWG88U2LLMIYHEIYRUFDK09XKKWSRQSK2XSLNYD7MN6O	6
975	PIW2O1HZHS	XFFLZJERBXPWTYX8K45385UV7L2QI074UAWFQG2GN209DY3AP9CSAUZ1UTONQYJLZVCTBSRDBZQFFUSIR2BJXO4AK5U62OZZTPKS	6
975	LRYG3OO7V2	K87R9RLETWABF6YXAXK1BIG7VKX90WZKAVH3D1Y7S51IU5XSACS290UB296Y4LO67ZATY5TI8NIGR7NZXE8XD7KJBGAD5ACHR4L4	8
975	0I32H8MU6T	D4FSK3WSOU4WGBZM03AP0SS4QN8KAYWWT4TK3E3DY1WVGRY8N50BLPEVLLC64LRZ8ICMRPTV960956Y8Z97F7VLEZ88SC6INJ6X8	4
975	98YTCMB2VA	LR7LFBOYFZOXDH5NM1N68XSQBTCYNZ9JZUNS932T7PTJU48ZN97FKBPY8RKV9ZKQZF7T4MNS939SDI6GVNLN249YEYTSSGTHFDTO	9
975	0IIQTWJMBK	O4AWOFQB7VZVEAVO6X5GJPF3592K2N9ZRJGTK1NYSWHD36OG82IPXIY9YH0ONGJTVAE53CDFKHXWHB98VVL9FUBIUH4DB8KMNXS2	8
975	5KUMKKEHEX	TM5ZDFQVB1WH1324JOA95KWI9EL7KJTTHGBIQKCPUXSQH6JFSSDJS27I0XZ83SK2HDAV1TO9MVOI1FAD5FP2FKBOJ3R2VDVCM0ID	9
975	7FQKPIDC53	XN8DE76OYRVWWDXDRX7CVM8BVNI9M5B66GH2RZBMEAUM6F89784DLBKLP6R0Y6B2PYZP65W2VU7V1WFPOICNB8U566NUHKYH816I	4
975	I6JF0RW5IU	TDBMBR1DYT21BLP4X1QD4SASBVL50XAZ695FAB9R31IMU3F9IMK9QFVBDTKQG5NATC4BQK4W19KDKX8IQLXNNAJ1O4CR0TL7NH3R	9
975	5CPJU9L2PT	DS8SYIR4R0PVBA4IAXS3CXWIN5IXM0C3QKM2Y4Z2267DW5ZTRYMTLY6Q60F293S0XVE1XBTF80BFZSVRGZGYNTS2N658Z628OGPA	7
975	8P3KYCP9C1	76PEHVUW00OEXWKX3NECMN0FVPC7C1TDVZI20TF88FXFR4BKSLU3L7PTFKT1SXU9HLS7NR6JHGEG0UX0O2P1GZ1XKZXQAOPKVY8G	3
975	B09BUMIAAB	D6AOKVE2I3UW2N0I32RT4XY3QJ314VBWQOK5OM5EX5B5D3HAYC25RXQQIG8B2N8X27FND53Q7N59V20XB2C13FF373XHO3LK6ODF	6
975	SMUHZ6ZLPE	373IL7D1R5PQK9AKG4W2MPJIWBEBVCHZU9I4JSRHBBQ8H0D4L9ZTRNKNYVWK3CGOX06L1FBXNO0K9KA57JZWNXHHY4GY6GO95CLQ	8
975	UIXWT83ZC0	2CG8BGCW9ONU0MTMTB9SYW79N1GA1P79UAFHTYLRFUYP2DF44WLAL7GGFHVK9C4UROA0HM350SND7RGJVMGFD6YW48CMDARC0E8O	1
975	G6YJUIUX8N	PWR2QK2UCIXALZX6YRU0O5IKR2ZBKN3T2GFZYNWW5C2ZOL1L3GBWNXYUOHLXV1JYPEHET8HL484LDS6FANHELGFERVKRB9AE2DKK	2
975	4T71U0G3GP	W25802P3MQ6KGXHTFNJ8CW7X0J570TAIVANVMFVNZLFEOG5L3UX0ALBA4HIQ7SC3QXZFJWH916J1R3JTOTEF5KIK9N0F7FQHJLY0	5
975	5ZJ4TJAB4I	0CGNY8DCKSB7YCNN68GPOF55BCVPBRGESCXR72HLEIY5ZIIDC3MMRLCUGKLVMXA2L6OWO6PD14LGRAG34SNHF3WH9DKXRV9QH6T2	8
\.


--
-- TOC entry 2087 (class 2606 OID 45446)
-- Name: _cast _cast_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT _cast_pk PRIMARY KEY ("character", person_id, movie_id);


--
-- TOC entry 2089 (class 2606 OID 45454)
-- Name: country country_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pk PRIMARY KEY (country_id);


--
-- TOC entry 2081 (class 2606 OID 45425)
-- Name: crew crew_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT crew_pk PRIMARY KEY (person_id, movie_id, job_name);


--
-- TOC entry 2069 (class 2606 OID 45377)
-- Name: department department_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pk PRIMARY KEY (department_id);


--
-- TOC entry 2073 (class 2606 OID 45393)
-- Name: genre genre_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY genre
    ADD CONSTRAINT genre_pk PRIMARY KEY (genre_id);


--
-- TOC entry 2071 (class 2606 OID 45385)
-- Name: job job_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pk PRIMARY KEY (job_name);


--
-- TOC entry 2075 (class 2606 OID 45401)
-- Name: member member_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pk PRIMARY KEY (member_login);


--
-- TOC entry 2083 (class 2606 OID 45430)
-- Name: movie_genre movie_genre_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT movie_genre_pk PRIMARY KEY (movie_id, genre_id);


--
-- TOC entry 2079 (class 2606 OID 45417)
-- Name: movie movie_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie
    ADD CONSTRAINT movie_pk PRIMARY KEY (movie_id);


--
-- TOC entry 2091 (class 2606 OID 45459)
-- Name: movie_productioncountry movie_productioncountry_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT movie_productioncountry_pk PRIMARY KEY (country_id, movie_id);


--
-- TOC entry 2077 (class 2606 OID 45409)
-- Name: person person_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pk PRIMARY KEY (person_id);


--
-- TOC entry 2085 (class 2606 OID 45438)
-- Name: review review_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pk PRIMARY KEY (movie_id, member_login);


--
-- TOC entry 2223 (class 2618 OID 45532)
-- Name: top100director _RETURN; Type: RULE; Schema: moviedb; Owner: postgres
--

CREATE RULE "_RETURN" AS
    ON SELECT TO top100director DO INSTEAD  SELECT p.person_id,
    p.name,
    avg(m.vote_average) AS vote_average
   FROM (((person p
     JOIN crew c ON ((p.person_id = c.person_id)))
     JOIN movie m ON ((c.movie_id = m.movie_id)))
     JOIN job j ON (((j.job_name)::text = (c.job_name)::text)))
  WHERE ((j.job_name)::text = 'Director'::text)
  GROUP BY p.person_id
  ORDER BY (avg(m.vote_average)) DESC
 LIMIT 100;


--
-- TOC entry 2104 (class 2620 OID 45523)
-- Name: review on_insert_into_review; Type: TRIGGER; Schema: moviedb; Owner: postgres
--

CREATE TRIGGER on_insert_into_review AFTER INSERT ON review FOR EACH ROW EXECUTE PROCEDURE vote_average();


--
-- TOC entry 2094 (class 2606 OID 45485)
-- Name: crew czlowiek_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT czlowiek_ekipa_fk FOREIGN KEY (person_id) REFERENCES person(person_id);


--
-- TOC entry 2100 (class 2606 OID 45480)
-- Name: _cast czlowiek_obsada_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT czlowiek_obsada_fk FOREIGN KEY (person_id) REFERENCES person(person_id);


--
-- TOC entry 2092 (class 2606 OID 45460)
-- Name: job dzial_praca_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY job
    ADD CONSTRAINT dzial_praca_fk FOREIGN KEY (department_id) REFERENCES department(department_id);


--
-- TOC entry 2095 (class 2606 OID 45510)
-- Name: crew film_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT film_ekipa_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- TOC entry 2097 (class 2606 OID 45505)
-- Name: movie_genre film_film_gatunek_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT film_film_gatunek_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- TOC entry 2102 (class 2606 OID 45490)
-- Name: movie_productioncountry film_film_krajprodukcji_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT film_film_krajprodukcji_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- TOC entry 2101 (class 2606 OID 45495)
-- Name: _cast film_obsada_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT film_obsada_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- TOC entry 2099 (class 2606 OID 45500)
-- Name: review film_recenzja_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT film_recenzja_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- TOC entry 2096 (class 2606 OID 45470)
-- Name: movie_genre gatunek_film_gatunek_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT gatunek_film_gatunek_fk FOREIGN KEY (genre_id) REFERENCES genre(genre_id);


--
-- TOC entry 2103 (class 2606 OID 45515)
-- Name: movie_productioncountry kraj_film_krajprodukcji_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT kraj_film_krajprodukcji_fk FOREIGN KEY (country_id) REFERENCES country(country_id);


--
-- TOC entry 2093 (class 2606 OID 45465)
-- Name: crew praca_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT praca_ekipa_fk FOREIGN KEY (job_name) REFERENCES job(job_name);


--
-- TOC entry 2098 (class 2606 OID 45475)
-- Name: review uzytkownik_recenzja_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT uzytkownik_recenzja_fk FOREIGN KEY (member_login) REFERENCES member(member_login);


-- Completed on 2017-02-02 19:12:30

--
-- PostgreSQL database dump complete
--

