--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: moviedb; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA moviedb;


ALTER SCHEMA moviedb OWNER TO postgres;

SET search_path = moviedb, pg_catalog;

--
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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: _cast; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE _cast (
    "character" character varying NOT NULL,
    person_id integer NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE _cast OWNER TO postgres;

--
-- Name: country; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE country (
    country_id character varying NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE country OWNER TO postgres;

--
-- Name: country_of_origin; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE country_of_origin (
    country_of_origin_id integer NOT NULL,
    person_id integer NOT NULL,
    country_id character varying NOT NULL
);


ALTER TABLE country_of_origin OWNER TO postgres;

--
-- Name: country_of_origin_country_of_origin_id_seq; Type: SEQUENCE; Schema: moviedb; Owner: postgres
--

CREATE SEQUENCE country_of_origin_country_of_origin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_of_origin_country_of_origin_id_seq OWNER TO postgres;

--
-- Name: country_of_origin_country_of_origin_id_seq; Type: SEQUENCE OWNED BY; Schema: moviedb; Owner: postgres
--

ALTER SEQUENCE country_of_origin_country_of_origin_id_seq OWNED BY country_of_origin.country_of_origin_id;


--
-- Name: crew; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE crew (
    person_id integer NOT NULL,
    movie_id integer NOT NULL,
    job_name character varying NOT NULL
);


ALTER TABLE crew OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE department (
    department_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE department OWNER TO postgres;

--
-- Name: genre; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE genre (
    genre_id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE genre OWNER TO postgres;

--
-- Name: job; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE job (
    job_name character varying NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE job OWNER TO postgres;

--
-- Name: member; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE member (
    member_login character varying NOT NULL,
    email character varying NOT NULL,
    password_hash character varying NOT NULL
);


ALTER TABLE member OWNER TO postgres;

--
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
-- Name: movie_genre; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE movie_genre (
    movie_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE movie_genre OWNER TO postgres;

--
-- Name: movie_productioncountry; Type: TABLE; Schema: moviedb; Owner: postgres
--

CREATE TABLE movie_productioncountry (
    movie_productioncountry_id integer NOT NULL,
    country_id character varying NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE movie_productioncountry OWNER TO postgres;

--
-- Name: movie_productioncountry_movie_productioncountry_id_seq; Type: SEQUENCE; Schema: moviedb; Owner: postgres
--

CREATE SEQUENCE movie_productioncountry_movie_productioncountry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movie_productioncountry_movie_productioncountry_id_seq OWNER TO postgres;

--
-- Name: movie_productioncountry_movie_productioncountry_id_seq; Type: SEQUENCE OWNED BY; Schema: moviedb; Owner: postgres
--

ALTER SEQUENCE movie_productioncountry_movie_productioncountry_id_seq OWNED BY movie_productioncountry.movie_productioncountry_id;


--
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
-- Name: country_of_origin country_of_origin_id; Type: DEFAULT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country_of_origin ALTER COLUMN country_of_origin_id SET DEFAULT nextval('country_of_origin_country_of_origin_id_seq'::regclass);


--
-- Name: movie_productioncountry movie_productioncountry_id; Type: DEFAULT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry ALTER COLUMN movie_productioncountry_id SET DEFAULT nextval('movie_productioncountry_movie_productioncountry_id_seq'::regclass);


--
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
Captain Benjamin L. Willard	8349	28
Colonel Walter E. Kurtz	3084	28
Lieutenant Colonel Bill Kilgore	3087	28
Tyrone 'Clean' Miller	2975	28
Lance B. Johnson	8350	28
Jay 'Chef' Hicks	8351	28
Chief Phillips	8354	28
Colonel Lucas	3	28
Photojournalist	2778	28
General Corman	3173	28
Jerry, Civilian	8346	28
Supply Sergeant	80874	28
Lieutenant Richard M. Colby	349	28
Kilgore's Gunner	1739	28
Mike from San Diego	1402117	28
Miss May	13023	28
Playmate of the Year	550106	28
Playmate	1664821	28
Soldier in Trench	14320	28
Machine Gunner	159948	28
AFRS Announcer	103853	28
Lieutenant Carlsen	1532851	28
Agent	65553	28
Johnny from Malibu / Mike from San Diego	1391387	28
Soldier with Colby (uncredited)	43524	28
Soldier (uncredited)	107323	28
Soldier (uncredited)	1073850	28
Soldier (uncredited)	57925	28
Eagle Thrust Seven Helicopter Pilot (uncredited)	8655	28
Extra (uncredited)	45581	28
Extra (uncredited)	6952	28
TV Photographer (uncredited)	7202	28
Director of TV Crew (uncredited)	1776	28
Bit Part (uncredited)	107322	28
Helicopter Skid Marine (uncredited)	1604873	28
Octavio	258	55
Susana	259	55
Valeria	261	55
Daniel	262	55
El Chivo	263	55
Luis	264	55
Gustavo	265	55
Jorge	266	55
Mauricio	267	55
Tía Luisa	268	55
Mama Susana	269	55
Mama Octavio	270	55
Leonardo	271	55
Maru	272	55
Ramiro	260	55
Julieta	553140	55
Jarocho	18468	55
Alvaro	127825	55
El jaibo	1197402	55
Doctor	23875	55
Conductor de T.V.	174434	55
Hombre deshuesadero	1044057	55
Judicial	132018	55
Andrés Salgado	1234762	55
El Chispas	1660431	55
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
Valentine Dussaut	1350	110
Richter Joseph Kern	1352	110
Auguste Bruner	1356	110
Karin	1354	110
Le photographe	49025	110
Le Vétérinaire	27983	110
Karol Karol	1145	110
Julie Vignon (de Courcy)	1137	110
Dominique	1146	110
Olivier	1138	110
Tony Montana	1158	111
Manny Ribera	1159	111
Elvira Hancock	1160	111
Gina Montana	1161	111
Frank Lopez	1162	111
Mama Montana	1163	111
Omar Suarez	1164	111
Alejandro Sosa	1165	111
Mel Bernstein	1166	111
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
Himself (uncredited)	139002	132
Captain James T. Kirk	1748	152
Mr. Spock	1749	152
Lt. Cmdr. Hikaru Sulu	1752	152
Montgomery Scott	1751	152
Lt. Pavel Chekov	1754	152
Lt. Cmdr. Uhura	1753	152
Dr. Leonard McCoy	1750	152
Dr. Christine Chapel	1755	152
Capt./Cmdr. Willard Decker	1756	152
Lieutenant Ilia	1757	152
CPO Janice Rand	1759	152
Klingon Captain	1820	152
Alien Boy	168423	152
Epsilon Technician	44054	152
Airlock Technician	178145	152
Crew Member	72658	152
Jacques Mayol	1642	175
Enzo Molinari	1003	175
Johana Baker	2165	175
Dr. Laurence	1165	175
Novelli	2166	175
Uncle Louis	2168	175
Roberto	2170	175
Duffy	2171	175
Priest	2172	175
Bonita	2173	175
Sally	2174	175
Young Jacques	2175	175
Young Enzo	2180	175
Jacques Father	2181	175
Dr. Lawrence Gordon	2130	176
Maria Tura	2491	198
Joseph Tura	2492	198
Leutnant Stanislav Sobinski	2493	198
Greenberg	2494	198
Rawitch	2495	198
Professor Alexander Siletsky	2496	198
SS-Gruppenführer Ehrhardt	2497	198
Bronski	2501	198
Dobosh, Regisseur	2502	198
Sturmführer Schultz	1510	198
Anna, Garderobiere	2503	198
Dr. Zefram Cochrane	2505	199
Lily Sloane	1981	199
Borg Queen	2506	199
Lieutenant Hawk	2203	199
Captain Jean-Luc Picard	2387	199
Lt. Commander Data	1213786	199
Commander Geordi La Forge	2390	199
Lieutenant Commander Worf	2391	199
Commander Beverly Crusher	2392	199
Ships Counselor Commander Deanna Troi	2393	199
	2797	222
'Maxim' de Winter	3359	223
Mrs. de Winter (2nd)	3360	223
Jack Favell	3361	223
Mrs. Danvers	3362	223
Major Giles Lacy	3363	223
Frank Crawley	3364	223
Beatrice Lacy	3366	223
Mrs. Edythe Van Hopper	3367	223
Dr. Baker	2642	223
Ben	3368	223
Tabbs	3369	223
Frith	3370	223
Chalcroft	3371	223
Robert	3372	223
Man outside phone booth	2636	223
Colonel Julyan	2438	223
Policeman	100763	223
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
Richard Hannay	3609	260
Pamela	3610	260
Miss Annabelle Smith	3611	260
Professor Jordan	3612	260
Margaret, Crofter's Wife	3672	260
John Crofter	3673	260
Mrs. Louisa Jordan	3674	260
Sheriff Watson	3675	260
Mr. Memory	3676	260
Commercial Traveller	553488	260
Commercial Traveller	27946	260
Mr. Jordan's Maid	3677	260
M.C. Who Introduces Mr Memory (uncredited)	1530685	260
Passerby Near the Bus (uncredited)	2636	260
Pat, Professor Jordan's Daughter (uncredited)	3678	260
The Milkman (uncredited)	3679	260
Innkeeper's Wife (uncredited)	3680	260
Maggie	3635	261
C.C. Baxter	3151	284
Fran Kubelik	4090	284
Jeff D. Sheldrake	4091	284
Joe Dobisch	4093	284
Dr. Dreyfuss	4094	284
Mrs. Mildred Dreyfuss	4096	284
Mrs. Margie MacDougall	4097	284
Miss Olsen	4098	284
Sylvia	3161	284
Karl Matuschka	4099	284
Al Kirkeby	571911	284
The Blonde	40381	284
Mr. Vanderhoff	87517	284
Mr. Eichelberger	141694	284
Office Worker (uncredited)	1234545	284
Office Worker (uncredited)	1551605	284
Office Maintenance Man (uncredited)	1250242	284
TV Movie Host (uncredited)	16527	284
Charlie - Bartender (uncredited)	120555	284
Elevator Supervisor with Clicker (uncredited)	98166	284
Bit Part (uncredited)	1225439	284
Messenger (uncredited)	153413	284
Man in Santa Claus Suit (uncredited)	25627	284
Don Pietro Pellegrini	4420	307
Pina	4421	307
Francesco	4425	307
Luigi Ferrari, alias Giorgio Manfredi	4422	307
Il maggiore Fritz Bergmann	4424	307
Marina Mari	4426	307
Marcello, figlio di Pina	4423	307
Il desertore austriaco	5001	307
Il capitano Hartmann	5002	307
Lauretta, sorella di Pina	5003	307
Ingrid	18337	307
Agostino the Sexton	132194	307
Neighborhood Police Sergeant	374218	307
Police Commissioner	32669	307
Grandfather (uncredited)	132479	307
Nannina (uncredited)	1459391	307
The Priest (uncredited)	543796	307
Clarence Worley	2224	319
Alabama Whitman	4687	319
Dick Ritchie	4688	319
Elliot Blitzer	4689	319
Drexl Spivey	64	319
Clifford Worley	2778	319
Vincenzo Coccotti	4690	319
Floyd	287	319
Cody Nicholson	3197	319
Big Don	2231	319
Lee Donowitz	3712	319
Virgil	4691	319
Frankie	4692	319
Marty	4693	319
Mentor	5576	319
Nicky Dimes	2969	319
Lucy	3711	319
Boris	41125	319
Linda Partridge	1231	334
Donnie Smith	3905	334
Jim Kurring	4764	334
Frank T.J. Mackey	500	334
Jimmy Gator	4492	334
Phil Parma	1233	334
Earl Partridge	4765	334
Solomon Solomon	658	334
Claudia Wilson Gator	4766	334
Rick Spector	2234	334
Stanley Spector	4779	334
Dixon	4777	334
Rose Gator	4778	334
Gwenovier	10691	334
Cynthia	7427	334
Worm	18270	334
Narrator/Burt Ramsey	10743	334
Delmer Darion	10872	334
Stanley Berry	43776	334
Thurston Howell	19439	334
Faye Barringer	6199	334
Alan Kligman Esq.	4776	334
Mrs. Godfrey	1591432	334
Sir Edmund William Godfrey / Young Pharmacy Kid	60846	334
Young Jimmy Gator	11155	334
Luis	40481	334
WDKK Floor Director	9048	334
Dentist Nurse #1	98365	334
Chad, Seduce & Destroy	1219029	334
Ripley	10205	348
Dallas	4139	348
Lambert	5047	348
Brett	5048	348
Kane	5049	348
Ash	65	348
Parker	5050	348
Alien	5051	348
Mother (voice)	5052	348
Alien (uncredited)	1077325	348
Lt. Thompson	11163	377
Marge Thompson	13652	377
Nancy Thompson	5141	377
Tina Gray	13656	377
Rod Lane	13657	377
Glen Lantz	85	377
Freddy Krueger	5139	377
Hall Guard	1538594	377
Sgt. Garcia	13661	377
Dr. King	12826	377
Sgt. Parker	13660	377
Teacher	7401	377
Nurse	13662	377
Foreman	7219	377
Minister	190793	377
Mr. Lantz	120106	377
Mrs. Lantz	1698597	377
Coroner	11408	377
Mrs. Gray	1698598	377
Boyfriend	1698599	377
Surfer	224322	377
Surfer	1679939	377
Cop	42820	377
Cop	1698600	377
Cop	1698601	377
Kid	1698602	377
Kapitän-Leutnant Heinrich Lehmann-Willenbrock	920	387
Leutnant Werner	5228	387
Der Leitende/Fritz Grade	5229	387
1WO	5230	387
2WO	4924	387
Kriechbaum/Navigator	2349	387
Johann	3970	387
Ullmann	5232	387
Hinrich	5233	387
Bosun	682	387
Ario	5234	387
Pilgrim	5235	387
Frenssen	4922	387
Phillip Thomsen	2311	387
Leutnant Müller	5012	387
Preacher	39325	387
Schwalle	28114	387
Bockstiegel	1136687	387
Dufte	1649330	387
Monique	574349	387
Captain of the 'Weser'	9932	387
Benjamin	1346868	387
Hagen	1665127	387
Schmutt	1665128	387
Franz	1665129	387
Markus	38601	387
Erster WO Merkel (uncredited)	1665130	387
Françoise (uncredited)	1665131	387
Nadine (uncredited)	1170466	387
Hoke Colburn	192	403
Daisy Werthan	5698	403
Boolie Werthan	707	403
Florine Werthan	5699	403
Idella	5700	403
Miss McClatchey	5701	403
Oscar	5702	403
Nonie	5703	403
Miriam	5704	403
Beulah	5705	403
Dr. Weil	1403815	403
Neighbor Lady	1403817	403
Katie Bell	937317	403
Red Mitchell	43992	403
Trooper #1	1472	403
Girl at Temple (uncredited)	569901	403
Manny (voice)	15757	425
Sid (voice)	5723	425
Diego (voice)	5724	425
Soto (voice)	5725	425
Zeke (voice)	70851	425
Carl (voice)	5726	425
Rhino / Start (voice)	17401	425
Saber-Toothed Tiger (voice)	5727	425
Lenny / Oscar / Dab (voice)	21088	425
Jennifer (voice)	60019	425
Rachel (voice)	13636	425
Dodo / Macrauchenia (voice)	5717	425
Dodo (voice)	1446460	425
Dodo / Scrat (voice)	52419	425
Glyptodon (voice)	5713	425
Glyptodont (voice)	59695	425
Baby Moeritherium (voice)	102794	425
Dodo (voice) (uncredited)	1446462	425
Sonja	4794	446
Katharina	6083	446
Ingo	6086	446
Andreas	6082	446
Philip	6091	446
Klaus	1081	446
Kolja	6079	446
Dimitri	6080	446
Anna	6081	446
Marko	6084	446
Maik	6085	446
Simone	6087	446
Antoni	1145	446
Milena	6088	446
Marysia	6089	446
Christoph	6090	446
Beata	6092	446
Wilke	6093	446
Clyde Barrow	6449	475
Bonnie Parker	6450	475
C.W. Moss	6451	475
Eugene Grizzard	3460	475
Buck Barrow	193	475
Blanche	6461	475
Frank Hamer	6462	475
Ivan Moss	6463	475
Velma Davis	6464	475
Bonnie's mother	6798	475
Bank Teller (uncredited)	58513	475
Policeman (uncredited)	1213032	475
Deputy (uncredited)	170523	475
Bank Guard (uncredited)	999538	475
Bonnie's Sister (uncredited)	91988	475
Sheriff Smoot (uncredited)	166358	475
Antonius Block	2201	490
Jöns	6649	490
Death	6656	490
Jof	6658	490
Mia	6657	490
Lisa, Plog's wife	6659	490
Witch	6660	490
Karin, Block's wife	6661	490
Mute girl	6662	490
Raval	6663	490
Monk	6664	490
Plog the smith	6665	490
Albertus Pictor, church painter	6666	490
Jonas Skat	6667	490
Knight (uncredited)	403150	490
Woman at inn (uncredited)	58305	490
The young monk (uncredited)	231921	490
Merchant at the inn (uncredited)	550014	490
Farmer at the inn (uncredited)	321845	490
The landlord (uncredited)	1194870	490
Mikael, Jof and Maria's son (uncredited)	1194871	490
Man (uncredited)	34774	490
Man (uncredited)	244278	490
Young pregnant woman (uncredited)	32729	490
Old man at the inn (uncredited)	1194872	490
Man (uncredited)	1194873	490
Young woman kneeling for the flagellants (uncredited)	1186207	490
Young woman kneeling for the flagellants (uncredited)	1194874	490
Knight Commander (uncredited)	131579	490
Knight (uncredited)	1194875	490
Old man addressed by the monk (uncredited)	1194876	490
Cléo Victoire, Florence	7565	499
Antoine	7566	499
Angèle	7568	499
Dorothée	1151713	499
Bob, the Pianist	10934	499
The Lover	590099	499
Irma	1423674	499
Mr. White/Larry Dimmick	1037	500
Mr. Orange/Freddy Newandyke	3129	500
Mr. Blonde/Vic Vega	147	500
Nice Guy Eddie Cabot	2969	500
Mr. Pink	884	500
Joe Cabot	6937	500
Mr. Blue	6939	500
Mr. Brown	138	500
Detective Holdaway	6938	500
Officer Marvin Nash	3206	500
K-Billy DJ (voice)	3214	500
Tony Wendice	7124	521
Margot Mary Wendice	4070	521
Mark Halliday	7125	521
Chief Insp. Hubbard	5182	521
Charles Alexander Swann aka Captain Lesgate	7682	521
Storyteller	1217924	521
Detective Pearson	73980	521
Detective Williams	933880	521
Woman exiting airplane	121323	521
Police Sergeant O'Brien	87518	521
Detective (uncredited)	9923	521
Man in Phone Booth (uncredited)	1216356	521
Man at Tony's Table at the Dinner in Photograph (uncredited)	2636	521
Men's Club Party Member (uncredited)	171111	521
Policeman Outside Wendice Flat (uncredited)	14573	521
Judge at Margot's Trial (uncredited)	141067	521
Detective (uncredited)	380051	521
Bobby (uncredited)	1629431	521
Jean-Claude	7275	537
Françoise	7276	537
Père de Jean-Claude	7277	537
Thierry, Fiancé de Françoise	7278	537
Jean-Yves, Fils de Jean-Claude	7279	537
Mère de Françoise	7280	537
Soeur de Françoise	7281	537
La secrétaire	7282	537
Le dragueur cours de tango	7283	537
Rose Diakité	7284	537
Le médecin	7285	537
Pedro Lombardi	7286	537
L'aide-soignante	7287	537
Tajômaru	7450	548
Masako	7451	548
Takehiro	7452	548
Woodcutter	7453	548
Priest	7454	548
Commoner	7455	548
Medium	7456	548
Policeman	7457	548
Jean Michel Basquiat	2954	549
Grace Margaret Mulligan	2227	553
Gloria	7569	553
Ma Ginger	7570	553
Man with the big Hat	1642	553
Tom Edison	6162	553
Mrs. Henson	7571	553
The Big Man	3085	553
Vera	1276	553
Bill Henson	4654	553
Jack McKay	856	553
Tom Edison Senior	4492	553
Gangster	7572	553
Martha	6751	553
Ben	6752	553
Gangster	6758	553
Man in the Coat	1646	553
Olivia	7574	553
Jason	7575	553
Mr. Henson	7576	553
Liz Henson	2838	553
June	7577	553
Chuck	1640	553
Athena	7578	553
Olympia	7579	553
Pandora	7580	553
Diana	7581	553
Dahlia	7582	553
Narrator (voice)	5049	553
Additional Cast	1480036	553
Additional Cast	135708	553
Additional Cast	1378316	553
Dr. Ben McKenna	854	574
Jo McKenna	8237	574
Lucy Drayton	8238	574
Edward Drayton	8239	574
Val Parnell	8240	574
Jan Peterson	8241	574
Hank McKenna	8242	574
Louis Bernard	24814	574
Assassin at Albert Hall	15972	574
Conductor at Albert Hall	1045	574
Cindy Fontaine	19109	574
Helen Parnell	236479	574
Assistant Manager	85935	574
Buchanan	89064	574
Ambassador	975645	574
Woburn	14015	574
Police Inspector	35591	574
Handyman (uncredited)	118452	574
Worker at the Taxidermist's (uncredited)	78902	574
Taxidermist (uncredited)	1580608	574
Taxidermist (uncredited)	1567845	574
Taxidermist (uncredited)	1063842	574
Sir Kenneth Clarke (uncredited)	1393333	574
Church Member (uncredited)	1550460	574
Church Member (uncredited)	569321	574
Church Member (uncredited)	1551021	574
Church Member (uncredited)	1145704	574
Church Member (uncredited)	1581066	574
French Policeman (uncredited)	153686	574
French Policeman (uncredited)	120700	574
French Policeman (uncredited)	33777	574
Royal Albert Hall Attendee (uncredited)	27164	574
Royal Albert Hall Attendee (uncredited)	1581070	574
Royal Albert Hall Attendee (uncredited)	1216356	574
Royal Albert Hall Attendee (uncredited)	1581072	574
Tom Joad	4958	596
Ma Joad	8515	596
Casy	8516	596
Grandpa Joad	8517	596
Rosasharn	8518	596
Pa Joad	8519	596
Al Joad	8520	596
Muley Graves	4119	596
Connie Rivers	8521	596
Grandma Joad	8522	596
Noah	34610	596
Uncle John	116661	596
Winfield	81481	596
Ruth Joad	567800	596
Thomas	112364	596
Caretaker	30215	596
Wilkie	13977	596
Davis	101881	596
Policeman	4303	596
Bert	105454	596
Bill	242238	596
Joe	115772	596
Inspection Officer	105810	596
Leader	30017	596
Proprietor	116494	596
Floyd	104714	596
Frank	190772	596
City Man	89728	596
Bookkeeper	3341	596
Tim	17759	596
Agent	102071	596
Muley's Son	567801	596
Spencer	95311	596
Driver	30530	596
Mae	148524	596
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
Michael McManus	9045	629
Dean Keaton	5168	629
US Customs Agent Dave Kujan	9046	629
Todd Hockney	7166	629
Kobayashi	4935	629
Roger 'Verbal' Kint	1979	629
Edie Finneran	2179	629
FBI Agent Jack Baer	4808	629
Fred Fenster	1121	629
Sgt. Jeffrey "Jeff" Rabin	6486	629
Smuggler	101377	629
Saul Berg	56166	629
Dr. Plummer	9047	629
Dr. Walters	9048	629
Arkosh Kovash	156227	629
Agent Strausz	3218	629
Agent Rizzi	1216752	629
Daniel "Dan" Metzheiser	1235937	629
Séverine Serizy	50	649
Henri Husson	3784	649
Pierre Serizy	9762	649
Madame Anais	9763	649
Marcel	17577	649
Charlotte	9765	649
Renée	9766	649
Graf	9767	649
Hyppolite	9768	649
Pallas	37464	649
Footman	104101	649
Majordomo	25976	649
Prof. Henri	938898	649
L'ensignant	28247	649
Monsieur Adolphe	39645	649
Man in Gardencafe - Left from the Duke (uncredited)	793	649
(uncredited)	40976	649
Barman (uncredited)	37140	649
Le grele (uncredited)	24422	649
Maria Braun	3734	661
Hermann Braun	9927	661
Karl Oswald	9928	661
Bill	9929	661
Mother	9930	661
Betti Klenze	9931	661
Willi Klenze	3757	661
Senkenberg	1865	661
Hans Wetzel	9932	661
Frau Ehmke	2740	661
Counsel	3769	661
Harry Potter	10980	673
Ron Weasley	10989	673
Hermione Granger	10990	673
Sirius Black	64	673
Professor Remus Lupin	11207	673
Professor Severus Snape	4566	673
Professor Albus Dumbledore	5658	673
Rubeus Hagrid	1923	673
Draco Malfoy	10993	673
Gregory Goyle	11212	673
Professor Trelawney	7056	673
Professor Minerva McGonagall	10978	673
Ginny Weasley	10991	673
Aunt Marge	11213	673
Uncle Vernon	10983	673
Lily Potter	10988	673
Molly Weasley	477	673
Fred Weasley	96851	673
Neville Longbottom	96841	673
Peter Pettigrew	9191	673
Argus Filch	11180	673
Dean Thomas	234923	673
Girl with Flowers	1507605	673
Madame Rosmerta	1666	673
Jeff Markham (aka Jeff Bailey)	10158	678
Kathie Moffat	10159	678
Whit Sterling	2090	678
Meta Carson	10160	678
Jimmy	10161	678
Jack Fisher	10162	678
Ann Miller	10163	678
Joe Stephanos	10164	678
The Kid	10165	678
Leonard Eels	10166	678
Marny	115366	678
Tillotson	114402	678
Mr. Miller	103068	678
Eunice Leonard	97042	678
Sheriff	34625	678
Lou	78305	678
Kibitzer in Blue Sky Club (uncredited)	115995	678
Kibitzer in Blue Sky Club (uncredited)	1420903	678
Kibitzer in Blue Sky Club (uncredited)	198219	678
Kibitzer in Blue Sky Club (uncredited)	1487177	678
Mexican Waiter (uncredited)	1204286	678
Mexican Waiter (uncredited)	1543340	678
Harlem Club Headwaiter (uncredited)	1063466	678
Woman at Harlem Club (uncredited)	120750	678
Doorman (uncredited)	101882	678
Bartender in Acapulco (uncredited)	1208020	678
Casino Patron (uncredited)	1596342	678
Restaurant Patron (uncredited)	1596347	678
Mrs. Miller (uncredited)	1271047	678
The Porter (uncredited)	1023934	678
Croupier (uncredited)	1331770	678
Man with Eunice (uncredited)	120308	678
Man in Nightclub Cloakroom (uncredited)	179327	678
Mystery Man (uncredited)	954389	678
Jose Rodriguez (uncredited)	1112109	678
Gaylord 'Greg' Focker	7399	693
Pam Byrnes	10399	693
Jack Byrnes	380	693
Bernie Focker	4483	693
Rozalin Focker	10400	693
Dina Byrnes	10401	693
Officer LeFlore	1462	693
Isabel Villalobos	10402	693
Judge Ira	10403	693
Kevin Rawley	887	693
Jorge Villalobos	52957	693
Little Jack 'L.J.' Byrnes	1003453	693
Little Jack 'L.J.' Byrnes	1003454	693
Flight Attendant	149665	693
Airline Clerk	155393	693
Rent-a-Car Agent	29795	693
Airport Security Guard	172201	693
Woody Focker	963693	693
Girl on Bus	1673124	693
Ada McGrath	18686	713
George Baines	1037	713
Alisdair Stewart	4783	713
Flora McGrath	10690	713
Mana	7248	713
Aunt Morag	10756	713
Hira	10755	713
Reverend	7255	713
Nessie	10760	713
Hone	7249	713
Chief Nihe	10761	713
Blind Piano Tuner	173431	713
Angel	53485	713
Tahu	1690610	713
Taunting Man	1404551	713
James Bond	517	714
Elliot Carver	378	714
Wai Lin	1620	714
Paris Carver	10742	714
Henry Gupta	10743	714
Stamper	10744	714
Jack Wade	10671	714
Elisabeth	6003	742
Rolf	6283	742
Eva	11038	742
Stefan	11039	742
Göran	11040	742
Lena	11041	742
Anna	11042	742
Ted	11043	742
Klas	11044	742
Lasse	11045	742
Erik	11046	742
Signe	11047	742
Birger	6004	742
Ragnar	11048	742
Margit	11049	742
Fredrik	11050	742
Måne	11051	742
Sigvard	11052	742
Ashley 'Ash' J. Williams	11357	765
Annie Knowby	11749	765
Jake	11750	765
Bobbie Joe	11751	765
Linda	11753	765
Ed Getley	11754	765
Professor Raymond Knowby	11755	765
Henrietta Knowby	11756	765
Possessed Henrietta	11769	765
Jane Smith	11701	787
John Smith	287	787
Eddie	4937	787
Benjamin Danz	11702	787
Jasmine	11703	787
Father	65827	787
Martin Coleman	3288	787
Suzy Coleman	11704	787
Gwen	11705	787
Julie - Associate #1	59156	787
Jade - Associate #2	41421	787
Janet - Associate #3	1347627	787
Jessie - Associate #4	68495	787
Jamie - Associate #5	1347628	787
Bodyguard #1	1667654	787
Robert Thorn	23626	806
Katherine Thorn	12041	806
Damien Thorn	12042	806
Keith Jennings	11207	806
Father Brennan	4935	806
Mrs. Baylock	12021	806
Vatican Observatory Priest	12044	806
Cardinal Fabretti	12045	806
Nanny	12046	806
Bugenhagen	5658	806
Father Spiletto	27277	806
Tabloid Reporter	11839	806
Damien - 2 Years Old	1134336	806
Damien - Newborn	1134337	806
Damien - Newborn	1134338	806
Damien - Newborn	1134339	806
Damien - Newborn	1134340	806
Cmdr. Shears	8252	826
Col. Nicholson	12248	826
Maj. Warden	10018	826
Col. Saito	12249	826
Maj. Clipton	12250	826
Lt. Joyce	12251	826
Col. Green	10029	826
Capt. Reeves	12252	826
Major Hughes	1075445	826
Grogan	33220	826
Baker	1208202	826
Nurse	964548	826
Captain Kanematsu	1075446	826
Lieutenant Miura	1075447	826
Siamese Girl	1748362	826
Nicole Horner	12266	827
Christina Delassalle	2569	827
Michel Delassalle	12267	827
Chow Mo-Wan	1337	844
Bai Ling	1339	844
Wang Jing Wen	12671	844
Tak	12670	844
Su Li-Zhen	643	844
Lulu/Mimi	12672	844
Ah Ping	12674	844
Su Li-Zhen	1338	844
Wang Jie Wen	12676	844
Bird	12675	844
cc 1966	1622	844
Mr Wang	1178957	844
Guy Haines	12497	845
Anne Morton	12498	845
Bruno Anthony	12499	845
Sen. Morton	2642	845
Barbara Morton	12500	845
Carly Norris	4430	867
Zeke Hawkins	13021	867
Jack Lansford	13022	867
Vida Warren	6416	867
Judy Marks	13023	867
Samantha Moore	13024	867
Alex Parsons	2641	867
Mrs. McEvoy	13026	867
Gus Hale	13027	867
Peter Farrell	13028	867
Jackie Kinsella	13029	867
Victoria Hendrix	30485	867
Reporter #2	1355189	867
Eric Stoner ("The Cincinnati Kid")	13565	886
Lancey Howard	13566	886
Melba Nile	13567	886
Shooter	9857	886
Christian Rudd	4514	886
Lady Fingers	13568	886
William Jefferson Slade	9626	886
Pig	726	886
Yeller	7173	886
Hoban	9596	886
Felix	45252	886
Sokal	101901	886
Mr. Rudd	12158	886
Cajun	178884	886
Danny	161405	886
Mrs. Rudd	98963	886
Mrs. Slade	121083	886
Dealer	6463	886
Old Man	1213187	886
Old Man	348497	886
Philly	30615	886
Hotel Desk Clerk	114961	886
Dr. Yuri Zhivago	5004	907
Lara Antipova	1666	907
Tonya Gromeko	400	907
Viktor Komarovsky	522	907
Gen. Yevgraf Zhivago	12248	907
Anna	14012	907
Alexander Gromeko	12689	907
Liberius	14014	907
Razin, Liberius' Lieutenant	14015	907
Petya	14016	907
Engineer at dam	14017	907
Sergei	14018	907
Kostoyed Amourski	14277	907
The Girl	47754	907
Pasha Antipov / Strelnikov	14011	907
The Bolshevik	63000	907
Medical Professor	10462	907
Amelia	2265	907
Beef-Faced Colonel	730346	907
Delegate	90627	907
Female Janitor	111326	907
The Train Jumper	102153	907
Political Officer	199919	907
Mrs. Sventytski (uncredited)	941312	907
Mr. Sventytski (uncredited)	37796	907
Militiaman (uncredited)	100901	907
Raped Woman (uncredited)	1443973	907
Hospital Inmate (uncredited)	32830	907
Major (uncredited)	1545347	907
Siberian Husband (uncredited)	1436363	907
Gentlewoman (uncredited)	231021	907
Priest (uncredited)	14822	907
Extra (uncredited)	32130	907
Extra (uncredited)	83739	907
Kostoyed (voice) (uncredited)	1375376	907
Susanne Wallner	14168	932
Dr. Mertens	14169	932
Frau Brückner	14170	932
Ferdinand Brückner	14171	932
Herbert	14173	932
Otto	14174	932
Mondschein	14175	932
Mutter des kranken Kindes	14176	932
Sonja	14177	932
Daisy	14178	932
Bartholomäus	14179	932
Carola Schulz.	14180	932
Fritz Knochenhauer	14181	932
Arzt	14182	932
Schwester	14183	932
Dienstmädchen	14184	932
Kundin	14185	932
Manny (voice)	15757	950
Sid (voice)	5723	950
Diego (voice)	5724	950
Ellie (voice)	15758	950
Crash (voice)	57599	950
Eddie (voice)	15760	950
Fast Tony (voice)	14991	950
Lone Gunslinger Vulture (voice)	21200	950
Scrat (voice)	5713	950
Dung Beetle Dad (voice)	5717	950
Glypto Boy Billy / Beaver Girl (voice)	1086503	950
Rhino Boy / Beaver Boy (voice)	1335105	950
Mr. Start (voice)	46946	950
Elk Boy (voice)	1335106	950
Condor Chick (voice)	7967	950
(voice)	42160	950
Female Mini Sloth (voice)	1215072	950
Detective John Kimble	1100	951
Joyce Palmieri / Rachel Crisp	14698	951
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
David Sumner	4483	994
Amy Sumner	14947	994
Tom Hedden	386	994
Major John Scott	14948	994
Charlie Venner	14949	994
Chris Cawsey	14950	994
Riddaway	14951	994
Norman Scutt	7194	994
Bobby Hedden	14952	994
Janice Hedden	14953	994
Harry Ware	14954	994
John Niles	14955	994
Louise Hood	14956	994
Reverend Barney Hood	14957	994
Henry Niles	2076	994
Dallas	14965	995
\.


--
-- Data for Name: country; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY country (country_id, name) FROM stdin;
FI	Finland
US	United States of America
MX	Mexico
JP	Japan
FR	France
DE	Germany
AU	Australia
GB	United Kingdom
IT	Italy
SE	Sweden
CN	China
DK	Denmark
CA	Canada
\.


--
-- Data for Name: country_of_origin; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY country_of_origin (country_of_origin_id, person_id, country_id) FROM stdin;
\.


--
-- Name: country_of_origin_country_of_origin_id_seq; Type: SEQUENCE SET; Schema: moviedb; Owner: postgres
--

SELECT pg_catalog.setval('country_of_origin_country_of_origin_id_seq', 1, false);


--
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
223	55	Director
273	55	Author
275	55	Director of Photography
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
1126	110	Director
1134	110	Producer
1126	110	Author
1132	110	Author
1135	110	Original Music Composer
1346	110	Original Music Composer
1136	110	Editor
33238	110	Director of Photography
1126	110	Screenplay
1132	110	Screenplay
1744	152	Director
1745	152	Producer
1747	152	Screenplay
1760	152	Original Music Composer
1761	152	Original Music Composer
1762	152	Director of Photography
1765	152	Production Design
1767	152	Editor
1768	152	Casting
16252	152	Producer
1763	152	Art Direction
1802	152	Art Direction
1096	152	Art Direction
602	152	Set Decoration
1801	152	Costume Design
406204	152	Makeup Artist
1746	152	Story
59	175	Director
59	175	Author
2158	175	Author
2159	175	Author
2160	175	Director of Photography
996	175	Original Music Composer
60	175	Producer
2183	175	Editor
2186	175	Casting
1000	175	Production Design
2187	175	Sound Designer
59	175	Producer
2799	175	Author
2800	175	Author
2489	198	Author
2428	198	Director
2490	198	Producer
2428	198	Producer
2428	198	Author
2498	198	Author
11593	198	Director of Photography
2500	198	Original Music Composer
70	222	Author
2792	222	Author
2793	222	Original Music Composer
2794	222	Director of Photography
2795	222	Director of Photography
70	222	Director of Photography
2796	222	Director of Photography
70	222	Producer
2798	222	Director
2798	222	Author
2798	222	Editor
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
2636	260	Director
3601	260	Producer
3604	260	Original Music Composer
3606	260	Director of Photography
3607	260	Editor
3608	260	Sound Designer
3613	260	Original Music Composer
1653023	260	Novel
3681	260	Script Supervisor
27918	260	Dialogue
3599	260	Adaptation
3146	284	Producer
4100	284	Original Music Composer
4101	284	Director of Photography
4102	284	Editor
4103	284	Art Direction
4104	284	Set Decoration
4105	284	Makeup Artist
4106	284	Production Manager
4107	284	Special Effects
4108	284	Gaffer
3146	284	Director
4410	307	Director
4411	307	Producer
4412	307	Producer
4410	307	Producer
4416	307	Original Music Composer
4417	307	Director of Photography
4418	307	Editor
4419	307	Production Design
4428	307	Sound Designer
22472	307	Editor
4414	307	Additional Writing
4410	307	Additional Writing
4413	307	Story
4413	307	Screenplay
4415	307	Screenplay
4410	307	Screenplay
54928	307	Producer
893	319	Director
138	319	Screenplay
8297	319	Screenplay
4507	319	Producer
4695	319	Co-Producer
4697	319	Producer
4699	319	Producer
4700	319	Executive Producer
4701	319	Co-Producer
4702	319	Producer
947	319	Original Music Composer
904	319	Director of Photography
908	319	Editor
6668	319	Editor
4710	319	Production Design
795	319	Art Direction
4762	334	Director
4762	334	Screenplay
4762	334	Producer
4767	334	Executive Producer
4768	334	Executive Producer
578	348	Director
5045	348	Screenplay
5053	348	Producer
915	348	Producer
1723	348	Producer
5054	348	Producer
5046	348	Executive Producer
1760	348	Original Music Composer
5055	348	Director of Photography
5056	348	Editor
5057	348	Editor
4616	348	Production Design
5058	348	Production Design
5058	348	Art Direction
5059	348	Art Direction
5060	348	Set Decoration
5061	348	Costume Design
5062	348	Sound Editor
9136	348	Production Design
9402	348	Special Effects
23349	348	Casting
668	348	Casting
5046	348	Writer
1378834	348	Assistant Art Director
1339072	387	Music Editor
1339061	387	Makeup Artist
1339062	387	Makeup Artist
1339063	387	Makeup Artist
572622	403	ADR & Dubbing
5696	403	Director
5697	403	Author
5697	403	Screenplay
5322	403	Executive Producer
5706	403	Producer
5697	403	Producer
5707	403	Producer
1297	403	Producer
947	403	Original Music Composer
5708	403	Director of Photography
1732	403	Editor
5709	403	Production Design
3188	403	Art Direction
945	403	Set Decoration
5710	403	Costume Design
5712	403	Music Editor
1440853	403	First Assistant Editor
5713	425	Director
5714	425	Director
5716	425	Screenplay
5715	425	Screenplay
5717	425	Screenplay
5719	425	Producer
5720	425	Executive Producer
5721	425	Editor
3393	425	Original Music Composer
5718	425	Associate Producer
87059	425	Additional Writing
87059	425	Animation
5715	425	Story
1604000	425	Additional Writing
1604001	425	Additional Writing
229962	425	Additional Writing
6094	446	Director
6094	446	Screenplay
6095	446	Screenplay
5195	446	Editor
6096	446	Director of Photography
6097	446	Set Designer
4525	446	Producer
4526	446	Producer
1163290	446	Music
6448	475	Director
6449	475	Producer
6452	475	Director of Photography
6453	475	Editor
2875	475	Art Direction
6454	475	Set Decoration
6455	475	Costume Design
173929	475	Stunts
1331195	475	Stunts
1461972	475	Stunts
6459	475	Original Music Composer
6728	475	Screenplay
6729	475	Screenplay
11057	475	Writer
16193	475	Makeup Artist
1529473	475	Production Manager
46608	475	Assistant Director
6648	490	Director
6650	490	Producer
6651	490	Original Music Composer
6817	499	Director
6817	499	Producer
6817	499	Screenplay
10934	499	Original Music Composer
19086	499	Director of Photography
24296	499	Production Design
3538	499	Art Direction
1423673	499	Costume Design
3779	499	Producer
3778	499	Producer
2636	521	Director
2636	521	Producer
7123	521	Author
4082	521	Original Music Composer
2654	521	Director of Photography
7126	521	Editor
7127	521	Art Direction
4126	521	Set Decoration
4313	521	Makeup Artist
7128	521	Sound Designer
1514138	521	Makeup Artist
1533647	521	Sound
76160	521	Assistant Director
1556114	521	Property Master
7271	536	Director
7271	536	Author
7271	536	Sound Designer
7271	536	Director of Photography
7272	536	Editor
7288	537	Director
7288	537	Screenplay
7289	537	Screenplay
7290	537	Producer
5426	537	Producer
7291	537	Original Music Composer
7292	537	Original Music Composer
7293	537	Director of Photography
7294	537	Editor
7295	537	Casting
5026	548	Director
7448	548	Novel
5026	548	Screenplay
7449	548	Screenplay
7458	548	Producer
7459	548	Executive Producer
7460	548	Original Music Composer
7461	548	Director of Photography
5026	548	Editor
7462	548	Production Design
1267600	548	Lighting Technician
1513913	548	Art Direction
239213	548	Assistant Director
83199	548	Assistant Director
1273295	548	Assistant Director
1578078	548	Sound
1111737	548	Sound
554162	548	First Assistant Camera
1143488	548	Lighting Production Assistant
143707	548	Script Supervisor
42	553	Director
42	553	Screenplay
7583	553	Producer
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
670	612	Sound Designer
9032	629	Director
9033	629	Writer
9032	629	Producer
9034	629	Producer
9035	629	Co-Producer
4584	629	Executive Producer
9036	629	Executive Producer
9037	629	Executive Producer
9038	629	Executive Producer
9039	629	Music
9040	629	Director of Photography
9039	629	Editor
6410	629	Casting
9041	629	Production Design
8221	629	Art Direction
9042	629	Set Decoration
793	649	Director
793	649	Screenplay
9747	649	Screenplay
9748	649	Author
9749	649	Producer
9750	649	Producer
9751	649	Producer
9752	649	Director of Photography
9753	649	Editor
9754	649	Production Design
9754	649	Set Decoration
9755	649	Costume Design
9757	649	Makeup Artist
9758	649	Creature Design
9759	649	Production Manager
2725	661	Director
9933	661	Screenplay
9934	661	Screenplay
9935	661	Producer
9936	661	Producer
3767	661	Original Music Composer
3769	661	Director of Photography
2725	661	Editor
3770	661	Editor
9937	661	Production Design
9939	661	Production Design
9940	661	Set Decoration
9941	661	Set Decoration
9942	661	Set Decoration
9943	661	Costume Design
9944	661	Costume Design
9945	661	Costume Design
9946	661	Costume Design
9948	661	Makeup Artist
9949	661	Sound Designer
9950	661	Sound Designer
39571	661	Production Design
2725	661	Idea
1591765	673	Lighting Supervisor
1591763	673	Best Boy Electric
40823	673	Foley
1117716	673	Creative Producer
11218	673	Director
10966	673	Novel
10967	673	Screenplay
10968	673	Producer
11222	673	Producer
491	673	Original Music Composer
6737	693	Director
10385	693	Screenplay
10387	693	Screenplay
380	693	Producer
6737	693	Producer
3305	693	Producer
10390	693	Executive Producer
10395	693	Co-Producer
10392	693	Executive Producer
7885	693	Original Music Composer
892	693	Director of Photography
10393	693	Editor
10394	693	Editor
10395	693	Editor
6410	693	Casting
10757	713	Director
10757	713	Screenplay
1462022	713	Producer
10759	713	Original Music Composer
7262	713	Director of Photography
10762	713	Editor
75478	713	Producer
7623	765	Director
7623	765	Screenplay
11641	765	Screenplay
11643	765	Executive Producer
11646	765	Executive Producer
11359	765	Producer
11468	765	Original Music Composer
9573	765	Director of Photography
11648	765	Editor
11744	765	Art Direction
11745	765	Art Direction
11746	765	Set Decoration
11747	765	Makeup Artist
59287	765	Makeup Effects
11419	765	Makeup Effects
107372	765	Makeup Effects
1189737	765	Makeup Effects
931858	765	Makeup Effects
1262012	765	Makeup Effects
1203390	765	Makeup Artist
98471	765	Makeup Effects
11694	787	Director
11092	787	Screenplay
11695	787	Producer
5575	787	Producer
2445	787	Producer
376	787	Producer
11696	787	Producer
11697	787	Executive Producer
11698	787	Producer
11098	787	Original Music Composer
11699	787	Director of Photography
908	787	Editor
1593	787	Casting
1594	787	Casting
7233	787	Production Design
11700	787	Art Direction
6055	787	Set Decoration
605	787	Costume Design
12028	806	Director
11834	806	Screenplay
12028	806	Producer
9250	806	Executive Producer
12031	806	Producer
12032	806	Producer
7229	806	Original Music Composer
1760	806	Original Music Composer
12033	806	Director of Photography
6043	806	Editor
1302	806	Casting
12035	806	Production Design
12036	806	Art Direction
12037	806	Art Direction
12038	806	Set Decoration
12039	806	Set Decoration
12040	806	Costume Design
12240	826	Novel
4066	826	Screenplay
6594	826	Producer
12241	826	Original Music Composer
12242	826	Director of Photography
12243	826	Art Direction
12246	826	Sound Designer
12247	826	Sound Designer
12238	826	Director
11837	826	Makeup Artist
13267	826	Screenplay
1357	844	Director of Photography
12667	844	Director of Photography
12668	844	Director of Photography
607	844	Producer
12682	844	Producer
12684	844	Producer
12453	844	Producer
12453	844	Screenplay
12453	844	Director
12455	844	Original Music Composer
45818	844	Editor
18839	844	Producer
13015	867	Director
10492	867	Screenplay
11308	867	Music Editor
117	867	Original Music Composer
13019	867	Novel
12235	867	Director of Photography
6581	867	Editor
2122	867	Editor
12288	867	Producer
1371066	867	Music Editor
1558406	867	Music Supervisor
8527	867	Costume Design
19045	867	Production Design
2532	867	Casting
2031	867	Casting
2026	867	Art Direction
21729	867	Set Decoration
1173602	867	Script Supervisor
9360	867	Still Photographer
983118	867	Steadicam Operator
1397731	867	Steadicam Operator
13563	886	Director
13564	886	Novel
9791	886	Screenplay
8950	886	Screenplay
2993	886	Producer
8406	886	Producer
9217	886	Original Music Composer
1939	886	Director of Photography
4964	886	Editor
10009	886	Art Direction
10604	886	Art Direction
3648	886	Set Decoration
14158	932	Director
14161	932	Director of Photography
14162	932	Director of Photography
14163	932	Editor
14164	932	Sound Designer
13887	932	Production Design
14165	932	Production Design
14166	932	Costume Design
14167	932	Original Music Composer
14186	932	Production Manager
14187	932	Location Manager
11640	932	Location Manager
14163	932	Director
14158	932	Writer
15768	950	Editor
5714	950	Director
239	950	Screenplay
11098	950	Original Music Composer
15769	950	Visual Effects
15770	950	Visual Effects
5719	950	Producer
1217416	950	Storyboard
1453938	950	Lighting Artist
1447310	950	Post Production Supervisor
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
7767	994	Director
14940	994	Novel
14941	994	Screenplay
7767	994	Screenplay
14942	994	Producer
7769	994	Original Music Composer
14944	994	Director of Photography
14141	994	Casting
14945	994	Editor
12685	994	Editor
1724	994	Editor
10591	994	Production Design
14946	994	Art Direction
\.


--
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
-- Data for Name: member; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY member (member_login, email, password_hash) FROM stdin;
IQ0VP7I4EQ	H4SGT@TQJJ	89582b7ce9dcd1431ee7c6c78dea3281
HLAPWR5SVJ	LY3TA@9V2E	61e517023da45689f7338a71aeb380fe
3122J53CUB	OA498@POJK	1cbb87512bb3e7e9c8d485b35ef845c7
8OI9QT5AJF	H7B00@2OV0	e4c2ef7078a1eca1b5b06f83e5599b15
8MD6C924TO	4PEEC@P7HK	db367ffea79ee65158ca066bd10f2bc4
QBAUG43EX0	Z75H6@9D77	2eca5cebaabeed04f3d1386a5708ee6d
2UYP83OU7H	CKKRV@XXM8	d70e77a9531cbc41204c15232adc78cc
M8LP7EJPJC	ZOFZ4@4FEE	8da41ab626baeb4664dec5f3605ad57c
OE7G4D95TQ	TIOJJ@8UOV	b97e2699e195e368231beaf738f6b05f
44GWYVQ941	W9VXU@PIV4	0d64f584b8cd752bf2f7ab14b76bb80b
WT1KWZC2VX	A8ZX8@YT7P	7ad7a98b860f22872695fea14c3eb802
XA2SEDHKA5	QXW74@ANZZ	534946c51d823f39cab33645ef5d54c9
4UMCA9GGS5	JNSB8@V6N1	39b3867f5014155dad2dc03e064ae2de
OXSSA6KT74	U344Q@6R22	3bdbbef3c93beb3387c8df22f45cf0a5
RF62QV59AC	FB9TG@W8J8	17fd638e024262d8e04a2d31c92d9f8d
EXSGMP7BN4	I6QZX@1W3E	7f689f0031692316020eec89aef8a1cd
DN5N8RS3G1	MUUOZ@TT3E	f7f6ce14776fb7c1bc6bb239b8f9955e
TRFU14BD1F	J8QC1@I8N7	4ceba34004c1e1e641114611ee615b29
HDAKH5P9W5	PP1Y5@PVIY	bea9b97fd1600ffb336399b77b38ca20
FFWE8F8F46	1IMSR@W76A	fcab75a38a92c03a4df6d670cc5f192a
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie (movie_id, release_date, status, revenue, poster_url, title, vote_average) FROM stdin;
198	1942-03-06	Released	0	/ug5R6fdOhud4hbb5O6pn1snSEFJ.jpg	To Be or Not to Be	5.30000019
678	1947-11-13	Released	0	/fSGtyKAYqK6GSvAxoDgMCL2YXQI.jpg	Out of the Past	4.94999981
475	1967-07-18	Released	50700000	/isuVmlzVtJVUqySAmkjLB4kXdNm.jpg	Bonnie and Clyde	4.8499999
319	1993-09-09	Released	12281551	/xBO8R3CZfrJ9rrwrZoJ68PgJyAR.jpg	True Romance	4.6500001
596	1940-03-15	Released	0	/mIk2ferK0lPgTaiAfoI5KvHmUCz.jpg	The Grapes of Wrath	5.05000019
55	2000-06-16	Released	20908467	/8gEXmIzw1tDnBfOaCFPimkNIkmm.jpg	Amores perros	5.0999999
548	1950-12-26	Released	96568	/mwWJuktWk8z5OY4og0z48Jg4u3n.jpg	Rashomon	5.44999981
499	1962-04-11	Released	0	/9epKgEPool0vMYofg2dOq08DeyC.jpg	Cléo from 5 to 7	5.0999999
111	1983-12-08	Released	65884703	/zr2p353wrd6j3wjLgDT4TcaestB.jpg	Scarface	4.25
223	1940-04-12	Released	6000000	/eIkJjEbQcPasYvoNHKueFrfgpX4.jpg	Rebecca	4.94999981
2	1988-10-21	Released	0	/gZCJZOn4l0Zj5hAxsMbxoS6CL0u.jpg	Ariel	4.55000019
284	1960-06-15	Released	25000000	/8nrQKQjD6z0SJouKHQapXzmjFc6.jpg	The Apartment	6.3499999
175	1988-05-11	Released	0	/w4TWqa7SiXP0Hm4rkRnCfXwIeRK.jpg	The Big Blue	4.94999981
693	2004-12-15	Released	516642939	/xHAqB06iL5D6HyOS6QpgyKkRQHD.jpg	Meet the Fockers	6.4000001
199	1996-11-21	Released	150000000	/qhVB8eUGwkdVvd8Fezk0AgcMPDH.jpg	Star Trek: First Contact	4.4000001
574	1956-06-01	Released	10250000	/vhUOukoJTWPfVpZOiKwrjdEV4OX.jpg	The Man Who Knew Too Much	4.94999981
81	1984-03-11	Released	3301446	/y2rl0OkMfZHpBaQYPfSJmLMOxwp.jpg	Nausicaä of the Valley of the Wind	4.69999981
260	1935-06-01	Released	0	/9v283GWj9a0AC8wwC4zriNqY1lZ.jpg	The 39 Steps	5.3499999
3	1986-10-16	Released	0	/7ad4iku8cYBuB08g9yAU7tHJik5.jpg	Shadows in Paradise	3.9000001
521	1954-05-29	Released	3000000	/mWWXNdtjRy82gZr4eaOEtBWc1JX.jpg	Dial M for Murder	5.3499999
132	1970-12-06	Released	0	/3UR6YSrz1nIQ84inth4emIPcEOT.jpg	Gimme Shelter	4.80000019
403	1989-12-13	Released	145793296	/vzdx1rkR0wK8NcdgTAvg6Vp061U.jpg	Driving Miss Daisy	5.19999981
377	1984-11-15	Released	25504513	/6ZPruMQvS8GurYOBPuTw81EEaeP.jpg	A Nightmare on Elm Street	4.9000001
446	2003-02-11	Released	0	/aO0k1veOy1LYTeGlDGAiAUPjk2Y.jpg	Distant Lights	5.0999999
236	1994-09-29	Released	15119639	/qoZShHm8QTrHAR80LypwI0SYp8I.jpg	Muriel's Wedding	6.19999981
176	2004-10-01	Released	103911669	/dHYvIgsax8ZFgkz1OslE4V6Pnf5.jpg	Saw	5.44999981
334	1999-12-08	Released	48451803	/jxkHxPiMfGiFvxSOduNV4oIKJI5.jpg	Magnolia	5.44999981
110	1994-05-27	Released	0	/77CFEssoKesi4zvtADEpIrSKhA3.jpg	Three Colors: Red	4.8499999
451	1995-10-27	Released	49800000	/37qHRJxnSh5YkuaN9FgfNnMl3Tj.jpg	Leaving Las Vegas	7.0999999
28	1979-08-15	Released	89460381	/l8dn7rKbjP36PtHsViHGpzf5ey7.jpg	Apocalypse Now	4.69999981
222	1927-09-23	Released	0	/ePGMsItIMHSOvZkCJ6rnl4v64Sq.jpg	Berlin: Symphony of a Great City	3.6500001
307	1945-09-27	Released	0	/gKI4rq7mt15VkYGJnKnHxEYdhYb.jpg	Rome, Open City	6.55000019
713	1993-05-19	Released	116700000	/yuGqa81ye11dDAeBZ9MResJSmoY.jpg	The Piano	5
152	1979-12-06	Released	139000000	/hqsfe8mBWrvOQDEhIWcRlyQK5WL.jpg	Star Trek: The Motion Picture	3.95000005
490	1957-02-16	Released	0	/iJXSumDrz64AvmFZaHHNBGDO1ex.jpg	The Seventh Seal	3.95000005
261	1958-02-17	Released	17570324	/sYn1CgYBDmz4xKVaapFFnRd7jD8.jpg	Cat on a Hot Tin Roof	4.55000019
537	2005-10-12	Released	0	/czSf8d6QJXUqdj0CVuYJZNPqbfp.jpg	Not Here to Be Loved	6.1500001
765	1987-03-13	Released	5923044	/n49mpgUsPgBfRg2qIEj31HX0chu.jpg	Evil Dead II	4.3499999
553	2003-05-19	Released	16680836	/g1xLrof2RVgtHBB4fLvR5Xr8l5x.jpg	Dogville	5.5999999
806	2006-06-06	Released	119188334	/kqKHg1qXuaIOhnKmPEF1GLzGrOY.jpg	The Omen	6.44999981
237	2003-09-26	Released	2500000	/eZDKfjjI5IhqKCOLHonTvKpPnNr.jpg	Young Adam	4.6500001
500	1992-06-25	Released	14661007	/4ctv9pxKpwjTFevWQbvaqXkXbPF.jpg	Reservoir Dogs	4.3499999
387	1981-09-16	Released	85000000	/kI1rptTkqDWj6SBRsYwguBvPViT.jpg	Das Boot	6.0999999
661	1979-02-20	Released	0	/umHMlDhZoO0lSd6YadufzisxvBw.jpg	The Marriage of Maria Braun	5.5
348	1979-05-25	Released	104931801	/2h00HrZs89SL3tXB4nbkiM7BKHs.jpg	Alien	4.3499999
425	2002-03-10	Released	383257136	/zpaQwR0YViPd83bx1e559QyZ35i.jpg	Ice Age	4.80000019
649	1967-05-24	Released	0	/i19wPS7cOFIplOjNVTg4bp8BfAe.jpg	Belle de Jour	4.94999981
549	1996-08-09	Released	3011195	/8hA5Fp1tl1MTKHfek8xgOmPDmrJ.jpg	Basquiat	4.5
629	1995-07-19	Released	23341568	/jgJoRWltoS17nD5MAQ1yK2Ztefw.jpg	The Usual Suspects	5.5
714	1997-12-11	Released	333011068	/k3eI9q7ISgpDEu2CMwR2s6inJVp.jpg	Tomorrow Never Dies	4.0999999
536	2007-03-01	Released	0	\N	Stuttgart Shanghai	5.05000019
673	2004-05-31	Released	789804554	/qMn0YCWKxt7xg8nqRnRj2Ei9qgx.jpg	Harry Potter and the Prisoner of Azkaban	4.80000019
612	2005-12-22	Released	130358911	/3pnsX1egUElYvgmAcCqYvXVOY9O.jpg	Munich	5.05000019
932	1946-10-14	Released	0	/bnTPnjVgrTwSnCfa0jjcB1mhMKv.jpg	Murderers Among Us	4.55000019
787	2005-06-07	Released	478207520	/dqs5BmwSULtB28Kls3IB6khTQwp.jpg	Mr. & Mrs. Smith	4.69999981
826	1957-10-02	Released	33300000	/7PdkAYok5sxbh5fT01h7mQgofbn.jpg	The Bridge on the River Kwai	5.0999999
742	2000-08-25	Released	0	/y6yk8fNyfXMJcviD6zxZE2qC0lJ.jpg	Together	4.75
766	1992-10-09	Released	0	/2eZKDIwLNnySbwqQtAaUz0kYDIL.jpg	Army of Darkness	5.94999981
907	1965-12-22	Released	111858363	/lP1Mn1sQ9FiSNovCyZonhKjjkRM.jpg	Doctor Zhivago	5.30000019
827	1955-01-29	Released	0	/mNaL2CFsABXJKmnst1V2X2Or3Go.jpg	Diabolique	4.6500001
845	1951-06-19	Released	7000000	/y0Lec3HBZbzkB3b1ACSC4tVnj9n.jpg	Strangers on a Train	4.0999999
844	2004-05-20	Released	19271312	/orslhtqVBbI1n7RECP7Fkhuodph.jpg	2046	4.3499999
867	1993-05-21	Released	116300000	/av21Dfu31DQPtp5jkorMMS58rQC.jpg	Sliver	4.44999981
886	1965-10-15	Released	0	/hNkcS5cDV8kdvzFmRCe3gVRhSnG.jpg	The Cincinnati Kid	5.30000019
933	1968-06-19	Released	0	/rj0sXtlhcu97BoJyJcu5lC6G8UN.jpg	Hot Summer	5
950	2006-03-23	Released	660940780	/isRuztu5Ch7FJdtSBLcG8QSOpEI.jpg	Ice Age: The Meltdown	4.55000019
951	1990-12-21	Released	201957688	/3QVlUD2R6WHp8aFK4aRtTlqzaQu.jpg	Kindergarten Cop	4.4000001
975	1957-09-18	Released	0	/f3DEXseCs3WBtvCv9pVPCtoluuG.jpg	Paths of Glory	5
994	1971-12-29	Released	3251794	/kn85ADdkCrL3I2uWfKKhxpjolU5.jpg	Straw Dogs	4.75
995	1939-03-02	Released	1103757	/wvyS90AJsztvX5wxpDSjURad9yl.jpg	Stagecoach	4.94999981
\.


--
-- Data for Name: movie_genre; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie_genre (movie_id, genre_id) FROM stdin;
2	18
3	35
3	18
3	10769
28	18
28	10752
55	18
55	53
81	12
81	14
81	16
81	28
81	878
110	18
110	9648
110	10749
111	28
111	80
111	18
111	53
132	99
132	10402
152	878
152	12
152	9648
175	12
175	18
175	10749
176	27
176	9648
176	80
198	10752
198	35
199	878
199	28
199	12
199	53
222	99
222	36
223	18
223	9648
223	10749
223	53
236	18
236	35
236	10749
237	18
237	53
237	80
237	10749
260	28
260	53
260	9648
261	18
261	10749
284	35
284	18
284	10749
307	18
307	36
319	28
319	53
319	80
319	10749
334	18
348	27
348	28
348	53
348	878
377	27
387	28
387	18
387	36
387	10752
387	12
403	35
403	18
425	16
425	35
425	10751
425	12
446	18
475	80
475	18
490	14
490	18
499	18
499	35
499	10402
500	80
500	53
521	80
521	9648
521	53
536	99
537	10749
537	18
548	80
548	18
548	9648
549	18
549	36
553	80
553	18
553	53
574	12
574	80
574	18
574	9648
574	53
596	18
612	18
612	28
612	36
612	53
629	18
629	80
629	53
649	18
649	10749
661	10752
661	18
673	12
673	14
673	10751
678	18
678	9648
678	53
693	35
693	10749
713	10749
713	18
714	12
714	28
714	53
742	18
742	35
742	10749
765	27
765	35
765	14
766	14
766	27
766	35
787	28
787	35
787	18
787	53
806	18
806	27
806	53
826	18
826	36
826	10752
827	18
827	27
827	53
844	14
844	18
844	878
844	10749
845	80
845	53
867	18
867	53
886	18
907	18
907	10749
907	10752
932	18
950	16
950	10751
950	35
950	12
951	35
975	18
975	10752
994	80
994	18
994	53
994	9648
995	12
995	37
\.


--
-- Data for Name: movie_productioncountry; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY movie_productioncountry (movie_productioncountry_id, country_id, movie_id) FROM stdin;
1	FI	2
2	FI	3
3	US	28
4	MX	55
5	JP	81
6	FR	110
7	FR	110
8	FR	110
9	US	111
10	US	132
11	US	152
12	FR	175
13	FR	175
14	FR	175
15	US	176
16	US	198
17	US	199
18	DE	222
19	US	223
20	AU	236
21	AU	236
22	FR	237
23	FR	237
24	GB	260
25	US	261
26	US	284
27	IT	307
28	US	319
29	US	334
30	GB	348
31	GB	348
32	US	377
33	DE	387
34	US	403
35	US	425
36	DE	446
37	US	451
38	US	475
39	SE	490
40	FR	499
41	FR	499
42	US	500
43	US	521
44	CN	536
45	CN	536
46	FR	537
47	JP	548
48	US	549
49	DK	553
50	DK	553
51	DK	553
52	DK	553
53	DK	553
54	DK	553
55	DK	553
56	DK	553
57	DK	553
58	US	574
59	US	596
60	CA	612
61	CA	612
62	CA	612
63	US	629
64	FR	649
65	FR	649
66	DE	661
67	GB	673
68	GB	673
69	US	678
70	US	693
71	AU	713
72	AU	713
73	AU	713
74	GB	714
75	GB	714
76	SE	742
77	US	765
78	US	766
79	US	787
80	US	806
81	GB	826
82	GB	826
83	FR	827
84	DE	844
85	DE	844
86	DE	844
87	DE	844
88	DE	844
89	US	845
90	US	867
91	US	886
92	IT	907
93	IT	907
94	DE	932
95	DE	933
96	US	950
97	US	951
98	US	975
99	GB	994
100	GB	994
101	US	995
\.


--
-- Name: movie_productioncountry_movie_productioncountry_id_seq; Type: SEQUENCE SET; Schema: moviedb; Owner: postgres
--

SELECT pg_catalog.setval('movie_productioncountry_movie_productioncountry_id_seq', 101, true);


--
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
8349	1940-08-03	\N	Ramón Gerardo Antonio Estévez  (born August 3, 1940), better known by his stage name Martin Sheen, is a film actor best known for his performances in the films Badlands (1973) and Apocalypse Now (1979), and in the television series The West Wing from 1999 to 2006. In film he has won the Best Actor award at the San Sebastián International Film Festival for his performance as Kit Carruthers in Badlands. His portrayal of Capt. Willard in Apocalypse Now earned a nomination for the BAFTA Award for Best Actor. Sheen has worked with a wide variety of film directors, such as Richard Attenborough, Francis Ford Coppola, Terrence Malick, Mike Nichols, Martin Scorsese, Steven Spielberg and Oliver Stone. He has had a star on the Hollywood Walk of Fame since 1989. In television he has won both a Golden Globe and two Screen Actors Guild awards for playing the lead role of President Bartlet in The West Wing, and an Emmy for guest acting in the sitcom Murphy Brown. Born and raised in the United States to immigrant parents, a first-generation Irish mother, Mary-Anne Phelan from Borrisokane in County Tipperary and a Galician father, Francisco Estévez from Vigo in Galicia (Spain), he adopted the stage name Martin Sheen to help him gain acting parts. He is the father of actors Emilio Estevez, Ramón Estevez, Carlos Irwin Estevez (Charlie Sheen), and Renée Estevez. His younger brother Joe Estevez is also an actor. Although known as an actor, he has also directed one film, Cadence (1990), appearing alongside sons Charlie and Ramon. He has also narrated, produced and directed in documentary television, earning two Daytime Emmy awards in the 1980s. In addition to film and television, Sheen has also become notable for his activism in liberal politics.\n\nDescription above from the Wikipedia article Martin Sheen, licensed under CC-BY-SA, full list of contributors can be found on Wikipedia.	2	Dayton, Ohio, USA	Martin Sheen
273	1958-03-13	\N	​From Wikipedia, the free encyclopedia.  \n\nGuillermo Arriaga Jordán (born 13 March 1958) is a Mexican author, screenwriter, director and producer. Self-defined as “a hunter who works as a writer,” he authored Amores Perros, received a BAFTA Best Screenplay nomination for 21 Grams, and received the 2005 Cannes Best Screenplay Award for The Three Burials of Melquiades Estrada.\n\nDescription above from the Wikipedia article Guillermo Arriaga Jordán  Roger Young (director) licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Mexico City, Mexico	Guillermo Arriaga
3084	1924-04-03	2004-07-01	From Wikipedia, the free encyclopedia.\n\nMarlon Brando, Jr. (April 3, 1924 – July 1, 2004) was an American actor who performed for over half a century.\n\nHe was perhaps best known for his roles as Stanley Kowalski in A Streetcar Named Desire (1951), his Academy Award-nominated performance as Emiliano Zapata in Viva Zapata! (1952), his role as Mark Antony in the MGM film adaptation of the Shakespeare play Julius Caesar (1953), for which he was nominated for an Academy Award, and his Academy Award-winning performance as Terry Malloy in On the Waterfront (1954). During the 1970s, he was most famous for his Academy Award-winning performance as Vito Corleone in Francis Ford Coppola's The Godfather (1972), also playing Colonel Walter Kurtz in another Coppola film, Apocalypse Now (1979). Brando delivered an Academy Award-nominated performance as Paul in Last Tango in Paris (1972), in addition to directing and starring in the western film One-Eyed Jacks (1961).\n\nBrando had a significant impact on film acting, and was the foremost example of the "method" acting style. While he became notorious for his "mumbling" diction and exuding a raw animal magnetism, his mercurial performances were nonetheless highly regarded, and he is considered one of the greatest and most influential actors of the 20th century. Director Martin Scorsese said of him, "He is the marker. There's 'before Brando' and 'after Brando'.'"Actor Jack Nicholson once said, "When Marlon dies, everybody moves up one."\n\nBrando was also an activist, supporting many issues, notably the African-American Civil Rights Movement and various American Indian Movements.\n\nDescription above from the Wikipedia article Marlon Brando, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Omaha, Nebraska, USA	Marlon Brando
3087	1931-01-05	\N	Robert Selden Duvall (born January 5, 1931) is an American actor and director. He has won an Academy Award, two Emmy Awards, and four Golden Globe Awards over the course of his career. Duvall has been in some of the most acclaimed and popular films of all time, among them To Kill a Mockingbird, The Godfather, The Godfather Part II, MASH, Network, True Grit, Bullitt, The Conversation, Apocalypse Now, Tender Mercies, The Natural and Lonesome Dove. He began appearing in theatre during the late 1950s, moving into small, supporting television and film roles during the early 1960s in such works as To Kill a Mockingbird (1962) (as Boo Radley) and Captain Newman, M.D. (1963). He started to land much larger roles during the early 1970s with movies like MASH (1970) (as Major Burns) and THX 1138 (1971). This was followed by a series of critical successes: The Godfather (1972), The Godfather Part II (1974), Network (1976), The Great Santini (1979), Apocalypse Now (1979), and True Confessions (1981). Since then Duvall has continued to act in both film and television with such productions as Tender Mercies (1983) (for which he won an Academy Award, The Natural (1984), Colors (1988), the television mini-series Lonesome Dove (1989), Stalin (1992), The Man Who Captured Eichmann (1996), A Family Thing (1996), The Apostle (1997) (which he also wrote and directed), A Civil Action (1998), Gods and Generals (2003), Broken Trail (2006) and Get Low (2010).\n\nDescription above from the Wikipedia article Robert Duvall, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	San Diego, California, USA	Robert Duvall
2975	1961-07-30	\N	Laurence John Fishburne III (born July 30, 1961) is an American actor of screen and stage, as well as a playwright, director, and producer. He is perhaps best known for his roles as Morpheus in the Matrix science fiction film trilogy and as singer-musician Ike Turner in the Tina Turner biopic What's Love Got to Do With It. He became the first African-American to portray Othello in a motion picture by a major studio when he appeared in Oliver Parker's 1995 film adaption of the Shakespeare play. Fishburne has won a Tony Award for Best Featured Actor in a Play for his performance in Two Trains Running (1992) and an Emmy Award for Drama Series Guest Actor for his performance in TriBeCa (1993).\n\nFishburne’s first marriage was to actress to Hajna O. Moss. They had two children together: a son, Langston and a daughter, Montana. Fishburne is now married to actress Gina Torres. They live in Hollywood with their daughter Delilah.	2	Augusta, Georgia, United States	Laurence Fishburne
8350	1955-10-17	2008-12-16	From Wikipedia, the free encyclopedia.\n\nSamuel John "Sam" Bottoms (October 17, 1955 – December 16, 2008) was an American actor and producer.\n\nDescription above from the Wikipedia article Sam Bottoms, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Santa Barbara, California, U.S.	Sam Bottoms
8351	1936-12-23	\N	Frederic Fenimore Forrest, Jr. (born December 23, 1936) is an American actor.Notable film roles include The Conversation, Valley Girl ,Promise Him Anything (TV), One from the Heart, The Stone Boy, The Missouri Breaks, The Deliberate Stranger (TV), and horror maestro Dario Argento's first American film Trauma. On television, he played Captain Richard Jenko on the first season of the Fox Television series 21 Jump Street, in 1987. Forrest was subsequently replaced by actor Steven Williams, who played Captain Adam Fuller for the remainder of the series.\n\nDescription above from the Wikipedia article  Frederic Fenimore Forrest, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Waxahachie - Texas - USA	Frederic Forrest
8354	1937-11-10	\N	From Wikipedia, the free encyclopedia.\n\nAlbert P. Hall (born November 10, 1937) is an American actor.\n\nBorn in Brighton, Alabama, Hall graduated from the Columbia University School of the Arts in 1971. That same year he appeared Off-Broadway in The Basic Training of Pavlo Hummel and on Broadway in the Melvin Van Peebles musical Ain't Supposed to Die a Natural Death. His most famous film role to date is probably that of Chief Phillips in Francis Ford Coppola's award-winning Apocalypse Now. Contemporary audiences may recognise Hall as stern judge Seymore Walsh, a recurring guest-role, on Ally McBeal and The Practice. Hall also has made guest appearances on Kojak, Miami Vice, Matlock, Star Trek: The Next Generation, Strong Medicine, 24, Sleeper Cell and Grey's Anatomy.\n\nDescription above from the Wikipedia article Albert Hall, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Brighton, Alabama, U.S.	Albert Hall
3	1942-07-13	\N	Legendary Hollywood Icon Harrison Ford was born on July 13, 1942 in Chicago, Illinois.  His family history includes a strong lineage of actors, radio personalities, and models.  Harrison attended public high school in Park Ridge, Illinois where he was a member of the school Radio Station WMTH. Harrison worked as the lead voice for sports reporting at WMTH for several years.  Acting wasn’t a major interest to Ford until his junior year at Ripon College when he first took an acting class.  Harrison Ford’s career started in 1964 when he travelled to California in search of a voice-over job. He never received that position, but instead signed a contract with Columbia Pictures where he earned $150 weekly to play small fill in roles in various films.  Through the 60’s Harrison worked on several TV shows including Gunsmoke, Ironside, Kung Fu, and American Style.  It wasn’t until 1967 that Harrison received his first credited role in the Western film, A Time for Killing. Dissatisfied with the meager roles he was being offered, Ford took a hiatus from acting to work as a self-employed carpenter. This seemingly odd diversion turned out to be a blessing in disguise for Harrison’s acting career when he was soon hired by famous film producer George Lucas.  This was a turning point in Harrison’s life that led to him be casted in milestone roles such as Hans Solo and Indiana Jones.  Since his most famous roles in the Star Wars Trilogy and Raiders of the Lost Ark, Harrison Ford has starred in over 40 films.  Many criticize his recent work, saying his performances have been lackluster leading to commercially disappointing films.  Harrison has always worked hard to protect his off-screen private life, keeping details about his children and marriages quite.  He has a total of five children including one recent adoption with third and current wife Calista Flockhart. In addition to acting Harrison Ford is passionate about environmental conservation, aviation, and archeology.	2	Chicago - Illinois - USA	Harrison Ford
6952	1965-09-03	\N	Carlos Irwin Estévez (born September 3, 1965), better known by his stage name Charlie Sheen, is an American film and television actor. He is the youngest son of actor Martin Sheen.\n\nHis character roles in films have included Chris Taylor in the 1986 Vietnam War drama Platoon, Jake Kesey in the 1986 film The Wraith, and Bud Fox in the 1987 film Wall Street. His career has also included more comedic films such as Major League, the Hot Shots! films, and Scary Movie 3 and Scary Movie 4. On television, Sheen is known for his roles on two sitcoms: as Charlie Crawford on Spin City and as Charlie Harper on Two and a Half Men. In 2010, Sheen was the highest paid actor on television, earning US$1.8 million per episode of Two and a Half Men.\n\nSheen's personal life has also made headlines, including reports about alcohol and drug abuse and marital problems as well as allegations of domestic violence. He was fired from his role on Two and a Half Men by CBS and Warner Bros. on March 7, 2011. Sheen subsequently announced a nationwide tour.\n\nDescription above from the Wikipedia article Charlie Sheen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City - New York - USA	Charlie Sheen
7202	1940-06-24	\N		2	Rome, Lazio, Italy	Vittorio Storaro
2778	1936-05-17	2010-05-29	Dennis Lee Hopper (May 17, 1936 – May 29, 2010) was an American actor, filmmaker and artist. As a young man, Hopper became interested in acting and eventually became a student of the Actors' Studio. He made his first television appearance in 1954, and appeared in two films featuring James Dean, Rebel Without a Cause (1955) and Giant (1956). During the next 10 years, Hopper appeared frequently on television in guest roles, and by the end of the 1960s had played supporting roles in several films. He directed and starred in Easy Rider (1969), winning an award at the Cannes Film Festival and was nominated for an Academy Award for Best Original Screenplay as co-writer. "With its portrait of counterculture heroes raising their middle fingers to the uptight middle-class hypocrisies, Easy Rider became the cinematic symbol of the 1960s, a celluloid anthem to freedom, macho bravado and anti-establishment rebellion." Film critic Matthew Hays notes that "no other persona better signifies the lost idealism of the 1960s than that of Dennis Hopper." He was unable to build on his success for several years, until a featured role in Apocalypse Now (1979) brought him attention. He subsequently appeared in Rumble Fish (1983) and The Osterman Weekend (1983), and received critical recognition for his work in Blue Velvet and Hoosiers, with the latter film garnering him an Academy Award nomination for Best Supporting Actor. He directed Colors (1988) and played the villain in Speed (1994). Hopper's later work included a leading role in the television series Crash. Hopper's last performance was filmed just before his death: The Last Film Festival, slated for a 2011 release. Hopper was also a prolific and acclaimed photographer, a profession he began in the 1960s.\n\nDescription above from the Wikipedia article Dennis Hopper, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dodge City - Kansas - USA	Dennis Hopper
3173	1920-08-31	2011-07-24	From Wikipedia, the free encyclopedia.\n\nGervais Duan "G. D." Spradlin (born August 31, 1920) is an American actor. He often plays devious authority figures. He is credited in over 70 television and film productions, and has performed alongside such notable actors as Marlon Brando, Al Pacino, Johnny Depp, George C. Scott, Robert Duvall, Michael Douglas, Danny DeVito, Sean Connery, Gene Hackman, Jack Palance, Martin Sheen, Christopher Walken, Arnold Schwarzenegger, Nick Nolte and Harrison Ford.\n\nDescription above from the Wikipedia article G. D. Spradlin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Daylight, Garvin County, Oklahoma, United States	G. D. Spradlin
8346	\N	\N		0		Jerry Ziesmer
80874	\N	\N	Tom Mason was born is an actor.	0	Brooklyn - New York - USA	Tom Mason
349	1941-01-26	\N	Theodore Scott Glenn (born January 26, 1941) is an American actor. His roles have included Wes Hightower in Urban Cowboy (1980), astronaut Alan Shepard in The Right Stuff (1983), Commander Bart Mancuso in The Hunt for Red October (1990), and Jack Crawford in The Silence of the Lambs (1991).\n\nDescription above from the Wikipedia article Scott Glenn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Pittsburgh - Pennsylvania - USA	Scott Glenn
1739	1952-09-26	\N		0		James Keane
1402117	\N	\N		2		Kerry Rossall
13023	1953-06-07	\N	Colleen Celeste Camp  (born June 7, 1953) is an American actress and film producer, known for her performances in two installments of the Police Academy series and as Yvette the Maid in the 1985 black comedy Clue. She was also the first actress to play Kristin Shepard in U.S. prime time soap opera Dallas in 1979. Camp was born in San Francisco, California. She had small early roles in films like 1975's Funny Lady with Barbra Streisand. She also appeared alongside Bruce Lee as his wife Anne in Bruce Lee's last movie Game Of Death. Camp was also a Playboy magazine pinup and played one in Francis Coppola's 1979 film Apocalypse Now, though most of her footage was cut from the initial theatrical release. She would later feature more heavily in Coppola's Redux cut. She has worked steadily in film comedies like Peter Bogdanovich's They All Laughed, 1983's Valley Girl and the Michael J. Fox comedy Greedy. She often is cast as a police officer. Camp has been nominated twice for the Worst Supporting Actress Golden Raspberry Award – first, in 1982, for The Seduction, and then, in 1993, for Sliver. In 1999, she had a small part as character Tracy Flick's overbearing mother in the film Election, with Reese Witherspoon as Tracy. While continuing to act in shows like HBO's Entourage, Camp is also now making a name for herself as a producer. She was married to John Goldwyn, a Paramount executive, from 1986 to 2001. They have one daughter, Emily. She appeared in the episode Simple Explanation of House, M.D. that first aired on April 6, 2009.\n\nDescription above from the Wikipedia article Colleen Camp, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	San Francisco - California - USA	Colleen Camp
550106	1950-09-25	\N		1		Cynthia Wood
1664821	\N	\N		1		Linda Carpenter
14320	1946-06-12	\N		2	Perth, Perthshire, Scotland, UK	Jack Thibeau
159948	\N	\N		0		Damien Leake
103853	1958-04-29	\N		2	USA	Marc Coppola
1532851	\N	\N		0		Glenn Walken
65553	1931-01-08	1991-10-26		0		Bill Graham
1391387	1955-09-30	\N		2	San Francisco, California, USA	Jerry Ross
43524	1945-11-09	\N		2	Houston, Texas, USA	Charles Robinson
107323	\N	\N		0		Nick Nicholson
1073850	\N	\N		0		Don Gordon Bell
57925	1931-03-20	2001-09-25		0		Evan A. Lottman
8655	1944-03-24	\N	From Wikipedia, the free encyclopedia.\n\nRonald Lee Ermey (born March 24, 1944) is a retired United States Marine Corps drill instructor and actor.\n\nErmey has often played the roles of authority figures, such as his breakout performance as Gunnery Sergeant Hartman in Full Metal Jacket, Mayor Tilman in the Alan Parker film Mississippi Burning, Bill Bowerman in Prefontaine, Sheriff Hoyt in The Texas Chainsaw Massacre remake, and plastic army men leader Sarge in the Toy Story films.\n\nHe has hosted two programs on the History Channel: Mail Call, in which he answered viewers' questions about various militaria both modern and historic; and Lock N' Load with R. Lee Ermey, which focused on the development of different types of weapons.\n\nHe is currently a candidate for the National Rifle Association board of directors.\n\nDescription above from the Wikipedia article R. Lee Ermey, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Emporia, Kansas, USA	R. Lee Ermey
45581	1955-05-18	\N		2		Jim Gaines
223	1963-08-15	\N	Alejandro González Iñárritu ( born August 15, 1963) is a Mexican film director. Iñárritu is the first Mexican director to be nominated for the Academy Award for Best Director and by the DGA of America for Best Director. He is also the first and only Mexican born director to have won the Prix de la mise en scene or best director award at Cannes (2006). His four feature films Amores perros (2000), 21 Grams (2003), Babel (2006) and Biutiful (2010) have gained critical acclaim worldwide including 12 Academy Award nominations.\n\nDescription above from the Wikipedia article Alejandro González Iñárritu, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Mexico City, Distrito Federal, Mexico	Alejandro González Iñárritu
275	1965-11-23	\N	Rodrigo Prieto (born November 1965) is a Mexican cinematographer.\n\n Rodrigo Prieto was born in Mexico City, Mexico.  His grandfather, Jorge Prieto Laurens, was the mayor of Mexico City and leader of the Chamber of Deputies of Mexico, but was later persecuted by the country's ruler because of political differences. Prieto's grandfather escaped with his family to Texas and then to Los Angeles. There, Prieto's father would spend most of his childhood. He studied aeronautical engineering at New York University, where he met and married Prieto's mother, an art student. Prieto graduated from Centro de Capacitación Cinematográfica in Mexico City; He has become an established cinematographer, working with such names as Spike Lee(25th Hour), Curtis Hanson (8 Mile), Ang Lee (Brokeback Mountain, Lust, Caution) and Pedro Almodovar (Broken Embraces.) Nonetheless, his political legacy still has a visible effect on his career. In 2002, he shot Frida, a film about Frida Kahlo, a communist Mexican artist. In 2003, he cooperated with Oliver Stone in two documentaryprojects: Comandante, about Fidel Castro, and Persona Non Grata, about Yassir Arafat. In 2004, he shot Alexander for Stone. Prieto also worked with Alejandro González Iñárritu on the acclaimed Amores Perros, 21 Grams, Babel and Biutiful. Prieto has most recently formed an artistic collaboration with Martin Scorsese; first on The Wolf of Wall Street and most recently, Silence.  Prieto is noted for his unconventional use of the camera often combined with strong moody lighting. In 25th Hour, Prieto utilized overexposure and other techniques to create original dream-like images to signify that the events shown on screen are memories or visions. Similarly innovative photography could be spotted in Frida, featuring strong colors and sharp imagery blended with atmospheric yellows and browns, as well as his experimental use of infrared during a battle scene in Alexander. He also is interested in evoking naturalism, most evident in The Homesman and Brokeback Mountain.	0	Mexico City - Mexico	Rodrigo Prieto
1776	1939-04-07	\N	Francis Ford Coppola  (born April 7, 1939) is an American film director, producer and screenwriter. He is widely acclaimed as one of Hollywood's most celebrated and influential film directors. He epitomized the group of filmmakers known as the New Hollywood, which included George Lucas, Martin Scorsese, Robert Altman, Woody Allen and William Friedkin, who emerged in the early 1970s with unconventional ideas that challenged contemporary filmmaking.\n\nHe co-authored the script for Patton, winning the Academy Award in 1970. His directorial fame escalated with the release of The Godfather in 1972. The film revolutionized movie-making in the gangster genre, garnering universal laurels from critics and public alike. It went on to win three Academy Awards, including his second, which he won for Best Adapted Screenplay, and it was instrumental in cementing his position as one of the prominent American film directors. Coppola followed it with an equally successful sequel The Godfather Part II, which became the first ever sequel to win the Academy Award for Best Picture. The film received yet higher praises than its predecessor, and gave him three Academy Awards—for Best Adapted Screenplay, Best Director and Best Picture. In the same year was released The Conversation, which he directed, produced and wrote. The film went on to win the Palme d'Or at the 1974 Cannes Film Festival. His next directorial venture was Apocalypse Now in 1979, and it was as notorious for its lengthy and troubled production as it was critically acclaimed for its vivid and stark depiction of the Vietnam War. It won his second Palme d'Or at the 1979 Cannes Film Festival.\n\nAlthough some of Coppola's ventures in the 1980s and early 1990s were critically lauded, Coppola's later work has not met the same level of critical and commercial success as his '70s films. Description above from the Wikipedia article Francis Ford Coppola, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Detroit, Michigan, USA	Francis Ford Coppola
107322	\N	\N		0		Henry Strzalkowski
1604873	\N	\N		0		Lonnie Woodley
258	1978-11-30	\N	​García Bernal was born in Guadalajara, Mexico, the son of Patricia Bernal, an actress and former model, and José Angel García, an actor and director. His stepfather is Sergio Yazbek, whom his mother married when García Bernal was young. He started acting at just a year old and spent most of his teen years starring in telenovelas. Gael studied the International Baccalaureate, with chemistry being unquestionably his favorite subject. When he was fourteen, he taught indigenous peoples in Mexico to read, often working with the Huichol Indians. In his later teens, he took part in peaceful demonstrations during the Chiapas uprisingof 1994.	0	Guadalajara, Jalisco, Mexico	Gael García Bernal
259	\N	\N		0		Vanessa Bauche
261	1969-09-24	\N	Goya Toledo is a Spanish film and television actress and model.Born at Arrecife on the island of Lanzarote, one of the Canary Islands, on the 24 September 1969, Toledo started out as a model before venturing into acting. Her most well-known role to date has been playing the model Valeria in the 2000 film Amores Perros. She also had a starring role in the 2003 Spanish thriller Killing Words.	0	Arrecife, Lanzarote	Goya Toledo
262	\N	\N		0		Alvaro Guerrero
263	\N	\N		0	Mexico	Emilio Echevarría
264	1968-07-27	\N	Jorge salinas perez mejor conocido como jorge salinas es un actor mexicano nacido el 27 de julio de 1968 en la ciudad de mexico. La primera participación de Jorge en el medio del espectáculo fue en la película Viva El Chubasco, al lado de Antonio Aguilar y Eulalio González. Después, recibe dos oportunidades en televisión en 1991: la primera, en la telenovela Cadenas de amargura al lado de Daniela Castro y Raul Araiza, bajo la producción de Carlos Sotomayor; la segunda fue en Valeria y Maximiliano, protagonizada por Leticia Calderón y Juan Ferrara, también de la mano deCarlos Sotomayor. Luego aparece en la película Como Cualquier Noche, y más tarde realiza varias telenovelas, entre las que destacan El abuelo y yo yDos mujeres, un camino. Es en 1999 cuando protagoniza su primer telenovela Tres mujeres, producción de Roberto Hernandez.\n\nSu más reciente trabajo fue en la telenovela Fuego en la sangre, en la que comparte créditos con Eduardo Yáñez, Adela Noriega, Nora Salinas, Pablo Montero y Elizabeth Álvarez, entre otros actores.Jorge filmó la película Labios rojos de Rafael Lara, en la que formó pareja con Silvia Navarro. Las filmágenes empezaron en junio de 2007 en el DF y terminaron en octubre del mismo año. La película está prevista para estrenarse en el cine en 2009.	0	Mexico City, Mexico.	Jorge Salinas
265	\N	\N		0		Rodrigo Murray
266	1978-06-23	\N		2	Mexico City, Distrito Federal, Mexico	Humberto Busto
267	\N	\N		0		Gerardo Campbell
268	\N	\N		0		Rosa María Bianchi
269	1942-11-20	2016-02-03		1	 Guadalajara, Jalisco, Mexico	Dunia Saldívar
270	1956-03-05	\N	Adriana Barraza (5 de marzo de 1956, Toluca - ) es una actriz mexicana nominada a los Premios de la Academia. Sus dos trabajos más importantes han sido Amores Perros y Babel. Previamente a su nominación al Oscar a la mejor actriz de reparto fue candidata en la misma categoría en los Globos de Oro y Broadcast Film Critics Association Award, y candidata al Premio del Sindicato de Actores como "Mejor actriz de reparto en una película". Es una reconocida maestra de actuación en México, Miami y Colombia. Se destacó en el Taller de Perfeccionamiento Actoral de Televisa; donde, junto al reconocido actor, director, productor, escritor y profesor de actuación: Sergio Jiménez, dio clases por más de una década. Junto a este gran teórico de la actuación compiló y diseñó un método de actuación llamado: Actuación Técnica del cual es co-creadora. (de ahí que en el medio artístico sea conocida como la querida "Maestra Barraza"). Fue actriz en algunas telenovelas y programas; además, directora de telenovelas infantiles de Televisa por muchos años, pero se ha destacado y ha alcanzado su mayor realización como maestra (de actuación, análisis de textos y neutralización de acento) y como actriz internacional de cine. En 2011 fue recortada de la cinta Thor y se entero por una carta del director que le llego a su representante	1	Toluca, Estado de Mexico, Mexico	Adriana Barraza
271	\N	\N		0		José Sefami
272	\N	\N		1		Lourdes Echevarría
260	\N	\N		0		Marco Pérez
553140	\N	\N		1		Laura Almela
18468	1966-11-08	\N	Gustavo Sánchez Parra is known for his work on El fuego de la venganza (2004), La leyenda del Zorro (2005) and Amores perros (2000).	0	Mexico City - Mexico	Gustavo Sánchez Parra
127825	1959-12-22	\N	Dagoberto Gama was born in Coyuca de Catalán, Guerrero, Mexico. He is an actor, known for Amores perros (2000), Camelia La Texana (2014) and El violín (2005).	0	Coyuca de Catalan, Guerrero, Mexico	Dagoberto Gama
1197402	\N	\N		2		Rodrigo Ostap
23875	\N	\N	Patricio Castillo is an actor, known for Amores perros (2000), Crónicas chilangas (2009) and La Gata (2014).	0		Patricio Castillo
174434	\N	\N		2		Roberto Medina
1044057	\N	\N		0		Carlos Samperio
132018	1978-05-23	\N		2	Monterrey, Nuevo León, Mexico	Mauricio Martínez
1234762	\N	\N		2	Naples, Campania, Italy	Ricardo Dalmacci
1660431	\N	\N		2		Gustavo Muñoz
613	1954-12-08	\N	Sumi Shimamoto is a Japanese voice actress.	0	Kōchi, Japan	Sumi Shimamoto
614	\N	\N		0		Mahito Tsujimura
615	1935-02-22	\N		1	Tokyo, Japan	Hisako Kyouda
1768	\N	\N		0		Marvin Paige
16252	\N	\N		0		Jon Povill
1763	\N	\N		0		Leon Harris
1802	\N	\N		0		Joseph R. Jennings
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
1350	1966-07-15	\N	Irène Marie Jacob (born 15 July 1966) is a French-born Swiss actress considered one of the preeminent French actresses of her generation. Jacob gained international recognition and acclaim through her work with Polish film director Krzysztof Kieslowski, who cast her in the lead role of The Double Life of Véronique and Three Colors: Red. She came to represent an image of European sophistication, through her "classic beauty and thoughtful, almost melancholic style of acting."\n\nDescription above from the Wikipedia article Irène Jacob, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Suresnes, France	Irène Jacob
1430	1943-12-18	\N	From Wikipedia, the free encyclopedia.  \n\nKeith Richards (born 18 December 1943) is an English musician, songwriter, and founding member of the rock band the Rolling Stones ranked by Rolling Stone magazine as the "10th greatest guitarist of all time." Fourteen songs Richards wrote with songwriting partner and the Rolling Stones' vocalist Mick Jagger were listed on Rolling Stone's "500 Greatest Songs of All Time".\n\nDescription above from the Wikipedia article Keith Richards, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dartford, Kent, England, United Kingdom	Keith Richards
1429	1941-06-02	\N	​From Wikipedia, the free encyclopedia.  \n\nCharles Robert "Charlie" Watts (born 2 June 1941) is an English drummer, best known as a member of The Rolling Stones. He is also the leader of a jazz band, as well as a record producer, commercial artist, and horse breeder.\n\nDescription above from the Wikipedia article Charlie Watts, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England	Charlie Watts
1096	1953-06-23	2004-03-15		0		John Vallone
602	\N	\N		0		Linda DeScenna
1352	1930-12-11	\N	From Wikipedia, the free encyclopedia.\n\nJean-Louis Trintignant (born 11 December 1930) is a French actor who has enjoyed an international acclaim. He won the Best Actor Award at the 1969 Cannes Film Festival.\n\nTrintignant was born in Piolenc, Vaucluse, France, the son of Claire (née Tourtin) and Raoul Trintignant, an industrialist. At the age of twenty, Trintignant moved to Paris to study drama, and made his theatrical debut in 1951 going on to be seen as one of the most gifted French actors of the post-war era. After touring in the early 1950s in several theater productions, his first motion picture appearance came in 1955 and the following year he gained stardom with his performance opposite Brigitte Bardot in Roger Vadim's And God Created Woman.\n\nTrintignant’s acting was interrupted for several years by mandatory military service. After serving in Algiers, he returned to Paris and resumed his work in film. He had the leading male role in the classic A Man and a Woman, which at the time was the most successful French film ever screened in the foreign market.\n\nIn Italy, he was always dubbed into Italian, and his work stretched into collaborations with renowned Italian directors, including Sergio Corbucci in The Great Silence, Valerio Zurlini in Violent Summer and The Desert of the Tartars, Ettore Scola in La terrazza, Bernardo Bertolucci in The Conformist, and Dino Risi in the cult film The Easy Life.\n\nThroughout the 1970s, Trintignant starred in numerous films and in 1983 he made his first English language feature film, Under Fire. Following this, he starred in François Truffaut's final film, Confidentially Yours, and reprised his best-known role in the sequel A Man and a Woman: 20 Years Later.\n\nIn 1994, he starred in Krzysztof Kieślowski's last film, Three Colors: Red.\n\nThough he takes an occasional film role, he has, as of late, been focusing essentially on his stage work.\n\nAfter a 14-year gap, Trintignant came back on screen for Michael Haneke's film Amour. Haneke had sent Trintignant the script, which had been written specifically for him. Trintignant said that he chooses which films he works in on the basis of the director, and said of Haneke that "he has the most complete mastery of the cinematic discipline, from technical aspects like sound and photography to the way he handles actors"\n\nDescription above from the Wikipedia article Jean-Louis Trintignant, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Piolenc, Vaucluse, France	Jean-Louis Trintignant
1356	\N	\N		0		Jean-Pierre Lorit
1354	\N	\N		0		Frédérique Feder
49025	1965-11-02	\N		0		Samuel Le Bihan
27983	\N	\N		0		Marion Stalens
1145	1961-07-17	\N		0		Zbigniew Zamachowski
1137	1964-03-09	\N	Juliette Binoche (born 9 March 1964) is a French actress, artist and dancer. She has appeared in more than 40 feature films, been recipient of numerous international accolades, is a published author and has appeared on stage across the world. Coming from an artistic background, she began taking acting lessons during adolescence. After performing in several stage productions, she was propelled into the world of auteurs Jean-Luc Godard (Hail Mary, 1985), Jacques Doillon (Family Life, 1985) and André Téchiné, who made her a star in France with the leading role in his 1985 drama Rendez-vous. Her sensual performance in her English-language debut The Unbearable Lightness of Being (1988), directed by Philip Kaufman, launched her international career.\n\nShe sparked the interest of Steven Spielberg, who offered her several parts including a role in Jurassic Park which she declined, choosing instead to join Krzysztof Kieslowski on the set of Three Colors: Blue (1993), a performance for which she won the Venice Film Festival Award for Best Actress and a César. Three years later Binoche gained further acclaim in Anthony Minghella’s The English Patient (1996), for which she was awarded an Academy Award and a BAFTA for Best Supporting Actress in addition to the Best Actress Award at the 1997 Berlin Film Festival. For her performance in Lasse Hallström’s romantic comedy Chocolat (2000) Binoche was nominated for an Academy Award for Best Actress.\n\nDuring the 2000s she maintained a successful, critically acclaimed career, alternating between French and English language roles in both mainstream and art-house productions. In 2010 she won the Best Actress Award at the Cannes Film Festival for her role in Abbas Kiarostami’s Certified Copy making her the first actress to win the European “best actress triple crown”.\n\nThroughout her career Binoche has intermittently appeared on stage, most notably in a 1998 London production of Luigi Pirandello’s Naked and in a 2000 production of Harold Pinter's Betrayal on Broadway for which she was nominated for a Tony Award. In 2008 she began a world tour with a modern dance production in-i devised in collaboration with Akram Khan. Affectionately referred to as "La Binoche" by the French press, her other notable performances include: Mauvais Sang (1986), Les Amants du Pont-Neuf, Damage (1992), The Horseman on the Roof (1995), Code Unknown (2000), Caché (2005), Breaking and Entering (2006) and Flight of the Red Balloon (2007).\n\nDescription above from the Wikipedia article Juliette Binoche, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paris, France	Juliette Binoche
1146	1969-12-21	\N	From Wikipedia, the free encyclopedia\n\nJulie Delpy (born December 21, 1969) is a French-American actress, director, screenwriter, and singer-songwriter. She studied filmmaking at New York University's Tisch School of the Arts and has directed, written, and acted in more than 30 films including Europa Europa, Before Sunrise, Before Sunset, and 2 Days in Paris. After moving to the U.S., she became an American citizen.\n\nDescription above from the Wikipedia article Julie Delphy, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paris, France	Julie Delpy
1138	1953-08-19	1994-10-22		0		Benoît Régent
1126	1941-06-27	1996-03-13	From Wikipedia\n\nKrzysztof Kieślowski (Polish pronunciation: [ˈkʂɨʂtɔf kʲɛɕˈlɔfskʲi] ( listen); 27 June 1941 – 13 March 1996) was an influential Polish art-house film director and screenwriter known internationally for The Decalogue (1989), The Double Life of Véronique (1991), and The Three Colors Trilogy (1993–1994). Kieślowski received numerous awards during his career, including the Cannes Film Festival Jury Prize (1988), FIPRESCI Prize (1988, 1991), and Prize of the Ecumenical Jury (1991); the Venice Film Festival FIPRESCI Prize (1989), Golden Lion (1993), and OCIC Award (1993); and the Berlin International Film Festival Silver Bear (1994). In 1995 he received Academy Award nominations for Best Director and Best Writing.\n\nIn 2002 Kieślowski was listed at number two on the British Film Institute's Sight &amp; Sound Top Ten Directors list of modern times.\n\nKrzysztof Kieślowski died on 13 March 1996, He was 54.	2	Warsaw, Mazowieckie, Poland.	Krzysztof Kieślowski
1134	1938-10-07	\N		0		Marin Karmitz
1132	1945-10-25	\N	From Wikipedia, the free encyclopedia\n\nKrzysztof Piesiewicz (Polish pronunciation: [ˈkʂɨʂtɔf pjɛˈɕɛvit͡ʂ]; born on October 25, 1945 in Warsaw, Poland) is a Polish lawyer, screenwriter, and politician, who is currently a member of the Polish Parliament and head of the Ruch Społeczny (RS) or Social Movement Party.\n\nPiesiewicz studied law at Warsaw University and began practicing in 1973. Through the late 1970s he became increasingly involved in political cases, defending opponents of the Communist regime, serving as a legal advisor for Solidarity, and assisting in the successful prosecution of the murderers of Jerzy Popiełuszko.\n\nIn 1982 he met the film director Krzysztof Kieślowski, who was planning to direct a documentary on political show trials in Poland under martial law. Piesiewicz agreed to help, though he doubted whether an accurate film could be made within the constraints of the judicial system; indeed, the filmmakers found that their presence in court seemed to be affecting the outcomes of cases, often improving the prospects of the accused, but making it hard to capture judicial abuses.\n\nKieślowski decided to explore the issue through fiction instead, and the two collaborated for the first time as writers on the feature film No End, released in 1984.\n\nPiesewicz returned to his law career, but remained in touch with Kieślowski and three years later persuaded him to create a series of films based on the Ten Commandments. This series, The Decalogue, explored the filmmakers' mutual interest in moral and ethical dilemmas in contemporary social and political life, and achieved (belated) critical acclaim around the world.\n\nTheir later collaborations, The Double Life of Véronique and Three Colors (Blue, White, Red), focused on metaphysical questions of personal choice and appeared relatively apolitical, though the latter series was based on Piesiewicz's idea of dramatizing the French political ideals of liberty, equality, and fraternity in the same way they had previously dramatized the Ten Commandments.\n\nPiesiewicz was credited as co-writer on all of Kieślowski's projects after No End, the last of which was Nadzieja, directed by Stanislaw Mucha after Kieślowski's death. He has begun writing a new series of films, The Stigmatised; the first of these, Silence, was directed by Michał Rosa and released in 2002.\n\nPiesiewicz's career in electoral politics began in 1989, when he began working in the Social Movement for Solidarity Electoral Action (RS AWS) party, originally the political wing of the Solidarity union and the leading party in the center-right AWS coalition. In 1991 he was elected to the Polish Senate, served for two years, then returned in 1997. In 2002, RS AWS changed its name to RS and elected Piesiewicz as its leader.\n\nHe is a Roman Catholic.	2	Warsaw, Poland	Krzysztof Piesiewicz
1428	1943-07-26	\N	​From Wikipedia, the free encyclopedia.  \n\nSir Michael Philip "Mick" Jagger (born 26 July 1943) is an English musician, singer-songwriter, actor, and producer, best known as the lead vocalist of rock band, The Rolling Stones. Jagger has also acted in and produced several films. The Rolling Stones started in the early 1960s as a rhythm and blues cover band with Jagger as frontman. Beginning in 1964, Jagger and guitarist Keith Richards developed a songwriting partnership, and by the mid-1960s the group had evolved into a major rock band. Frequent conflict with the authorities (including alleged drug use and his romantic involvements) ensured that during this time Jagger was never far from the headlines, and he was often portrayed as a counterculture figure. In the late 1960s Jagger began acting in films (starting with Performance and Ned Kelly), to mixed reception. In the 1970s, Jagger, with the rest of the Stones, became tax exiles, consolidated their global position and gained more control over their business affairs with the formation of the Rolling Stones Records label. During this time, Jagger was also known for his high-profile marriages to Bianca Jagger and later to Jerry Hall. In the 1980s Jagger released his first solo album, She's the Boss. He was knighted in 2003. Jagger's career has spanned over 50 years. His performance style has been said to have "opened up definitions of gendered masculinity and so laid the foundations for self-invention and sexual plasticity which are now an integral part of contemporary youth culture". In 2006, he was ranked by Hit Parader as the fifteenth greatest heavy metal singer of all time, despite not being associated with the genre. Allmusic has described Jagger as "one of the most popular and influential frontmen in the history of rock &amp; roll". His distinctive voice and performance, along with Keith Richards' guitar style, have been the trademark of The Rolling Stones throughout their career.\n\nDescription above from the Wikipedia article Mick Jagger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Dartford, Kent, England	Mick Jagger
1801	1922-08-23	\N		2	Cedar Rapids, Iowa, USA	Robert Fletcher
1665131	\N	\N		0		Maryline Moulard
1170466	1951-01-08	\N		1	 London, England	Edwige Pierre
10934	1932-02-24	\N		2	Paris, France	Michel Legrand
1135	1955-05-20	\N	From Wikipedia, the free encyclopedia\n\nZbigniew Preisner (Polish: [ˈzbiɡɲɛf ˈpɾajsnɛɾ]; born 20 May 1955) is a Polish film score composer, best known for his work with film director Krzysztof Kieślowski.\n\nPreisner is best known for the music composed for the films directed by fellow Pole Krzysztof Kieślowski. His Song for the Unification of Europe, based on the Greek text of 1 Corinthians 13, is attributed to a character in Kieślowski's Three Colors: Blue and plays a dominating role in the story. His music for Three Colors: Red includes a setting of Polish and French versions of a poem by Wisława Szymborska, a Polish Nobel Prize-winning poet.\n\nAfter working with Kieślowski on Three Colors: Blue, Preisner was hired by the producer Francis Ford Coppola to write the score for The Secret Garden, directed by Polish director Agnieszka Holland. Although Preisner is most closely associated with Kieślowski, he has collaborated with several other directors, winning a César in 1996 for his work on Jean Becker's Élisa. He has won a number of other awards, including another César in 1994 for Three Colors: Red, and the Silver Bear from the 47th Berlin International Film Festival 1997 for The Island on Bird Street. He was nominated for Golden Globe awards for his scores for Three Colors: Blue (1993) and At Play in the Fields of the Lord (1991).\n\nIn 1998, Requiem for My Friend, Preisner's first large scale work not written for film, premiered. It was originally intended as a narrative work to be written by Krzysztof Piesiewicz and directed by Kieślowski, but it became a memorial to Kieślowski after the director's death. The Lacrimosa from this Requiem appears in Terrence Malick's The Tree of Life. The Dies Irae from this Requiem appears in the film La Grande Bellezza, directed by Paolo Sorrentino.\n\nPreisner composed the theme music for the People's Century, a monumental twenty-six part documentary made jointly in 1994 by the BBC television network in United Kingdom and the PBS television network in the United States. He has also worked with director Thomas Vinterberg on the 2003 film It's All About Love. He provided orchestration for David Gilmour's 2006 album On An Island as well as additional orchestrations for the show at Gdańsk shipyards at which he also conducted the Baltic Philharmonic Orchestra, this was documented on the album Live in Gdańsk (2008). Silence, Night and Dreams is Zbigniew Preisner's new recording project, a large-scale work for orchestra, choir and soloists, based on texts from the Book of Job. The premier recording, was released in 2007 with the lead singer of Madredeus, Teresa Salgueiro and boy soprano Thomas Cully from Libera.	2	Bielsko-Biala, Slaskie, Polska	Zbigniew Preisner
1346	\N	\N		0		Bertrand Lenclos
1136	\N	\N		0		Jacques Witta
33238	\N	\N		0		Piotr Sobocinski
1158	1940-04-25	\N	Alfredo James "Al" Pacino (born April 25, 1940) is an American film and stage actor and director. He is famous for playing mobsters, including Michael Corleone in The Godfather trilogy, Tony Montana in Scarface, Alphonse "Big Boy" Caprice in Dick Tracy and Carlito Brigante in Carlito's Way, though he has also appeared several times on the other side of the law — as a police officer, detective and a lawyer. His role as Frank Slade in Scent of a Woman won him the Academy Award for Best Actor in 1992 after receiving seven previous Oscar nominations.\n\nHe made his feature film debut in the 1969 film Me, Natalie in a minor supporting role, before playing the leading role in the 1971 drama The Panic in Needle Park. Pacino made his major breakthrough when he was given the role of Michael Corleone in The Godfather in 1972, which earned him an Academy Award nomination for Best Supporting Actor. Other Oscar nominations for Best Supporting Actor were for Dick Tracy and Glengarry Glen Ross. Oscar nominations for Best Actor include The Godfather Part II, Serpico, Dog Day Afternoon, the court room drama ...And Justice for All and Scent of a Woman.\n\nIn addition to a career in film, he has also enjoyed a successful career on stage, picking up Tony Awards for Does a Tiger Wear a Necktie? and The Basic Training of Pavlo Hummel. His love of Shakespeare led him to direct his first film with Looking for Richard, a part documentary on the play Richard III. Pacino has received numerous lifetime achievement awards, including one from the American Film Institute. He is a method actor, taught mainly by Lee Strasberg and Charlie Laughton at the Actors Studio in New York. Although he has never married, Pacino has had several relationships with actresses and has three children.\n\nDescription above from the Wikipedia article Al Pacino, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New York City, New York, USA	Al Pacino
1159	1956-12-02	\N	Steven Bauer (born December 2, 1956) is a Cuban-American actor. He is known for his role as Manny Ribera in the 1983 film Scarface, and his role on the bilingual PBS show Que Pasa, USA.	0	Havana - Cuba	Steven Bauer
1160	1958-04-29	\N	​From Wikipedia, the free encyclopedia.\n\nMichelle Marie Pfeiffer  (born April 29, 1958) is an American actress and singer. She made her screen debut in 1980, but first garnered mainstream attention with her performance in Scarface (1983). She rose to prominence in the late 1980s and early 1990s with critically acclaimed performances in the films Dangerous Liaisons (1988), Married to the Mob (1988), The Fabulous Baker Boys (1989), The Russia House (1990), Frankie and Johnny (1991), Love Field (1992), Batman Returns (1992), and The Age of Innocence (1993). Michelle Pfeiffer has won numerous awards for her work, including the Golden Globe Award for Best Actress - Motion Picture Drama for The Fabulous Baker Boys, the BAFTA Award for Best Actress in a Supporting Role for Dangerous Liaisons, and the Silver Bear for Best Actress for Love Field; each of these films also resulted in a nomination for an Academy Award. She received a star on the Hollywood Walk of Fame on August 6, 2007. Her star is located at 6801 Hollywood Boulevard.\n\nDescription above from the Wikipedia article Michelle Pfeiffer, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Santa Ana, California, U.S.	Michelle Pfeiffer
1161	1958-11-17	\N	From Wikipedia, the free encyclopedia.\n\nMary Elizabeth Mastrantonio (born November 17, 1958, height 5' 4" (1,63 m)) is an American actress and singer known for her role as Carmen in The Color of Money, as well as for her roles as Lindsey Brigman in The Abyss, Gina Montana in Scarface, and Maid Marian in Robin Hood: Prince of Thieves.\n\nDescription above from the Wikipedia article Mary Elizabeth Mastrantonio, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Lombard - Illinois - USA	Mary Elizabeth Mastrantonio
1162	1930-01-03	2015-12-04	​From Wikipedia, the free encyclopedia.  \n\nRobert Loggia (born Salvatore Loggia; January 3, 1930) is an American film and television actor and director, who specializes in character parts.\n\nDescription above from the Wikipedia article Robert Loggia, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Staten Island, New York, USA	Robert Loggia
1163	1936-08-20	\N	From Wikipedia, the free encyclopedia\n\nMíriam Colón (born August 20, 1936) is a Puerto Rican actress and the founder and director of the Puerto Rican Traveling Theater in New York City.\n\nDescription above from the Wikipedia article Míriam Colón, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Ponce, Puerto Rico	Miriam Colón
1164	1939-10-24	\N	From Wikipedia, the free encyclopedia.\n\nFahrid Murray Abraham (born October 24, 1939) is an American actor. He became known during the 1980s after winning the Academy Award for Best Actor for his role as Antonio Salieri in Amadeus. He has appeared in many roles, both leading and supporting, in films such as All the President's Men and Scarface. He is also known for his television and theatre work.	2	Pittsburgh, Pennsylvania, USA	F. Murray Abraham
1165	1936-02-12	1989-10-11		0		Paul Shenar
1166	1937-11-05	\N	​From Wikipedia, the free encyclopedia.\n\nHarris Yulin (born November 5, 1937) is an American actor who has appeared in dozens of Hollywood and television films.\n\nDescription above from the Wikipedia article Harris Yulin, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	 Los Angeles, California, USA	Harris Yulin
590099	1920-01-29	2007-08-30		0	  Madrid, Spain	José Luis de Vilallonga
1431	1936-10-24	\N	​From Wikipedia, the free encyclopedia.  \n\nBill Wyman (born William George Perks; 24 October 1936) is an English musician best known as the bass guitarist for the English rock and roll band The Rolling Stones from 1962 until 1992. Since 1997, he has recorded and toured with his own band, Bill Wyman's Rhythm Kings. He has worked producing both records and film, and has scored music for film in movies and television.\n\nWyman has kept a journal since he was a child after World War II. It has been useful to him as an author who has written seven books, selling two million copies. Wyman's love of art has additionally led to his proficiency in photography and his photographs have hung in galleries around the world.[1] Wyman's lack of funds in his early years led him to create and build his own fretless bass guitar. He became an amateur archaeologist and enjoys relic hunting; The Times published a letter about his hobby (Friday 2 March 2007). He designed and markets a patented "Bill Wyman signature metal detector", which he has used to find relics dating back to era of the Roman Empire in the English countryside. As a businessman, he owns several establishments including the famous Sticky Fingers Café, a rock &amp; roll-themed bistro serving American cuisine first opened in 1989 in the Kensington area of London and later, two additional locations in Cambridge and Manchester, England.\n\nDescription above from the Wikipedia article Bill Wyman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lewisham, London, England United Kingdom	Bill Wyman
1432	1948-01-17	\N	​From Wikipedia, the free encyclopedia.  \n\nMichael Kevin "Mick" Taylor (born 17 January 1949 in Welwyn Garden City, Hertfordshire) is an English musician, best known as a former member of John Mayall's Bluesbreakers (1966–69) and The Rolling Stones (1969–74). During his tenure with those bands, Taylor gained a reputation as a reliable technical guitarist with a preference for blues, rhythm and blues, and rock and roll, and a talent for slide guitar. Since his resignation from the Rolling Stones in December 1974 at age 25, Taylor has worked with numerous other artists as well as releasing a number of solo albums.\n\nDescription above from the Wikipedia article Mick Taylor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Welwyn Garden City, England United Kingdom	Mick Taylor
1433	\N	\N		0		Marty Balin
1435	\N	\N		0		Sonny Barger
1436	1907-07-29	1996-07-09		0		Melvin Belli
1437	\N	\N		0		Dick Carter
1438	\N	\N		0		Jack Casady
1439	\N	\N		0		Mike Clarke
1440	\N	\N		0		Sam Cutler
1441	\N	\N		0		Spencer Dryden
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
406204	\N	\N	Ve Neill (born Mary Flores) is an American makeup artist. She has won three Academy Awards, for the films Beetlejuice, Mrs. Doubtfire and Ed Wood. She has been nominated for eight Oscars total.[1]  Neill serves as a judge on the 2011 Syfy original series Face Off which features makeup artists competing for $100,000.[2]  Ve Neill has worked on all of the films of the Pirates of the Caribbean franchise. Other notable films she has worked on are Austin Powers in Goldmember, A.I. Artificial Intelligence, Hook, and Edward Scissorhands.	0		Ve Neill
1746	\N	\N		0		Alan Dean Foster
1423674	\N	\N		0		Loye Payen
556171	1940-03-15	\N	From Wikipedia, the free encyclopedia.  Phillip Chapman Lesh (born March 15, 1940 in Berkeley, California) is a musician and a founding member of the Grateful Dead, with whom he played bass guitar throughout their 30-year career.\n\nAfter the band's disbanding in 1995, Lesh continued the tradition of Grateful Dead family music with side project Phil Lesh and Friends, which paid homage to the Dead's music by playing their originals, common covers, and the songs of the members of his band. Phil &amp; Friends helped keep a legitimate entity for the band's music to continue but have been on hiatus since 2008. Recently, Lesh has been performing with Furthur alongside former Dead bandmate Bob Weir.\n\nDescription above from the Wikipedia article Phil Lesh, licensed under CC-BY-SA,full list of contributors on Wikipedia. \n\n  \n\n 	0	Berkeley, California, USA	Phil Lesh
139002	1931-01-10	1987-01-03	From Wikipedia, the free encyclopedia\n\nAlbert (born November 26, 1926, Boston, Massachusetts) and David Maysles (rhymes with "hazels", born 10 January 1932, Boston, Massachusetts) were a documentary filmmaking team whose cinéma vérité works include Salesman (1968), Gimme Shelter (1970) and Grey Gardens (1976). Their 1964 film on The Beatles forms the backbone of the DVD, The Beatles: The First U.S. Visit. Several Maysles films document art projects by Christo and Jeanne-Claude over a three-decade period, from 1974 when Christo's Valley Curtain was nominated for an Academy Award to 2005 when The Gates headlined New York's Tribeca Film Festival.\n\nDavid Maysles, the younger brother, died of a stroke on January 3, 1987, in New York. Albert Maysles graduated in 1949 with a BA from Syracuse University and later earned a masters degree at Boston University. Albert has continued to make films on his own since his brother's death. Jean-Luc Godard once called Albert Maysles "the best American cameraman". In 2005 Maysles was given a lifetime achievement award at the Czech film festival AFO (Academia Film Olomouc). He is working on his own autobiographical documentary.\n\nIn 2005 he founded the Maysles Institute, a nonprofit organization that provides training and apprenticeships to underprivileged individuals. Albert is a patron of Shooting People, a filmmakers' community.\n\nDescription above from the Wikipedia article Albert and David Maysles, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brookline, Massachusetts, USA	David Maysles
1748	1931-03-22	\N	From Wikipedia, the free encyclopedia\n\nWilliam Shatner (born March 22, 1931) is a Canadian actor, musician, singer, author, film director, spokesman and comedian. He gained worldwide fame and became a cultural icon for his portrayal of Captain James Tiberius Kirk, commander of the Federation starship USS Enterprise, in the science fiction television series Star Trek, from 1966 to 1969; Star Trek: The Animated Series from 1973 to 1974, and in seven of the subsequent Star Trek feature films from 1979 to 1994. He has written a series of books chronicling his experiences playing Captain Kirk and being a part of Star Trek, and has co-written several novels set in the Star Trek universe. He has also authored a series of science fiction novels called TekWar that were adapted for television.\n\nShatner also played the eponymous veteran police sergeant in T. J. Hooker from 1982 to 1986. Afterwards, he hosted the reality-based television series Rescue 911 from 1989 to 1996, which won a People's Choice Award for Favorite New TV Dramatic Series. He has since worked as a musician, author, director and celebrity pitchman. From 2004 to 2008, he starred as attorney Denny Crane in the television dramas The Practice and its spin-off Boston Legal, for which he won two Emmy Awards and a Golden Globe Award.	2	Montreal, Quebec, Canada	William Shatner
1749	1931-03-26	2015-02-27	Leonard Nimoy was an American actor, film director, poet, musician and photographer. Nimoy's most famous role is that of Spock in the original Star Trek series 1966–1969, multiple films, television and video game sequels.\n\nNimoy began his career in his early twenties, teaching acting classes in Hollywood and making minor film and television appearances through the 1950s, as well as playing the title role in Kid Monk Baroni. In 1953, he served in the United States Army. In 1965, he made his first appearance in the rejected Star Trek pilot, "The Cage", and would go on to play the character of Mr. Spock until 1969, followed by seven further films and a number of guest slots in various sequels. His character of Spock generated a significant cultural impact and three Emmy Award nominations; TV Guide named Spock one of the 50 greatest TV characters. Nimoy also had a recurring role in Mission: Impossible and a narrating role in Civilization IV, as well as several well-received stage appearances. Nimoy's fame as Spock is such that both his autobiographies, I Am Not Spock (1977) and I Am Spock (1995) detail his existence as being shared between the character and himself.\n\nNimoy was born to Yiddish-speaking Orthodox Jewish immigrants from Iziaslav, Ukraine. His father, Max Nimoy, owned a barbershop in the Mattapan section of the city. His mother, Dora Nimoy (née Spinner), was a homemaker. Nimoy began acting at the age of eight in children's and neighborhood theater. His parents wanted him to attend college and pursue a stable career, or even learn to play the accordion—which, his father advised, Nimoy could always make a living with—but his grandfather encouraged him to become an actor. His first major role was at 17, as Ralphie in an amateur production of Clifford Odets' Awake and Sing!. Nimoy took Drama classes at Boston College in 1953 but failed to complete his studies, and in the 1970s studied photography at the University of California, Los Angeles. He has an MA in Education and an honorary doctorate from Antioch University in Ohio. Nimoy served as a sergeant in the U.S. Army from 1953 through 1955, alongside fellow actor Ken Berry and architect Frank Gehry.	2	Boston, Massachusetts, USA	Leonard Nimoy
1752	1937-04-20	\N	George Hosato Takei Altman (born April 20, 1937) is an American actor of Japanese descent, best known for his role in the television series Star Trek, in which he played Hikaru Sulu, helmsman of the USS Enterprise. He is a proponent of gay rights and active in state and local politics as well as continuing his acting career. He has won several awards and accolades in his work on human rights and Japanese-American relations, including his work with the Japanese American National Museum. Description above from the Wikipedia article George Takei, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles - California - USA	George Takei
1751	1920-03-03	2005-07-20	From Wikipedia, the free encyclopedia.  James Montgomery "Jimmy" Doohan ( March 3, 1920 – July 20, 2005) was a Canadian character and voice actor best known for his role as Montgomery "Scotty" Scott in the television and film series Star Trek. Doohan's characterization of the Scottish Chief Engineer of the Starship Enterprise was one of the most recognizable elements in the Star Trek franchise, for which he also made several contributions behind the scenes. Many of the characterizations, mannerisms, and expressions that he established for Scotty and other Star Trek characters have become entrenched in popular culture.  Following his success with Star Trek, he supplemented his income and showed continued support for his fans by making numerous public appearances. Doohan often went to great lengths to buoy the large number of fans who have been inspired to make their own accomplishments in engineering and other fields, as a result of Doohan's work and his encouragement.  Description above from the Wikipedia article James Doohan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Vancouver, British Columbia, Canada	James Doohan
1754	1936-09-14	\N	Walter Marvin Koenig is an American actor, writer, teacher and director, known for his roles as Pavel Chekov in Star Trek and Alfred Bester in Babylon 5. He wrote the script for the 2008 science fiction legal thriller InAlienable.	2	Chicago, Illinois USA	Walter Koenig
1753	1932-12-28	\N	​From Wikipedia, the free encyclopedia.    Nichelle Nichols (born Grace Nichols; December 28, 1932) is an American actress, singer and voice artist. She sang with Duke Ellington and Lionel Hampton before turning to acting. Her most famous role is that of communications officer Lieutenant Uhura aboard the USS Enterprise in the popular Star Trek television series, as well as the succeeding motion pictures, where her character was eventually promoted in Starfleet to the rank of commander. In 2006, she added executive producer to her résumé.  Description above from the Wikipedia article Nichelle Nichols, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Robbins, Illinois, USA	Nichelle Nichols
1760	1929-02-10	2004-07-21	Jerrald King "Jerry" Goldsmith (February 10, 1929 – July 21, 2004) was an American composer and conductor most known for his work in film and television scoring. He composed scores for such noteworthy films as The Sand Pebbles, Logan's Run, Planet of the Apes, Patton, Papillon, Chinatown, The Wind and the Lion, The Omen, The Boys from Brazil, Capricorn One, Alien, Poltergeist, The Secret of NIMH, Gremlins, Hoosiers, Total Recall, Basic Instinct, Rudy, Air Force One, L.A. Confidential, Mulan, The Mummy, three Rambo films, and five Star Trek films.\n\nHe collaborated with some of film history's most accomplished directors, including Robert Wise, Howard Hawks, Otto Preminger, Joe Dante, Richard Donner, Roman Polanski, Ridley Scott, Steven Spielberg, Paul Verhoeven, and Franklin J. Schaffner.\n\nGoldsmith was nominated for six Grammy Awards, five Primetime Emmy Awards, nine Golden Globe Awards, four British Academy Film Awards, and eighteen Academy Awards (he won only one, in 1976, for The Omen).	2	Pasadena, California, USA	Jerry Goldsmith
1750	1920-01-20	1999-06-11	From Wikipedia, the free encyclopedia\n\nJackson DeForest Kelley  (January 20, 1920 – June 11, 1999) was an American actor, screenwriter,  poet and singer known for his iconic roles in Westerns and as Dr. Leonard "Bones" McCoy of the USS Enterprise in the television and film series Star Trek.Kelley was delivered by his uncle at his parents' home in Atlanta, the son of Clora (née Casey) and Ernest David Kelley, who was a Baptist minister of Irish and Southern ancestry. DeForest was named after the pioneering electronics engineerLee De Forest, and later named his Star Trek character's father "David" after his own. Kelley had an older brother, Ernest Casey Kelley.As a child, he often played outside for hours at a time. Kelley was immersed in his father's mission in Conyers  and promised his father failure would mean "wreck and ruin". Before the  end of his first year at Conyers, Kelley was introduced into the  congregation to his musical talents and often sang solo in morning  church services.Eventually, this led to an appearance on the radio station WSB AM in Atlanta, Georgia. As a result of his radio work, he won an engagement with Lew Forbes and his orchestra at the Paramount Theater.In  1934, the family left Conyers for the community of Decatur. He attended  the Decatur Boys High School where he played on the Decatur Bantams  baseball team. Kelley also played football and other sports. Before his  graduation, Kelley got a job as a drugstore car hop. He spent his  weekends working in the local theatres. Kelley graduated in 1938.During World War II, Kelley served as an enlisted man in the United States Army Air Forces between March 10, 1943, and January 28, 1946, assigned to the First Motion Picture Unit. After an extended stay in Long Beach, California,  Kelley decided to pursue an acting career and relocate to southern  California permanently, living for a time with his uncle Casey. He  worked as an usher in a local theater in order to earn enough money for  the move. Kelley's mother encouraged her son in his new career goal, but  his father disliked the idea. While in California, Kelley was spotted  by a Paramount Pictures scout while doing a United States Navy training film.	0	Atlanta, Georgia, USA	DeForest Kelley
1755	1932-02-23	2008-12-18	Majel Barrett-Roddenberry  (born Majel Leigh Hudec; February 23, 1932 – December 18, 2008) was an American actress and producer. She is perhaps best known for her role as Nurse Christine Chapel in the original Star Trek series, and for being the voice of most onboard computer interfaces throughout the series. She was also the wife of Star Trek creator Gene Roddenberry. As a result of her marriage to Gene Roddenberry and her ongoing relationship with Star Trek – participating in some way in every series to date – she was sometimes referred to as "the First Lady of Star Trek". She and Gene Roddenberry were married in Japan on August 6, 1969, after the cancellation of the Star Trek: The Original Series. They had one son together, Eugene "Rod" Roddenberry, Jr., born in 1974.\n\nDescription above from the Wikipedia article Majel Barrett, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Columbus, Ohio, USA	Majel Barrett
1756	1947-10-01	\N		0		Stephen Collins
1757	1948-10-02	1998-08-18	​From Wikipedia, the free encyclopedia\n\nPersis Khambatta (2 October 1948 – 18 August 1998) was an Indian model, actress and author. She was best known for her role as Lieutenant Ilia in the 1979 feature film Star Trek: The Motion Picture. The name Persis is Greek meaning Persian woman and can be found in the Bible.\n\nDescription above from the Wikipedia article Persis Khambatta, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Bombay, Maharashtra, India	Persis Khambatta
1759	1930-04-01	2015-05-01		0		Grace Lee Whitney
1820	1924-10-15	1996-11-22		0		Mark Lenard
168423	1957-12-13	\N		0	New Jersey, USA	Billy Van Zandt
44054	1949-06-12	\N		2	 Washington, District of Columbia, USA	Roger Aaron Brown
178145	\N	\N		0		Gary Faga
72658	1952-07-15	1990-05-21		0		Franklyn Seales
1744	1914-09-10	2005-09-14	From Wikipedia, the free encyclopedia\n\nRobert Earl Wise (September 10, 1914 – September 14, 2005) was an American sound effects editor, film editor, film producer and director. He won Academy Awards as Best Director for The Sound of Music (1965) and West Side Story (1961) as well as nominations as Best Film Editing for Citizen Kane (1941) and Best Picture for The Sand Pebbles (1966).\n\nAmong his other films are Born to Kill; Destination Gobi; The Hindenburg; Star Trek: The Motion Picture; The Day the Earth Stood Still; Run Silent, Run Deep; The Andromeda Strain; The Set-Up; The Haunting; and The Body Snatcher. Wise's working period spanned the 1930s to the 1990s.\n\nOften contrasted with contemporary "auteur" directors such as Stanley Kubrick who tended to bring a distinctive directorial "look" to a particular genre, Wise is famously viewed to have allowed his (sometimes studio assigned) story to dictate style. Later critics such as Martin Scorsese would go on to expand that characterization, insisting that despite Wise's notorious workaday concentration on stylistic perfection within the confines of genre and budget, his choice of subject matter and approach still functioned to identify Wise as an artist and not merely an artisan. Through whatever means, Wise's approach would bring him critical success as a director in many different traditional film genres: from horror to noir to Western to war films to science fiction, to musical and drama, with many repeat hits within each genre. Wise's tendency towards professionalism led to a degree of preparedness which, though nominally motivated by studio budget constraints, nevertheless advanced the moviemaking art, with many Academy Award-winning films the result. Robert Wise received the AFI Life Achievement Award in 1998.\n\n \n\nDescription above from the Wikipedia article Robert Wise, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Winchester, Indiana, USA	Robert Wise
1745	1921-08-19	1991-10-24	From Wikipedia, the free encyclopedia  Eugene Wesley "Gene" Roddenberry, Sr (August 19, 1921 –\n\nOctober 24, 1991) was an American television screenwriter, producer\n\nand futurist, best known for creating the American science fiction\n\nseries Star Trek. Born in El Paso, Texas, Roddenberry grew up in Los\n\nAngeles, California where his father worked as a police officer.\n\nRoddenberry flew 89 combat missions in the United States Army Air\n\nForces during World War II, and worked as a commercial pilot after\n\nthe war. He later followed in his father's footsteps, joining the Los\n\nAngeles Police Department to provide for his family, but began\n\nfocusing on writing scripts for television.  As a freelance writer, Roddenberry wrote scripts for Highway\n\nPatrol, Have Gun, Will Travel and other series, before creating and\n\nproducing his own television program, The Lieutenant. In 1964,\n\nRoddenberry created Star Trek, and it premiered in 1966, running for\n\nthree seasons before cancellation. Syndication of Star Trek led to\n\nincreasing popularity, and Roddenberry continued to create, produce,\n\nand consult on Star Trek films and the television series, Star Trek:\n\nThe Next Generation until his death. Roddenberry received a star on\n\nthe Hollywood Walk of Fame and he was inducted into the Science\n\nFiction Hall of Fame and the Academy of Television Arts &amp;\n\nSciences' Hall of Fame. Years after his death, Roddenberry was one of\n\nthe first humans to have his ashes "buried" in outer space.  The fictional Star Trek universe Roddenberry created has spanned\n\nover four decades, producing six television series, 715 episodes and\n\neleven films, with a twelfth film currently in development and\n\nscheduled for a 2012 release.  Description above from the Wikipedia article Gene Roddenberry,\n\nlicensed under CC-BY-SA, full list of contributors on Wikipedia.	0	El Paso, Texas, USA	Gene Roddenberry
1747	\N	\N		0		Harold Livingston
1761	1919-12-10	2008-05-15		0		Alexander Courage
1762	1926-11-15	\N		2	Los Angeles, California, USA	Richard H. Kline
1765	1920-02-15	2007-03-01		0		Harold Michelson
1767	\N	\N		0		Todd C. Ramsay
1642	1960-09-27	\N	From Wikipedia, the free encyclopedia\n\nJean-Marc Barr (born on 27 September 1960 in Bitburg, Rhineland-Palatinate, Germany) is a French-American film actor and director. His mother is French. His American father was in the US Air Force and served in the Second World War. Jean-Marc Barr is primarily known as an actor, but is also a film director, screenwriter and producer. Barr is bilingual in French and English: he speaks French with a nasal, hybrid accent, reminiscent of his American upbringing - with a slight American accent and occasional anglicisms in interviews - and English with a Mid-Atlantic accent.\n\nHe studied philosophy at the University of California, Los Angeles, the Paris Conservatoire and the Sorbonne. He went on to pursue an education in drama at the Guildhall School of Music and Drama in London. In London he met his future wife, a pianist and composer Irina Dečermić.\n\nJean-Marc Barr began working in theatre in France in 1986. After some television roles and film work, in particular, Hope and Glory (1987) by John Boorman, he was cast in the tremendously successful The Big Blue (1988). Luc Besson cast him in the role of French diver Jacques Mayol. He played in the role opposite Rosanna Arquette and Jean Reno. The Big Blue was the most financially successful film in France in the 1980s.\n\nIn 1991, he starred in Danish director Lars von Trier's Europa, marking the beginning of a long friendship (he is the godfather of von Trier's children) as well as a significant professional relationship. He went on to appear in von Trier’s Europa (1991), Breaking the Waves (1996), Dancer in the Dark (2000), Dogville (2004) and Manderlay (2005). Also in 2005 he starred in the French film Crustacés et Coquillages.\n\nHis collaboration with von Trier put him on track to start directing his own work. He debuted in 1999 as a director, screenwriter and producer with the intimate love story Lovers. This film became the first part of a trilogy; the two subsequent parts being the drama Too Much Flesh (2000) and the comedy Being Light (2001) which he co-directed with Pascal Arnold.\n\nHe may also be recognized for his role as the attractive divorce lawyer, Maitre Bertram in the Merchant Ivory film le Divorce (2003). He appeared as Hugo in The Red Siren in 2002. He appeared as the main character in the video for Blur's 1995 single, "Charmless Man".\n\nDescription above from the Wikipedia article Jean-Marc Barr, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Bitburg, Rhineland-Palatinate, Germany	Jean-Marc Barr
1003	1948-07-30	\N	Jean Reno ( born July 30, 1948) is a French actor. Working in French, English, and Italian, he has appeared not only in numerous successful Hollywood productions such as The Pink Panther, Godzilla, The Da Vinci Code, Mission: Impossible, Ronin and Couples Retreat, but also in European productions such as the French films Les Visiteurs (1993) and Léon (1994) along with the 2005 Italian film The Tiger and the Snow.\n\nDescription above from the Wikipedia article Jean Reno , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Casablanca, Morocco	Jean Reno
2165	1959-08-10	\N	From Wikipedia, the free encyclopedia.\n\nRosanna Lisa Arquette (born August 10, 1959) is an American actress, film director, and producer. She was born in New York City, the daughter of Brenda Olivia "Mardi" (née Nowak), an actress, poet, theater operator, activist, acting teacher, and therapist, and Lewis Arquette, an actor and director. Her siblings, Patricia, Alexis, Richmond, and David Arquette, are also actors.	1	New York City, New York, USA	Rosanna Arquette
2166	1953-08-18	\N		0		Sergio Castellitto
2168	1929-06-03	1989-07-06	Jean Bouise est un acteur français, né le 3 juin 1929 au Havre et mort le 6 juillet 1989 à Lyon (8e). Habitué des seconds rôles, il apparaît régulièrement au cinéma depuis le milieu des années 1960 jusqu’à sa mort.\n\n Diplômé de l'École supérieure de chimie de Rouen, Jean Bouise suit un stage de théâtre en 1950. Il rencontre ensuite Roger Planchon et participe à la naissance du théâtre de la Comédie de Lyon. Il est aussi de l'aventure du théâtre de la Cité de Villeurbanne, devenu le TNP en 1972. Il interprète aussi bien les classiques du répertoire (Georges Dandin,Tartuffe, Le Brave Soldat Schweick, etc.) que les créations du metteur en scène.  Il décroche son premier rôle au cinéma en 1962 dans L'Autre Cristobal d'Armand Gatti, présenté au Festival de Cannes 1963, mais jamais distribué en salle. Il joue ensuite le capitaine Haddock dans Tintin et les oranges bleues. De film en film, Jean Bouise devient un des seconds rôles incontournables du cinéma français. Il apparaît ainsi dans Les Choses de la vie de Claude Sautet, Monsieur Klein de Joseph Losey, Z et L'Aveu de Costa-Gavras. Sa prestation dans le Vieux Fusil de Robert Enrico lui vaut une première nomination au César du meilleur acteur dans un second rôle en 1976, récompense qu'il recevra en 1980 pour Coup de tête. Il devient par la suite un des acteurs-fétiches de Luc Besson : vieil homme qui réapprend à parler à Pierre Jolivet dans Le Dernier Combat, chef de station dans Subway, oncle Louis dansLe Grand Bleu et attaché à l'ambassade d'URSS en France dans Nikita qui sera son dernier rôle.  Son jeu retenu, sa moustache fournie (qu'il ne porte cependant pas au début), sa voix profonde, ses petits yeux de myope masqués derrière des lunettes, le destinent souvent à des rôles inquiétants, mais également à des personnages pleins d’humanité, dans lesquels il s’avère particulièrement touchant. Il est ainsi devenu un des plus grands « seconds rôles » du cinéma français.  Il meurt le 6 juillet 1989 à l'Hôpital Léon-Bérard de Lyon d'un cancer du poumon. « On arrivait tellement à le croire, qu'il a disparu sans qu'on s'en aperçoive », remarque Luc Besson dans son hommage. Son dernier film, Nikita, qu’il ne verra jamais fini, lui sera dédié par le réalisateur. Il est enterré au cimetière de Saint-Hilaire-de-Brens, dans l'Isère.  Il était marié à la comédienne Isabelle Sadoyan.\n\n    	0	Le Havre - Seine-Maritime - France	Jean Bouise
2170	1957-09-28	\N		0	Nice, France	Marc Duret
2171	1955-06-08	\N	Griffin Dunne (born June 8, 1955) is an American actor and film director, known for his roles in An American Werewolf in London (1981) and After Hours (1985).	0	New York City, New York, USA	Griffin Dunne
2172	1932-08-22	2010-06-08		0		Andréas Voutsinas
2173	1964-12-31	\N	From Wikipedia, the free encyclopedia\n\nValentina Vargas (born December 31, 1964) is a Chilean-born actress. She developed most of her career in France, where she was raised.\n\nVargas began her career in the dramatic art within the workshop of Tania Balaschova in Paris and also later at the Yves Pignot School of Los Angeles. Her cinematographic career started via the filming of three of the most important works[dubious – discuss] in contemporary French cinema, namely Pierre Jolivet's Strictly Personal, Luc Besson's Big Blue and Jean-Jacques Annaud's The Name of the Rose. Over the years, Vargas also worked with Samuel Fuller in Street of No Return, Miguel Littín in Los náufragos and Alfredo Arieta in Fuegos.\n\nVargas is trilingual in Spanish, French and English. This has enabled her to pass without notice in films as varied as the cinematic horror film Hellraiser IV: Bloodline where she played the Cenobite Angelique, to the comedy Chili con carne of Thomas Gilou. She appeared opposite Jan Michael Vincent (Dirty Games), Malcolm McDowell and Michael Ironside (Southern Cross), and James Remar (The Tigress).\n\nAfter her performance in Bloody Mallory where she played "the malicious one", she turned to playing roles for television. Initially she played in a version of Les Liaisons dangereuses directed by Josée Dayan. She starred in this production with Catherine Deneuve, Rupert Everett, Leelee Sobieski and Nastassja Kinski.	1	Santiago de Chile, Chile	Valentina Vargas
2174	1956-01-09	\N	From Wikipedia, the free encyclopedia.\n\nKimberly Beck (born January 9, 1956; Glendale, California) is an American actress with over sixty television and film roles to her credit.\n\nDescription above from the Wikipedia article Kimberly Beck, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Glendale, California, U.S.	Kimberly Beck
2175	\N	\N		0		Bruce Guerre-Berthelot
2180	\N	\N		0		Gregory Forstner
2181	\N	\N		0		Claude Besson
59	1959-03-18	\N	Luc Besson is a French film director, writer, and producer known for making highly visual thriller and action films.  Besson has been nominated for, and won, numerous awards and honors from the foreign press, and is often credited as inventing the so-called "Cinema du look" movement in French film.  \n\nBorn in Paris, Besson spent his childhood traveling Europe with his parents and developing an enthusiasm for ocean diving, before an accident would push him toward the world of cinema.  After taking odd jobs in the Parisian film scene of the time, Besson began writing stories which would eventually evolve into some of his greatest film successes: The Fifth Element and Le Grand Bleu.  \n\nIn 1980 he founded his own production company, Les Films du Loup later Les Films du Dauphin,and later still EuropaCorp film company with his longtime collaborator, Pierre-Ange Le Poga. Besson's work stretches over twenty-six years and encompasses at least fifty-films.  .	2	Paris, France	Luc Besson
2158	\N	\N		0		Robert Garland
2159	\N	\N		0		Marilyn Goldin
2160	\N	\N		0		Carlo Varini
996	1959-09-09	\N		0		Eric Serra
60	\N	\N		0		Patrice Ledoux
2183	\N	\N		0		Olivier Mauffroy
2186	\N	\N		0		Nathalie Cheron
1000	\N	\N		0		Dan Weil
2187	\N	\N		0		Pierre Befve
2799	\N	\N		0		Jacques Mayol
2800	\N	\N		0		Marc Perrier
2798	1887-12-28	1941-07-15		2	Frankfurt-on-Main, Germany	Walter Ruttmann
3359	1907-05-22	1989-07-11	From Wikipedia, the free encyclopedia.  Laurence Kerr Olivier, Baron Olivier, OM (22 May 1907 – 11 July 1989) was an English actor, director, and producer. He was one of the most famous and revered actors of the 20th century. He married three times, to fellow actors Jill Esmond, Vivien Leigh, and Joan Plowright.\n\nOlivier played a wide variety of roles on stage and screen from Greek tragedy, Shakespeare and Restoration comedy to modern American and British drama. He was the first artistic director of the National Theatre of Great Britain and its main stage is named in his honour. He is regarded by some to be the greatest actor of the 20th century, in the same category as David Garrick, Richard Burbage, Edmund Kean and Henry Irving in their own centuries. Olivier's AMPAS acknowledgments are considerable: fourteen Oscar nominations, with two awards (for Best Actor and Best Picture for the 1948 film Hamlet), and two honorary awards including a statuette and certificate. He was also awarded five Emmy awards from the nine nominations he received. Additionally, he was a three-time Golden Globe and BAFTA winner.\n\nOlivier's career as a stage and film actor spanned more than six decades and included a wide variety of roles, from the title role in Shakespeare's Othello and Sir Toby Belch in Twelfth Night to the sadistic Nazi dentist Christian Szell in Marathon Man and the kindly but determined Nazi-hunter in The Boys from Brazil. A High church clergyman's son who found fame on the West End stage, Olivier became determined early on to master Shakespeare, and eventually came to be regarded as one of the foremost Shakespeare interpreters of the 20th century. He continued to act until the year before his death in 1989. Olivier played more than 120 stage roles: Richard III, Macbeth, Romeo, Hamlet, Othello, Uncle Vanya, and Archie Rice in The Entertainer. He appeared in nearly sixty films, including William Wyler's Wuthering Heights, Alfred Hitchcock's Rebecca, Stanley Kubrick's Spartacus, Otto Preminger's Bunny Lake Is Missing, Richard Attenborough's Oh! What a Lovely War, and A Bridge Too Far, Joseph L. Mankiewicz's Sleuth, John Schlesinger's Marathon Man, Daniel Petrie's The Betsy, Desmond Davis' Clash of the Titans, and his own Henry V, Hamlet, and Richard III. He also preserved his Othello on film, with its stage cast virtually intact. For television, he starred in The Moon and Sixpence, John Gabriel Borkman, Long Day's Journey into Night, Brideshead Revisited, The Merchant of Venice, Cat on a Hot Tin Roof, and King Lear, among others.\n\nIn 1999, the American Film Institute named Olivier among the Greatest Male Stars of All Time, at number 14 on the list.\n\nDescription above from the Wikipedia article Laurence Olivier, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dorking, Surrey, England, UK	Laurence Olivier
3360	1917-10-22	2013-12-15	Born Joan de Beauvoir de Havilland on October 22, 1917, in Tokyo, Japan, in what was known as the International Settlement. Her father was a British patent attorney with a lucrative practice in Japan, but due to Joan and older sister Olivia de Havilland's recurring ailments the family moved to California in the hopes of improving their health. Mrs. de Havilland and the two girls settled in Saratoga while their father went back to his practice in Japan. Joan's parents did not get along well and divorced soon afterward. Mrs. de Havilland had a desire to be an actress but her dreams were curtailed when she married, but now she hoped to pass on her dream to Olivia and Joan.\n\nWhile Olivia pursued a stage career, Joan went back to Tokyo, where she attended the American School. In 1934 she came back to California, where her sister was already making a name for herself on the stage. Joan likewise joined a theater group in San Jose and then Los Angeles to try her luck there. After moving to L.A., Joan adopted the name of Joan Burfield because she didn't want to infringe upon Olivia, who was using the family surname. She tested at MGM and gained a small role in No More Ladies (1935), but she was scarcely noticed and Joan was idle for a year and a half. During this time she roomed with Olivia, who was having much more success in films.\n\nIn 1937, this time calling herself Joan Fontaine, she landed a better role as Trudy Olson in You Can't Beat Love (1937) and then an uncredited part in Quality Street (1937). Although the next two years saw her in better roles, she still yearned for something better. In 1940 she garnered her first Academy Award nomination for Rebecca (1940). Although she thought she should have won, (she lost out to Ginger Rogers in Kitty Foyle (1940)), she was now an established member of the Hollywood set. She would again be Oscar-nominated for her role as Lina McLaidlaw Aysgarth in Suspicion (1941), and this time she won.\n\nJoan was making one film a year but choosing her roles well. In 1942 she starred in the well-received This Above All (1942). The following year she appeared in The Constant Nymph (1943). Once again she was nominated for the Oscar, she lost out to Jennifer Jones in The Song of Bernadette (1943). By now it was safe to say she was more famous than her older sister and more fine films followed. In 1948, she accepted second billing to Bing Crosby in The Emperor Waltz (1948).\n\nJoan took the year of 1949 off before coming back in 1950 with September Affair (1950) and Born to Be Bad (1950). In 1951 she starred in Paramount's Darling, How Could You! (1951), which turned out badly for both her and the studio and more weak productions followed. Absent from the big screen for a while, she took parts in television and dinner theaters. She also starred in many well-produced Broadway plays such as Forty Carats and The Lion in Winter. Her last appearance on the big screen was The Witches (1966) and her final appearance before the cameras was Good King Wenceslas (1994). She is, without a doubt, a lasting movie icon.	1	Tokyo, Japan	Joan Fontaine
4776	1938-05-05	\N	​From Wikipedia, the free encyclopedia\n\nMichael George Murphy (born May 5, 1938) is an American film and television actor.\n\nDescription above from the Wikipedia article Michael Murphy (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles, California, USA	Michael Murphy
2130	1962-10-26	\N	Cary Elwes is the third son born to interior designer/shipping heiress Tessa Kennedy and the late portrait painter Dominick Elwes, and is the brother of producer/agent Cassian Elwes and artist Damian Elwes. He was born and raised in London and attended Harrow. After graduating from Harrow, he moved to the US and studied drama at Sarah Lawrence College. He left school after two years to begin his film career. Cary is well respected by colleagues and fans alike and considered by many to be one of the finest young actors working today. He is interested in history and says, "It's deliberate that a lot of my films have been period pieces". He is politically active for causes he believes in, such as protecting the environment and helping Native American peoples. He is married to Lisa Marie Kurbikoff, a stills photographer.	2	London - England - UK	Cary Elwes
2491	1908-10-06	1942-01-16	From Wikipedia, the free encyclopedia.\n\nCarole Lombard (October 6, 1908 – January 16, 1942) was an American actress. She was particularly noted for her comedic roles in several classic films of the 1930s, most notably in the 1936 film My Man Godfrey. She is listed as one of the American Film Institute's greatest stars of all time and was the highest-paid star in Hollywood in the late 1930s, earning around US$500,000 per year (more than five times the salary of the US President). Lombard's career was cut short when she died at the age of 33 in the crash of TWA Flight 3.\n\nDescription above from the Wikipedia article Carole Lombard, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Fort Wayne, Indiana, USA	Carole Lombard
2492	1894-02-14	1974-12-26	From Wikipedia, the free encyclopedia.  Jack Benny (February 14, 1894 – December 26, 1974) was an American comedian, vaudevillian, and actor for radio, television, and film. Widely recognized as one of the leading American entertainers of the 20th century, Benny played the role of the comic penny-pinching miser, insisting on remaining 39 years old on stage despite his actual age, and often playing the violin badly.\n\nBenny was known for his comic timing and his ability to get laughs with either a pregnant pause or a single expression, such as his signature exasperated "Well!" His radio and television programs, tremendously popular from the 1930s to the 1960s, were a foundational influence on the situation comedy genre. Dean Martin, on the celebrity roast for Johnny Carson in November 1973, introduced Benny as "the Satchel Paige of the world of comedy."\n\nDescription above from the Wikipedia article Jack Benny, licensed under CC-BY-SA,full list of contributors on Wikipedia.     	0	Chicago, Illinois, United States	Jack Benny
2493	1919-01-13	2003-05-14	Robert Langford Modini Stack was a multilingual American actor and television host. In addition to acting in more than 40 films, he also appeared on the television series The Untouchables and later served as the host of Unsolved Mysteries.\n\nBorn in Los Angeles, California, Stack spent his early childhood growing up in Europe.  Becoming fluent in French and Italian at an early age, and he did not learn English until returning to Los Angeles.  Stack achieved minor fame in sporting, winning multiple championships including setting two world records and winning multiple honors in skeet shooting\n\nStack studied drama at Bridgewater State College, earning his first hollywood role at the age of 20 and continuing to star in numerous roles throughout the early 1940s.\n\nAfter serving in the military, Stack returned to Hollywood to star in numerous films including stand out roles in The High and the Mighty (opposite John Wayne) and Written on the Wind (1957), for which he was awarded an Academy Award for Best Supporting Actor.\n\nStack later moved on to televised dramatic series, depicting the crime-fighting Eliot Ness in The Untouchables (1959–1963), which earned him a best actor Emmy Award in 1960. Stack also starred in multiple drama series, before returning to film, this time in comedies to satirize his famed stoic and humorless demeanor.\n\nHe began hosting Unsolved Mysteries in 1987, and served as the show's host throughout it's entire original run from 1987 to 2002.	0	Los Angeles, California, USA	Robert Stack
2494	1892-03-02	1949-03-17	From Wikipedia, the free encyclopedia.  Felix Bressart (March 2, 1892 – March 17, 1949) was a German-American actor of stage and screen.\n\nFelix Bressart (pronounced "BRESS-ert") was born in East Prussia, Germany (now part of Russia) and was already a very experienced stage actor when he had his film debut in 1928. He started off as a supporting actor, e.g. as the Bailiff in the box-office hit Die Drei von der Tankstelle (1930), but had soon established himself in leading roles of minor movies. After the Nazis seized power in 1933, Jewish-born Bressart had to leave Germany and continued his career in German-speaking movies in Austria, where Jewish artists were still relatively safe. After no fewer than 30 films in eight years, he emigrated to the United States.\n\nOne of Bressart's former European colleagues was Joe Pasternak, now a successful Hollywood producer. Bressart's first American film was Three Smart Girls Grow Up (1939), a vehicle for Universal Pictures' top attraction, Deanna Durbin. Pasternak also selected the reliable Bressart to perform in a screen test opposite Pasternak's newest discovery, Gloria Jean. The influential German community in Hollywood helped to establish Bressart in America, as his earliest American movies were directed by Ernst Lubitsch, Henry Koster, and Wilhelm Thiele (director of Die Drei von der Tankstelle).\n\nBressart scored a great success in Lubitsch's Ninotchka, produced at Metro-Goldwyn-Mayer. MGM signed Bressart to a studio contract in 1939. Most of his MGM work consisted of featured roles in major films like Edison, the Man.\n\nHe combined his mildly inflected East European accent with a soft-spoken delivery to create kindly, friendly characters, as in Lubitsch's To Be or Not to Be, in which he sensitively recites Shylock's famous "Hath not a Jew eyes?" speech from The Merchant of Venice. Lubitsch also directed Bressart to similar effect in The Shop Around the Corner.\n\nBressart soon became a popular character actor in films like Blossoms in the Dust (1941), The Seventh Cross (1944), and Without Love (1945). Perhaps his largest role was in RKO Radio Pictures' "B" musical comedy Ding Dong Williams, filmed in 1945. Bressart, billed third, played the bemused supervisor of a movie studio's music department, and appeared in formal wear to conduct Chopin's "Fantasie Impromptu."\n\nAfter almost 40 Hollywood pictures, Felix Bressart suddenly died of leukemia at the age of 57. His last film was My Friend Irma (1949), the movie version of a popular radio show. Bressart died during production, forcing the producers to finish the film with Hans Conried. In the final film, Conried speaks throughout, but Bressart is still seen in the long shots.\n\nDescription above from the Wikipedia article Felix Bressart, licensed under CC-BY-SA,full list of contributors on Wikipedia.     	0	Eydtkuhnen, East Prussia, Germany	Felix Bressart
2495	1885-03-01	1946-04-22	From Wikipedia, the free encyclopedia.\n\nLionel Atwill (1 March 1885 – 22 April 1946) was an English stage and film actor born in Croydon, London, England.\n\nHe studied architecture before his stage debut at the Garrick Theatre, London in 1904. He become a star in Broadway theatre by 1918, and made his screen debut in 1919. He acted on the stage in Australia but was most famous for his U.S. horror roles in the 1930s. His two most memorable parts were as the crazed, disfigured sculptor in Mystery of the Wax Museum (Warner Brothers, 1933), and as Inspector Krogh in Son of Frankenstein (1939), memorably sent up by Kenneth Mars in Mel Brooks's Young Frankenstein (1974).\n\nWhen he was not cast in macabre roles, Atwill often appeared in the 1930s as righteous-minded authority figures. For example, in 1937's less memorable The Wrong Road for RKO, investigator Atwill persuades a young, bank-robbing ingenue played by Helen Mack and her boyfriend Richard Cromwell to return their ill-gotten $100,000 and give up a life of crime. Two of Atwill's other notable non-horror roles were opposite his contemporary Basil Rathbone in films featuring Arthur Conan Doyle's character Sherlock Holmes, including a role as Dr. James Mortimer in 20th Century Fox's 1939 film rendition of the Conan Doyle novel The Hound of the Baskervilles, and the 1943 Universal Studios film Sherlock Holmes and the Secret Weapon, in which he played Holmes' archenemy and super-villain, Professor Moriarty.\n\nAtwill remained a stalwart of the Universal horror films until his career flagged in the 1940s because of a widely publicized sex scandal in 1941, during the investigation of which he was charged in 1942 with perjury at a trial in which Atwill had been accused of staging a sex orgy at his home.\n\nHe died while working on the 1946 film serial Lost City of the Jungle. His ashes were once inurned in Chapel of the Pines Crematory.\n\nDescription above from the Wikipedia article Lionel Atwill, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Croydon, London, England, UK	Lionel Atwill
2496	1890-07-17	1951-04-22		0	Southampton, Hampshire, England	Stanley Ridges
2497	1884-10-11	1967-02-14	From Wikipedia, the free encyclopedia.\n\nSig Ruman (October 11, 1884 – February 14, 1967) was a German-American actor known for his comic portrayals of pompous villains.\n\nDescription above from the Wikipedia article Sig Ruman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hamburg, Germany	Sig Ruman
2501	1887-01-01	1955-03-07	Tom Dugan was born on January 1, 1889 in Dublin, Ireland as Thomas J. Dugan. He was an actor, known for To Be or Not to Be (1942), Take Me Out to the Ball Game (1949) and Good News (1947). He was married to Marie Raymond and Marie Engle. He died on March 7, 1955 in Redlands, California.	0	 Dublin, Ireland	Tom Dugan
2502	1876-03-16	1959-04-16	A respected stage actor -- he trained at the New York Academy of  Dramatic Arts -- since the 1920s, birdlike Charles Halton's thinning  hair, rimless glasses and officious manner were familiar to generations  of moviegoers. Whether playing the neighborhood busybody, a stern  government bureaucrat or weaselly attorney, you could count on Halton to  try to drive the "immoral influences" out of the neighborhood,  foreclose on the orphanage, evict the poor widow and her children from  their apartment, or any other number of dastardly deeds, all justified  by "I'm sorry but that's my job." His 40-year film career ended with High School Confidential! (1958), after which he retired.	0	Washington - District of Columbia - USA	Charles Halton
1510	1892-10-02	1945-03-15	From Wikipedia, the free encyclopedia.\n\nHenry Victor (2 October 1892 – 15 March 1945) was an English-born character actor. Raised in Germany, Victor is probably best remembered for his portrayal of the strongman Hercules in Tod Browning's 1932 film Freaks. He originally was a leading figure in UK silent films. Later in his career, he mostly portrayed villains or Nazis in both American and British films with his trademark German accent. He died at 52 of a brain tumor. He is buried in Chatsworth, California's at the Oakwood Memorial Park Cemetery.\n\nDescription above from the Wikipedia article Henry Victor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England	Henry Victor
2503	1875-11-10	1960-10-15		0		Maude Eburne
2489	1896-11-08	1960-09-11	From Wikipedia, the free encyclopedia.  Edwin Justus Mayer (8 November 1896 – 11 September 1960) was an American screenwriter. He wrote or co-wrote the screenplays for 47 films between 1927 and 1958.\n\nHe was born and died in New York, New York. He is the grandfather of film director Daisy von Scherler Mayer.\n\nEdwin Justus Mayer worked on many screenplays. But he is famous today for working with Ernst Lubitsch. He worked with Lubitsch in To Be or Not to Be (1942) and A Royal Scandal (1945). A Royal Scandal (1945) was a box office failure, but today, is considered by many as one of Lubitsch's finest films.\n\nDescription above from the Wikipedia article Edwin Justus Mayer, licensed under CC-BY-SA,full  list of contributors on Wikipedia.     	0	New York, New York	Edwin Justus Mayer
4421	1908-03-07	1973-09-26	From Wikipedia, the free encyclopedia.\n\nAnna Magnani (pronounced: mahn-YANEE; 7 March 1908 – 26 September 1973) was an Italian stage and film actress. She won the Academy Award for Best Actress, along with four other international awards, for her portrayal of a Sicilian widow in The Rose Tattoo.\n\nBorn in Rome to an Egyptian father and an Italian mother, she worked her way through Rome's Academy of Dramatic Art by singing at night clubs. During her career, her only child was stricken by polio when he was 18 months old and remained crippled.\n\nShe was referred to as "La Lupa," the "perennial toast of Rome" and a "living she-wolf symbol" of the cinema. Time magazine described her personality as "fiery", and drama critic Harold Clurman said her acting was "volcanic". In the realm of Italian cinema, she was "passionate, fearless, and exciting," an actress that film historian Barry Monush calls "the volcanic earth mother of all Italian cinema." Director Roberto Rossellini called her "the greatest acting genius since Eleonora Duse. Playwright Tennessee Williams became an admirer of her acting and wrote The Rose Tattoo specifically for her to star in, a role for which she received her first Oscar in 1955.\n\nAfter meeting director Goffredo Alessandrini she received her first screen role in La cieca di Sorrento (The Blind Woman of Sorrento) (1934) and later achieved international fame in Rossellini's Rome, Open City (1945), considered the first significant movie to launch the Italian neorealism movement in cinema. As an actress she became recognized for her dynamic and forceful portrayals of "earthy lower-class women" in such films as The Miracle (1948), Bellissima (1951), The Rose Tattoo (1955), The Fugitive Kind (1960), with Marlon Brando and directed by Sidney Lumet, and Mamma Roma (1962). As early as 1950, Life magazine had already stated that Magnani was "one of the most impressive actresses since Garbo".\n\nDescription above from the Wikipedia article Anna Magnani, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Rome, Italy	Anna Magnani
4425	\N	\N		0		Francesco Grandjacquet
1591432	\N	\N		0		Genevieve Zweig
2428	1892-01-28	1947-11-30	From Wikipedia, the free encyclopedia.\n\nErnst Lubitsch (January 28, 1892 – November 30, 1947) was a German-born  film director. His urbane comedies of manners gave him the reputation of being Hollywood's most elegant and sophisticated director; as his prestige grew, his films were promoted as having "the Lubitsch touch."\n\nIn 1947 he received an Honorary Academy Award for his distinguished contributions to the art of the motion picture, and he was nominated 3 times for Best Director.\n\nDescription above from the Wikipedia article Ernst Lubitsch, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Berlin, Germany	Ernst Lubitsch
2490	1893-09-16	1956-01-23	​From Wikipedia, the free encyclopedia\n\nSir Alexander Korda (16 September 1893 – 23 January 1956) was a Hungarian-born British producer and film director. He was a leading figure in the British film industry, the founder of London Films and the owner of British Lion Films, a film distributing company.\n\nDescription above from the Wikipedia article Alexander Korda, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Pusztatúrpásztó, Austria-Hungary (now Hungary)	Alexander Korda
2498	1880-01-12	1974-10-23	From Wikipedia, the free encyclopedia.  Lengyel was born Lebovics Menyhért in Balmazújváros, Hungary. He started his career as a journalist. He worked first in Kassa (Košice), then later in Budapest.\n\nHis first play, A nagy fejedelem (The Great Prince) was performed by the Thalia Company in 1907. The Hungarian National Theatre performed his next drama A hálás utókor (The Grateful Posterity) in 1908 for which he received the Vojnits Award from the Hungarian Academy of Sciences, given every year for the best play. Taifun (Typhoon), one of his plays, written in 1909, became a worldwide success and is still performed today. It was adapted to the screen in the United States in 1914.\n\nHis articles were often published in Nyugat (West), the most important Hungarian literary journal in the first half of the 20th century. During World War I, he was sent to Switzerland by the Hungarian daily newspaper Az Est (The Evening) as a reporter. His pacifist articles and other publications written in 1918 were also published in German and French papers and were collected in a book called Egyszerű gondolatok (Simple Thoughts).\n\nHis story "The Miraculous Mandarin" (in Hungarian: A csodálatos mandarin), a “pantomime grotesque” came out in 1916. It is the story which inspired Béla Bartók, the famous Hungarian composer, to create in 1924 the ballet The Miraculous Mandarin.\n\nAfter World War I, Lengyel went to the United States for a longer stay and published his experiences in 1922 in a book Amerikai napló (American Journal). In the 1920s, he was active in the film industry. For some time, he was story editor at May-Film in Berlin. In 1929/30, he was co-director of a Budapest theatre. In 1931, he was sent by the Hungarian newspaper Pesti Napló (Pest Journal) to London as its reporter. The story of his Utopian novel A boldog város (The Happy City) came out in 1931; it was set in an American city that lay in the depths of a chasm created by the great Californian earthquake.\n\nHe moved to Hollywood, California in 1937 and became a screenwriter. Some of his stories became worldwide successes, such as Ninotchka (1939), for which he was nominated for the Academy Award for Best Writing, Original Story, and To Be or Not to Be (1942).\n\nLengyel returned to Europe in 1960 and settled down in Italy. In 1963, he received the Great Award of Rome for his literary works.\n\nAfter the Hungarian Revolution of 1956, Lengyel often visited Hungary and wanted to repatriate to his country. However, some weeks after his returning in 1974, he died in Budapest at the age of 94.\n\nThe city library of Balmazújváros, his native town, was named after him in 2004. A complete list of Lengyel's works as well as the articles and references about him and his publications were compiled by one of the librarians on this occasion.\n\nDescription above from the Wikipedia article Edwin Justus Mayer, licensed under CC-BY-SA,full list of contributors on Wikipedia.     	0	Balmazújváros, Hungary	Melchior Lengyel
11593	1898-01-21	1964-10-27	​From Wikipedia, the free encyclopedia\n\nRudolph Maté, A.S.C. (21 January 1898 – 27 October 1964), born Rudolf Matheh or Mayer, was an accomplished cinematographer and film director.\n\nBorn in Kraków (then in Austria-Hungary, now in Poland), Maté started in the film business after his graduation from the University of Budapest. He went on to work as an assistant cameraman in Hungary and later throughout Europe, sometimes with noted colleague Karl Freund. Maté worked on several of Carl Theodor Dreyer's films including The Passion of Joan of Arc (1928) and Vampyr (1932) which led to his being hired as director of photography on a number of prominent films.\n\nMaté worked as cinematographer on Hollywood films from the mid-1930s, including Dodsworth (1936), the Laurel and Hardy feature Our Relations (1936) and Stella Dallas (1937). He was nominated for the Academy Award for Best Cinematography in five consecutive years, for Foreign Correspondent (1940), That Hamilton Woman (1941), The Pride of the Yankees (1942), Sahara (1943), and Cover Girl (1944).\n\nIn 1947, he turned to directing films, his credits include When Worlds Collide (1951), the film noir classic D.O.A. and No Sad Songs for Me (both 1950).\n\nDirected by Maté, The 300 Spartans is a 1962 film depicting the Battle of Thermopylae. Made with the cooperation of the Greek government, it was shot in the village of Perachora in the Peloponnese.\n\nHe died from a heart attack in Hollywood on October 27, 1964 at the age of 66.\n\nDescription above from the Wikipedia article Rudolph Maté, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Krakau, Galicia, Austria-Hungary [now Kraków, Malopolskie, Poland]	Rudolph Maté
2500	1896-02-14	1961-05-30		2		Werner R. Heymann
2505	1940-01-27	\N	James Oliver Cromwell is an American film and television actor, probably best known for his role as Dr. Zefram Cochrane in Star Trek: First Contact. He has been nominated for an Oscar, three Emmy Awards, and four Screen Actors Guild Awards during his career.\n\nCromwell was born in Los Angeles, California and was raised in Manhattan, New York. He was adopted by actress Kay Johnson and actor, director and producer John Cromwell, who was blacklisted during the McCarthy era. He was educated at The Hill School, Middlebury College and Carnegie Institute of Technology (now Carnegie Mellon University), where he studied engineering. Like both his parents, he was drawn to the theater, doing everything from Shakespeare to experimental plays.\n\nHe has long been an advocate of leftist causes. In an October 2008 interview, he strongly attacked the Republican Party and the George W. Bush administration, saying their controversial foreign policy would "either destroy us or the entire planet." He became a vegetarian in 1974 after seeing a stockyard in Texas and experiencing the "smell, terror and anxiety." He became an ethical vegan while playing the character of Farmer Hoggett in the movie Babe in 1995. He frequently speaks out on issues regarding animal cruelty for PETA, largely the treatment of pigs.\n\nCromwell was married to Anne Ulvestad from 1976 to 1986. They had three children. He married his second wife, Julie Cobb, on 29 May 1986.	2	Los Angeles, California, USA	James Cromwell
1981	1952-11-08	\N	Alfre Ette Woodard (born November 8, 1952) is an American film, stage, and television actress. She has been nominated once for an Academy Award and Grammy Awards, 12 times for Emmy Awards (winning four), and has also won a Golden Globe and three Screen Actors Guild Awards. She is known for her role in films such as Cross Creek, Miss Firecracker, Grand Canyon, Passion Fish, Primal Fear, Star Trek: First Contact, Miss Evers' Boys, K-PAX, Radio, Take the Lead and The Family That Preys.	1	Tulsa - Oklahoma - USA	Alfre Woodard
2506	1954-06-28	\N	Alice Maud Krige is a South African actress and producer. Her first feature film role was as the Gilbert and Sullivan singer Sybil Gordon in the 1981 Academy Award-winning film Chariots of Fire. Since then, she has played a variety of roles in a number of genres. Krige first played the role of the Borg Queen in the motion picture Star Trek: First Contact and reprised the role for the final episode of the television series Star Trek: Voyager. A year after the series ended, she reprised the role in "Borg Invasion 4-D" at Star Trek: The Experience.\n\nShe attended Rhodes University in Grahamstown where she pursued an undergraduate degree in psychology and literature, but quickly turned to acting, earning an honors degree in drama from Rhodes, before a moving to London to pursue a new career path. Once in England, she studied drama at the London Central School of Speech and Drama before making her acting performance debut in the 1979 BBC Play for Today.  \n\nAfter achieving critical acclaim for her role in Chariot's of Fire, and continued to star and support in both film and stage theater throughout the 1980s.  This eclectic trend continued into the 1990s before turning to television for both starring and reoccurring minor roles in prominent television series.  In addition, she continued to make sporadic convention appearances and was recently awarded an honorary doctorate in literature from Rhodes University.  Alice Krige is married to writer/director, Paul Schoolman, and lives what she describes as an "itinerant" lifestyle. Although she and her husband maintain a permanent home in the United States, they spend much of their time living and working abroad.	0	Upington, South Africa	Alice Krige
2203	1966-02-13	\N	Neal McDonough was trained at the London Academy of Dramatic Arts and Sciences. His theatre credits include 'Cheap Talk', 'Foreigner', 'As You Like It', 'Rivals', 'A Midsummer Night's Dream', 'Bald Soprano', and 'Waiting for Lefty'. The young actor won a 1991 Best Actor Dramalogue Award for 'Away Alone'. McDonough has been a 'Star Trek' fan since he was a kid. Playing Lieutenant Hawk in 'Star Trek First Contact' was a life-long dream. McDonough has three pictures on his bedroom wall. One is a picture of his mom, the other is the Holy Virgin Mary, and the third is William Shatner as Captain Kirk. He has numerous television credits including 'NYPD Blue', 'Quantum Leap', and the voice of Bruce Banner in the animated series 'The Incredible Hulk' among others. He graduated Syracuse University with a Bachelor of Fine Arts degree in 1988. 	2	Dorchester, Massachusetts, USA	Neal McDonough
60846	1971-09-14	\N		0		Pat Healy
3538	\N	\N		0		Jean-François Adam
2387	1940-07-13	\N	Sir Patrick Hewes Stewart is an English film, television and stage actor. He has had a distinguished career in theatre and television for around half a century. He is most widely known for his television and film roles, as Captain Jean-Luc Picard in Star Trek: The Next Generation and as Professor Charles Xavier in the X-Men films.\n\nStewart was born in Mirfield near Dewsbury in the West Riding of Yorkshire, England, the son of Gladys, a weaver and textile worker, and Alfred Stewart, a Regimental Sergeant Major in the British Army who served with the King's Own Yorkshire Light Infantry and previously worked as a general labourer and as a postman. Stewart and his first wife, Sheila Falconer, have two children: Daniel Freedom and Sophie Alexandra. Stewart and Falconer divorced in 1990. In 1997, he became engaged to Wendy Neuss, one of the producers of Star Trek: The Next Generation, and they married on 25 August 2000, divorcing three years later. Four months prior to his divorce from Neuss, Stewart played opposite actress Lisa Dillon in a production of The Master Builder. The two dated for four years, but are no longer together. He is now seeing Sunny Ozell; at 31, she is younger than his daughter. "I just don't meet women of my age," he explains.\n\nStewart has been a prolific actor in performances by the Royal Shakespeare Company, appearing in over 60 productions.	2	Mirfield, West Yorkshire, England	Patrick Stewart
1213786	1949-02-02	\N	From Wikipedia, the free encyclopedia.\n\nBrent Jay Spiner (/ˈspaɪnər/, born February 2, 1949, height 5' 10" (1,78 m)) is an American actor, best known for his portrayal of the android Lieutenant Commander Data in the television series Star Trek: The Next Generation and four subsequent films. His portrayal of Data in Star Trek: First Contact and of Dr. Brackish Okun in Independence Day, both in 1996, earned him a Saturn Award and Saturn Award nomination respectively.\n\nHe has also enjoyed a career in the theatre and as a musician.\n\nBrent Jay Spiner was born February 2, 1949 in Houston, Texas to Sylvia and Jack Spiner, who owned a furniture store. After his father's death, Spiner was adopted by Sylvia's second husband, Sol Mintz, whose surname he used between 1955 and 1975. Spiner was raised Jewish. He attended Bellaire High School, Bellaire, Texas. Spiner became active on the Bellaire Speech team, winning the national championship in dramatic interpretation. He attended the University of Houston where he performed in local theatre.	2	Houston - Texas - USA	Brent Spiner
2390	1957-02-16	\N	From Wikipedia, the free encyclopedia.\n\nLevardis Robert Martyn Burton, Jr. (born February 16, 1957, height 5' 7" (1,70 m)) professionally known as LeVar Burton, is an American actor, director, producer and author who first came to prominence portraying Kunta Kinte in the 1977 award-winning ABC television miniseries Roots, based on the novel by Alex Haley.\n\nHe is also well known for his portrayal of Geordi La Forge on the syndicated science fiction series Star Trek: The Next Generation and as the host of the PBS children's program Reading Rainbow.	0	Landstuhl - Rhineland-Palatinate - Germany	LeVar Burton
2391	1952-12-09	\N	From Wikipedia, the free encyclopedia.\n\nMichael Dorn (born December 9, 1952, height 6' 2½" (1,89 m)) is an American actor and voice artist who is best known for his role as the Klingon Worf from the Star Trek franchise.\n\nDorn was born in Luling, Texas, the son of Allie Lee (née Nauls) and Fentress Dorn, Jr. He grew up in Pasadena, California. He studied radio and television production at the Pasadena City College. From there he pursued a career in music as a performer with several different rock music bands, travelling to San Francisco and then back to Los Angeles.Dorn first appeared in Rocky (1976) as Apollo Creed's bodyguard, though he was not credited. He first appeared as a guest on the television show W.E.B. in 1978. The producer was impressed with his work, so he introduced Michael to an agent who introduced him to acting teacher Charles Conrad to study acting for six months. He then landed a regular role on the television series CHiPs.	0	Luling - Texas - USA	Michael Dorn
2392	1949-03-02	\N	From Wikipedia, the free encyclopedia.\n\nCheryl Gates McFadden (born March 2, 1949), usually credited as Gates McFadden, is an American actress and choreographer.\n\nShe is best known for portraying the character of Dr. Beverly Crusher in the television and film series Star Trek: The Next Generation. She attended Brandeis University earning B.A Cum Laude in Theater Arts. After graduating from Brandeis, she moved to Paris and studied theater with actor Jacques LeCoq. Before Star Trek: The Next Generation, she was mostly known as a choreographer, often working on Jim Henson productions including the films The Dark Crystal, for which she was a choreographer, Labyrinth, for which she served as Director of Choreography and Puppet Movement, and The Muppets Take Manhattan, in which she has a brief on-screen appearance.\n\nAs a way of distinguishing her acting work from her choreography, she is usually credited as "Gates McFadden" as an actress and "Cheryl McFadden" as a choreographer. She appeared briefly in the Woody Allen film Stardust Memories, and in The Hunt for Red October as Jack Ryan's wife Cathy, though most of her scenes were cut in post-production. In 1987, McFadden was cast as Dr. Beverly Crusher on Star Trek: The Next Generation.\n\nThe Crusher character was slated to be Captain Jean-Luc Picard's love interest, and this aspect of the character is what attracted McFadden to the role. Another important aspect of the character was being a widow balancing motherhood and a career. McFadden left after the first season, in part because series executive producer Gene Roddenberry was never enthusiastic about casting McFadden in the first place.\n\nRoddenberry also wanted to give the role of ship's doctor to actress Diana Muldaur, with whom he had worked on the original Star Trek series and other occasions. Muldaur's character, Dr. Katherine Pulaski, proved very unpopular with fans and left the show after the second season. McFadden was approached to return for the third season. At first she was hesitant, but after a phone call from co-star Patrick Stewart, McFadden was persuaded to reprise her role.	1	Cuyahoga Falls, Ohio, USA	Gates McFadden
2393	1955-03-29	\N	From Wikipedia, the free encyclopedia.\n\nMarina Sirtis (born 29 March 1955, height 5' 4½" (1,64 m)) is an English-American actress. She is best known for her role as Counselor Deanna Troi on the television series Star Trek: The Next Generation and the four feature films that followed.\n\nBiography\n\nMarina Sirtis was born in the East End of London, the daughter of working class Greek parents Despina, a tailor's assistant, and John Sirtis. She was brought up in Harringay, North London and emigrated to the U.S. in 1986, later becoming a naturalized U.S. citizen. She auditioned for drama school against her parents' wishes, ultimately being accepted to the Guildhall School of Music and Drama. She is married to rock guitarist Michael Lamper (21 June 1992 – present). Her younger brother, Steve, played football in Greece and played for Columbia University in the early 1980s. Marina herself is an avowed supporter of Tottenham Hotspur F.C.\n\nCareer\n\nSirtis started her career as a member of the repertory company at the Connaught Theatre, Worthing, West Sussex in 1976. Directed by Nic Young, she appeared in Joe Orton's What the Butler Saw and as Ophelia in Hamlet.\n\nBefore her role in Star Trek, Sirtis was featured in supporting roles in several films. In the 1983 Faye Dunaway film The Wicked Lady, she engaged in a whip fight with Dunaway. In the Charles Bronson sequel Death Wish 3, Sirtis's character is a rape victim. In the film Blind Date, she appears as a prostitute who is murdered by a madman.\n\nOther early works include numerous guest starring roles on British television series. Sirtis appeared in Raffles (1977), Hazell (1978), Minder (1979), the Jim Davidson sitcom Up the Elephant and Round the Castle (1985) and The Return of Sherlock Holmes (1986) among other things. She also played the stewardess in the famous 1979 Cinzano Bianco television commercial starring Leonard Rossiter and Joan Collins, in which Collins was splattered with drink.	0	London - England - UK	Marina Sirtis
2797	1847-10-02	1934-08-02	Paul Ludwig Hans Anton von Beneckendorff und von Hindenburg, dit Paul von Hindenburg, né le 2 octobre 1847 à Posen (aujourd'hui en Pologne) et décédé le 2 août 1934 au manoir de Neudeck en Prusse-Occidentale1, fut un militaire, nommé maréchal, et homme d'État allemand qui, du fait de son prestige et de sa longévité, joua un rôle important dans l'Histoire allemande.  Après une longue carrière militaire au cours de laquelle il participe, notamment, à la bataille de Sadowa puis à la guerre franco-prussienne de 1870, Hindenburg occupe la scène militaire et politique allemande de 1914 à sa disparition. Lorsque commence la Première Guerre mondiale, il est sollicité par l'empereur Guillaume II. Vainqueur de la bataille de Tannenberg, Hindenburg est nommé chef du grand état-major de l'Armée impériale allemande deux ans plus tard, en 1916. Il assumera cette position jusqu'à la fin du conflit, dirigeant l'Allemagne avec le général Ludendorff, sous la forme d'une dictature militaire.  Auréolé de son prestige militaire que la défaite de l'Empire allemand n'a guère affecté, le maréchal Hindenburg est élu président du Reich à l'issue du scrutin présidentiel d'avril 1925 ; il succède au social-démocrate Friedrich Ebert, décédé dans l'exercice de ses fonctions. Aisément réélu pour un second septennat, le président Hindenburg ne peut cependant empêcher l'ascension politique d'Adolf Hitler, qu'il est contraint de nommer chancelier du Reich ; il s'éteint en 1934, laissant Hitler s'emparer de tous les pouvoirs.	0	Posen	Paul von Hindenburg
70	1890-01-16	1969-05-03	​From Wikipedia, the free encyclopedia.  \n\nKarl W. Freund, A.S.C. (January 16, 1890-May 3, 1969) was a cinematographer and film director. Born in Dvůr Králové (Königinhof), Bohemia, his career began in 1905 when, at age 15, he got a job as an assistant projectionist for a film company in Berlin where his family moved in 1901. He worked as a cinematographer on over 100 films, including the German Expressionist films The Golem (1920), The Last Laugh (1924) and Metropolis (1927). Freund emigrated to the United States in 1929 where he continued to shoot well remembered films such as Dracula (1931) and Key Largo (1948). He won an Academy Award for Best Cinematography for The Good Earth (1937). In 1937, he went to Germany to bring his only daughter, Gerda Maria Freund, back to the United States, saving her from almost certain death in the concentration camps. Karl's ex-wife, Susette Freund (née Liepmannssohn), remained in Germany where she was interned at the Ravensbrück concentration camp and eventually taken in March, 1942 to Bernburg Euthanasia Center where she was murdered. Between 1921 and 1935, Freund also directed ten films, of which the best known are probably The Mummy (1932) starring Boris Karloff, and his last film as director, Mad Love (1935) starring Peter Lorre. Freund's only known film as an actor is Carl Dreyer's Michael (1924) in which he has a cameo as a sycophantic art dealer who saves the tobacco ashes dropped by a famous painter. At the beginning of the 1950s, he was persuaded by Desi Arnaz at Desilu to be the cinematographer in 1951 for the televisions series I Love Lucy. Critics have credited Freund for the show's lustrous black and white cinematography, but more importantly, Freund designed the "flat lighting" system for shooting sitcoms that is still in use today. This system covers the set in light, thus eliminating shadows and allowing the use of three moving cameras without having to modify the lighting in-between shots. And where Freund did not invent the three camera shooting system, he did perfect it for use with film cameras in front of a live audience. Freund and his production team also worked on other sitcoms produced at/through Desilu such as "Our Miss Brooks".\n\nDescription above from the Wikipedia article Karl Freund, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Königinhof, Bohemia, Austria-Hungary [now Dvur Kralove, Czech Republic]	Karl Freund
2792	\N	\N		0		Carl Mayer
2793	\N	\N		0		Edmund Meisel
2794	\N	\N		0		Robert Baberske
2795	\N	\N		0		Reimar Kuntze
2796	\N	\N		0		László Schäffer
3361	1906-07-03	1972-04-25	From Wikipedia, the free encyclopedia. George Henry Sanders (3 July 1906 – 25 April 1972) was a Russian-born English film, and television actor, singer-songwriter, and music composer. He was widely known for his roles of cads and other darkly drawn characters in many successful films, most of all as Addison DeWitt in All About Eve (1950) and the villainous tiger Shere Khan in The Jungle Book (1967). His career spanned over 40 years.   Description above from the Wikipedia article George Sanders, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	St. Petersburg, Russian Empire [now Russia]	George Sanders
3362	1897-02-10	1992-01-03	Dame Judith Anderson was born Frances Margaret Anderson on February 10, 1897 in Adelaide, South Australia. She began her acting career in Australia before moving to New York in 1918. There she established herself as one of the greatest theatrical actresses and was a major star on Broadway throughout the 1930s, 1940s and 1950s. Her notable stage works included the role of Lady Macbeth, which she played first in the 1920s, and gave an Emmy Award-winning television performance in Macbeth (1960). Anderson's long association with Euripides's "Medea" began with her acclaimed Tony Award-winning 1948 stage performance in the title role. She appeared in the television version of Medea (1983) in the supporting character of the Nurse.\n\nAnderson made her Hollywood film debut under director Rowland Brown in a supporting role in Blood Money (1933). Her striking, not conventionally attractive features were complemented with her powerful presence, mastery of timing and an effortless style. Anderson made a film career as a supporting character actress in several significant films including Alfred Hitchcock's Rebecca (1940), for which she was Oscar nominated for Best Supporting Actress. She worked with director Otto Preminger in Laura (1944), then with René Clair in And Then There Were None (1945). Her remarkable performance in a supporting role in Cat on a Hot Tin Roof (1958) fit in a stellar acting ensemble under director Richard Brooks.\n\nAnderson was awarded Dame Commander of the Order of the British Empire in the 1960 Queen's New Year's Honours List for her services to the performing arts. Living in Santa Barbara in her later years, she also had a successful stint on the soap opera Santa Barbara (1984) and was nominated for a Daytime Emmy Award in 1984. In the same year, at age 87, she appeared in Star Trek III: The Search for Spock (1984) as the High Priestess, and was nominated for a Saturn Award for that role. She was awarded Companion of the Order of Australia in the 1991 Queen's Birthday Honours List for her services to the performing arts. Anderson died at age 94 of pneumonia on January 3, 1992 in Santa Barbara, California.	1	Adelaide, South Australia, Australia	Judith Anderson
3363	1895-02-04	1953-10-08	From Wikipedia, the free encyclopedia.  William Nigel Ernle Bruce (4 February 1895 – 8 October 1953), best known as Nigel Bruce, was a British character actor on stage and screen.  He was best known for his portrayal of Doctor Watson in a series of films and in the radio series The New Adventures of Sherlock Holmes (starring Basil Rathbone as Sherlock Holmes). Bruce is also remembered for his roles in the Alfred Hitchcock films Rebecca and Suspicion.\n\nDescription above from the Wikipedia article Nigel Bruce, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Ensenada, Baja California, Mexico	Nigel Bruce
3364	1891-11-20	1967-06-16	Reginald Denny (20 November 1891 – 16 June 1967) was an English stage, film and television actor as well as an aviator and UAV pioneer. He was once an amateur boxing champion of Great Britain.	0	Richmond, Surrey, England, UK	Reginald Denny
3366	1888-12-18	1971-11-17	From Wikipedia, the free encyclopedia.\n\nDame Gladys Constance Cooper, DBE (18 December 1888 – 17 November 1971) was an English actress whose career spanned seven decades on stage, in films and on television.\n\nBeginning on the stage as a teenager in Edwardian musical comedy and pantomime, she was starring in dramatic roles and silent films by World War I. She also became a manager of the Playhouse Theatre from 1917 to 1933, where she played many roles. Beginning in the early 1920s, Cooper was winning praise in plays by W. Somerset Maugham and others. In the 1930s, she was starring steadily both in the West End and on Broadway. Moving to Hollywood in 1940, Cooper found success in a variety of character roles; she was nominated for three Academy Awards, the last one as Mrs. Higgins in My Fair Lady (1964). Throughout the 1950s and 1960s, she mixed her stage and film careers, continuing to star on stage until her last year.\n\nDescription above from the Wikipedia article Gladys Cooper, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Chiswick, England, UK	Gladys Cooper
3367	1888-04-15	1954-01-31		0		Florence Bates
2642	1892-10-25	1972-10-16	​From Wikipedia, the free encyclopedia.  \n\nLeo Gratten Carroll (25 October 1892 – 16 October 1972) was an English-born actor. He was best known for his roles in several Hitchcock films and The Man from U.N.C.L.E. and Topper.\n\nDescription above from the Wikipedia article Leo Gratten Carroll   licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Weedon, Northamptonshire, England, U.K.	Leo G. Carroll
3368	1887-02-25	1977-09-11		0		Leonard Carey
3369	1874-10-17	1964-08-28	From Wikipedia\n\nLumsden Hare (17 October 1874 – 28 August 1964) was an Irish\n\nborn film and theatre actor. He was also a theatre director and theatrical\n\nproducer.\n\nBorn Francis Lumsden Hare in Tipperary, Ireland, he\n\nappeared in more than thirty-five Broadway-theatre productions in New York City\n\nbetween 1900 and 1942. He served as director and/or producer for various\n\nproductions, some starring himself.\n\nHe started appearing in films in 1916. By his last screen\n\nappearance in 1961, Hare had appeared in more than 140 films and over a dozen\n\ntelevision productions. He died, age 89, in Beverly Hills, California.	0		Lumsden Hare
3370	1875-03-19	1945-01-10		0		Edward Fielding
3371	1884-06-27	1945-12-14		0	County Cork, Ireland	Forrester Harvey
3372	\N	\N		0		Philip Winter
2636	1899-08-13	1980-04-29	From Wikipedia, the free encyclopedia.\n\nSir Alfred Joseph Hitchcock, KBE (13 August 1899 – 29 April 1980) was an Anglo-American director and producer. He pioneered many techniques in the suspense and psychological thriller genres. After a successful career in his native United Kingdom in both silent films and early talkies, Hitchcock moved to Hollywood. In 1956 he became an American citizen while remaining a British subject.\n\nOver a career spanning more than half a century, Hitchcock fashioned for himself a distinctive and recognizable directorial style. He pioneered the use of a camera made to move in a way that mimics a person's gaze, forcing viewers to engage in a form of voyeurism. He framed shots to maximize anxiety, fear, or empathy, and used innovative film editing. His stories frequently feature fugitives on the run from the law alongside "icy blonde" female characters. Many of Hitchcock's films have twist endings and thrilling plots featuring depictions of violence, murder, and crime, although many of the mysteries function as decoys or "MacGuffins" meant only to serve thematic elements in the film and the extremely complex psychological examinations of the characters. Hitchcock's films also borrow many themes from psychoanalysis and feature strong sexual undertones. Through his cameo appearances in his own films, interviews, film trailers, and the television program Alfred Hitchcock Presents, he became a cultural icon.\n\nHitchcock directed more than fifty feature films in a career spanning six decades. Often regarded as the greatest British filmmaker, he came first in a 2007 poll of film critics in Britain's Daily Telegraph, which said: "Unquestionably the greatest filmmaker to emerge from these islands, Hitchcock did more than any director to shape modern cinema, which would be utterly different without him. His flair was for narrative, cruelly withholding crucial information (from his characters and from us) and engaging the emotions of the audience like no one else." The magazine MovieMaker has described him as the most influential filmmaker of all-time, and he is widely regarded as one of cinema's most significant artists.\n\nDescription above from the Wikipedia article Alfred Hitchcock, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Leytonstone - London - England	Alfred Hitchcock
2438	1863-07-21	1948-12-20	From Wikipedia, the free encyclopedia.\n\nSir Charles Aubrey Smith KBE (21 July 1863 – 20 December 1948), known to movie-goers as C. Aubrey Smith, was an English cricketer and actor.\n\nDescription above from the Wikipedia article C. Aubrey Smith, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	London, England	C. Aubrey Smith
100763	1887-09-29	1957-11-26		0		Billy Bevan
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
3070	1948-07-24	\N	From Wikipedia, the free encyclopedia. Chris Haywood (born 24 July 1948) is an English-born, Australian-based film and televisionactor/producer.\n\nDescription above from the Wikipedia article Chris Haywood, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Billericay - Essex - England	Chris Haywood
3072	1970-04-16	\N		0		Daniel Lapaine
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
1423673	\N	\N		0		Alyette Samazeuilh
3779	1920-12-23	1984-09-10		0		Georges de Beauregard
3063	1960-11-05	\N	Katherine Mathilda "Tilda" Swinton (born 5 November 1960) is a British actress known for both arthouse and mainstream films. She won the Academy Award for Best Supporting Actress for her performance in Michael Clayton.\n\nDescription above from the Wikipedia article Tilda Swinton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	London, United Kingdom	Tilda Swinton
3064	1959-11-02	\N	From Wikipedia, the free encyclopedia.\n\nPeter Mullan (born 2 November 1959) is a Scottish actor and film-maker who has been appearing in films since 1990.\n\nDescription above from the Wikipedia article Peter Mullan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Peterhead, Scotland, UK	Peter Mullan
3609	1905-03-18	1958-06-09	From Wikipedia, the free encyclopedia.  Robert Donat (18 March 1905 – 9 June 1958) was an English film and stage actor.  He is best-known for his roles in Alfred Hitchcock's The 39 Steps and Goodbye, Mr. Chips for which he won an Academy Award for Best Actor.\n\nDescription above from the Wikipedia article Robert Donat, 1st Baron Tweedsmuir, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Withington, Manchester, England	Robert Donat
3610	1906-02-26	1987-10-02	From Wikipedia, the free encyclopedia.\n\nEdith Madeleine Carroll (26 February 1906 – 2 October 1987) was an English actress, popular in the 1930s and 1940s.\n\nDescription above from the Wikipedia article Madeleine Carroll, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	West Bromwich, West Midlands, England, UK	Madeleine Carroll
3611	1899-04-30	1976-07-18	From Wikipedia, the free encyclopedia.  Lucie Mannheim (30 April 1899 – 28 July 1976) was a German singer and actress.\n\nMannheim was born in Berlin–Köpenick where she studied drama and quickly became a popular figure appearing on stage in plays and musicals. Among other roles, she played Nora in Ibsen's A Doll's House, Marie in Büchner's Woyzeck, and Juliet in Shakespeare's Romeo and Juliet. She also began a film career in 1923, appearing in several silent and sound films including Atlantik (1929) – the first of many versions of the story of the ill-fated RMS Titanic. The composer Walter Goetze wrote his operetta Die göttliche Jette (1931) especially for Mannheim.  However, as a Jew she was obliged to stop acting in 1933, when her contract at the State Theatre was cancelled. She promptly left Germany, first to Czechoslovakia, then to Britain. She appeared in several films there, notably as the doomed spy Annabella Smith in Alfred Hitchcock's 1935 version of The 39 Steps.\n\nDuring World War II she appeared in several films, as well as broadcasting propaganda to Germany – including performing an anti-Hitler version of Lili Marleen  in 1943. In 1941, she married the actor Marius Goring.\n\nShe returned to Germany in 1948 and resumed her career as an actress on stage and in film. In 1955 she joined the cast of the British television series The Adventures of the Scarlet Pimpernel as Countess La Valliere. She made her final English-language film appearance in the 1965 film Bunny Lake Is Missing. Her last appearance was in a 1970 TV movie. She died in Braunlage.\n\nDescription above from the Wikipedia article Lucie Mannheim, 1st Baron Tweedsmuir, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Berlin, Germany	Lucie Mannheim
3612	1884-10-12	1953-06-08	From Wikipedia, the free encyclopedia. Sir Godfrey Tearle (October 12, 1884 - June 9, 1953) was an American-born actor who portrayed the quintessential Englishman on stage and in films in both England and the United States.\n\nDescription above from the Wikipedia article Godfrey Tearle, 1st Baron Tweedsmuir, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	New York City, New York	Godfrey Tearle
3672	1907-12-22	1991-06-14	​From Wikipedia, the free encyclopedia.\n\nDame Peggy Ashcroft, DBE  (22 December 1907 – 14 June 1991) was an English actress.ing released in the US by Lionsgate.\n\nDescription above from the Wikipedia article Mark Strange, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Croydon, Surrey, England	Peggy Ashcroft
3673	1897-03-25	1980-06-23	From Wikipedia, the free encyclopedia\n\nJohn Paton Laurie (25 March 1897 – 23 June 1980) was a Scottish actor born in Dumfries, Scotland. Although he is now probably most recognised for his role as Private James Frazer in the sitcom Dad's Army (1968-1977), he appeared in hundreds of feature films, including films by Alfred Hitchcock, Michael Powell and Lawrence Olivier. He was also a noted stage actor (particularly of Shakespearean roles) and speaker of verse, especially that of Robert Burns.\n\nDescription above from the Wikipedia article John Laurie, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dumfries, Dumfriesshire, Scotland, UK	John Laurie
3674	1874-08-28	1957-09-01		0		Helen Haye
3675	1884-02-23	1948-09-27	Frank Cellier (23 February 1884 – 27 September 1948) was an English actor. Early in his career, he toured in Britain, Germany, the West Indies, America and South Africa. In the 1920s, he became known in the West End for Shakespearean character roles, among others, and also directed some plays in which he acted. Later, during the 1930s and 1940s, he also appeared in films.\n\nBeginning in the 1930s, Cellier played roles in films, including Sheriff Watson in Alfred Hitchcock's The 39 Steps (1935). He was also Monsieur Barsac in the comedy film The Guv'nor (1935).\n\nCellier died in London in 1948 aged 64.	2	Surbiton, Surrey, England, UK	Frank Cellier
3676	1889-02-06	1966-05-03		0		Wylie Watson
553488	\N	\N		0		Gus McNaughton
27946	1895-07-26	1975-06-29		0		Jerry Verno
3677	1913-07-04	\N		0		Peggy Simpson
1530685	\N	\N		0		Pat Hagate
3678	1913-07-10	2007-08-25		0		Elizabeth Inglis
3679	1902-09-23	1979-09-22		0		Frederick Piper
3680	\N	\N		0		Hilda Trevelyan
3601	1896-05-19	1977-10-17	Sir Michael Elias Balcon (19 May 1896 – 17 October 1977) was an English film producer, known for his work with Ealing Studios. Balcon had earlier worked for Gainsborough Pictures, Gaumont British and MGM-British.	2	Birmingham, England, UK	Michael Balcon
3604	\N	\N		0		Jack Beaver
3606	1900-02-20	1975-02-12	From Wikipedia, the free encyclopedia\n\nBernard Knowles (20 February 1900 - 12 February 1975) was an English film director, producer, cinematographer and screenwriter. Born in Manchester, Knowles worked with Alfred Hitchcock on numerous occasions before the director emigrated to Hollywood. He later graduated as a director and screenwriter and worked much on TV, including Fabian of the Yard, Dial 999, Ivanhoe and The Adventures of Robin Hood. He died shortly before his 75th birthday in Taplow, Buckinghamshire in 1975.\n\nDescription above from the Wikipedia article Bernard Knowles, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Manchester, Lancashire, England, UK	Bernard Knowles
3607	1905-05-26	1979-08-15		0		Derek N. Twist
3608	\N	\N		0		A. Birch
3613	1894-11-20	1957-08-18		0	London, England, UK	Louis Levy
4692	1935-10-27	\N	Frank Adonis (born October 27, 1935), sometimes credited as Frank Martin, is an American film and television actor.\n\nHe was born Frank Testaverde Scioscia in Brooklyn, New York.\n\n Adonis is a long-time character actor frequently cast in gangster roles.	2	Brooklyn, New York,  USA	Frank Adonis
3778	1912-12-11	2007-01-09		0		Carlo Ponti
1393333	\N	\N		0		Clifford Buckton
1653023	1875-08-26	1940-02-11	From Wikipedia\n\nJohn Buchan, 1st Baron Tweedsmuir, GCMG, GCVO, CH, PC (/ˈbʌxən/; 26 August 1875 – 11 February 1940) was a Scottish novelist, historian and Unionist politician who served as Governor General of Canada, the 15th since Canadian Confederation.\n\nAfter a brief legal career, Buchan simultaneously began his writing career and his political and diplomatic careers, serving as a private secretary to the colonial administrator of various colonies in southern Africa. He eventually wrote propaganda for the British war effort in the First World War. Buchan was in 1927 elected Member of Parliament for the Combined Scottish Universities, but he spent most of his time on his writing career, notably writing The Thirty-Nine Steps and other adventure fiction. In 1935 he was appointed Governor General of Canada by King George V, on the recommendation of Prime Minister of Canada R. B. Bennett, to replace the Earl of Bessborough. He occupied the post until his death in 1940. Buchan proved to be enthusiastic about literacy, as well as the evolution of Canadian culture, and he received a state funeral in Canada before his ashes were returned to the United Kingdom.	2	Perth, Perthshire, Scotland, UK	John Buchan
3681	1899-08-14	1982-07-06		0		Alma Reville
27918	\N	\N		0		Ian Hay
3599	1899-08-02	1995-06-15	Born just before the century turned, Charles Bennett made his writing debut as a child in 1911, fought in France during World War I while still a teen and resumed his acting career after the war's end. In 1926 he dropped acting to concentrate on being a playwright, later turning one of his most famous plays, "Blackmail," into a screenplay for production under the direction of Alfred Hitchcock. The affiliation with "Hitch" continued into the early 1940s, by which time both Bennett and the director were working in Hollywood. He wrote for producers ranging from Cecil B. DeMille to Irwin Allen to the penny-pinching folks at AIP. "If I couldn't write, I wouldn't want to live," commented Bennett, who had projects (including a remake of "Blackmail") going right up to the time of his death.	0	Shoreham-by-Sea, England	Charles Bennett
3635	1932-02-27	2011-03-23	Dame Elizabeth Rosemond "Liz" Taylor, DBE (February 27, 1932 – March 23, 2011) was a British-American actress. From her early years as a child star with MGM, she became one of the great screen actresses of Hollywood's Golden Age. As one of the world's most famous film stars, Taylor was recognized for her acting ability and for her glamorous lifestyle, beauty and distinctive violet eyes.\n\nNational Velvet (1944) was Taylor's first success, and she starred in Father of the Bride (1950), A Place in the Sun (1951), Giant (1956), Cat on a Hot Tin Roof (1958), and Suddenly, Last Summer (1959). She won the Academy Award for Best Actress for BUtterfield 8 (1960), played the title role in Cleopatra (1963), and married her co-star Richard Burton. They appeared together in 11 films, including Who's Afraid of Virginia Woolf? (1966), for which Taylor won a second Academy Award. From the mid-1970s, she appeared less frequently in film, and made occasional appearances in television and theatre.\n\nHer much publicized personal life included eight marriages and several life-threatening illnesses. From the mid-1980s, Taylor championed HIV and AIDS programs; she co-founded the American Foundation for AIDS Research in 1985, and the Elizabeth Taylor AIDS Foundation in 1993. She received the Presidential Citizens Medal, the Legion of Honour, the Jean Hersholt Humanitarian Award and a Life Achievement Award from the American Film Institute, who named her seventh on their list of the "Greatest American Screen Legends". Taylor died of congestive heart failure at the age of 79.	0	Hampstead Garden Suburb - London - England	Elizabeth Taylor
3151	1925-02-08	2001-06-27	From Wikipedia, the free encyclopedia\n\nJohn Uhler "Jack" Lemmon III (February 8, 1925 – June 27, 2001) was an American actor and musician. He starred in more than 60 films including Some Like It Hot, The Apartment, Mister Roberts (for which he won the 1955 Best Supporting Actor Academy Award), Days of Wine and Roses, The Great Race, Irma la Douce, The Odd Couple, Save the Tiger (for which he won the 1973 Best Actor Academy Award), The Out-of-Towners, The China Syndrome, Missing (for which he won 'Best Actor' at the 1982 Cannes Film Festival), Glengarry Glen Ross, Grumpy Old Men and Grumpier Old Men.\n\n \n\nDescription above from the Wikipedia article Jack Lemmon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Newton, Massachusetts, USA	Jack Lemmon
4090	1934-04-24	\N	From Wikipedia, the free encyclopedia\n\nShirley MacLaine (born April 24, 1934) is an American film and theater actress, dancer, activist, and author, well-known for her beliefs in new age spirituality and reincarnation. She has written a large number of autobiographical works, many dealing with her spiritual beliefs as well as her Hollywood career. In 1983, she won the Academy Award for Best Actress for her role in Terms of Endearment. She is the elder sister of actor Warren Beatty. She was nominated for an Academy Award 5 times before her win.   Description above from the Wikipedia article Shirley MacLain, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Richmond, Virginia, USA	Shirley MacLaine
4091	1908-08-30	1991-01-05	Born to Maleta Martin and Frederick MacMurray (concert violinist). Fred sang and played in orchestras to earn tuition. He was educated at Carroll College, Wis. Fred played with a Chicago orchestra for more than a year. Then he joined an orchestra in Hollywood where he played, did some recording and played extra roles. He then joined a comedy stage band, California Collegians, and went to New York. There he joined "Three's A Crowd" revue on Broadway and on the road. After this show closed, he returned to California and worked in vaudeville. He played the vaudeville circuits and night clubs until cast for major role in "Roberta". Signed by Paramount in 1935.\n\nMacMurray was raised in Beaver Dam, Wisconsin from the age of 5, eventually graduating from Beaver Dam High School (currently the site of Beaver Dam Middle School), where he was a 3-sport star in football, baseball, and basketball. Fred retained a special place in his heart for his small-town Wisconsin upbringing, referring at any opportunity in magazine articles or interviews to the lifelong friends and cherished memories of Beaver Dam, even including mementos of his childhood in several of his films. In "Pardon my Past" (1945), Fred and fellow GI William Demarest are moving to Beaver Dam, WI to start a mink farm.	0	Kankakee, Illinois, USA	Fred MacMurray
4093	1914-12-02	2001-01-01	From Wikipedia, the free encyclopedia\n\nRay Walston (December 2, 1914 – January 1, 2001) was an American stage, television and film actor best known as the title character on the 1960s situation comedy My Favorite Martian. In addition, he was also known for his role as high school teacher Mr. Hand in the 1982 film Fast Times at Ridgemont High and Judge Henry Bone on the drama series Picket Fences.\n\n \n\nDescription above from the Wikipedia article Ray Walston, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New Orleans, Louisiana, USA	Ray Walston
4094	1922-03-20	2002-04-02	​From Wikipedia, the free encyclopedia\n\nJack Kruschen (March 20, 1922 – April 2, 2002) was a Canadian-born character actor who worked primarily in American film, television and radio.\n\nDescription above from the Wikipedia article Jack Kruschen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Winnipeg, Manitoba, Canada	Jack Kruschen
4096	1926-11-29	\N		0		Naomi Stevens
4097	1938-11-30	\N		0		Hope Holiday
4098	1927-04-16	2008-10-15	From Wikipedia, the free encyclopedia.\n\nEdie Adams (April 16, 1927 – October 15, 2008) was an American singer, Broadway, television and film actress and comedienne. Adams, a Tony Award winner, "both embodied and winked at the stereotypes of fetching chanteuse and sexpot blonde." She was well-known for her impersonations of female stars on stage and television, most particularly, Marilyn Monroe.\n\nDescription above from the Wikipedia article Edie Adams, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Kingston, Pennsylvania, USA	Edie Adams
3161	1926-03-05	1987-03-22		0		Joan Shawlee
4099	1926-02-23	2010-01-22		0		Johnny Seven
571911	1916-10-19	2000-12-11		0	Pittsburgh, Pennsylvania, USA	David Lewis
40381	1932-09-26	1987-06-16	From Wikipedia, the free encyclopedia\n\nJoyce Jameson (September 26, 1932 - January 16, 1987) was an American actress best remembered for her blonde bimbo roles during the Marilyn Monroe period. She was known for many television roles including recurring guest appearances as “Skippy” one of the "fun girls" in the 1960s television series The Andy Griffith Show and also for film portrayals such as "The Blonde" in the 1960 Academy Award winner The Apartment.\n\nDescription above from the Wikipedia article Joyce Jameson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chicago, Illinois, USA	Joyce Jameson
87517	1914-08-29	1995-02-02	Character actor in US radio, films, and TV. Memorable as the star of radio's "The Great Gildersleeve" from 1950 to 1955 (replacing the actor Harold Peary, who had originated the radio role of Throckmorton P. Gildersleeve in 1941). As well, Waterman starred in the 1955 TV version.\n\nDate of Death: 2 February 1995, Burlingame, California  (bone marrow disease). Interred at Skylawn Memorial Park, San Mateo, California.	0	Madison, WI	Willard Waterman
141694	1916-04-04	1990-11-27	From Wikipedia, the free encyclopedia.\n\nDavid White (April 4, 1916 – November 27, 1990) was an American stage, film and television actor best known for playing Darrin's boss Larry Tate in the 1964-72 sitcom Bewitched.\n\nDescription above from the Wikipedia article David White (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Denver, Colorado, USA	David White
1234545	1920-12-16	1968-12-15	Perennial starlet Dorothy Abbott was a sexy, vivacious, wide-smiling  model, showgirl and actress who could brighten up a room. Unfortunately,  her cinematic offerings wound up being pretty minimal and her last  years were marred by depression and, ultimately, a tragic end.\n\nShe was born Dorothy E. Abbott on December 16, 1920, in Kansas City, Missouri and started her career off as a chorine with Earl Carroll  and his Los Angeles-based revues and in Las Vegas showrooms where she  was dubbed the rather mystifying title of "The Girl with the Golden  Arm". Paramount Studios perked up on the lovely blonde with the Betty  Page-like bangs and gave her a starting contract at $150 a week. Groomed  in dozens of decorative "good time girl" bits -- dancers, chorus girls,  waitresses, stewardesses, party girls, nurses and models -- she was at  the same time promoted as a cheesecake pinup, "winning" such dubious  titles as "Miss Wilshire Club," "Miss Los Angeles Transit" and "Miss Oil  Cans". The dusky-voiced Dorothy was usually briefly seen and not heard in such dramatic and lightweight fare as The Razor's Edge (1946), Road to Rio (1947), Night Has a Thousand Eyes (1948) (in which she has her first speaking role as a maid), Words and Music (1948), Take Me Out to the Ball Game (1949), Little Women (1949), Neptune's Daughter (1949), Annie Get Your Gun (1950), His Kind of Woman (1951), Aaron Slick from Punkin Crick (1952), _The Las Vegas Story (1952)_, The Caddy (1953), There's No Business Like Show Business (1954), Love Me or Leave Me (1955), Rebel Without a Cause (1955), Gunfight at the O.K. Corral (1957), Jailhouse Rock (1957), South Pacific (1958), The Apartment (1960), That Touch of Mink (1962), A Gathering of Eagles (1963) and Dear Heart (1964). Her one starring role came early in the exploitative, lowbudget potboiler A Virgin in Hollywood (1953) as a star reporter out to get a seamy Hollywood story, but she was unable to capitalize on it. Working  bit parts at the studio during the days, she would often perform on  stage in little theatre shows at night. On the sly, when work was  meager, she became a real estate agent in the 1950s in order to help  supplement her income. TV chores included guest roles in "Leave It to  Beaver" and "Ozzie and Harriet". She also had a recurring part for one  season as Jack Webb 's girlfriend on the Dragnet (1954) series.\n\nDorothy  married LAPD narcotics squad officer-turned homicide detective Adolph  Rudy Diaz in 1949. Diaz, who was of Native American (Apache) descent,  eventually retired as a cop in order to pursue acting. By this time, the  marriage was in trouble and the couple separated. Going by the stage  name of Rudy Diaz in 1967, he began to get work and was seen out in public with other  women. The divorce was finalized in 1968, but Dorothy took it hard and  never seemed to get over it. On December 15, 1968, she committed suicide  at her Los Angeles home -- one day before her 48th birthday. She was  interred (as Dorothy E. Diaz) at Rose Hills Memorial Park, Whittier, Los  Angeles County, California, Plot: Valley Lawn, Lot 2939.	0	Kansas City, Missouri	Dorothy Abbott
1551605	\N	\N		0		Ralph Moratz
1250242	\N	\N		0		Joe Palma
16527	1913-11-26	1982-11-17		0		Bill Baldwin
120555	\N	\N		0		Benny Burt
98166	1927-02-27	2004-01-02		1		Lynn Cartwright
1225439	\N	\N		0		Mason Curry
153413	\N	\N		0		David Macklin
25627	1916-08-24	1994-01-28	​From Wikipedia, the free encyclopedia.  \n\nHarold John "Hal" Smith (August 24, 1916 – January 28, 1994) was an American character actor and voice actor. Smith is best known as Otis Campbell, the town drunk on The Andy Griffith Show, and was the voice of many characters on various animated cartoon shorts. He is also known to radio listeners as John Avery Whittaker on Adventures in Odyssey.\n\nSmith is often wrongly given credit for the writing of the movie It Came from Beneath the Sea, as well as ten other produced feature films. The true co-writer of those movies is Harold Jacob Smith, who wrote as "Hal Smith" until 1958.\n\nDescription above from the Wikipedia article Hal Smith (actor),  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Petoskey, Michigan, U.S.	Hal Smith
3146	1906-06-22	2002-03-27	From Wikipedia, the free encyclopedia.  Billy Wilder (22 June 1906 – 27 March 2002) was an Austria/Hungarian-born American filmmaker, screenwriter, producer, artist, and journalist, whose career spanned more than 50 years and 60 films. He is regarded as one of the most brilliant and versatile filmmakers of Hollywood's golden age. Wilder is one of only five people who have won Academy Awards as producer, director, and writer for the same film (The Apartment).\n\nWilder became a screenwriter in the late 1920s while living in Berlin. After the rise of Adolf Hitler, Wilder, who was Jewish, left for Paris, where he made his directorial debut. He relocated to Hollywood in 1933, and in 1939 he had a hit as a co-writer of the screenplay to the screwball comedy Ninotchka. Wilder established his directorial reputation after helming Double Indemnity (1944), a film noir he co-wrote with mystery novelist Raymond Chandler. Wilder earned the Best Director and Best Screenplay Academy Awards for the adaptation of a Charles R. Jackson story The Lost Weekend, about alcoholism. In 1950, Wilder co-wrote and directed the critically acclaimed Sunset Boulevard.\n\nFrom the mid-1950s on, Wilder made mostly comedies. Among the classics Wilder created in this period are the farces The Seven Year Itch (1955) and Some Like It Hot (1959), satires such as The Apartment (1960), and the romantic comedy Sabrina (1954). He directed fourteen different actors in Oscar-nominated performances. Wilder was recognized with the AFI Life Achievement Award in 1986. In 1988, Wilder was awarded the Irving G. Thalberg Memorial Award. In 1993, he was awarded the National Medal of Arts. Wilder holds a significant place in the history of Hollywood censorship for expanding the range of acceptable subject matter.\n\nDescription above from the Wikipedia article Billy Wilder, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Sucha, Galicia, Austria-Hungary	Billy Wilder
4100	1897-10-20	1980-01-01		2		Adolph Deutsch
4101	1900-07-09	1989-08-20	From Wikipedia, the free encyclopedia\n\nJoseph LaShelle, A.S.C. (July 9, 1900 - August 20, 1989) was a Los Angeles born film cinematographer.\n\nHe won an Academy Award for Laura (1944), and was nominated on eight additional occasions.\n\nLaShelle's first job in the film industry was as an assistant in the Paramount West Coast Studio lab in 1920. Instead of going to college as planned he remained in the film industry after a promotion to supervisor of the printing department.\n\nIn 1925 Charles G. Clarke convinced him he should be a cameraman. He went to work with Clarke and after 3 months he was promoted to 2nd cameraman and he worked for various cinematographers at the Hollywood Metropolitan Studios. LaShalle was transferred from Metropolitan to Pathé where he began a 14 years association with Arthur C. Miller. He later went with Miller to Fox Films.\n\nAfter working as a camera operator on such Fox productions as How Green Was My Valley (1941) and The Song of Bernadette (1943) he was promoted and became a cinematographer in 1943. He was a member of the A.S.C.\n\nSome of his well known work include the film noirs: Laura (1944), for which he won an Oscar, Fallen Angel (1945), and Road House (1948). He is remembered for his work with Otto Preminger.	2	Los Angeles, California, USA	Joseph LaShelle
4102	1895-07-13	1987-06-08		0		Daniel Mandell
4103	\N	\N		0		Alexandre Trauner
4104	1899-01-30	1977-02-17		0	Cobden, Ontario, Canada	Edward G. Boyle
4105	\N	\N		0		Harry Ray
4106	\N	\N		0		Allen K. Wood
4107	\N	\N		0		Milt Rice
4108	\N	\N		0		Don Stott
4420	1905-11-01	1990-04-02	From Wikipedia, the free encyclopedia.\n\nAldo Fabrizi (November 1, 1905, Rome, Italy – April 2, 1990, Rome, Italy) was an Italian actor and cinema and theatre director.\n\nDescription above from the Wikipedia article Aldo Fabrizi, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Rome, Italy	Aldo Fabrizi
73980	1927-03-17	2006-07-28		0		Patrick Allen
4422	1907-01-15	1980-10-18	From Wikipedia, the free encyclopedia.\n\nMarcello Pagliero (15 January 1907 – 18 October 1980) was an Italian film director, actor, and screenwriter.\n\nPagliero was born in London and died in Paris. He is perhaps best known for his performance in the Roberto Rossellini film Rome, Open City (1945).\n\nHe moved to France in 1947, and continued to work in film until 1960 and in French television after that.\n\nIn 1949, he was nominated for an Academy Award for Writing Original Screenplay an as a co-writer for the Rossellini film Paisà.\n\nDescription above from the Wikipedia article Marcello Pagliero, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	 London, England, UK	Marcello Pagliero
4424	\N	\N		0		Harry Feist
4426	\N	\N		0		Maria Michi
4423	\N	\N		0		Vito Annichiarico
5001	\N	\N		0		Ákos Tolnay
5002	\N	\N		0		Joop van Hulzen
5003	\N	\N		0		Carla Rovere
18337	\N	\N		0		Giovanna Galletti
132194	1895-10-06	1963-04-11	Nando Bruno was born on October 6, 1895, died April 11, 1963 (age 67) in Rome, Lazio, Italy. He was an actor and writer,	0	Rome - Lazio - Italy	Nando Bruno
374218	\N	\N		0		Eduardo Passarelli
32669	\N	\N		0		Carlo Sindici
132479	\N	\N		0		Turi Pandolfini
1459391	\N	\N		0		Amalia Pellegrini
543796	\N	\N		0		Alberto Tavazzi
4410	1906-05-08	1977-06-03	Roberto Rossellini (8 May 1906 – 3 June 1977) was an Italian film director and screenwriter. Rossellini was one of the directors of the Italian neorealist cinema, contributing films such as Roma città aperta (Rome, Open City 1945) to the movement.\n\nDescription above from the Wikipedia article Roberto Rossellini, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Rome, Italy	Roberto Rossellini
4411	\N	\N		0		Giuseppe Amato
4412	\N	\N		0		Ferruccio De Martino
4416	1908-02-02	1982-05-13		2	Rome - Lazio - Italy	Renzo Rossellini
4417	\N	\N		0		Ubaldo Arata
4418	\N	\N		0		Eraldo Da Roma
4419	\N	\N		0		Rosario Megna
4428	\N	\N		0		Raffaele Del Monte
22472	\N	\N		0		Jolanda Benvenuti
4414	\N	\N		0		Alberto Consiglio
4413	1904-10-30	1981-04-14	From Wikipedia, the free encyclopedia.\n\nSergio Amidei (30 October 1904 – 14 April 1981) was an Italian screenwriter and an important figure in Italy's neorealist movement.\n\nAmidei was born in Trieste. He worked with famed Italian directors such as Roberto Rossellini and Vittorio De Sica. He was nominated for four Academy Awards: in 1946 for Rome, Open City, in 1947 for Shoeshine, in 1949 for Paisà and in 1961 for Il generale della Rovere.\n\nHe died in Rome.\n\nDescription above from the Wikipedia article Sergio Amidei, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Trieste, Italy	Sergio Amidei
4415	1920-01-20	1993-10-31	From Wikipedia, the free encyclopedia.\n\nFederico Fellini, Knight Grand Cross (January 20, 1920 – October 31, 1993), was an Italian film director and screenwriter. Known for a distinct style that blends fantasy and baroque images, he is considered one of the most influential and widely revered filmmakers of the 20th century.\n\nDescription above from the Wikipedia article Federico Fellini, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Rimini, Emilia-Romagna, Italy	Federico Fellini
54928	\N	\N		0		Rod E. Geiger
2224	1969-08-18	\N	Christian Michael Leonard Slater (born August 18, 1969) is an American actor. He made his film debut with a small role in The Postman Always Rings Twice before playing a leading role in the 1985 film The Legend of Billie Jean. He then played a monk's apprentice alongside Sean Connery in The Name of the Rose before gaining recognition for his breakthrough role in the cult film Heathers. In the 1990s Slater featured in many big budget films including Robin Hood: Prince of Thieves, True Romance, Interview with the Vampire: The Vampire Chronicles, Broken Arrow and Hard Rain. He was also featured in the cult film True Romance. Since 2000 Slater has combined work in the film business with television, including appearances in The West Wing and Alias. Slater was married to Ryan Haddon between 2000 and 2005; they had two children together. Slater has had widely publicized brushes with the law, including being sentenced to three months in jail for assault in 1997. Description above from the Wikipedia article Christian Slater, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York, New York City, USA	Christian Slater
4687	1968-04-08	\N	Patricia T. Arquette (born April 8, 1968) is an American actress and director. She played the lead character in the supernatural drama series Medium for which she won the Primetime Emmy Award for Outstanding Lead Actress in a Drama Series.\n\nDescription above from the Wikipedia article Patricia Arquette, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Chicago - Illinois - USA	Patricia Arquette
4688	1970-03-20	\N	American actor and a comedian Michael David Rapaport has acted in more than forty films since the early 1990s. For his television credits he's best known for his roles on the television series Boston Public, Prison Break, Friends, and The War at Home. \n\nRapaport has appeared in both dramatic and comedic roles on film and television. His movie performances include “Metro”, “Deep Blue Sea”, and “Higher Learning”. Rapaport also had recurring roles on several television shows including: Friends, “The War at Home”, “My Name is Earl” and “Prison Break”.\n\nRapaport is married to Nichole Beattie and they have two children, sons Julian Ali and Maceo Shane.	2	New York City, New York, USA	Michael Rapaport
4689	1959-05-20	\N	Bronson Alcott Pinchot (born May 20, 1959) is an American actor. He has appeared in several feature films, including Risky Business, Beverly Hills Cop (and reprising his popular supporting role in Beverly Hills Cop III), The First Wives Club, True Romance, Courage Under Fire and It's My Party. Pinchot is probably best known for his role in the ABC family sitcom Perfect Strangers as Balki Bartokomous from the (fictional) Greek-like island of Mypos.\n\nDescription above from the Wikipedia article Bronson Pinchot, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	New York City - New York - USA	Bronson Pinchot
4693	\N	\N	Paul Bates is an American actor. He has played minor roles in True Romance, The Preacher's Wife, Mr. Wonderful, 8 Mile, The Wayans Bros, Walk Hard: The Dewey Cox Story and Bad Teacher. He is known for playing Oha in the 1988 film Coming to America starring Eddie Murphy.	2		Paul Bates
11155	1969-02-22	\N	Thomas Jane (born Thomas Elliott III; February 22, 1969) is an American actor, known for his roles in the 1999 film Deep Blue Sea, the 2001 TV movie 61*, the 2004 film The Punisher and the 2007 Stephen King adaptation The Mist. He currently stars in the HBO comedy-drama series Hung.\n\nDescription above from the Wikipedia article Thomas Jane, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Baltimore, Maryland, USA	Thomas Jane
933880	\N	\N		0		George Leigh
1550460	\N	\N		0		Walter Bacon
569321	\N	\N		0		Lovyss Bradley
1551021	\N	\N		0		Nora Bush
64	1958-03-21	\N	Gary Leonard Oldman (born 21 March 1958) is an English actor, filmmaker and musician, well-known to audiences for his portrayals of dark and morally ambiguous characters. He has starred in films such as Sid and Nancy, Prick Up Your Ears, JFK, Dracula, True Romance, Léon, The Fifth Element, The Contender, the Harry Potter film series and the Batman film series, as well as in television shows such as Friends and Fallen Angels.\n\nOldman came to prominence in the mid-1980s with a string of performances that prompted pre-eminent film critic, Roger Ebert, to describe him as "the best young British actor around". He has been cited as an influence by a number of successful actors. In addition to leading and central supporting roles in big-budget Hollywood films, Oldman has frequently acted in independent films and television shows. Aside from acting, he directed, wrote and co-produced Nil by Mouth, a film partially based on his own childhood, and served as a producer on several films.\n\nAmong other accolades, Oldman has received Emmy-, Screen Actors Guild-, BAFTA- and Independent Spirit Award nominations for his acting work, and has been described as one of the greatest actors never nominated for an Academy Award. His contributions to the science fiction genre have won him a Saturn Award, with a further two nominations. He was also nominated for the 1997 Palme d'Or and won two BAFTA Awards for his filmmaking on Nil By Mouth. In 2011, Empire readers voted Oldman an "Icon of Film", in recognition of his contributions to cinema.\n\nDescription above from the Wikipedia article Gary Oldman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Gary Oldman
4690	1943-03-31	\N	Christopher Walken (born Ronald Walken, usually called "Chris") is an American stage and screen actor.\n\nHe has appeared in more than 100 movies and television shows. Walken was born Ronald Walken (named after actor Ronald Colman) into a Methodist family in Astoria, Queens, New York. His mother, Rosalie, was a Scottish immigrant from Glasgow, and his father, Paul Walken, emigrated from Germany in 1928 with his brothers, Wilhelm and Alois. His father was a baker and his mother worked as a window dresser. Influenced by their mother's own dreams of stardom, he and his brothers Kenneth and Glenn were child actors on television in the 1950s. Walken studied at Hofstra University on Long Island, but did not graduate. Walken initially trained as a dancer in music theatre at the Washington Dance Studio before moving on to dramatic roles in theatre and then film. Walken is imitated for his deadpan affect, sudden off-beat pauses, and strange speech rhythm, in a manner similar to William Shatner. He is revered for his quality of danger and menace, but his unpredictable deliveries and expressions make him invaluable in comedy as well. Walken is noted for refusing movie roles only rarely, having stated in interviews that he will decline a role only if he is simply too busy on other projects to take it. He regards each role as a learning experience. Walken has been married to Georgianne Walken (born Thon) since 1969; she is a casting director, most notably for The Sopranos. They live in Connecticut and have no children (Walken has stated in interviews that not having children is one of the reasons he has had such a prolific career). In regard to his villainous roles preceding him when meeting new people, Walken says, "When they see me in a movie, they expect me to be something nasty ... That's why it's good to defy expectations sometimes."	2	Queens, New York USA	Christopher Walken
287	1963-12-18	\N	William Bradley "Brad" Pitt (born December 18, 1963) is an American actor and film producer. Pitt has received two Academy Award nominations and four Golden Globe Award nominations, winning one. He has been described as one of the world's most attractive men, a label for which he has received substantial media attention. Pitt began his acting career with television guest appearances, including a role on the CBS prime-time soap opera Dallas in 1987. He later gained recognition as the cowboy hitchhiker who seduces Geena Davis's character in the 1991 road movie Thelma &amp; Louise. Pitt's first leading roles in big-budget productions came with A River Runs Through It (1992) and Interview with the Vampire (1994). He was cast opposite Anthony Hopkins in the 1994 drama Legends of the Fall, which earned him his first Golden Globe nomination. In 1995 he gave critically acclaimed performances in the crime thriller Seven and the science fiction film 12 Monkeys, the latter securing him a Golden Globe Award for Best Supporting Actor and an Academy Award nomination.\n\nFour years later, in 1999, Pitt starred in the cult hit Fight Club. He then starred in the major international hit as Rusty Ryan in Ocean's Eleven (2001) and its sequels, Ocean's Twelve (2004) and Ocean's Thirteen (2007). His greatest commercial successes have been Troy (2004) and Mr. &amp; Mrs. Smith (2005).\n\nPitt received his second Academy Award nomination for his title role performance in the 2008 film The Curious Case of Benjamin Button. Following a high-profile relationship with actress Gwyneth Paltrow, Pitt was married to actress Jennifer Aniston for five years. Pitt lives with actress Angelina Jolie in a relationship that has generated wide publicity. He and Jolie have six children—Maddox, Pax, Zahara, Shiloh, Knox, and Vivienne.\n\nSince beginning his relationship with Jolie, he has become increasingly involved in social issues both in the United States and internationally. Pitt owns a production company named Plan B Entertainment, whose productions include the 2007 Academy Award winning Best Picture, The Departed.	2	Shawnee - Oklahoma - USA	Brad Pitt
3197	1961-11-29	\N	Tom Sizemore (born November 29, 1961) is an American film and television actor and producer. He is known for his roles in films such as Saving Private Ryan, Pearl Harbor, Heat and Black Hawk Down and supporting roles in well known films such as The Relic, True Romance, Natural Born Killers, Wyatt Earp and Devil in a Blue Dress.	2	Detroit, Michigan, USA	Tom Sizemore
2231	1948-12-21	\N	Samuel Leroy Jackson (born December 21, 1948) is an American film and television actor and film producer. After Jackson became involved with the Civil Rights Movement, he moved on to acting in theater at Morehouse College, and then films. He had several small roles such as in the film Goodfellas, Def by Temptation, before meeting his mentor, Morgan Freeman, and the director Spike Lee. After gaining critical acclaim for his role in Jungle Fever in 1991, he appeared in films such as Patriot Games, Amos &amp; Andrew, True Romance and Jurassic Park. In 1994 he was cast as Jules Winnfield in Pulp Fiction, and his performance received several award nominations and critical acclaim.\n\nJackson has since appeared in over 100 films including Die Hard with a Vengeance, The 51st State, Jackie Brown, Unbreakable, The Incredibles, Black Snake Moan, Shaft, Snakes on a Plane, as well as the Star Wars prequel trilogy and small roles in Quentin Tarantino's Kill Bill Vol. 2 and Inglourious Basterds. He played Nick Fury in Iron Man and Iron Man 2, Thor, the first two of a nine-film commitment as the character for the Marvel Cinematic Universe franchise. Jackson's many roles have made him one of the highest grossing actors at the box office. Jackson has won multiple awards throughout his career and has been portrayed in various forms of media including films, television series, and songs. In 1980, Jackson married LaTanya Richardson, with whom he has one daughter, Zoe.\n\nDescription above from the Wikipedia article Samuel L. Jackson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Washington - D.C. - USA	Samuel L. Jackson
3712	1948-07-02	\N	From Wikipedia, the free encyclopedia.\n\nSaul Rubinek (born July 2, 1948, height 5' 7" (1,70 m)) is a Canadian film and television actor. He has also directed and produced feature-length films.\n\nEarly life\n\nRubinek was born in Föhrenwald, Wolfratshausen, Germany, the son of Polish Jews Frania and Israel Rubinek, who was a factory worker, theatre company manager, Yiddish Theatre actor, and Talmudic scholar. Rubinek's parents were hidden by Polish farmers for over two years during World War II and moved to Canada in 1948.	2	Föhrenwald, Wolfratshausen, Germany	Saul Rubinek
4691	1961-09-18	2013-06-19	James J. Gandolfini, Jr. (September 18, 1961 - June 19, 2013) was an American actor. He is best known for his role as Tony Soprano in the HBO TV series The Sopranos, about a troubled crime boss struggling to balance his family life and career in the Mafia. For this role, Gandolfini garnered enormous praise, winning the Primetime Emmy Award for Outstanding Lead Actor in a Drama Series three times, along with the Screen Actors Guild Award for Outstanding Performance by a Male Actor in a Drama Series three times. Gandolfini's other roles include the woman-beating mob henchman Virgil in True Romance, enforcer/stuntman Bear in Get Shorty, Lt. General Miller in In the Loop, and the impulsive Wild Thing Carol in Where the Wild Things Are. In 2007, Gandolfini produced the HBO documentary "Alive Day Memories: Home from Iraq" in which he interviewed 10 injured veterans from the Iraq War. In 2010, Gandolfini produced another HBO documentary "Wartorn: 1861-2010" in which Post-Traumatic Stress Disorder and its impact on soldiers and families is analyzed throughout several wars in American history from 1861 to 2010.\n\nDescription above from the Wikipedia article James Gandolfini, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Westwood, New Jersey, USA	James Gandolfini
4700	\N	\N		0		James G. Robinson
4701	\N	\N		0		James W. Skotchdopole
4702	\N	\N		0		Bill Unger
1145704	1895-07-10	1960-06-14		0	Nebraska, USA	Ann Kunde
5576	1959-12-31	\N	Val Edward Kilmer (born December 31, 1959) is an American actor. Originally a stage actor, Kilmer became popular in the mid-1980s after a string of appearances in comedy films, starting with Top Secret! (1984), then the cult classic Real Genius (1985), as well as blockbuster action films, including a role in Top Gun and a lead role in Willow.\n\nDuring the 1990s, Kilmer gained critical respect after a series of films that were also commercially successful, including his roles as Jim Morrison in The Doors, Doc Holliday in 1993's Tombstone, Batman in 1995's Batman Forever, Chris Shiherlis in 1995's Heat and Simon Templar in 1997's The Saint. During the early 2000s, Kilmer appeared in several well-received roles, including The Salton Sea, Spartan, and supporting performances in Kiss Kiss Bang Bang, Alexander, and as the voice of KITT in Knight Rider.\n\nDescription above from the Wikipedia article Val Kilmer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles - California - USA	Val Kilmer
2969	1965-10-10	2006-01-24	Christopher Shannon "Chris" Penn (October 10, 1965 – January 24, 2006) was an American film and television actor known for his roles in such films as The Wild Life, Reservoir Dogs, Footloose, Rush Hour, True Romance, All the Right Moves and Pale Rider.\n\nDescription above from the Wikipedia article Chris Penn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles - California - USA	Chris Penn
3711	1955-09-18	\N	From Wikipedia, the free encyclopedia.\n\nAnna Kluger Levine (born September 18, 1953) is an American actress. She has also been credited as Anna Levine Thompson and Anna Thomson.\n\nDescription above from the Wikipedia article Anna Levine, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, USA	Anna Levine
41125	1962-03-26	\N	​From Wikipedia, the free encyclopedia\n\nEric Allan Kramer (March 26, 1962) is an American actor, perhaps best known as Little John in Robin Hood: Men in Tights, as Thor in The Incredible Hulk Returns, as Whitey van de Bunt in Bob. and as Dave Rogers in The Hughleys. He currently co-stars in the Disney Channel sitcom Good Luck Charlie as Bob Duncan.\n\nDescription above from the Wikipedia article Eric Allan Kramer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Grand Rapids, Michigan, USA	Eric Allan Kramer
893	1944-06-21	2012-08-19	Anthony D. L. "Tony" Scott (d. August 19, 2012) was an English film director. His films include Top Gun, Beverly Hills Cop II, The Last Boy Scout, True Romance, Crimson Tide, Enemy of the State, Spy Game, Man on Fire, Déjà Vu, The Taking of Pelham 1 2 3, and Unstoppable. He was the younger brother of fellow film director Ridley Scott. On August 19th 2012, Scott jumped to his death off Vincent Thomas Bridge in Los Angeles after being diagnosed with an inoperable brain tumor. \n\nDescription above from the Wikipedia article Tony Scott, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	North Shields, Northumberland, England, UK	Tony Scott
138	1963-03-27	\N	From Wikipedia, the free encyclopedia\n\nQuentin Jerome Tarantino is an American film director, screenwriter, producer, cinematographer and actor. In the early 1990s he was an independent filmmaker whose films used nonlinear storylines and aestheticization of violence. His films have earned him a variety of Academy Award, Golden Globe, BAFTA and Palme d'Or Awards and he has been nominated for Emmy and Grammy Awards. In 2007, Total Film named him the 12th-greatest director of all time.\n\nTarantino was born in Knoxville, Tennessee, the son of Connie McHugh Tarantino Zastoupil, a health care executive and nurse born in Knoxville, and Tony Tarantino, an actor and amateur musician born in Queens, New York.\n\nTarantino's mother allowed him to quit school at age 17, to attend an acting class full time. Tarantino gave up acting while attending the acting school, saying that he admired directors more than actors. Tarantino also worked in a video rental store before becoming a filmmaker, paid close attention to the types of films people liked to rent, and has cited that experience as inspiration for his directorial career.\n\nTarantino has been romantically linked with numerous entertainers, including actress Mira Sorvino, directors Allison Anders and Sofia Coppola, actresses Julie Dreyfus and Shar Jackson and comedians Kathy Griffin and Margaret Cho. There have also been rumors about his relationship with Uma Thurman, whom he has referred to as his "muse". However, Tarantino has stated that their relationship is strictly platonic. He has never married and has no children.\n\nDescription above from the Wikipedia article Quentin Tarantino, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Knoxville, Tennessee, USA	Quentin Tarantino
8297	1965-08-23	\N	From Wikipedia, the free encyclopedia.\n\nRoger Avary (born Roger d'Avary on August 23, 1965) is a Canadian film and television producer, screenwriter and director in the American mass media industry. He was behind the screenplays of the films Silent Hill and Beowulf. Before that he had worked on Reservoir Dogs and Pulp Fiction, the later of which earned both him and Quentin Tarantino an Oscar for Best Original Screenplay at the 67th Academy Awards. He also directed the films Killing Zoe and The Rules of Attraction among other film and television projects as well.\n\nDescription above from the Wikipedia article Roger Avary, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Flin Flon, Manitoba, Canada	Roger Avary
4507	\N	\N	Gary Barber is the Chairman and Chief Executive Officer of Metro-Goldwyn-Mayer Inc. (MGM),  a leading entertainment company focused on the production and distribution of film and television content globally.  He joined the company in December 2010.\n\nAfter emerging from bankruptcy in 2010, with Mr. Barber at the helm, MGM produced the 23rd James Bond adventure, “Skyfall,” along with Eon Productions and Sony Pictures, which made over $1.1 billion at the worldwide box office and became the highest-grossing Bond film of all time. Just one month later, “The Hobbit: An Unexpected Journey,” a production of New Line Cinema and MGM, was released and went on to surpass $1 billion worldwide, earning MGM the impressive distinction of being the first studio with back-to-back billion dollar releases. Under Mr. Barber’s leadership, MGM has also financed or produced highly successful films such as “21 Jump Street” and “Hansel and Gretel: Witch Hunters.” \n\nAlso thriving under Mr. Barber’s direction is MGM’s television division. The company has been responsible for new programs such as the drama series “Vikings” with HISTORY, “Teen Wolf” with MTV and a new series based on the Oscar®-winning film “Fargo” for FX. \n\nMr. Barber co-founded the production, finance and distribution company Spyglass Entertainment in 1998.  Mr. Barber continues to serve as Co-Chairman of the Board of Spyglass.\n\nSpyglass’ slate of films has grossed over $5 billion in worldwide box office to date and has amassed over 34 Oscar® nominations, including four wins. Spyglass produced such films as “The Sixth Sense,” “Bruce Almighty,” “Memoirs of a Geisha,” “27 Dresses,” “Wanted,” “Four Christmases,” “Star Trek,” “G.I. Joe: The Rise of Cobra,” “Invictus,” “Leap Year,” “Get Him To the Greek,” “Dinner For Schmucks,” “The Tourist,” “The Dilemma,” “No Strings Attached,” “The Vow” and the “Footloose” remake.\n\nMr. Barber has produced numerous feature films and has run business entities in feature film production, foreign distribution, music and exhibition. From 1989 to 1997, Mr. Barber was with Morgan Creek and served as Vice Chairman and Chief Operating Officer. Prior to this, Mr. Barber served as President of Vestron International Group.\n\nMr. Barber received his undergraduate and post graduate degrees from the University of Witwatersrand in South Africa. Earlier in his career, he practiced as a Chartered Accountant and Certified Public Accountant in both South Africa and the USA with Price Waterhouse.\n\n/Biography provided by MGM.com/	0	Johannesburg - South Africa	Gary Barber
4695	1937-09-01	2009-05-30		0	Kansas City, Missouri, USA	Don Edmonds
4697	1953-12-17	\N		0		Samuel Hadida
4699	\N	\N	Steve Perry is an assistant director and producer, known for Lethal Weapon 3 (1992),Lethal Weapon 2 (1989) and Lethal Weapon 4 (1998).	2		Steve Perry
947	1957-09-12	\N	Hans Florian Zimmer born September 12th, 1957) is a German composer and record producer. Since the 1980s, he has composed music for over 150 films. His works include The Lion King, for which he won Academy Award for Best Original Score in 1994, the Pirates of the Caribbean series, The Thin Red Line, Gladiator, The Last Samurai, The Dark Knight Trilogy, Inception, and Interstellar. Zimmer spent the early part of his career in the United Kingdom before moving to the United States. He is the head of the film music division at DreamWorks studios and works with other composers through the company that he founded, Remote Control Productions.[1] Zimmer's works are notable for integrating electronic music sounds with traditional orchestral arrangements. He has received fourGrammy Awards, three Classical BRIT Awards, two Golden Globes, and an Academy Award. He was also named on the list of Top 100 Living Geniuses, published by The Daily Telegraph.[2]	2	Frankfurt am Main, Hesse, Germany	Hans Zimmer
904	\N	\N		0		Jeffrey L. Kimball
908	\N	\N		0		Michael Tronick
6668	\N	\N		2		Christian Wagner
4710	\N	\N		0		Benjamín Fernández
795	\N	\N		0		James J. Murakami
1231	1960-12-03	\N	Julianne Moore (born Julie Anne Smith; December 3, 1960) is an American actress and a children's book author. Throughout her career she has been nominated for four Oscars, six Golden Globes, three BAFTAs and nine Screen Actors Guild Awards. Moore began her acting career in 1983 in minor roles, before joining the cast of the soap opera As the World Turns, for which she won a Daytime Emmy Award in 1988. She began to appear in supporting roles in films during the early 1990s, in films such as The Hand That Rocks the Cradle and The Fugitive. Her performance in Short Cuts (1993) won her and the rest of the cast a Golden Globe for their ensemble performance, and her performance in Boogie Nights (1997) brought her widespread attention and nominations for several major acting awards.\n\nHer success continued with films such as The Big Lebowski (1998), The End of the Affair (1999) and Magnolia (1999). She was acclaimed for her portrayal of a betrayed wife in Far from Heaven (2002), winning several critic awards as best actress of the year, in addition to several other nominations, including the Academy Award, Golden Globe, and Screen Actors Guild Award. The same year she was also nominated for several awards as best supporting actress for her work in The Hours. In 2010 Moore starred in the comedy drama The Kids Are All Right, for which she received a Golden Globe and BAFTA nomination.\n\nDescription above from the Wikipedia article Julianne Moore, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Fayetteville, North Carolina, USA	Julianne Moore
3905	1950-03-13	\N	From Wikipedia, the free encyclopedia.\n\nWilliam Hall Macy, Jr. (born March 13, 1950) is an American actor and writer. He was nominated for an Academy Award for his role as Jerry Lundegaard in Fargo. He is also a teacher and director in theater, film and television. His film career has been built mostly on his appearances in small, independent films, though he has appeared in summer action films as well. Macy has described his screen persona as "sort of a Middle American, WASPy, Lutheran kind of guy... Everyman". He has won two Emmy Awards and a Screen Actors Guild Award, being nominated for nine Emmy Awards and seven Screen Actors Guild Awards in total. He is also a three-time Golden Globe Award nominee.	2	Miami - Florida  USA	William H. Macy
4764	1965-05-24	\N	John Christopher Reilly (born May 24, 1965), better known as John C. Reilly is an American film and theatre actor. Debuting in Casualties of War in 1989, he is one of several actors whose careers were launched by Brian De Palma. To date, he has appeared in more than fifty films, including three separate films in 2002, each of which was nominated for the Academy Award for Best Picture. He was nominated for an Academy Award for Best Supporting Actor for his role in Chicago and a Grammy Award for the song "Walk Hard", which he performed in Walk Hard: The Dewey Cox Story. Description above from the Wikipedia article John C. Reilly, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Chicago, Illinois, USA	John C. Reilly
500	1962-07-03	\N	Thomas "Tom" Cruise (born Thomas Cruise Mapother IV; July 3, 1962) is an American actor and filmmaker. He has been nominated for three Academy Awards and has won three Golden Globe Awards.\n\nHe started his career at age 19 in the 1981 film Endless Love. After portraying supporting roles in Taps (1981) and The Outsiders (1983), his first leading role was in Risky Business, released in August 1983. Cruise became a full-fledged movie star after starring as Pete "Maverick" Mitchell in Top Gun (1986). He has since 1996 been well known for his role as secret agent Ethan Hunt in the Mission: Impossible film series. One of the biggest movie stars in Hollywood, Cruise has starred in many successful films, including The Color of Money (1986), Cocktail (1988), Rain Man (1988), Born on the Fourth of July (1989), Far and Away(1992), A Few Good Men (1992), The Firm (1993), Interview with the Vampire: The Vampire Chronicles (1994), Jerry Maguire (1996), Eyes Wide Shut (1999), Magnolia (1999), Vanilla Sky (2001), Minority Report (2002),The Last Samurai (2003), Collateral (2004), War of the Worlds (2005), Lions for Lambs (2007), Valkyrie (2008), Knight and Day (2010), Jack Reacher (2012), Oblivion (2013), and Edge of Tomorrow (2014).\n\nIn 2012, Cruise was Hollywood's highest-paid actor. Fifteen of his films grossed over $100 million domestically; twenty-one have grossed in excess of $200 million worldwide. Cruise is known for his support for the Church of Scientology and its affiliated social programs. From: Wikipedia.	2	Syracuse, New York, U.S	Tom Cruise
4492	1931-09-10	\N	From Wikipedia, the free encyclopedia.\n\nPhilip Baker Hall (born September 10, 1931) is an American actor.\n\nDescription above from the Wikipedia article Philip Baker Hall, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Toledo, Ohio, USA	Philip Baker Hall
43776	1960-11-13	\N	Neil Richard Flynn (born November 13, 1960) is an American actor and comedian, known for his role as Janitor in the medical comedy drama Scrubs. He also portrays Mike Heck in the ABC sitcom The Middle.\n\nDescription above from the Wikipedia article Neil Flynn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chicago - Illinois - USA	Neil Flynn
19439	1935-09-21	2009-09-14	Henry Gibson (September 21, 1935 – September 14, 2009) was an American actor and songwriter, best known as a cast member of Rowan and Martin's Laugh-In and for his recurring role as Judge Clark Brown on Boston Legal.\n\nDescription above from the Wikipedia article Charles Henry Gibson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Germantown, Philadelphia, Pennsylvania, USA	Henry Gibson
6199	1941-05-18	\N	From Wikipedia, the free encyclopedia.  Miriam Margolyes, OBE (born 18 May 1941) is an English actress and voice artist. Her earliest roles were in theatre and after several supporting roles in film and television she won a BAFTA Award for her role in The Age of Innocence (1993).\n\nDescription above from the Wikipedia article Miriam Margolyes, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Oxford, England	Miriam Margolyes
1581066	\N	\N		0		Jean Ransome
153686	1919-10-16	2002-05-23		0		Albert Carrier
120700	1901-03-07	1993-03-25		0		Louis Mercier
1233	1967-07-23	2014-02-02	Philip Seymour Hoffman (July 23, 1967 – February 2, 2014) was an American actor and director. Hoffman began acting in television in 1991, and the following year started to appear in films. He gradually gained recognition for his supporting work in a series of notable films, including Scent of a Woman (1992), Twister (1996), Boogie Nights (1997), Happiness (1998), The Big Lebowski (1998), Magnolia (1999), The Talented Mr. Ripley (1999), Almost Famous (2000), 25th Hour (2002), Punch-Drunk Love (2002), Cold Mountain (2003), and Along Came Polly (2004).  \n\nIn 2005, Hoffman played the title role in the biographical film Capote (2005), for which he won multiple acting awards including an Academy Award for Best Actor. He received another two Academy Award nominations for his supporting work in Charlie Wilson's War (2007) and Doubt (2008). Other critically acclaimed films in recent years have included Before the Devil Knows You're Dead (2007) and The Savages (2007). In 2010, Hoffman made his feature film directorial debut with Jack Goes Boating‎.\n\nHoffman is also an accomplished theater actor and director. He joined the LAByrinth Theater Company in 1995, and has directed and performed in numerous Off-Broadway productions. His performances in two Broadway plays led to two Tony Award nominations: one for Best Leading Actor in True West (2000), and another for Best Featured Actor in Long Day's Journey into Night (2003).\n\n Description above from the Wikipedia article Philip Seymour Hoffman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Fairport - New York - USA	Philip Seymour Hoffman
4765	1922-07-26	2000-12-26	​From Wikipedia, the free encyclopedia.  \n\nJason Nelson Robards, Jr. (July 26, 1922 – December 26, 2000) was an American actor on stage and in film and television and a winner of the Tony Award (theatre), two Academy Awards (film) and the Emmy Award (television). He was also a United States Navy combat veteran of World War II.\n\nHe became famous playing works of Eugene O'Neill, an American playwright, and regularly performed in O'Neill's works throughout his career. Robards was cast in both common-man roles and as well-known historical figures.\n\nDescription above from the Wikipedia article Jason Robards, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Chicago, Illinois, USA	Jason Robards
658	1953-05-24	\N	Alfred Molina (born 24 May 1953) is a British-American actor. He first came to public attention in the UK for his supporting role in the 1987 film Prick Up Your Ears. He is well known for his roles in Raiders of the Lost Ark, The Man Who Knew Too Little, Spider-Man 2, Maverick, Species, Not Without My Daughter, Chocolat, Frida, Steamboy, The Hoax, Prince of Persia: The Sands of Time, The Da Vinci Code, Little Traitor, An Education and The Sorcerer's Apprentice. He is currently starring as Detective Ricardo Morales on the NBC police/courtroom drama Law &amp; Order: LA.\n\nDescription above from the Wikipedia article Alfred Molina, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Alfred Molina
4766	1968-10-21	\N	Melora Walters (born October 21, 1968) is an American actress.\n\nDescription above from the Wikipedia article Melora Walters, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Dhahran, Saudi Arabia	Melora Walters
2234	1953-06-21	\N	Michael Bowen (born June 21, 1953) is an American actor. Films he has appeared in include Jackie Brown, Magnolia, and Less Than Zero. Bowen also had a recurring role as Danny Pickett on the ABC television series, Lost.\n\nBowen (also credited as Michael Bowen Jr.) was born to actress Sonia Sorel (1921–2004) and Beat painter Michael Bowen. He is half-brother to Robert and Keith Carradine. His nieces are actresses Martha Plimpton and Ever Carradine.\n\nDescription above from the Wikipedia article Michael Bowen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Houston - Texas - USA	Michael Bowen
4779	\N	\N		0		Jeremy Blackman
4777	\N	\N		0		Emmanuel Johnson
4778	1939-10-13	\N	Melinda Rose Dillon (born October 13, 1939) is an American actress, perhaps best known for her roles in Close Encounters of the Third Kind and the holiday classic A Christmas Story.\n\nDescription above from the Wikipedia article Melinda Dillon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Hope, Arkansas, USA	Melinda Dillon
10691	1962-05-12	\N	April Grace is a SAG Award nominated American actress.\n\nIn the early 1990s, Grace landed a recurring role as the transporter chief on Star Trek: The Next Generation. Interspersing acclaimed and award-winning stage work in Los Angeles with her film and TV roles, the actress slowly rose from bit parts in major studio films to more prominent characters in independent films. In 2001, she was seen as a TV reporter determined to become a household name in ABC's summer series The Beast, set in the world of a 24-hour cable news station.\n\nWhile she had numerous stage and small screen credits, Grace was still a relatively fresh face when writer-director Paul Thomas Anderson tapped her to play a determined television reporter in his 1999 drama Magnolia. She shared most of her scenes with Tom Cruise, who played a foul-mouthed sex guru, and the subject of her interview.\n\nGrace has also appeared on the television series Lost as the character Ms. Klugh. In 2007, Grace appeared as a news reporter in the film I Am Legend.\n\nDescription above from the Wikipedia article April Grace, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lakeland - Florida - USA	April Grace
7427	1962-12-09	\N	From Wikipedia, the free encyclopedia\n\nFelicity Kendall Huffman (born December 9, 1962) is an American film, stage, and television actress. She is known for her role as executive producer Dana Whitaker on the ABC television show Sports Night (1998—2000), which earned her an Golden Globe Award nomination, and as hectic supermom Lynette Scavo on the ABC show Desperate Housewives (2004—present), which has earned her an Emmy Award.\n\nIn 2005, her critically acclaimed role as a trans woman in the independent film Transamerica earned her a Golden Globe Award and an Academy Award nomination. She has also starred in films such as Reversal of Fortune, The Spanish Prisoner, Magnolia, Path to War, Georgia Rule and Phoebe in Wonderland.\n\nDescription above from the Wikipedia article Felicity Huffman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Bedford, New York, USA	Felicity Huffman
18270	1968-04-10	\N	From Wikipedia, the free encyclopedia.\n\nOrlando Jones (born April 10, 1968) is an American comedian and film and television actor. He is notable for being one of the original cast members of the sketch comedy series MADtv and for his role as the 7 Up spokesman from 1999-2002.\n\nDescription above from the Wikipedia article Orlando Jones, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Mobile, Alabama, USA	Orlando Jones
10743	\N	\N		0		Ricky Jay
10872	1969-01-27	\N	American stand-up comedian, writer and actor Patton Oswalt first began performing standup comedy in the late 1980s to early 1990s. After spending two seasons writing for MADtv, and starring in his own 1996 comedy special for HBO, he began performing in films and television shows.In January 2011, Oswalt released his first book, Zombie Spaceship Wasteland. Oswalt married writer Michelle Eileen McNamara on September 24, 2005. Their daughter, Alice Rigney Oswalt, was born on April 15, 2009.	0	Portsmouth - Virginia - USA	Patton Oswalt
33777	1908-11-04	1975-01-08		0		Anthony Warde
27164	1892-10-11	1980-12-30		0	Melbourne, Australia	Frank Baker
40481	1956-08-28	\N	​From Wikipedia, the free encyclopedia.  \n\nLuis Guzmán (born August 28, 1956) is an actor from Puerto Rico. He is known for his character work. For much of his career, his squat build, wolfish features, and brooding countenance have garnered him roles largely as sidekicks, thugs, or policemen, but his later career has seen him move into more mainstream roles. He is a favorite of director Steven Soderbergh, who cast him in Out of Sight, The Limey, and Traffic, and Paul Thomas Anderson, who cast him in Boogie Nights, Magnolia and Punch-Drunk Love. He also voiced Ricardo Diaz in Grand Theft Auto: Vice City and Grand Theft Auto: Vice City Stories.\n\nDescription above from the Wikipedia article Luis Guzmán, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Cayey, Puerto Rico	Luis Guzmán
9048	1962-04-02	\N	From Wikipedia, the free encyclopedia\n\nRobert Clark Gregg (born April 2, 1962) is an American actor, screenwriter and director. He co-starred as Christine Campbell's ex-husband Richard in the CBS sitcom The New Adventures of Old Christine, which debuted in March 2006 and concluded in May 2010. He is best known for playing Agent Phil Coulson in the Marvel Cinematic Universe (Iron Man, Iron Man 2 and Thor).	2	Boston - Massachusetts - USA	Clark Gregg
98365	1956-10-27	\N	Born Jane Esther Hamilton on 27 October 1956, Las Vegas, Nevada, Veronica Hart is a respected porn star of the 70s and 80s who went on to minor roles more mainstream movies. Awarded AFAA 1981/82 Best Actress, AFAA 1982 Best Supporting Actress, CAFA 1982 Best Actress.	1	Las Vegas, Nevada, USA	Veronica Hart
1219029	1968-09-12	\N	From Wikipedia, the free encyclopedia.\n\nPaul Francis Tompkins (born September 12, 1968), best known as Paul F. Tompkins, is an American actor and comedian.\n\nDescription above from the Wikipedia article Paul F. Tompkins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Philadelphia - Pennsylvania - USA	Paul F. Tompkins
4762	1970-06-26	\N	From Wikipedia, the free encyclopedia\n\nPaul Thomas Anderson (born June 26, 1970) is an American film director, screenwriter, and producer. He has written and directed five feature films: Hard Eight (1996), Boogie Nights (1997), Magnolia (1999), Punch-Drunk Love (2002) and There Will Be Blood (2007). He has been nominated for five Academy Awards — There Will Be Blood for Best Achievement in Directing, Best Motion Picture of the Year, and Best Adapted Screenplay; Magnolia for Best Original Screenplay; and Boogie Nights for Best Original Screenplay.\n\nAnderson has been hailed as being "one of the most exciting talents to come along in years" and as being "among the supreme talents of today." In 2004, Anderson was ranked 21st on The Guardian's list of the 40 best directors. In 2007, Total Film named him the 20th-greatest director of all time. In 2011, Entertainment Weekly named him the 11th-greatest working director calling him "one of the most dynamic directors to emerge in the last 20 years"\n\nDescription above from the Wikipedia article paul Thomas Anderson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Studio City, California, USA	Paul Thomas Anderson
4767	\N	\N		0		Michael De Luca
4768	\N	\N		0		Lynn Harris
10205	1949-10-08	\N	Sigourney Weaver (born October 8, 1949, height 5' 11" (1,80 m)) is an American actress best known for her role as Ellen Ripley in the Alien film series, a role for which she has received worldwide recognition. Other notable roles include the Ghostbusters films, Gorillas in the Mist, The Ice Storm, Working Girl, Death and the Maiden, Prayers for Bobby and Avatar.\n\nShe is a three-time Academy Award nominee for her performances in Aliens (1986), Gorillas in the Mist (1988), and Working Girl (1988) winning Golden Globe Awards in the latter two films. Weaver has been called "The Sci-Fi Queen" by many on account of her many science fiction and fantasy films.	1	New York City - New York - USA	Sigourney Weaver
4139	1933-08-25	\N	​From Wikipedia, the free encyclopedia\n\nThomas Roy "Tom" Skerritt (born August 25, 1933) is an American actor who has appeared in over 40 films and more than 200 television episodes since 1962.\n\nDescription above from the Wikipedia article Tom Skerritt, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Detroit, Michigan, USA	Tom Skerritt
5047	1949-04-20	\N	​From Wikipedia, the free encyclopedia\n\nVeronica A. Cartwright (born 20 April 1949) is an English-born actress who has worked mainly in American film and television.\n\nDescription above from the Wikipedia article Veronica Cartwright, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Bristol, England, UK	Veronica Cartwright
5048	1926-07-14	\N	Harry Dean Stanton (born July 14, 1926) is an American actor, musician, and singer. Stanton's career has spanned over fifty years, which has seen him star in such films as Cool Hand Luke, Kelly's Heroes, Dillinger, Alien, Repo Man, The Last Temptation of Christ, Wild at Heart, The Green Mile and The Pledge. In the late 2000s, he played a recurring role in the HBO television series Big Love.\n\nDescription above from the Wikipedia article Harry Dean Stanton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	West Irvine - Kentucky - USA	Harry Dean Stanton
5049	1940-01-22	2017-01-25	John Vincent Hurt, CBE (born 22 January 1940) was an English actor, known for his leading roles as John Merrick in The Elephant Man, Winston Smith in Nineteen Eighty-Four, Mr. Braddock in The Hit, Stephen Ward in Scandal and Quentin Crisp in The Naked Civil Servant, Caligula in the television series, I, Claudius (TV series), and An Englishman in New York. Recognizable for his distinctive rich voice, he has also enjoyed a successful voice acting career, starring in films such as Watership Down, The Lord of the Rings and Dogville, as well as BBC television series Merlin. Hurt initially came to prominence for his role as Richard Rich in the 1966 film A Man for All Seasons, and has since appeared in such popular motion pictures as: Alien, Midnight Express, Rob Roy, V for Vendetta, Indiana Jones and the Kingdom of the Crystal Skull, the Harry Potter film series and the Hellboy film series. Hurt is one of England's best-known, most prolific and sought-after actors, and has had a versatile film career spanning six decades. He is also known for his many Shakespearean roles. Hurt has received multiple awards and honours throughout his career including three BAFTA Awards and a Golden Globe Award, with six and two nominations respectively, as well as two Academy Award nominations. His character's final scene in Alien is consistently named as one of the most memorable in cinematic history.\n\nDescription above from the Wikipedia article John Hurt , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Shirebrook, Derbyshire, England, UK	John Hurt
65	1931-09-12	\N	Sir Ian Holm, CBE (born 12 September 1931) is a British actor known for his stage work and for many film roles. He received the 1967 Tony Award for Best Featured Actor for his performance as Lenny in The Homecoming and the 1998 Laurence Olivier Award for Best Actor for his performance in the title role of King Lear. He was nominated for the 1981 Academy Award for Best Supporting Actor for his role as athletics trainer Sam Mussabini in Chariots of Fire. Other well-known film roles include the android Ash in Alien, Father Vito Cornelius in The Fifth Element, and the hobbit Bilbo Baggins in the first and third films of the Lord of the Rings film trilogy.\n\nDescription above from the Wikipedia article Ian Holm, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Goodmayes, Essex, England, UK	Ian Holm
5050	1937-11-15	\N	From Wikipedia, the free encyclopedia.\n\nYaphet Frederick Kotto (born November 15, 1937) is an African-American actor, known for numerous film roles (including the sci-fi/horror film Alien and as a James Bond villain in Live and Let Die), and his starring role in the NBC television series Homicide: Life on the Street (1993-2000).\n\nDescription above from the Wikipedia article Yaphet Kotto, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	New York City, New York, U.S.	Yaphet Kotto
5051	\N	\N		0		Bolaji Badejo
5052	1923-11-21	\N		1		Helen Horton
1077325	1927-03-09	2000-08-11		2		Eddie Powell
578	1937-11-30	\N	Scott was born in South Shields, Tyne and Wear, England, the son of Elizabeth and Colonel Francis Percy Scott. He was raised in an Army family, meaning that for most of his early life, his father — an officer in the Royal Engineers — was absent. Ridley's older brother, Frank, joined the Merchant Navy when he was still young and the pair had little contact. During this time the family moved around, living in (among other areas) Cumbria, Wales and Germany. He has a younger brother, Tony, also a film director. After the Second World War, the Scott family moved back to their native north-east England, eventually settling in Teesside (whose industrial landscape would later inspire similar scenes in Blade Runner). He enjoyed watching films, and his favourites include Lawrence of Arabia, Citizen Kane and Seven Samurai. Scott studied in Teesside from 1954 to 1958, at Grangefield Grammar School and later in West Hartlepool College of Art, graduating with a Diploma in Design. He progressed to an M.A. in graphic design at the Royal College of Art from 1960 to 1962.\n\nAt the RCA he contributed to the college magazine, ARK and helped to establish its film department. For his final show, he made a black and white short film, Boy and Bicycle, starring his younger brother, Tony Scott, and his father. The film's main visual elements would become features of Scott's later work; it was issued on the 'Extras' section of The Duellists DVD. After graduation in 1963, he secured a job as a trainee set designer with the BBC, leading to work on the popular television police series Z-Cars and the science fiction series Out of the Unknown. Scott was an admirer of Stanley Kubrick early in his development as a director. For his entry to the BBC traineeship, Scott remade Paths of Glory as a short film.\n\nHe was assigned to design the second Doctor Who serial, The Daleks, which would have entailed realising the famous alien creatures. However, shortly before Scott was due to start work, a schedule conflict meant that he was replaced on the serial by Raymond Cusick.\n\nAt the BBC, Scott was placed into a director training programme and, before he left the corporation, had directed episodes of Z-Cars, its spin-off, Softly, Softly, and adventure series Adam Adamant Lives!\n\nIn 1968, Ridley and Tony Scott founded Ridley Scott Associates (RSA), a film and commercial production company.Five members of the Scott family are directors, all working for RSA. Brother Tony has been a successful film director for more than two decades; sons, Jake and Luke are both acclaimed commercials directors as is his daughter, Jordan Scott. Jake and Jordan both work from Los Angeles and Luke is based in London.\n\nIn 1995, Shepperton Studios was purchased by a consortium headed by Ridley and Tony Scott, which extensively renovated the studios while also expanding and improving its grounds.  	2	South Shields, County Durham, England, UK	Ridley Scott
5045	1946-09-30	2009-12-17	From Wikipedia, the free encyclopedia.\n\nDaniel Thomas "Dan" O'Bannon (September 30, 1946 – December 17, 2009) was an American motion picture screenwriter, director and occasional actor, usually in the science fiction and horror genres.\n\nDescription above from the Wikipedia article Dan O'Bannon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Dan O'Bannon
5053	1928-02-02	2005-09-20		0		Gordon Carroll
915	\N	\N	From Wikipedia, the free encyclopedia.  David Giler is an American filmmaker who has been active in the motion picture industry since the early 1960s.\n\nHe started his career as a writer, providing scripts for television programs such as Kraft Suspense Theatre and The Man from U.N.C.L.E.. He then moved to screenplays in the 70's, helping to write films such as The Parallax View and the original version of Fun With Dick and Jane. He produced his first film in 1970, the critically reviled Myra Breckinridge, an adaptation of Gore Vidal's controversial novel (he also co-wrote the film with director Michael Sarne). He helped Walter Hill produce the legendary horror thriller Alien in 1979, and it is for this film that he is probably best remembered. He and Hill became embroiled in a much-publicized behind-the-scenes fight with Alien's original writer, Dan O'Bannon, over who was to receive screenplay credit. Giler and Hill claim that they completely rewrote the script from top to bottom, and therefore they wanted to relegate O'Bannon to a "story by" credit only. O'Bannon claims that they did little more than change the names of the characters and dialogue, and felt that the two were trying to bully him out of the more prestigious screenplay credit. As evidenced by the interviews on the supplemental DVD features, the two parties were extremely antagonistic when it comes to this topic (O'Bannon has since died), though O'Bannon was the only one to receive credit for the screenplay in the final film. The various drafts can be found online, allowing audiences to decide for themselves.\n\nGiler worked with Hill on several more projects, including the continuation of the Alien franchise. The two were responsible for the final and very controversial rewrite of the Alien 3 story which killed off the Bishop, Hicks and Newt characters from Aliens. Some of the films that he wrote during this period include The Money Pit, Southern Comfort, and an uncredited rewrite for Beverly Hills Cop II.\n\nHe has also directed one film, The Black Bird (1975).\n\nDescription above from the Wikipedia article David Giler, licensed under CC-BY-SA, full list of contributors on Wikipedia.     	0		David Giler
1723	1942-01-10	\N	From Wikipedia, the free encyclopedia\n\nWalter Hill (born January 10, 1940) is an American film director, screenwriter, and producer. Hill is known for male-dominated action films and revival of the Western. He said in an interview, "Every film I've done has been a Western," and elaborated in another, "The Western is ultimately a stripped down moral universe that is, whatever the dramatic problems are, beyond the normal avenues of social control and social alleviation of the problem, and I like to do that even within contemporary stories."\n\n \n\nDescription above from the Wikipedia article Walter Hill (filmmaker), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Long Beach, California, USA	Walter Hill
5054	\N	\N		0		Ivor Powell
5046	\N	\N		0		Ronald Shusett
5055	\N	\N		0		Derek Vanlint
5056	\N	\N		0		Terry Rawlings
5057	\N	\N		2		Peter Weatherley
4616	\N	\N		0		Michael Seymour
5058	\N	\N		2	London, England UK	Roger Christian
5059	1941-01-11	\N		0		Leslie Dilley
5060	\N	\N		0		Ian Whittaker
5061	1931-03-18	\N		0		John Mollo
5062	\N	\N		2		Robert Hathaway
9136	\N	\N		0		H.R. Giger
9402	\N	\N		0		Brian Johnson
23349	\N	\N		0		Mary Goldberg
668	1936-03-14	2004-04-21		0		Mary Selway
1378834	\N	\N		0		Jonathan Amberston
11163	1935-08-05	\N	From Wikipedia, the free encyclopedia\n\nJohn Saxon (born August 5, 1936) is an American actor who has worked on over 200 projects during the span of sixty years. Saxon is most known for his work in horror films such as A Nightmare on Elm Street and Black Christmas, both of which feature Saxon as a policeman in search of the killer. He is also known for his role as Roper in the 1973 film Enter the Dragon, in which he starred with Bruce Lee and Jim Kelly.\n\nDescription above from the Wikipedia article John Saxon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, USA	John Saxon
13652	1945-08-24	\N	From Wikipedia, the free encyclopedia\n\nRonee Blakley (born August 24, 1945) is an American entertainer. Though an accomplished singer, songwriter, composer, producer and director, she is perhaps best known as an actress. Her most famous role was as the fictional country superstar Barbara Jean in Robert Altman's 1975 film Nashville, for which she won a National Board of Review Award for Best Supporting Actress and was nominated for an Academy Award. She also had a notable role in A Nightmare on Elm Street (1984).\n\nDescription above from the Wikipedia article Ronee Blakley, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Caldwell, Idaho, USA	Ronee Blakley
5141	1964-07-17	\N	Heather Langenkamp (born July 17, 1964) is an American film and television actress. She is best known for her role as Nancy Thompson from the A Nightmare on Elm Street films. She also played Marie Lubbock on the sitcom Just the Ten of Us.\n\nDescription above from the Wikipedia article Heather Langenkamp, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Tulsa, Oklahoma, USA	Heather Langenkamp
13656	1960-11-24	\N	From Wikipedia, the free encyclopedia\n\nAmanda Wyss (born November 24, 1960) is an American film and television actress.\n\nDescription above from the Wikipedia article Amanda Wyss, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Manhattan Beach, California, USA	Amanda Wyss
13657	1963-10-06	\N	​From Wikipedia, the free encyclopedia.  \n\nJsu Garcia (born October 6, 1963) is an American actor who has starred in many films and television shows. In his earlier years, he was credited under the name Nick Corri. Together with long time friend and NY Times #1 Bestseller author John-Roger, he runs both his own production company Scott J-R Productions and his own distribution company Gilgamesh LLC. Garcia and John-Roger have created five films, including the successful Spiritual Warriors.\n\nDescription above from the Wikipedia article Jsu Garcia  licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, United States	Jsu Garcia
85	1963-06-09	\N	John Christopher "Johnny" Depp II (born June 9, 1963) is an American actor and musician. He has won the Golden Globe Award and Screen Actors Guild award for Best Actor.\n\nDepp rose to prominence on the 1980s television series 21 Jump Street, becoming a teen idol. Turning to film, he played the title character of Edward Scissorhands (1990), and later found box office success in films such as Sleepy Hollow (1999), Pirates of the Caribbean: The Curse of the Black Pearl (2003), Charlie and the Chocolate Factory (2005), and Rango (2011). He has collaborated with director and friend Tim Burton in seven films, including Sweeney Todd: The Demon Barber of Fleet Street (2007) and Alice in Wonderland (2010). Depp has gained acclaim for his portrayals of people such as Edward D. Wood, Jr., in Ed Wood, Joseph D. Pistone in Donnie Brasco, Hunter S. Thompson in Fear and Loathing in Las Vegas, George Jung in Blow, and the bank robber John Dillinger in Michael Mann's Public Enemies.\n\nFilms featuring Depp have grossed over $2.6 billion at the United States box office and over $6 billion worldwide. He has been nominated for top awards many times, winning the Best Actor Awards from the Golden Globes for Sweeney Todd: The Demon Barber of Fleet Street and from the Screen Actors Guild for Pirates of the Caribbean: The Curse of the Black Pearl. He also has garnered a sex symbol status in American cinema, being twice named as the Sexiest man alive by People magazine in 2003 and 2009.\n\nDescription above from the Wikipedia article Johnny Depp, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Owensboro, Kentucky, USA 	Johnny Depp
5233	1951-09-24	\N	Heinz Hoenig was born on September 24, 1951 in Landsberg am Lech, Bavaria, Germany. He is an actor who participated in over 100 feature films and TV productions., known for Das Boot (1981), Seven Dwarfs (2004) and Antibodies (2005). He was previously married to Simone Hoenig.	2	Landsberg am Lech, Germany	Heinz Hoenig
5139	1947-06-06	\N	From Wikipedia, the free encyclopedia\n\nRobert Barton Englund (born June 6, 1947) is an American actor and voice-actor, best known for playing the fictional serial killer Freddy Krueger, in the Nightmare on Elm Street film series. He received a Saturn Award nomination for Best Supporting Actor for A Nightmare on Elm Street 3: Dream Warriors in 1987 and A Nightmare on Elm Street 4: The Dream Master in 1988. Englund is a classically trained actor.\n\nDescription above from the Wikipedia article robert Englund, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Glendale, California, USA	Robert Englund
1538594	\N	\N		0		Leslie Hoffman
13661	1949-05-25	\N		0	Lake County, Tennessee, USA	Joe Unger
12826	1950-08-27	\N	​From Wikipedia, the free encyclopedia\n\nCharles Fleischer (born August 27, 1950) is an American actor, stand-up comedian and voice artist.\n\nDescription above from the Wikipedia article Charles Fleischer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Washington, D.C., United States	Charles Fleischer
13660	1941-07-12	\N		0		Joseph Whipp
7401	1943-10-12	\N	From Wikipedia, the free encyclopedia.\n\nLinda "Lin" Shaye  (born 1944) is an American film, theatre and television actress.\n\nDescription above from the Wikipedia article Lin Shaye, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Detroit, Michigan, USA	Lin Shaye
13662	\N	\N		0		Mimi Craven
7219	1952-11-02	\N	From Wikipedia, the free encyclopedia.\n\nDavid Andrews (born 1952) is an American actor, best known for his role as General Robert Brewster in Terminator 3: Rise of the Machines. Andrews was born in Baton Rouge, Louisiana. His attended the Louisiana State University as an undergraduate and followed with a year at the Duke University School of Law and two at Stanford Law School, from which he graduated in the late 1970s. He set his career off in style by starring in the 1984 horror classic A Nightmare on Elm Street. For the rest of the 80s Andrews did not have any major hits, mainly focusing on a TV career. In 1990 he starred in Stephen King's Graveyard Shift and in 1994 he was James Earp in Kevin Costners Wyatt Earp. His career was boosted by starring in the TV series Mann &amp; Machine. In 1995 he played astronaut Pete Conrad, alongside Tom Hanks, Kevin Bacon and Bill Paxton in the classic space drama Apollo 13.\n\nIn the late 90s Andrews concentrated on more television projects and starred in TV films such as Our Son, the Matchmaker, Fifteen and Pregnant, which also starred Kirsten Dunst, and the hit TV film Switched at Birth. In 1998 he played another astronaut, Frank Borman, in the HBO miniseries From the Earth to the Moon. He had a brief role as Major General Eldridge G. Chapman, commander of the 13th Airborne Division, in the Band of Brothers miniseries. 1999 was a great year for Andrews: not only that he did get the success from Switched at Birth but also Fight Club, which starred Brad Pitt and Edward Norton. Andrews started off the millennium by starring in Navigating the Heart before moving on to the sequel of the cannibal series Hannibal, starring Anthony Hopkins.\n\nIn 2002 he appeared in A Walk to Remember, and in 2003 he starred in Two Soldiers, The Chester Story and Terminator 3: Rise of the Machines. He also replaced John M. Jackson in the final season of JAG, playing Judge Advocate General Major General Gordon 'Biff' Cresswell. He was Edwin Jensen in the TV Movie The Jensen Project. Andrews played the role of Scooter Libby in the 2010 film, Fair Game, based on the Valerie Plame affair.	0	Baton Rouge - Louisiana - USA	David Andrews
190793	\N	\N		0		Jack Shea
120106	\N	\N		0		Ed Call
1698597	\N	\N		0		Sandy Lipton
11408	\N	\N		2		Jeff Levine
1698598	\N	\N		0		Donna Woodrum
1698599	\N	\N		0		Paul Grenier
224322	\N	\N		0		Ash Adams
1679939	\N	\N		0		Don Hannah
42820	1961-12-27	\N	Shashawnee Hall is an actor and producer.	0	Savannah - Georgia - USA	Shashawnee Hall
1698600	\N	\N		0		Brian Reise
1698601	\N	\N		0		Carol Pritikin
1698602	\N	\N		0		Kathi Gibbs
920	1941-06-10	\N	Jürgen Prochnow is a German actor. His most well-known roles internationally have been as the sympathetic submarine captain in Das Boot (1981), Duke Leto Atreides I in Dune (1984), the minor, but important role of Kazakh dictator General Ivan Radek in Air Force One and the antagonist Maxwell Dent in Beverly Hills Cop II.\n\nProchnow was born in Berlin and brought up in Düsseldorf, the son of an engineer. He has an elder brother, Dieter. He studied acting at the Folkwang Hochschule in Essen. Thanks to his on-screen intensity and his fluency in English, he has become one of the most successful German actors in Hollywood. He portrayed Arnold Schwarzenegger in a film about the actor's political career in California, entitled See Arnold Run; coincidentally, Prochnow was one of the actors considered for the title role in The Terminator. He also appears as the main antagonist in the Broken Lizard film Beerfest, which contains a submarine scene that references his role in Das Boot. He also played a supporting character in the Wing Commander film, Cmdr. Paul Gerald. In addition, he dubbed Sylvester Stallone's voice in the German version of Rocky and Rocky II.\n\nHe was facially scarred following a stunt accident during the filming of Dune. One scene called for Prochnow (as Duke Leto) to be strapped to a black stretcher and drugged. During one take, a high-powered bulb positioned above Prochnow exploded due to heat, raining down molten glass. Remarkably, the actor was able to free himself from the stretcher, moments before glass fused itself to the place he had been strapped. During the filming of the dream sequence, he had a special apparatus attached to his face so that green smoke (simulating poison gas) would emerge from his cheek when the Baron (Kenneth McMillan) scratched it. Although thoroughly tested, the smoke gave Prochnow first and second-degree burns on his cheek. This sequence appears on film in the released version.\n\nIn 1996, he was a member of the jury at the 46th Berlin International Film Festival.\n\nProchnow was married in the 1970s, and had a daughter Johanna, who died in 1987. He married Isabel Goslar in 1982, with whom he has two children: a daughter Mona, and son Roman. They divorced in 1997. He currently divides his time between Los Angeles and Munich. He was involved with Birgit Stein, a German screenwriter and actress. He received American citizenship in 2003.	2	Berlin, Germany	Jürgen Prochnow
5228	1956-04-12	\N	From Wikipedia, the free encyclopedia\n\nHerbert Arthur Wiglev Clamor Grönemeyer (born 12 April 1956) is a German musician and actor, popular in Germany, Austria and Switzerland. He starred as war correspondent Lieutenant Werner in Wolfgang Petersen's movie Das Boot, but later concentrated on his musical career. His fifth album 4630 Bochum (1984) and his 11th album Mensch (Human) (2002) are the third and first best-selling records in Germany respectively, making him the most successful artist in Germany with combined album sales over 13 million.	2	Göttingen, Lower Saxony, Germany	Herbert Grönemeyer
5229	1940-12-18	2000-01-07	From Wikipedia, the free encyclopedia\n\nKlaus Wennemann (18 December 1940 – 7 January 2000) was a German television and film actor.\n\nWenneman was born in Oer-Erkenschwick, North Rhine-Westphalia. He is perhaps best known for his leading roles as the Chief Engineer, (the LI), in Das Boot, and as Faber in the TV series Der Fahnder. As an actor, he appeared in nine movies, and ten television series. He died in Bad Aibling, Bavaria, at the age of 59, from lung cancer. He was married to the same woman from 1963 until his death; they had two sons together.\n\nWennemann was good friends with fellow actor Jürgen Prochnow. Their real-life friendship further added to the on-screen friendship of their respective character roles, portrayed in the film Das Boot.	2	Bad Aibling, Bavière, Germany	Klaus Wennemann
5230	1952-07-10	\N	From Wikipedia, the free encyclopedia  Hubertus Bengsch (born 10 July 1952 in Berlin) is a German actor, best known for his role as the German First Officer (1WO) in Das Boot. He also is well known for being the German voice of American actor Richard Gere.	2	Berlin, Germany	Hubertus Bengsch
4924	1955-12-08	\N	From Wikipedia, the free encyclopedia\n\nMartin Semmelrogge (born 8 December 1955, Boll-Eckwälden, Bad Boll, Germany) is a German actor, best known for his role as the comical 2WO (1st Lieutenant/Second Watch Officer) in the film Das Boot. He is the brother of former actor Joachim Bernhard, who appeared in Das Boot as the religious sailor.\n\nLike many of his Das Boot co-stars, Semmelrogge went on to have a successful career in the German cinema.	2	Bad Boll, Germany	Martin Semmelrogge
2349	1950-05-07	\N	From Wikipedia, the free encyclopedia Bernd Tauber (born 7 May 1950, Göppingen, West Germany) is a German actor. He is best known for his role as Navigator Kriechbaum in the 1981 film Das Boot.\n\nIn the mid-1980s, Tauber appeared on the TV show Lindenstraße as Benno Zimmermann, the first HIV-positive character in German television.\n\nIn german TV series "Auf Achse" (1978-1996), Tauber appeared in season 1, episode "Tommy's Trip".	2	Göppingen, Baden-Württemberg, Germany	Bernd Tauber
3970	1951-07-30	\N	From Wikipedia, the free encyclopedia\n\nErwin Alois Robert Leder (born 30 July 1951 in St. Pölten, Lower Austria, Austria) is an Austrian actor. He is best known for his role as Chief Mechanic Johann in Das Boot, a 1981 feature film directed by Wolfgang Petersen about a mission of one World War II U-boat and its crew.\n\nIn 2003, Leder appeared as the lycan scientist Singe in the gothic horror/action film Underworld. He reprised his role in the sequel in a brief cameo as a corpse.	2	St. Pölten, Austria	Erwin Leder
5232	1961-04-21	\N	Martin May was born on April 21, 1961 in Coburg, Germany. He is an actor and writer, known for Das Boot (1981), Das Boot (1985) and Der Flieger (1986).	2	Coburg, Germany	Martin May
1665128	\N	\N		0		Helmut Neumeier
1665129	\N	\N		0		Wilhelm Pietsch
38601	\N	\N		0		Dirk Salomon
1665130	\N	\N		0		Ulrich Günther
682	1956-01-07	\N	Uwe Ochsenknecht was born on January 7, 1956 in Biblis, Hesse, Germany as Uwe Adam Ochsenknecht. He is an actor, known for Das Boot (1981), Schtonk (1992) and Enlightenment Guaranteed (1999). He was previously married to Natascha Ochsenknecht.	2	Biblis, Hesse, Germany	Uwe Ochsenknecht
5234	1956-11-30	\N	Claude-Oliver Rudolph was born on November 30, 1956 in Frankfurt/Main, Germany. He is an actor and writer, known for Das Boot (1981), The World Is Not Enough (1999) and Cargo (2009). He is married to Sabine von Maydell. They have two children.	2	Frankfurt-on-Main, Germany	Claude-Oliver Rudolph
5235	1955-01-14	\N	From Wikipedia, the free encyclopedia\n\nJan Fedder (born 14 January 1955 in Hamburg, Germany) is a German actor. He is best known for his role as police officer Dirk Matthies in the German television show "Großstadtrevier". He is also known for his role as the crude Petty Officer Pilgrim in Wolfgang Petersen's film, Das Boot.\n\nWhile filming a scene in which the U-96 is caught in a storm, Fedder lost his footing and was nearly swept off the conning tower set. Bernd Tauber (who played Navigator Kriechbaum) noticed Fedder was suddenly missing and cried out "Mann-über-Bord!" (man overboard). With the cameras still rolling, Tauber helped him to the conning tower hatch. Petersen did not realize at first that it was an accident and said "Good idea, Jan. We'll do that one more time!" before it came upon him. Fedder was hospitalized and his role was partially rewritten so that he was bed-ridden for a short portion of the film. The footage was developed and the scene in which Pilgrim is nearly swept off the submarine is one of the most memorable moments in the film.	2	Hamburg, Germany	Jan Fedder
4922	1957-08-17	\N	From Wikipedia, the free encyclopedia\n\nRalf Richter (born August 17, 1957 in Essen) is a German actor. He debuted as the crude sailor "Frenssen" in the Academy Award nominated 1981 film Das Boot and frequently appeared in German TV series. He played main roles in German films such as Bang Boom Bang (1999), Fußball ist unser Leben (1999) or Was nicht passt, wird passend gemacht (2002).\n\nHis younger brother Frank is known as musician FM Einheit (ex-Einstürzende Neubauten).	2	Essen, Germany	Ralf Richter
2311	1941-06-30	2013-09-12	Otto Sander (born 30 June 1941 in Hanover) is a German film, theater, and voice actor.\n\nSander grew up in Kassel, where he graduated in 1961 from the Friedrichgymnasium. After leaving school he spent his military service as a navy reserve officer and then studied theatre science, history of art and philosophy. In 1965 he made his acting debut at the Düsseldorfer chamber plays. After his first film work in the same year he abandoned his studies in 1967, and went to Munich to become a full-time actor.\n\nHe is married to the actress Monika Hansen and is stepfather to the actors Ben Becker and Meret Becker.\n\nHis career is closely connected with the Schaubühne theatre in Berlin under the direction of Peter Stein. Because of his warm, strong voice, which earned him the sobriquet "The Voice" (the English term is used), he has been used frequently as narrator for television documentaries, and numerous talking books in the 1990s.\n\nIn 1990, he was a member of the Jury at the 40th Berlin International Film Festival.[1]\n\nAmong his best-known film roles are the angel Cassiel in Wings of Desire and its sequel Faraway, So Close! by Wim Wenders, and a shell-shocked U-boat commander, Kapitänleutnant Philipp Thomsen, in Wolfgang Petersen's Das Boot. Sander also appeared in Comedian Harmonists, a biopic about the musical group of the same name. He has two brothers, the lawyer Adolf Sander, the scientist Christian (Chris) Sander, and a sister, the book dealer Marianne Sander. He also played a professor in the movie: The Promise about the division of Berlin by the wall.\n\nDescription above from the Wikipedia article Otto Sander, licensed under CC-BY-SA, full list of contributors on Wikipedia.    	2	Hanover, Germany	Otto Sander
5012	1947-05-20	\N	From Wikipedia, the free encyclopedia  Sky du Mont (born Cayetano Neven du Mont; 20 May 1947) is a German actor. He is known for his role in Eyes Wide Shut, as "Santa Maria" in Der Schuh des Manitu and for narrating the German dub of Thomas &amp; Friends.\n\ndu Mont was born in Buenos Aires, Argentina. He has been married five times and his current wife is Mirja Dumont, who is also the mother of two out of his three children, Tara Neven du Mont and Fayn Neven du Mont. His third and oldest son is called Justin Neven du Mont.\n\nHe made an uncredited appearance in Das Boot as an officer aboard the resupply ship Weser. While he only appears in the background in the theatrical and director's cut, his full appearance is featured in the uncut mini-series. He appears in Traumschiff Surprise – Periode 1 as "Herzog William der Letzte", and he plays one of the Nazi killers in The Boys from Brazil. Sky du Mont also does a lot of voiceover work for commercials as well as television continuity for German channel Pro 7.	2	Buenos Aires, Argentina.	Sky du Mont
39325	\N	\N	Joachim Bernhard was born in 1961. He is an actor, known for Das Boot (1981), Das Boot (1985) and Die Schaukel (1983).	2		Joachim Bernhard
28114	1957-03-09	\N	Oliver Stritzel was born on March 9, 1957 in Berlin, Germany. He is an actor and writer, known for Das Boot (1981), Downfall (2004) and Das Boot (1985).	2	Berlin - Germany	Oliver Stritzel
1136687	1959-01-09	\N	From Wikipedia, the free encyclopedia  Konrad Becker (born January 9, 1959 in Vienna) is a hypermedia researcher and interdisciplinary content developer, director of the Institute for New Culture Technologies-t0 and initiator of Public Netbase and World-Information.Org\n\nAs an actor Konrad Becker is most famously know for his role as Böckstiegel in Wolfgang Petersen's anti-war drama Das Boot (1981).\n\nAs a musician Konrad Becker created Monoton, the crucial Austrian electronic music act providing distinguished soundscapes. The Wire magazine singled out Monoton’s record "Monotonprodukt07" as one of the 100 most important records of the 20th century. Konrad Becker has recently focused on notebook live jamming with minimalist rigor.\n\nAt the borderline between sound art, psychoacoustics and contemporary dance practices, Konrad Becker's project has crossed a variety of genres over the years and has gone through various mutations and side projects. Starting with meta-mathematical and performative multimedia installations, from industrial ambience noise to audio software art and a dance context in the early rave scene he also developed theatrical productions.	2	Wien, Austria	Konrad Becker
1649330	\N	\N	Lutz Schnell was born in 1960 in Verden an der Aller, Lower Saxony, Germany. He is an actor, known for Das Boot (1981), Das Boot (1985) and Boo, Zino &amp; the Snurks (2004).	2	Verden an der Aller, Lower Saxony, Germany	Lutz Schnell
574349	1936-05-18	1995-04-04	Rita Cadillac was born on May 18, 1936 in Paris, France as Nicole Yasterbelsky. She was an actress, known for Das Boot (1981), Lautlos wie die Nacht (1963) and Das Boot (1985). She died on April 4, 1995 in Deauville, France. She was a famous dancer and stripper at the Crazy Horse, Paris.	1	 Paris, France	Rita Cadillac
9932	1930-01-21	\N	From Wikipedia, the free encyclopedia\n\nGünter Lamprecht (born 21 January 1930) is a German actor, known for his leading role in the Fassbinder miniseries Berlin Alexanderplatz (1980) and as a ship captain in the epic war film Das Boot (1981).	2	Berlin, Germany	Günter Lamprecht
1346868	\N	\N	Jean-Claude Hoffmann is an actor, known for Das Boot (1981), Das Boot (1985) and Der Schrei der schwarzen Wölfe (1972).	2		Jean-Claude Hoffmann
1665127	\N	\N		0		Arno Kral
1339072	1937-01-12	2015-04-25	Alan Willis was born in Yiewsley, West Drayton on the 12th January 1937.  During his long, and distinguished career, Alan worked on seminal Television series as a Music and Sound Editor including The Professionals, Das Boot and The Beiderbecke Connection.  In 1982 he was nominated for a BAFTA for Outstanding Achievement in the Excellence in the Craft of Film Sound for Harry’s Game.   In his later career, Alan worked for YTV on such beloved series as The Darling Buds of May, Heartbeat and A Touch of Frost.  	2	Yiewsley, West Drayton, England	Alan Willis
1339061	\N	\N		0		Alfred Rasche
1339062	\N	\N		0		Ago von Sperl
1339063	\N	\N		0		Rüdiger von Sperl
192	1937-06-01	\N	Morgan Porterfield Freeman, Jr. is an American actor, film director, and narrator. He is noted for his reserved demeanor and authoritative speaking voice. Freeman has received Academy Award nominations for his performances in Street Smart, Driving Miss Daisy, The Shawshank Redemption and Invictus and won in 2005 for Million Dollar Baby. He has also won a Golden Globe Award and a Screen Actors Guild Award.\n\nMorgan Freeman was born in Memphis, Tennessee, the son of Mayme Edna (née Revere) and Morgan Porterfield Freeman, Sr., a barber who died in 1961 from liver cirrhosis. Freeman was sent as an infant to his paternal grandmother in Charleston, Mississippi. He has three older siblings. Freeman's family moved frequently during his childhood, living in Greenwood, Mississippi; Gary, Indiana; and finally Chicago, Illinois.\n\nFreeman made his acting debut at age 9, playing the lead role in a school play. He then attended Broad Street High School, currently Threadgill Elementary School, in Mississippi. At age 12, he won a statewide drama competition, and while still at Broad Street High School, he performed in a radio show based in Nashville, Tennessee. In 1955, he graduated from Broad Street High School, but turned down a partial drama scholarship from Jackson State University, opting instead to work as a mechanic in the United States Air Force.\n\nFreeman moved to Los Angeles in the early 1960s and worked as a transcript clerk at Los Angeles Community College. During this period, he also lived in New York City, working as a dancer at the 1964 World's Fair, and in San Francisco, where he was a member of the Opera Ring music group. Freeman acted in a touring company version of The Royal Hunt of the Sun, and also appeared as an extra in the 1965 film The Pawnbroker. He made his off-Broadway debut in 1967, opposite Viveca Lindfors in The Nigger Lovers (about the civil rights era "Freedom Riders"), before debuting on Broadway in 1968's all-black version of Hello, Dolly!, which also starred Pearl Bailey and Cab Calloway.\n\nFreeman was married to Jeanette Adair Bradshaw from October 22, 1967, until 1979. He married Myrna Colley-Lee on June 16, 1984. The couple separated in December 2007. Freeman's attorney and business partner, Bill Luckett, announced in August 2008 that Freeman and his wife are in the process of divorce. He has two sons from previous relationships. He adopted his first wife's daughter and the couple also had a fourth child. Freeman lives in Charleston, Mississippi, and New York City. He has a private pilot's license, which he earned at age 65, and co-owns and operates Madidi, a fine dining restaurant, and Ground Zero, a blues club, both located in Clarksdale, Mississippi. He officially opened his second Ground Zero in Memphis, Tennessee on April 24, 2008.\n\nFreeman has publicly criticized the celebration of Black History Month and does not participate in any related events, saying, "I don't want a black history month. Black history is American history." He says the only way to end racism is to stop talking about it, and he notes that there is no "white history month". Freeman once said on an interview with 60 Minutes' Mike Wallace: "I am going to stop calling you a white man and I'm going to ask you to stop calling me a black man.	2	Memphis, Tennessee, USA	Morgan Freeman
5698	1909-06-07	1994-09-11	From Wikipedia, the free encyclopedia.\n\nJessie Alice "Jessica" Tandy (June 7 1909 – September 11 1994) was an English - American stage and film actress.\n\nShe first appeared on the London stage in 1926 at the age of 16, playing, among others, Katherine opposite Laurence Olivier's Henry V, and Cordelia opposite John Gielgud's King Lear. She also worked in British films. Following the end of her marriage to Jack Hawkins, she moved to New York, where she met Canadian actor Hume Cronyn. He became her second husband and frequent partner on stage and screen.\n\nShe won the Tony Award for her performance as Blanche Dubois in the original Broadway production of A Streetcar Named Desire in 1948, sharing the prize with Katherine Cornell (who won for Antony and Cleopatra) and Judith Anderson (for the latter's portrayal of Medea). Over the following three decades, her career continued sporadically and included a substantial role in Alfred Hitchcock's film, The Birds (1963), and a Tony Award-winning performance in The Gin Game (playing in the two-character play opposite her husband, Cronyn) in 1977. She, along with Cronyn was a member of the original acting company of The Guthrie Theater.\n\nIn the mid 1980s she enjoyed a career revival. She appeared opposite Hume Cronyn in the Broadway production of Foxfire in 1983 and its television adaptation four years later, winning both a Tony Award and an Emmy Award for her portrayal of Annie Nations. During these years, she appeared in films such as Cocoon (1985), also with Cronyn.\n\nShe became the oldest actress to receive the Academy Award for Best Actress for her role in Driving Miss Daisy (1989), for which she also won a BAFTA and a Golden Globe, and was nominated for an Academy Award for Best Supporting Actress for Fried Green Tomatoes (1991). At the height of her success, she was named as one of People's "50 Most Beautiful People". She was diagnosed with ovarian cancer in 1990, and continued working until shortly before her death.\n\nDescription above from the Wikipedia article Jessica Tandy, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England	Jessica Tandy
707	1952-07-01	\N	 From Wikipedia, the free encyclopedia. Daniel Edward "Dan" Aykroyd, CM (born July 1, 1952) is a Canadian comedian, actor, screenwriter, musician, winemaker and ufologist. He was an original cast member of Saturday Night Live, an originator of The Blues Brothers (with John Belushi) and Ghostbusters and has had a long career as a film actor and screenwriter. Description above from the Wikipedia article Dan Aykroyd, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Ottawa, Ontario, Canada	Dan Aykroyd
5699	1949-04-21	\N	From Wikipedia, the free encyclopedia.\n\nPatti LuPone (born April 21, 1949) is an American singer and actress, known for her Tony Award-winning performances as Eva Perón in the 1979 musical Evita and as Rose in the 2008 revival of Gypsy, and for her Olivier Award-winning performance as Fantine in the original London cast of Les Misérables.\n\nDescription above from the Wikipedia article Patti LuPone, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Northport, Long Island, New York, USA	Patti LuPone
5700	1920-11-08	1998-11-17		0		Esther Rolle
5701	\N	\N		0		Joann Havrilla
5702	\N	\N		0		William Hall Jr.
5703	\N	\N		0		Clarice F. Geigerman
5704	\N	\N		0		Muriel Moore
5705	\N	\N		0		Sylvia Kaler
1403815	\N	\N		0		Alvin M. Sugarman
1403817	\N	\N		0		Carolyn Gold
937317	\N	\N		0		Crystal R. Fox
43992	1939-02-13	1996-08-14		0		Bob Hannah
1472	1957-11-15	\N	Ray McKinnon (born November 15, 1957) is an American actor, screenwriter, film director and producer. He was married to actress and producer Lisa Blount from 1998 until her death on October 25, 2010 . He graduated with a degree in Theatre from Valdosta State University.\n\nAlong with his wife, McKinnon won the Academy Award in the category Live Action Short Film in 2001 for The Accountant. The film was produced by Ginny Mule Pictures, a company founded by himself, Lisa Blount and Walton Goggins. Ray currently lives in Little Rock, Arkansas, the hometown of his late wife.\n\nDescription above from the Wikipedia article Ray McKinnon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Adel, Georgia, USA	Ray McKinnon
569901	\N	\N		0		D. Taylor Loeb
572622	\N	\N		0		Tom Bellfort
5696	1940-08-16	\N	From Wikipedia, the free encyclopedia.\n\nBruce Beresford (born 16 August 1940) is an Australian film director who has made more than 30 feature films over a 40-year career.\n\nDescription above from the Wikipedia article Bruce Beresford, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Sydney, New South Wales, Australia	Bruce Beresford
5697	1936-12-03	\N	From Wikipedia, the free encyclopedia.\n\nAlfred Fox Uhry (born 3 December 1936) is an American playwright, screenwriter, and member of the Fellowship of Southern Writers. As of 2009, he remains the only individual to receive an Academy Award, Tony Award (2) and the Pulitzer Prize for dramatic writing.\n\nDescription above from the Wikipedia article Alfred Uhry, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Atlanta, Georgia, USA	Alfred Uhry
5322	1916-07-28	2010-01-31		2		David Brown
5706	\N	\N		0		Robert Doudell
5707	1954-04-02	\N		0		Lili Fini Zanuck
1297	1934-12-13	2012-07-13		0		Richard D. Zanuck
5708	1947-04-07	\N		0		Peter James
1732	\N	\N		2		Mark Warner
5709	1946-10-26	2011-11-03		0		Bruno Rubeo
3188	\N	\N		0		Victor Kempster
945	1959-06-24	\N		2	England, UK	Crispian Sallis
5710	\N	\N		1		Elizabeth McBride
5712	\N	\N		0		Laura Perlman
1440853	\N	\N		0		Donald Likovich
15757	1957-12-21	\N	From Wikipedia, the free encyclopedia.\n\nRaymond Albert "Ray" Romano (born December 21, 1957) is an American actor, writer, and stand-up comedian, best known for his roles on the sitcom Everybody Loves Raymond and in the Ice Age film series. He currently stars on the TNT comedy-drama Men of a Certain Age.\n\nDescription above from the Wikipedia article Ray Romano, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Queens, New York, USA	Ray Romano
5723	1964-07-22	\N	John Leguizamo (born July 22, 1964) is a Colombian-American actor, comedian, voice artist, and producer. Leguizamo is of Puerto Rican and Colombian descent.\n\nDescription above from the Wikipedia article John Leguizamo, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	 Bogotá, Colombia	John Leguizamo
5720	1959-05-15	\N	Christopher "Chris" Meledandri (born May 15, 1959) is an American film producer, and the founder and CEO of Illumination Entertainment.	2	New York City, New York, USA	Christopher Meledandri
5721	\N	\N		0		John Carnochan
1581070	\N	\N		2		Oliver Cross
5724	1957-08-18	\N	From Wikipedia, the free encyclopedia.\n\nDenis Colin Leary (born August 18, 1957) is an American actor, comedian, writer, director and film producer. Leary is known for his biting, fast paced comedic style and chain smoking. He is the star and co-creator of the television show Rescue Me, which ended its seventh and final season on September 7, 2011. Leary has starred in many motion pictures, most recently as CaptainGeorge Stacy in Marc Webb's 2012 film The Amazing Spider-Man and the voice of Diego in the animated Ice Age series.	2	Worcester, Massachusetts, US	Denis Leary
5725	1972-09-09	\N	Goran Visnjic (born September 9, 1972) is a Croatian-born American actor who has appeared in American and British films and television productions. He is best known for his role as Dr. Luka Kovač in the hit television series ER.\n\nVisnjic grew up in Sibenik, Croatia (then Yugoslavia), a port town on the Adriatic Sea, where he decided at an early age that he wanted to be an actor. He first performed in local theater groups and then entered the Academy of Dramatic Arts in Zagreb. Goran gained popularity in Croatia when, at the age of 21, he was cast as Hamlet in the prestigious Dubrovnik Summer Festival’s staging of Shakespeare’s play. His performance earned him three national Best Actor awards, including an Orlando (the Croatian equivalent of a Tony). Visnjic made his American motion-picture debut in the "Welcome to Sarajevo," drama, directed by Michael Winterbottom.\n\nIn his leisure time, Visnjic enjoys fencing, swimming and diving. He lives in Los Angeles with his wife, Eva Visnjic, and their three children.	2	Šibenik, Croatia, Yugoslavia	Goran Visnjic
70851	1969-08-28	\N	Thomas Jacob "Jack" Black (born August 28, 1969) is an American comedian, actor and musician.\n\nHe makes up one half of the comedy and satirical rock duo Tenacious D. The group has two albums as well as a television series and a film. His acting career is extensive, starring primarily as bumbling, cocky, but internally self-conscious outsiders in comedy films. He was a member of the Frat Pack, a group of comedians who have appeared together in several Hollywood films, and has been nominated for a Golden Globe award. He has also won an MTV Movie Award, and a Nickelodeon Kids Choice Award.\n\nDescription above from the Wikipedia article Jack Black, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Santa Monica - California - USA	Jack Black
5726	1964-04-24	\N	​From Wikipedia, the free encyclopedia.  \n\nCedric Antonio Kyles (born April 24, 1964), known professionally by his stage name Cedric the Entertainer, is an American actor and comedian. He is perhaps best known as the co-star of the WB sitcom The Steve Harvey Show, as Eddie in the Barbershop films, and as one of the four comedians featured in the Spike Lee film The Original Kings of Comedy.\n\nDescription above from the Wikipedia article Cedric the Entertainer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Missouri, USA	Cedric the Entertainer
17401	1951-11-17	\N	Stephen Root (born November 17, 1951) is an American actor. He is principally known for his comedic work, but has won acclaim for his occasional dramatic roles.\n\nDescription above from the Wikipedia article Stephen Root, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Sarasota, Florida, US	Stephen Root
5727	1966-12-24	\N	From Wikipedia, the free encyclopedia.\n\nKarl Diedrich Bader (born December 24, 1966), better known as Diedrich Bader, is an American actor, voice actor and comedian. Many know him for his roles as Oswald Lee Harvey on The Drew Carey Show, Lawrence from the film Office Space, and his voice portrayal of Batman on Batman: The Brave and the Bold.\n\nDescription above from the Wikipedia article Diedrich Bader, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Alexandria, Virginia, USA	Diedrich Bader
21088	1971-03-16	\N	Alan Wray Tudyk (born March 16, 1971) is an American actor known for his roles as Simon in the British comedy Death at a Funeral, as Steve the Pirate in DodgeBall: A True Underdog Story, as Sonny in the science fiction drama I, Robot, and as Hoban "Wash" Washburne in the science fiction and western television series Firefly and movie Serenity.\n\nDescription above from the Wikipedia article Alan Tudyk, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	El Paso - Texas - USA	Alan Tudyk
60019	1973-08-05	\N		0		Lorri Bagley
13636	1968-10-11	\N	Jane Krakowski (born October 11, 1968) is an American actress and singer. She is known for playing Elaine Vassal on Ally McBeal and Jenna Maroney on 30 Rock, winning Screen Actors Guild Awards for both roles. She also regularly performs on the stage, winning a Tony Award for her performance in Nine, and an Olivier Award for Guys and Dolls in London's West End.\n\nDescription above from the Wikipedia article Jane Krakowski, licensed under CC-BY-SA, full list of contributors on Wikipedia .	1	Parsippany, New Jersey, USA	Jane Krakowski
5717	\N	\N	Peter Ackerman is a writer and actor.	0		Peter Ackerman
1446460	\N	\N		0		P.J. Benjamin
52419	1969-06-09	\N	From Wikipedia, the free encyclopedia.\n\nJosh C. Hamilton (born June 9, 1969) is an American actor.\n\nHamilton was born in New York City, New York. His father is actor Dan Hamilton, and his stepmother is actress Stephanie Braxton. His Broadway credits include Proof and The Coast of Utopia (2007, Lincoln Center).\n\nDescription above from the Wikipedia article Josh Hamilton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA 	Josh Hamilton
5713	1957-03-20	\N	From Wikipedia, the free encyclopedia.\n\nJohn Christopher "Chris" Wedge (born March 20, 1957) is an American film director, best known for the films Ice Age and Robots.\n\nDescription above from the Wikipedia article Chris Wedge, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Binghamton, New York, USA	Chris Wedge
59695	1951-05-18	\N		1		Denny Dillon
102794	1932-09-09	\N		0		Mitzi McCall
1446462	\N	\N		0		Dann Fink
5714	1965-01-24	\N	From Wikipedia, the free encyclopedia.\n\nCarlos Saldanha (born July 20, 1968) is a Brazilian director of animated films. He was the director of Ice Age: The Meltdown (2006) and Ice Age: Dawn of the Dinosaurs (2009), and the co-director of Ice Age (2002) and Robots (2005).\n\nSaldanha was born in Rio de Janeiro, Brazil. He left his hometown in 1991 to follow his artistic instinct and passion for animation. With a background in computer science and a natural artistic sensibility, he found New York City the perfect locale to merge these skills and become an animator. He attended the MFA program at New York's School of Visual Arts, where he graduated with honors in 1993, after completing two animated shorts, The Adventures of Korky, the Corkscrew (1992) and Time For Love (1993). The shorts have been screened at animation festivals around the world. At SVA, Saldanha met Chris Wedge, one of the cofounders of Blue Sky Studios, who invited him to join their growing team of artists.\n\nHe also worked as animator on Wedge's short film Bunny.\n\nDescription above from the Wikipedia article Carlos Saldanha, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Rio de Janeiro, Rio de Janeiro, Brazil	Carlos Saldanha
5716	\N	\N		0		Michael Berg
5715	\N	\N		0		Michael J. Wilson
5719	\N	\N		0		Lori Forte
1581072	1907-10-23	1967-05-04		2	Minneapolis, Minnesota, USA	Jimmie Horan
3393	1954-03-11	\N	​From Wikipedia, the free encyclopedia.\n\nDavid Louis Newman (born March 11, 1954) is an American composer and conductor known particularly for his film scores. In a career spanning nearly forty years, he has composed music for nearly 100 feature films. Newman was born in Los Angeles, California, the son of Mississippi-born Martha Louise (née Montgomery) and Hollywood composer Alfred Newman. He is the brother of Thomas Newman and the cousin of Randy Newman, both of whom are also composers of film scores. An accomplished violinist, and successful concert conductor, Newman was educated at the University of Southern California.	2	 Los Angeles, California, USA	David Newman
5718	\N	\N		0		John C. Donkin
87059	\N	\N		0		Galen T. Chu
1604000	\N	\N		0		James Bresnahan
1604001	\N	\N		2		Doug Compton
229962	\N	\N		0		Mike Thurmeier
4794	1976-02-06	\N		0		Maria Simon
6083	\N	\N		0		Alice Dwyer
6086	1973-10-01	\N	Devid Striesow (born October 1, 1973 in Bergen auf Rügen) is a German actor. He starred as "Sturmbannführer Herzog" (Bernhard Krüger) in Stefan Ruzowitzky's 2007 film The Counterfeiters, which was awarded the Academy Award for Best Foreign Language Film for that year.\n\nDescription above from the Wikipedia article Devid Striesow, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Bergen auf Rügen, Germany	Devid Striesow
6082	1985-05-25	\N		0		Sebastian Urzendowsky
6091	1976-01-04	\N	From Wikipedia, the free encyclopedia.\n\nAugust Diehl (born 4 January 1976) is a German actor, known for playing the Gestapo Sturmbannführer Dieter Hellstrom in Inglourious Basterds and Michael "Mike" Krause, Evelyn Salt's husband, in the movie Salt.\n\nDescription above from the Wikipedia article August Diehl, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Berlin	August Diehl
1081	1956-03-23	\N		2	Sonthofen, Germany	Herbert Knaup
6079	\N	\N		0		Ivan Shvedoff
6080	\N	\N		0		Sergey Frolov
6081	\N	\N		0		Anna Yanovskaya
6084	1983-10-17	\N		0		Martin Kiefer
6085	\N	\N		2		Tom Jahn
6087	1965-11-30	\N		0	Weimar-Germany	Claudia Geisler
6088	\N	\N		0		Aleksandra Justa
6089	\N	\N		0		Marysia Zamachowska
6090	1971-04-23	\N		0		Janek Rieke
6092	1979-11-20	\N		0		Julia Krynke
6093	1947-02-20	\N		2	Berlin - Germany	Henry Hübchen
6094	1965-08-19	\N	Hans-Christian Schmid (1965, Altötting) is a German film director and screenwriter.\n\nDescription above from the Wikipedia article Hans-Christian Schmid, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Altötting, Germany	Hans-Christian Schmid
6095	\N	\N		0		Michael Gutmann
5195	\N	\N		0		Hansjörg Weißbrich
6096	\N	\N		0		Bogumil Godfrejow
6097	\N	\N		0		Christian M. Goldbeck
4525	1961-06-09	\N		0		Jakob Claussen
4526	\N	\N		0		Thomas Wöbke
1163290	\N	\N		0		The Notwist
6449	1937-03-30	\N	It might have been easy to write off American actor Warren Beatty as merely the younger brother of film star Shirley MacLaine, were it not for the fact that Beatty was a profoundly gifted performer whose creative range extended beyond mere acting. After studying at Northwestern University and with acting coach Stella_Adler, Beatty was being groomed for stardom almost before he was of voting age, cast in prominent supporting roles in TV dramas and attaining the recurring part of the insufferable Milton Armitage on the TV sitcom Dobie Gillis. Beatty left Dobie after a handful of episodes, writing off his part as "ridiculous," and headed for the stage, where he appeared in a stock production of +Compulsion and in William Inge's Broadway play +A Loss of Roses.\n\nThe actor's auspicious film debut occurred in Splendor in the Grass (1961), after which he spent a number of years being written off by the more narrow-minded movie critics as a would-be Brando. Both Beatty and his fans knew that there was more to his skill than that, and in 1965 Beatty sank a lot of his energy and money into a quirky, impressionistic crime drama, Mickey_One (1965). The film was a critical success but failed to secure top bookings, though its teaming of Beatty with director Arthur_Penn proved crucial to the shape of movie-making in the 1960s. With Penn again in the director's chair, Beatty took on his first film as producer/star, Bonnie and Clyde (1967). Once more, critics were hostile -- at first. A liberal amount of praise from fellow filmmakers and the word-of-mouth buzz from film fans turned Bonnie and Clyde into the most significant film of 1967 -- and compelled many critics to reverse their initial opinions and issue apologies. This isn't the place to analyze the value and influence Bonnie and Clyde had; suffice it to say that this one film propelled Warren Beatty from a handsome, talented film star into a powerful filmmaker.\n\nPicking and choosing his next projects very carefully, Beatty was offscreen as much as on from 1970 through 1975, though several of his projects -- most prominently McCabe and Mrs. Miller (1971) and The_Parallax_View (1974) -- would be greeted with effusive praise by film critics and historians. In 1975, Beatty wrote his first screenplay, and the result was Shampoo (1975), a trenchant satire on the misguided mores of the late '60s. Beatty turned director for 1978's Heaven_Can_Wait, a delightful remake of Here_Comes_Mr._Jordan that was successful enough to encourage future Hollywood bankrolling of Beatty's directorial efforts. In 1981, Beatty produced, directed, co-scripted and acted in Reds, a spectacular recounting of the Russian Revolution as seen through the eyes of American Communist John Reed. It was a pet project of Beatty's, one he'd been trying to finance since the 1970s (at that time, he'd intended to have Sergei_Bondarchuk of War and Peace fame as director). Reds failed to win a Best Picture Academy Award, though Beatty did pick up an Oscar as Best Director. Nothing Beatty has done since Reds has been without interest; refusing to turn out mere vehicles, he has taken on a benighted attempt to re-spark the spirit of the old Hope-Crosby road movies (Ishtar [1984]); brought a popular comic strip to the screen, complete with primary colors and artistic hyperbole (Dick_Tracy [1991]); and managed to make the ruthless gangster Bugsy Siegel a sympathetic visionary (Bugsy [1992]). In 1998 he was able to breath new life into political satire with Bulworth, his much acclaimed film in which he plays a disillusioned politician who turns to rap to express himself. In 2001, Beatty rekindled memories of Ishtar as he starred in another phenomenal bust, Town &amp; Country. Budgeted at an astronomical 90 million dollars and earning a miserable 6.7 million dollars during it's brief theatrical run, Town &amp; Country was released three years after completion and pulled from theaters after a mere four weeks, moving critics to rank it among the biggest flops in movie history.\n\nFiercely protective of his private life, and so much an advocate of total control that he will dictate the type of film stock and lighting to be used when being interviewed for television, Beatty has nonetheless had no luck at all in keeping his many amours out of the tabloids. However, Beatty's long and well-documented history of high-profile romances with such actresses as Leslie_Caron, Julie_Christie, Diane_Keaton, and Madonna came to an abrupt end upon his 1992 marriage to Bugsy co-star Annette_Bening, with whom he later starred in 1994's Love_Affair, his blighted remake of the 1957 An Affair to Remember.	2	Richmond, Virginia, U.S.	Warren Beatty
6450	1941-01-14	\N	From Wikipedia, the free encyclopedia. Faye Dunaway (born January 14, 1941) is an American actress. Dunaway won an Academy Award for Best Actress for her performance in Network (1976) after receiving previous nominations for the critically acclaimed films Bonnie and Clyde (1967) and Chinatown (1974). She has starred in a variety of films, including The Thomas Crown Affair (both the 1968 and 1999 versions), The Towering Inferno (1974), Three Days of the Condor (1975), and Mommie Dearest (1981). Description above from the Wikipedia article Faye Dunaway, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Bascom, Florida, USA	Faye Dunaway
6451	1939-05-30	\N	From Wikipedia, the free encyclopedia.\n\nMichael J. Pollard (born May 30, 1939) is an American actor.\n\nDescription above from the Wikipedia article Michael J. Pollard, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Passaic, New Jersey, U.S.	Michael J. Pollard
3460	1933-06-11	2016-08-29	Gene Wilder (born Jerome Silberman; June 11, 1933 - August 29, 2016) was an American stage and screen actor, director, screenwriter, and author.\n\nWilder began his career on stage, making his screen debut in the film Bonnie and Clyde in 1967. His first major role was as Leopold Bloom in the 1968 film The Producers. This was the first in a series of prolific collaborations with writer/director Mel Brooks, including 1974's Young Frankenstein, the script of which garnered the pair an Academy Award nomination for Best Adapted Screenplay. Wilder is known for his portrayal of Willy Wonka in Willy Wonka &amp; the Chocolate Factory (1971) and for his four films with Richard Pryor: Silver Streak (1976), Stir Crazy (1980), See No Evil, Hear No Evil (1989), and Another You (1991). Wilder has directed and written several of his films, including The Woman in Red (1984).\n\nHis marriage to actress Gilda Radner, who died from ovarian cancer, led to his active involvement in promoting cancer awareness and treatment, helping found the Gilda Radner Ovarian Cancer Detection Center in Los Angeles and co-founding Gilda's Club.\n\nIn more recent years, Wilder turned his attention to writing, producing a memoir in 2005, Kiss Me Like A Stranger: My Search for Love and Art, and the novels My French Whore (2007), The Woman Who Wouldn't (2008), and What Is This Thing Called Love (2010).\n\nWilder sadly passed away on the 29th of August, 2016. 	2	Milwaukee - Wisconsin - USA	Gene Wilder
193	1930-01-30	\N	Eugene Allen "Gene" Hackman (born January 30, 1930) is a retired American actor and novelist.\n\nNominated for five Academy Awards, winning two, Hackman has also won three Golden Globes and two BAFTAs in a career that spanned four decades. He first came to fame in 1967 with his performance as Buck Barrow in Bonnie and Clyde. His major subsequent films include I Never Sang for My Father (1970); his role as Jimmy "Popeye" Doyle in The French Connection (1971) and its sequel French Connection II (1975); The Poseidon Adventure (1972); The Conversation (1974); A Bridge Too Far (1977); his role as arch-villain Lex Luthor in Superman (1978), Superman II (1980), and Superman IV: The Quest for Peace (1987); Under Fire (1983); Twice in a Lifetime (1985); Hoosiers (1986); No Way Out (1987); Mississippi Burning (1987); Unforgiven (1992); Wyatt Earp (1994); The Quick and the Dead, Crimson Tide and Get Shorty (all 1995); Enemy of the State (1998); The Royal Tenenbaums (2001); and his final film role before retirement, in Welcome to Mooseport (2004).\n\nDescription above from the Wikipedia article Gene Hackman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Bernardino - California - USA	Gene Hackman
6817	1928-05-30	\N	From Wikipedia, the free encyclopedia.\n\nAgnès Varda (born 30 May 1928) is a French film director and professor at the European Graduate School.[1] Her movies, photographs, and art installations focus on documentary realism, feminist issues, and social commentary — with a distinct experimental style.\n\nDescription above from the Wikipedia article Agnès Varda, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brussels, Belgium	Agnès Varda
19086	\N	\N		0		Jean Rabier
6461	1927-11-20	\N	From Wikipedia, the free encyclopedia.\n\nEstelle Margaret Parsons (born November 20, 1927) is an American theatre, film and television actress and occasional theatrical director.\n\nAfter studying law, Parsons became a singer before deciding to pursue a career in acting. She worked for the television program Today and made her stage debut in 1961. During the 1960s, Parsons established her career on Broadway before progressing to film. She received an Academy Award for Best Supporting Actress for her role as Blanche Barrow in Bonnie and Clyde (1967), and was also nominated for her work in Rachel, Rachel (1968).\n\nParsons worked extensively in film and theatre during the 1970s and later directed several Broadway productions. More recently her television work included a role in the sitcom Roseanne. Nominated on four occasions for a Tony Award, in 2004 Parsons was inducted into the American Theatre Hall of Fame.\n\nDescription above from the Wikipedia article Estelle Parsons, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lynn, Massachusetts, U.S.	Estelle Parsons
6462	1920-05-11	1997-12-25		0		Denver Pyle
6463	1907-02-26	1994-10-03		0	Richmond - Virginia - USA	Dub Taylor
6464	1936-11-26	\N		0		Evans Evans
6798	\N	\N		0		Mabel Cavitt
58513	1919-06-17	2005-12-28		2	Bartlesville, Oklahoma, USA	Patrick Cranshaw
1213032	\N	\N		0		Owen Bush
170523	1921-05-31	1969-10-03		0		Clyde Howdy
999538	\N	\N		0		Russ Marker
91988	\N	\N		0		Ann Palmer
166358	1918-06-25	1985-01-30		2	San Francisco, California, USA	Ken Mayer
6448	1922-09-27	2010-09-28	From Wikipedia, the free encyclopedia.\n\nArthur Hiller Penn (September 27, 1922 – September 28, 2010) was an American film director and producer with a career as a theater director as well. Penn amassed a critically acclaimed body of work throughout the 1960s and 1970s.\n\nDescription above from the Wikipedia article Arthur Penn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Philadelphia, Pennsylvania, United States	Arthur Penn
6452	1905-05-26	1983-05-30	While still a teenager, the future Academy Award-winning lensman began as an assistant cameraman in 1923 on John Ford's 1924 western saga The Iron Horse. He was then hired by the Famous Players-Lasky Studios in 1927, became a camera operator in 1928 and worked there until 1943. Guffey was hired as a Director of Photography by Columbia Pictures in 1944.\n\nIn 1957-58 he served as president of the American Society of Cinematographers (A.S.C.) for a year, and had been a long standing member.\n\nAccording to film critic Spencer Selby, Guffey was a prolific film noir cinematographer, shooting 20 of them, including In a Lonely Place (1950).​	2	Del Rio, Tennessee, U.S.	Burnett Guffey, A.S.C.
6453	1925-12-03	2010-04-17		0		Dede Allen
2875	1932-05-18	\N		0		Dean Tavoularis
6454	\N	\N		0		Raymond Paul
6455	1929-03-27	\N		0		Theadora Van Runkle
173929	1930-11-08	\N		0		Bob Harris
1331195	1932-11-16	1988-02-05		2	Los Angeles County, California, USA	Bennie E. Dobbins
1461972	\N	\N		0		Roydon Clark
6459	1928-06-07	\N		0		Charles Strouse
6728	1937-02-04	2003-06-27	David Newman (February 4, 1937 - June 27, 2003)  was an American filmmaker. From the late 1960s through the early 1980s  he frequently collaborated with Robert Benton. He was married to fellow  writer Leslie Newman, with whom he had two children, until the time of  his death. He died in 2003 of conditions from a stroke.  Newman studied at the University of Michigan.	0	New York City - New York - USA	David Newman
6729	1932-09-29	\N	From Wikipedia, the free encyclopedia.\n\nRobert Douglas Benton (born September 29, 1932) is an American screenwriter and film director.\n\nBenton was born in Waxahachie, Texas, the son of Dorothy (née Spaulding) and Ellery Douglass Benton, a telephone company employee. He attended the University of Texas and Columbia University.[1] Benton has enjoyed a highly successful career in film, winning numerous prestigious awards for both writing and directing. He was also the art director at Esquire magazine in the early 1960s. In 2006, he appeared in the documentary Wanderlust, as did a number of other well-known people.\n\nBenton's family originally hailed from Northumberland in Great Britain, where the Bentons held a seat long before the Norman Conquest. Many family members settled in America, including Abigail and Isabel Benton, who settled in Virginia in 1642; George Benton, who settled in Barbados in 1669; and Robert Benton, who settled in Virginia in 1635. Benton was once a noble family, but they became commoners after the Norman invasion. Robert Benton still has relatives living in England who trace their origins to the seventeenth century. Other prominent Bentons include: Thomas Hart Benton and William Burnett Benton.\n\nDescription above from the Wikipedia article Robert Benton, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Waxahachie, Texas, USA	Robert Benton
11057	1934-11-23	\N	From Wikipedia, the free encyclopedia.\n\nRobert Towne (born Robert Bertram Schwartz November 23, 1934) is an American screenwriter and director. His most notable work may be his Academy Award-winning original screenplay for Roman Polanski's Chinatown (1974).\n\nDescription above from the Wikipedia article Robert Towne, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Los Angeles, California, USA	Robert Towne
16193	\N	\N		0		Robert Jiras
1529473	\N	\N		0		Russell Saunders
46608	\N	\N		0		Jack N. Reddish
2201	1929-04-10	\N	From Wikipedia, the free encyclopedia.\n\nMax von Sydow ( born 10 April 1929) is a Swedish actor. He has also held French citizenship since 2002. He has starred in many films and had supporting roles in dozens more. He has performed in films filmed in many languages, including Swedish, Norwegian, English, Italian, German, Danish, French and Spanish.\n\nSome of his most memorable film roles include knight Antonius Block in Ingmar Bergman's The Seventh Seal (the first of his eleven films with Bergman and the film that includes the iconic shot of his career in the scene where he plays chess with Death), Jesus in George Stevens's The Greatest Story Ever Told, Father Merrin in Friedkin's The Exorcist, Joubert the assassin in Three Days of the Condor, and Ming the Merciless in the 1980 version of Flash Gordon.\n\nDescription above from the Wikipedia article Max von Sydow, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Lund, Skåne län, Sweden	Max von Sydow
7565	1937-12-04	\N	Corinne Marchand, née Denise Marie Renée Marchand le 4 décembre 1937 dans le 10e arrondissement de Paris, est une actrice et chanteuse française, rendue célèbre par le film d'Agnès Varda : Cléo de 5 à 7 (1962).\n\nÉlève de cours dramatiques, elle est d'abord chanteuse et meneuse de revues, et joue dans des opérettes. Après des petits rôles au cinéma, Agnès Varda lui offre celui de « Cléo » qui la fait accéder à la célébrité du jour au lendemain. Elle a également présenté des émissions télévisées aux côtés de Jean-Claude Darnal (Jeux de Noël, le 24 décembre 1965 sur la 1re chaîne).\n\n  	0	Paris,France	Corinne Marchand
7566	\N	\N		0		Antoine Bourseiller
7568	1919-01-27	1998-08-16		1		Dominique Davray
1151713	\N	\N		0		Dorothée Blanck
6649	1909-11-13	1986-05-26	From Wikipedia, the free encyclopedia.\n\nGunnar Björnstrand (13 November 1909 – 26 May 1986) was a Swedish actor known for his frequent work with writer/director Ingmar Bergman. He was born in Stockholm. He appeared in over 120 films.\n\nBjörnstrand at first had trouble finding work but got an engagement in Helsinki with his wife 1936-1938. Back in Stockholm he met Ingmar Bergman, at that time a mostly unknown theatre director. In the 1940s he got his first major film roles, making a breakthrough with the 1946 movie Kristin kommenderar. He was a versatile actor who could play tough and tender as well as comedy and tragedy. His daughter Veronica Björnstrand is also an actress. One of his most famous roles was as the worldly squire who makes such a contrast to his austere and spiritual master in Bergman's most famous film The Seventh Seal.\n\nDescription above from the Wikipedia article Gunnar Björnstrand, licensed under CC-BY-SA, full list of contributors on Wikipedia​	2	Stockholm, Stockholms län, Sweden	Gunnar Björnstrand
6656	1920-02-08	1971-11-26		0	Stockholm, Stockholms län, Sweden	Bengt Ekerot
6658	1908-05-31	2000-06-28		2	Malmö, Skåne län, Sweden	Nils Poppe
6657	1935-11-11	\N	Her artistic dreams came early in life and were further supported by her older sister Gerd Andersson who became a ballet dancer at the Royal Opera and made her acting debut in 1951. Bibi, on the other side, had to make do with bit parts and commercials. She debuted in Dum-Bom (1953), playing against Nils Poppe. Eventually, she was able to start at the Royal Dramatic Theatre's acting school in 1954. A brief relationship with Ingmar Bergman made her quit school and follow him to the Malmö city theatre, where he was a director, performing in plays by August Strindberg and Hjalmar Bergman. Bergman also gave her a small part in his comedy Smiles of a Summer Night (1955), and larger roles in his Wild Strawberries (1957) and The Seventh Seal (1957). From the the 1960s she got offers from abroad, with best result in I Never Promised You a Rose Garden (1977). During the civil war in Yugoslavia she has worked with several initiatives to give the people of Sarajevo theatre and other forms of culture.\n\nIMDb Mini Biography By: Mattias Thuresson	1	Kungsholmen, Stockholm, Stockholms län, Sweden	Bibi Andersson
6659	1925-05-02	2000-10-18		1	 Stockholm, Stockholms län, Sweden	Inga Gill
6660	1937-12-05	\N		0		Maud Hansson
6661	1927-08-06	\N	From Wikipedia, the free encyclopedia.\n\nInga Landgré (born 6 August 1927) is a Swedish film actress. She was born in Stockholm, Sweden.\n\nDescription above from the Wikipedia article Inga Landgré, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Stockholm, Sweden	Inga Landgré
6662	1931-12-18	\N	Gunnel Lindblom (born Gunnel Märtha Ingegärd Lindblom, 18 December 1931 Gothenburg, Sweden), is a Swedish film actress and director. As an actor she has been particularly associated with the work of Ingmar Bergman, though in 1965 she performed the lead role in Miss Julie for BBC Television. She also played the key-role of The Mummy in Bergman's staging of Strindberg's The Ghost Sonata in 1998-2000, a performance that earned her much critical acclaim.\n\nMarried to senior lecturer Sture Helander (who was Ingmar Bergman's personal physician), she was sometimes credited as Gunnel Lindblom Helander, or Gunnel Helander.\n\nShe appeared on stage as Tintomara's mother in Carl Jonas Love Almqvist's play Drottningens juvelsmycke (English: The Queen's Tiara), staged at Dramaten for the theatre's 100 years Jubilee in 2008. Currently (2009) directing the Jon Fosse play Flicka i gul regnjacka (Girl in Yellow Raincoat) at Dramaten, starring Stina Ekblad and Irene Lindh, which premiered on October 9.\n\nDescription above from the Wikipedia article Gunnel Lindblom, licensed under CC-BY-SA, full list of contributors on Wikipedia​	1	Gothenburg, Sweden	Gunnel Lindblom
6663	1913-02-13	1991-09-11		0	Malmö, Skåne län, Sweden	Bertil Anderberg
6664	1916-04-07	1979-11-17	From Wikipedia, the free encyclopedia\n\nAnders Ek (7 April 1916 – 17 November 1979) was a Swedish film actor. He was born in Gothenburg, Sweden and died in Stockholm. He was married to Birgit Cullberg and is the father of dancer Mats Ek and actress Malin Ek.\n\nDescription above from the Wikipedia article Anders Ek, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	Gothenburg, Sweden	Anders Ek
6665	1919-06-23	1985-08-26		2	Gävle, Gävleborgs län, Sweden	Åke Fridell
6666	1904-07-10	1983-09-16		0	Nyköping, Södermanlands län, Sweden	Gunnar Olsson
6667	1919-09-14	1963-01-05		0		Erik Strandmark
403150	1921-04-06	1993-04-13		0	Helsinki, Finland	Sten Ardenstam
58305	1910-04-06	1993-06-28		0	Malmö, Skåne län, Sweden	Gudrun Brost
231921	1935-01-17	\N		0	Umeå, Västerbottens län, Sweden	Lars Lind
550014	1907-01-06	1957-01-08		0	Halmstad, Hallands län, Sweden	Benkt-Åke Benktsson
321845	1886-11-19	1967-09-05		0	 Stockholm, Stockholms län, Sweden	Tor Borong
1194870	\N	\N		0		Harry Asklund
1194871	\N	\N		0		Tommy Karlsson
34774	1922-08-11	2000-05-15		0	Stockholm, Stockholms län, Sweden	Gösta Prüzelius
244278	1924-07-20	1990-02-18		0	Norrköping, Östergötlands län, Sweden	Tor Isedal
32729	1935-01-24	\N		0	 Stockholm, Stockholms län, Sweden	Mona Malm
1194872	\N	\N		0		Josef Norman
1194873	\N	\N		0		Fritjof Tall
1186207	\N	\N		0		Catherine Berg
1194874	\N	\N		0		Lena Bergman
131579	1922-02-03	1990-02-15		0	 Stockholm, Stockholms län, Sweden	Ulf Johanson
1194875	\N	\N		0		Gordon Löwenadler
1194876	1888-12-26	1968-10-16		0	Stockholm, Stockholms lan, Sweden	Nils Whiten
6648	1918-07-14	2007-07-30	From Wikipedia, the free encyclopedia.\n\nErnst Ingmar Bergman (14 July 1918 – 30 July 2007) was a Swedish director, writer and producer for film, stage and television. His influential body of work dealt with bleakness and despair as well as comedy and hope. Described by Woody Allen as "probably the greatest film artist, all things considered, since the invention of the motion picture camera", he is recognized as one of the most accomplished and influential film directors of all time. However, despite critical acclaim, his films rarely earned large grosses or gained wide audiences.\n\nHe directed over sixty films and documentaries for cinematic release and for television, most of which he also wrote, and directed over one hundred and seventy plays. Among his company of actors were Liv Ullmann, Bibi Andersson, Erland Josephson, Ingrid Thulin and Max von Sydow. Most of his films were set in the landscape of Sweden. His major subjects were death, illness, faith, betrayal, and insanity.\n\nBergman was active for more than six decades. In 1976 his career was seriously threatened as the result of a botched criminal investigation for alleged income tax evasion. Outraged, Bergman suspended a number of pending productions, closed his studios, and went into self-imposed exile in Germany for eight years.\n\nDescription above from the Wikipedia article Ingmar Bergman, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Uppsala, Uppsala län, Sweden	Ingmar Bergman
6650	1918-01-16	2009-09-04		0	Örebro, Örebro län, Sweden	Allan Ekelund
6651	\N	\N		0		Erik Nordgren
24296	\N	\N		0		Bernard Evein
1037	1939-05-13	\N	Harvey Keitel (born May 13, 1939) is an American actor. Some of his more notable starring roles were in Martin Scorsese's Mean Streets and Taxi Driver, Ridley Scott's The Duellists and Thelma and Louise, Quentin Tarantino's Reservoir Dogs and Pulp Fiction, Jane Campion's The Piano, Abel Ferrara's Bad Lieutenant, James Mangold's Cop Land, Nicolas Roeg's Bad Timing, and Theo Angelopoulos's Ulysses' Gaze. His latest work was as Detective Lieutenant Gene Hunt on the American adaptation of Life on Mars.\n\nDescription above from the Wikipedia article Harvey Keitel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Brooklyn, New York, USA	Harvey Keitel
3129	1961-05-14	\N	From Wikipedia, the free encyclopedia\n\nSimon Timothy "Tim" Roth (born 14 May 1961) is an English film actor and director best known for his roles in the American films Reservoir Dogs, Pulp Fiction, Four Rooms, Planet of the Apes, The Incredible Hulk and Rob Roy, receiving an Academy Award nomination for Best Supporting Actor for the latter. He most recently starred as Cal Lightman in the TV series Lie to Me.\n\nDescription above from the Wikipedia article Tim Roth, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England, UK	Tim Roth
147	1957-09-25	\N	Michael Søren Madsen (born September 25, 1957) is an American actor, poet, and photographer. He has starred in central roles in such films as Reservoir Dogs, Free Willy, Donnie Brasco, and Kill Bill, in addition to a supporting role in Sin City. Madsen is also credited with voice work in several video games, including Grand Theft Auto III, True Crime: Streets of L.A. and DRIV3R.	2	Chicago, Illinois, USA	Michael Madsen
884	1957-12-13	\N	Steven Vincent "Steve" Buscemi is an American actor, writer and film director. He was born in Brooklyn, New York, the son of Dorothy, who worked as a hostess at Howard Johnson's, and John Buscemi, a sanitation worker and Korean War veteran. Buscemi's father was Sicilian American and his mother Irish American. He has three brothers: Jon, Ken, and Michael. Buscemi was raised Roman Catholic.\n\nIn April 2001, while shooting the film Domestic Disturbance in Wilmington, North Carolina, Buscemi was stabbed three times while intervening in a bar fight at Firebelly Lounge between his friend Vince Vaughn, screenwriter Scott Rosenberg and a local man, who allegedly instigated the brawl.\n\nBuscemi has one son, Lucian, with his wife Jo Andres.	2	New York City, New York, USA	Steve Buscemi
6937	1919-03-15	2002-02-26	From Wikipedia, the free encyclopedia.\n\nLawrence Tierney (March 15, 1919 – February 26, 2002) was an American actor, known for his many screen portrayals of mobsters and hardened criminals, which mirrored his own frequent brushes with the law.\n\nCommenting on the DVD release of a Tierney film in 2005, a New York Times critic observed: "The hulking Tierney was not so much an actor as a frightening force of nature."\n\nDescription above from the Wikipedia article Lawrence Tierney, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York	Lawrence Tierney
6939	1933-12-31	2005-07-19		2		Edward Bunker
6938	1950-01-30	\N		0	New York City, New York, USA	Randy Brooks
3206	1959-09-14	\N		0		Kirk Baltz
3214	1955-12-06	\N	From Wikipedia, the free encyclopedia.  \n\nSteven Alexander Wright (born December 6, 1955) is an American comedian, actor and writer. He is known for his distinctly lethargic voice and slow, deadpan delivery of ironic, philosophical and sometimes nonsensical jokes and one-liners with contrived situations.\n\nDescription above from the Wikipedia article Steven Wright, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Steven Wright
7124	1905-01-03	1986-03-10	From Wikipedia, the free encyclopedia.  \n\nRay Milland (3 January 1905 – 10 March 1986) was a Welsh actor and director. His screen career ran from 1929 to 1985, and he is best remembered for his Academy Award–winning portrayal of an alcoholic writer in The Lost Weekend (1945), the murder-plotting husband in Dial M for Murder (1954), and as Oliver Barrett III in the 1970 film, Love Story.\n\nDescription above from the Wikipedia article Ray Milland, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Neath, Glamorgan, Wales, UK	Ray Milland
4070	1929-11-12	1982-09-14	From Wikipedia, the free encyclopedia.\n\nGrace Patricia Kelly (November 12, 1929 – September 14, 1982) was an American actress who, in April 1956, married Rainier III, Prince of Monaco, to become Princess consort of Monaco, styled as Her Serene Highness The Princess of Monaco, and commonly referred to as Princess Grace.\n\nAfter embarking on an acting career in 1950, at the age of 20, Grace Kelly appeared in New York City theatrical productions as well as in more than forty episodes of live drama productions broadcast during the early 1950s Golden Age of Television. In October 1953, with the release of Mogambo, she became a movie star, a status confirmed in 1954 with a Golden Globe Award and Academy Award nomination as well as leading roles in five films, including The Country Girl, in which she gave a deglamorized, Academy Award-winning performance. She retired from acting at 26 to enter upon her duties in Monaco. She and Prince Rainier had three children: Caroline, Albert, and Stéphanie. She also retained her American roots, maintaining dual US and Monégasque citizenships.\n\nShe died on September 14, 1982, when she lost control of her automobile and crashed after suffering a stroke. Her daughter Princess Stéphanie, who was in the car with her, survived the accident.\n\nIn June 1999, the American Film Institute ranked her No.13 in their list of top female stars of American cinema.	0	Philadelphia - Pennsylvania - USA	Grace Kelly
7125	1910-06-10	1990-12-02	Effective light comedian of '30s and '40s films and '50s and '60s TV series, Robert Cummings was renowned for his eternally youthful looks (which he attributed to a strict vitamin and health-food diet). He was educated at Carnegie Tech and the American Academy of Dramatic Arts. Deciding that Broadway producers would be more interested in an upper-crust Englishman than a kid from Joplin, Missouri, Cummings passed himself off as Blade Stanhope Conway, British actor. The ploy was successful. Cummings decided that if it worked on Broadway, it would work in Hollywood, so he journeyed west and assumed the identity of a rich Texan named Bruce Hutchens. The plan worked once more, and he began securing small parts in films. He soon reverted to his real name and became a popular leading man in light comedies, usually playing well-meaning, pleasant but somewhat bumbling young men. He achieved much more success, however, in his own television series in the '50s, The Bob Cummings Show (1955) and My Living Doll (1964).\n\nCummings was born June 10, 1910, in Joplin, Missouri, and he died of kidney failure December 2, 1990, in Woodland Hills, California. He is interred at Forest Lawn, Glendale, California, in the Great Mausoleum, Columbarium of Sanctity.	0	Joplin, Missouri, USA	Robert Cummings
5182	1903-04-15	1983-05-05	From Wikipedia, the free encyclopedia\n\nJohn Williams (15 April 1903 – 5 May 1983) was an English stage, film and television actor. He is remembered for his role as chief inspector Hubbard in Alfred Hitchcock's Dial M For Murder, and as portraying the second "Mr. French" on TV's Family Affair.\n\nDescription above from the Wikipedia article John Williams (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chalfont, Buckinghamshire, England, UK	John Williams
7682	1916-10-18	1992-01-08		2	Edinburgh, Scotland, UK	Anthony Dawson
1217924	\N	\N		0		Leo Britt
121323	1898-11-23	1984-07-28	From Wikipedia, the free encyclopedia\n\nBess Flowers (November 23, 1898 – July 28, 1984) was an American actress. By some counts considered the most prolific actress in the history of Hollywood, she was known as "The Queen of the Hollywood Extras," appearing in over 700 movies in her 41 year career.\n\nBorn in Sherman, Texas, Flowers's film debut came in 1923, when she appeared in Hollywood. She made three films that year, and then began working extensively. Many of her appearances are uncredited, as she generally played non-speaking roles.\n\nBy the 1930s, Flowers was in constant demand. Her appearances ranged from Alfred Hitchcock and John Ford thrillers to comedic roles alongside of Charley Chase, the Three Stooges, Leon Errol, Edgar Kennedy, and Laurel and Hardy.\n\nShe appeared in the following five films which won the Academy Award for Best Picture: It Happened One Night, You Can't Take it with You, All About Eve, The Greatest Show on Earth, and Around the World in Eighty Days. In each of these movies, Flowers was uncredited. Including these five movies, she had appeared in twenty-three Best Picture nominees in total, making her the record holder for most appearances in films nominated for the award. Her last movie was Good Neighbor Sam in 1964.\n\nFlowers's acting career was not confined to feature films. She was also seen in many episodic American TV series, such as I Love Lucy, notably in episodes, "Lucy Is Enceinte" (1952), "Ethel's Birthday" (1955), and "Lucy's Night in Town" (1957), where she is usually seen as a theatre patron.\n\nOutside her acting career, in 1945, Bess Flowers helped to found the Screen Extras Guild (active: 1946-1992, then merged with SAG), where she served as one of its first vice-presidents and recording secretaries.	1	Sherman, Texas, USA	Bess Flowers
87518	1920-06-07	1989-12-10		0		Robin Hughes
9923	1923-11-22	1996-01-30		0		Guy Doleman
1216356	1877-01-11	1969-10-22	Sam Harris was born on January 11, 1877 in Sydney, Australia. He is known for his work on The Spirit of Gallipoli (1928), I Cover the War! (1937) and Island of Love (1963). He died on October 22, 1969 in Los Angeles, California, USA.	2	 Sydney, Australia	Sam Harris
171111	1894-05-31	1972-07-18	Harold Miller was born on May 31, 1894 in Redondo Beach, California, USA as Harold Edwin Kammermeyer. He was an actor, known for Souvenirs (1928), Tipped Off (1923) and Mountain Madness (1920). He died on July 18, 1972 in Los Angeles, California.	2	Redondo Beach, California, USA	Harold Miller
14573	1931-12-28	\N	From Wikipedia, the free encyclopedia.  Martin Sam Milner (born December 28, 1931) is an American actor best known for his performances in two popular television series, Adam-12 and Route 66.\n\nHe has also appeared in other television series, numerous films, radio dramas, a Broadway play, and even a radio fishing show. In addition, his appearance was the inspiration for Guy Gardner, the Green Lantern Corps superhero created in 1969 by John Broome and Gil Kane.\n\nDescription above from the Wikipedia article Martin Milner, licensed under CC-BY-SA,full list of contributors on Wikipedia. \n\n 	0	Detroit, Michigan, U.S.	Martin Milner
141067	1884-11-04	1982-11-18	Forbes Murray was born on November 4, 1884 in Hamilton, Ontario, Canada as Murray Forbes Barnard. He was an actor, known for A Chump at Oxford (1940), Ride, Tenderfoot, Ride (1940) and The Spider's Web (1938). He died on November 18, 1982 in Douglas County, Oregon, USA.	2	Hamilton, Ontario, Canada	Forbes Murray
380051	\N	\N		0		Thayer Roberts
1629431	\N	\N		0		Jack Cunningham
7123	1916-08-26	2002-12-17	From Wikipedia, the free encyclopedia\n\nFrederick Major Paull Knott (28 August 1916 — 17 December 2002) was an English playwright, best known for writing the London-based stage thriller Dial M for Murder, which was later filmed in Hollywood by Alfred Hitchcock.\n\nKnott was born in Hankow, China, to English missionaries. He was educated at Oundle School from 1929 to 1934 and later gained a law degree from Cambridge University. He served in the British Army from 1939 to 1946, rising to the rank of Major, and eventually moved to the United States.\n\nAlthough his most successful play, Dial M for Murder, was a hit on the stage, it was originally a BBC television production. As a theatre piece, it premiered at the Westminster Theatre in Victoria, London, in June 1952, directed by John Fernald and starring Alan MacNaughtan and Jane Baxter. This production was followed in October by a successful run in New York City at the Plymouth Theater, where Reginald Denham directed Richard Derr and Gusti Huber. Knott also wrote the screenplay for the 1954 Hollywood movie which Hitchcock filmed for Warner Brothers in 3D, starring Ray Milland and Grace Kelly, with Anthony Dawson and John Williams reprising their characters from the New York stage production, which had brought Williams a Tony Award for his role as Inspector Hubbard.\n\nIn 1960, Knott wrote the stage thriller Write Me a Murder, which was produced at the Belasco Theatre in New York in October 1961. It was directed by George Schaefer and included Denholm Elliott and Kim Hunter in the cast.\n\nIn 1966, Knott's stage play Wait Until Dark was produced on Broadway at the Ethel Barrymore Theatre. The Director was Arthur Penn and the play starred Lee Remick who won a Tony Award nomination for her performance. Later the same year, Honor Blackman played the lead in London's West End at the Strand Theatre. However, the movie version released in 1967 had Audrey Hepburn in the lead role.\n\nKnott died in New York City in 2002.\n\nDescription above from the Wikipedia article Frederick Knott, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hankow, China	Frederick Knott
4082	1894-05-10	1979-11-11		0		Dimitri Tiomkin
2654	1909-07-04	1968-05-13	From Wikipedia, the free encyclopedia\n\nRobert Burks, A.S.C. (July 4, 1909 – May 11, 1968) was an American cinematographer known for being proficient in virtually every genre and equally at home with black-and-white or color.\n\nBurks began his career as a special effects technician in the late 1930s before becoming a director of photography in the mid-1940s. His first credit in this field was Jammin' the Blues (1944), a short film featuring leading jazz musicians of the day.\n\nBurks collaborated with Alfred Hitchcock on twelve of the director's films. Beginning with Strangers on a Train in 1951 (which secured him an Oscar nomination) through Marnie in 1964, he shot every Hitchcock film except Psycho in 1960. Additional credits include The Fountainhead, Beyond the Forest, The Glass Menagerie, The Spirit of St. Louis, The Music Man, and A Patch of Blue.\n\nBurks and his wife died in a house fire in 1968 in Huntington Harbor, California.	2	Chino Hills - California - USA	Robert Burks
7126	\N	\N		0		Rudi Fehr
7127	1906-10-13	1984-12-19		0		Edward Carrere
4126	1896-03-23	1985-02-11		0		George James Hopkins
4313	1907-07-01	1975-07-21		0		Gordon Bau
7128	\N	\N		0		Oliver S. Garretson
1514138	\N	\N		0		Otis Malcolm
1533647	\N	\N		0		Robert G. Wayne
76160	\N	\N		2		Mel Dellar
1556114	\N	\N		0		Herbert Plews
7271	\N	\N		0		Sandra Jakisch
7272	\N	\N		0		Catrin Vogt
7275	1947-03-18	\N		0		Patrick Chesnais
3085	1940-03-26	\N	James Caan  (born March 26, 1940) is an American actor. He is best-known for his starring roles in The Godfather, Thief, Misery, A Bridge Too Far, Brian's Song, Rollerball, Kiss Me Goodbye, Elf, and El Dorado. He also starred as "Big Ed" Deline in the television series Las Vegas.	2	The Bronx, New York, USA	James Caan
105454	1888-06-13	1961-09-15		0		Harry Tyler
242238	1905-07-21	1952-06-15		0		William Pawley
115772	1915-10-22	1980-12-28		0		Charles Tannen
105810	1888-05-07	1971-03-30		2	Lake Mills, Iowa, USA	Selmer Jackson
30017	1874-10-03	1949-04-22		0		Charles Middleton
116494	1889-06-14	1977-08-20		0		Eddy Waller
7276	1963-05-25	\N	From Wikipedia, the free encyclopedia.  Anne Consigny (born May 25, 1963 in Alençon, Orne ) is a French film actress who is active since 1981. She received a César Awards nomination for Best Actress for her role in the film Je ne suis pas là pour être aimé (2005). She is also known for her role as Claude in the 2007 drama The Diving Bell and the Butterfly and as Elizabeth in the 2008 film A Christmas Tale, for which she was nominated the César Award for Best Supporting Actress.\n\nShe is the daughter of Pierre Consigny,  who was the head of cabinet for the Prime Minister Maurice Couve de Murville. She has five siblings. One of her brothers is the writer and publicist Thierry Consigny, author of "La Mort de Lara".  She has a son, Vladimir Consigny, who is also an actor with French film director Benoît Jacquot, born June 26, 1988.\n\nDescription above from the Wikipedia article Anne Consigny, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Alençon, Orne, France	Anne Consigny
7277	1921-10-16	2010-02-03		0	Champigny-sur-Marne, Seine, Paris, France	Georges Wilson
7278	1964-10-22	\N	Lionel Abelanski, né le 22 octobre 1964 à Paris, est un acteur français.\n\nÉlève au Cours Florent, Lionel Abelanski fait sa première apparition à l'écran en 1989 dans Romuald et Juliette, mais, à ses débuts, se consacre essentiellement au théâtre.\n\n   	0	Paris,France	Lionel Abelanski
7279	\N	\N		0		Cyril Couton
7280	1942-02-19	\N	From Wikipedia, the free encyclopedia\n\nGeneviève Mnich (born 19 February 1942), is a French actress. She has appeared in 80 films since 1972.\n\nShe was born in Cuffies, Aisne, France.\n\nDescription above from the Wikipedia article Geneviève Mnich, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Cuffies, Aisne, France	Geneviève Mnich
7281	\N	\N		0		Hélène Alexandridis
7282	\N	\N		0		Anne Benoît
7283	1959-03-03	\N		2	Melun, France	Olivier Claverie
7284	\N	\N		0		Marie-Sohna Conde
7285	\N	\N		0		Stéphan Wojtowicz
7286	\N	\N		0		Pedro Lombardi
7287	\N	\N		0		Isabelle Brochard
7288	1966-10-18	\N		2	Rennes, France	Stéphane Brizé
7289	\N	\N		0		Juliette Sales
7290	\N	\N		0		Miléna Poylo
5426	\N	\N		0		Gilles Sacuto
7291	\N	\N		0		Eduardo Makaroff
7292	\N	\N		0		Christoph H. Müller
7293	\N	\N		2		Claude Garnier
7294	\N	\N		0		Anne Klotz
7295	\N	\N		1		Brigitte Moidon
7450	1920-04-01	1997-12-24	Toshirō Mifune ( April 1, 1920 – December 24, 1997) was a Japanese actor who appeared in almost 170 feature films. He is best known for his 16-film collaboration with filmmaker Akira Kurosawa, from 1948 to 1965, in works such as Rashomon, Seven Samurai, Throne of Blood, and Yojimbo. He is also popular for portraying Musashi Miyamoto in Hiroshi Inagaki's Samurai Trilogy.\n\nDescription above from the Wikipedia article Toshirō Mifune, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Tsingtao, China	Toshirō Mifune
7451	1924-03-25	\N	From Wikipedia, the free encyclopedia\n\nMachiko Kyō (born March 25, 1924 in Osaka) is a Japanese actress whose film work occurred primarily during the 1950s. She rose to extraordinary domestic praise in Japan for her work in two of the greatest Japanese films of the 20th century, Akira Kurosawa's Rashōmon and Kenji Mizoguchi's Ugetsu.\n\nMachiko trained to be a dancer before entering films in 1949. The following year, she would achieve international fame as the female lead in Akira Kurosawa's classic film Rashōmon. She went on to star in many more Japanese productions, most notably Kenji Mizoguchi's Ugetsu (1953) and Kon Ichikawa's Odd Obsession (1959).\n\nHer only role in a non-Japanese film was as Lotus Blossom, a young geisha, in The Teahouse of the August Moon, starring opposite Marlon Brando and Glenn Ford.\n\nNow in her eighties, Kyō continues to perform in traditional Japanese theatrical productions put on by famed producer Fukuko Ishii. Kyō was nominated for a Golden Globe for The Teahouse of the August Moon, a great feat for an Asian actress at the time, and has been awarded many prizes, including a Lifetime Achievement Award from the Awards of the Japanese Academy.\n\nDescription above from the Wikipedia article Machiko Kyō, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Osaka, Japan	Machiko Kyô
7452	1911-01-13	1973-10-07	​From Wikipedia, the free encyclopedia.\n\nMasayuki Mori  (January 13, 1911 – October 7, 1973) Born in Sapporo, Hokkaido prefecture) was a Japanese actor, the son of Takeo Arishima, a Japanese novelist active during the late Meiji and Taishō periods. Mori appeared in many of Akira Kurosawa 's films such as Rashomon and The Idiot. He also starred in pictures by Kenji Mizoguchi (Ugetsu), Mikio Naruse (Floating Clouds) and other prominent directors.\n\nDescription above from the Wikipedia article Masayuki Mori, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Sapporo, Hokkaido, Japan	Masayuki Mori
7453	1905-03-12	1982-02-11	​From Wikipedia, the free encyclopedia.  \n\nTakashi Shimura ( March 12, 1905 – February 11, 1982) was a Japanese actor.\n\nDescription above from the Wikipedia article Takashi Shimura, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Ikuno, Hyogo, Japan	Takashi Shimura
7454	1917-07-30	1999-11-01	From Wikipedia, the free encyclopedia\n\nMinoru Chiaki (July 30, 1917 (some sources say April 28)–November 1, 1999) was a Japanese actor who appeared in such films as Akira Kurosawa's Seven Samurai and The Hidden Fortress.\n\nIn Seven Samurai he was the good-natured samurai Heihachi and he was the first of the samurai to be killed. Ironically, in real life he turned out to be the last of the seven actors to die.\n\nLater in his career he appeared as a secondary actor in many Toei films. In 1986 he was given the Best Actor prize at the Japan Academy Prize ceremony for his performance in Toei's Gray Sunset (1985).\n\nDescription above from the Wikipedia article Minoru Chiaki, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hokkaido, Japan (some sources say 28 April 1917)	Minoru Chiaki
7455	1904-03-30	1972-11-03	Kichijirô Ueda (上田 吉二郎), born Sadao Ueda (上田 定雄) was a Japanese actor.  He died of cancer in 1972.	2	Kobe, Hyōgo, Japan	Kichijirô Ueda
7456	\N	\N		0		Noriko Honma
7457	\N	\N		0		Daisuke Katô
1276	1959-12-29	\N	Patricia Davies Clarkson (born December 29, 1959) is an American actress. After studying drama on the East Coast, Clarkson launched her acting career in 1985, and has worked steadily in both film and television. She twice won the Emmy for Outstanding Guest Actress in Six Feet Under. Film roles included The Green Mile, Far From Heaven, The Station Agent and was nominated for an Academy Award for Best Supporting Actress for her perfromance in Pieces of April (2003). Description above from the Wikipedia article Patricia Clarkson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New Orleans, Louisiana, USA	Patricia Clarkson
104714	1902-07-14	1961-06-27		2	Jersey City, New Jersey, USA	Paul Guilfoyle
190772	\N	\N		0		David Hughes
89728	1889-06-10	1953-02-08		0	New York City, New York, USA	Cliff Clark
5026	1910-03-23	1998-09-06	​From Wikipedia, the free encyclopedia.  \n\nAkira Kurosawa ( March 23, 1910 – September 6, 1998) was a Japanese film director, producer, screenwriter and editor. Regarded as one of the most important and influential filmmakers in the history of cinema, Kurosawa directed 30 films in a career spanning 57 years. Kurosawa entered the Japanese film industry in 1936, following a brief stint as a painter. After years of working on numerous films as an assistant director and scriptwriter, he made his debut as a director in 1943, during World War II with the popular action film Sanshiro Sugata (a.k.a. Judo Saga). After the war, the critically acclaimed Drunken Angel (1948), in which Kurosawa cast then-unknown actor Toshirō Mifune in a starring role, cemented the director's reputation as one of the most important young filmmakers in Japan. The two men would go on to collaborate on another 15 films. Rashomon, which premiered in Tokyo in August 1950, and which also starred Mifune, became, on September 10, 1951, the surprise winner of the Golden Lion at the Venice Film Festival and was subsequently released in Europe and North America. The commercial and critical success of this film opened up Western film markets for the first time to the products of the Japanese film industry, which in turn led to international recognition for other Japanese film artists. Throughout the 1950s and early 1960s, Kurosawa directed approximately a film a year, including a number of highly regarded films such as Ikiru (1952), Seven Samurai (1954) and Yojimbo (1961). After the mid-1960s, he became much less prolific, but his later work—including his final two epics, Kagemusha (1980) and Ran (1985)—continued to win awards, including the Palme d'Or for Kagemusha, though more often abroad than in Japan. In 1990, he accepted the Academy Award for Lifetime Achievement.Posthumously, he was named "Asian of the Century" in the "Arts, Literature, and Culture" category by AsianWeek magazine and CNN, cited as "one of the [five] people who contributed most to the betterment of Asia in the past 100 years".\n\nDescription above from the Wikipedia article Akira Kurosawa , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Tokyo, Japan	Akira Kurosawa
7448	\N	\N		0		Ryunosuke Akutagawa
7449	1918-04-18	\N		0		Shinobu Hashimoto
7458	\N	\N		0		Minoru Jingo
7459	1906-01-21	1985-10-24		0		Masaichi Nagata
7460	1914-08-19	1955-10-15		0		Fumio Hayasaka
7461	1908-02-25	1999-08-07		2	Kyoto, Japan	Kazuo Miyagawa
7462	\N	\N		0		H. Motsumoto
1267600	\N	\N		0		Kenichi Okamoto
1513913	\N	\N		0		Takashi Matsuyama
239213	\N	\N		0		Tai Katô
83199	\N	\N		2	Osaka, Japan	Tokuzô Tanaka
1273295	\N	\N		0		Mitsuo Wakasugi
1578078	\N	\N		0		Tsuchitarô Hayashi
1111737	\N	\N		0		Iwao Ôtani
554162	1927-12-24	2014-06-11		2	Kyoto, Japan	Fujio Morita
1143488	\N	\N		0		Genken Nakaoka
143707	\N	\N		0		Teruyo Nogami
2954	1965-12-07	\N	Jeffrey Wright was born on December 7, 1965 in Washington, D.C. Jeff's father died when he was a year old, and he was raised by his mother, a lawyer, now retired from the U.S. Customs Department, and his aunt, a former nurse. Jeffrey is happily married to Carmen Ejogo, his co-star in Boycott, and they have a son.	2	Washington, D.C., USA	Jeffrey Wright
2227	1967-06-20	\N	Nicole Mary Kidman, AC (born 20 June 1967) is an American-born Australian actress, fashion model, singer and humanitarian.\n\nAfter starring in a number of small Australian films and TV shows, Kidman's breakthrough was in the 1989 thriller Dead Calm. Her performances in films such as To Die For (1995) and Moulin Rouge! (2001) received critical acclaim, and her performance in The Hours (2002) brought her the Academy Award for Best Actress, a BAFTA Award and a Golden Globe Award. Her other films include To Die For (1995), The Portrait of a Lady (1996), Eyes Wide Shut (1999), The Others (2001), Cold Mountain (2003), Birth (2004), The Interpreter (2005), Stoker (2013) and Paddington (2014).\n\nKidman has been a Goodwill Ambassador for UNICEF Australia since 1994. In 2003, Kidman received her star on the Walk of Fame. In 2006, Kidman was made a Companion of the Order of Australia, Australia's highest civilian honour, and was also the highest-paid actress in the motion picture industry.\n\nShe is also known for her marriage to Tom Cruise, to whom she was married for 11 years and adopted two children, and her current marriage to country musician Keith Urban, with whom she has two biological daughters.\n\nAs a result of being born to Australian parents in Hawaii, Kidman has dual citizenship in Australia and the United States.	1	Honolulu, Hawaii, U.S	Nicole Kidman
7569	1932-02-14	\N	From Wikipedia, the free encyclopedia.\n\nHarriet Andersson (born 14 February 1932, Stockholm) is a Swedish actress, known outside Sweden for being part of one of director Ingmar Bergman's stock company.\n\nShe often played impulsive working class characters and quickly established a reputation on screen for her youthful, unpretentious, full-lipped sensuality. She disdains the use of makeup.\n\nDescription above from the Wikipedia article Harriet Andersson, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Stockholm, Sweden	Harriet Andersson
7570	1924-09-16	2014-08-12	From Wikipedia, the free encyclopedia.\n\nLauren Bacall (born Betty Joan Perske; September 16, 1924 – August 12, 2014) was an American actress known for her distinctive husky voice and sultry looks. She began her career as a model. She first appeared as a leading lady in the Humphrey Bogart film To Have and Have Not (1944) and continued on in the film noir genre, with appearances in Bogart movies The Big Sleep (1946), Dark Passage (1947), and Key Largo (1948), as well as comedic roles in How to Marry a Millionaire (1953) with Marilyn Monroe and Designing Woman (1957) with Gregory Peck. Bacall worked on Broadway in musicals, earning Tony Awards for Applause in 1970 and Woman of the Year in 1981. Her performance in the movie The Mirror Has Two Faces (1996) earned her a Golden Globe Award and an Academy Award nomination.\n\nIn 1999, Bacall was ranked 20th out of the 25 actresses on the AFI's 100 Years...100 Stars list by the American Film Institute. In 2009, she was selected by the Academy of Motion Picture Arts and Sciences to receive an Academy Honorary Award "in recognition of her central place in the Golden Age of motion pictures."\n\nBacall died on August 12, 2014, at the age of 89. According to her grandson Jamie Bogart, the actress died after suffering from a stroke.	1	The Bronx, New York City, New York, USA	Lauren Bacall
6162	1971-05-27	\N	Paul Bettany was born into a theatre family. His father, Thane Bettany, is still an actor but his mother, Anne Kettle, has retired from acting. He has an older sister who is a writer and a mother. His maternal grandmother, Olga Gwynne (her maiden and stage name), was a successful actress, while his maternal grandfather, Lesley Kettle, was a musician and promoter. He was brought up in North West London and, after the age of 9, in Hertfordshire (Brookmans Park). Immediately after finishing at Drama Centre, he went into the West End to join the cast of "An Inspector Calls", though when asked to go on tour with this play, he chose to stay in England.	2	Harlesden, London, England, UK 	Paul Bettany
7571	1946-04-23	\N	From Wikipedia, the free encyclopedia.\n\nBonnie Blair Brown (born April 23, 1947) is an American theater, film, and television actress. She has had a number of high profile roles, including a Tony Award-winning turn in the play Copenhagen on Broadway, as well as a run as the title character in the television comedy-drama The Days and Nights of Molly Dodd, which ran from 1987 to 1991. Brown currently plays Nina Sharp in the television series Fringe, which is broadcast on Fox.\n\nDescription above from the Wikipedia article Blair Brown, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Washington, D.C.	Blair Brown
4654	1969-10-08	\N	Jeremy Davies (born October 8, 1969) is an American film and television actor. He is known for portraying the interpreter Cpl. Timothy E. Upham in the film Saving Private Ryan and the physicist Daniel Faraday on the television series Lost. He most recently appeared in the FX series, "Justified", as Dickie Bennett.\n\nDescription above from the Wikipedia Jeremy Davies, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Saugus, California, USA	Jeremy Davies
856	1930-08-28	2012-02-03	From Wikipedia, the free encyclopedia\n\nBiagio Anthony Gazzarra (August 28, 1930 – February 3, 2012), known as Ben Gazzara, was an American film, stage, and television actor and director. His best known films include Anatomy of a Murder (1959), Voyage of the Damned (1976), Inchon (1981), Road House (1989), The Big Lebowski (1998), Happiness (1998), The Thomas Crown Affair (1999), Summer of Sam (1999), Dogville (2003) and Paris, je t'aime (2006). He was a recurring collaborator with John Cassavetes, working with him on Husbands (1970), The Killing of a Chinese Bookie (1976) and Opening Night (1977).\n\nAs the star of the television series Run for Your Life (1965-1968), Gazzarra was nominated for three Golden Globe Awards and two Emmy Awards. He won his first, and only, Emmy Award for his role in the television film Hysterical Blindness (2002).\n\nDescription above from the Wikipedia article Ben Gazzara, licensed under CC-BY-SA, full list of contributors on Wikipedia.    	2	New York City, New York, USA	Ben Gazzara
7572	1957-03-03	\N	Thom Hoffman is a Dutch film and television actor. He also starred in several musicals.	0	Wassenaar, Zuid-Holland, Netherlands	Thom Hoffman
6751	1961-05-13	\N	​From Wikipedia, the free encyclopedia\n\nSiobhan Fallon (born May 13, 1961) is an American actress.\n\nDescription above from the Wikipedia article Siobhan Fallon Hogan, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Syracuse, New York, USA	Siobhan Fallon
6752	1957-08-15	\N	From Wikipedia, the free encyclopedia\n\nŽeljko Ivanek ([ˈʒeʎko iˈʋanək]; born 15 August 1957) is an Emmy award-winning Slovenian American actor. He currently stars as Blake Sterling on the NBC series The Event.	0	Ljubljana - Slovenia	Zeljko Ivanek
6758	\N	2015-01-13		2		John Randolph Jones
1646	1944-10-14	\N	From Wikipedia, the free encyclopedia\n\nUdo Kier (born Udo Kierspe; October 14, 1944) is a German actor, known primarily for his work in horror and exploitation movies.\n\nDescription above from the Wikipedia article Udo Kier, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Cologne, Germany	Udo Kier
7574	1962-08-21	\N	Cleo King is an actress.	0	St. Louis - Missouri - USA	Cleo King
7575	\N	\N		0		Miles Purinton
7576	\N	\N		0		Bill Raymond
2838	1974-11-18	\N	From Wikipedia, the free encyclopedia\n\nChloë Stevens Sevigny (born November 18, 1974) is an American film actress, fashion designer and former model. Sevigny became known for her broad fashion career in the mid-1990s, both for modeling and for her work at New York's Sassy magazine, which labeled her the new "it girl" at the time, garnering her attention within New York's fashion scene.\n\nSevigny made her film debut with a leading role in the controversial Larry Clark film Kids (1995), which led to an Independent Spirit Award nomination for her performance. A long line of roles in generally well-received independent and often avant-garde films throughout the decade established Sevigny's reputation as an indie film queen. It was not until 1999 that Sevigny gained serious critical and commercial recognition for her first mainstream role in Boys Don't Cry, for which she received Academy Award and Golden Globe nominations for Best Supporting Actress.\n\nSevigny has continued acting in mostly independent art house films, such as American Psycho (2000), Party Monster (2003), The Brown Bunny (2003) and Dogville (2003). In 2006, Sevigny gained a leading role in the HBO television series Big Love, for which she received a Golden Globe for Best Supporting Actress in 2010. Additionally, Sevigny has two Off-Broadway theatre credits, and has starred in several music videos. She has also designed several wardrobe collections, most recently with Manhattan's Opening Ceremony boutique.\n\nDescription above from the Wikipedia article Chloë Sevigny, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Springfield, Massachusetts USA	Chloë Sevigny
7577	\N	\N		0		Shauna Shim
1640	1951-06-13	\N	From Wikipedia, the free encyclopedia\n\nStellan John Skarsgård (born 13 June 1951) is a Swedish actor, known internationally for his film roles in Angels &amp; Demons, Breaking the Waves, The Hunt for Red October, Ronin, Good Will Hunting, Pirates of the Caribbean: Dead Man's Chest, Pirates of the Caribbean: At World's End, Dominion: Prequel to the Exorcist, Mamma Mia! and Thor.\n\nDescription above from the Wikipedia article Stellan Skarsgård, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Gothenburg, Västra Götalands län, Sweden	Stellan Skarsgård
7578	\N	\N		0		Evelina Brinkemo
7579	\N	\N		0		Anna Brobeck
7580	\N	\N		0		Tilde Lindgren
7581	\N	\N		0		Evelina Lundqvist
7582	\N	\N		0		Helga Olofsson
1480036	\N	\N		0		Jan Coster
135708	\N	\N		0		Ingvar Örner
1378316	\N	\N		0		Erich Silva
42	1956-04-30	\N	Lars von Trier ( born Lars Trier; 30 April 1956) is a Danish film director and screenwriter. He is closely associated with the Dogme 95 collective, although his own films have taken a variety of different approaches. He is known for his female-centric parables and his exploration of controversial subject matter.\n\nVon Trier began making his own films at the age of 11 after receiving a Super-8 camera as a gift, and his first publicly released film was an experimental short called The Orchid Gardener, in 1977. His first feature film came seven years later, The Element of Crime, in 1984. As of 2010, he has directed a further 10 feature films, 5 short films and 4 television productions.\n\nHe has been married twice and is currently married to Bente Frøge. Von Trier suffers periodically from depression, as well as various fears and phobias, including an intense fear of flying. As he himself once put it, "Basically, I'm afraid of everything in life, except filmmaking".\n\nDescription above from the Wikipedia article Lars von Trier, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Kongens Lyngby, Denmark	Lars von Trier
7583	1937-11-08	\N		0		Gillian Berrie
854	1908-05-20	1997-07-02	James Maitland "Jimmy" Stewart (May 20, 1908 – July 2, 1997) was an American film and stage actor, known for his distinctive voice and his everyman persona. Over the course of his career, he starred in many films widely considered classics and was nominated for five Academy Awards, winning one in competition and receiving one Lifetime Achievement award. He was a major MGM contract star. He also had a noted military career and was a World War II and Vietnam War veteran, who rose to the rank of Brigadier General in the United States Air Force Reserve.\n\nThroughout his seven decades in Hollywood, Stewart cultivated a versatile career and recognized screen image in such classics as Mr. Smith Goes to Washington, The Philadelphia Story, Harvey, It's a Wonderful Life, Shenandoah, Rear Window, Rope, The Man Who Knew Too Much, and Vertigo. He is the most represented leading actor on the AFI's 100 Years…100 Movies (10th Anniversary Edition) and AFI's 10 Top 10 lists. He is also the most represented leading actor on the 100 Greatest Movies of All Time list presented by Entertainment Weekly. As of 2007, ten of his films have been inducted into the United States National Film Registry.\n\nStewart left his mark on a wide range of film genres, including westerns, suspense thrillers, family films, biographies and screwball comedies. He worked for a number of renowned directors later in his career, most notably Alfred Hitchcock, John Ford, Billy Wilder, Frank Capra, George Cukor, and Anthony Mann. He won many of the industry's highest honors and earned Lifetime Achievement awards from every major film organization. He died at age 89, leaving behind a legacy of classic performances, and is considered one of the finest actors of the "Golden Age of Hollywood". He was named the third Greatest Male Star of All Time by the American Film Institute.\n\nDescription above from the Wikipedia article James Stewart, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Indiana, Pennsylvania, USA	James Stewart
975645	1919-09-16	1962-09-10	Uddannet på Det kgl. Teaters elevskole 1937-39, hvor han var ansat  indtil 1950. Herefter søgte han udfordringer på de københavnske  privatteatre og i udlandet, bortset fra en enkelt sæson, 1954-55, hvor  han vendte tilbage til Det kgl.\n\nHan døde i London, hvor han netop  stod overfor sin karrieres måske største udfordring - titelrollen i  Shakespeares "Købmanden i Venedig" på Old Vic.	0		Mogens Wieth
14015	1918-08-04	1988-12-24		0		Noel Willman
35591	1914-03-08	1993-11-16		2	Paris, France	Yves Brainville
118452	1901-01-06	1970-09-30		0	King's Norton, Worcestershire, England	Patrick Aherne
78902	1909-02-02	1964-02-29		2	Fergus Falls, Minnesota, USA	Frank Albertson
8237	1922-04-03	\N	From Wikipedia, the free encyclopedia\n\nDoris Day (born Doris Mary Ann Kappelhoff; April 3, 1924) is an American actress and singer, and an outspoken animal rights activist since her retirement from show business. Her entertainment career began in the 1940s as a big band singer. In 1945 she had her first hit recording, "Sentimental Journey". In 1948, she appeared in her first film, Romance on the High Seas. During her entertainment career, she appeared in 39 films, recorded more than 650 songs, received an Academy Award nomination, won a Golden Globe and a Grammy Award, and, in 1989, received the Cecil B. DeMille Award for lifetime achievement in motion pictures.\n\nAs of 2009, Day was the top-ranking female box office star of all time and ranked sixth among the top ten box office performers (male and female).\n\nDescription above from the Wikipedia article Doris Day, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Cincinnati, Ohio, USA	Doris Day
8238	1909-07-28	1981-03-05	From Wikipedia, the free encyclopedia\n\nBrenda D. M. De Banzie (28 July 1909 – 5 March 1981) was a British actress of stage and screen.\n\nShe was the daughter of Edward De Banzie and his second wife Dorothy, whom he married in 1908. In 1911, the family lived in Salford.\n\nShe appeared as Maggie Hobson in the David Lean film version of Hobson's Choice (1954) with John Mills and Charles Laughton. Her most notable film role was as Phoebe Rice, the hapless wife of comedian Archie Rice (played by Laurence Olivier), in the 1960 film version of The Entertainer. She had also appeared on Broadway in John Osborne's original play, for which she received a Tony Award nomination.\n\nOther memorable film roles were in The Man Who Knew Too Much (1956), directed by Alfred Hitchcock, and The Pink Panther (1963) directed by Blake Edwards.\n\nDescription above from the Wikipedia article Brenda De Banzie, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Manchester, England, UK	Brenda De Banzie
8239	1907-09-27	1991-06-14	From Wikipedia, the free encyclopedia\n\nBernard James Miles, Baron Miles, CBE (27 September 1907–14 June 1991) was an English character actor, writer and director. He opened the Mermaid Theatre in London in 1959, the first new theatre opened in the City of London since the 17th century.\n\nMiles was born in Uxbridge, Middlesex and attended Bishopshalt School in Hillingdon. While his parents were respectively a farm labourer and a cook, he was educated at Pembroke College, Oxford. He entered the theatre in the 1930s, soon appearing in films. Like many actors, he featured prominently in the patriotic cinema during the Second World War, including classics of the genre such as In Which We Serve and One of Our Aircraft Is Missing. He also had an uncredited role in the WWII classic The First of the Few, released in the US as Spitfire.\n\nHis typical persona as an actor was as a countryman, with a strong accent typical of the Hertfordshire and Buckinghamshire counties. He was also, after Robert Newton, the actor most associated with the part of Long John Silver, which he played in a British TV version of Treasure Island, and in an annual performance at the Mermaid commencing in the winter of 1961-62. Actors in the annual theatrical productions included Spike Milligan as Ben Gunn, and, in the 1968 production, Barry Humphries as Long John Silver. It was Miles who, impressed by the talent of John Antrobus originally commissioned him to write a play of some sort. This led to Antrobus collaborating with Milligan to produce a one-act play called The Bed Sitting Room, which was later adapted to a longer play, and staged by Miles at The Mermaid on 31 January 1963, with both critical and commercial success.\n\nHe had a pleasant rolling bass-baritone voice that worked well in theatre and film, as well as being much in demand for voice-overs. As a performer, he was most well known for a series of comic monologues, often given in a rural dialect. These were recorded and sold as record albums, which were quite popular. Some of his comic monologues are currently available on youtube.com.\n\nMiles was made a Commander of the British Empire (CBE) in 1953, was knighted in 1969, and was granted a life peerage as Baron Miles, of Blackfriars in the City of London in 1979. He was only the second British actor ever to be given a peerage (the first was Laurence Olivier).\n\nMiles's written works include "The British Theatre" (1947), "God's Brainwave" (1972), and "Favorite Tales from Shakespeare" (1972). In 1981, he co-authored the book Curtain Calls with J.C. Trewin.\n\nHe died in Yorkshire.\n\nHis daughters are the actress Sally Miles and the artist Bridget Miles. His son John Miles was a Grand Prix Driver in the late 1960s and early 1970s with the Lotus team.\n\nDescription above from the Wikipedia article Bernard Miles, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Uxbridge, Hillingdon, Middlesex, England, UK	Bernard Miles
8240	1896-08-18	1969-03-25	​From Wikipedia, the free encyclopedia\n\nAlan Mowbray MM, (18 August 1896 - 25 March 1969), was an English stage and film actor who found success in Hollywood. Born Alfred Ernest Allen in London, England, he served with distinction the British Army in World War I, being awarded the Military Medal for bravery. He began as a stage actor, making his way to the United States where he appeared in Broadway plays and toured the country as part of a theater troupe. As Alan Mowbray, he made his motion picture debut in 1931, going on to a career primarily as a character actor in more than 140 films including the sterling butler role in the comedy Merrily We Live, and playing the title role in the TV series The Adventures of Colonel Flack. During World War II, he made a memorable appearance as the Devil in the Hal Roach propaganda comedy The Devil with Hitler. He appeared in some two dozen guest roles on various television series. Mowbray was a founding member of the Screen Actors Guild, with outside interests that led to membership in Britain's Royal Geographic Society. He played the title role in the television series Colonel Humphrey Flack, which first appeared in 1953-1954 and then was revived in 1958-1959. In the 1954-1955 television season Mowbray played Mr. Swift, the drama coach of the character Mickey Mulligan, in NBC's short-lived situation comedy The Mickey Rooney Show: Hey, Mulligan. Mowbray died of a heart attack in 1969 in Hollywood and was interred in the Holy Cross Cemetery in Culver City, California.\n\nDescription above from the Wikipedia article Alan Mowbray, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	London, England	Alan Mowbray
8241	1914-09-08	1999-05-25	From Wikipedia, the free encyclopedia.\n\nHillary Brooke (September 8, 1914 – May 25, 1999) was an American film actress best known for her work in Abbott and Costello and Sherlock Holmes films. She also played Lou Costello's love interest in the first season of The Abbott and Costello Show.\n\nDescription above from the Wikipedia article Hillary Brooke, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Astoria, New York, USA	Hillary Brooke
8242	1946-09-19	\N		0		Christopher Olsen
24814	1921-05-19	2002-11-29	Ancien élève du lycée Institution Saint-Malo, Daniel Gélin était dans les mêmes classes que Jean Le Bot, professeur des universités et amateur de marine. Il monte à Paris où il suit les cours d'art dramatique de René Simon. Il entre ensuite auConservatoire national d'art dramatique et y rencontre Louis Jouvet. Il commence une carrière au théâtre et fait sa première apparition à l'écran en 1940. Il permet à Louis de Funès d'obtenir ses premiers rôles au cinéma (avec La Tentation de Barbizon de Jean Stelli en 1945), celui-ci, le considérant comme celui qui avait lancé la carrière, le surnomma par la suite« Ma chance ».  Dans les années 1950, il devient un jeune premier à la mode grâce à son jeu très moderne et son physique ténébreux.  En comédien passionné de poésie, Daniel Gélin donne deux recueils de poèmes : Fatras (1950) et Dérives (1965) ainsi qu'une anthologie de ses choix poétiques, qu'il intitule Poèmes à dire, et qui paraît aux éditions Seghers avec une préface chaleureuse de Jean Vilar.  Le vendredi 29 novembre 2002, il succombe à une insuffisance rénale. Il repose dans le cimetière de Rocabey à Saint-Maloen Ille-et-Vilaine.	0	Angers, Maine-et-Loire, France	Daniel Gélin
15972	1907-09-04	1991-11-19		0		Reggie Nalder
1045	1911-06-29	1975-12-24	From Wikipedia, the free encyclopedia\n\nBernard Herrmann (born Max Herman; June 29, 1911 – December 24, 1975) was an American composer best known for his work in composing for motion pictures. As a conductor, he championed the music of lesser-known composers.\n\nAn Academy Award-winner (for The Devil and Daniel Webster, 1941; later renamed All That Money Can Buy), Herrmann is particularly known for his collaborations with director Alfred Hitchcock, most famously Psycho, North by Northwest, The Man Who Knew Too Much, and Vertigo. He also composed scores for many other movies, including Citizen Kane, The Day the Earth Stood Still, The Ghost and Mrs. Muir, Cape Fear, and Taxi Driver. He worked extensively in radio drama (composing for Orson Welles), composed the scores for several fantasy films by Ray Harryhausen, and many TV programs, including Rod Serling's The Twilight Zone and Have Gun–Will Travel.	2	New York, New York City, U.S.	Bernard Herrmann
19109	1930-04-28	1983-08-03	From Wikipedia, the free encyclopedia\n\nCarolyn Sue Jones (April 28, 1930 – August 3, 1983) was an American actress.\n\nJones began her film career in the early 1950s, and by the end of the decade had achieved recognition with a nomination for an Academy Award for Best Supporting Actress for The Bachelor Party (1957) and a Golden Globe Award as one of the most promising actresses of 1959. Her film career continued for a few years, and in 1964 she began playing the role of Morticia Addams in the television series The Addams Family, receiving a Golden Globe Award nomination for her work.\n\nDescription above from the Wikipedia article Carolyn Jones, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Amarillo, Texas, U.S.	Carolyn Jones
236479	1919-06-07	1992-04-07		0		Alix Talton
85935	1912-02-25	1975-02-01		0		Richard Wattis
89064	1900-05-07	1977-10-15		0		Ralph Truman
1580608	\N	\N		0		Frank Atkinson
1567845	\N	\N		0		John Barrard
1063842	1885-05-04	1965-05-20		0		Mayne Lynton
4958	1905-05-16	1982-08-12	Born in Grand Island, Nebraska, Henry Fonda started his acting debut with the Omaha Community Playhouse, a local amateur theater troupe directed by Dorothy Brando. He moved to the Cape Cod University Players and later Broadway, New York to expand his theatrical career from 1926 to 1934. His first major roles in Broadway include "New Faces of America" and "The Farmer Takes a Wife". The latter play was transfered to the screen in 1935 and became the start-up of Fonda's lifelong Hollywood career. The following year he married Frances Seymour Fonda with whom he had two children: Jane and Peter Fonda also to become screen stars. He is most remembered for his roles as Abe Lincoln in Young Mr. Lincoln (1939), Tom Joad in The Grapes of Wrath (1940), for which he received an Academy Award Nomination, and more recently, Norman Thayer in On Golden Pond (1981), for which he received an Academy Award for Best Actor in 1982. Henry Fonda is considered one of Hollywood's old-time legends and was friend and contemporary of James Stewart, John Ford and Joshua Logan. His movie career which spanned almost 50 years is completed by a notable presence in American theater and television.	2	Grand Island, Nebraska, USA	Henry Fonda
8515	1879-10-15	1967-08-13	From Wikipedia, the free encyclopedia\n\nJane Darwell (October 15, 1879 – August 13, 1967) was an American film and stage actress. With appearances in over 100 major motion pictures, Darwell is perhaps best-remembered for her portrayal of the matriarch and leader of the Joad family in the film adaptation of The Grapes of Wrath, for which she received the Academy Award for Best Supporting Actress, and her role as the Bird Woman in Mary Poppins.\n\nDescription above from the Wikipedia article Jane Darwell, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Palmyra, Missouri, USA	Jane Darwell
8516	1906-02-05	1988-11-27	From Wikipedia, the free encyclopedia\n\nJohn Carradine (born Richmond Reed Carradine; February 5, 1906 – November 27, 1988) was an American actor, best known for his roles in horror films and Westerns as well as Shakespearean theater. He was one of the most prolific character actors in Hollywood history and the patriarch of an acting dynasty that includes four of his sons and four of his grandchildren.\n\nDescription above from the Wikipedia article John Carradine, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	John Carradine
8517	1869-12-20	1956-02-02	From Wikipedia, the free encyclopedia\n\nCharley Ellsworth Grapewin (December 20, 1869 – February 2, 1956) was an American vaudeville performer and a stage and film actor, who portrayed Uncle Henry in The Wizard of Oz (1939) and Grandpa Joad in the film The Grapes of Wrath (1940).\n\nDescription above from the Wikipedia article Charles Grapewin, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	Xenia, Ohio, USA	Charley Grapewin
8518	1914-12-27	2005-08-09		0		Dorris Bowdon
8519	1880-06-17	1959-12-12		0		Russell Simpson
8520	1911-03-01	1998-07-29	American character actor of rather bizarre range, a member of the so-called 'John Ford Stock Company.' Originally a New York stage actor of some repute, Whitehead entered films in the 1930s. He played a wide variety of character parts, often quite different from his own actual age and type. He is probably most familiar as Al Joad in John Ford's The Grapes of Wrath (1940). But twenty-two years later, in his fifth film for Ford, The Man Who Shot Liberty Valance (1962), Whitehead at 51 was playing a lollipop-licking schoolboy! He continued to work predominantly on the stage, appearing now and again in films or on television. In his last years, he suffered from cancer and died in 1998 in Dublin, Ireland, where he had lived in semi-retirement for many years.	2	New York City, New York,	O.Z. Whitehead
4119	1899-12-08	1987-09-12		0		John Qualen
8521	1907-03-31	1990-07-19		0		Eddie Quillan
8522	1863-11-20	1950-07-24		0	London, England, UK	Zeffie Tilbury
34610	1908-06-17	1975-12-17	Francis Thomas Sullivan, aka Frank Sully, was born on June 17, 1908 in St. Louis, Missouri, USA. He was an actor, known for The Grapes of Wrath (1940), The More the Merrier (1943) and Bye Bye Birdie (1963). He died on December 17, 1975 in Woodland Hills, Los Angeles, California, USA.\n\nBeefy, square-jawed American character actor, usually cast as rustic types or dumb heavies. Also a regular feature in Three Stooges shorts. Sully started his career as a comedian in vaudeville and appeared on Broadway from the late 1920s.	0	St. Louis, Missouri.	Frank Sully
116661	1876-03-18	1955-10-20		0		Frank Darien
81481	1931-07-28	\N		0		Darryl Hickman
567800	1926-04-28	2010-03-21	Shirley Olivia Mills was born in Tacoma, Washington in 1926 and moved to southern California while still a child. She  became the star of an independent movie which achieved great fame  titled Child Bride (1938)when she was 12 years old which she describes  in detail on her "official" website on a separate page devoted to  memories of that movie along with still photos of it. Other pages on the  site are devoted to The Grapes Of Wrath (1940) and also Nine Girls  (1944), additional movies where she was a movie actress in featured  roles. Mills appeared in major Hollywood studio movies through the 1940s and  into the 1950s, during which decade she also appeared on major network  television programs.\n\nDate of Birth  8 April  1926, Tacoma, Washington\n\nDate of Death  31 March  2010, Arcadia, California   (complications of pneumonia)	0		Shirley Mills
112364	1875-08-15	1958-04-15		0		Roger Imhof
30215	1874-06-17	1957-05-01	You would think stage and film veteran Grant Mitchell was born to play stern authoritarians; his father after all was General John Grant Mitchell. But Mitchell would actually be better known for his portrayals of harangued husbands, bemused dads and bilious executives in 30s and 40s films. Born June 17, 1874, in Columbus, Ohio, and a Yale post graduate at Harvard Law, Mitchell gave up his law practice to become an actor and made his stage debut at age 27. He appeared in many leads on Broadway in such plays as "It Pays to Advertise," "The Champion," "The Whole Town's Talking," and "The Baby Cyclone," the last of which was specially written for him by George M. Cohan. Mitchell's screen career officially got off the ground with the advent of sound, though he did show up in a couple of silents. The beefy, balding actor appeared primarily in "B" films, and actually had a rare lead in the totally forgotten Father Is a Prince (1940). From time to time, however, he enjoyed being a part of "A" quality classic films such as Mr. Smith Goes to Washington (1939), The Man Who Came to Dinner (1942), Laura (1944), and Arsenic and Old Lace (1944). Unmarried, he died at age 82 on May 1, 1957, in Los Angeles, California, USA  (cerebral thrombosis)	0	Columbus, OH	Grant Mitchell
13977	1887-07-01	1948-11-25	Born in Council Bluffs, Iowa, Brown wrote and directed a single short film in 1914. As an actor, he appeared in more than 100 films, stretching from 1921 through his death in 1948. His parallel career on the Broadway stage spanned 1911 through 1937.	0		Charles D. Brown
101881	1906-03-12	1947-05-15		0		John Arledge
4303	1903-04-09	1960-11-05	​From Wikipedia, the free encyclopedia\n\nWardell Edwin "Ward" Bond (April 9, 1903 – November 5, 1960) was an American film actor whose rugged appearance and easygoing charm featured in numerous roles.\n\nDescription above from the Wikipedia article Ward Bond, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Benkelman, Nebraska, U.S.	Ward Bond
3341	1906-08-29	1982-04-21	Joe Sawyer's familiar mug appeared everywhere during the 1930s and 1940s, particularly as a stock player for Warner Bros. in its more standard college musicals, comedies and crime yarns. He could play both sides of the fence, street cops and mob gunmen, with equal ease. He was born Joseph Sauers in Guelph, Canada, on August 29, 1906, and eventually moved to California to pursue a film career. Trained at the Pasadena Playhouse, he had a perfect "tough guy" look: sturdy build, jutting chin and beady eyes, made more distinctive by his shock of light hair and a slightly high-pitched voice. Sawyer made his film debut in 1931 under his real name, which, contrary to popular opinion, was German and not Irish, though he made a career out of playing Irishmen, and appeared mostly in strongarm bit parts in his early career until hitting his stride playing a variety of coaches, cops and sidekicks with imposing names like "Spud," "Slug" and "Whitey." He appeared in hundreds of films, in just about every genre, over a four-decade-long career, among them College Humor (1933), College Rhythm (1934), The Westerner (1934), The Informer (1935), in which his portrayal of an IRA gunman got him noticed by the public and critics alike, Pride of the Marines (1936), Black Legion (1937), The Petrified Forest (1936) (another "tough-guy" role that got him good reviews), The Grapes of Wrath (1940), They Died with Their Boots On (1941), Sergeant York (1941), Tarzan's Desert Mystery (1943), Gilda (1946), It Came from Outer Space (1953), North to Alaska (1960) and How the West Was Won (1962). He also guest-starred on many TV series and was a regular on "The Adventures of Rin Tin Tin" (1954) as Sgt. Aloysius "Biff" O'Hara. His first wife was actress Jeane Wood, the daughter of Gone with the Wind (1939) uncredited director Sam Wood. His second wife, June, died in 1960. Sawyer died in Ashland, Oregon, on April 21, 1982 of liver cancer at the age of 75.	0		Joe Sawyer
17759	1905-12-08	1985-08-02	From Wikipedia, the free encyclopedia.\n\nFrank Faylen (December 8, 1905 – August 2, 1985) was an American movie and television actor.\n\nBorn Frank Ruf in St. Louis, Missouri, he began his acting career as an infant appearing with his vaudeville performing parents on stage. After traveling with his showbiz parents through his childhood, Faylen became a stage actor at 18, and eventually began working in movies in the 1930s. He began playing a number of unmemorable bit parts for Warner Brothers, then freelanced for other studios in gradually larger character roles. He appears as Walt Disney's musical conductor in The Reluctant Dragon, and as a stern railroad official in the Laurel and Hardy comedy A-Haunting We Will Go. Faylen and L &amp; H supporting player Charlie Hall were teamed briefly by Monogram Pictures.\n\nFaylen's breakthrough came in 1945, where he was cast as Bim, the cynical male nurse at Bellevue's alcoholic ward in The Lost Weekend. He played Ernie Bishop, the friendly taxi driver in Frank Capra's 1946 film It's a Wonderful Life. Faylen's career also stretched to television, playing long-suffering grocer Herbert T. Gillis on the 1950s television sitcom The Many Loves of Dobie Gillis. In 1968 he had a small part in the Barbra Streisand film Funny Girl. Faylen appeared in almost 200 films. He has a star on the Hollywood Walk of Fame, but not on the St. Louis Walk of Fame.\n\nDescription above from the Wikipedia article Frank Faylen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	St. Louis, Missouri, U.S.	Frank Faylen
102071	\N	\N		0		Adrian Morris
567801	1923-10-26	2006-06-10		0		Hollis Jewell
95311	1877-11-08	1947-07-28		0		Robert Homans
30530	1893-09-06	1965-02-05	A minor character actor who appeared in literally hundreds of films,  actor Irving Bacon could always be counted on for expressing bug-eyed  bewilderment or cautious frustration in small-town settings with his  revolving door of friendly, servile parts - mailmen, milkmen, clerks,  chauffeurs, cabbies, bartenders, soda jerks, carnival operators,  handymen and docs. Born September 6, 1893 in the heart of the Midwest  (St. Joseph, Missouri), he was the son of Millar and Myrtle (Vane)  Bacon. Irving first found work in silent comedy shorts at Keystone  Studios usually playing older than he was and, for a time, was a utility  player for Mack Sennett in such slapstick as A Favorite Fool (1915). His director brother also began using him in his own silent funnies starting with Good Morning, Nurse (1925), which was written by Frank Capra, Hurry, Doctor! (1925) and Wide Open Faces (1926).\n\nIrving made an easy adjustment when sound entered the pictures and after appearing in the Karl Dane / George K. Arthur one- and two-reelers such as Knights Before Christmas (1930), began to show up in feature-length films. He played higher-ups on occasion, such as the Secretary of the Navy in Million Dollar Legs (1932), police inspector in House of Mystery (1934), mayor in Room for One More (1952), and judge in Ambush at Cimarron Pass  (1958), but those were exceptions to the rule. Blending in with the  town crowd was what Irving was accustomed to and, over the years, he  would be glimpsed in some of Hollywood's most beloved classics such as  Capra's Mr. Deeds Goes to Town (1936), San Francisco (1936), You Can't Take It with You (1938) and A Star Is Born (1954). Trivia nuts will fondly recall his beleaguered postman in the Blondie (1938) film series that ran over a decade.\n\nIrving could also be spotted on popular '50s and '60s TV programs such as the westerns Laramie (1959) and Wagon Train (1957), and "comedies December Bride (1954) and The Real McCoys (1957). He can still be seen in a couple of old codger roles on I Love Lucy (1951). One was as a marriage license proprietor and the other as Vivian Vance's  doting dad from Albuquerque, to whom she paid a visit on her way to  Hollywood with the Ricardos. Irving died on February 5, 1965, having  clocked in over 400 features.	0	Saint Joseph, Missouri, USA	Irving Bacon
148524	1902-10-03	1954-09-03	Sister of Frank McHugh, Matt McHugh, James McHugh, Nora McHugh.	0		Kitty McHugh
8783	1968-08-09	\N	Eric Bana is an Australian film and television actor. He began his career as a comedian in the sketch comedy series Full Frontal before gaining critical recognition in the biopic Chopper (2000). After a decade of roles in Australian TV shows and films, Bana gained Hollywood's attention by playing the role of American Delta Force Sergeant Norm "Hoot" Hooten in Black Hawk Down (2001), the lead role as Bruce Banner in the Ang Lee directed film Hulk (2003), Prince Hector in the movie Troy (2004), the lead in Steven Spielberg's Munich (2005), and the villain Nero in the science-fiction film Star Trek (2009).\n\nAn accomplished dramatic actor and comedian, he received Australia's highest film and television awards for his performances in Chopper, Full Frontal and Romulus, My Father. Bana performs predominantly in leading roles in a variety of low-budget and major studio films, ranging from romantic comedies and drama to science fiction and action thrillers.\n\nEric Bana was the younger of two children; he has a brother, Anthony. He is of Croatian ancestry on his father's side. Bana's paternal grandfather, Mate Banadinović, fled to Argentina after the Second World War, and Bana's paternal grandmother emigrated to Germany and then to Australia in the 1950s with her son, Ivan (Bana's father). His father was a logistics manager for Caterpillar, Inc., and his German-born mother, Eleanor, was a hairdresser. Bana grew up in Melbourne's Tullamarine, a suburban area on the western edge of the city, near the main airport. In a cover story for The Mail on Sunday, he told author Antonella Gambotto-Burke that his family had suffered from racist taunts, and that it had distressed him. "Wog is such a terrible word," he said. He has stated: "I have always been proud of my origin, which had a big influence on my upbringing. I have always been in the company of people of European origin".\n\nShowing acting skill early in life, Bana began doing impressions of family members at the age of six or seven, first mimicking his grandfather's walk, voice and mannerisms. In school, he mimicked his teachers as a means to get out of trouble. As a teen, he watched the Mel Gibson film Mad Max (1979), and decided he wanted to become an actor. However, he did not seriously consider a career in the performing arts until 1991 when he was persuaded to try stand-up comedy while working as a barman at Melbourne's Castle Hotel. His stand-up gigs in inner-city pubs did not provide him with enough income to support himself, so he continued his work as a barman and bussing tables.	2	Melbourne, Australia	Eric Bana
8784	1968-03-02	\N	Daniel Wroughton Craig is an English actor, best known for playing British secret agent James Bond since 2006. Craig is an alumnus of the National Youth Theatre and graduated from the Guildhall School of Music and Drama in London and began his career on stage. His early on screen appearances were in the films Elizabeth, The Power of One and A Kid in King Arthur's Court, and on Sharpe's Eagle and Zorro in television. His appearances in the British films Love Is the Devil, The Trench and Some Voices attracted the industry's attention, leading to roles in bigger productions such as Lara Croft: Tomb Raider, Road to Perdition, Layer Cake and Munich.	2	Chester, Cheshire, England, UK	Daniel Craig
8785	1953-02-09	\N	Ciaran Hinds was born in Belfast, Northern Ireland on February 9, 1953. He was one of five children and the only son. His father was a doctor who hoped to have Ciaran follow in his footsteps, but that was not to be. It was his mother Moya, an amateur actress, who was the real influence behind his decision to become an actor. Though he did enroll in Law at Queens' University of Belfast, he left that in order to train in acting at RADA. He began his stage career at the Glasgow Citizens' Theatre as a pantomime horse in the production of "Cinderella". Staying with the company for several years, he starred in a number of productions, including playing the lead roles in "Arsenic and Old Lace" and "Faust". His stage career has included working with The Field Day Company and a number of world tours. He has starred in a number of productions with the Royal Shakespeare Company, including a world tour in the title role of "Richard III". Hinds' film career began in 1981 in the movie Excalibur (1981), which boasted a cast rich in talented actors including Liam Neeson, Gabriel Byrne and Patrick Stewart. In-between his movie work, he's amassed a large number of television credits. Playing such classic characters as "Mr. Rochester" in Jane Eyre (1997) (TV), and "Captain Wentworth" in Persuasion (1995) has increased his popularity and most definitely given him much increased recognition. As for his personal life, you won't be likely to see his name in the weekly tabloids. He likes to keep his private life private. It is known that he is in a long-term, committed relationship with a French-Vietnamese actress named Hélène Patarot and they have a daughter together and live in Paris. He is in very high demand and his reputation as a quality, professional actor is sure to keep him busy for as long as he chooses. IMDb Mini Biography By: Sheryl Reeder	2	Belfast, Northern Ireland, UK	Ciarán Hinds
2406	1967-08-03	\N	From Wikipedia, the free encyclopedia.\n\nMathieu Kassovitz (born 3 August 1967) is a French director, screenwriter, producer and actor, best known for his Cannes-winning drama La Haine. Kassovitz is also the founder of MNP Entreprise, a film production company.\n\nDescription above from the Wikipedia article Mathieu Kassovitz, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Paris, France	Mathieu Kassovitz
169	1947-06-18	\N	From Wikipedia, the free encyclopedia.\n\nHanns Zischler (born 18 June 1947) is a German actor most famous in America for his portrayal of Hans in Steven Spielberg's film Munich. According to the Internet Movie Database, Zischler has appeared in 171 movies since 1968.\n\nKnown in Sweden for his role as Josef Hillman in the second season of the Martin Beck movies, though his voice is dubbed.\n\nHe is sometimes credited as Hans Zischler, Johann Zischler, or Zischler.\n\nDescription above from the Wikipedia article Hanns Zischler, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Nürnberg-Germany	Hanns Zischler
3769	1935-08-05	\N		2	Berlin, Germany	Michael Ballhaus
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
2369	1931-05-24	\N	​From Wikipedia, the free encyclopedia.  \n\nMichael Lonsdale (born May 24, 1931), sometimes billed as Michel Lonsdale, is a French actor who has appeared in over 180 films and television shows.\n\nLonsdale was raised by an Irish mother and an English father, initially in London and on Jersey, and later during the Second World War in Casablanca, Morocco. He moved to Paris to study painting in 1947 but was drawn in to the world of acting instead, first appearing on stage at the age of 24.\n\nLonsdale is bilingual and is in demand for English-language and French productions. He is best known in the English-speaking world for his roles as the villainous Sir Hugo Drax in the 1979 James Bond film, Moonraker, the astute French detective Lebel in The Day of the Jackal, and M Dupont d'Ivry in The Remains of the Day.\n\nOn 25 February 2011, he won a Caesar award, his first, as a best supporting actor in Of Gods and Men.\n\nDescription above from the Wikipedia article Michael Lonsdale, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Paris, France	Michael Lonsdale
41316	\N	\N		0	Giv'atayim, Israel	Igal Naor
1031561	\N	\N		0		Lucky Englander
1312252	\N	\N		0		Fritz Fleischhacker
474	\N	\N		0		Jina Jay
488	1946-12-18	\N	Steven Allan Spielberg (born December 18, 1946) is an American film director, screenwriter, producer, and studio entrepreneur.\n\nIn a career of more than four decades, Spielberg's films have covered many themes and genres. Spielberg's early science-fiction and adventure films were seen as archetypes of modern Hollywood blockbuster filmmaking. In later years, his films began addressing issues such as the Holocaust, the Transatlantic slave trade, war, and terrorism. He is considered one of the most popular and influential filmmakers in the history of cinema. He is also one of the co-founders of DreamWorks movie studio.\n\nSpielberg won the Academy Award for Best Director for Schindler's List (1993) and Saving Private Ryan (1998). Three of Spielberg's films—Jaws (1975), E.T. the Extra-Terrestrial (1982), and Jurassic Park (1993)—achieved box office records, each becoming the highest-grossing film made at the time. To date, the unadjusted gross of all Spielberg-directed films exceeds $8.5 billion worldwide. Forbes puts Spielberg's wealth at $3.2 billion.	2	Cincinnati - Ohio - USA	Steven Spielberg
489	1953-06-05	\N		0	Berkeley, California, USA	Kathleen Kennedy
5664	\N	\N		0		Barry Mendel
8780	1956-07-16	\N	Tony Kushner is a Jewish American playwright and screenwriter.  His best known work is the 1993 Pulitzer Prize winning play Angels in America, which was later adapted into an Emmy Winning HBO series of the same name.  	0	 New York City, New York	Tony Kushner
491	\N	\N		0		John Williams
492	1959-06-27	\N		0		Janusz Kaminski
493	\N	\N		0		Michael Kahn
496	\N	\N		0		Rick Carter
8794	\N	\N		0		Tony Fanning
8795	\N	\N		0		Anne Seibel
498	\N	\N		0		Joanna Johnston
670	1948-07-12	\N	From Wikipedia, the free encyclopedia.  Benjamin "Ben" Burtt, Jr. (born July 12, 1948) is an American sound designer for the films Star Wars (1977), Invasion of the Body Snatchers (1978), Raiders of the Lost Ark (1981), E.T. the Extra-Terrestrial (1982), Indiana Jones and the Last Crusade (1989) and WALL-E (2008). He is also a film editor and director, screenwriter, and voice actor.  He is most notable for creating many of the iconic sound effects heard in the Star Wars film franchise, including the "voice" of R2-D2, the lightsaber hum and the heavy-breathing sound of Darth Vader.  Description above from the Wikipedia article Ben Burtt, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York, USA	Ben Burtt
9045	1966-05-12	\N	​From Wikipedia, the free encyclopedia.  \n\nStephen Andrew Baldwin (born May 12, 1966) is an American actor, director, producer and author. He is best known as the youngest of the Baldwin brothers and for his roles as William F. Cody in the western show The Young Riders (1989–1992) and as Stuart in the movie Threesome (1994). Other notable films Baldwin starred in were Posse (1993), 8 Seconds (1994), The Usual Suspects (1995), Fall Time (1995), Bio-Dome (1996), Fled (1996), One Tough Cop (1998), The Flintstones in Viva Rock Vegas (2000), The Harpy (2007), and The Flyboys (2008). He is also well known for his public display of evangelical Christian ideology as well as for his recent appearances on numerous reality television shows.\n\nDescription above from the Wikipedia article Stephen Baldwin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Massapequa, Long Island, New York, USA	Stephen Baldwin
5168	1950-05-12	\N	​From Wikipedia, the free encyclopedia.    Gabriel James Byrne (born May 12, 1950) is an Irish actor, film director, film producer, writer, cultural ambassador and audiobook narrator. His acting career began in the Focus Theatre before he joined London’s Royal Court Theatre in 1979. Byrne's screen début came in the Irish soap opera The Riordans and the spin-off show Bracken. The actor has now starred in over 35 feature films, such as The Usual Suspects, Miller's Crossing and Stigmata, in addition to writing two. Byrne's producing credits include the Academy Award-nominated In the Name of the Father. Currently, he is receiving much critical acclaim for his role as Dr. Paul Weston in the HBO drama In Treatment.  Description above from the Wikipedia article Gabriel Byrne, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	 Dublin, Ireland	Gabriel Byrne
9046	1952-05-15	\N	​From Wikipedia, the free encyclopedia.  \n\nCalogero Lorenzo "Chazz" Palminteri (born May 15, 1952) is an American actor and writer, best known for his performances in The Usual Suspects, A Bronx Tale, Mulholland Falls and his Academy Award nominated role for Best Supporting Actor in Bullets Over Broadway.	2	The Bronx, New York, USA	Chazz Palminteri
7166	1957-10-30	\N	Kevin Elliot Pollak (born October 30, 1957) is an American actor, impressionist, game show host, and comedian. He started performing stand-up comedy at the age of 10 and touring professionally at the age of 20. In 1988, Pollak landed a role in George Lucas’ Willow, directed by Ron Howard, and began his acting career.	2	San Francisco, California, USA	Kevin Pollak
4935	1945-02-07	2011-01-02	Peter William "Pete" Postlethwaite, OBE ( 7 February 1946 – 2 January 2011), was an English stage, film and television actor.\n\nAfter minor television appearances including in The Professionals, Postlethwaite's first success came with the film Distant Voices, Still Lives in 1988. He played a mysterious lawyer, Mr. Kobayashi, in The Usual Suspects, and he appeared in Alien 3, In the Name of the Father, Amistad, Brassed Off, The Shipping News, The Constant Gardener, The Age of Stupid, Inception, The Town, Romeo + Juliet, and Æon Flux. In television, Postlethwaite's most notable performance was as the villain Sergeant Obadiah Hakeswill in the Sharpe television series and television movies opposite actor Sean Bean's character of Richard Sharpe.\n\nPostlethwaite was born in Warrington, England in 1946. He trained as a teacher and taught drama before training as an actor. Steven Spielberg called Postlethwaite "the best actor in the world" after working with him on The Lost World: Jurassic Park. He received an Academy Award nomination for his role in In the Name of the Father in 1993, and was made an Officer of the Order of the British Empire in the 2004 New Year's Honours List. He died of pancreatic cancer on 2 January 2011.\n\nDescription above from the Wikipedia article Pete Postlethwaite, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Warrington, UK	Pete Postlethwaite
1979	1959-07-26	\N	Kevin Spacey Fowler (born July 26, 1959), better known by his stage name Kevin Spacey, is an American actor of screen and stage, film director, producer, screenwriter and singer who has resided in the United Kingdom since 2003. He began his career as a stage actor during the 1980s before obtaining supporting roles in film and television. He gained critical acclaim in the early 1990s that culminated in his first Academy Award for Best Supporting Actor for the neo-noir crime thriller The Usual Suspects (1995), and an Academy Award for Best Actor for midlife crisis-themed drama American Beauty (1999).\n\nHis other starring roles have included the comedy-drama film Swimming with Sharks (1994), psychological thriller Seven (1995), the neo-noir crime film L.A. Confidential (1997), the drama Pay It Forward (2000), the science fiction-mystery film K-PAX (2001), and the role of Lex Luthor in the superhero film Superman Returns (2006).\n\nDescription above from the Wikipedia article Kevin Spacey, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	South Orange, New Jersey, USA	Kevin Spacey
2179	1962-01-05	\N	From Wikipedia, the free encyclopedia.\n\nSusan Elizabeth "Suzy" Amis (born January 5, 1962) is an American former film actress and former model.\n\nDescription above from the Wikipedia article Suzy Amis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Oklahoma City, Oklahoma, USA	Suzy Amis
4808	1958-04-26	\N	Giancarlo Giuseppe Alessandro Esposito  (born April 26, 1958) is an American film and television actor and director.\n\nDescription above from the Wikipedia article Giancarlo Esposito, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Copenhagen, Denmark	Giancarlo Esposito
1121	1967-02-19	\N	Benicio Monserrate Rafael del Toro Sánchez (born February 19, 1967) is a Puerto Rican actor and film producer. His awards include the Academy Award, Golden Globe, Screen Actors Guild (SAG) Award and British Academy of Film and Television Arts (BAFTA) Award. He is known for his roles as Fred Fenster in The Usual Suspects, Javier Rodríguez in Traffic (his Oscar-winning role), Jack 'Jackie Boy' Rafferty in Sin City, Dr. Gonzo in Fear and Loathing in Las Vegas, Franky Four Fingers in Snatch, and Che Guevara in Che. He is the third Puerto Rican to win an Academy Award.\n\nDescription above from the Wikipedia article Benicio del Toro, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Santurce, Puerto Rico	Benicio del Toro
6486	1940-07-24	\N	From Wikipedia, the free encyclopedia\n\nDan Hedaya (born July 24, 1940) is an American character actor. He often plays sleazy villains or uptight, wisecracking individuals; two of his best-known roles are as a cuckolded husband in the Coen brothers' crime thriller Blood Simple, and the scheming Nick Tortelli on the sitcom Cheers.	0	Brooklyn - New York - USA	Dan Hedaya
101377	1938-08-06	2000-05-13	From Wikipedia, the free encyclopedia  Paul Bartel (August 6, 1938 – May 13, 2000) was an American actor, writer and director. Bartel was perhaps most known for his 1982 hit black comedy Eating Raoul, which he wrote, starred in and directed.  Description above from the Wikipedia article Paul Bartel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, USA	Paul Bartel
56166	\N	\N		0		Carl Bressler
9047	1952-09-13	\N		1		Christine Estabrook
156227	\N	\N		0		Morgan Hunter
3218	\N	\N		0		Louis Lombardi
1216752	1954-04-09	\N		0		Frank Medrano
1235937	\N	\N		0	New York, New York City, USA	Ron Gilbert
9032	1965-09-17	\N	Bryan Singer (born September 17, 1965) is an American film director and film producer. Singer won critical acclaim for his work on The Usual Suspects, and is especially well-known among fans of the science fiction and comic book genres for his work on the first two X-Men films and Superman Returns.\n\nDescription above from the Wikipedia article Bryan Singer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	Bryan Singer
9033	\N	\N	Christopher McQuarrie is an American screenwriter, producer and director. His screenplays include The Usual Suspects, for which he won the 1996 Academy Award, The Way of the Gun and Valkyrie. He is the creator of NBC television series Persons Unknown.\n\nDescription above from the Wikipedia article Christopher McQuarrie, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Princeton Junction, New Jersey	Christopher McQuarrie
9034	\N	\N		0		Michael McDonnell
9035	\N	\N		0		Kenneth Kokin
4584	\N	\N		0		Robert Jones
9036	\N	\N		0		Art Horan
9037	\N	\N		0		François Duplat
9038	\N	\N		0		Hans Brockmann
9039	1964-07-06	\N		0		John Ottman
9040	\N	\N		0		Newton Thomas Sigel
6410	1961-08-05	\N		1		Francine Maisler
9041	\N	\N		0		Howard Cummings
8221	\N	\N		0		David Lazan
9042	\N	\N		1		Sara Andrews
50	1943-10-22	\N	Catherine Deneuve (born 22 October 1943) is a French actress. She gained recognition for her portrayal of aloof and mysterious beauties in films such as Repulsion (1965) and Belle de jour (1967). Deneuve was nominated for an Academy Award for Best Actress in 1993 for her performance in Indochine; she also won César Awards for that film and The Last Metro (1980). Considered one of France's most successful actresses, she has also appeared in seven English-language films, most notably the 1983 cult classic The Hunger. In 2008, she appeared in her 100th film, Un conte de Noël.\n\nDescription above from the Wikipedia article Catherine Deneuve, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Paris, France	Catherine Deneuve
3784	1925-12-27	\N	From Wikipedia, the free encyclopedia\n\nMichel Piccoli (born 27 December 1925) is a French actor. He was born in Paris to a musical family; his mother was a pianist and his father a violinist.\n\nHe has appeared in many different roles, from seducer to cop to gangster, in more than 170 movies. Piccoli has worked with Jean Renoir, Jean-Pierre Melville, Jean-Luc Godard, Claude Lelouch, Jacques Demy, Claude Sautet, Louis Malle, Agnès Varda, Leos Carax, Luis Buñuel, Costa-Gavras, Alfred Hitchcock, Marco Ferreri, Jacques Rivette, Otar Iosseliani and Jacques Doillon.\n\nHe was married three times, first to Éléonore Hirt, then for eleven years to the singer Juliette Gréco and finally to Ludivine Clerc. He has one daughter from his first marriage, Anne-Cordélia.\n\nPiccoli is politically active on the left, and is vocally opposed to the Front National.\n\nDescription above from the Wikipedia article Michel Piccoli, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Paris, France	Michel Piccoli
9762	1934-09-25	\N	From Wikipedia, the free encyclopedia\n\nJean Sorel (born 25 September 1934) is a French actor.\n\nHe also worked in Italian cinema, and Spanish cinema with directors such as Luis Buñuel or Luchino Visconti. However since 1980 he has worked mostly in television. He is married to Italian actress Anna-Maria Ferrero.\n\nDescription above from the Wikipedia article Jean Sorel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Jean Sorel
9763	1927-12-13	\N	​From Wikipedia, the free encyclopedia.\n\nGeneviève Page  (born Geneviève Bonjean, December 13, 1927, in Paris) is a leading French actress with a film career spanning fifty years. She is the daughter of Jacques Paul Bonjean (1899–1990), a well known french art-collector.\n\nDescription above from the Wikipedia article Geneviève Page, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Paris, France	Geneviève Page
17577	1942-09-28	1999-12-27	From Wikipedia, the free encyclopedia.\n\nPierre Clémenti (28 September 1942 – 27 December 1999) was a French actor.\n\nBorn in Paris, Clémenti studied drama and began his acting career in the theatre. He secured his first minor screen roles in 1960 in Yves Allégret's Chien de pique performing alongside Eddie Constantine. Arguably, his most famous role was that of gangster lover of bourgeois prostitute Catherine Deneuve in Belle de jour, the 1967 classic by Luis Buñuel, in whose film La voie lactée he played the Devil. He appeared in several highly regarded films of the period, working with many of Europe's best known directors, including Luchino Visconti (The Leopard), Pier Paolo Pasolini (Pigsty) and Bernardo Bertolucci (The Conformist and Partner). Other directors he has worked with are Liliana Cavani, Glauber Rocha, Miklós Jancsó and Philippe Garrel.\n\nIn 1972, his career was derailed after he was sentenced to prison for allegedly possessing or using drugs. Due to insufficient evidence, Clémenti was released after 17 months; later he penned a book about his time in prison. After his release he played the role of ever-optimistic sailor of the Potemkin in Dusan Makavejev's scandalous movie Sweet movie, and the role of the seductive saxophone player Pablo in Fred Haines's film adaptation of Herman Hesse's novel Steppenwolf. Throughout his career, he continued to be active on-stage.\n\nHe was also involved with the French underground film movement, directing several of his own films, which often featured fellow underground filmmakers and actors. Visa de censure no X was an experimental work made up of two of films. New Old was a feature length work released in 1978 in which Viva appeared. La Revolution ce ne'est qu'un debut, continuons le combat, followed by In the shadow of the blue rascal and Sun. He died of liver cancer in 1999\n\nDescription above from the Wikipedia article Pierre Clémenti, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Paris, France	Pierre Clémenti
9765	1933-05-10	\N		1		Françoise Fabian
9766	1940-09-03	\N	Macha Méril, born Princess Maria-Magdalena Vladimirovna Gagarina on 3 September 1940, Rabat, Morocco, is a French actress and writer, descended by her father from the Russian princely house Gagarin and by her mother from a Ukrainian noble family. She has appeared in 119 films between 1959 and 2007, including roles in films directed by Jean-Luc Godard (Une femme mariée, 1964), Luis Buñuel (Belle de jour, 1967) and Rainer Werner Fassbinder (Chinese Roulette, 1976). She also played in the Quebec series Lance et Compte.\n\nDescription above from the Wikipedia article Macha Méril,licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Rabat, Morocco	Macha Méril
9767	1920-01-10	1997-11-28	Georges Marchal was one of the most important lead actors in French cinema in the '50s, together with Jean Marais. He was the lead in various costume dramas and swashbuckling films before taking part in some of the films of Luis Buñuel, a close friend of his	2	Nancy, Meurthe-et-Moselle, France	Georges Marchal
9768	1926-03-08	2001-08-29	From Wikipedia, the free encyclopedia\n\nFrancisco Rabal (March 8, 1926 – August 29, 2001), perhaps better known as Paco Rabal, was a Spanish actor born in Águilas, a small town in the province of Murcia, Spain.\n\nIn 1936, after the Spanish Civil War broke out. Rabal and his family left Murcia and moved to Madrid. Young Francisco had to work as a street salesboy and in a chocolate factory. When he was 13 years old, he left school to work as an electrician at Estudios Chamartín.\n\nRabal got some sporadic jobs as an extra. Dámaso Alonso and other people advised him to try his luck with a career in theater.\n\nDuring the following years, he got some roles in theater companies such as Lope de Vega or María Guerrero. It was there that he met actress Asunción Balaguer; they married and remained together for the rest of Rabal's life. Their daughter, Teresa Rabal, is also an actor.\n\nIn 1947, Rabal got some regular jobs in theater. He used his full name, Francisco Rabal, as stage name. However, the people who knew him always called him Paco Rabal. (Paco is the familiar form for Francisco.) "Paco Rabal" became his unofficial stage name.\n\nDuring the 1940s, Rabal began acting in movies as an extra, but it was not until 1950 that he was first cast in speaking roles, and played romantic leads and rogues. He starred in three films directed by Luis Buñuel - Nazarín (1959), Viridiana (1961) and Belle de jour (1967).\n\nWilliam Friedkin thought of Rabal for the French villain of his 1971 movie The French Connection. However, he could not remember the name of "that Spanish actor". Mistakenly, his staff hired another Spanish actor, Fernando Rey. Friedkin discovered that Rabal did not speak English or French, so he decided to keep Rey. Rabal has previously worked with Rey in Viridiana. Rabal did, however, work with Friedkin in the much less successful but Academy Award-nominated cult classic Sorcerer (1977), a remake of The Wages of Fear (1953).\n\nThroughout his career, Rabal worked in France, Italy and Mexico with directors such as Gillo Pontecorvo, Michelangelo Antonioni, Luchino Visconti, Valerio Zurlini, Jacques Rivette and Alberto Lattuada.\n\nIt is widely considered that Rabal's best performances came after Francisco Franco's death on 1975. In the 1980s, Rabal starred in Los santos inocentes, winning the Award as Best Actor in Cannes Film Festival, in El Disputado Voto del Señor Cayo and also in the TV series Juncal. In 1989, he was a member of the jury at the 39th Berlin International Film Festival. In the 1999 he played the character of Francisco Goya in Carlos Saura Goya en Burdeos, winning a Goya Award as Best Actor.\n\nFrancisco Rabal is the only Spanish actor to have received a honoris causa doctoral degree from the University of Murcia.\n\nRabal's final movie was Dagon, a film which was dedicated to him right before the credits. The dedication read "Dedicated to Francisco Rabal, a wonderful actor and even better human being."\n\nRabal died in 2001 from compensatory dilating emphysema, while on an airplane travelling to Bordeaux, when he was coming back from receiving an Award at Montreal Film Festival.\n\nDescription above from the Wikipedia article Francisco Rabal, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Águilas, Murcia, Región de Murcia, Spain	Francisco Rabal
37464	1929-06-23	1999-08-22		1	Madagascar	Muni
104101	1936-09-13	\N		0	Tarare, France	Michel Charrel
25976	1925-02-22	2010-10-29	Bernard Musson est un acteur français né le 22 février 1925 à Cormeilles-en-Parisis (Val-d'Oise) et mort le 29 octobre 2010 à Paris. Avec plus de 250 films à son actif, il est, l'un des « troisièmes couteaux » les plus connus du cinéma français, aux côtés deDominique Zardi et Robert Dalban. Il est notamment l'un des acteurs fétiches de Luis Buñuel et de Jean Rollin. Élève de Charles Dullin, il a aussi mené une longue carrière au théâtre.	2	Cormeilles-en-Parisis, Val-d'Oise, France	Bernard Musson
938898	1916-02-22	1995-08-21		0	Marseille, Provence-Alpes-Côte d'Azur, France	Marcel Charvey
10492	1944-11-23	\N	From Wikipedia, the free encyclopedia.\n\nJózsef A. "Joe" Eszterhas (born November 23, 1944) is a Hungarian-American writer, best known for his work on the pulp erotic films Basic Instinct and Showgirls. He has also written several non-fiction books, including an autobiography entitled Hollywood Animal.\n\nDescription above from the Wikipedia article Joe Eszterhas, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Csakanydoroszlo, Hungary	Joe Eszterhas
28247	1925-05-14	\N	Fils du comédien et directeur de théâtre Aman-Julien Maistre connu sous le pseudonyme de A.M. Julien, François Maistre a souvent été abonné aux rôles de policier. Dans ce registre, ce comédien talentueux est principalement connu du grand public pour ses rôles de télévision. Le plus marquant est sans doute sa prestation sous les apparences du tonitruant commissaire Faivre, dans les quatre premières saisons de la série des Brigades du Tigre.  On le retrouve aussi dans les Enquêtes du Commissaire Maigret incarné par Jean Richard, Les Cinq Dernières Minutes, Le Mystère de la chambre jaune, La Dame de Monsoreau, Nostradamus, Au plaisir de Dieu, Joseph Balsamo, Gaston Phébus,Arsène Lupin, Châteauvallon, plusieurs captures de pièces de boulevard pour Au Théâtre ce Soir, etc. Il a également incarné Pierre Laval dans le téléfilm historique L'Armistice de Juin 40 (1983).  Au cinéma, où il commence à tourner en 1958, sa carrière est celle d'un second rôle qui fréquente aussi bien les films d'auteur que les fictions populaires. Dans la première catégorie, cet acteur récurrent des films de Claude Chabrol a également mis son talent au service de Jacques Rivette, Philippe de Broca, Luis Buñuel (à plusieurs reprises), Henri Verneuil et Costa-Gavras. Au titre de la seconde, il a tourné, dans un registre plus alimentaire, pour André Hunebelle,Bernard Borderie (dans la série des Angélique), Jacques Poitrenaud et Maurice Labro.  François Maistre a eu un fils en 1951, Jean François, artiste de variétés, jongleur, musicien, comédien, musicien, marionnettiste.  Après son divorce avec Anne-Marie Coffinet, il a épousé Aurore Pajot et eut une fille, Cécile Maistre, née en 1967, réalisatrice de courts-métrages, actrice, assistante réalisatrice et scénariste, principalement sur les films de Claude Chabrol, dont elle est la belle-fille.	0	Demigny, France	François Maistre
39645	1919-07-21	1974-07-06	Issu d'une famille d'artistes, en particulier d'acteurs de théâtre (parmi lesquels son père Louis Blanche, mais aussi son oncle le peintre Emmanuel Blanche), il est, à l'âge de quatorze ans, le plus jeune bachelier de France. Il forme, avec Pierre Dac, un duo auquel on doit de nombreux sketches dont Le Sâr Rabindranath Duval (1957), et un feuilleton radiophonique,Malheur aux barbus !, diffusé de 1951 à 1952 sur Paris Inter (deux cent treize épisodes), et publié en librairie cette même année; personnages et aventures sont repris de 1956 à 1960 sur Europe 1, sous le titre Signé Furax (soit mille trente-quatre épisodes). Ces émissions sont suivies par de nombreux auditeurs. Toujours avec Pierre Dac il crée le Parti d'en rire.  Il est également l'inventeur et l'auteur de canulars téléphoniques qui sont régulièrement diffusés à la radio dans les années 1960.  On lui doit également des poèmes, des paroles de chansons (673 pour être précis) comme Débit de l'eau, débit de laitchanté par Charles Trenet ou bien Le complexe de la truite (sur l'air de la Truite de Schubert) chantée par Les frères Jacques. Au théâtre, il interprète Tartuffe et Néron.  Parallèlement à sa carrière sur scène, il tourne sans discontinuer dans des films où il est souvent intervenu aussi comme scénariste et dialoguiste. Sa composition la plus populaire est celle du commandant Obersturmführer Schulz face à Brigitte Bardot dans Babette s'en va-t-en guerre (1959). Il est un des acteurs favoris de Georges Lautner, notamment fameux pour son rôle du notaire, Maître Folace dans Les Tontons flingueurs en 1963 et Boris Vassilief dans Les Barbouzes en 1964.  Il meurt d'une crise cardiaque à cinquante-deux ans, peut-être à cause de son traitement négligé du diabète de type 1. Il est enterré à Èze. Très affecté, Pierre Dac (quatre-vingt-un ans) le suivra quelques mois plus tard.	0	Paris, France	Francis Blanche
793	1900-02-22	1983-07-29	From Wikipedia, the free encyclopedia.\n\nLuis Buñuel Portolés (22 February 1900 – 29 July 1983) was a Spanish filmmaker who worked in Spain, Mexico, France and the US. He is considered one of the most influential directors in the history of cinema.\n\nDescription above from the Wikipedia article Luis Buñuel, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Calanda, Teruel, Aragón, Spain	Luis Buñuel
40976	1921-02-21	1972-07-25		0	 Paris, France	Claude Cerval
37140	1924-03-01	2005-02-15		2	Saint-Etienne, France	Marc Eyraud
24422	1931-05-27	2002-10-20	From Wikipedia, the free encyclopedia.\n\nBernard Fresson (27 May 1931- 20 October 2002) was a French cinema actor. He starred in over 160 films. Some of his notable roles include: Javert in the 1972 mini-series version of Les Misérables, Inspector Barthelmy in John Frankenheimer's French Connection II (1974), Scope in Roman Polanski's The Tenant (1976), Gilbert in Lover Boy (1978), and Francis in Garçon! (1983), for which he received a César nomination for Best Supporting Actor.\n\nDescription above from the Wikipedia article Bernard Fresson, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Reims, Marne, France	Bernard Fresson
9747	1931-09-17	\N	​From Wikipedia, the free encyclopedia.  \n\nJean-Claude Carrière (born 17 September 1931, Colombières-sur-Orb, Hérault, France) is a screenwriter and actor. Alumnus of the École normale supérieure de Saint-Cloud, he was a frequent collaborator with Luis Buñuel. He was president of La Fémis, the French state film school. His collaboration with Buñuel began with the film Diary of a Chambermaid (1964), for which he co-wrote the screenplay (with Buñuel) and also played the part of a village priest. Carrière and the director would collaborate on the scripts of nearly all Buñuel's later films, including Belle de Jour (1967), The Discreet Charm of the Bourgeoisie (1972), The Phantom of Liberty (1974), That Obscure Object of Desire (1977) and The Milky Way (1969). He also wrote screenplays for The Tin Drum (1979), Danton (1983), The Return of Martin Guerre (1982), La dernière image (1986), The Unbearable Lightness of Being (1988), Valmont (1989), The Bengali Night (1988), Chinese Box (1997) and Birth (2004), and co-wrote Max, Mon Amour (1986) with director Nagisa Oshima. He also collaborated with Peter Brook on a 9-hour stage version of the ancient Sanskrit epic, The Mahabharata, and a five-hour film version. Most recently he collaborated with Michael Haneke on the script of The White Ribbon. His work in television includes the series Les aventures de Robinson Crusoë (1964), a French-West German production much seen overseas.\n\nDescription above from the Wikipedia article Jean-Claude Carrière, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Colombières-sur-Orb, Hérault, France	Jean-Claude Carrière
9748	\N	\N		0		Joseph Kessel
9749	\N	\N		0		Henri Baum
9750	\N	\N		0		Raymond Hakim
9751	\N	\N		0		Robert Hakim
9752	1919-08-10	2001-05-15		0		Sacha Vierny
9753	\N	\N		0		Louisette Hautecoeur
9754	\N	\N		0		Robert Clavel
9755	\N	\N		0		Yves Saint-Laurent
9757	\N	\N		0		Janine Jarreau
9758	\N	\N		0		Simone Knapp
9759	\N	\N		0		Marc Goldstaub
3734	1943-12-25	\N	 \n\nHanna Schygulla (born 25 December 1943) is a German actress and chanson singer. She is generally considered the most prominent German actress of the New German Cinema.\n\nSchygulla was born in Königshütte, Upper Silesia, to German parents Antonie (née Mzyk) and Joseph Schygulla. Her father, a timber merchant by profession, was then drafted as an infantryman in the German Army and was captured by American forces in Italy, subsequently being held as a prisoner of war until 1948. In the 1960s, Schygulla studied Romance languages and German studies, while taking acting lessons in Munich during her spare time.\n\nActing eventually became her focus, and she became particularly known for her film work with Rainer Werner Fassbinder. During the making of Effi Briest (1974), an adaptation of a classic German novel, Fassbinder and Schygulla fell out over divergent interpretations of the character. Also a problem for Schygulla was low pay, and she led a revolt against Fassbinder on this issue during the making of Effi Briest. Fassbinder's response was typically blunt: "I can't stand the sight of your face any more. You bust my balls". After this, they did not work together for several years until The Marriage of Maria Braun in 1978. The film was entered into the 29th Berlin International Film Festival, where Schygulla won the Silver Bear for Best Actress for her performance.\n\nSchygulla has acted in French, Italian, and American films. In the 1990s she also became known and well regarded as a chanson singer. In Juliane Lorenz's documentary film Life, Love and Celluloid (1998), on Fassbinder and related topics, Schygulla performs several songs.\n\nIn 2002, she appeared in VB51, a performance by the artist Vanessa Beecroft. In 2007, she appeared in the film The Edge of Heaven, directed by Fatih Akın, to wide acclaim. In 2007 she received the Honorary Award from the Antalya Golden Orange Film Festival and in 2010 she received the Honorary Golden Bear from the Berlin Film Festival.\n\nHanna Schygulla has lived in Paris since 1981.\n\nDescription above from the Wikipedia article Hanna Schygulla, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Chorzów, Polska	Hanna Schygulla
9927	1936-04-08	2002-12-03		2	Berlin, Germany	Klaus Löwitsch
9928	1922-12-28	2002-04-13		2	Peking, China	Ivan Desny
9929	\N	\N		0		George Eagles
9930	1919-05-16	2007-01-16		1		Gisela Uhlen
9931	1944-04-13	\N		1		Elisabeth Trissenaar
3757	1942-08-29	2014-09-01		2	Berlin, Germany	Gottfried John
1865	1939-05-18	\N		2		Hark Bohm
2740	1922-10-06	1993-05-07		1	Gdańsk, Poland	Lilo Pempeit
11308	\N	\N		0		Bunny Andrews
2725	1945-05-31	1982-06-10	Rainer Werner Fassbinder was a German film director, screenwriter, and actor. He is one of the most important figures in the New German Cinema.\n\nFassbinder maintained a frenetic pace in filmmaking. In a professional career that lasted less than fifteen years, he completed forty feature length films; two television film series; three short films; four video productions; twenty-four stage plays and four radio plays; and thirty-six acting roles in his own and others’ films. He also worked as an actor (film and theater), author, cameraman, composer, designer, editor, producer and theater manager.\n\nUnderlying Fassbinder's work was a desire to provoke and disturb. His phenomenal creative energy, when working, coexisted with a wild, self-destructive libertinism that earned him a reputation as the enfant terrible of the New German Cinema, as well as being its central figure. He had tortured personal relationships with the actors and technicians around him who formed a surrogate family. However, his pictures demonstrate his deep sensitivity to social outsiders and his hatred of institutionalized violence. He ruthlessly attacked both German bourgeois society and the larger limitations of humanity.\n\nFassbinder died in June 1982 at the age of 37 from a lethal cocktail of cocaine and barbiturates. His death has often been cited as the event that ended the New German Cinema movement.	2	Bad Wörishofen, Germany	Rainer Werner Fassbinder
9933	\N	\N		0		Pea Fröhlich
9934	1937-07-09	2004-06-18		0		Peter Märthesheimer
9935	1940-11-14	\N		2	Königsberg, Germany	Michael Fengler
9936	1927-02-28	\N		2	Münster, Germany	Hanns Eckelkamp
3767	1940-07-03	2007-01-21		0	Viechtafell, Viechtach, Bavaria, Germany	Peer Raben
3770	1957-08-02	\N		1	Mannheim, Germany	Juliane Lorenz
9937	1935-09-14	2006-09-28		0		Helga Ballhaus
9939	\N	\N		0		Norbert Scherer
9940	\N	\N		0		Arno Mathes
9941	\N	\N		0		Hans-Peter Sandmeier
9942	\N	\N		0		Andreas Willim
9943	\N	\N		0		Barbara Baum
9944	\N	\N		0		Georg Kuhn
9945	\N	\N		0		Inge Proeller
9946	\N	\N		0		Susi Reichel
9948	\N	\N		0		Anni Nöbauer
9949	\N	\N		2		Milan Bor
9950	\N	\N		0		Jim Willis
39571	\N	\N		0		Claus Kottmann
10980	1989-07-23	\N	Daniel Jacob Radcliffe (born 23 July 1989) is an English actor who rose to prominence playing the titular character in the Harry Potter film series. His work on the series has earned him several awards and more than £60 million.\n\nRadcliffe made his acting debut at age ten in BBC One's television movie David Copperfield (1999), followed by his film debut in 2001's The Tailor of Panama. Cast as Harry at the age of eleven, Radcliffe has starred in seven Harry Potter films since 2001, with the final installment releasing in July 2011. In 2007 Radcliffe began to branch out from the series, starring in the London and New York productions of the play Equus, and the 2011 Broadway revival of the musical How to Succeed in Business Without Really Trying. The Woman in Black (2012) will be his first film project following the final Harry Potter movie.\n\nRadcliffe has contributed to many charities, including Demelza House Children's Hospice and The Trevor Project. He has also made public service announcements for the latter. In 2011 the actor was awarded the Trevor Project's "Hero Award".\n\nDescription above from the Wikipedia article Daniel Radcliffe, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Hammersmith, London, UK	Daniel Radcliffe
10989	1988-08-24	\N	From Wikipedia, the free encyclopedia\n\nRupert Alexander Grint (born 24 August 1988) is an English actor, who rose to prominence playing Ron Weasley, one of the three main characters in the Harry Potter film series. Grint was cast as Ron at the age of 11, having previously acted only in school plays and at his local theatre group. From 2001 to 2010, he starred in eight Harry Potter movies alongside Daniel Radcliffe and Emma Watson.\n\nBeginning in 2002, Grint began to work outside of the Harry Potter franchise, taking on a co-leading role in Thunderpants. He has had starring roles in Driving Lessons, a dramedy released in 2006, and Cherrybomb, a small budgeted drama released in 2010. Grint co-starred with Bill Nighy and Emily Blunt in Wild Target, a comedy. His first project following the end of the Harry Potter series will be Comrade, a 2012 anti-war release in which he stars as the main role.\n\nDescription above from the Wikipedia article Rupert Grint, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Watton-at-Stone, Hertfordshire, United Kingdom	Rupert Grint
10990	1990-04-15	\N	Emma Charlotte Duerre Watson (born 15 April 1990) is an English actress and model who rose to prominence playing Hermione Granger, one of three starring roles in the Harry Potter film series. Watson was cast as Hermione at the age of nine, having previously acted only in school plays. From 2001 to 2011, she starred in eight Harry Potter films alongside Daniel Radcliffe and Rupert Grint. Watson's work on the Harry Potter series has earned her several awards and more than £10 million.\n\nShe made her modelling debut for Burberry's Autumn/Winter campaign in 2009. In 2007, Watson announced her involvement in two non-Harry Potter productions: the television adaptation of the novel Ballet Shoes and an animated film, The Tale of Despereaux. Ballet Shoes was broadcast on 26 December 2007 to an audience of 5.2 million, and The Tale of Despereaux, based on the novel by Kate DiCamillo, was released in 2008 and grossed over US $70 million in worldwide sales. In 2012, she starred in Stephen Chbosky's film adaptation of The Perks of Being a Wallflower, and was cast in the role of Ila in Darren Aronofsky's biblical epic Noah.\n\nDescription above from the Wikipedia article Emma Watson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paris, France	Emma Watson
11207	1963-03-20	\N	​From Wikipedia, the free encyclopedia.  \n\nDavid Thewlis (born 20 March 1963) is an English film, television and stage character actor, as well as a writer.\n\nDescription above from the Wikipedia article David Thewlis, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Blackpool, Lancashire, England, UK	David Thewlis
4566	1946-02-21	2016-01-14	Alan Sidney Patrick Rickman (born 21 February 1946) was  an English actor and theatre director. He was a renowned stage actor in modern and classical productions and a former member of the Royal Shakespeare Company. Rickman was known for his film performances as Hans Gruber in Die Hard, Severus Snape in the Harry Potter film series, Eamon de Valera in Michael Collins, and Metatron in Dogma. He was also known for his prominent roles as the Sheriff of Nottingham in the 1991 film, Robin Hood: Prince of Thieves, and as Colonel Brandon in Ang Lee's 1995 film Sense and Sensibility. More recently he played Judge Turpin in Tim Burton's Sweeney Todd: The Demon Barber of Fleet Street and voiced the Caterpillar in Tim Burton's Alice in Wonderland.\n\nDescription above from the Wikipedia article Alan Rickman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Hammersmith, London, UK	Alan Rickman
117	1946-10-18	\N		0		Howard Shore
5658	1940-10-19	\N	Sir Michael Gambon is an Irish-British actor who has worked in theatre, television and film. A highly respected theatre actor, Gambon is recognised for his role in The Singing Detective and for his role as Albus Dumbledore in the Harry Potter film series, replacing the late actor Richard Harris. Gambon was born in Cabra, Dublin during World War II. His father, Edward Gambon, was an engineer, and his mother, Mary, was a seamstress. His father decided to seek work in the rebuilding of London, and so the family moved to Mornington Crescent in North London, when Gambon was five. His father had him made a British citizen - a decision that would later allow Michael to receive an actual, rather than honorary, knighthood. Gambon married Anne Miller when he was 22, but has always been secretive about his personal life, responding to one interviewer's question about her: "What wife?" The couple lived near Gravesend, Kent, where she has a workshop. While filming Gosford Park, Gambon brought Philippa Hart on to the set and introduced her to co-stars as his girlfriend. When the affair was revealed in 2002, he moved out of the marital home and bought a bachelor pad. In February 2007, it was revealed that Hart was pregnant with Gambon's child, and gave birth to son, Michael, in May 2007. On 22 June 2009 she gave birth to her second child, a boy named William, who is Gambon's third child. Gambon is a qualified private pilot and his love of cars led to his appearance on the BBC's Top Gear programme. Gambon raced the Suzuki Liana and was driving so aggressively that it went round the last corner of his timed lap on two wheels. The final corner of the Dunsfold Park track has been named "Gambon" in his honour.	2	Cabra, Dublin, Ireland	Michael Gambon
1923	1950-03-30	\N	Robbie Coltrane, is a Scottish actor, comedian and author. He is known both for his role as Dr Eddie "Fitz" Fitzgerald in the British TV series Cracker and as Rubeus Hagrid in the Harry Potter films.\n\nColtrane was born Anthony Robert McMillan in Rutherglen, South Lanarkshire, the son of Jean McMillan Ross, a teacher and pianist, and Ian Baxter McMillan, a general practitioner who also served as a forensic police surgeon. He has an older sister, Annie, and a late younger sister, Jane.\n\nColtrane moved into acting in his early twenties, taking the stage name Coltrane (in tribute to jazz saxophonist John Coltrane) and working in theatre and stand-up comedy. Coltrane soon moved into films, obtaining roles in a number of movies such as Flash Gordon. On television, he also appeared as Samuel Johnson in Blackadder.\n\nHis roles went from strength to strength in the 1990s with the TV series Cracker and a BAFTA award as the stepping stone to parts in bigger films such as the James Bond films GoldenEye and The World Is Not Enough and a major supporting role as half-giant Rubeus Hagrid in the Harry Potter films.	2	Rutherglen, South Lanarkshire, Scotland	Robbie Coltrane
10993	1987-09-22	\N	​From Wikipedia, the free encyclopedia\n\nThomas Andrew "Tom" Felton (born 22 September 1987) is a British actor and musician. He is best known for playing the role of Draco Malfoy in the Harry Potter film series, the movie adaptations of the best-selling Harry Potter fantasy novels by author J. K. Rowling, for which he auditioned at age twelve. Felton started filming in commercials when he was eight years old and in films at the age of ten, appearing in The Borrowers and Anna and the King. After being cast as Draco Malfoy he has subsequently appeared in all eight Harry Potter films, from 2001 to 2011, and finished filming the last two. A fishing aficionado, he helped form the World Junior Carp Tournament, a "family-friendly" fishing tournament. Felton's portrayal of Draco Malfoy in Harry Potter and the Half-Blood Prince won him the MTV Movie Award for Best Villain in 2010.\n\nDescription above from the Wikipedia article Tom Felton, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Kensington, London, United Kingdom	Tom Felton
11212	1987-09-09	\N	Joshua was born in Hampton, England in March, 1987 to Martin and Jessica Herdman. He is the youngest of four boys. He started acting when he was about seven. His father is an actor and got him an agent. He got his big break when he auditioned for "Harry Potter and the Sorcerer's Stone" and got the part of Gregory Goyle. In his spare time, he enjoys going back home to Hampton, spending time with friends and family, reading and writing. IMDb Mini Biography By: adam_mar	2		Josh Herdman
7056	1959-04-15	\N	Emma Thompson (born 15 April 1959) is a British actress, comedian and screenwriter. Her first major film role was in the 1989 romantic comedy The Tall Guy. In 1992, Thompson won multiple acting awards, including an Academy Award and a BAFTA Award for Best Actress, for her performance in the British drama Howards End. The following year Thompson garnered dual Academy Award nominations, as Best Actress for The Remains of the Day and as Best Supporting Actress for In the Name of the Father. In 1995, Thompson scripted and starred in Sense and Sensibility, a film adaptation of the Jane Austen novel of the same name, which earned her an Academy Award for Best Adapted Screenplay and a BAFTA Award for Best Actress in a Leading Role. Other notable film and television credits have included the Harry Potter film series, Wit (2001), Love Actually (2003), Angels in America (2003), Nanny McPhee (2005), Stranger than Fiction (2006), Last Chance Harvey (2008), An Education (2009), and Nanny McPhee and the Big Bang (2010). Thompson is also a patron of the Refugee Council and President of the Teaching Awards.\n\nDescription above from the Wikipedia article Emma Thompson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Paddington, London, England	Emma Thompson
10978	1934-12-28	\N	From Wikipedia, the free encyclopedia.\n\nDame Margaret Natalie Smith, DBE (born 28 December 1934), better known as Maggie Smith, is an English film, stage, and television actress who made her stage debut in 1952 and is still performing after 59 years. She has won numerous awards for acting, both for the stage and for film, including five BAFTA Awards, two Academy Awards, two Golden Globes, two Emmy Awards, two Laurence Olivier Awards, two SAG Awards, and a Tony Award. Her critically acclaimed films include Othello (1965), The Prime of Miss Jean Brodie (1969), California Suite (1978), Clash of the Titans (1981), A Room with a View (1985), and Gosford Park (2001). She has also appeared in a number of widely-popular films, including Sister Act (1992) and as Professor Minerva McGonagall in the Harry Potter series. Smith has also appeared in the recent hit TV series "Downton Abbey" (2010-2011) as Violet, Dowager Countess of Grantham.\n\nDescription above from the Wikipedia article Maggie Smith, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Ilford Borough, Essex, United Kingdom	Maggie Smith
10163	1925-04-24	1981-02-28	Virginia Huston was born on April 24, 1925 in Wisner, Nebraska, USA. She was an actress, known for Out of the Past (1947), Sudden Fear (1952) and Tarzan's Peril (1951). Huston suffered a broken back in an automobile accident, which disrupted her career at its peak - when she returned, she dropped to minor roles and "B"-level films. Huston retired from films after her marriage to a wealthy real estate agent. She died of cancer on February 28, 1981 in Santa Monica, California, USA.	1	Wisner, Nebraska, USA	Virginia Huston
10164	1919-03-23	2006-01-27		0		Paul Valentine
13019	1929-08-27	2007-11-12	From Wikipedia, the free encyclopedia\n\nIra Levin (August 27, 1929 – November 12, 2007) was an American author, dramatist and songwriter.\n\nDescription above from the Wikipedia article Ira Levin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Ira Levin
10991	1991-02-17	\N	Bonnie Francesca Wright was born on February 17, 1991 to jewelers Gary Wright and Sheila Teague. Her debut performance was in Harry Potter and the Philosopher's Stone (2001) as Ron Weasley's little sister Ginny Weasley. Bonnie tried out for the film due to her older brother Lewis mentioned she reminded him of Ginny. Her role in the first film was a small cameo like role as Ginny, having bigger part in the second film Harry Potter and the Chamber of Secrets (2002). After shooting the first Potter film, in 2002 Bonnie did the Hallmark television film Stranded (2002) (TV) playing Young Sarah Robinson. Then in 2004 after doing the Harry Potter and the Prisoner of Azkaban (2004) Bonnie was cast in Agatha Christie: A Life in Pictures (2004) (TV) , a BBC TV film as Young Agatha. Then Bonnie was back as Ginny Weasley for Harry Potter and the Goblet of Fire (2005), Harry Potter and the Order of the Phoenix (2007) and for Harry Potter and the Half-Blood Prince (2009) where her role turned supporting as Harry's love interest. In 2007 she guessed voiced for Disney's The Replacements (TV Series 2006-) London Calling (#2.11) as Vanessa. Also that time she voiced Ginny for Harry Potter and the Order of the Phoenix (2007) (VG) as well for Harry Potter and the Half-Blood Prince (2009) (VG) in 2009. While shooting for Harry Potter and the Deathly Hallows: Part 1 (2010), Bonnie was cast as Mia for Geography of the Hapless Heart (2013) a feature length film shot in five international locations about the complexity of love. Bonnie's segment was shot in December 2009 in London. Also during that time and shooting for Harry Potter and the Deathly Hallows: Part 2 (2011) Bonnie was attending London College of Communication to study film. In 2011 Bonnie starred in The Philosophers (2013) with James D'Arcy (I) , Daryl Sabara and with Harry Potter co-star Freddie Stroma. Film to be out in 2012. Bonnie has also written and directed a short film for school called Separate We Come, Separate We Go starring Potter co-star David Thewlis IMDb Mini Biography By: Kgose31788	1	London, United Kingdom	Bonnie Wright
11213	1948-05-11	\N	​From Wikipedia, the free encyclopedia\n\nPamela Ann "Pam" Ferris (born 11 May 1948) is a German-born Welsh actress. She is best known for her starring roles on television as Ma Larkin in The Darling Buds of May, as Laura Thyme in Rosemary &amp; Thyme, and for playing Miss Trunchbull in the movie Matilda. She also played the part of Aunt Marge in Harry Potter and the Prisoner of Azkaban.\n\nDescription above from the Wikipedia article Pam Ferris, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hannover, Germany	Pam Ferris
10983	1947-07-31	2013-03-28	Richard Griffiths is an English actor of stage, film and television. He has received the Laurence Olivier Award for Best Actor, the Drama Desk Award for Outstanding Actor in a Play, the Outer Critics Circle Award for Best Featured Actor in a Play, and the Tony Award for Best Performance by a Leading Actor in a Play, all for his role in the play The History Boys. He is also known for his portrayal of Vernon Dursley in the Harry Potter films, Uncle Monty in Withnail and I and Henry Crabbe in Pie in the Sky. On March 29th 2013 Richard died due to complications following heart surgery.	2	Thornaby-on-Tees, North Yorkshire, England, UK	Richard Griffiths
10988	1967-05-19	\N	​From Wikipedia, the free encyclopedia.  \n\nGeraldine Margaret Agnew-Somerville (born 19 May 1967) is an Irish actress best known for her roles as Detective Sergeant Jane "Panhandle" Penhaligon in Cracker, and Lily Potter in the Harry Potter film series.\n\nDescription above from the Wikipedia article  Geraldine Margaret Agnew-Somerville , licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	County Meath, Republic of Ireland	Geraldine Somerville
477	1950-02-22	\N	Julie Walters is an English actress and novelist.\n\nWalters was born as Julia Mary Walters in Smethwick, Sandwell, the daughter of Mary Bridget, a postal clerk of Irish Catholic extraction, and Thomas Walters, a builder and decorator.\n\nWalters met her husband, Grant Roffey, an AA patrol man, in a whirlwind romance. The couple have a daughter, Maisie Mae Roffey (born 1988, City of Westminster, London), but did not marry until 1997, 11 years into their relationship, when they went to New York. The couple live on an organic farm run by Roffey in West Sussex.	1	Smethwick, England, UK	Julie Walters
96851	1986-02-25	\N		2		James Phelps
96841	1989-06-27	\N	Matthew David Lewis III is an English actor, best known for playing Neville Longbottom in the Harry Potter films.\n\nLewis was born in Horsforth,Leeds,West Yorkshire, England, the son of Adrian and Lynda Lewis. He has two older brothers and a foster sister.\n\nLewis has been acting since he was five years old. He started off with minor parts in television programmes, debuting in Some Kind of Life, and then went on to try out for the part of Neville Longbottom. He has portrayed Neville Longbottom in the first six Harry Potter films and is scheduled to be in the future Harry Potter films. For his role as Neville Longbottom, Lewis wears yellow and crooked false teeth, two-sizes-too-big shoes and has plastic bits placed behind his ears in order to make them stick out more. This is done to give the character a more clownish look.	2	Leeds, West Yorkshire, UK	Matthew Lewis
9191	1957-02-27	\N	Timothy Leonard Spall, OBE (born 27 February 1957) is an English character actor and occasional presenter.\n\nDescription above from the Wikipedia article Timothy Spall, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Battersea, London, England, UK	Timothy Spall
11180	1942-04-17	\N	David Bradley is an English character actor. He has recently become known for playing the caretaker of Hogwarts, Argus Filch, in the Harry Potter series of films.\n\nBradley was born in York, England. He became an actor in 1971, first appearing on television that year in the successful comedy Nearest and Dearest playing a police officer. He was awarded a Olivier Award in 1991 for his supporting actor role in King Lear at the Royal National Theatre.\n\nBradley appeared in Nicholas Nickleby (2002) and had a small role in the 2007 comedy film Hot Fuzz as a farmer who illegally hoarded weapons, including a sea mine which later proves important to the story.	2	York, North Yorkshire, England, UK	David Bradley
234923	1988-12-02	\N		0		Alfie Enoch
1507605	\N	\N		1		Violet Columbus
1666	1941-04-14	\N	From Wikipedia, the free encyclopedia.\n\nJulie Frances Christie (born 14 April 1941) is a British actress. Born in British India to English parents, at the age of six Christie moved to England where she attended boarding school.\n\nIn 1961, she began her acting career in a BBC television series, and the following year, she had her first major film role in a romantic comedy. In 1965, she became known to international audiences as the model "Diana Scott" in the film Darling. That same year she played the part of "Lara" in David Lean's Doctor Zhivago. A pop icon of the "swinging London" era of the 1960s, she has won the Academy Award, Golden Globe, BAFTA, and Screen Actors Guild Awards.\n\nDescription above from the Wikipedia article Julie Christie, licensed under CC-BY-SA, full list of contributors on Wikipedia​	1	Chabua, Assam, India	Julie Christie
1591765	\N	\N		0		Caine Dickinson
1591763	\N	\N		0		Alan McPherson
40823	\N	\N		0		Peter Burgis
1117716	\N	\N		0		Enfys Dickinson
6737	1957-06-14	\N	From Wikipedia, the free encyclopedia.\n\nMatthew Jay Roach (born June 14, 1957) is an American film director and producer, best known for directing the Austin Powers films and Meet the Parents.\n\nDescription above from the Wikipedia article Jay Roach, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Albuquerque, New Mexico	Jay Roach
10385	\N	\N		0		Jim Herzfeld
10387	\N	\N		0		Marc Hyman
3305	1956-09-21	\N		0		Jane Rosenthal
10390	\N	\N		0		Amy Sayres
12235	1930-06-16	2016-01-01		2	Szeged, Hungary	Vilmos Zsigmond
6581	1948-12-10	\N		0		Richard Francis-Bruce
2122	\N	\N		0		William Hoy
12288	1930-06-29	\N		0	New York City, New York, USA	Robert Evans
11218	1961-11-28	\N	Alfonso Cuarón Orozco is an Academy Award-nominated Mexican film director, screenwriter and film producer, best known for, Children of Men, Harry Potter and the Prisoner of Azkaban, Y tu mamá también, and A Little Princess.\n\nCuarón was born in México City. He is the son of Alfredo Cuarón, a nuclear physicist who worked for the United Nations' International Atomic Energy Agency for many years.\n\nHe studied Philosophy at the National Autonomous University of Mexico (UNAM) and filmmaking at CUEC (Centro Universitario de Estudios Cinematográficos), a faculty of the same University. There, he met director Carlos Marcovich and cinematographer Emmanuel Lubezki, and they made what would be his first short film, Vengeance is mine. The controversy caused by the fact that the film was shot in English was the reason he was expelled from the Film School.\n\nHe began working in television in Mexico, first as a technician and then as a director. Cuarón's television work led to assignments as an assistant director for several Latin American film productions including Gaby: A True Story and Romero, and in 1991, he landed his first big-screen directorial assignment.\n\nIn 1995, Cuarón released his first feature film produced in the United States, A Little Princess, an adaptation of Frances Hodgson Burnett's classic novel.\n\nDuring his time studying in CUEC (Centro Universitario de Estudios Cinematográficos) he met Mariana Elizondo, and with her he has his first son, Jonás Cuarón born 1981, in Mexico City, Distrito Federal, Mexico.	0	Mexico City, Mexico	Alfonso Cuarón
10966	1965-07-31	\N	Fron wikipedia, the free encyclopedia .\n\nJoanne "Jo" Rowling,  known as  J. K. Rowling and Robert Galbraith, is a British novelist, screenwriter and film producer best known as the author of the Harry Potter fantasy series	1	Yate, Gloucestershire, England	Joanne K. Rowling
10967	1960-03-18	\N	Steve Kloves, born in Austin, Texas, grew up in Sunnyvale, California, where he graduated from Fremont High School. He attended the University of California, Los Angeles but dropped out when he was not admitted into the film school in his third year. As an unpaidintern for a Hollywood agent, he gained attention for a screenplay he wrote called Swings. This led to a meeting where he successfully pitched Racing with the Moon (1984).  His first experience with professional screenwriting left him wanting more interaction with the actors so that the characters would stay true to his vision. Kloves wrote The Fabulous Baker Boys and also intended it to be his directorial debut. After years of trying to sell the project in Hollywood, the film finally got off the ground and was released in 1989. The Fabulous Baker Boys did reasonably well, but his next shot as writer/director for Flesh and Bone in 1993 fared poorly at the box office. Kloves then stopped writing for three years.  Realizing that he had to return to writing to support his family, he began adapting Michael Chabon's novel Wonder Boys into a screenplay. Kloves was offered the chance to direct but he declined, preferring to direct only his own original work. This was his first try at adapting another work to film. His screenplay was nominated for a Golden Globe and an Academy Award after the film's release in 2000.  Warner Bros. sent Kloves a list of novels that the company was considering to adapt as films. The listing included the first Harry Potter novel, which intrigued him despite his usual indifference to these catalogs. He went on to write the screenplays for the first four films in the series. After Michael Goldenberg wrote the screenplay for the fifth film, Kloves then returned to write the sixth, seventh and eighth installments.  As of 2011, Kloves is working on a film adaptation of Mark Haddon's novel The Curious Incident of the Dog in the Night-Time, which he will write and direct. He has also a draft written of the yet unproduced fantasy film Akira.	0	Austin - Texas - USA	Steve Kloves
10968	1961-07-26	\N		0		David Heyman
11222	1952-10-07	\N		2		Mark Radcliffe
10158	1917-08-06	1997-07-01	​From Wikipedia, the free encyclopedia.\n\nRobert Charles Durman Mitchum  (August 6, 1917 – July 1, 1997) was an American film actor, author, composer and singer and is #23 on the American Film Institute's list of the greatest male American screen legends of all time. Mitchum is largely remembered for his starring roles in several major works of the film noir style, and is considered a forerunner of the anti-heroes prevalent in film during the 1950s and 1960s.\n\nDescription above from the Wikipedia article Robert Mitchum, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Bridgeport, Connecticut, USA	Robert Mitchum
10159	1924-09-09	2001-08-24	Jane Greer (September 9, 1924 – August 24, 2001) was a film and television actress who was perhaps best known for her role as femme fatale Kathie Moffat in the 1947 film noir Out of the Past.\n\nDescription above from the Wikipedia article Jane Greer, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Washington, D.C., United States	Jane Greer
2090	1916-12-09	\N	Kirk Douglas (December 9, 1916) is an American stage and film actor, film producer and author. His popular films include Champion (1949), Ace in the Hole (1951), The Bad and the Beautiful (1952), Lust for Life (1956), Paths of Glory (1957), Gunfight at the O.K. Corral (1957) Spartacus (1960), and Lonely Are the Brave (1962).\n\nHe is #17 on the American Film Institute's list of the greatest male American screen legends of all time. In 1996, he received the Academy Honorary Award "for 50 years as a creative and moral force in the motion picture community."\n\nDescription above from the Wikipedia article Kirk Douglas, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Amsterdam, New York, USA	Kirk Douglas
10160	1923-08-10	\N	From Wikipedia, the free encyclopedia\n\nRhonda Fleming (born Marilyn Louis, Hollywood, California, August 10, 1923) is an American film and television actress.\n\nShe acted in more than forty films, mostly in the 1940s and 1950s, and became renowned as one of the most glamorous actresses of her day. She was nicknamed the "Queen of Technicolor" because her fair complexion and flaming red hair photographed exceptionally well in Technicolor.\n\n \n\n Description\n\nabove from the Wikipedia article Rhonda Fleming  licensed\n\nunder CC-BY-SA, full list of contributors on Wikipedia.	1	Los Angeles, California, USA	Rhonda Fleming
10161	1915-09-09	1993-06-10	From Wikipedia, the free encyclopedia.\n\nRichard Webb (September 9, 1915 – June 19, 1993) was a film, television and radio actor. He was born in Bloomington, Illinois.\n\nDescription above from the Wikipedia article Richard Webb, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Bloomington, Illinois, USA	Richard Webb
10162	1919-11-25	1992-01-09	​From Wikipedia, the free encyclopedia\n\nSteve Brodie (November 21, 1919 — January 9, 1992) was an American movie and television actor.\n\nBorn as John Stevenson in El Dorado, Kansas, he reportedly selected his screen name in tribute to Steve Brodie, who jumped from the Brooklyn Bridge in 1886 and survived.\n\nMost of his acting work was from the mid 1940s to the early 1950s working at MGM, RKO and Republic Pictures appearing mostly in westerns and B-movies. He mainly played supporting roles in films such as the film noir classic Out of the Past (1947) and the classic crime film Armored Car Robbery (1950), although he did have the starring role in Desperate (1947). He later appeared with Elvis Presley in Blue Hawaii (1961) and Roustabout (1964).\n\nBeginning in the mid-1950s he appeared largely on television, including, for instance, The Public Defender, three episodes of Alfred Hitchcock Presents, and in the episode "Vendetta" of the syndicated western series Pony Express. He and Sterling Holloway appeared in the 1960 episode "Love Me, Love My Dog" of the syndicated crime drama The Brothers Brannagan.\n\nDescription above from the Wikipedia articleSteve Brodie (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	El Dorado, Kansas, USA	Steve Brodie
1371066	\N	\N		0		Christopher Kennedy
1558406	\N	\N		0		Timothy R. Sexton
8527	\N	\N		0		Deborah Lynn Scott
10165	1925-09-12	2015-09-07	Date of Birth: 12 September 1925, Los Angeles, California, USA\n\nDate of Death: 7 September 2015, Connecticut, USA\n\nDickie Moore made his acting and screen debut at the age of 18 months in the John Barrymore film The Beloved Rogue (1927); and by the time he had turned 10, he was a popular child star and had appeared in 52 films. He continued as a child star for many more years, and became the answer to the trivia question, "Who was the first actor to kiss Shirley Temple on screen?" when that honor was bestowed upon him in 1942's Miss Annie Rooney (1942). As with many child actors, once Dickie got older the roles began to dry up. He made his last film in 1950, but was still in the public eye with the 1949 to 1955 TV series Captain Video and His Video Rangers (1949). He then retired from acting for a new career in publicity.	0	Los Angeles, California, USA 	Dickie Moore
10166	\N	\N		0		Ken Niles
115366	1909-06-10	1996-06-12	From Wikipedia\n\nMary Field (June 10, 1909 – June 12, 1996) was an American\n\nfilm actress who primarily appeared in supporting roles.\n\nShe was born in New York City. As a child she never knew her\n\nbiological parents. During her infancy she was left outside the doors of a\n\nchurch with a note pinned to her saying that her name was "Olivia\n\nRockefeller". She would later be adopted.\n\nIn 1937, she was signed under contract to Warner Bros.\n\nStudios and made her film debut in The Prince and the Pauper (1937). Her other\n\nscreen credits include parts in such films as “Jezebel” (1938), “Cowboy from\n\nBrooklyn” (1938), “The Amazing Dr. Clitterhouse” (1938), “Eternally Yours”\n\n(1939), “When Tomorrow Comes” (1939),” Broadway Melody” of 1940, “Ball of Fire”\n\n(1941), “How Green Was My Valley” (1941), “Mrs. Miniver” (1942), “Out of the\n\nPast” (1947), and “Life With Father” (1947). During her time in Hollywood she\n\nstarred in approximately 103 films.\n\nHer TV credits include parts in Gunsmoke, Wagon Train, and\n\nThe Loretta Young Show. In 1963, her last acting role was as a Roman Catholic\n\nnun in the television series, Going My Way, starring Gene Kelly and modeled\n\nafter the 1944 Bing Crosby film of the same name. She appeared in several\n\nepisodes of the television comedy, Topper, as Henrietta Topper's friend Thelma\n\nGibney.\n\nOn June 12, 1996, just two days after her 87th birthday,\n\nMary Field died at her home in Fairfax, Virginia of complications from a\n\nstroke. She lived there with her daughter, Susana Kerstein, and son-in- Law,\n\nBob Kerstein. She had two grandchildren, Sky Kerstein and Kendall Kerstein.	0		Mary Field
114402	1905-04-04	1992-02-12	Character actor with a wildly distinctive face. Used real name Oliver  Prickett for stage work, especially at the Pasadena Community Playhouse,  where he was a longtime fixture and teacher and where his brother was  managing director. Used stage name Oliver Blake for scores of small film  and television roles. Brother-in-law of actress Maudie Prickett.\n\nDate of Birth  4 April  1905, Centralia, Illinois\n\nDate of Death  12 February  1992, Los Angeles, California	0		Oliver Blake
103068	1882-11-08	1955-07-24		0		Harry Hayden
97042	1909-12-13	1985-10-08		0	Houston, Texas, USA	Theresa Harris
34625	1907-03-13	1974-03-03		0		Frank Wilcox
78305	1916-06-03	2000-02-22		0		John Kellogg
115995	1896-02-06	1968-01-01		0		Brooks Benedict
1420903	\N	\N		0		Homer Dickenson
198219	\N	\N		0		Mike Lally
1487177	\N	\N		0		Bill Wallace
1204286	1891-01-09	1984-03-09		2	Manzaneda, Ourense, Galicia, Spain	Eumenio Blanco
1543340	\N	\N		0		Victor Romito
1063466	\N	\N		0		Wesley Bly
120750	\N	\N		0		Mildred Boyd
101882	1907-10-14	1987-04-09		0		James Bush
1208020	1895-12-13	1955-12-18	James Conaty was born on December 13, 1895 in Worcester, Massachusetts, USA as James Thomas Conaty. He was an actor, known for The Day the Earth Stood Still (1951), The Best Years of Our Lives (1946) and Laura (1944). He died on December 18, 1955 in Los Angeles, California, USA.	2	Worcester, Massachusetts, USA	James Conaty
1596342	\N	\N		0		Alphonso DuBois
1596347	\N	\N		0		Rudy Germane
1271047	\N	\N		0		Adda Gleason
1023934	1893-01-20	1949-12-18		2	Duluth, Minnesota, USA	Philip Morris
1331770	\N	\N		2		Manuel París
120308	\N	\N		0		Caleb Peterson
179327	1900-12-03	1974-09-26		0		Jeffrey Sayre
954389	\N	\N		0		Charles Regan
1112109	\N	\N		0		Tony Roux
7399	1965-11-30	\N	​Benjamin Edward "Ben" Stiller (born November 30, 1965) is an American comedian, actor, writer, film director, and producer. He is the son of veteran comedians and actors Jerry Stiller and Anne Meara. After beginning his acting career with a play, Stiller wrote several mockumentaries, and was offered two of his own shows, both entitled The Ben Stiller Show. He began acting in films, and had his directorial debut with Reality Bites. Throughout his career he has since written, starred in, directed, and/or produced over 50 films including Heavyweights, There's Something About Mary, Meet the Parents, Zoolander, Dodgeball, and Tropic Thunder. In addition, he has had multiple cameos in music videos, television shows, and films. Stiller is a member of the comedic acting brotherhood colloquially known as the Frat Pack. His films have grossed more than $2.1 billion domestically (United States and Canada), with an average of $73 million per film. Throughout his career, he has received several awards and honors including an Emmy Award, several MTV Movie Awards, and a Teen Choice Award.	2	New York City, New York, USA	Ben Stiller
10399	1969-06-01	\N	​From Wikipedia, the free encyclopedia.  \n\nTheresa Elizabeth "Teri" Polo (born June 1, 1969) is an American actress known for her role of Pam Focker in the movie Meet the Parents (2000) and its two sequels, Meet the Fockers (2004) and Little Fockers (2010). She was one of the stars in the sitcom I'm with Her, as well as the political drama series The West Wing.\n\nDescription above from the Wikipedia article Teri Polo , licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Dover, Delaware, U.S.	Teri Polo
10395	\N	\N	From Wikipedia, the free encyclopedia.  Jon Poll (born 1958) is an American film director, editor and producer, best known for his directorial debut with the 2007 film Charlie Bartlett.\n\nDescription above from the Wikipedia article Jon Poll, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Jon Poll
10392	\N	\N		0		Nancy Tenenbaum
7885	1943-11-28	\N		0		Randy Newman
892	\N	\N		0		John Schwartzman
10393	1957-02-01	\N		0		Alan Baumgarten
10394	\N	\N		0		Lee Haxall
18686	1958-03-20	\N	Holly Paige Hunter (born March 20, 1958) is an American actress. Hunter starred in The Piano for which she won the Academy Award for Best Actress. She has also been nominated for an Oscar for her roles in Broadcast News, The Firm, and Thirteen. Hunter has also won two Emmy Awards with seven nominations and has won a Golden Globe Award with another six nominations.\n\nDescription above from the Wikipedia article Holly Hunter, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Conyers, Georgia, USA	Holly Hunter
19045	\N	\N		0		Paul Sylbert
2532	\N	\N		1		Cathy Sandrich
380	1943-08-17	\N	Robert De Niro, Jr. (born August 17, 1943) is an American actor, director, and producer. His first major film role was in 1973's Bang the Drum Slowly. In 1974, he played the young Vito Corleone in The Godfather Part II, a role that won him the Academy Award for Best Supporting Actor. His longtime collaboration with Martin Scorsese began with 1973's Mean Streets, and earned De Niro an Academy Award for Best Actor for his portrayal of Jake LaMotta in the 1980 film, Raging Bull. He was also nominated for an Academy Award for his roles in Scorsese's Taxi Driver (1976) and Cape Fear (1991). In addition, he received nominations for his acting in Michael Cimino's The Deer Hunter (1978) and Penny Marshall's Awakenings (1990). He has received high critical praise in Scorsese's films such as for his portrayals as Travis Bickle in Taxi Driver, Jake Lamotta in Raging Bull, and as Jimmy Conway in Goodfellas. He has earned four nominations for the Golden Globe Award for Best Actor – Motion Picture Musical or Comedy: New York, New York (1977), Midnight Run (1988), Analyze This (1999) and Meet the Parents (2000). He directed A Bronx Tale (1993) and The Good Shepherd (2006).\n\nDescription above from the Wikipedia article Robert De Niro, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	New York City, New York, USA	Robert De Niro
4483	1937-08-08	\N	Dustin Lee Hoffman (born August 8, 1937) is an American actor with a career in film, television, and theatre since 1960. He has been known for his versatile portrayals of antiheroes and vulnerable types of characters. He first drew critical praise for the 1966 Off-Broadway play Eh? for which he won a Theatre World Award and a Drama Desk Award. This was soon followed by his breakthrough movie role as Benjamin Braddock in The Graduate (1967). Since then Hoffman's career has largely been focused in cinema with only sporadic returns to television and the stage. Some of his most noted films are Papillon, Marathon Man, Midnight Cowboy, Little Big Man, Lenny, All the President's Men, Kramer vs. Kramer, Tootsie, Rain Man, and Wag the Dog. Hoffman has won two Academy Awards, five Golden Globes, three BAFTAs, three Drama Desk Awards, a Genie Award, and an Emmy Award. Dustin Hoffman received the AFI Life Achievement Award in 1999. Description above from the Wikipedia article Dustin Hoffman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Los Angeles, California, USA	Dustin Hoffman
10400	1942-04-24	\N	From Wikipedia, the free encyclopedia.\n\nBarbra Joan Streisand born April 24, 1942) is an American singer, actress, film producer and director. She has won two Academy Awards, eight Grammy Awards, four Emmy Awards, a Special Tony Award, an American Film Institute award, a Peabody Award, and is one of the few entertainers who have won an Oscar, Emmy, Grammy, and Tony Award.\n\nShe is one of the most commercially and critically successful entertainers in modern entertainment history, with more than 71.5 million albums shipped in the United States and 140 million albums sold worldwide. She is the best-selling female artist on the Recording Industry Association of America's (RIAA) Top Selling Artists list, the only female recording artist in the top ten, and the only artist outside of the rock and roll genre. Along with Frank Sinatra, Cher, and Shirley Jones, she shares the distinction of being awarded an acting Oscar and also recording a number-one single on the U.S. Billboard Hot 100 chart.\n\nAccording to the RIAA, Streisand holds the record for the most top ten albums of any female recording artist - a total of 31 since 1963. Streisand has the widest span (46 years) between first and latest top ten albums of any female recording artist. With her 2009 album, Love Is the Answer, she became one of the only artists to achieve number-one albums in five consecutive decades. According to the RIAA, she has released 51 Gold albums, 30 Platinum albums, and 13 Multi-Platinum albums in the United States.\n\nDescription above from the Wikipedia article Barbra Streisand, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Williamsburg, Brooklyn, New York, USA	Barbra Streisand
10401	1943-02-03	\N	​From Wikipedia, the free encyclopedia.  \n\nBlythe Katherine Danner (born February 3, 1943) is an American actress. She is the mother of actress Gwyneth Paltrow and director Jake Paltrow.\n\nDescription above from the Wikipedia article Blythe Danner , licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Philadelphia, Pennsylvania, USA	Blythe Danner
1462	1964-05-11	\N	From Wikipedia, the free encyclopedia\n\nTim Blake Nelson (born May 11, 1964) is an American director, writer, singer, and actor.	2	Tulsa - Oklahoma - USA	Tim Blake Nelson
10402	1975-10-03	\N	Mini Biography Alanna Noel Ubach (born October 3, 1975) is an American actress and voice actress. She is known for her roles in Legally Blonde as Serena and Meet the Fockers as Isabel Villalobos. She has provided voices for several characters in a number of animated shows, such as Liz Allan in The Spectacular Spider-Man, the title character in El Tigre: The Adventures of Manny Rivera and Lola Boa in Brandy &amp; Mr. Whiskers. She has also written and performed a one-woman show. She played the first female assistant, Josie, in Beakman's World. Ubach was born in Downey, California, the daughter of Sidna and Rodolfo Ubach.\n\nHer sister Athena Ubach is a therapist. Her father is of Puerto Rican descent as well as Mexican. Source The Mini Biography is from Wikipedia: http://en.wikipedia.org/wiki/Alanna_Ubach.	1	Downey - California - USA	Alanna Ubach
10403	1925-02-03	\N	From Wikipedia, the free encyclopedia.\n\nSheldon "Shelley" Berman (born February 3, 1925) is an American comedian, actor, writer, teacher, lecturer, and poet.\n\n \n\nDescription above from the Wikipedia article Shelley Berman, licensed under CC-BY-SA, full list of contributors on Wikipedia	0		Shelley Berman
887	1968-11-18	\N	Owen Cunningham Wilson (born November 18, 1968) is an American actor and screenwriter from Dallas, Texas. His older brother, Andrew and younger brother, Luke, are also actors. He has had a long association with filmmaker Wes Anderson, having shared co-writing and acting credits for Bottle Rocket (1996) and The Royal Tenenbaums (2001), which was nominated for an Academy Award for Best Original Screenplay, and for his collaborations with fellow actor Ben Stiller. The two have appeared in ten films together.\n\nWilson is best known for his roles in Meet the Parents (2000), Shanghai Noon (2000), Zoolander (2001), Shanghai Knights (2003), Wedding Crashers (2005), Night at the Museum (2006), Cars (2006), Marley &amp; Me (2008), Night at the Museum: Battle of the Smithsonian (2009), Midnight in Paris (2011), Cars 2 (2011) and The Internship (2013).	2	Dallas - Texas - USA	Owen Wilson
52957	1984-06-09	\N		2	The Bronx, New York, U.S.	Ray Santiago
1003453	\N	\N		0		Spencer Pickren
1003454	\N	\N		0		Bradley Pickren
149665	1971-12-05	\N		0		Kali Rocha
155393	\N	\N		0		Dorie Barton
29795	1968-10-30	\N	From Wikipedia, the free encyclopedia.\n\nJack Stuart Plotnick (born October 30, 1968) is an American film and television actor.\n\nBorn in Worthington, Ohio, Plotnick is based in Hollywood. Plotnick is an openly gay actor, best known for performances on Ellen, Buffy the Vampire Slayer, as the voice of Xandir on Drawn Together, and his drag persona, "Evie Harris" in Girls Will Be Girls.	0	Worthington - Ohio - USA	Jack Plotnick
172201	1961-11-06	\N		0		Wayne Thomas Yorke
963693	1984-08-30	\N		0		Max Hoffman
1673124	\N	\N		1		Linda O'Neil
2031	\N	\N		1		Amanda Mackey
4783	1947-09-14	\N	Nigel John Dermot "Sam" Neill (born 14 September 1947) is a New Zealand actor. He is perhaps best known for his starring role as paleontologist Dr Alan Grant in Jurassic Park and Jurassic Park III. He has also had a number of high-profile roles including: the lead in Reilly, Ace of Spies, the adult Damien in Omen III: The Final Conflict, Merlin in the miniseries Merlin, Captain Vasily Borodin in The Hunt for Red October, Lord Friedrich Hoffman in Snow White: A Tale of Terror, and Alisdair Stewart in The Piano.\n\nMost recently he played Cardinal Thomas Wolsey in the Peace Arch Entertainment production for Showtime, The Tudors.\n\nDescription above from the Wikipedia article Sam Neill licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Omagh, Co. Tyrone, Northern Ireland, UK	Sam Neill
10690	1982-07-24	\N	Anna Paquin is the star of several major motion pictures, including her first Oscar winning performance in The Piano (1993), the role of the young Jane in the 1996 film Jane Eyre (1996), and the role of Amy Alden in the charming family film, Fly Away Home (1996). With a well-developed vocabulary and gentle sense of humor, Paquin proves herself to be the most enchanting young talent working today. Paquin's rising stardom has often been a cause of charming media shyness, where it is obvious that she is an ordinary girl who happens to posses an extraordinary talent. She has two agents, Gail Cowan in New Zealand, and the William Morris agency in Los Angeles, but neither these nor her parents have much influence in deciding what she films. "In the end", she says, "it's my decision". Paquin's parents separated while she was filming Fly Away Home (1996) in Canada. On Oscar night in 1993, Anna Paquin was the surprise (and surprised) winner of the Academy Award for Best Supporting Actress. She stood, wide-eyed and gulping for breath at the microphone for a full twenty-something-odd seconds before delivering a gracious, though rather breathless thank-you speech.	1	Winnipeg, Manitoba, Canada 	Anna Paquin
7248	1968-07-27	\N	​From Wikipedia, the free encyclopedia.\n\nClifford Vivian Devon "Cliff" Curtis  (born 27 July 1968) is a New Zealand actor who has had major roles in film, including The Piano, Whale Rider, and Blow, and most recently has appeared in NBC's television series Trauma. He is also co-owner of independent film production company Whenua Films. Curtis, ethnically Māori, has on film portrayed a range of ethnicities, including Latin American and Arab characters. He has appeared as a character actor in many Hollywood films, while in New Zealand he is usually the main star.\n\nDescription above from the Wikipedia article Cliff Curtis, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Rotorua, North Island, New Zealand	Cliff Curtis
10756	1948-02-29	\N		1	 Sydney, New South Wales, Australia	Kerry Walker
10755	\N	\N		0		Tungia Baker
7255	\N	\N		2		Ian Mune
10760	\N	\N	​From Wikipedia, the free encyclopedia.  \n\nGenevieve Lemon is an Australian actress who has appeared in a number of soap operas – as Zelda Baker in The Young Doctors, Marlene "Rabbit" Warren in Prisoner and Brenda Riley in Neighbours. She showed her comedic and singing talents in the televised revue show Three Men and a Baby Grand.\n\nLemon has also appeared in a number of films directed by Jane Campion – Sweetie, The Piano and Holy Smoke. She played in the stage production "Priscilla, Queen of the Desert – the Musical" as the barmaid and owner of the Broken Hill Hotel, Shirley. Her first CD, with her band, is called "Angels in the City". It is a live recording of a concert she performed in the Studio at the Sydney Opera House as part of the Singing around the House series.\n\nGenevieve Lemon is currently on stage at London's Victoria Palace Theatre, portraying Mrs Wilkinson in Billy Elliot the Musical, a role she performed firstly in Sydney then Melbourne. On 21 January 2008 she won the Best Actress in a Musical award at the 2007 Sydney Theatre Awards. Lemon won a 2008 Helpmann Award for Best Actress in a Musical for her role in Billy Elliot the Musical. Lemon has worked extensively for a number of major state theatre companies in Australia.\n\nLemon began her career with the Leichhardt-based amateur theater company, The Rocks Players.\n\nDescription above from the Wikipedia article Genevieve Lemon, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Genevieve Lemon
7249	\N	\N	Pete is one of New  Zealand's most well-known and respected Maori actors. He has been  working in the industry as an actor, writer, producer, director and  voice artist for over 20 years. Pete helped set up the production  company Puriri Films, where  works as a producer, director, writer and  presenter.	0		Pete Smith
10761	\N	\N		0		Te Whatanui Skipwith
173431	1930-08-25	\N		2		Bruce Allpress
53485	1988-10-10	\N	Frances Rose McIver (born 10 October 1988) is a New Zealand actress. Her mainstream feature film debut came in 2009's The Lovely Bones; other works include the films Predicament, and Blinder; as well as guest appearances in New Zealand based shows Xena: Warrior Princess, Hercules: The Legendary Journeys, and Legend of the Seeker. McIver was a series regular on Power Rangers RPM, and she has recurring roles in both Showtime'sMasters of Sex and on ABC's Once Upon a Time. Since March 2015, she has starred as the lead in The CW's iZombie as medical examiner Olivia "Liv" Moore.	1	Auckland, New Zealand	Rose McIver
1690610	\N	\N		2		Neil Gudsell
1404551	\N	\N		2		Jon Sperry
10757	1954-04-30	\N	From Wikipedia, the free encyclopedia.\n\nJane Campion (born 30 April 1954) is a film maker and screenwriter. She is one of the most internationally successful New Zealand directors, although most of her work has been made in or financed by other countries, principally Australia – where she now lives – and the United States. Campion is the second of four women ever nominated for the Academy Award for Best Director.\n\nDescription above from the Wikipedia article Jane Campion, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Wellington, New Zealand	Jane Campion
1462022	\N	\N		0		Alain Depardieu
10759	1944-03-23	\N		0		Michael Nyman
7262	1952-03-30	\N		0		Stuart Dryburgh
10762	\N	\N		0		Veronika Jenet
75478	\N	\N		0		Mark Turnbull
12021	1945-02-09	\N	From Wikipedia, the free encyclopedia.\n\nMia Farrow (born Maria de Lourdes Villiers Farrow; February 9, 1945) is an American actress, humanitarian, singer, and former fashion model. Farrow has appeared in more than forty-five films and won numerous awards, including a Golden Globe award (and seven additional Golden Globe nominations), five BAFTA Film Award nominations, and a win for best actress at the San Sebastian International Film Festival.  Farrow is also known for her extensive humanitarian work as a UNICEF Goodwill Ambassador. She is involved in humanitarian activities in Darfur, Chad, and the Central African Republic. In 2008, Time magazine named her one of the most influential people in the world. Description above from the Wikipedia article Mia Farrow, licensed under CC-BY-SA, full list of contributors on Wikipedia .	0	Los Angeles, California, U.S.	Mia Farrow
12044	1962-06-30	\N		2	Belgrade, Serbia, Yugoslavia	Предраг Бјелац
12045	\N	\N		0		Carlo Sabatini
12046	\N	\N		0		Amy Huck
27277	1954-09-23	\N		0		Giovanni Lombardo Radice
517	1953-05-16	\N	Pierce Brendan Brosnan, OBE (16 May 1953) is an Irish actor, film producer and environmentalist who holds Irish and American citizenship.\n\nAfter leaving school at 16, Brosnan began training in commercial illustration, but trained at the Drama Centre in London for three years. Following a stage acting career he rose to popularity in the television series Remington Steele (1982–87). After Remington Steele, Brosnan took the lead in many films such as Dante's Peak and The Thomas Crown Affair. In 1995, he became the fifth actor to portray secret agent James Bond in the official film series, starring in four films between 1995 and 2002. He also provided his voice and likeness to Bond in the 2004 video game James Bond 007: Everything or Nothing.\n\nSince playing Bond, he has starred in such successes as The Matador (nominated for a Golden Globe, 2005), Mamma Mia! (National Movie Award, 2008), and The Ghost Writer (2010). In 1996, along with Beau St. Clair, Brosnan formed Irish DreamTime, a Los Angeles-based production company.\n\nIn later years, he has become known for his charitable work and environmental activism. He was married to Australian actress Cassandra Harris from 1980 until her death in 1991. He married American journalist and author Keely Shaye Smith in 2001, becoming an American citizen in 2004.	2	Navan - Co. Meath - Ireland	Pierce Brosnan
378	1947-06-01	\N	Jonathan Pryce, CBE (born 1 June 1947) is a Welsh stage and film actor and singer.\n\nAfter studying at the Royal Academy of Dramatic Art and meeting his long time partner, English actress Kate Fahy, in 1974, he began his career as a stage actor in the 1970s. His work in theatre, including an award-winning performance in the title role of the Royal Court Theatre's "Hamlet", led to several supporting roles in film and television. He made his breakthrough screen performance in Terry Gilliam's 1985 cult film "Brazil". Critically lauded for his versatility, Pryce has participated in big-budget films such as "Evita", "Tomorrow Never Dies", "Pirates of the Caribbean" and "The New World", as well as independent projects such as "Glengarry Glen Ross" and "Carrington". His career in theatre has also been prolific, and he has won two Tony Awards—the first in 1977 for his Broadway debut in "Comedians", the second for his 1991 role as "The Engineer" in the musical "Miss Saigon".	2	Holywell, Flintshire, Wales, UK	Jonathan Pryce
1620	1962-08-06	\N	Michelle Yeoh Choo-Kheng (born 6 August 1962) is a Hong Kong-based Malaysian actress and dancer, well known for performing her own stunts in the action films that brought her to fame in the early 1990s.\n\nBorn in Ipoh, Malaysia, she is based in Hong Kong and was chosen by People magazine as one of the 50 Most Beautiful People in the World in 1997.\n\nShe is best known in the Western world for her roles in the 1997 James Bond film Tomorrow Never Dies, playing Wai Lin, and the multiple Academy Award-winning Chinese action film Crouching Tiger, Hidden Dragon, for which she was nominated the BAFTA for "Best Actress". In 2008, the film critic website Rotten Tomatoes ranked her the greatest action heroine of all time.\n\nShe is credited as Michelle Khan in some of her earlier films. This alias was chosen by the D&amp;B studio who thought it might be more marketable to international and western audiences. Yeoh later preferred using her real name.\n\nDescription above from the Wikipedia article Michelle Yeoh, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Ipoh, Perak, Malaysia	Michelle Yeoh
10742	1964-12-08	\N	Teri Lynn Hatcher (born December 8, 1964) is an American actress. She is known for her television roles as Susan Mayer on the ABC comedy-drama series Desperate Housewives, and Lois Lane on the ABC comedy-drama series Lois &amp; Clark: The New Adventures of Superman. In 2005 her Desperate Housewives work won her the Golden Globe Award for Best Actress and the Screen Actor's Guild Award for Outstanding Performance by a Female Actress in a Comedy Series.\n\nDescription above from the Wikipedia article Teri Hatcher, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Palo Alto, California, USA	Teri Hatcher
10744	1967-10-15	\N	​From Wikipedia, the free encyclopedia.  \n\nGötz Otto (born 15 October 1967) is a German actor known for his very tall stature. He is 196 cm (6 ft 6 inches) tall and is often characterised by bleached blonde hair in his films.\n\nDescription above from the Wikipedia article Götz Otto, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dietzenbach, Germany	Götz Otto
10671	1936-02-12	\N	From Wikipedia, the free encyclopedia\n\nJoe Don Baker (born February 12, 1936) is an American film actor, perhaps best known for his roles as a Mafia hitman in Charley Varrick, real-life Tennessee sheriff Buford Pusser in Walking Tall, James Bond villain Brad Whitaker in The Living Daylights, and CIA agent Jack Wade in the James Bond films GoldenEye and Tomorrow Never Dies.\n\nDescription above from the Wikipedia article Joe Don baker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Groesbeck, Texas, USA	Joe Don Baker
6003	\N	\N		0		Lisa Lindgren
6283	1960-11-08	\N	Rolf Åke Michael Nyqvist (born November 8, 1960 in Stockholm) is a Swedish actor. Educated at the School of Drama in Malmö, he became well known from his role as police officer Banck in the first series of Beck movies made in 1997. He is recently most recognized for his role in the internationally acclaimed The Girl with the Dragon Tattoo Trilogy as Mikael Blomkvist and is one of Sweden's most beloved actors.\n\nDescription above from the Wikipedia article Michael Nyqvist, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Stockholm, Stockholms län, Sweden	Michael Nyqvist
11038	\N	\N		0		Emma Samuelsson
11039	\N	\N		0		Sam Kessel
11040	1967-09-02	\N		0	 Stockholm, Stockholms län, Sweden	Gustaf Hammarsten
11041	1971-06-07	\N		1	Stockholm, Sweden	Anja Lundkvist
11042	\N	\N		0		Jessica Liedberg
11043	\N	\N		0		Axel Zuber
11044	1970-11-24	\N	From Wikipedia, the free encyclopedia.\n\nShanti Grau Roney (born November 24, 1970) is a Swedish actor. While his film credits include nearly twenty movies, most of these have been limited to a domestic or Scandinavian release. One notable exception is Lukas Moodysson's film Together (2000) which gathered acclaim at film festivals worldwide.\n\nIn television, he had a prominent role in the popular series Tusenbröder while also featuring in the Danish series The Eagle which won an International Emmy Award in 2005.\n\nShanti Roney is brother to Nunu and Marimba Roney.\n\nDescription above from the Wikipedia article Shanti Roney, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Spånga, Stockholm Municipality, Sweden	Shanti Roney
11045	1971-12-03	\N		0		Ola Rapace
11046	\N	\N		0		Olle Sarri
11047	1970-08-14	\N		0	Linköping, Östergötlands län, Sweden	Cecilia Frode
6004	1938-10-16	\N		0	Stockholm, Stockholms län, Sweden	Sten Ljunggren
11048	\N	\N		0		Claes Hartelius
11049	\N	\N		0		Thérèse Brunnander
11050	1983-12-13	\N		2		Henrik Lundström
11051	\N	\N		0		Emil Moodysson
11052	\N	\N		0		Lars Frode
11839	1970-11-12	\N		0		Harvey Stephens
1134336	\N	\N		0		Tomas Wooler
1134337	\N	\N		0		Baby Zikova
1134338	\N	\N		0		Baby Morvas
11357	1958-06-22	\N	From Wikipedia, the free encyclopedia. Bruce Lorne Campbell (born June 22, 1958) is an American actor, producer, writer, and director. A legendary B movie actor, Campbell is most famous for his starring roles in cult films like The Evil Dead, Evil Dead II, Crimewave, Army of Darkness, Maniac Cop, Bubba Ho-tep, Escape From L.A. and Sundown: The Vampire in Retreat. He played the main role in the short-lived but successful science fiction/western TV series The Adventures of Brisco County Jr. around the years 1993–1994. He also stars in a spoof of his B-movie cult status in the 2007 film My Name Is Bruce. He has starred in mainstream cinema as well, most notably Cloudy with a Chance of Meatballs, Congo and McHale's Navy. Campbell has had an extensive working relationship with director Sam Raimi, starring as Ash in Raimi's Evil Dead trilogy of horror-slapstick as well as cameos in Raimi's Spider-Man series and Darkman. He is currently starring as Sam Axe in TV series Burn Notice on the USA Network. He is rumored to star at an upcoming comedy horror film The Gatekeeper. He is about to play in the upcoming computer animated movie Cars 2 as Rod "Torque" Redline Description above from the Wikipedia article Bruce Campbell, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Birmingham, Michigan, USA	Bruce Campbell
11749	\N	\N		0		Sarah Berry
11750	1951-07-19	\N	From Wikipedia, the free encyclopedia\n\nDan Hicks (sometimes credited as Danny Hicks) is an American actor. He is best known for starring roles in Evil Dead II and Intruder as well as appearing in various other horror films. He is a close friend of Sam Raimi (the director of Evil Dead II) and often has parts in his movies.\n\nDescription above from the Wikipedia article Dan Hicks (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Pontiac, Michigan, USA	Dan Hicks
11751	1961-03-21	\N		0		Kassie DePaiva
11753	\N	\N		0		Denise Bixler
11754	\N	\N		0		Richard Domeier
11755	\N	\N		0		John Peakes
11756	\N	\N		0		Lou Hancock
11769	1965-12-14	\N	​From Wikipedia, the free encyclopedia.\n\nTheodore "Ted" Raimi  (born December 14, 1965) is an American actor, perhaps best known for his roles as Lieutenant Tim O'Neill in seaQuest DSV and Joxer the Mighty in Xena: Warrior Princess/Hercules: The Legendary Journeys. Raimi is the younger brother of Spider-Man director Sam Raimi, who directed him in Xena and Hercules, as well as in the Spider-Man movies.\n\nDescription above from the Wikipedia article Ted Raimi, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Detroit, Michigan, USA	Ted Raimi
7623	1959-10-23	\N	From Wikipedia, the free encyclopedia\n\nSamuel Marshall "Sam" Raimi (October 23, 1959) is an American film director, producer, actor and writer. He is best known for directing cult horror films like the Evil Dead series, Darkman and Drag Me to Hell, as well as the blockbuster Spider-Man films and the producer of the successful TV series Hercules: The Legendary Journeys, Xena: Warrior Princess, Legend of the Seeker and Spartacus: Blood and Sand.\n\nDescription above from the Wikipedia article Sam Raimi, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Royal Oak, Michigan, USA	Sam Raimi
11641	1957-12-24	\N	From Wikipedia, the free encyclopedia\n\nScott Spiegel (born December 24, 1957) is an American screenwriter, film director, producer and actor. He is best known for co-writing the screenplay for the movie Evil Dead II with longtime friend, film director Sam Raimi, with whom he attended Wylie E. Groves High School in Birmingham, Michigan. Spiegel played the role of Scotty in Raimi's Within the Woods, which served as a precursor to The Evil Dead.\n\nWhen Spiegel first moved to Los Angeles, he shared a house in with directors Raimi and Joel Coen, producer Ethan Coen and actresses Holly Hunter, Frances McDormand and Kathy Bates. He shared yet another house with roommate and film editor Bob Murawski (Spider-Man). In the early 1990s, he introduced film director Quentin Tarantino to producer Lawrence Bender, who helped Tarantino get Reservoir Dogs made.\n\nSpiegel grew up in what was then "rural" Birmingham, Michigan. He attended Walnut Lake Elementary school and then went on to attend West Maple Jr. High School. It was here that Scott met Sam Raimi and Bruce Campbell. Spiegel worked at the local grocery market across from Walnut Lake Elementary School and it is from this market that Scott would later draw upon the memories to come up with classic scenes that would eventually be worked into many of the scenes of the movies he would either write or direct.\n\nIn 1999, Spiegel directed the direct-to-video sequel to From Dusk Till Dawn, Texas Blood Money. Spiegel formed the production company Raw Nerve with film directors Eli Roth, and Boaz Yakin. Raw Nerve produced the film Hostel (2005), directed by Roth.\n\nDescription above from the Wikipedia article Scott Spiegel, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Birmingham, Michigan	Scott Spiegel
11643	\N	\N		0		Alex De Benedetti
11646	\N	\N		0		Irvin Shapiro
11359	1955-05-14	\N	Robert Gerard Tapert (born May 14, 1955), sometimes credited as Rob Tapert, Robert G. Tapert, or Rip Tapert, is an American film producer, best known for his co-founding of, and his subsequent work with, the Renaissance Pictures company.	0		Robert Tapert
11468	\N	\N		0		Joseph LoDuca
9573	\N	\N		0		Peter Deming
11648	\N	\N		0		Kaye Davis
11744	\N	\N		0		Randy Bennett
11745	\N	\N		0		Philip Duffin
11746	\N	\N		0		Elizabeth Moore
11747	\N	\N		0		Wendy Bell
59287	1963-03-15	\N	Gregory "Greg" Nicotero (born March 15, 1963) is an American special make-up effects creator, and television producer and director. His first major job in special effects makeup was on the George A. Romero film Day of the Dead (1985), under the tutelage of Romero and make-up effects veteran Tom Savini.	2	Pittsburgh, Pennsylvania, U.S.	Gregory Nicotero
11419	1964-11-25	\N	​From Wikipedia, the free encyclopedia.  \n\nRobert Kurtzman (born November 25, 1964) is an American film director, producer, screenwriter, and special effects creator.\n\nDescription above from the Wikipedia article Robert Kurtzman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Crestline, Ohio, USA	Robert Kurtzman
107372	\N	\N		0		Howard Berger
1189737	\N	\N		0		Shannon Shea
931858	\N	\N		0		Aaron Sims
1262012	\N	\N		0		Bryant Tausek
1203390	\N	\N		0		Mike Trcic
98471	\N	\N		0		Mark Shostrom
1134339	\N	\N		0		Baby Muller
1134340	\N	\N		0		Baby Litera
12028	\N	\N	From Wikipedia, the free encyclopedia.  \n\nJohn Moore (born 1970) is an Irish director, producer, and writer.\n\nDescription above from the Wikipedia article John Moore (director) , licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Dundalk, Ireland	John Moore
2026	\N	\N		0		Peter Landsdown Smith
21729	\N	\N		1		Lisa Fischer
1173602	1943-06-11	\N		2	Los Angeles, California, USA 	Adell Aldrich
9360	\N	\N		1		Suzanne Tenner
983118	\N	\N		0		Larry McConkey
1397731	\N	\N		0		Elizabeth Ziegler
11701	1975-06-04	\N	Angelina Jolie is an American actress. She has received an Academy Award, two Screen Actors Guild Awards, and three Golden Globe Awards. Jolie has promoted humanitarian causes throughout the world, and is noted for her work with refugees as a Goodwill Ambassador for the United Nations High Commissioner for Refugees (UNHCR). She has been cited as one of the world's most beautiful women and her off-screen life is widely reported. Though she made her screen debut as a child alongside her father Jon Voight in the 1982 film Lookin' to Get Out, Jolie's acting career began in earnest a decade later with the low-budget production Cyborg 2 (1993). Her first leading role in a major film was in Hackers (1995). She starred in the critically acclaimed biographical films George Wallace (1997) and Gia (1998), and won an Academy Award for Best Supporting Actress for her performance in the drama Girl, Interrupted (1999). Jolie achieved wider fame after her portrayal of video game heroine Lara Croft in Lara Croft: Tomb Raider (2001), and since then has established herself as one of the best-known and highest-paid actresses in Hollywood. She has had her biggest commercial successes with the action-comedy Mr. &amp; Mrs. Smith (2005) and the animated film Kung Fu Panda (2008). Divorced from actors Jonny Lee Miller and Billy Bob Thornton, Jolie currently lives with actor Brad Pitt, in a relationship that has attracted worldwide media attention. Jolie and Pitt have three adopted children, Maddox, Pax, and Zahara, as well as three biological children, Shiloh, Knox, and Vivienne.	1	Los Angeles, California, USA 	Angelina Jolie
4937	1970-03-28	\N	Vincent Anthony "Vince" Vaughn (born March 28, 1970) is an American film actor, screenwriter, producer and comedian. He began acting in the late 1980s, appearing in minor television roles before experiencing wider recognition with the 1996 movie, Swingers. He has since appeared in a number of films, mostly comedies, including The Lost World: Jurassic Park, Old School, Starsky &amp; Hutch, Dodgeball: A True Underdog Story, Couples Retreat, Mr. &amp; Mrs. Smith, and Wedding Crashers	2	Minneapolis - Minnesota - USA	Vince Vaughn
11702	1979-12-15	\N	Adam Jared Brody (born December 15, 1979) is an American film and television actor and part time musician. He began his career in 1995, appearing on the Gilmore Girls and other series, and subsequently came to fame for his role as Seth Cohen on The O.C. Brody subsequently appeared in several film roles, including Mr. &amp; Mrs. Smith, Thank You for Smoking, Jennifer's Body, In the Land of Women, Cop Out, and Scream 4. Description above from the Wikipedia Adam Brody, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Diego - California - USA	Adam Brody
11703	1977-01-31	\N	Kerry Washington is an American actress. She is known for her roles as Ray Charles's wife, Della Bea Robinson, in the film Ray (2004), as Idi Amin's wife Kay in The Last King of Scotland, and as Alicia Masters, love interest of Ben Grimm/The Thing in the live-action Fantastic Four films of 2005 and 2007. She has also starred in the critically acclaimed independent films Our Song and The Dead Girl, and is the lead actress in the 2012 ABC drama Scandal, a Shonda Rhimes series in which Washington plays Olivia Pope, a former crisis management expert to the President. Her most recent role was as Broomhilda von Schaft, Django's wife, in Quentin Tarantino's film Django Unchained.	1	Bronx, New York, USA	Kerry Washington
65827	1956-06-04	\N	Keith David Williams (born June 4, 1956), better known as Keith David, is an American film, television, and voice actor, and singer. He is perhaps most known for his live-action roles in such films as Crash, There's Something About Mary, Barbershop and Men at Work. He has also had memorable roles in numerous cult favorites, including John Carpenter's films The Thing (as Childs) and They Live (as Armitage), the Riddick films Pitch Black and The Chronicles of Riddick (as the Imam), the General in Armageddon, King in Oliver Stone's Platoon, and Big Tim in Darren Aronofsky's Requiem for a Dream. David is also well known for his voice over career, primarily his Emmy winning work as the narrator of numerous Ken Burns films. Characters that he has voiced include Goliath on the Disney series Gargoyles, the Arbiter in Halo 2 and Halo 3, David Anderson in Mass Effect and Mass Effect 2, the Decepticon Barricade in Transformers: The Game, Julius Little in Saints Row and Saints Row 2, Sgt. Foley in Call of Duty: Modern Warfare 2, Dr. Facilier in The Princess and the Frog, and Chaos in Dissidia: Final Fantasy and Dissidia 012 Final Fantasy.\n\nDescription above from the Wikipedia article Keith David, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Harlem - New York - USA	Keith David
3288	1969-11-30	\N	From Wikipedia, the free encyclopedia\n\nChristopher John "Chris" Weitz (born November 30, 1969) is an American producer, writer, director and actor. He is best known for his work with his brother, Paul Weitz, on the comedy films American Pie and About a Boy, as well as directing the film adaptation of the novel The Golden Compass and the film adaptation of New Moon from the series of Twilight books.\n\nDescription above from the Wikipedia article Chris Weitz, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York	Chris Weitz
11704	\N	\N		0		Rachael Huntley
11705	1976-03-23	\N	American actress Michelle Lynn Monaghan's first notable roles were in episodes of Young Americans, and Law &amp; Order: Special Victims Unit, both in 2001. That year she also her big screen debut in the movie “Perfume” (2001), followed by another small role in “Unfaithful” (2002).\n\nMonaghan had her big break in 2002 when she co-starred in the television series Boston Public.   Monaghan is better known for her roles in “Mission: Impossible III”, “Kiss Kiss Bang Bang”, “Gone Baby Gone”, “Made of Honor”, “The Heartbreak Kid” and “Eagle Eye”.\n\nMonaghan met Australian graphic artist Peter White at a party in 2000. They were married in August 2005 and live in New York. She gave birth to daughter Willow Katherine White on November 5, 2008.	1	Winthrop, Iowa, USA	Michelle Monaghan
59156	1974-07-23	\N	From Wikipedia, the free encyclopedia.  Stephanie Caroline March (born July 23, 1974) is an American actress, best known for her portrayal of Alexandra Cabot on the television series Law &amp; Order: Special Victims Unit.\n\nDescription above from the Wikipedia article Stephanie March, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Dallas, Dallas County, Texas	Stephanie March
11834	1940-02-12	\N	From Wikipedia, the free encyclopedia.\n\nDavid Seltzer (born 1940) is an American screenwriter, producer and director, perhaps best known for writing The Omen (1976), and Bird on a Wire (1990), starring Mel Gibson and Goldie Hawn. As writer/director, Seltzer's credits include the 1986 teen tragi-comedy Lucas starring Corey Haim, Charlie Sheen and Winona Ryder, the 1988 comedy Punchline starring Sally Field and Tom Hanks, and 1992's Shining Through starring Melanie Griffith and Michael Douglas.\n\nDescription above from the Wikipedia article David Seltzer, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	2	Highland Park, Illinois, USA	David Seltzer
9250	\N	\N		0		Jeffrey Stott
12031	\N	\N		0		Peter Veverka
12032	\N	\N		0		Glenn Williamson
7229	1966-10-07	\N		0		Marco Beltrami
12033	\N	\N		0		Jonathan Sela
6043	1974-04-08	\N		2		Dan Zimmerman
1302	\N	\N		0		Susie Figgis
41421	1979-04-12	\N	Jennifer Marie Morrison (born April 12, 1979, height 5' 5¼" (1,66 m)) is an American actress, model and film producer. She is best known for her role as Dr. Allison Cameron in House, whom she played for over five years, and also as Zoey Pierson in the sixth season of How I Met Your Mother.\n\nJennifer Morrison was born in Chicago, Illinois, and raised in Arlington Heights, Illinois. She is the eldest of three children with a sister, Julia, and a brother, Daniel. Her father, David L. Morrison, is a retired music teacher who was named teacher of the year by the Illinois State Board of Education in 2003. Morrison's mother, Judy Morrison, is also a retired teacher.\n\nMorrison attended South Middle School then graduated from Prospect High School in 1997 where her parents worked. She played clarinet in the school's marching band, sang in the choir and was a cheerleader with the school's pep squad. She attended Loyola University Chicago where she majored in Theatre and minored in English, graduating in 2000. She studied with the Steppenwolf Theatre Company before moving to Los Angeles to pursue a career in film and television.\n\nMorrison started dating her House co-star Jesse Spencer in July 2004. Spencer proposed to Morrison on December 23, 2006, at the Eiffel Tower and the two had planned to marry later in 2007. In August 2007, Morrison and Spencer called off their engagement.\n\nDescription above from the Wikipedia article Jennifer Morrison, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Chicago, Illinois, U.S.	Jennifer Morrison
1347627	\N	\N		0		Theresa Barrera
68495	1970-11-30	\N	​From Wikipedia, the free encyclopedia.  \n\nPerrey Reeves (born November 30, 1970) is an American film and television actress best known for her role on HBO's Entourage.	1	New York City, New York, USA	Perrey Reeves
1347628	\N	\N		0		Melanie Tolbert
1667654	1979-06-05	\N		2	Redlands, California, USA	Sam Sabbah
11694	1965-07-24	\N	Douglas Eric "Doug" Liman (born July 24, 1965) is an American film director and producer best known for Swingers (1996), The Bourne Identity (2002), Mr. &amp; Mrs. Smith (2005), Jumper (2008), and Fair Game (2010).  Description above from the Wikipedia article Doug Liman, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New York City, New York, USA	Doug Liman
11092	1973-08-02	\N	Simon David Kinberg (born August 2, 1973) is a British-born American screenwriter and film producer. He is best known for his work on the X-Men film franchise, and has also written such films as Mr. &amp; Mrs. Smith and Sherlock Holmes. He has served as a producer on others including Cinderella, and The Martian, for which he was nominated for an Academy Award for Best Picture. His production company is Genre Films (usually credited as Kinberg Genre),[citation needed] which has a first-look deal with 20th Century Fox.	2	London  	Simon Kinberg
11695	\N	\N		0		Lucas Foster
5575	1962-07-07	\N	Akiva J. Goldsman (born July 7, 1962) is an American screenwriter and producer in the motion picture industry. He received an Academy Award for Best Adapted Screenplay for the 2001 film, A Beautiful Mind, which also won the Oscar for Best Picture.\n\nGoldsman has been involved specifically with Hollywood films. His filmography includes the films A Beautiful Mind, I am Legend and Cinderella Man, as well as more serious dramas, and numerous rewrites both credited and uncredited. In 2006 Goldsman re-teamed with A Beautiful Mind director Ron Howard for a high profile project, adapting Dan Brown's novel The Da Vinci Code for Howard's much-anticipated film version, receiving mixed reviews for his work. Goldsman currently directs and writes many episodes of the JJ Abrams produced science fiction drama Fringe.\n\nDescription above from the Wikipedia article Akiva Goldsman, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City - New York - USA	Akiva Goldsman
2445	\N	\N		0		Eric McLeod
376	1944-12-06	\N		0		Arnon Milchan
11696	\N	\N		0		Patrick Wachsberger
11697	\N	\N		0		Erik Feig
11698	\N	\N		0		Varina Bleil
11098	1963-09-18	\N		0		John Powell
11699	\N	\N		0		Bojan Bazelli
1593	\N	\N		0		Joseph Middleton
1594	\N	\N		0		Michelle Morris
7233	1965-08-28	\N		2	San Diego, California, United States	Jeff Mann
11700	\N	\N		0		Keith Neely
6055	\N	\N		0		Victor J. Zolfo
605	\N	\N		2		Michael Kaplan
23626	1967-10-04	\N	Isaac Liev Schreiber (born October 4, 1967), commonly known as Liev Schreiber, is an American actor, producer, director, and screenwriter. He became known during the late 1990s and early 2000s, having initially appeared in several independent films, and later mainstream Hollywood films, including the Scream trilogy of horror films, The Sum of All Fears, X-Men Origins: Wolverine, and Salt. Schreiber is also a respected stage actor, having performed in several Broadway productions. In 2005, Schreiber won a Tony Award as Best Featured Actor for his performance in the play Glengarry Glen Ross. That year, Schreiber also made his debut as a film director and writer with Everything Is Illuminated, based on the novel of the same name.\n\nSchreiber is in a relationship with Naomi Watts, with whom he has two children.\n\nDescription above from the Wikipedia article Liev Schreiber, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	San Francisco, California, USA	Liev Schreiber
12041	1981-03-28	\N	Julia O'Hara Stiles (born March 28, 1981) is an American actress.\n\nAfter beginning her career in small parts in a New York City theatre troupe, she has moved on to leading roles in plays by writers as diverse as William Shakespeare and David Mamet. Her film career has included both commercial and critical successes, ranging from teen romantic comedies such as 10 Things I Hate About You (1999) to dark art house pictures such as The Business of Strangers (2001). She is also known for playing the supporting character Nicky Parsons in the Bourne film series and the leading role in Save the Last Dance, and for her role in Mona Lisa Smile. She guest starred as Lumen Pierce in the fifth season of the Showtime series Dexter, a role that earned her a Golden Globe Award nomination.\n\nDescription above from the Wikipedia article Julia Stiles, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, USA	Julia Stiles
12042	1998-12-29	\N	From Wikipedia, the free encyclopedia.  \n\nSeamus Davey-Fitzpatrick (born December 29, 1998) is an American child actor. His first film role was as Damien Thorn in the 2006 remake of the thriller The Omen.\n\nDescription above from the Wikipedia article Seamus Davey-Fitzpatrick  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	New York City, New York, USA	Seamus Davey-Fitzpatrick
4066	1914-07-23	1984-06-26		0	Chicago, Illinois, USA	Carl Foreman
6594	1901-11-11	1985-12-31		0		Sam Spiegel
12241	1921-10-21	2006-09-23		0		Malcolm Arnold
12242	1908-03-17	\N		2	London, England	Jack Hildyard
12243	1919-06-26	2004-08-25		0		Donald M. Ashton
12246	1908-05-07	\N		0		John Cox
12247	\N	\N		0		John W. Mitchell
12035	\N	\N	Patrick Lumb was born in Dorset, England in 1966. At the age of 11 he moved with his family to Scotland and then at 16, left home to attend The Central School of Art, London. He went on to study Fine Art (Painting) and graduated with B.A. (Hons.) on his 21st birthday from Falmouth School of Art, Cornwall. In 1989 he moved to the US after being awarded a Full Merit Scholarship to the prestigious School of the Art Institute of Chicago. After travelling extensively in the US and graduating in 1992 with a Master's degree in Fine Art, specializing in Film, Photography and Digital Imaging, Patrick returned to Europe, to take up a teaching position as Head of the Art and Design History Dept. at Oakham School, Rutland UK. In 1996 he moved back to Los Angeles CA, to begin a career in Film. Patrick and his wife Nancy were married in Los Angeles in 1991 and have three sons Myles, Pearse and Tate. They have a dog called Rex and spend their time between their homes in Los Angeles and Lucca, Italy.	2	Bournemouth, Dorset, UK	Patrick Lumb
12036	\N	\N		0		Katerina Kopicová
12037	\N	\N		0		Martin Kurel
12038	\N	\N		0		Ladislav Markic
12039	\N	\N		0		Paki Smith
12040	\N	\N		0		George L. Little
8252	1918-04-17	1981-11-16	From Wikipedia, the free encyclopedia William Holden (April 17, 1918 – November 12, 1981) was an American actor. Holden won the Academy Award for Best Actor in 1953 and the Emmy Award for Best Actor in 1974. One of the biggest box office draws of the 1950s, he was named one of the "Top 10 Stars of the Year" six times (1954–1958, 1961) and appeared on the American Film Institute's AFI's 100 Years…100 Stars list as #25.   Description above from the Wikipedia article William Holden, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	O'Fallon, Illinois, USA	William Holden
12248	1914-04-02	2000-08-05	From Wikipedia, the free encyclopedia\n\nSir Alec Guinness, CH, CBE (2 April 1914 – 5 August 2000) was an English actor. He was featured in several of the Ealing Comedies, including Kind Hearts and Coronets in which he played eight different characters. He later won the Academy Award for Best Actor for his role as Colonel Nicholson in The Bridge on the River Kwai. His is known for playing Obi-Wan Kenobi in the original Star Wars trilogy. He also played Prince Feisal in Lawrence of Arabia and George Smiley in the TV adaptation of Tinker, Tailor, Soldier, Spy.   Description above from the Wikipedia article Alec Guinness, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Marylebone, London, England, UK	Alec Guinness
10018	1910-09-14	1973-07-18	From Wikipedia, the free encyclopedia\n\nColonel John Edward "Jack" Hawkins CBE (14 September 1910 - 18 July 1973) was an English film actor of the 1950s, 1960s and early 1970s.   Description above from the Wikipedia article Jack Hawkins, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Wood Green, London, England, UK	Jack Hawkins
12249	1889-06-10	1973-11-23	Sessue Hayakawa (June 10, 1889 – November 23, 1973) was a Japanese and American Issei (Japanese immigrant) actor who starred in American, Japanese, French, German, and British films. Hayakawa was the first and one of the few Asian actors to find stardom in the United States as well as Europe. Between the mid-1910s and the late 1920s, he was as well known as actors Charlie Chaplin and Douglas Fairbanks. He was one of the highest paid stars of his time; making $5,000 a week in 1915, and $2 million a year via his own production company during the 1920s. He starred in over 80 movies and has two films in the U.S. National Film Registry. His international stardom transitioned both silent films and talkies.\n\nOf his English-language films, Hayakawa is probably best known for his role as Colonel Saito in the film The Bridge on the River Kwai, for which he received a nomination for Academy Award Best Supporting Actor in 1957. He also appeared as the pirate leader in Disney's Swiss Family Robinson in 1960. In addition to his film acting career, Hayakawa was a theatre actor, film and theatre producer, film director, screenwriter, novelist, martial artist, and an ordained Zen master.   Description above from the Wikipedia article Sessue Hayakawa, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Nanaura, Chiba, Japan	Sessue Hayakawa
12250	1917-05-18	1993-08-03	​From Wikipedia, the free encyclopedia\n\nJames Donald (18 May 1917 - 3 August 1993) was a Scottish actor. Tall and gaunt, he specialised in playing authority figures; military officers, doctors or scientists. Donald was born in Aberdeen, and made his first professional stage appearance sometime in the late-1930s, having been educated at Rossall School on Lancashire's Fylde coast. During World War II he appeared in minor roles in such propaganda classics as In Which We Serve (1942), Went the Day Well? (1942) and The Way Ahead (1944), and he played Mr. Winkle in the 1952 film version of The Pickwick Papers. However, leading roles eluded him until Lust for Life (1956), in which he played Theo Van Gogh. His work in the theatre included Noël Coward's Present Laughter (1943) which starred Coward himself, and The Eagle with Two Heads (1947), You Never Can Tell (1948), and The Heiress (1949) with Ralph Richardson, Peggy Ashcroft and Donald Sinden. He memorably portrayed Major Clipton, the doctor who expresses grave doubts about the sanity of Col. Nicholson's (Alec Guinness) efforts to build the bridge in order to show up his Japanese captors, in the film The Bridge on the River Kwai (1957). The final words are his: "Madness!, Madness!" He also played Group Captain Ramsey, the Senior British Officer in The Great Escape (1963), as well as supporting roles in other notable films both in Britain and the United States, including The Vikings (1958), King Rat (1965), Cast a Giant Shadow (1966), and Quatermass and the Pit (1967). Donald starred in a 1960 television adaptation of A. J. Cronin's The Citadel and appeared regularly in many other television dramas in the UK and USA, as well as on stage. In 1961, he played Prince Albert opposite Julie Harris's Queen Victoria, in the Hallmark Hall of Fame production of Laurence Housman's play Victoria Regina.\n\nDescription above from the Wikipedia article James Donald, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Aberdeen, Aberdeenshire, Scotland, UK	James Donald
12251	1933-08-22	\N		0		Geoffrey Horne
10029	1909-08-20	1978-11-28	From Wikipedia, the free encyclopedia\n\nAndré Morell (20 August 1909 – 28 November 1978; sometimes credited as Andre Morell) was a British actor. He appeared frequently in theatre, film and on television from the 1930s to the 1970s. His best known screen roles were as Professor Bernard Quatermass in the BBC Television serial Quatermass and the Pit (1958–59), and as Doctor Watson in the Hammer Film Productions version of The Hound of the Baskervilles (1959). He also appeared in the Academy Award-winning films The Bridge on the River Kwai (1957) and Ben-Hur (1959), in several of Hammer's well-known horror films throughout the 1960s and in the acclaimed ITV historical drama The Caesars (1968).\n\nHis obituary in The Times newspaper described him as possessing a "commanding presence with a rich, responsive voice... whether in the classical or modern theatre he was authoritative and dependable."\n\nDescription above from the Wikipedia article André Morell, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\n​	0	London, England	André Morell
12252	1915-04-08	2003-09-01		0	\tNew Orleans, Louisiana, USA	Peter Williams
1075445	\N	\N		0		John Boxer
33220	1920-07-31	1992-12-06	From Wikipedia, the free encyclopedia\n\nPercy Herbert (31 July 1920 - 6 December 1992) was an English character actor who often played soldiers, most notably in The Bridge on the River Kwai, The Wild Geese and Tunes of Glory. However, he was equally at home in comedies (Barnacle Bill, Call Me Bwana, two Carry On films) and science fiction (One Million Years B.C., Mysterious Island). He also acted on television; he was a regular on the short-lived series Cimarron Strip, starring Stuart Whitman.\n\nHerbert was a soldier and prisoner of war during World War II, captured by the Japanese when they took Singapore.\n\nHe was discovered by Dame Sybil Thorndike.\n\nHerbert died of a heart attack on 6 December 1992.\n\nDescription above from the Wikipedia article Percy Herbert (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England, UK	Percy Herbert
1208202	1917-10-22	2004-06-03	English character actor, trained at RADA. Started in repertory in Liverpool. By 1949, appeared on the West End stage. A self-confessed socialist, who never lost his Barnsley accent, he tended to specialise in playing working class men, such as cabbies, stewards or non-commissioned officers/	0	Wombwell, Barnsley, Yorkshire, England	Harold Goodwin
964548	1933-06-15	1992-10-20		0	Stepney, London, England, UK	Ann Sears
1075446	\N	\N		2		Heihachirô Ôkawa
1075447	\N	\N		2		Keiichirô Katsumoto
1748362	\N	\N		0		Vilaiwan Seeboonreaung
12240	1912-02-20	1994-01-30	​From Wikipedia, the free encyclopedia.  \n\nPierre Boulle (20 February 1912 – 30 January 1994) was a French novelist largely known for two famous works, The Bridge over the River Kwai (1952) and Planet of the Apes (1963).\n\nDescription above from the Wikipedia article Pierre Boulle  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Avignon, France	Pierre Boulle
12238	1908-03-25	1991-04-16	From Wikipedia, the free encyclopedia\n\nSir David Lean CBE (25 March 1908 – 16 April 1991) was an English film director, producer, screenwriter, and editor, best remembered for bringing Charles Dickens's novels to the screen with films such as Great Expectations (1946) and Oliver Twist (1948), and for his big-screen epics such as The Bridge on the River Kwai (1957), Lawrence of Arabia (1962), Doctor Zhivago (1965), Ryan's Daughter (1970), and A Passage to India (1984).\n\nAcclaimed and praised by directors such as Steven Spielberg and Stanley Kubrick, Lean was voted 9th greatest film director of all time in the British Film Institute Sight &amp; Sound "Directors Top Directors" poll 2002. Lean has four films in the top eleven of the British Film Institute's Top 100 British Films.\n\n \n\nDescription above from the Wikipedia article David Lean, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Croydon, Surrey, England, UK	David Lean
11837	1914-09-05	2013-02-06		0		Stuart Freeborn
13267	\N	\N		0		Michael Wilson
12266	1921-03-25	1985-09-30	From Wikipedia, the free encyclopedia.\n\nSimone Signoret (25 March 1921 – 30 September 1985) was a French cinema actress often hailed as one of France's greatest movie stars. She became the first French person to win an Academy Award, for her role in Room at the Top (1959). In her lifetime she also received a BAFTA, an Emmy, Golden Globe, Cannes Film Festival recognition and the Silver Bear for Best Actress.\n\nDescription above from the Wikipedia article Simone Signoret, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Wiesbaden, Germany	Simone Signoret
2569	1913-12-30	1960-12-15		0		Véra Clouzot
12267	1912-12-21	1979-01-19	From Wikipedia, the free encyclopedia.\n\nPaul Meurisse (21 December 1912, Dunkirk – 19 January 1979, Neuilly-sur-Seine) was a French actor who appeared in over 60 films and many stage productions. Meurisse was noted for the elegance of his acting style, and for his versatility. He was equally able to play comedic and serious dramatic roles. His screen appearances ranged from the droll and drily humorous to the menacing and disturbing. His most celebrated role was that of the sadistic and vindictive headmaster in the 1955 film Les Diaboliques.\n\nDescription above from the Wikipedia article Paul Meurisse, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Dunkerque, Nord, Nord-Pas-de-Calais, France	Paul Meurisse
1337	1962-06-27	\N	Tony Leung Chiu-Wai is a Hong Kong film actor and former TVB actor. A major film star since the 1990s, Leung has won the Hong Kong Film Awards five times and the Golden Horse Best Actor awards thrice.	2	Hong Kong	Tony Leung Chiu-Wai
1339	1979-02-09	\N	Zhang Ziyi, sometimes credited as Ziyi Zhang, is a Chinese film actress and model. She is considered one of the Four Dan Actresses of China. Her first major role was in The Road Home (1999). She achieved fame in the West after leading roles in Crouching Tiger, Hidden Dragon (2000), Rush Hour 2 (2001), House of Flying Daggers (2004), 2046 (2004), and Memoirs of a Geisha (2005). She has been nominated for three BAFTA Awards and a Golden Globe Award.	1	Beijing - China	Zhang Ziyi
12671	1969-08-08	\N	Faye Wong is a Chinese singer-songwriter and actress, often referred to as a "diva" in Chinese-language media. Early in her career she briefly used the stage name Shirley Wong. Wikipedia	1	Beijing, China	Faye Wong
12670	1972-11-13	\N	From Wikipedia, the free encyclopedia\n\nTakuya Kimura (born November 13, 1972), nicknamed Kimutaku, is a Japanese singer and actor. He is also a member of the Japanese idol group SMAP. Most of the TV dramas he starred in produced high ratings in Japan. He has become one of the most well-known and successful actors/singers/entertainers in Japan and Asia.\n\nDescription above from the Wikipedia article Takuya Kimura, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Tokyo, Japan	Takuya Kimura
643	1965-12-31	\N	From Wikipedia, the free encyclopedia\n\nGong Li (born 31 December 1965) is a Chinese-born Singaporean film actress. Gong first came into international prominence through close collaboration with Chinese director Zhang Yimou and is credited with helping bring Chinese cinema to Europe and the United States.\n\nShe has twice been awarded the Golden Rooster and the Hundred Flowers Awards as well as the Berlinale Camera, Cannes Festival Trophy, National Board of Review, New York Film Critics Circle Award, and Volpi Cup.\n\nShe married Singaporean businessman Ooi Hoe Soeng in 1996, and became a Singaporean citizen in 2008.\n\nDescription above from the Wikipedia article Gong Li, licensed under CC-BY-SA, full list of contributors on Wikipedia.\n\nChinese-born film actress, Gong first came into international prominence through close collaboration with Chinese director Zhang Yimou  and is credited with helping bring Chinese cinema to Europe and the United States.	0	Shenyang, Liaoning Province, China	Gong Li
12672	1965-12-08	\N	Carina Lau Kar-ling (born 8 December 1965) is a Hong Kong-based Chinese actress. She holds citizenship from Hong Kong and Canada. She was especially notable in the 1980s for her girl-next-door type roles in films.[1] Lau started her acting career in TVB, where she met fellow actor Tony Leung Chiu-Wai who had been her boyfriend since 1989. The couple wed in 2008.	0	Suzhou, Jiangsu, China	Carina Lau
12674	\N	\N		0		Siu Ping-Lam
1338	1964-09-20	\N	Maggie Cheung Man yuk (born 20 September 1964) is a Hong Kong actress. Raised in England and Hong Kong, she has over 70 films to her credit since starting her career in 1983. Some of her most commercially successful work was in the action genre, but Cheung once said in an interview that of all the work she has done, the films that really meant something to her are Song of Exile, Center Stage, Comrades: Almost a Love Story and In the Mood for Love. As Emily Wang in Clean, her last starring role to date, she became the first Asian actress to win a prize at the Cannes Film Festival. Cheung's native language is Cantonese, but she is multilingual, having learned to speak English, Mandarin and French.	0	Hong Kong	Maggie Cheung
12676	\N	\N	​From Wikipedia, the free encyclopedia.\n\nDong Jie  (born April 19, 1980) is a Chinese actress and dancer.\n\nDescription above from the Wikipedia article Dong Jie, licensed under CC-BY-SA, full list of contributors on Wikipedia	0		Dong Jie
12675	\N	\N		0		Bird McIntyre
1622	1976-10-14	\N	Chang Chen (born October 14, 1976) is a Taiwanese actor, born in Taipei, Taiwan. His name is sometimes seen in the Western order (Chen Chang). He is the son of a Taiwanese actor Chang Kuo Chu and brother of a Taiwanese actor, Chang Ha	0	Taipei, Taiwan	Chang Chen
1178957	\N	\N		0		Wong Sam
1357	1952-05-02	\N		0		Christopher Doyle
12667	\N	\N		0		Pung-Leung Kwan
12668	\N	\N		0		Yiu-Fai Lai
13015	1950-04-29	\N	From Wikipedia, the free encyclopedia.\n\nPhillip Noyce (born 29 April 1950) is an Australian film director.	0	Griffith - New South Wales - Australia	Phillip Noyce
13565	1930-03-24	1980-11-07	He was the ultra-cool male film star of the 1960s, and rose from a troubled youth spent in reform schools to being the world's most popular actor. Over 25 years after his untimely death from mesothelioma in 1980, Steve McQueen is still considered hip and cool, and he endures as an icon of popular culture. 	2	Beech Grove, IN	Steve McQueen
607	1951-11-14	\N	From Wikipedia, the free encyclopedia. Zhang Yimou (born November 14, 1950 or 1951)  is a Chinese film director, producer, writer and actor, and former cinematographer. He is counted amongst the Fifth Generation of Chinese filmmakers, having made his directorial debut in 1987 with Red Sorghum. Zhang has won numerous awards and recognitions, with Best Foreign Film nominations for Ju Dou in 1990 and Raise the Red Lantern in 1991, Silver Lion and Golden Lion prizes at the Venice Film Festival, Grand Jury Prize at the Cannes Film Festival, and the Golden Bear at the Berlin International Film Festival. One of Zhang's recurrent themes is the resilience of Chinese people in the face of hardship and adversity, a theme which has been explored in such films as, for example, To Live (1994) and Not One Less (1999). His films are particularly noted for their rich use of colour, as can be seen in some of his early films, like Raise the Red Lantern, and in his wuxia films like Hero and House of Flying Daggers.\n\nDescription above from the Wikipedia article Zhang Yimou, licensed under CC-BY-SA, full list of contributors on Wikipedia.    	2	Xi'an, Shaanxi, China	Zhang Yimou
12682	\N	\N		0		Marc Sillam
12684	\N	\N		0		Eric Heumann
12453	1956-07-17	\N	Wong Kar-wai is a Hong Kong Second Wave filmmaker, internationally renowned as an auteur for his visually unique, highly stylized films. Wong's films frequently feature protagonists who yearn for romance in the midst of a knowingly brief life and scenes that can often be described as sketchy, digressive, exhilarating, and containing vivid imagery.	2	Shanghai, China	Wong Kar-wai
12455	1951-02-19	\N		0		Shigeru Umebayashi
45818	\N	\N		0		William Chang
18839	\N	\N		0		Amedeo Pagani
12497	1925-07-01	2011-03-28	From Wikipedia, the free encyclopedia\n\nFarley Earle Granger (July 1, 1925 – March 27, 2011) was an American actor. In a career spanning several decades, he was perhaps best known for his two collaborations with Alfred Hitchcock, Rope in 1948 and Strangers on a Train in 1951.	0	San Jose - California - USA	Farley Granger
12498	1922-12-22	1999-09-09	​From Wikipedia, the free encyclopedia.  \n\nRuth Roman (born Norma Roman December 22, 1922 in Lynn, Massachusetts – September 9, 1999 in Laguna Beach, California) was an American actress. One of her most memorable roles was in the Alfred Hitchcock 1951 thriller Strangers on a Train.\n\nDescription above from the Wikipedia article Ruth Roman licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Lynn, Massachusetts, U.S.	Ruth Roman
12499	1918-10-13	1951-08-28	​From Wikipedia, the free encyclopedia.  \n\nRobert Hudson Walker (October 13, 1918 – August 28, 1951) was an American actor.[1] He is probably best known for his role as Bruno Anthony in Alfred Hitchcock's 1951 thriller Strangers on a Train.\n\nDescription above from the Wikipedia article  Robert Walker licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Salt Lake City, Utah, USA	Robert Walker
12500	1928-07-07	\N		0		Patricia Hitchcock
4430	1958-03-10	\N	Sharon Yvonne Stone (born March 10, 1958) is an American actress, film producer, and former fashion model. She achieved international recognition for her role in the erotic thriller Basic Instinct. She was nominated for an Academy Award for Best Actress and won a Golden Globe Award for Best Actress in a Motion Picture Drama for her performance in Casino.\n\nDescription above from the Wikipedia article Sharon Stone, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Meadville, Pennsylvania, USA	Sharon Stone
13021	1963-02-21	\N	From Wikipedia, the free encyclopedia.\n\nWilliam Joseph "Billy" Baldwin (born February 21, 1963) is an American actor, producer, and writer, known for his starring roles in such films as Flatliners (1990), Backdraft (1991), Sliver (1993), Fair Game (1995), Virus (1999), Double Bang (2001), as Johnny 13 in Danny Phantom (2004–2007), Art Heist (2004), The Squid and the Whale (2005), as Senator Patrick Darling in the TV drama Dirty Sexy Money (2007–2009) on ABC, Justice League: Crisis on Two Earths (2010), and now Baldwin is currently a regular guest on Gossip Girl as William van der Woodsen and Parenthood as Gordon Flint. Billy's most recent role was as lead detective Brian Albert in the Lifetime Original Movie The Craigslist Killer.\n\nDescription above from the Wikipedia article William Baldwin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Massapequa, New York, U.S	William Baldwin
13022	1949-05-31	\N	Tom Berenger (born May 31, 1949) is an American actor known mainly for his roles in action films.\n\nDescription above from the Wikipedia article Tom Berenger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Chicago - Illinois - USA	Tom Berenger
6416	1966-05-19	\N	Polly Walker (born 19 May 1966) is an English actress.\n\nDescription above from the Wikipedia article Polly Walker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Warrington, Cheshire, England, UK	Polly Walker
13024	1966-07-15	\N		1	Los Angeles, California, USA 	Amanda Foreman
2641	1928-06-20	\N	​From Wikipedia, the free encyclopedia.    Martin Landau (born June 20, 1928) is an American actor. Landau began his career in the 1950s; his early films include a supporting role in Alfred Hitchcock's North by Northwest (1959). He played continuing roles in the television series Mission: Impossible for which he received Emmy Award nominations, and Space:1999. He received a Golden Globe Award for Best Supporting Actor - Motion Picture and his first nomination for an Academy Award for Best Supporting Actor for his work in Tucker: The Man and His Dream, and was also Oscar nominated for his role in Crimes and Misdemeanors (1989). His performance in the supporting role of Béla Lugosi in Ed Wood (1994) earned him the Academy Award, Screen Actors Guild Award and a Golden Globe. He continues to perform in film and television and heads the Hollywood branch of the Actors Studio. Landau was born into a Jewish-American family in Brooklyn, New York, the son of Selma (née Buchanan) and Morris Landau, an Austrian-born machinist who scrambled to rescue relatives from the Nazis.  Description above from the Wikipedia article Martin Landau  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, U.S.	Martin Landau
13026	1924-04-20	2008-12-05	From Wikipedia, the free encyclopedia.  Nina Foch (April 20, 1924 - December 5, 2008) was a Dutch-born American actress and leading lady in many 1940s and 1950s films.\n\nDescription above from the Wikipedia article Nina Foch, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Leiden, Zuid-Holland, Netherlands	Nina Foch
13027	1923-02-15	2002-10-13		0		Keene Curtis
13028	1935-01-28	\N		0		Nicholas Pryor
13029	\N	\N		0		Anne Betancourt
30485	1952-12-25	\N	From Wikipedia, the free encyclopedia\n\nCarol Christine Hilaria Pounder (born December 25, 1952), known professionally as C. C. H. Pounder (styled "CCH Pounder"), is a Guyanese-American film and television actress. She has appeared in numerous films, made-for-television films, television miniseries and plays, and has made guest appearances on notable television shows.	0	Georgetown - British Guiana	CCH Pounder
1355189	1954-04-12	\N		0	Chicago - Illinois - USA	Philip Hoffman
13566	1893-12-12	1973-01-26	Edward G. Robinson (born Emanuel Goldenberg; December 12, 1893 – January 26, 1973) was a Romanian-born American actor. Although he played a wide range of characters, he is best remembered for his roles as a gangster, most notably in his star-making film Little Caesar.\n\nDescription above from the Wikipedia article Edward G. Robinson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Bucharest, Romania	Edward G. Robinson
13567	1941-04-28	\N	Ann-Margret Olsson (born April 28, 1941) is a Swedish-American actress, singer and dancer whose professional name is Ann-Margret. She is best known for her roles in Bye Bye Birdie (1963), Viva Las Vegas (1964), The Cincinnati Kid (1965), Carnal Knowledge (1971), and Tommy (1975). She has won five Golden Globe Awards and been nominated for two Academy Awards, two Grammy Awards, a Screen Actors Guild Award, and six Emmy Awards. On August 21, 2010, she won her first Emmy Award for her guest appearance on Law &amp; Order: SVU.\n\nDescription above from the Wikipedia article Ann-Margret, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	Valsjöbyn, Jämtlands län, Sweden	Ann-Margret
9857	1912-03-22	2009-07-01	From Wikipedia, the free encyclopedia\n\nKarl Malden (born Mladen George Sekulovich ; March 22, 1912 – July 1, 2009) was an American actor. In a career that spanned more than seven decades, he featured in classic Marlon Brando films such as A Streetcar Named Desire, On the Waterfront and One-Eyed Jacks. Among other notable film roles were Archie Lee Meighan in Baby Doll, Zebulon Prescott in How the West Was Won and General Omar Bradley in Patton. His best-known role was on television as Lt. Mike Stone on the 1970s crime drama, The Streets of San Francisco. During the 1970s and 1980s, he was the spokesman for American Express, reminding cardholders "Don't leave home without it".\n\n \n\nDescription above from the Wikipedia article Karl Malden, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Chicago, Illinois, USA 	Karl Malden
4514	1943-08-27	\N	Tuesday Weld (born August 27, 1943) is an American actress.\n\nWeld began her acting career as a child, and progressed to more mature roles during the late 1950s. She won a Golden Globe Award for Most Promising Female Newcomer in 1960. Over the following decade she established a career playing dramatic roles in films.\n\nAs a featured performer in supporting roles, her work was acknowledged with nominations for a Golden Globe Award for Play It As It Lays (1972), an Academy Award for Best Supporting Actress for Looking for Mr. Goodbar (1978), an Emmy Award for The Winter of Our Discontent (1983), and a BAFTA for Once Upon a Time in America (1984).\n\nSince the end of the 1980s, her acting appearances have been infrequent.\n\nDescription above from the Wikipedia article Tuesday Weld, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, USA	Tuesday Weld
13568	1906-08-30	1979-12-25	Rose Joan Blondell (August 30, 1906 – December 25, 1979) was an American actress.\n\nAfter winning a beauty pageant, Blondell embarked upon a film career. Establishing herself as a sexy wisecracking blonde, she was a Pre-code staple of Warner Brothers and appeared in more than 100 movies and television productions. She was most active in films during the 1930s, and during this time she co-starred with Glenda Farrell in nine films, in which the duo portrayed gold-diggers. Blondell continued acting for the rest of her life, often in small character roles or supporting television roles. She was nominated for an Academy Award for Best Supporting Actress for her work in The Blue Veil (1951).\n\nBlondell was seen in featured roles in two films released shortly before her death from leukemia, Grease (1978) and the remake of The Champ (1979).\n\nDescription above from the Wikipedia article Joan Blondell, licensed under CC-BY-SA, full list of contributors on Wikipedia.	1	New York City, New York, USA	Joan Blondell
9626	1931-02-06	\N	From Wikipedia, the free encyclopedia\n\nElmore Rual Torn, Jr. (born February 6, 1931), better known as Rip Torn, is an American actor of stage, screen and television.\n\nTorn received an Academy Award nomination as Best Supporting Actor for his role in the 1983 film Cross Creek. His work includes the role of Artie, the producer, on The Larry Sanders Show, for which he was nominated for six Emmy Awards, winning in 1996. Torn also won an American Comedy Award for Funniest Supporting Male in a Series, and two CableACE Awards for his work on the show, and was nominated for a Satellite Award in 1997 as well.\n\nDescription above from the Wikipedia article Rip Torn, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Temple, Texas, USA	Rip Torn
726	1924-08-21	1996-05-03	From Wikipedia, the free encyclopedia.\n\nJack Weston (born Jack Weinstein; August 21, 1924 – May 3, 1996) was an American film, stage, and television actor.\n\nWeston usually played comic roles in films such as Cactus Flower and Please Don't Eat the Daisies, but also occasionally essayed heavier parts, such as the scheming crook and stalker who, along with Alan Arkin and Richard Crenna, attempts to terrorize and rob a blind Audrey Hepburn in the 1967 film Wait Until Dark. Weston had countless character roles in major films such as The Cincinnati Kid and The Thomas Crown Affair.\n\nIn 1981, Weston appeared on Broadway in Woody Allen's comedy The Floating Light Bulb, for which he was nominated for a Tony Award as Best Actor. Other stage appearances included Bells are Ringing (with Judy Holliday), The Ritz, One Night Stand, and Neil Simon's California Suite.\n\nDescription above from the Wikipedia article Jack Weston, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Cleveland, Ohio	Jack Weston
7173	1907-12-25	1994-11-18	From Wikipedia, the free encyclopedia\n\nCabell "Cab" Calloway III (December 25, 1907 – November 18, 1994) was an American jazz singer and bandleader.\n\nCalloway was a master of energetic scat singing and led one of the United States' most popular African American big bands from the start of the 1930s through the late 1940s. Calloway's band featured performers including trumpeters Dizzy Gillespie and Adolphus "Doc" Cheatham, saxophonists Ben Webster and Leon "Chu" Berry, New Orleans guitar ace Danny Barker, and bassist Milt Hinton. Calloway continued to perform until his death in 1994 at the age of 86.\n\nDescription above from the Wikipedia article Cab Calloway, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Rochester, New York, USA	Cab Calloway
9596	1914-08-10	2002-08-16	From Wikipedia, the free encyclopedia\n\nJeff Corey (August 10, 1914 – August 16, 2002) was an American stage and screen actor and director who became a well-respected acting teacher after being blacklisted in the 1950s.\n\nDescription above from the Wikipedia article Jeff Corey,licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, USA	Jeff Corey
45252	\N	\N		0		Theo Marcuse
101901	1918-10-25	2006-10-21		0		Milton Selzer
12158	1908-07-23	1978-10-08		0		Karl Swenson
178884	1921-07-27	2003-03-19		0		Émile Genest
161405	1932-03-28	2002-05-02		0		Ron Soble
98963	1907-08-03	1995-03-10		0		Irene Tedrow
121083	\N	\N		0		Midge Ware
1213187	\N	\N		0		Burt Mustin
348497	1889-04-28	1967-05-03		0		Harry Hines
30615	1934-04-20	2008-02-09	From Wikipedia, the free encyclopedia.\n\nRobert DoQui (April 20, 1934 – February 9, 2008) was an American actor who starred in film and on television. He is best known for his role as King George in the 1973 film, Coffy, starring Pam Grier, as Sgt. Warren Reed in the 1987 science fiction film RoboCop, the 1990 sequel RoboCop 2, and the 1993 sequel RoboCop 3. Robert starred on television and is also known for his voice as Pablo Roberts on Harlem Globetrotters cartoon from 1970-1973. He was born in Stillwater, Oklahoma.\n\nHe starred in the miniseries Centennial in 1978, and The Court-Martial of Jackie Robinson TV movie in 1990. Robert made guest appearances on many TV shows, including I Dream of Jeannie, "The Jeffersons," Daniel Boone, Gunsmoke, Adam-12, The Parkers, and Star Trek: Deep Space Nine in the season 4 episode "Sons of Mogh" as a Klingon named Noggra. He died February 9, 2008 at the age of 73. He was buried at Inglewood Park Cemetery in Los Angeles, California.\n\nDescription above from the Wikipedia article Robert DoQui, licensed under CC-BY-SA, full list of contributors on Wikipedia​	0	Stillwater, Oklahoma, USA	Robert DoQui
114961	1909-02-28	1994-02-01		0		Olan Soule
13563	1926-07-21	\N	From Wikipedia, the free encyclopedia\n\nNorman Frederick Jewison, CC, O.Ont (born 21 July 1926) is a Canadian film director, producer, actor and founder of the Canadian Film Centre. Highlights of his directing career include In the Heat of the Night (1967), The Thomas Crown Affair (1968), Fiddler on the Roof (1971), Jesus Christ Superstar (1973), Moonstruck (1987), The Hurricane (1999) and The Statement (2003). Jewison has addressed important social and political issues throughout his directing and producing career, often making controversial or complicated subjects accessible to mainstream audiences.\n\nDescription above from the Wikipedia article Norman Jewison, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Toronto, Ontario, Canada	Norman Jewison
13564	\N	\N		0		Richard Jessup
9791	1915-08-19	2000-10-31	From Wikipedia, the free encyclopedia\n\nRinggold Wilmer "Ring" Lardner Jr. (August 19, 1915 – October 31, 2000) was an American journalist and screenwriter blacklisted by the Hollywood movie studios during the Red Scare of the late 1940s and 1950s.\n\nRing Lardner Jr. moved to Hollywood where he worked as a publicist and "script doctor" before writing his own material. This included Woman of the Year, a film that won him an Academy Award for Writing Original Screenplay in 1942. He also worked on the scripts for the films Laura (1944), Brotherhood of Man (1946), Forever Amber (1947), and M*A*S*H (1970). The script of the latter earned him an Academy Award for Best Adapted Screenplay.\n\nLardner held strong left-wing views and during the Spanish Civil War he helped raise funds for the Republican cause. He was also involved in organizing anti-fascist demonstrations. His brother, James Lardner, was a member of the Abraham Lincoln Brigade, and was killed in action in Spain in 1938. Although his political involvement upset the owners of the film studios, he continued to be given work and in 1947 became one of the highest paid scriptwriters in Hollywood when he signed a contract with 20th Century Fox at $2,000 a week.	2	Chicago, Illinois, U.S.	Ring Lardner, Jr.
8950	1924-05-01	1995-10-29	From Wikipedia, the free encyclopedia.   Terry Southern (1 May 1924 – 29 October 1995) was an American author, essayist, screenwriter and university lecturer, noted for his distinctive satirical style. Part of the Paris postwar literary movement in the 1950s and a companion to Beat writers in Greenwich Village, Southern was also at the center of Swinging London in the sixties and helped to change the style and substance of American films in the 1970s. In the 1980s he wrote for Saturday Night Live and lectured on screenwriting at several universities in New York.\n\nSouthern's dark and often absurdist style of satire helped to define the sensibilities of several generations of writers, readers, directors and film goers. He is credited by journalist Tom Wolfe as having invented New Journalism with the publication of "Twirling at Ole Miss" in Esquire in 1962, and his gift for writing memorable film dialogue was evident in Dr. Strangelove, The Loved One, The Cincinnati Kid, Easy Rider, and The Magic Christian. His work on Easy Rider helped create the independent film movement of the 1970s.\n\nDescription above from the Wikipedia article Terry Southern, licensed under CC-BY-SA,full list of contributors on Wikipedia.	2	Alvarado, Texas, USA	Terry Southern
2993	1927-07-07	\N	Martin Ransohoff (born November 30, 1926) is a cinema and television producer, and member of the Ransohoff family.\n\nHe graduated from Colgate University in 1949 and is on a list of Distinguished Alumni. He founded the film production company Filmways, Inc. in 1960 and remained with the company until 1972. Filmways started making TV commercials, moved into documentaries then sitcoms; by 1963 Filmways were making $13 million a year. In 1972 he became an independent producer. He attempted to "create" female movie stars during the 1960s; the actresses who achieved the greatest success under his tutelage were Ann-Margret, Tuesday Weld and Sharon Tate, who featured in several of his films from 1964 until her death in 1969. He is a cousin of neurosurgeonJoseph Ransohoff. The Beverly Hillbillies brought Ransohoff his first success in 1962 and thereafter he turned his attention to films. Ransohoff went on to produce such films as American Pop.	2	New Orleans, Louisiana, USA	Martin Ransohoff
8406	1930-07-08	2011-09-13	John Nicholas Calley (July 8, 1930 – September 13, 2011) was an American film studio executive and producer. He was quite influential during his years at Warner Bros. (where he worked from 1968 to 1981) and "produced a film a month, on average, including commercial successes like The Exorcist and Superman." During his seven years at Sony Pictures Entertainment starting in 1996, five of which he was chairman and chief executive, he was credited with "reinvigorat[ing]" that major film studio.	0	Jersey City - New Jersey - USA	John Calley
9217	1932-06-21	\N		2	Buenos Aires, Argentina	Lalo Schifrin
1939	1912-10-22	1995-04-12		2	Merced, California, USA	Philip H. Lathrop
4964	1929-09-02	1988-12-27	From Wikipedia, the free encyclopedia.\n\nHal Ashby (September 2, 1929 – December 27, 1988) was an American film director and film editor.\n\nDescription above from the Wikipedia article Hal Ashby, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Ogden, Utah, USA	Hal Ashby
10009	1907-11-28	1996-12-28		2	Los Angeles, California, USA	Edward C. Carfagno
10604	1914-04-17	1998-10-03		2	Kokomo, Indiana, USA	George W. Davis
3648	1907-03-20	1983-09-16		2	Kern, California, USA	Henry Grace
5004	1932-04-10	2015-07-10	Omar Sharif, the Franco-Arabic actor best known for playing Sherif Ali in Lawrence of Arabia (1962) and the title role in Doctor Zhivago (1965), was born Michel Demitri Shalhoub on April 10, 1932 in Alexandria, Egypt to Joseph Shalhoub, a lumber merchant, and his wife, Claire. Of Lebanese and Syrian extraction, the young Michel was raised a Roman Catholic. He was educated at Victoria College in Alexandria and took a degree in mathematics and physics from Cairo University with a major. Afterward graduating from university, he entered the family lumber business. Before making his English-language film debut with "Lawrence of Arabia", for which he earned him a Best Supporting Actor Academy Award nomination and international fame, Sharif became a star in Egyptian cinema. His first movie was the Egyptian film Siraa Fil-Wadi (1954) ("The Blazing Sun") in 1953, opposite the renowned Egyptian actress Faten Hamama whom he married in 1955. He converted to Islam to marry Hamama and took the name Omar al-Sharif. The couple had one child (Tarek Sharif, who was born in 1957 and portrayed the young Zhivago in the eponymous picture) and divorced in 1974. Sharif never remarried. Beginning in the 1960s, Sharif earned a reputation as one of the world's best known contract bridge players. In the 1970s and '80s, he co-wrote a syndicated newspaper bridge column for the Chicago Tribune. Sharif also wrote several books on bridge and has licensed his name to a bridge computer game, "Omar Sharif Bridge", which has been marketed since 1992. Sharif told the press in 2006 that he no longer played bridge, explaining, "I decided I didn't want to be a slave to any passion any more except for my work. I had too many passions, bridge, horses, gambling. I want to live a different kind of life, be with my family more because I didn't give them enough time." As an actor, Sharif had made a comeback in 2003 playing the title role of an elderly Muslim shopkeeper in the French film Monsieur Ibrahim (2003). For his performance, he won the Best Actor Award at the Venice Film Festival and the Best Actor César, France's equivalent of the Oscar, from the Académie des Arts et Techniques du Cinéma.	0	Alexandria, Egypt	Omar Sharif
400	1944-07-31	\N	​From Wikipedia, the free encyclopedia.  \n\nGeraldine Leigh Chaplin (born July 31, 1944) is an English-American actress and the daughter of Charlie Chaplin.\n\nDescription above from the Wikipedia article Geraldine Chaplin, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Santa Monica, California, United States	Geraldine Chaplin
522	1925-04-14	2002-07-09	Rodney Stephen "Rod" Steiger (April 14, 1925 – July 9, 2002) was an American actor known for his performances in such films as In the Heat of the Night, Oklahoma!, Waterloo, The Pawnbroker, On the Waterfront, The Harder They Fall, Doctor Zhivago, and Jesus of Nazareth.\n\nDescription above from the Wikipedia article Rod Steiger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Westhampton, New York, USA	Rod Steiger
14012	1923-05-24	1986-11-16	From Wikipedia, the free encyclopedia\n\nSiobhán McKenna (May 24, 1923 – November 16, 1986) was an Irish stage and screen actress.\n\nDescription above from the Wikipedia article Siobhán McKenna, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Belfast, Northern Ireland, UK	Siobhán McKenna
12689	1902-12-19	1983-10-10	From Wikipedia, the free encyclopedia.\n\nSir Ralph David Richardson (19 December 1902 – 10 October 1983) was an English actor, one of a group of theatrical knights of the mid-20th century who, though more closely associated with the stage, also appeared in several classic films.\n\nRichardson first became known for his work on stage in the 1930s. In the 1940s, together with Laurence Olivier, he ran the Old Vic company. He continued on stage and in films into the early 1980s and was especially praised for his comedic roles. In his later years he was celebrated for his theatre work with his old friend John Gielgud. Among his most famous roles were Peer Gynt, Falstaff, John Gabriel Borkman and Hirst in Pinter's No Man's Land.\n\nDescription above from the Wikipedia article Ralph Richardson, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Tivoli Road, Cheltenham, Gloucestershire, England, UK	Ralph Richardson
14014	1920-03-11	1992-04-11		0		Gérard Tichy
14016	1918-10-13	1973-01-30	From Wikipedia, the free encyclopedia.  John Joseph "Jack" MacGowran (October 13, 1918 – January 31, 1973) was an Irish character actor, whose last film role was as the alcoholic director Burke Dennings in The Exorcist. He was probably best known for his work with Samuel Beckett.\n\nDescription above from the Wikipedia article Jack MacGowran , licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Dublin, Ireland	Jack MacGowran
14017	1928-02-14	\N		0		Mark Eden
14018	1907-07-08	1977-07-22		0		Erik Chitty
14277	1926-10-18	1991-11-23	​From Wikipedia, the free encyclopedia\n\nNikolaus Karl Günther Nakszyński, best known as Klaus Kinski (18 October 1926 – 23 November 1991), was a German actor. He appeared in over 130 films, and is perhaps best-remembered as a leading role actor in Werner Herzog films: Aguirre, the Wrath of God (1972), Nosferatu (1979), Woyzeck (1979), Fitzcarraldo (1982) and Cobra Verde (1987).\n\nDescription above from the Wikipedia article Klaus Kinski, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Zoppot, Free City of Danzig, Germany	Klaus Kinski
47754	1942-03-14	\N	From Wikipedia, the free encyclopedia.  Rita Tushingham (born 14 March 1942; erroneously reported by some sources as 1940,[1] Liverpool, Lancashire, England) is a noted English actress.\n\nDescription above from the Wikipedia article Rita Tushingham, licensed under CC-BY-SA,full list of contributors on Wikipedia.	0	Garston, Liverpool, Merseyside, England, UK	Rita Tushingham
14011	1937-02-25	\N	​From Wikipedia, the free encyclopedia.  \n\nSir Thomas Daniel "Tom" Courtenay (born 25 February 1937) is an English actor who came to prominence in the early 1960s with a succession of films including The Loneliness of the Long Distance Runner (1962), Billy Liar (1963), and Dr. Zhivago (1965). Since the mid-1960s he has been known primarily for his work in the theatre. Courtenay received a knighthood in February 2001 for forty years' service to cinema and theatre. Courtenay is the President of Hull City A.F.C.'s Official Supporters Club. In 1999, he was awarded an honorary doctorate by Hull University.\n\nDescription above from the Wikipedia article Tom Courtenay, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Hull, England	Tom Courtenay
63000	1928-02-23	2014-12-29	From Wikipedia, the free encyclopedia\n\nBernard Kay (Born 23 February 1928, Bolton, England) is a British actor with an extensive theatre, television and film repertoire.\n\nKay began his working life as a reporter on Bolton Evening News, and a stringer for The Manchester Guardian. He was conscripted in 1946 and started acting in the army. Kay gained a scholarship to study at the Old Vic Theatre School and became a professional in 1950, as a member of the company which reopened the Old Vic after WW2.\n\nHe has appeared in hundreds of TV productions including Emmerdale Farm, The Champions, The Cellar and the Almond Tree, Clayhanger, A Very British Coup, Casualty, Casualty 1909, Doctors, Z-Cars, Coronation Street and Foyle's War. He portrayed Captain Stanley Lord of the SS Californian in the BBC dramatisation 'Trial by Inquiry: Titanic' in 1967; and he played the bandit leader Cordova in Zorro television episode "Alejandro Rides Again" in 1991 which was filmed in Madrid, Spain. Kay also gave a sympathetic performance as Korporal Hartwig in an early episode of "Colditz".\n\nHe has appeared four times in the Doctor Who series in various roles, most notably as Saladin in the classic Doctor Who story The Crusade in 1965, alongside William Hartnell and Julian Glover. He also appeared in the serial The Dalek Invasion of Earth (1964), The Faceless Ones (1967) and Colony in Space (1971). In 2006, he guest-starred in the Doctor Who audio adventure Night Thoughts.\n\nHis most famous film appearance was his turn as a Bolshevik leader in Doctor Zhivago (1965). (He commuted between Madrid and London to play Saladin during this stint.)\n\nHe has also acted extensively on the stage. In 1952, for the Nottingham Rep, he learned, rehearsed, and played Macbeth in less than 24 hours. In 1984, he played Shylock in a British Council tour of Asia, ending in Baghdad, in the middle of the Iraq/Iran war. Other theatre includes An Inspector Calls (Garrick Theatre), Macbeth (Nottingham Playhouse), Titus Andronicus (European Tour), A Man for all Seasons (International Tour), The Merchant of Venice (International Tour), Galileo (Young Vic), Death of a Salesman (Lyric Theatre, Belfast) and Halpern and Johnson (New End Theatre). He has twice appeared at the Finborough Theatre, London - in 2006 in After Haggerty and in 2010 in Dream of the Dog.\n\nHe was married to Patricia Haines (first wife of Michael Caine) from 1963 until her death in 1977.\n\nDescription above from the Wikipedia article Bernard Kay, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Bolton, England	Bernard Kay
10462	1916-08-21	2005-11-03	From Wikipedia, the free encyclopedia\n\nGeoffrey Keen (21 August 1916 – 3 November 2005) was an English actor who appeared in supporting roles in many famous films.\n\nDescription above from the Wikipedia article Geoffrey Keen, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Wallingford, Oxfordshire, England, UK	Geoffrey Keen
2265	1930-11-13	\N	​From Wikipedia, the free encyclopedia\n\nAdrienne Corri (born 13 November 1930 in Edinburgh, Scotland) is an actress of Italian parentage.\n\nShe is probably best known for her role as the rape victim Mrs. Alexander in the 1971 Stanley Kubrick film A Clockwork Orange, and for her appearances as Valerie in Jean Renoir's The River (1951) and as Lara's mother in David Lean's Dr. Zhivago (1965). She appeared in many horror and suspense films in the 1950s until the 1970s including Devil Girl from Mars, The Tell-Tale Heart, A Study in Terror and Vampire Circus. She also appeared as Therese Duval in Revenge of the Pink Panther. She also was in the 1969 science fiction movie Moon Zero Two and in the 1969 Twelfth Night, directed by John Sichel, as the Countess Olivia opposite Alec Guinness as Malvolio.\n\nHer numerous television credits include Angelica in Sword of Freedom (1958), a regular role in A Family At War and You're Only Young Twice, a 1971 television play by Jack Trevor Story, as Mena in the Doctor Who story "The Leisure Hive" and guest starred as the mariticidal Liz Newton in the UFO episode "The Square Triangle".\n\nShe had a major stage career. There is a story that, when the audience booed on the first night of John Osborne's The World Of Paul Slickey, Corri responded with her own abuse: she raised two fingers to the audience and shouted "Go fuck yourselves".\n\nCorri has married and divorced twice, to the actors Daniel Massey (1961-1967) and Derek Fowlds.\n\nHer book The Search for Gainsborough (Jonathan Cape: 1984) contained much original research, including examination of banking records, and made a plausible case for 1726 as his birth year.\n\nDescription above from the Wikipedia article  Adrianne Corri, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Edinburgh, Scotland, UK	Adrienne Corri
730346	\N	\N		0		Roger Maxwell
90627	1909-10-08	\N		0		Wolf Frees
111326	1901-06-30	1990-10-15		0		Gwen Nelson
102153	1912-07-22	2003-04-16		1		Lilí Murati
199919	1904-08-09	1976-02-24		2	Ipoh, Malaysia	Peter Madden
941312	1906-05-08	1991-07-24		0		Luana Alcañiz
37796	\N	\N		0		Emilio Carrer
100901	1919-11-10	1999-11-06		0	 Barcelona, Catalonia, Spain	José María Caffarel
1443973	\N	\N		0		Catherine Ellison
32830	1929-06-13	2009-09-19		0		Víctor Israel
1545347	\N	\N		0		Inigo Jackson
1436363	\N	\N		0		Leo Lähteenmäki
231021	1923-07-14	\N		0		María Martín
14822	1903-05-03	1982-08-09		0	Matalascañas, Huelva, Andalucía, Spain	José Nieto
32130	1940-03-02	2015-02-11		0		Ricardo Palacios
83739	1937-11-21	2010-11-23	Best known as Hammer Films most seductive female vampire of the early 1970s, the Polish born Pitt possessed dark, alluring features and a sexy figure that made her just right for Gothic horror! Ingrid Pitt (born Ingoushka Petrov) survived WWII and became a well known actress on the East Berlin stage, however she didn't appear on screen until well into her twenties. She appeared in several minor roles	0	Warsaw, Poland	Ingrid Pitt
1375376	1923-02-08	2015-04-03		2	Paddington, London, England, UK	Robert Rietty
14168	1925-12-28	2002-02-01	Hildegard Frieda Albertine Knef (December 28, 1925 - February 1, 2002) was a German actress, singer and writer.  Description above from the Wikipedia article Hildegard Knef, licensed under CC-BY-SA, full list of contributors on Wikipedia	1	Ulm, Germany	Hildegard Knef
14169	1907-03-13	1990-06-01		0	Berlin - Germany	Wilhelm Borchert
14170	1905-06-19	1983-05-13		0		Erna Sellmer
14171	1900-01-03	1969-09-17		0	Stettin, Pomerania	Arno Paulsen
14173	1935-07-06	\N		0		Michael Günther
14174	\N	\N		0		Christian Schwarzwald
14175	1870-11-21	1948-09-08		0		Robert Forsch
14176	1891-01-03	1975-08-01		0		Elly Burgmer
14177	1886-03-01	1982-03-13		0		Marlise Ludwig
14178	\N	\N		0		Hilde Adolphi
14179	1897-05-03	1983-05-20		0		Albert Johannes
14180	1900-10-10	1984-10-11		1	Berlin, Germany	Ursula Krieg
14181	\N	\N		0		Wolfgang Dohnberg
14182	1886-03-06	1960-05-13		0		Ernst Stahl-Nachbaur
14183	\N	\N		0		Wanda Peters
14184	\N	\N		0		Christiane Hanson
14185	\N	\N		0		Käthe Jöken-König
14158	1906-10-09	1984-01-19		2	Saarbrücken, Germany	Wolfgang Staudte
14161	\N	\N		0		Friedl Behn-Grund
14162	\N	\N		0		Eugen Klagemann
14163	1911-11-02	2003-11-05		2	Berlin, Germany	Hans Heinrich
14164	\N	\N		0		Dr. Klaus Jungk
13887	\N	\N		0		Otto Hunte
14165	\N	\N		0		Bruno Monden
14166	\N	\N		0		Gertraud Recke
14167	\N	\N		0		Ernst Roters
14186	\N	\N		0		Herbert Uhlich
14187	\N	\N		0		Willi Herrmann
11640	\N	\N		0		Max Sablotzki
15758	1970-03-18	\N	Dana Elaine Owens was born on March 18, 1970 in Newark, New Jersey. Better known by her stage name Queen Latifah, she is a rapper, actress and singer. Queen Latifah's work in music, film and television has earned her a Golden Globe award, two Screen Actors Guild Awards, two Image Awards, a Grammy Award, six additional Grammy nominations, an Emmy Award nomination and an Academy Award nomination. From 1993-1998, Latifah had a starring role on Living Single. She began her film career in supporting roles in the 1991 and 1992 films House Party 2, Juice and Jungle Fever. Later, Latifah appeared in the 1996 box-office hit, Set It Off and subsequently had a supporting role in the Holly Hunter film Living Out Loud (1998). She also played the role of Thelma in the 1999 movie The Bone Collector, alongside Denzel Washington and Angelina Jolie. Although she had already received some critical acclaim, she gained mainstream success after being cast as Matron "Mama" Morton in the Oscar-winning film adaptation of the musical Chicago (2002). Latifah received an Academy Award nomination for Best Actress in a Supporting Role. Since then, she has starred in a number of popular films including; Bringing Down the House, with Steve Martin, Taxi, Beauty Shop, Hairspray and Last Holiday. In 2007, she produced the film The Perfect Holiday starring Morris Chestnut and Gabrielle Union. Her most recent films include; Just Wright (2010), The Dilemma (2011) and she is set to reprise her role in the next installment of the animated film, Ice Age.	1	Newark, New Jersey, USA 	Queen Latifah
57599	1976-10-03	\N	Seann William Scott (born October 3, 1976) is an American actor and comedian. He is most widely known for having played Steve Stifler in the American Pie series of teen sex comedy films. He is also known for his roles in the films Final Destination, Road Trip, Dude, Where's My Car?, Evolution, The Rundown, The Dukes of Hazzard, Role Models, and Cop Out.\n\nDescription above from the Wikipedia article Seann William Scott, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Cottage Grove, Minnesota, USA	Seann William Scott
15760	1986-11-10	\N	From Wikipedia, the free encyclopedia.\n\nJoshua Michael "Josh" Peck (born November 10, 1986) is an American actor, comedian, director, and voice actor best known for playing Josh Nichols in the Nickelodeon live-action sitcom Drake &amp; Josh. He began his career as a child actor in the late 1990s and early 2000s, and became known to young audiences after his role on The Amanda Show. He has since acted in films such as Mean Creek, Drillbit Taylor, The Wackness, and Red Dawn.\n\nDescription above from the Wikipedia article Josh Peck, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Hell's Kitchen, New York, U.S.	Josh Peck
14991	1950-04-28	\N	From Wikipedia, the free encyclopedia.\n\nJames Douglas Muir "Jay" Leno  (born April 28, 1950) is an American stand-up comedian and television host.\n\nFrom 1992 to 2009, Leno was the host of NBC's The Tonight Show with Jay Leno. Beginning in September 2009, Leno started a primetime talk show, titled The Jay Leno Show, which aired weeknights at 10:00 p.m. (Eastern Time, UTC-5), also on NBC. After The Jay Leno Show was canceled in January 2010 amid a host controversy, Leno returned to host The Tonight Show with Jay Leno on March 1, 2010.\n\nDescription above from the Wikipedia article Jay Leno, licensed under CC-BY-SA, full list of contributors on Wikipedia	2	New Rochelle, New York, USA	Jay Leno
21200	1970-05-04	\N	William Emerson "Will" Arnett (born May 4, 1970) is a Canadian actor and comedian best known for roles as George Oscar "G.O.B." Bluth II on the Fox comedy Arrested Development and as Devon Banks on the NBC comedy 30 Rock. Since his success on Arrested Development, Arnett has landed major film roles. He recently played supporting roles in the comedy films Semi-Pro, Blades of Glory, and Hot Rod. He starred in 2006's Let's Go to Prison and 2007's The Brothers Solomon. Arnett has also done work as a voiceover artist for commercials, films, television programs, and video games.\n\nDescription above from the Wikipedia article Will Arnett, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Toronto, Ontario, Canada	Will Arnett
1086503	\N	\N		0		Caitlin Rose Anderson
1335105	\N	\N		0		Connor Anderson
46946	1934-12-30	\N	From Wikipedia, the free encyclopedia.\n\nJoseph Bologna (born December 30, 1934) is an American actor.\n\nDescription above from the Wikipedia article Joseph Bologna, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	0	Brooklyn, New York, U.S.	Joseph Bologna
1335106	\N	\N		0		Jack Crocicchia
7967	\N	\N		0		Peter DeSeve
42160	1998-01-28	\N	From Wikipedia, the free encyclopedia.\n\nAriel Winter Workman (born January 28, 1998), known in television shows and films as, Ariel Winter, is an American teen actress and singer. She is best known for her role as Alex Dunphy in the TV series Modern Family, for which she has won a Screen Actors Guild Award for Best Ensemble in a Comedy Series, along with the rest of the show's cast.\n\nDescription above from the Wikipedia article Ariel Winter, licensed under CC-BY-SA, full list of contributors on Wikipedia.​	1	Los Angeles, California	Ariel Winter
1215072	1965-07-19	\N	From Wikipedia, the free encyclopedia.Clea Lewis (born July 19, 1965) is an American actress, best known for her television role as Ellen's annoying friend Audrey Penney in Ellen DeGeneres' sitcom Ellen.\n\nLewis was born in Cleveland Heights, Ohio to a writer mother and a former vaudeville performer and lawyer father. Lewis graduated from Brown University in 1987. She and her husband, Peter Ackerman, have two sons, Stanley born in 2002 and Alvin born in 2005.\n\n Lewis has also appeared on The Fresh Prince of Bel-Air and Flying Blind. She also appeared in the first episode of Friends, in which she played Frannie. She has appeared in numerous films, including Scotch &amp; Milk, The Rich Man's Wife, andDiabolique. In 2000 she did the voice of Amy Lawrence in Tom Sawyer. Lewis played Gina, a chatty ad agency worker, in 2007's Perfect Stranger. She also voiced various characters in the Nickelodeon cartoon SpongeBob SquarePants.  She also appeared on the short-lived Andy Barker, P.I. as Jenny Barker, the wife of the title character.  Her somewhat nasal, squeaky voice has meant a great deal of animation voice-over work for Lewis, including in both television (ABC's Saturday morning cartoon, Pepper Ann) and film (Ice Age: The Meltdown). She also recorded the book-on-CD for The Princess Diaries.	1	Cleveland Heights, Ohio, USA	Clea Lewis
15768	\N	\N		0		Tim Nordquist
239	\N	\N	​From Wikipedia, the free encyclopedia\n\nJon Vitti is an American writer best known for his work on the television series The Simpsons. He has also written for the King of the Hill and The Critic series, and has served as a consultant for several animated movies, including Ice Age (2002) and Robots (2005). He is one of the eleven writers of The Simpsons Movie and also responsible for the film adaptation of Alvin and the Chipmunks.\n\nVitti is a graduate of Harvard University, where he wrote for and was president with Mike Reiss of the Harvard Lampoon. He was also very close with Conan O'Brien while at Harvard. Prior to joining The Simpsons, he had a brief stint with Saturday Night Live. He described his experiences on a DVD commentary as "a very unhappy year". After leaving The Simpsons' writing staff in its fourth season, Vitti wrote for the HBO series The Larry Sanders Show. He is now working on The Office in the seventh season and has written the episode, Viewing Party.\n\nHe is the second most prolific writer for The Simpsons; his 25 episodes place him after John Swartzwelder, who wrote 59 episodes.\n\nVitti has also used the pseudonym Penny Wise. Vitti used the pseudonym for episodes "Another Simpsons Clip Show" and "The Simpsons 138th Episode Spectacular" because he did not want to be credited for writing a clip show as expressed on Simpsons DVD commentaries (though his name was credited for writing the first Simpsons clip show "So It's Come to This: A Simpsons Clip Show").\n\nOn the season four Simpsons episode "The Front," Jon Vitti is caricatured as a Harvard graduate who gets fired from I&amp;S Studios for penning mediocre episodes and gets hit on the head with a name plate by his boss, Roger Meyers.\n\nHis wife, Ann, is the sister of fellow The Simpsons writer George Meyer (who was also a Saturday Night Live writer-turned-Simpsons writer who did not like working on SNL). He is a distant cousin of Los Angeles Lakers trainer Gary Vitti, award-winning author Jim Vitti, and actor Michael Dante (the stage name of Ralph Vitti).\n\nDescription above from the Wikipedia article Jon Vitti, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0		Jon Vitti
15769	\N	\N		0		Yujin Ito
15770	\N	\N		0		Ben Sanders
1217416	\N	\N		0		Bob Camp
1453938	\N	\N		0		Arun Ram-Mohan
1447310	\N	\N		0		Jeannine Berger
1100	1947-07-30	\N	Arnold Alois Schwarzenegger (born July 30, 1947) is an Austrian-American former professional bodybuilder, actor, model, businessman and politician who served as the 38th Governor of California (2003–2011). Schwarzenegger began weight training at 15. He was awarded the title of Mr. Universe at age 20 and went on to win the Mr. Olympia contest a total of seven times. Schwarzenegger has remained a prominent presence in the sport of bodybuilding and has written several books and numerous articles on the sport. Schwarzenegger gained worldwide fame as a Hollywood action film icon, noted for his lead roles in such films as Conan the Barbarian, The Terminator, Commando and Predator. He was nicknamed the "Austrian Oak" and the "Styrian Oak" in his bodybuilding days, "Arnie" during his acting career and more recently the "Governator" (a portmanteau of "Governor" and "Terminator"). As a Republican, he was first elected on October 7, 2003, in a special recall election (referred to in Schwarzenegger campaign propaganda as a "Total Recall") to replace then-Governor Gray Davis. Schwarzenegger was sworn in on November 17, 2003, to serve the remainder of Davis's term. Schwarzenegger was then re-elected on November 7, 2006, in California's 2006 gubernatorial election, to serve a full term as governor, defeating Democrat Phil Angelides, who was California State Treasurer at the time. Schwarzenegger was sworn in for his second term on January 5, 2007.\n\nDescription above from the Wikipedia article Arnold Schwarzenegger, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Thal, Styria, Austria	Arnold Schwarzenegger
14698	1964-01-13	\N	From Wikipedia, the free encyclopedia.\n\nPenelope Ann Miller (born January 13, 1964 as Penelope Andrea Miller), sometimes credited as Penelope Miller, is an American actress. She began her career on Broadway, and starred in several major Hollywood films, particularly in the early 1990s, and has continued appearing in supporting roles in both film and television.\n\nDescription above from the Wikipedia article Penelope Ann Miller, licensed under CC-BY-SA, full list of contributors on Wikipedia	0	Los Angeles, California, USA	Penelope Ann Miller
14562	1920-11-21	1988-08-05	From Wikipedia, the free encyclopedia.\n\nRalph Meeker (21 November 1920 – 5 August 1988) was an American stage and film actor best-known for starring in the 1953 Broadway production of Picnic, and in the 1955 film noir cult classic Kiss Me Deadly.\n\nDescription above from the Wikipedia article Ralph Meeker, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Minneapolis, Minnesota, United States	Ralph Meeker
14563	1890-02-18	1963-10-29	​From Wikipedia, the free encyclopedia\n\nAdolphe Jean Menjou (February 18, 1890 – October 29, 1963) was an American actor. His career spanned both silent films and talkies, appearing in such films as The Sheik, A Woman of Paris, Morocco, and A Star is Born. He was nominated for an Academy Award for The Front Page in 1931.\n\nDescription above from the Wikipedia article Adolphe Menjou, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Pittsburgh, Pennsylvania, USA	Adolphe Menjou
14564	1899-08-29	1973-07-02	​From Wikipedia, the free encyclopedia\n\nGeorge Peabody Macready, Jr. (August 29, 1899 – July 2, 1973), was an American stage, film, and television actor often cast in roles as polished villains.\n\nDescription above from the Wikipedia article George Macready, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Providence Rhode Island, USA	George Macready
14565	1914-02-17	1959-09-14	​From Wikipedia, the free encyclopedia.\n\nWayne Morris  (February 17, 1914 – September 14, 1959), born Bert DeWayne Morris in Los Angeles, was an American film and television actor, as well as a decorated World War II fighter ace. He appeared in many notable films, including Paths of Glory (1957), The Bushwackers (1952) and the title role of Kid Galahad in 1937. While filming Flight Angels (1940), Morris became interested in flying and became a pilot. With war in the wind, he joined the Naval Reserve and became a Navy flier in 1942, leaving his film career behind for the duration of the war. Flying the F6F Hellcat off the aircraft carrier USS Essex, Morris shot down seven Japanese planes and contributed to the sinking of five ships. He was awarded four Distinguished Flying Crosses and two Air Medals. Morris was considered by the Navy as physically 'too big' to fly fighters. After being turned down several times as a fighter pilot, he went to his brother in law, Cdr. David McCampbell, imploring him for the chance to fly fighters. Cdr. McCampbell said "Give me a letter." He flew with the VF-15, the famed "McCampbell Heroes." He married Patricia O'Rourke, an Olympic swimmer, and sister to B-movie actress Peggy Stewart. Following the war, Morris returned to films, but his nearly four-year absence had cost him his burgeoning stardom. He continued to act in movies, but the pictures, for the most part, sank in quality. Losing his boyish looks but not demeanor, Morris spent most of the fifties in low-budget westerns. He made an unusual career move in 1957, making his Broadway debut as a washed-up boxing champ in William Saroyan's The Cave Dwellers. He also appeared as a weakling in Stanley Kubrick's Paths of Glory (1957). Morris suffered a massive heart attack while visiting aboard the aircraft carrier USS Bon Homme Richard in San Francisco Bay and was pronounced dead after being transported to Oakland Naval Hospital in Oakland, California. He was 45. He was buried at Arlington National Cemetery.\n\nDescription above from the Wikipedia article Wayne Morris (American actor), licensed under CC-BY-SA, full list of contributors on Wikipedia	2	Los Angeles, California, USA	Wayne Morris
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
240	1928-07-26	1999-03-07	Stanley Kubrick (July 26, 1928 – March 7, 1999) was an American film director, writer, producer, and photographer who lived in England during most of the last four decades of his career. Kubrick was noted for the scrupulous care with which he chose his subjects, his slow method of working, the variety of genres he worked in, his technical perfectionism, and his reclusiveness about his films and personal life. He maintained almost complete artistic control, making movies according to his own whims and time constraints, but with the rare advantage of big-studio financial support for all his endeavors. Kubrick's films are characterized by a formal visual style and meticulous attention to detail—his later films often have elements of surrealism and expressionism that eschews structured linear narrative. His films are repeatedly described as slow and methodical, and are often perceived as a reflection of his obsessive and perfectionist nature. A recurring theme in his films is man's inhumanity to man. While often viewed as expressing an ironic pessimism, a few critics feel his films contain a cautious optimism when viewed more carefully.\n\nThe film that first brought him attention to many critics was Paths of Glory, the first of three films of his about the dehumanizing effects of war. Many of his films at first got a lukewarm reception, only to be years later acclaimed as masterpieces that had a seminal influence on many later generations of film-makers. Considered especially groundbreaking was 2001: A Space Odyssey noted for being both one of the most scientifically realistic and visually innovative science-fiction films ever made while maintaining an enigmatic non-linear storyline. He voluntarily withdrew his film A Clockwork Orange from England, after it was accused of inspiring copycat crimes which in turn resulted in threats against Kubrick's family. His films were largely successful at the box-office, although Barry Lyndon performed poorly in the United States. Living authors Anthony Burgess and Stephen King were both unhappy with Kubrick's adaptations of their novels A Clockwork Orange and The Shining respectively, and both authors were engaged with subsequent adaptations. All of Kubrick's films from the mid-1950s to his death except for The Shining were nominated for Oscars, Golden Globes, or BAFTAs. Although he was nominated for an Academy Award as a screenwriter and director on several occasions, his only personal win was for the special effects in 2001: A Space Odyssey.\n\nEven though all of his films, apart from the first two, were adapted from novels or short stories, his works have been described by Jason Ankeny and others as "original and visionary". Although some critics, notably Andrew Sarris and Pauline Kael, frequently disparaged Kubrick's work, Ankeny describes Kubrick as one of the most "universally acclaimed and influential directors of the postwar era" with a "standing unique among the filmmakers of his day."\n\nDescription above from the Wikipedia article Stanley Kubrick, licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Manhattan, New York, US	Stanley Kubrick
14554	\N	\N		0		Humphrey Cobb
10769	1922-12-23	1995-02-21	From Wikipedia, the free encyclopedia\n\nCalder Baynard Willingham, Jr. (December 23, 1922 - February 19, 1995) was an American novelist and screenwriter. He cowrote several notable screenplays, including Paths of Glory (1957) and One-Eyed Jacks (1961).\n\nWillingham and Buck Henry were co-credited (but did not collaborate) on the screenplay for The Graduate (1967), which they adapted separately from a novel by Charles Webb; they won a BAFTA Award for Best Screenplay for their work and were also nominated for an Oscar.\n\nDescription above from the Wikipedia article Caroline D'Amore, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Atlanta, Georgia	Calder Willingham
3335	\N	\N		0		Jim Thompson
3350	1928-02-13	\N		0		Gerald Fried
14555	\N	\N		0		Georg Krause
14556	\N	\N		0		Eva Kroll
14557	\N	\N		0		Ludwig Reiber
11926	\N	\N		0		Ilse Dubois
14947	1950-07-26	\N	​From Wikipedia, the free encyclopedia.  \n\nSusan Melody George (born 26 July 1950) is an English actress, movie and television show producer.\n\nDescription above from the Wikipedia article Susan George (actress)  licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	London, England, UK	Susan George
386	1923-04-04	2016-12-06		2	Wem, Shropshire, England	Peter Vaughan
14948	1929-09-07	2011-02-13		0		T. P. McKenna
14949	1938-12-17	\N		0		Del Henney
14950	1938-01-04	\N	Jim Norton is an Irish character actor.	0	Dublin - Ireland	Jim Norton
14951	1933-03-12	\N		0		Donald Webster
7194	1943-11-24	\N		2	Leslie, Fife, Scotland, UK	Ken Hutchison
14952	\N	\N		0		Len Jones
14953	1950-04-03	\N		0		Sally Thomsett
14954	\N	\N		0		Robert Keegan
14955	1920-09-29	1983-08-01		0		Peter Arne
14956	\N	\N		0		Cherina Schaer
14957	1934-07-04	\N		0		Colin Welland
2076	1941-07-29	\N	​From Wikipedia, the free encyclopedia David Warner (born 29 July 1941) is an English actor, who is known for playing sinister or villainous characters, both in film and animation. Description above from the Wikipedia David Warner (actor), licensed under CC-BY-SA, full list of contributors on Wikipedia.	2	Manchester, England, UK	David Warner
7767	1925-02-21	1984-12-28	From Wikipedia, the free encyclopedia.\n\nDavid Samuel "Sam" Peckinpah (February 21, 1925 – December 28, 1984) was an American filmmaker and screenwriter who achieved prominence following the release of the Western epic The Wild Bunch (1969). He was known for the innovative and explicit depiction of action and violence, as well as his revisionist approach to the Western genre.\n\nPeckinpah's films generally deal with the conflict between values and ideals, and the corruption of violence in human society. He was given the nickname "Bloody Sam" owing to the violence in his films. His characters are often loners or losers who desire to be honorable, but are forced to compromise in order to survive in a world of nihilism and brutality.\n\nPeckinpah's combative personality, marked by years of alcohol and drug abuse, has often overshadowed his professional legacy. Many of his films were noted for behind-the-scenes battles with producers and crew members, damaging his reputation and career during his lifetime. Many of his films, such as Straw Dogs (1971), Pat Garrett &amp; Billy the Kid (1973) and Bring Me the Head of Alfredo Garcia (1974), remain controversial.\n\nDescription above from the Wikipedia article Sam Peckinpah, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Fresno, California, United States	Sam Peckinpah
14940	\N	\N		0		Gordon Williams
14941	\N	2011-09-26	​From Wikipedia, the free encyclopedia.\n\nDavid Zelag Goodman is a film and television writer. His most prolific period was from the 1960s to the early 1980s. He was nominated for an Academy Award for Lovers and Other Strangers, though he did not win. He helped Sam Peckinpah write the screenplay for 1971's controversial Straw Dogs.\n\nDescription above from the Wikipedia article David Zelag Goodman, licensed under CC-BY-SA, full list of contributors on Wikipedia	0		David Zelag Goodman
14942	1932-04-21	2009-10-13		0		Daniel Melnick
7769	1922-06-17	1980-02-17		2	Pittsburgh, Pennsylvania, USA	Jerry Fielding
14944	1930-07-29	\N		2	The Hague, Zuid-Holland, Netherlands	John Coquillon
14141	1916-11-08	1977-07-02		0		Miriam Brickman
14945	\N	\N		0		Paul Davies
12685	\N	\N		0		Tony Lawson
1724	1945-01-05	\N	From Wikipedia, the free encyclopedia\n\nRoger Spottiswoode (born January 5, 1945) is a Canadian-born film director and writer, who began his career as an editor in the 1970s. He was born in Ottawa, Ontario. He has directed a number of notable films and television productions, including Under Fire (1983) and the 1997 James Bond film Tomorrow Never Dies starring Pierce Brosnan. Spottiswoode was one of the writing team responsible for 48 Hrs. starring Eddie Murphy and Nick Nolte. In 2000, he directed the science fiction action thriller The 6th Day starring Arnold Schwarzenegger.\n\nDescription above from the Wikipedia article Roger Spottiswoode, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Ottawa, Ontario, Canada	Roger Spottiswoode
10591	\N	\N		0		Ray Simm
14946	\N	\N		0		Ken Bridgeman
14965	1910-03-08	2000-04-08	​From Wikipedia, the free encyclopedia\n\nClaire Trevor (March 8, 1910 – April 8, 2000) was an Academy Award-winning American actress. She was nicknamed the "Queen of Film Noir" because of her many appearances in "bad girl” roles in film noir and other black-and-white thrillers. She appeared in over 60 films.\n\nDescription above from the Wikipedia article Claire Trevor, licensed under CC-BY-SA, full list of contributors on Wikipedia.	0	Brooklyn, New York, U.S.	Claire Trevor
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: moviedb; Owner: postgres
--

COPY review (movie_id, member_login, content, vote) FROM stdin;
2	IQ0VP7I4EQ	9BMCZK3X0Z8J0M639UNPT8QW2CS3TCE222606J2HY8GGCSMK615R18SBVZJX1ADXVFR8PG6Z1G0U1JUKZI71GXB4J5FHAFQX5TV6	1
2	HLAPWR5SVJ	O5Z5FZVH8JLF98TDMQ8EWYUBZZW0DZIYXIKMH6B7PXLV4BAH6UTCW2O0KYFQD5DIBWR0XG5PPAY9M8HXZP3SGGC44TCT0V4UTDUH	6
2	3122J53CUB	JT0YDWVDOOLQR0YBVC4TW6EEMZ4GEQJO9DP5C3DUQ1QF0CJ4FS8AZX7NPWMO1P98F7ROL2819KD5P8NJPAAVRIZLGBQQRZ2B2RA2	6
2	8OI9QT5AJF	5SNTHBOUC7QIC80ONQ6IGHJMSJKSCD88UYURXCKGK0ED9HO0BXOADUOXJBB716S89SYONJ0KF07PDFMK5TQOY74AK7IWANPOIFER	5
2	8MD6C924TO	AN26E5NW9TDY0BIPDKCXYDPADK2LTG8B405GYSUCRNKOE7KLH8F4B4567124CCD2UC4AGB1V0AGK3B6G9QEVBE9A48J6Z09PJR4C	1
2	QBAUG43EX0	JFFGTEBYUD55W4W8R1QC4FH246AA1BLH3C0K8OSA7MK5NBC6NQ20O9JE7MLXDA7T1YBTDL9CJQER5MP23EXKIV243VNWC466P0EY	1
2	2UYP83OU7H	T2BRZR841JU7S49NWKG5H0S7NAOTHCEI02KMW2TE49BL2YUA6T2P7232JDEZCOWYEMH0TX141CAHYGFYQOXYKZK78RCSY4BQMMHQ	5
2	M8LP7EJPJC	3QI27Y52VEC8PJY08OOBJ1CVIF6AU5L9ZHW7P5MBPFNN9UJVN0N82OHCOXT215H02DIHW0LDCNWDOZVY6KW4RNHK9UT1LUKU7WU6	3
2	OE7G4D95TQ	B8XOK6O1EXZC56QINJP67ICGT1RDCG2EYN4M9PGQ2T564ZQY3LUMEAN36R4TOLZ75UNSCEI8D8EOMFL4L3J0WPAYAAPSUXCQ47AK	4
2	44GWYVQ941	8VYDVIF68R0FAHUB8LQUYSBZ0NQ6XUOEBSNHUXAG42BSYMUPRO5VU0XQU9MI2JIOCWER3NQKLJZ5QSAN3BPIZ3TK57XUK1OUUXQC	3
2	WT1KWZC2VX	CVE7UKLA19B99P149YJC3W6Z59U5EL3C7E0PKKETIJD8WVLMW0U8HAPPZOBUZQ5QG9B4YLTZU03TT8DKXHIO1447ZL06IT31OX2X	5
2	XA2SEDHKA5	RYKH5NRG560L17SHRYLEEEMVWQB7BF6GP0GT7H6RN04O9URWKU68QTPNLZUOMUE0AU6B09KK231NJ7VC8PWRI7Z6K2HIWRF2WEOP	7
2	4UMCA9GGS5	Q5LJWGX1CDNDRQ67WRC59081BXKY81FTGNSTLHW1CEIY3EEBI59WMUY07TI8583K846E7NWP5K24RJ76SJQD2SGWY2W19X5DL709	2
2	OXSSA6KT74	AD5IU1B13IXVLPWR0SPYKPF05PHPYTUS8YSFV4I1F54T9GYHJVUPKL7V8FNETWCJYEWW7Q65KYTPUV1Y1AFC9EIX16HQRDHS2U54	5
2	RF62QV59AC	BJ2ZZFW2SAMNYNSR9KT694AJQNGQAW9Z7FZ0MNK9W5J64C30YB2KM7UGJTIL8F15BWQTX2EVATKDVEOOUQ293ZN9USR2F8BRDO4I	6
2	EXSGMP7BN4	KC66GJ2XQVEF31SM2BLJR8FKLQCS39HJG2KO5CWPULE7MXMHTELMT8EM6VU0HK4QN58AQDR0O5ZF3I7XE49ZY40HY8RKR6IJRXTR	7
2	DN5N8RS3G1	L0PXU7XJ8SYX7WMLE2TE1MSWGISXPXGYQ83EUCD7D8ZP3WUJ58M4AN79H3QLP93LL9H83I0CYVB3WD2TYI1RKLYDA360V1SDEOD3	4
2	TRFU14BD1F	VQXHKGOLEMEA6XGIMAAKE79M9Q6D8YI99ED2EJAFK15R10ZEL52NDSLXRKH3KKNQEFA1TODDA5AMBSVJ112C655Q3PL3BG49OPMV	7
2	HDAKH5P9W5	7V71ZMIS9V8Z8CSSKUIJU8DCKB3AA7WF9T3G4KGSX734MEDEMRD5DME9R4RXSISB930OJMX9N0WXEJ0G8ZXS40BWO3YA3T9OP25T	4
2	FFWE8F8F46	Y593DSNZR4IELZ3U9GI1DAPYXG40IHLNG2J3XZ0IX768P5R3G3PVX2JYQLG7XXRJT47SPA7KQ9DGDQI1YAUO2Z0OSVNMS3VAPWPU	9
3	IQ0VP7I4EQ	9OF6FFYYDU9DOIXDCR3ESA3WU1WOC0QAX2ZWOSWTCZOANIEU86NEWQP8UTLOSKVNE8QVTAZU5JC3V2IMXCPGNLNGN0B5GIB2DB6P	8
3	HLAPWR5SVJ	SA7H3JNOWN1K91Q4PA2VJI383NWIJZT63UEBS8UBA20NKVHRU8XBD3SKH8NPWFE635QPWPLRQ0URRPYIGFXLBS29B33UUEP5X3TO	2
3	3122J53CUB	24FWGVMJB21JFJRR35LDQN2V07LLZ3X6KENKSY56P09BBKP57N48ILYOBT5IKATIE59B5G9E9OXZN1TQSQOM8ZY8P8I82XWOG16F	3
3	8OI9QT5AJF	O90O093Y8BK9P04WHJPHAV77AMM1ITW5NEEQX7IZ4KR788M6229RQ8L2C3NNXCPPOOVLWN9JB0NZD98C9P8QUFOP3LO4U4C15CSU	4
3	8MD6C924TO	BKP2ZQ0UVZC4KOHD84J9GRL9FYGXV4BQO08FTY4ZY4HWL9KQ5Y6HJUGT8QXAJC91XVPUQBTKAULLJZXFO02683H4TOHDA4PW5Q80	6
3	QBAUG43EX0	Z93FVHZJ4JJ3SWSKC24OUAC4PKGEYQ316UY081MWSVZE7KSH6M2YEL9Z79ZLBUUNQS6772LKPH69L76F18IMXEWUV938CBV7BLYP	4
3	2UYP83OU7H	VKEARI6PAOACTTCMHZL5LM79MIOW889JR1GXDMG60FVV26SSSV4VMTCJMFXJ4KRBO1U2MPI4TOEG0MGQZ5DMDN68Y7K8Z7CQYTGB	3
3	M8LP7EJPJC	0FDM9C7O6SA8GT8GE7B4WDPEKFWMYRHFFF9ZAAEL8T2OK9SNDKUVFGYW09B4PV0OK43BTJGD3Z6DKA3LWIIO7WA9QM9A8J5N3NEQ	2
3	OE7G4D95TQ	R34DQ1PKVMZG0IHMLRY33UHJFFU4SK76NFFONKR4UZ5AK4IBYAR6QWM6WV8KHV1LO33UC39B93IEZH9K7SGR3AQ02J12MGX97UVQ	1
3	44GWYVQ941	X94BP7WNIGPVXNZPJRONC23BGY3GJGFVSJKTLQND3MUCMGZ38TYCGD85F340DQDCB3DNDFE3ELU0H1YA99I0SDOPKPNRVW9MISBS	1
3	WT1KWZC2VX	L02O475TIXOE31EINU8OXDX1XHSLHRZZF7XJPLXFS5B29M155D57DEPICA1WPUL17Y96D42B6251B52KPWQEV1WBSPHPTAZ8UK4K	4
3	XA2SEDHKA5	51AK3BKIXGGHRG2DHFFB7NXXMR5D7H1BS6U5P320M35JAIC464NEYIQRDN8MFHKPOFZUW7YONOZDSOWEPBGC4XMJQC2C5QVFSP45	5
3	4UMCA9GGS5	RH9G80KTM9Y036DBIV12QETEWT73UVDU1V74G556CZDDDLBTRDJ4CCCNX4UP3R915E9H9J4MZ500AQBKROLQLIRYTUGLLQCU0MH9	4
3	OXSSA6KT74	4UIJ7EHLMMH3J7PFSQXWKXODTBJ2F9YJC8X3CHODJNHI9RBSXPI6UMBGFFZ65PFMX81LKVDLCTN7QGDB90E012YZ7QY7RRI3H4UB	7
3	RF62QV59AC	0HCL63A9DZ9BY6FKOV5JBN37F4ULT0WVCKISCP48X031Y53VCT2IZ1YNOFFCJZPNCN8NYWI906VLUCIKA9IA7O6LV5E7J2Z7KPYL	9
3	EXSGMP7BN4	P6PK2R2FN2L75BKRPPYQX13SL08HXAEO6NUC2ZE7EFIC3AN0OQ59A4IYD79CSVSNY7ARQIZZL0MST0ZKMH2HEENCE684ZCOSX4O6	1
3	DN5N8RS3G1	5KG1FYJR0FMIYZK2KJTT8NTJ49JM35YM3KQ7VQ8QDUO1VWBMDZMV4MCS066GP7X5QAPOINH4KDPN82XH87JESDRQI8HYT2AG6SLV	2
3	TRFU14BD1F	WD0SSL17YT7JYHSYTNMS8FKFSKRCIQQRCAM3TV920TUOJP4VSSNF8CIQ2UAI3YYHDQGY5YF8NU2PV56CP6T0DKTA15A8U18B5MK3	3
3	HDAKH5P9W5	G03NO2NK356Y827E8E37F69XGOWV0TJUC2JFZMZSF089DKW8B76IR6DJ0GHAF1TJVLVFT1OVPL1P89U51XU3WADGYAPTEYMNGYO1	7
3	FFWE8F8F46	QPKSK3GEYK0VLIRH0WUIPQSL4R08NIKV2GLIJKMH6BAZZ72P4FQB3TJ968X3CH0PAE3F7J7PKNMNQ3W6YKEI2I2J6LMLWSEYLUZU	2
28	IQ0VP7I4EQ	XSVIA1PG6TCL1F2DSX2LUIV6W32IXC5EB2A1T91RNCA1J95MMV266JUP6YWH8HT3Y8K8EATS5K8RH4XW7P5BJ8H2IV44NUSFSGDL	7
28	HLAPWR5SVJ	6ILCJAVLCHCB9JTLSTZ0S0SFYEL229B0L7BHT9A7VRGO23OL84AXOUHGZGNEZ3SDGMZCHM1TT1EAUEN509388NM0Z5RNV5I28CIP	1
28	3122J53CUB	LDWCQDWPGVV2ROZ9UE298MM4N7YTMCR572O5H5RKZLTJ5UERS3O8QPE811YTPDDEE04Z931ZWRJX3C933GBSYSPSXQEQG85WHOFF	7
28	8OI9QT5AJF	PSYBYL8FQEY250IBUPVKMBTZLSYWWPP73COYMR9GQMGLQXKIWUX8T5NN99ZGXLTBZ092MTZDQO4A4HJYHP9B2QN8ZAZN13SE3FVZ	7
28	8MD6C924TO	R5D5USFANS1ZB8IMRIJMBDL3LLX5ZHZWT9ZT6GH7I7MS8XZ4K2M6LMXOUJTI5KLF2EGCIYPKBMED135YW2U753KHML9WW9C8WGZ3	5
28	QBAUG43EX0	XWWMB59ITW1O5VCZNK949Z6Y3YBJGRUDBG9G7U47K83YHH0N9II6Z9S8Z7SM30CBCYNYW613QCTA5IRW7XJ7JYNCYARABRDU62WT	8
28	2UYP83OU7H	B0DRPQXPRCQQ6OGQE2NKLAWO11889DDV7267GQ4I0WH8ATFC7E19IJSBEYZXRYQO95SESIJY8FTY2XOIW5B5LDMYJ42R0G0BG28F	1
28	M8LP7EJPJC	ATY4DBDZ4IQKRBVXVC5S44YQ281PSRAZIHVMMAIBJ8PVMGJFEOV0CXFF5ICEKYHMI1CJPJKU34I5PCEVYVKD5JWVBQQE8D1V1CMU	2
28	OE7G4D95TQ	904EB6IOK02ERQYNDQ9EQH93GWZCXENZTQY5Q94MNG1ZX9RXDIXVNPX21B7OHG1GNDUA127EWW1KQJFGFB9PQ1LD26EOBQFHPVMU	4
28	44GWYVQ941	Q6KLS91YNLS61JFHMZV1RH4YSDGRT456V1YFYD72UPPVWSJGAAD5127JCW2P3KETQVLAU9TI23GC2JCA39QT09E23PCBLR9KK5EA	2
28	WT1KWZC2VX	JWAR5C8W5Q3T2W33U2QQSGF6R6K3616EC3TMPC57GG88JST5FRZDXTYDRD982E0DTYR8DQNR7TKMHGX9NPYOB3QSEQ5LC6EBQ4OV	1
28	XA2SEDHKA5	U2YDIFEIL5KQAVMQLC0H84WVBOAOI6N1C83X9L3XMK2UV5BL2VF2YNB0FDB3FZAPSTOC2YQ9IC5YBCAGMYWX1UCY7DS6JARWKNCB	5
28	4UMCA9GGS5	9TDFFUWRMYCD5QRDMY7QZEYGT0IUIOY980NESRVAQHUOP2OTAT7YFV0547VPMCI8ADFFDNV5C69SUK00MYTZR94M9RJU6GYO8WOM	6
28	OXSSA6KT74	IQX8CWIVIKUG4DXSTRAI2FVDA85IVU76ODDH61PNW01HZNCDA6OFND4D5T7D09AXNY209QV2BXWCOOOX61HZF2SKIAMN3LWW0D3B	6
28	RF62QV59AC	LDUKWD0Q2YRFKG81KSUFSS9DI80AAMKUNCVYXOTZ23QL5HTEX4PVJ5C2EQCYNZQPN61HVKE695NYBYIAOVMG7ZKR92TGM5MCNA78	4
28	EXSGMP7BN4	MTNZSVOSO1QHCJ1MKSYVKI317TETKKA0KUCC9QOD69VBD9KVU0DSJMFDZW29R5HD0Z7RGZM3DVYKX2X8JS8UHSR7O8MNYOVB1RKN	1
28	DN5N8RS3G1	2O4NJOXX4Q783086X6IIADIN9FY9XTFRJ7QDDG8D3JTRPO4YWFDVCFBZGROEZYALKPY6K52R8EO0T07UKAMRPUPE607V13NEIHH9	7
28	TRFU14BD1F	8O1MWW70KGQU43ZMT60AUAT7GZE1JSLT74LWUF27RNVURB7AY2ZLQ9F844F6SGR247W9RD1ND2SHO9QE1DCR2AC8YM1095PK63ZU	4
28	HDAKH5P9W5	7SUBLHYQ8U5NAFOE9944XLFLBOHNIKUJ6Z3VSQQ2OR025M80AG645Z2WNI97ALHXAWRLL3VTTCQFUMQYPRMCO0NG6HIJQS2DJD2J	8
28	FFWE8F8F46	XPHUMK3IWCA2LST8FIJIKOEUMDAJN5RUG32BFRBPU7KEHQEAJFE4SBUILWIJKT50VPWS0R2XG3XME9N58AAI1WBFIT0TJ2EBCUT2	8
55	IQ0VP7I4EQ	WJ1MQXYNHELJMKKSX88ORJH0IOOZWKUPUBM0I5K8M2APPK6R4SPVVNNNCBDCJ907U5YL8TK1Y9BZI1L8R64E584HY9YH1IZMBD5T	6
55	HLAPWR5SVJ	VTKHX7VMYEKZFUMFVCVBRX94C9PJYXF62M6MT6HBI494ORWXMHQAKRE8UQEXRLXA8O72YAVY4T2WXEQVM16RGEWKH72D1UU6G96A	5
55	3122J53CUB	48MV2G0YSKQ9TK0OG431XU0IS6K96PYHQCS2U5O85VZXLDIJ3R9ECI5JIED5612CWITR274LP56C4D6OXBFOPTFIGIUP1SCD2WAD	6
55	8OI9QT5AJF	1Q6WYZGL3PEIYH4VNWCCLLUNPT632JIC346UJ11496M3QHDKHROA7AJQ6THE2NTUHBP4LJMW5IDO806IQVVK4HE3VQY0TWCVN2WO	8
55	8MD6C924TO	I97F2FZ64RFW9YG1IZ96VJ4VWCIGSBFERQHWYFBCP608TDU854FCXSG9FMS06TO3LAETQUCCY6QZS5CSSJKX6DR9JIRMWLG6S7WS	9
55	QBAUG43EX0	ARL1CO0BQQJKAIWI07ITEJIC0QM0UGVITTR2853Z0831HCWDTX19O941JJBWBARK5A0R14J4DT2GQQ4Y4JH6OV4TYZSZ4HX0RS6H	3
55	2UYP83OU7H	ELYN665HXK2OM213U5JFG2BLUA55CZ7UXMZ8SSRZ9MAP0LRP676XWBEMKN36AAF8NI0AC3KBNUG32WVISQ8E2K7VHNXFZVY8HBCS	6
55	M8LP7EJPJC	RMDW4JC4KTY1UOUBAFCKE2ZFFM26IW0UCXBD5S7A41638NEHD7H69HQYW7RSRGWY2EZ7MRFRHBPN56H1IV2KO4U5HMQ8BPTYEIA4	7
55	OE7G4D95TQ	H4W1ZZ71C200ZK6OLK8T3ZAAHQ1S1IX5MDA0FTYFWDETZILFXK28CL4R4WUI7PA4F5NVJFI2V360VQK9FW5QPZ2BJT6S8QHHDKO4	8
55	44GWYVQ941	06RB9MIOE6NLUDKUTOQCMMZJ03EVZWKCPEPZNOQMUXFWSGOM7WT682SNGILGIXYRWL6QYVHE8DSYGD0TP2YDDOEXWBTFDKE69XAG	3
55	WT1KWZC2VX	8XLPO84K3GDR20P8UOHHI3XCBBX9VZTCTIREMXYPJN24PXLTY7OJ29CEAJNNK4YDXB7TILW60275A2WO0EKXLJJUGNDCKLFPYZGO	7
55	XA2SEDHKA5	1KNLRTABHDHX9WGUB1O1MN5HTWOWSGLWIY937M4ZJS9J6PKY94X72WMNPG14ENTA2VOKWMXZ7YR3OVLELZXXTN3VLVN0U9V698RK	1
55	4UMCA9GGS5	9CWH8AEFS935WTOZ5QO139A86E7DV4PDAELXBPVNZQ2WU57QGGDRDSGABXL3CATYTZ4SH1YP5BCNGOOBGR6P07AR7LWNE2KY6DD4	1
55	OXSSA6KT74	PJOSYWBQ33XIJWVDE8VZMU6EKKD1NQCKUB1IR6CL9BER9F5FYU2FSEX5MKHNTKCN0MXI4NWH6KZLQOFFP7C2X72PN65HZY1Y800W	5
55	RF62QV59AC	WKL8VJHPLO8EC7VIK03UI48SOSHSBMZXSY3W03BYUABR7CW1FQYA7CI1M3UDBZO9ZKWOD9RQYF9H3QUL5PMUYZ0PPBK7J8W4WC2W	5
55	EXSGMP7BN4	IXG9HL2CB85IIHWM3KATG9CYTHZTFU0Y75X2FURN7NNDPYA09S212CJIVSPAWJ7QHGKNU4GJ3WW3V8J5G9TX1964VOGXER1YP66I	4
55	DN5N8RS3G1	XGFLT8FQQWXIU3X0KYIKP2FXTEM57OYCBRT2NLIA0OF1TOUXE8EIX784AS1PVJTB8UHDJ4N8QHTBWNDEUY19JQODTY24U3PR4D38	2
55	TRFU14BD1F	ROJVG1QO6IWOW56ST2RFDTUCSOX2CGSTF7CKRODY8ZWQFQ77S8LLM3D73HC1EXLZZCJY2WAFY2HO7E7BQZJD5HHL4FQKLLUKO70C	2
55	HDAKH5P9W5	IF68FWTWZAZKBLOOH4S574WF04NH6A9N44HTMFZUXZFF19K9F6GDIGJOS0ILJLZYAMPGE4BCE7HHYRO0TNCA36EXV2BW7NLLAQFP	6
55	FFWE8F8F46	D5K4D8L9B0BMS15JZ5DH1UL3PF0W5HHM8FQS1FZ73YTC9JOVPCKVBH2STQO8IYD4SZNMLNSUFGODBJ4G0EG37WK1N78K11YEUZTK	8
81	IQ0VP7I4EQ	CKCT0Q43YRKWIHERJ66OW9OPH3ORJSLZUKY4EKHGQ7YPXXSTUXL2X5IC6WM7BNUFFUC7TJM9Z08ZK81TK56WHTCYBV8S7JECNSKC	6
81	HLAPWR5SVJ	V9LKLC67T2742WGQ78WSO57L4BPW5L1XZ8Y5VM5QF0S3AXFX7VPUYUHZC9PKWKCIBJF47L5VDFMXNELG62YJ6H9E193V6V34YK20	5
81	3122J53CUB	LZW03QSITM7YIO4W2L3KBC8SJZSMR9DMUYUDCSC0R5IX57XG9I588QRI0DQE8G1TIVEU30UJJC2F4LXMBLMIDFNDHLM8C82LEYOJ	8
81	8OI9QT5AJF	DNIYVY5XLOPQEDX3SPDHAMRNVHLKRAG6NS78EUSQSQ577R74FRVILC3154CNNUGKHTDWFZZ77WZUQUQEKQFAO8ULZGCJSEC7JUZN	4
81	8MD6C924TO	LZP1YKZMJKLO8D7OG5J9268WQP2T1K54C090ZI0X48Q505UBFSDZPOWO03LIRFU8ORLHDGZ7FWE3QC5V51OJGGOXEVA66SFZNRRJ	5
81	QBAUG43EX0	M793FU3K27X70M01L1ICXDSG2AWRPQ8VWBT4OPBWVNLXM9GFP7BZJH6IO2BE7M5L8CLY36M60VQJ25434QBROJMOELPWO6ZJS9YK	7
81	2UYP83OU7H	RMTUF9X0WQT8HKQKN7ZZ6TSQ0R36H12HTFMES6IJZYS46XGVI9EC8U183C4YF1T4XLPC8L2RYPAIBXUDKHXIXZI8NOLPCUE8EXHU	3
81	M8LP7EJPJC	EX7HWOSUT6GR1N7DLH8CQZUAMPELCDOQA4GU0BAL0O4RF8KGH43QIR2PD74HJHSPSZR6HMMKGWMB4C4OE7EHK7HSC1R3G2BS5O9P	5
81	OE7G4D95TQ	O84RSJWE0UACQDMDLEUR84Q5TENU3GPCO709JZ1YVOMGQ1ZZZPUJP7STR88O5BLUE8XTMM3VN66USKP2PY5OVGXRPGRL1M2UC1CS	1
81	44GWYVQ941	FMMV96SB7BHSG9HF688KGDG5S4ADMR0H7YJLS2WJEPREJ3UNVOG3DH7BGRDE6PZQL9US05WDLYF0WBWYJWS7L6D00HFBZRNZ0B3J	3
81	WT1KWZC2VX	CWZ1CSPCGPE5O5J61FP641T0VO3LPAVIMQGA3FIOYXT1AGKWE386ONOLD8GYYDXG46S8YJDV6AHHH10ODHHWBY48C5659T0VAN7D	7
81	XA2SEDHKA5	M740M9NGHDLH2UR5BFFCT63MHWMKVG44X01JM5YYQ252UXH9IZ9I1AEPESSZXCUAIRUB3ITFQQV1BA2UPNC6HWDWVME4N9BNI4UD	1
81	4UMCA9GGS5	FGAG42KPNOE08KJAY3VO7PREY1QPHSGQYQKHBZN42HI7AEOY2NTB8ZFZY6RCL5H4HXBR9C98P0V0HTEUM2W48FS9KUSFILT79O0M	1
81	OXSSA6KT74	7YZOVVHDPSF27ZTIM5CFBGPT30EHY0331RPD6QNTK65BNNKVAYWSYHB0JGU4QAOYZMAPJPL6RS4FKNGQPTGADKEUQY305SDJRHMA	4
81	RF62QV59AC	5MUM0AFM6P69EO74OUOHQ9UWUA8PUXDAGDUGVXNK9HUJ711EFPCX7365181ZB01IM53B40I1GEIIPLY3J4JFUPDNGYPX5XIIQL6C	9
81	EXSGMP7BN4	0JPGLQ3UXQPJ8QGQWX61Q4GLV5T692DPW5TV48J9K2TH9N7GB23X9KR5DEVP66V4MAXC7VWXN7RXK8LH8M4H8QPLOXS0M4CNHY59	7
81	DN5N8RS3G1	5IQFFKC33UF2OQTCO66UMXKD5LT4EQWCMRDDNB2GNSUCM78OSK228OOH8NJ41HZM8CQ7NPZMD0G4DI07NEL3X4E8D6FA18PG2IDK	5
81	TRFU14BD1F	ABCVQYIHUE0WLRW55YD8R4QKYVFLAB5EQQMDJHHF50S2PNPQ2K7TAL9GU265T6HSIWG5FSWXQ8C1LY5LFYSZDLEEQFTQKMV8TAT3	2
81	HDAKH5P9W5	TLKYJCBII556VZ5ORP7RBP99FMEMEHLFCEVMIB3JC6HJXTZW0UCUWLFELLS77ZEAU04RESFPVXPFI0LWXRWTF0T08RB7T6LN1GZ7	7
81	FFWE8F8F46	HSHOW986A6V96JQCV53HETWRI5YMBNBAO7P8PFS0V47VQ7XX5LGL50UY6ZF1LV4W5UV94RWPMDWJVBBKIBR0HZEXM0CZ91P9AL05	4
110	IQ0VP7I4EQ	Y2NY092ELD4Y4SJEDPGQ7WDO7QUXWJJLG8TIDCQZLTAWHBEIF465UOOBZ90KPFRB3TR69BBB9QEOWRG5LLR2NO11TSTELGJGB92Y	5
110	HLAPWR5SVJ	HJE246DKAPH248DYYYP20MQR7Z3G7MXYSMEBM9SSXRTCLLQHFSNKN5343W5FD6MX2TJS4CLYG6EJ3OGVIVAP9MKXTJI0EMP1E5K1	1
110	3122J53CUB	8NDGYEQ0TBPQK6R56YPJW8V4VU3RNE8DOTKH7JLH379I3J4Q75HG4SQ92JVDL9MPCLB0WK8XNIPZ9NBL0NUS61J6CKPYXH64UUFR	3
110	8OI9QT5AJF	D3X7T3WC1APIJN8O4SLCEYM4K9GLUEPHTCWT7UN7W3LJAQO38Q0B3PEPQ2XTXKSWVHZG1ORJFNPKMC43VMNEONOD8HCE73KMLZY2	7
110	8MD6C924TO	HCT8Q6PA3DO838K7OHH3VIULMMLDC9XNBDNK3F8R8CFEYGE49O7RR9F9SHWEUM73PA60UAEIJ05TDPXGHREYCF6C7O2VT36WELYX	3
110	QBAUG43EX0	NK9JYH1EW5CUP6DIJ1JE42GHSZP3JO11A74GEON8E8LS0BD73N5UOSOVE119175HDKUSC6D4NL96QXRRVSA5SHNRSJCMXOHHDDOP	5
110	2UYP83OU7H	V56KBGCSSEQKKNJ69Z67C9240H8E22NIB9AXEVRAK89FWCNB7KDOSSOWCCT4I80Z1HJKNV2OH5WE9XIY47GSZ80SVOUCBX2LIJNO	8
110	M8LP7EJPJC	CYMRZHX6JWO44AK2HA2R0Z9B0MUCK60J351J4AA1DWL1GHHXRTAJV6CNZK1MWUVM6EA9IB7GABNENH5SF6U16QY72NUTJXESA85B	2
110	OE7G4D95TQ	HOQV3ITS8ARPIHZ94QPPDG4RO6M75DOL3L7SEFCIFO4NCDBQOTGSQWEAU8H75WX5VGW7JH5YOGKZMQPK56SL664HG67G8FMS0815	5
110	44GWYVQ941	EGGYSDJLPXDS6B9DM8ZMP0NJY0J418NYU310MXO2U51I4XBDMPOACTCN26924PTQJO8DKJ0YU61T9EPAYFRMUNWA1N7PYW8FLL8Q	7
110	WT1KWZC2VX	82DYZQG2SOYR8DZ7H5617M7LLA78VHXF8L0NOX47QII9J7ZSJIEQCY2W51NZSHGL0SSXNMTUA8LYE8CNKPZNDHDKSERWKFPIC6I0	4
110	XA2SEDHKA5	BF7ZTPDMDS7Z9ODS3ITOIFJ46K5TDVH0L8JJ2XT197OVU6K0MZJYYMG66C2JTUJRKGNBF30FY1OL0XJ99FHNMTB91NNZ5KIPX6LN	5
110	4UMCA9GGS5	JUS9D9675GJ32KOM6F1FOJ2QBJOT9X3L5Q0UYOITEC6HD6DA3C11UIF92C83VN8HM77LT3YR6HAMMVMFGOZ65B1XL02WPP81EZ4G	9
110	OXSSA6KT74	1QAOJ5NH2XGZ3XGXBLKFJA3ACCRIJHX0FGP7ZRWGOPSDV6W22DCNTBY1W9MHOE8V9PTWHI7UZE14R0PFPZQGFKHERYK0EO2JR7DF	4
110	RF62QV59AC	9UTFRXPJ4J6UG2YY2PZIPFT7HPLLRMTWJ3PE6AYX14WOOG7VDUZSN774AV8CLD2R0JLNMU111CRUTFTARZH6XBIM5VDLCVLXCEXE	8
110	EXSGMP7BN4	UIT271LPMK5B7UV654ZB8R1QQZF03RORPF7QXE0K76TKIJEBZ1HK8D6CRDMHVUW56OV1WFI1EPDC8RHGUDBBKDSMJ59U1SYMJXN4	6
110	DN5N8RS3G1	NPUTQGT93DA5FXSTUU25JS0FY9V012LDNSHYRS478NP29YW5F3ZCV8O4YO5RU2HA26SWP4CB0566D8G9M0V8DISOEN9CXNMFFO9C	2
110	TRFU14BD1F	9QL1XMZCS1ZI5E4HJ7UOESB49NNT00Y8D4NKJGQ53LWWJ42IS85RPYBROR1J8FL1C1EB1T7CRYV26PUEVFB25HTP2562PG7X95TS	7
110	HDAKH5P9W5	1R8A291CJV86WX3ET54IYI5XFXK072A5BO4XD1CH1MTK752SETQ9ZKBSWL4FZAEQUD5I3FA23WQMZU0J41WOMBG1NLB267S1HC03	1
110	FFWE8F8F46	UZ8SYGD4Y3BUUK8O0ES7E4RDI56EZEX36JKCX6X5D6YS9HLWUMR7I65ZH5J2J8FUGIYL9504QX3HG8EBTJTMXZV9NU42W5VE1EM1	5
111	IQ0VP7I4EQ	AWYVXQUCYTJ1HJAP26QWZ7PB8HVBZPCWMTSW50AIA6ZBVBPVVY8H6E3DHXXP5TMIRWOY1NUC5IW2HNQ71AQAQ40I0PPIDUNRTQU8	6
111	HLAPWR5SVJ	14HE6MXRA54H0Y4CM1X6G7L8M9L4FI13RKAGI6URC0ZTVBN6SOHY7BQ3SJ27B3M1EAZPXY3PHF4QH2MLWOL0BC6Q4GX9DWQJN8PU	3
111	3122J53CUB	7I4U1R1G9W06RLWRW0CEJVRA4MUYVDJM29YFRFJUEJ4U7CWL411INPCL130P6DU6MNDSWQ9QQRA916D1ZJ33LA9N6MOYP3XAY7HT	9
111	8OI9QT5AJF	EZO2L15OCU4Z90XJ1VLO0VJBKBW3AL4YT2VTPBAJD842T8QDA07L5FITPMRJECO10FGGED3ZUCK20QSMVT3JNS2NUCEDU0EBUCCN	8
111	8MD6C924TO	J866I135Q284FYVJENHM2VC90F37JHYOETLU7MF19SEKFJOCT2PY4A9X66GC75VIDU0VMAL1IQNKR14Q01OR19UDTXXAGC3D65GU	5
111	QBAUG43EX0	3ZSQYQNXZGEBZLGQEQEAWBYNLVFXJNVVJ77B6BDTGP4RS8Q0XX1PCU61AFECK0NLUT12OEUDNV3HHH4MEO9WWGTZAGA16AIPCS69	2
111	2UYP83OU7H	XMTCYBQ0ZU3K28601ZOAC2ID3HMMOFYL5FQBQU7EC9LWHQDCLZL3S9E5EPJRZEMU5SOXR4KG1J7CRW5MDKAY4536AV7BKQP8W00Z	1
111	M8LP7EJPJC	QVROEBIBBORT6NPDX0AZSW56I5K49Q05GKWYTJZ3U49GQRODA49A0AT4ZUFI1NCVYWNW00UNAGEXXZQ1RH4EQZFF0298ERCH2NS3	2
111	OE7G4D95TQ	1MJKWAT65HAEO0TT7F8QH581VJSE75JHWW04U44ZVJ5V84Z1SX5IUN76OSYMRO9A73R2AY9CLI58AN21U1WJ9BWJZ4QBGRIHJ4XF	4
111	44GWYVQ941	703X26LR85BZ72Z1ZA5GICGI7639XYGZXOWA3WHEL108OMIYTPU319E4UUZ5DM4KZMCSFY8D315QLH3VXFQIDM7XJ2PI6MB87PIC	3
111	WT1KWZC2VX	0S4QQAAEYSN0DH75VGNOOINIZHQZ6T590M7XW1XM6TVJCR2FDCLJ5Y4REV0JTLHFWO91JKJ3TBR5XEGHOLV3HWDCRPSAAN2VMQWY	5
111	XA2SEDHKA5	A533RZ4G94AOT4IZO89K7J31I3FI6SGRRZOP2AZ6J6SVSVRTU67SWNV0BBUYUVKQXT73Q27OIDBA1IJXLWY9VY4EEXO0PAMXVB78	7
111	4UMCA9GGS5	YD18TJTMU9217N76K58Y2Y2OH8I0NO0LK8WT6BBPK1UYV8SXO0LG8K5AKN1VB39FJRQ80O9J4TNBDE2IPULWDTMACWITJPNR2PPD	5
111	OXSSA6KT74	U6A0CMP646GVTGQRMCZFQ6DFQ9OF6IYZY05XL5BH6EH0C80J79QNZ7BX34KC7J9WHR62K2GQBRIMYNDSJEI62L91ZH4QV8JXEVSV	1
111	RF62QV59AC	78E29MIYY9P1123AC46RFDD805CHVID4RQMFEE291CAHOY3FQWB1WD645FCEJADQ6VKLQX68B60DC5TCB719GLINTRK8BY008UL3	4
111	EXSGMP7BN4	SY2ZCZZN329WACMJDJUN618N77MG9EST0XTI8JEVSAZZKMBWNR5K1QR00P2FNTNZJQ5MSEK4F856BIDV502SJH2KG2RTR9I8WAQ3	5
111	DN5N8RS3G1	ZDJHAF3UUYRLGJX05QCXVG0W1MFZ6KB2JEGWTKIC9ZVDAHKZVH0TNG5SNWPY9DYKXYCBDAHUIAY5UWWTBQEYURODJXJ65TC5BLQL	2
111	TRFU14BD1F	JWU9FLNR980A6WT890FJ82P0LZY724JGLN23TYOGBVKZT587T6BUKBGRG4YPXQYEYTZT3ZPKL9INRZHP10N53Y6JHLWYA8SU7GB9	2
111	HDAKH5P9W5	PD4R1JK239RXIY6D2L9XPMSC0JNRXPLYHJMXSOBPVQNMFB2KVRE4BM0DV20R53FNY2Q8MJUOJTB98G6YRC5GLQW4TJC0YUT2L9XN	6
111	FFWE8F8F46	38M60VSL1EO5B9378CIFVPCH4ZZ9IX8SSDYESKU4ET1EX4WU05N7PI9N5FBA5TCDF6N8KYPYRNBCX8TADFINKBCKDLJNIU9VQY91	5
132	IQ0VP7I4EQ	YJCQYPCG7Z7WA60KZ3D3C49OBP6OPW991TP5F7VVADGWM0HXIK0458O3JXOJTY0LZ74QR4E1IS28YNCKIJFF5FE3FVVRTMCMN56O	9
132	HLAPWR5SVJ	0FNF9VMGQF6VDBJSVPT3BL6JWI6PQV2QYORD296T1WYPZ6PK231PNU4OJES0Z605MQ7YTG0WTACOWQT02VXW4NDDTC3XQF3463CI	9
132	3122J53CUB	11WDE5MSQ13U28EJDA9N3FRNCGOGHR3NL0B4ASZS0VDK9DXHZU32D5GVJJB8RGK88QJC6KIULRWICHN9SGQXYAJPUPU1R0BTLELT	8
132	8OI9QT5AJF	VKPMIRWI7TC6BQKZXJ8G3RRZRDVQD7753F76BKQTXHW5S5PK13X4MNAD304E6GFAWGC6TNYM3PSW5VGVXKZJJCSPE3CKQLWQBWJM	8
132	8MD6C924TO	T1NFLB74OIITJRVR61TXX1ZLN6R2BUIM42ETLE7BVU0V41G4B9F4ZYF1BB1PTE3395YQNBF23SCCBEQWZX0CPOWGXMRKNSRQ16V8	1
132	QBAUG43EX0	0QA3NBHWCZ7VEZ5O0OVJS2AT5PLAVLESRT8H0ICNPTUWUYI2VCASAZT7PR87ZGA1UPDU1YXSMI38HN9GGSPTKWR2AA1JKEXJT3BE	6
132	2UYP83OU7H	XB6OSG25UZBR11G0RQ88KU07OIHUUPOM4USRSE2QY6PLZ1SMQSBMDGLDK99J8HLFLZWGIZIMYRJNFPIXZ4EBOCIYJOGTESRQVJ99	2
132	M8LP7EJPJC	LD1KYYV67850MUDDK1IR864SZIF9225PISO0N1ZOW1MQL228ONLS1SGOJIUQSVEECQS4FM0SB44GUNH6QHVORMY0L9QEGI5AXHN4	3
132	OE7G4D95TQ	72BX2Q6XA46BYAK9ZX021SG6VL293TM9MWSOU1Y51CLFUCSIUB7UXBSOWFBQX64QS6YBR5P884AYHBLT3UO2W1MKDD2P0IH4I4WX	4
132	44GWYVQ941	Q0ZV9W2B3HU3SXDSB40UO8OC9I0WFQMOXFM3ZGWFTJJ6HWHUEMH96D9SMWW16F5N4GFNKJ34HUAEZS5NAFS3JNRUF4RCU5JNO5BB	5
132	WT1KWZC2VX	4K4SM2MC5331J01XCERYVHQ10KMLW03Q36F4YL6UFRKBYLKER0M1UM5W3C1CPAQEAM7NU690I6TD7PDPAH35OB6RBSBVT4FFBFAL	4
132	XA2SEDHKA5	7TV1VTX31ZO9MBIGU08PQLB4NHN1OC1O1BCXHD3SJXJ3XVH268QOC57VR0NOF6OZ79HK9U8Q7PG2CIH29V4QVNL6EQFR0PNNJT5X	4
132	4UMCA9GGS5	73L9ARXZESJSVOTB8EUXLGSPR0SB2TTMUNB2TQV5YG9768EA3MKPL9C0K6RJ9V6V968HM1SSSY9EHUTTWSIQJDBULLRW8L6DKO89	9
132	OXSSA6KT74	6XC326WA7T0N8XQMPM65O6BJ5TG2543WTTZ5GWQGPTN11JAYP04CBEV9V28J04EC0D3P7VG25ZQ4SJRWSSMFA0UP7ZJNYHQUPKBY	4
132	RF62QV59AC	V04TBGMY1RLKL0IS9C9TORIM2EXI5OHI3H71SV8UH0GI7DMQICQIBEADSR17TD2MJDQE3QANDPLYL9OZ1GA389GZG4IA4BAE7394	6
132	EXSGMP7BN4	IX1CDEW3M2TDBFMD9NJ6179IASCOH0RATCTTI054U54BZ635YA7PZ84KYTCUBHWVKSU8W24ISPL6C7SDZHZG2CKVII4ZYK3MIJ1G	4
132	DN5N8RS3G1	4I5GZ7KW8I1A854RQ2IH80N7EUHV9X3FL14839DEA9JADZ0P842QT9NE57BFZYXLOVYHA6YQZDH9RN4P41XE4MWMN0D588PMM8VR	1
132	TRFU14BD1F	SPCGM1Q1OXRDWK8BSQC9L3J22S1Y5XS1MOLMU7SVGV9DV2LXRK3RTSYYFJO39160E01H9VQV7Q304GHAGDHU4BI40WGKTZVOYI95	1
132	HDAKH5P9W5	EX54ITCZ749COX6UL6DR7QNPFBI5OCWHM9BPM0VRGE22HIFBZ3NL6NDXKPYGLHK5H20PVQIVLVK2XUI76GFVZKK85NF6COF947UO	5
132	FFWE8F8F46	0QIV1AKCL90H0KEBZG6R1UHLMT6PL7093PG0697KA5TNPYLEB7F0Y70FJ7IIE41OJ0NLDOEZJWQ6A35XH1ON29L6ZAQ81YFFDFEY	3
152	IQ0VP7I4EQ	9BW3QRBQ3FPBVANPNVJORWD7F8UQK25ZHMI02UMSKP55B7FY200T4K3N7YXR7VFAJ04J2WX2J1EC0I6I26XUCM46S42D64UZJ5VK	1
152	HLAPWR5SVJ	55GC8JDF0WZ2PYB7U8767074U5OGP25WVF7ARSEC011HCLRFT1Y6YOEF8LSC46081DGJ1BQC44FG8Z1IOJWXD88GB1CFABH4A3Q9	2
152	3122J53CUB	INSLWC3I7GIUJXVJC42E9IA9KC2XLGFJ1EG5EMR6E7DV3V0NWU89Y4EANTAUJG71B82FR0FZN5ACEOFZLOB1HFU79FRUL6W8ALT4	8
152	8OI9QT5AJF	U56OIW24C59OLJ5FGU5N5GLIUNQJBB34K60SEM9T2C6KSGAX1341YQ7OUX44FT3BBEEOSNA3UMV2JB0ON2SHHCG38M8RSENJJ5IO	1
152	8MD6C924TO	VFN3AGL5FES7QRNAV397KQGOSLP8MSO2LM1XENG5473HPUCXAIXBJQ1F89KY0MTW00VEZZ6HWDCMW898J18D4MS5UWYEDSEROGQZ	9
152	QBAUG43EX0	78KLQOFOOT9AMO8OP1NH0TDA1EE8U8PRK9L3Y1O7MRFDZE0DGD8PCRIO5JULKH3QDR0MCF0YNQ5JN9LXNA2Q9AO2177OHDXFXZ9H	4
152	2UYP83OU7H	OBANKCWW9A5878JOMQDC7UFHLQJ3ZVYAEI892DZ82G26CPKFN1KI6ER352B3236NM54Y9KWJ0FK02IF6FEP8KPEA1FD9B5F8KOUH	6
152	M8LP7EJPJC	WGCEBS130BXXFXXN8C60363GWI59LQNX7KT8M3J7NGADQL5HSULLYQ1ZM6S3X2RKX905DYBF39NX5Z0LNXQ1EC9QS4WQLQKVY0QQ	6
152	OE7G4D95TQ	9D4TGSZCE3WFGQAL0FVAJMJBU4NZ28FJJZNTWH7TKOOBAKEAKJ8U5QMW429MEAKFYM6RCQZTIB048IBJZNOTAUO3N0Y4HVOKEIMX	4
152	44GWYVQ941	W73UPM30RYW1ZW1V0FD8CEM24LWWP0Z5N5DPV8UHUD5CCDS8WZNDJYLSVAZE0GK081N4TL91U6O9IJ012Y90NWWYUU4UJQRN3FEL	7
152	WT1KWZC2VX	YOLZVSMKLKLK7LBGTNLEZK9ROSEOAGDFPCEJYB1DJNIJTKLEPGK12GAOP3KCO8JFHF55H2SRVI5LCZ7EH9936LNJB0340ZZLECCN	4
152	XA2SEDHKA5	P7WY2GTKZLZ6F5O8PJ52W3Q8X16SUH9XU01CMFEF38MOD8V3KMY2GV2VQYBBJB0SMCLPDMWKF08XRC4YFCHHSHQ97FVYDD62H4CB	6
152	4UMCA9GGS5	F08ZNXQWEEO3N5G3S9FWMR708HC3GPWA3B9MIRFT9M3BH40HZ8Y57OKY2H1GUXQYRN9L54UB4VXAY6SDQ4EH11DO0LTB088M5ET4	8
152	OXSSA6KT74	OM5NXBL1K96ZXZ0SI70KUVTKTL5WKEUNYICSI4D01WPLXLCJI3WG2TK22U3MGZRGPSAPXIJO49S8GIWHIVORRNUF7JZXB1UCFI6E	3
152	RF62QV59AC	WVATIM2AMWU7VDUKAYB84RNSVNCPQ27LS6W9O7IA1EVXFZPXA1FU4GQEIR75JNUTYIPZQU6CPAG060M57PPYXNQMPS169N1OUB86	3
152	EXSGMP7BN4	ZGP4CE390HSEB74856L2CK82ADCJ2F41QVHI93UJXNYKJ17P6PZEXEHPIX48BTGUN1YQ0W9BMCEZVYTJGWNMQZDLN19L9VHDGD6R	1
152	DN5N8RS3G1	QZKQX2V9R4TDV2OG4EXXMC8WXB05BTR1BGZ7D627SM67PIO226L9J40O1X3WB077N2BPDRD8MZFAGBGOX8CEHRRHPKGPCG52O8TX	2
152	TRFU14BD1F	8ZL3NXTZ0I0RO8DX2Z5K493LX5F4NVHRTHYI1L448SZCP8YI1EVIXMM969GSRZLEAI7GJ45R5BMLK05YH7CIA83G4ZM1EMMIGVBH	1
152	HDAKH5P9W5	R86IDNW9BZFERLUWCDBO1LTREMTYDEYZYXZ8FA6VHG3AHXXB2WDR92JGPOE03766AQQ3VVQCHPHURSKRZS6RBGZ5OTT05F2JK7A1	2
152	FFWE8F8F46	4PGFBKUUZY7EXBLBO530UPCCZGBX7JUSSK5DZLA6FLY4WWIERH5CGAWOMEQ4J6WPEOVMFHMC47VJ0IQD76G0ORLSYQ1V5FWIYJ0H	1
175	IQ0VP7I4EQ	68J52HJOMYDXM6M06BWDDYZQ1HYKNUQRJCB764VJBDL2X7TJKR2IDD7IJ2EVS9B2HWOK4O4BQMB9M733YPA52IOFE3YE090CCTUA	5
175	HLAPWR5SVJ	IO5X010B85M8K7D9G98HIFB00LQW973M2KPAEHCQXDG7MFQCXD6TW2LDME7OLECBBAGASC487RUE8EOU5O85AKZ98LYAJXFSAF5L	9
175	3122J53CUB	PUUJ7VEIHFI0MT7GHA1KGBGO4YKMCD2ICVP4NWDYU11FPJ6DIM3FEA2NNGOJL2GDMAX1ED2U7C0OKA9U1GDZJXDB3BQHH4N1VX3P	6
175	8OI9QT5AJF	F8FUJHCKNDMH4REZQ4Y6W7DWUMDZ83WHU8VH8FAQB0P7EANMICF3ES9H5T96ENMURFX5560K3I55SFRT80Q6Y3CB8NLPFDLYO5Q9	4
175	8MD6C924TO	SRLL496WEZ0BQ7O6Q5XCV6RVLE07GQXYSGQJEU43GP4YVNZG7189262W90AZJ9PXBBTJRE16B46FB397PT9PSY6VN4KOTEUG9GWT	8
175	QBAUG43EX0	PZ2AC78AWUF0DKZ9AFNF76W4NM6JZG5HQC94HOP07V1KEXQ45H8AIN7TC8WZBZKPY8JAK42VZXHMEMZZ6BOSH48CFP1J10ZIKLVF	4
175	2UYP83OU7H	PUAPMLVFUP0I739K2I4AG54DS3979C30TLRROC4TN7UABA4707RD1FHTZ76TLXGSV9YVLR6ZNKXJK4BS9CHBUZ9OE72QGLHZ0COC	4
175	M8LP7EJPJC	IVIB10QS7J46OTJPF769KROZPTBD7THP8G0Q9A29S5HY7U227KVFSDB1HTVIYNVOBP7H23QEE6QOKZ150JFX7C75E9JPPTKFK2XS	6
175	OE7G4D95TQ	U9E3QAVWWQR10SPH8Q8RCD3UAZUWLERBIIFKB3QCLIRS1YZB47MMZAUQFU30P9LS9PTSMFGE96F3WK3MAS1N2FMHXYERA0WM79TL	2
175	44GWYVQ941	HZZ1HM350451R06H7Z4DL4XBYEJJ36X1RH33BWU3TM64I0T9ZFAJZI3MCYCDCTB4HEJJ6DFLEBT87328UJUY5NBJNR1NTR0AKCWE	5
175	WT1KWZC2VX	JDV9ZFYY5OJ5ES29N84C95PM21XKSX5GXRLG8YGINVSCRRP97B6D2CROXJG7SNFHTCIWHVAY2VYOMN4KMXMR01NV97TYSJ0APLSO	3
175	XA2SEDHKA5	21MAHLHODBJO6V4BYQ2ZWXKCMGS5Y8B4PAT6ARSPGG55JJVX69150ZWFRKYB2LZEAO95C8AG7MSQ1O2CV58ZHGE0ONO03RX4R154	3
175	4UMCA9GGS5	ZV88U7OGGODRVP7NA64KJRYTKNQZY99T725JA0XI0TH9KIHBZRQ4BUBI7OYGRZSHOUT3UXMJJVUZKYJBGO9GSFRN0WMVCR1BA9VZ	7
175	OXSSA6KT74	ORCEGVPAL8IFXADZMZICGC7K0H14SZKDTM177CLTCMPYEQPRYLXKMXSMT1N93VRVXEVLIF2KNZA3XIGJ1KFHB9163PNFYMZQ53BA	8
175	RF62QV59AC	EISTN7XXZZKVDITQKTXMZR32WVB9T83HFOXCXXYCEIE0CUUDGAUKNXFWOZ715XD05DPZUQ2X5UIQND0BB72SNT3SJAX7Z6GQFN49	2
175	EXSGMP7BN4	5S0H7O2PYJL95085VNMJ7QU2578N1L9I16GOCKPEACU0M73GIVT9RZHP87LAPPYNKDI9UT3K8IJ454Q8D2FF290BY0QF8OYVOGQI	7
175	DN5N8RS3G1	4WY1IBJPNTDQN7XJSVKMGL3DYMTTXQZOHKJGQOT7RWKHMYVRBL5VF6RS3VD6S0174ZICXR3EBN4UAV091BRMUDJL20M5KXP14NNX	5
175	TRFU14BD1F	S4US1T2B6SH4EFRIPM0Q7J7E73O7D0WIDSIH732TRJ6HFBGR8SOAWHTI6PU7F47G690V6JLVUH8XNZ96X69VMVV69AKRJ4OWL0LG	3
175	HDAKH5P9W5	VVYH2QPI54GQXKI4M4KN4V684MZ2MLXO3WCLLOTEGXDFEAWUF296A2P9YZNQ1W6UH1XBI7T8KGHGS1430EXTM1OAGCWWADNT1T7M	4
175	FFWE8F8F46	VMIJBV4VIR74TZW9MHPNX4FL67G2XP83SQF2PKLFTO7UY1RN0UOLR8Z0G6MDOB73SDMCU4UC6K4I6UWFP2CDBXMT1OWS7H0RQECU	4
176	IQ0VP7I4EQ	O369LPHEQ3VKGXW942512LFHBEYTM22SB0B9FDZIEPLVAI1TESWMG3WDXY8G0Y1YBDIQWX30CXWN9UH3NFO4FQLIE8LRFSRQXXU7	1
176	HLAPWR5SVJ	K7RY5JTGJDDRF3UJ7SU19MXLMVTFGZMAJ3DI6FJG2C45I9AZ7GZE9GA8JGMKZN9T0CILZMM2IO87R2DMU4IAAIBC2E8028QOCLEG	7
176	3122J53CUB	Y9U375UICRQD905F9TRBFTVNV9J7T5FX6V54XGCMQ40XSX2IUJC2WFWFOGH7VWYGL2GO4BS3QFUK2758GBNK2NA190QQ8F03GTMZ	5
176	8OI9QT5AJF	OOT1JLRULNQKJ0UJOO71OPDUB5LO1EIVGQ2W3TTBTHXN9GYOGT2FO7D9K8ZOAD3HE4E377Q445IG10V5G6IHLDHIN3M53FBPOPJE	1
176	8MD6C924TO	4RID7LSY6HTN4HE5V6BX5QEVUBY422MRQ3LO9DO1YTQW2R886U2TIRFOMXS5WY5D4C7B5Z5SRJ9L9R2DD07IA2J9X7CMUSFAXM10	6
176	QBAUG43EX0	6CHZJB8R3O44P260XDB28N8XS78E9XW0CTGX0S00KR3SHSF0IKAJZ7VTETHMD4SG1E26WJ9EMKSQUPQ92I5ZXNAF7XSHLOXQ9X0C	7
176	2UYP83OU7H	JE9K56PPF9YDHU493SOEX880238WCR6ZNJSE5O2QVZ2X3DE33QFFL8DKFJSB82NXC9Z7B0DP08T7GK6YZE3VM1NPGI9W50R2MEV4	4
176	M8LP7EJPJC	G2CN0ONOGD4M3M381LLVJ131RTAQ0UBZCKTM0HVMAAAEEKBNY4U3JJEP8L6HO7YVCEKT3QHUZ8VJ0YWGRW259HP3GEOPLO7DMOCA	9
176	OE7G4D95TQ	SUHWAEKY5YJYZZ2E2W4YRMZC2IKAR6MWWH8BVJ8DEELPE0VZF8T2HLSF5E413KG8MXCS01TTY1TMBJ8BWV5TMUOLY3GQOGJ48MDR	7
176	44GWYVQ941	D8OOADQ1GEVF2EIOXV2I037UCERSYOYFRNTXREMQ8TSZULVBBQK1LI7KA3M5W8D1PQYPVU7TJMJHKIA1SPQID74IPIWY1Q3AQ0JD	6
176	WT1KWZC2VX	GQQT1S99Z922UMGR4YSVP9M8J12SJ1T86EM9AYLP4JZI35HDWTVB1SHGDRKAZRZ8P35QAHQFND1FKEFNUZ50FRHO6G6TOL0NT02A	1
176	XA2SEDHKA5	0DPCPYY0C58M7P9V938VQT3K61CMNVTLEN3VPXZ3TY4K7HR502U74OTGKFFYWLNQMXHUVOFMDEB2ZSMZJGWVBVQ03XLKRBHIKO8J	9
176	4UMCA9GGS5	7KMWH30M1R12QOQY2O1HQ08C44C73SKUCZM6K831ZOBFTRBW0UR9HCSGLJ2N12TJGHZ0CTN4U9SCY2SN3QGIALNAHFUAGQA6428M	7
176	OXSSA6KT74	KUHGXOIUPRS0OTLWKJ54ZT69MYE8VI64GVS59BM6EQ1XCJ17ZKTTDRC1XH39KJ8HVYU3APWI69ZI1J6C7HIKYN1YS0I1HNV4RTCN	7
176	RF62QV59AC	76KXKWD24AOK0CDBYTI75LKG5BTN40IGTN9K8WN0X6Y04QQKS33A4Q3VWD2JCZ7D1H1NC2DBGRJ8XTMOUI5B6IMCTOY44DY89U8W	7
176	EXSGMP7BN4	DI0024NG58C0OZ336GT5Z3YDIGC2L8DU0ZQAFKEN85YPVDQN4EDNO09JUWRV1U565SAYJ3YVCF73FIRF0Y8G5ZFAZHPS3SWOA1UD	1
176	DN5N8RS3G1	1EBQSKI3GDMEM4CWYAFMA8BNF1UTS2OXNB9U70NP6GTDDNRXU1L0P1D2CXK00ZKNZY1K5SZ7XZP3P8K1J691RXHW8GRJQXZH6FNO	6
176	TRFU14BD1F	H2BCNDZLKMDNTQ40T6CQELYAPRAAI6KV5ECD7YDTSLY3N66G4RNIK8S5EBX5DZCNCSROO0243S83X4WSU3F1TCK7WG95BHQ2IK15	4
176	HDAKH5P9W5	R2EYSP19ZIJOEKKTL4AHU2H163VCFUMD1EDBBDAXS768ZR66GJ7Q1X3ZVM1Y3Y3E5GXAHIRH4MZX5IBP7Z66X6LEKNQYLL33E2CT	8
176	FFWE8F8F46	6Y71ZWO8G3MLM1D27Q94SZ4236ST5SDGSVAA9E8K7FEUDN9UZBHLDZLG4E83D5DX0F300D22SZ6NVJYP6833L1D2K3G5FFGCCQ47	6
198	IQ0VP7I4EQ	I3WJO3N28VUPT6FCJL8CAQ667WNT4KEP05XEGU78ZALIWPWIA92E55U160L1P47XQEYYIA5ZOAN9FYKRAFS5R9T5K5HQIFS5DY1R	7
198	HLAPWR5SVJ	89AED05SUWIP31KLCGQV3NM2PQJRR5Q731BFS0NJYNZJ9APNITBRK67VWHYXQNAZFKWCZF3L2H6PXD2PA5J748W63QSKC02KMADZ	4
198	3122J53CUB	MXD00ZD9S7TOIWVDD5GX0IJWSICOVCWADCYIGGDJT7LT963DHHJF6BXEOQHRXYOPKSKG8M7617E270WWP8GO2RECPT3Z8WW4S5IQ	6
198	8OI9QT5AJF	XF4JNO874HY3VCYS9W2OI1OSH7ELJJBRGA23LEPDFEUMF6NU7MTJPBM60LCPJXXUGGXVJ5G4GZJDGCNLUUN601BEY6CAC94RQAG8	3
198	8MD6C924TO	2KCGYC02IZY815ZK13OFS6N2G2H52XF5OC2JL0CZLMPGOBLEEGZG23056J9555AVU3UZDP9A1Y4GRHOERC0V79DUM6MB0G4PL3WV	5
198	QBAUG43EX0	VAYHZOD9TNZ45O2FOYV09NGD7JV4O4XV3X5CBOHU9V2SWG51CK7FA4RI4VJQ3JUY0EBHS0D9QB0NUXQ1N32E7SU8FWIQF100AE2S	2
198	2UYP83OU7H	XJLG7Z9EEYGERCAQQ0ITCC6RX4YKAMP57VZUQ792U4B8BLXZ0JUNU9CVN4TDAZE1ILG6MPAT1P8IB7PMH9U02BK8TEHWN625ZKZ0	2
198	M8LP7EJPJC	1MKJAWFA3UPOH5BEN8HAIMIINF4WDS1IZHQWJQ1PE8ZU1IGA00MLSZ6OEB641S7L2HZAPP47G26KXXQF936MGPZ9KBRIU7XWAO1U	5
198	OE7G4D95TQ	FUL5OF03W1QU047WUENRZZO7WMJEJJJ66W3IUR1K9FYKAX3CZAQJNC3QGOIB5VUMSUYEAZBDMDSUBE69TGPJ39S32NCGI0ONVL1Q	9
198	44GWYVQ941	ZBA8M6KUJPCRJSZFKTSB5LXW45WYE8ZMQA4FPKRDHIT79Z8HZHK1JODNNNEQJWQKZ0BJYT0ACP4W2ZXF7O86Y7CB6Q1BGA3V2JIJ	6
198	WT1KWZC2VX	YTFRJZ4URUY08T4XTV2Y9MH2Y3BVI3TRORI52OOIIRP6DLHR87JXQVXMMN3QXILYBGMQK94EHTPS7KYMWUXLU6B346SPV8U9F056	9
198	XA2SEDHKA5	1G8DEQ6FFOBYQ3CUAEEFTWOQPSI9PMGP2N4OYHPPFXZRR0FERPFW01PF1RYVH6Z2IV6C9Y52YZ95779YMDSAGTZA7ZWHT3II86J5	8
198	4UMCA9GGS5	DF3TN8B1UH4R9IEOYVY65FJBYJ4Q17AXE5J8YR3VYJNR2ZUVD4JLV877614EDUAXHGND8GZG1CIW11I9YJM6XZCF7LB7XZREJ0KW	3
198	OXSSA6KT74	QW7FCTS0LGES4P4HD9SDIGWE2TCVENBQWXIXO1VFUOWF6O2KW6F02SDJ93MTQ6W8EY5HGH2MOMT3URHN028HIKYEU9XVOBYX2XBI	5
198	RF62QV59AC	VDPE2MQ8KZSW92Y8PZ391WHTH7MX6B6P85FYSDP8IFKJF9PJAYN8II18667592CJ2CXDWAPLK41VM7NHSCWHX8HZEH2WFU8PDAQD	3
198	EXSGMP7BN4	LXAJBXNRFV8SZM7F5V4479PH2G06LSLQK6GPW7WL4I8V3EQHBKHPWIOMH2Q56QGXJRH3GRS78TAZB3OYZT5BK54CR4I4R1OOBLLL	9
198	DN5N8RS3G1	XAU1JRCHYLNN1FNVEMNXFLMIYQGFWXZSC2CSLKAO143T4QZWB2688Y0MYLC3K7VBV5K8C4K4M95KS2OH0UD301TOB039HHD3J289	2
198	TRFU14BD1F	0TGSBV92Q4674D031K3L57MAKXF5BBZ4OC9B7LYFUWV67CNDN9RREXJ3GFIOQD0OEBS2DY6QVX1JLQCHKBSCTIZ12F41DKZR6G26	6
198	HDAKH5P9W5	U9YDB6R6AS0DAEPVY55M0A84ENL8JNEYGXZB38SLI42XEYCFK6HL6U3UB49XVSWWNC6NPN1ZMUD6HLZPKGYNF21W3EA9940ZIFJB	8
198	FFWE8F8F46	ZZ6FR8MQ7M0ETMP4JQUKKTKM10S3OYCBXXVQ1IY4PF62K5QRL48YY1RFPTN1QSCJJYQ518CA205EXSC5KARTZOM6GPBH47N6DXSV	4
199	IQ0VP7I4EQ	U0M27586NS6RRQPATT5MTZM75G5N8B9ARQZKE11TOA36E0NQ76UDWJ55NP619U8MT69A1F512M7T6P2E3PPBQ6NHV36Z4AT3BQNH	7
199	HLAPWR5SVJ	MZ2A2LKLL98W28UE65WT1P7IG723DRPCVOQZXBXVC6J38CBB8ZFV0Y862T34TRI4U5BOR4R4HBQ5GDJD504OL3L6PT7EH2CVXOID	1
199	3122J53CUB	XTDHLNZHC0YJ092W4S0TE877NXO84I15GCHG0GAQWYM3J4R3J836RT6ZWG4X80N493CX1W6XRK7PVEYSFVZ5O5NXGSUULMR5LS4Q	8
199	8OI9QT5AJF	3CXCGOHVQDRSMSNBRPEPORJBMLE2CEDKH0LTB3IQFCZODB94E34C0ANM3W04JOSMAHKWG4AXHXJM148KMKXJJAUHM9ZPDOH1TNN6	7
199	8MD6C924TO	NYK3H5C0BU8XPS91JD9WCJGEVU2QS2OQCS8WMQCFRRLP11X6IAKJOJYDRGHWCWHJFSV6TMO3A3EV81M376HSREC245EGIPD5KCJJ	2
199	QBAUG43EX0	0M5VRJUEDFZ3OYFOY1AP2CYHIVU0JL6SDWHUM6A5RY0ZPM318QVKI3OXYXN6Y452JH02RVB10F8DM8251312ZVJJHT5ZTEHW38QH	6
199	2UYP83OU7H	BJNO3TD5KL05RE4DCCY7QU7ZMIW7LKOSUK0UON6BGO6IF3BANT052JFRLXCV7FTA7HKHOJYYGW1BXZUSHWU1US0KEII0LKDA46L7	5
199	M8LP7EJPJC	3VD5BYFSD3WCTOLV2POR9DFA7N5T1H0NX9NAQ6S4U2BPWY261OCQ7PU0QC7Y2W16DIPTALF57T6GB0NJU91MEJQHOWUN94B8BEMO	3
199	OE7G4D95TQ	I5QJGTNTNYZZXD34O131IFN126DS8F6O9BMDLD70DYB84YM0HDWNSW9DSYRKQ4UH1LZV10TL3DYUDP6DUMK4ST5MBIUWWXJID3GS	9
199	44GWYVQ941	08RULTP8PAC1NZDU0YIPNUTF6YG3PRJJNF4O2JHAQNVIS4I7FYMF8DVFPMYXNVS803OI5Z1RRH898LXBPIX1EEKKTY8QVUX54XRY	5
199	WT1KWZC2VX	ABQ65X0EVGEZWHE713WTDYH0K57TDEL39VOGH4JRTG8R419MT8D35FNM4ZV9ZHAQ5K0A27Z6UF97ZZ5T6VAFBR83ICMRIJ1MFRVU	1
199	XA2SEDHKA5	8UVIHJZFQWE4CDEG5POL62ZVHXKNW1HEKR8AP73HIX2PHXGGXGKCHJFF49AU8MTYOATUFD07VGCIAJNUQEZQRF6BM3FQ7JJ6EDBH	2
199	4UMCA9GGS5	VATPMRBG7EUVPD3WDHJDRIM7KAL6FD7IGP5DFAEX54PYV4RGPJB51DWNYWFLFEA3HMPAIZQCCVIW2XMQTFR6CBQC3ROT53S04WRJ	4
199	OXSSA6KT74	R8Z383G4AVBJY1AXE1F5MG0K7HJDR2GGDBCG1CDIKH26NJGBSDZ4LNCKIP60TDNHO5GXZ36BX6UEO37XAIUOCL4Z828MGMZH4VRS	1
199	RF62QV59AC	TLZHXHO286ORJ0KS9FDARY74U5KHNK3LOTR65GPEP6A6U47WOY5PORW4O4X26HPYDCDZIOW209VUXAJZ8X3ZON767WSASWHIRM3S	7
199	EXSGMP7BN4	IOABCZP6BGNV73JNZJZEG1W5WKD1MDLH190J3YMXRA6PEPV3851DDNUQ1EP2WXT85F38D9TB7CWF5G1GYJ3RLIEOOJRZITA4Q7U8	6
199	DN5N8RS3G1	WZ8L0GA0OVVNIDM3CWXBPT3R42NC2Z7W2VCT5GUCDXAY6MAPXAOK67FD6QQ7287ZX8UXB385CV72TEVS27O1LW04P9XOZWJFZLB7	7
199	TRFU14BD1F	MO4CSIK9NT158F4TGNAI0ICFTGPL1CIDX0PTUY3OP4BP5T0ROWT7AZAELYTL38HKLYII0L8RUW35GXKAP77FTLC7ZKH5FRUQW1EH	3
199	HDAKH5P9W5	S0DXBMO5F8YOS55BC19WKSQDCMDBNIPSCZ7H3RR8XCULTRWVYOU9EVAAJ9UZJMS6TFL38YHUKB8I7EUVZRN8YPORY67461ZKTX2N	2
199	FFWE8F8F46	3XAG9YDW2CFO9A19UID14EB0NXTLXYKMHP64M2Z1K4642P717L9PYVLYVK2LF19D22HTD7W1SMQ9IH7802OLZ4XVEIJC9NWT52C9	2
222	IQ0VP7I4EQ	NXAYH6MFLPOM4VNMXO7FWO5YU2F06EQE70MEOXS7KQ225ZE2IGHNE4V81LEO1WIH8JPEII8A6A4GWC35YNR06CADENMCTDGXHV3V	3
222	HLAPWR5SVJ	9T9IHRD9PMZSI0NFSK6ILA455R24H8AIHUY3RRZU6EYBXTKN2SZK7N99ZEN0YJ1RMQLYBTXBVLLGL3HLHPBYJ0L3VZENE95XMHZH	3
222	3122J53CUB	VLI4XYVB2Y66BTJIDHVFRCMPK6WQY4DEADVD24VBZ13AIRCQWPJADC0T93T1CFN8V1587FPJWUP0JLH34G3JUDA7MBE9K49TN5PQ	6
222	8OI9QT5AJF	ESQ9AOSWAKXW066LENR07V6BQ81V5MO60IZXNJUZRLM1QNT7CHJR7ZXSWOTBW71Y615SHI8532IWJEVDP3SYC68BUGB90TCUTX5Z	5
222	8MD6C924TO	B04JOYFQBJR2QW2PDV9247AG9EJZYCVJ6VNDXOYI3UT7UGK6JEQC66XD0XJJOP18XI64IZ1Y618KODW34MQUVTN98JNAEP3O2VJM	3
222	QBAUG43EX0	PYUM2FE7NZWBQPB9HME4669M1TR7UR34KTOY5H3OICUU08XA1PVIERNSYHUJYGN55217AMD9T0W4LOW25QGF6UZ2F69XXUZBYZZ7	2
222	2UYP83OU7H	0AOLVZO4SGKV1NHAI8KC81DNPM9AUFWZYVFQ13L5L7WZZC5GSBQ1O5J86B6J0NKNUV7GI0IPXP1AENXNR2RTZ5L3MGU06CF8XJFE	2
222	M8LP7EJPJC	Y822AD9DI3SNT1750XZJE4BGSTVJ3N5ITI24Z1Z1LZENBMMKHC7WQ4A46VJRSZK48K4L9CG8778P0XFGGKB0QI2YI87DSHJWOJP0	5
222	OE7G4D95TQ	BKF68YS6VEJQCLHXTOZRFCBFCP0YLAQIOZEA64RTJ2W3YWQ6B954ZIL8JA3S83UVXACMGH0Y7GHNQHQQ93XMFVTFOF06B8VQHBGY	6
222	44GWYVQ941	DZ4IG7TA8SBTNTEGIQBR68AQ4X8V1FOB255D2E8YAEPXYMYOQJ9VEGXFZNNT87J2EA1RXBNERNR1SN1R8UERG26VH0OP0PZC5WSY	6
222	WT1KWZC2VX	G0O65E1Z6WLV6UO21WMEGJ7W8NCXP665D6130VLXE5LEC344LJEAGTO7327RCEKA0QS93VCFLYAK82UETHMG16ZUS497X3V9VLOW	3
222	XA2SEDHKA5	4BZG9YRSD8AI3752EI417R8VFRRCBZWO73YFW92HHBO58Z460GQDU4NNCDBRHORNLVK9JZGEQWU6CCXPWVM4IT4CQLDS8KA2UBUM	4
222	4UMCA9GGS5	4XBAMW7KQLAQW5VCXE11HT7WXFFW1MBSK918L367619ACBMPOZ662VHLZPMGQLSEJRGWDX13I45PT7TW20HBPE0Y1QJ6QZQVI50V	8
222	OXSSA6KT74	0M18CY7021150N0ERZF0R4WN4NSOJGYH71COPDMQ389YRA0LZR1FU4N5ZNDZFSQVDT89LMYNMZ7S4864WGZ2OSWDNGYC9XKLSOV7	1
222	RF62QV59AC	0AN2N3564A1RJC93XGU64VEXWOZPWAQN826GLAAY1GSG7U0ULR5HABHE50G9EQK4UOTQG2SWF5FYD8ZBYEDEEIM7U1KU3BUK5YVT	1
222	EXSGMP7BN4	JOS9ICF5TB7AEK9MF0LBW6OR73DL42OMGAP0VF6GHBBZNUY0U808KRPN9ACP83B0WU3E5J1A3F4U4ZENEN06CQCZUC1UCRHNAKC3	7
222	DN5N8RS3G1	U5KGZEEX4SJ6YLVCEXGRET3SH7M7QTTWLXTSQZNM8BZTRXOFWK5W6LVAB2911GGL8XVB1CWPK3TC3JATTGLFY609CTQXZVU15OV3	1
222	TRFU14BD1F	MOTYQMC1SG11QIV5AWB7W9HW9ZZJ2HPYHRG11RHUXHTMY5JN9541T6PNH7Y0X39K1DU8B3ETPRKOP47DQLJ7MXEKB2U33R73IJVV	3
222	HDAKH5P9W5	LMG0LMCWB8MAUKLUB7E8J6IIK07UQFGJL2E9DGBKCY93I3IGVJGLRXBOD7QVOSF52DZ2FMQ5635V7PARR18G941Y106F0P5USEBE	2
222	FFWE8F8F46	QBI2LOX1PRX78DXT867LBAOQLEQ8LC2O5NB00OXQE6LJIH1MHBUHD3CPW2RG7YQNYJBVB73UJRGEYFHDME0JRVKBKWE77QSPP7V8	2
223	IQ0VP7I4EQ	GKKH98VW80QUN338G5C89KP35X280Z0TJ7G4QBRXZPM5XMTXZRICS9F54QLMGW6J97LPX8RENPJU8TGTDEJJQYBJ1K99ZFQCTD60	1
223	HLAPWR5SVJ	E90ADYD0V7KK2JBNX2K5CXM8ROI8HB5XQT9FSIMA8SGNZZ75PY6KV47QW1SYPETTBW4JK64OQK7TR9J2RMSSFVCVVSS0ZXU39XLC	8
223	3122J53CUB	YVT4R3K6N9XR0HDVANQUIX1NDY3ZEU3XH7319YY11ZHS5J9PRH8J5RWA3F03AV23F9J2OMWMZY2TPJS4ZNI6VT20L273750G7ON5	9
223	8OI9QT5AJF	GBFVVUGYCVUX5DXM5IVGTRWO3P48WWB5W5SLCL99VBIHMFC1C3BF1YPZP01GZICQTYAAUMKUJWVSIPBXND53U6E7P36MT2JN92XY	2
223	8MD6C924TO	BG0TR5FD7QAYE3WNI6WUDU1P7BRMHSQ1NSL6EJDA93SN6XP8WA05ADBRPLVPO25O9IKVS0I92WUJCOTKWSZH2U0KR4R3YXVH7DNX	4
223	QBAUG43EX0	3Q611DOT2OA1L36CYWPSAEXIPKEANL9B672B3QBRL0YPQBN3ZEJQ7EMY2XMQ8NFRP95OB4IIV8GJQI2N7LLIBSD1UDJGEUS8VHAR	2
223	2UYP83OU7H	8245B598CIU58TXC6P66D37VCEBPIYIHKG8SQMAXD3R4YLFA55Y1EUDF5J374UZOAMU2UEWTPJ2KLC618ATM9RDZD3XGTC3SDD4L	7
223	M8LP7EJPJC	NQ0JEM52332NC83AMOTJ4Y1RQAMPJGIHUAVU2D5EI7K943RE9S0YLC6YYJ3E9PSWUV2BNJIJTOA6O1XWTIP1PU5SE65TK0F2PXOJ	1
223	OE7G4D95TQ	P10JRE7B9K7WGU191HAZK6QOY82JHR0MNVDRZR7Q8QEV77EGO3XQOT0SKLVTLY3RUUIUQJJJJU0414Q14W4O3J845VGO6OEJWXBN	7
223	44GWYVQ941	T0ETOH3260Q53ZY3PYKWOY5D5M4PQHE3DCK604PCEB940SCZPQH900K54BYBMNLYVX10P2CUIIRMZAMMKE9AAFCM2OBZGNZ0ZKID	7
223	WT1KWZC2VX	LKXNW0SI7F4YL1HOLYQUP8A1NN4S1XP1JV84MXNPUD4JGB5WRMOV2SLNK6AJ59RKZCPZ3NBYLBALE0UMRIBOJ490JVUQWDTVWUUE	6
223	XA2SEDHKA5	F3EKZK1SAITLY1X7CA5CYPH2VBHROZTFP0MP6DTTIIJMAE8M6XTTYB7ZVLZYCJDLZN67PHA9QL4QG52QC5V1F9QN2W3VO5Q9E8WW	3
223	4UMCA9GGS5	A6YWUDNHRTZTIVHYMFZ6SF3OPUV54LIIFIC86EV6DGLCDCFKIL227ZZ5DKH9RSNFKQNATJ1HT23M40KNPLWTSPLQSH4V7WPV3F2W	7
223	OXSSA6KT74	F09TVJF6NANA4UG63W5F7RMPFJ7NHTY8XYJUXA7GFTFGQVDBIZ9S6R2YOTNLL2Y4MPMGLVI2ZZANMF9UG5ERTGBG6VFDXV4N4K3A	3
223	RF62QV59AC	70XQH3HQOMJU3FQYGLGOGK0QFFD5WSBM8KJFRBMM4ZRI6T4PNZX9XWDXAGLCZL46K6WS6LGF93TQ3RUVKYR74CYLHWEKZJXS5U89	9
223	EXSGMP7BN4	LTCSSA4DW4TW01B46CIIKLKG6QZFBUISUY8EOOMC3IU2VY9SWY8R00WAI6WBKZCBVABC26PS0FPC0SUIQGSMW024B76S2K1EGSGV	6
223	DN5N8RS3G1	7Z0JQ1ULUK0LOUEGZP4HHA4A6ZQOK6HL9VTQ2DG9HSRXGGOZX8QDLNP640M0LGBXCOM2BXNWJ59ZTH30L00MQEAVGWWC0PYBR3U1	8
223	TRFU14BD1F	VX9U34QOZNX6WOUPYH8N1WOBL53H8HZWC6ZC11WKUHQJ8FEADW2WWNC9J8I8AIPSXA4ZZRY6UX3TFECF13DMPDAY4Z32TYJL18W8	3
223	HDAKH5P9W5	PLW75B8US3E5DGHEDCTAG59X6N6NS2HSE3LRQOUCBDL6Y6PRCGX5C7FUL9BREUB0WW1J5ZYZSQ9CTD897PLLFLPGY1FRMC7QCVJC	2
223	FFWE8F8F46	GWNS7NW8DAIACTZJZVKGUUDTGMPTSA83641283H83IV17RKSIHMA95UVS3MV7DQDCPEH26L6OMNM9MWYC6KKX74AKFKFRVA01SZR	4
236	IQ0VP7I4EQ	D0L6PWWSHWGGXTA2FPEVD7WWFO2MXURXFL8G9OILHRCTE84C98WCU6JGDZ0A4K5WESBLU420G2NW4DSHUZMZ8OCIB2CKYHR7WPOV	9
236	HLAPWR5SVJ	SSEF562SXLAGTQE7GY0Q2J12SC9KQAOY6KCGHTCSKZORBDE1M9P1YFEI1MW26RCX7LKJN8ZWVHGD5J0O7H8QUXA1F3O47JV2X1U0	8
236	3122J53CUB	5NOJ3FQ9BNRWH5YTVDJLSDUT4ZLWNPEZAVB4UG0RU2EQ6IZO6JBXKOK224OE34VVI2WW349OM2009EXWA7ZEOQPVLJBZ1WY0HSHE	6
236	8OI9QT5AJF	DVCJWLSYU3YG2D6EQH2NAKT3JWZDATQ7T96LX41E671QMS9S1V0LO0V2CIA9VOXAN1X2HUQWPXQDTDQ0XGLO3ES2OEJO41SSJ0DV	8
236	8MD6C924TO	GLGFE60KSI92JMOCIHII5OCLC1XE833945Q5EJZH1R66KWUPEPAS4N91I5DMIWMYO97O5T79SBQOSGBPGIAS3LFR6YWJGM8FFIRL	7
236	QBAUG43EX0	GTURBA36UJC4XFAV34D4QSG7Y2FCKIKZ00AYQB1LLULPUPTG8UMNNQIXNX3I41WM9ME6ELE1D2S5H1NJJ9DZ67MJSML3HSQT78QH	3
236	2UYP83OU7H	WBXPUKU8MQWJU94Y6QBA5O29LUUL88IKG8X7QJLX1LG5ZTXTV5BSOGPIJXEAZI9OILDWL7IXEOJTH6J16AZD7Z59SOX2FL7SL1XO	4
236	M8LP7EJPJC	BHYXOO975ANNMDZS5RSPED6KPR3R0IPI5L52BQSL6CWOKO2HIAQKE8L7KNH6USHXUESAI6RP8HTBQSABZWI01FE6A7SXIW0N593F	9
236	OE7G4D95TQ	18MTAM6PJR2NGG8JR5P9VALO3HLRFGRY4E7X6G12HR0QZKCQ2ENDOFL1X8Z3BPJC9DTBIKMKEW2DK4YSF5ZB2OKY2GA8Q812IXRV	7
236	44GWYVQ941	AHR1D91NIQ2JHXF0HKU34ICJO3F594WNC1EYHKYPSKUZHYJKVCAN6261EHNK36NN4PHPTRS7VFLTYMCZT5J73JRK4NTA7OVW7H52	5
236	WT1KWZC2VX	31ETD20RMD2FX18WPTV77UF8S9GUYWQRJHZDFO0R12SK04JWX9RYK5UJVFBEVG2ZWL6QB4RB3DGEC5HY0U7ZF2GNWQR9NV5VA2XP	9
236	XA2SEDHKA5	2V2RP4GYQG08NNBICU3ES3VNRYHIVDKH2079FH08AZGK0BAH4M7H3LP99O91W8DM6TFWQBD445D3WLWQX9NIGCNRK890I8LCV4NH	8
236	4UMCA9GGS5	N12ICN7HWMY2TDXU4F3FYMSCNW5UBH17OUKIUADYQJYVL8Y5XR0YUCGAJ05QSMFOU1N82PA4CFYOX61O8A7TRDNLOJ84EXGDEKAT	6
236	OXSSA6KT74	0CIR6WON2MM8QSSPV7RNBUSQFZP8VKN6H4H7YCUQ87W6W5YFYXSNSGTGT2LHGQ2R9Q1WKU0TMAPD8V3KAKK71ANBKBN60NKSFE7G	2
236	RF62QV59AC	C4D69AS0PH88BG6G4Z9DZLIH4290783YXF8PGB294K53P8ZHNLKO7DO0W6CGB13ROJK6HR937AIPQO26D1NVXO0U1I3J8V7DROPF	6
236	EXSGMP7BN4	296MQR749KHEGDJOH39S0E9YZ4LDE8C9WIK2QJH63Z28VF2SXZJUPW7YAIWVG40AHHS73R78WCZAMBCUC3POYRT9KW2IWV08910O	6
236	DN5N8RS3G1	4YG2K8N77L8GCTNOLLZYSWGZYLAM0BVKX6HEJWOSGBNL3CUCMTXPA0EISQD88AG5ZYSFLIFZ7HRQI55W189GNFJ719W2SPUG5RVE	6
236	TRFU14BD1F	O0DO8R3IY9WVRH9A9STOUOMWMGSWLV1K0BNI52OYQZD99HAIUF59B09ANRC19H6CIM4Q31EHD585KMXEGKBGZ1IACM4OZWZI2A1W	4
236	HDAKH5P9W5	UO3AY5F2EZA37VZG0NQE3NR60SQGZCJVB1V5HFA6CI7W4V1A9CBXLSTG76KGO9CBQP2GA38UMTBVQ4CE0PGWAWJSHO8L54RDF5GO	8
236	FFWE8F8F46	VAGEQK1Q80C4FP83PB3GJ9V4WZRB8PUXYLFP9STLRCIY5RZOTJ04MIUVOLR13ZSTGPF4KT37RSYH079F9CSYZ0KQ0TAYA2S1TZSQ	3
237	IQ0VP7I4EQ	5E9Q2N4TN5RMM10H33QEZD1SE7YA7XAPS4E8TI6MQ6NYTMYB1UZ5BLV1NRL5Y3VZ4B3RW1XV7DX20C82IWIN7FNHINVB6BXWLX4R	5
237	HLAPWR5SVJ	GOA6E88X2BKSTWBUI2YYWJJGWZ5PBRCIRJBIIQ3GPTPLKTNOVBC5F367F4KOCSWL9CBKV3M29SJD385CMR39PHDXMECOFOD66EMI	5
237	3122J53CUB	D32ZK6WU3EH9HCVZX519N7R08WUONGYVWUJYBJFLQCS95P8LSGIJUJEFLB1XLHHXQVMX36XO0QSLPR4TYI6G8PBMQDMASR9I55TK	1
237	8OI9QT5AJF	LSVT3SE03Z4GH9CLBYAU9GZUX5JQKQU7UQN0KXE66WXNR3KR773GS0CE3B58JXQNF6W1WMAOTEXNTLC3V1TNWNO3OI7J1GXJGKIV	2
237	8MD6C924TO	T4U6PXODYUR9BMSEC02S2MNP1WNQOHJDRWC68QH090ZYPJZ3EEDTPCOGRFF2J8ZRKOSPKVFWTCSCWY9R7TLJE0XOI5P3LPQBAIOB	7
237	QBAUG43EX0	KTT8QAMULU2FY40WPNU0EGPGMKDWQCOK7ZW92KXZL37KWXXUZPV54LXDDMWG60EJFRH8I03FZ4PKJETZXT6ARTQWCS6QYR3UZXFF	4
237	2UYP83OU7H	YM9WPF96M4927SM4D2WAV5Z4NRIB4VV9OJ8H6OBNR00Y6X08QZV5TE43WFJ877B0IAOXTF8Y1IT4EB7Z0JVFA0PJPFV1FCQTZAP6	3
237	M8LP7EJPJC	DPK16ELU9YVHTIXM50RUEHOUGTY1AFEVARW4KNDWEZQQ9TV33G3K7ME5A0UNPTU3T9HCV2CSX5QP17UW7584M4XYM14U2ZGUFW69	4
237	OE7G4D95TQ	THAELWC6YECF8PUV0RZMSZ48SZ7Y5KEBUJNX7ZBHV2YX1O4JW8OFHX44NCVVZNAO9BUYC6YAPR10BHGD4XC65837PTK5EPSI1JX0	8
237	44GWYVQ941	GH0KOZZ6D2F5R1BLETAHXISV36A8T81UQKYQLVQIEBL0F9WYR6X0WTF7ZERSZ0NFBVOHCU9SC2DW61Q3KMRWKB87E11GE8TNYGZT	6
237	WT1KWZC2VX	OV67FX4PTA7YYINJ049WRCL32NEIZ80B6I50UZFOERU03SQZGD7L07DMJCE1SVZVJ61PNWYBZVSARUAK7PCWAPL9FSQRUN5S19Q7	7
237	XA2SEDHKA5	AMTP5VEOD4YC44DSDU4U1K4FGRM0AISDDS6CTGF3GVCX1P0S19XOWM90RNIOJON4MV8L7A96PBNGIGN1038BUDR0TGVF80T2HHLG	5
237	4UMCA9GGS5	OU0908U93RK9RXQPMJIDI21P38ZSU8A5GKLIIB3F610YLGRCDN58CDIW3LF2JCO4RO2HLHHLPDGQCDEXRWOHCB3DBZP65B54N5G6	4
237	OXSSA6KT74	J06FUT962U0GRLWYG1PVZFW1KPOHMDG6IKH5SBSS4GJEZ0NZJFGD1KYEEE5EF1UYN38HE1FFJ71S6RBUCY8G7CE7VC1OGONCWU05	7
237	RF62QV59AC	FVRAB44TFIWCLCQ3N1LYBVB9184TY6L1F36CQG5IKNP4FL4M6JI3PGZTUSJCAK5J756SFOMH5COYFH4PDSXOXRL9DMS863I9RG7K	4
237	EXSGMP7BN4	MGS7A7N2BONY38RXQVPT7O35OKC4OG9KUB1MERWT8GC8FKD50MBUR0Q8MWSZ5SN4ODD2HFS985V1M50EHHDCFO23U39S86YP2HTC	2
237	DN5N8RS3G1	LXV3CVVEZVR5OSYPLZ9KKHNGAABHG8ELY86TSJD3GZ4HSXUO9ARSU16DKO3BTO81RFHQWF6CWGEUNGYNPXHGRW16C2JDPBJ21D0M	4
237	TRFU14BD1F	E24DO5OXL0D0QV6G2J4OLO363WU6L3JQL7L5NCC0MI0CFM9PNV8357DZ87J2LRLRQXPSJB2ZGEBDX10QWET04PVN4W6P2KP56JVS	9
237	HDAKH5P9W5	RFL2JX05ACHH3FG7VWABBYXEN65ZGGNFITF9H8V24R3TYI9FJ7KWVQ52SHPN1BZ3YC9K9HZXBHHT4EPE6ZPI61T1XNQASHB22A4W	3
237	FFWE8F8F46	ZGBIXUNJL7N1KQBVQ77SIWV0ZE4GO14J25HTNAIGGRLPDII09GLD7EBCULST0G5UDE9PJSHQZ0L0LGXQ6DHHQ1LY3F8CRZP9W1L8	3
260	IQ0VP7I4EQ	2RR85NH2K0NYBWX9XDM2KVDTF89KMDU4YHDV0IVNE6SOUNQC2A9X9F9HO737O6QHGTA4TCJOS8YOCZ92S7SLE65SI6H2PY9HQLIB	4
260	HLAPWR5SVJ	VT00UFARVEY8AOQOECKXRWW5Q949Q70R7P6O2UT14BX1S4PJS3LI8N5964KVKBAXOHAVSBWTTS3P95MVUVQXVRTTT7R7K8Q3B9NK	8
260	3122J53CUB	31RH2ZPUPABSYBZUMB6YQBUTYIUBAO9RC2039Q32D9D7QPW61IY8RVN2G7STFOUBBTP6L5V6HEVR7XDJWXK1ZAAQO7XC7JXZPC66	9
260	8OI9QT5AJF	ZV5X20NA55T3I6RD2MAT8RNIS97Q5B50HK7COE6JWQTBDIYNFVXZ5MAIHXE326E3A2W89OZXP17S8LEJKULKOF44JY40ADQ0LZBL	6
260	8MD6C924TO	0N059JEPSK5T4TIV4O472ZKU9WMKGGIK3XTHUOO6ZO0O8HGUIERKHN4BCG6M64IMBVZG9ABQA7HN86V1Q1BBZ8DQ3SFNSC95FONN	5
260	QBAUG43EX0	9VIDBKJFQCGVE6E2HWDSJNR5X878MHUTIKRG38YX3LMP92NF4C81K5IVDMPCMK2JSXM3O78J8PY8BB65U2DJI2JMC6DRSVLSSD6M	4
260	2UYP83OU7H	T16EZ24GKUCQUSUHTA0NA1S4R0NEFP7FUPAAGFT9OG2LAA7C0L9CG8P1JBW8PZB4W76ERTANR0939G4Q2KN4P48VAI1ETUUYE7ZD	2
260	M8LP7EJPJC	3VGKWVP8V2DHFGFMHP18KEI2546GKYBR0M9ZHT3ISXOQX7NOPM7S7E3YMNP1ZJY60VR2GPEXVTPXZ2F8QS071TUVSKM3EBTJ9SZC	4
260	OE7G4D95TQ	UH9HK6OZG9UIQKGS0FHB5K5DLTT9GYHCCS6K10QWG6ML2UX1N0IMSAUKM660MOSS2RF7O50AYU598UK052VPP4UC8V853ZJ1N3SK	4
260	44GWYVQ941	0MR9IY8FVM1VG5U3DD87D9275G8KEVECALFPEQGGV6NIGKX4Z8K0UNL0TTECZXB9IZU4ZFYX62LGWT0UTEVFLORX9O5ULEQ85NAR	7
260	WT1KWZC2VX	2EUJX32BEE93TSVC5Y3H74LJEL2LNLITI509B6XUZV5K512V56AZGK173KFLBQY36QUX1VA8AJRM9BNMTGPQKSM8D3G01LSI7BNO	2
260	XA2SEDHKA5	E3K5BZ72P727225BHSNEVU8PKHY1JO7X8FONFVJ3OFY5N39TXH0TAKVU45V4AFTBAF8WOR6VITZP5CBRHFEBYOXYU4SKAP3JWX5I	8
260	4UMCA9GGS5	MEFKEKQUFY23EW5ARMWSJCU9WV30Q3IH2W5A80TDGEOF0Q528IEKJ0VKUGYSQZDMQUAR14C03SLFYOJFZB2HY88CBVQ2CAWQABZF	4
260	OXSSA6KT74	OBEGOQ0OPWF6T3P76YRW8QGNJY254EWZDZLAYBKRHXV8K6SHHTENHTR7507ZY5TL9P33RPJ5OAOK5HCNFVXLAJSTIOE8DU3MDK94	1
260	RF62QV59AC	ZZ2KI8GFHCYXUUCHIK07JVDKL14HBGVIIKQ64B1KLOALQKTA0F59I72EVS9RE9DAQQPKDGMGTQW5U13AI3Q6LW9KRMKMCKFLKA5A	8
260	EXSGMP7BN4	J6U3YP1K6T4Z9ILSHZ4QE2169EJLKVU62E976DWGH9U2QWDB32DKAU1QEX3TGQAL9774JOWECYIEH8QNBHRRRJ6HMS2IJCA19I3S	7
260	DN5N8RS3G1	I2PG9HMLWJGHQS88S4ZBZR0VN4AXQF8F7X2PCLSCT60JWA3TB3QOERA0C33EHY5RLAK20S6HLXR21Q9MAQWXYTAPWBNIRN45AI8V	7
260	TRFU14BD1F	A3S7JCRAH9V4QE1CI3194GYFXZ72W2SSOV9WDZPQTPOC2OBJC32PHV64ENJTEYOPQCP4EF9SOKQO1WNJYYZ39CL2ZFRZQ5L4B9VZ	9
260	HDAKH5P9W5	GF73KB6FRCSA95Q8VQN1WE9XJCS8VN2AXLRT29YBOXIC9ZQA56QSH8LBFKUIS8TDKRNYN7GW1MM967YUVSDZ6J3YAPNSOQSQEE1R	3
260	FFWE8F8F46	2W7Z405WMFIWAWA44GAYYX8UYHL4541FGI36F9CT8CYJE5O3RWK703XEXNBWPB1RNCP13EZ4ER0W9YP23RMJU3OMVYI18PD6KG5B	5
261	IQ0VP7I4EQ	XAN6P3JDAF98J37YS6UYCFE676YN3L22NMGR9MEAFJVTI3ZWGI2JLNNR6Q9TF5KYMGV7XQZF2TT3UUXEGBHUSTQ98YUSNU5J96HC	2
261	HLAPWR5SVJ	28ZTXR24U6L24NDYZG3ZW885G2HYJ3YNV7ODSB5BYFN2J0SH1VK0OMV3A3M5JDU0H7G78AFXK1ARUGWQJA6YT89JLUCYZA2VUXUL	5
261	3122J53CUB	VI1PWPWLEI4H6VIG6HJ87VN7R8K9P67VK7X2FJ7SM8HMIR3OTOYQLNW9447YFX6HLI787QBWK0W9OBYAE5QAIRK6KY7KLINZB9AA	5
261	8OI9QT5AJF	4QCNBGU1XU2G7TJH5937AXJS0LBM67PBXQKONXHLZFXDFENYDSG9HCSGHUWZEH4ZF1SRJ53I2SH5AFNV8MJO0P4U7DH3ARGSK88O	6
261	8MD6C924TO	6PIY8HY5XGBGA128P9Z77TFXAHKLZUBH99B6A02HFZK7GW9ZOT48IQZNKUX07NFDE4HB057ZGR1HIIROIU7FZD8SKYWQCCK2TH2L	4
261	QBAUG43EX0	89TVE21ZRECDJRMQ9NB5Z1BIRXEG9XBPFAKUNTULH32TUM2U8MT31QYH8KERXUZ3CW7JH1CQ20Y68RXF5UIXEHXZLCWCPDXWD9Q7	4
261	2UYP83OU7H	TMHJDBB12IQW9WCMBZ59I8FE9AZCB29A00LIAOAGW7S4GQQRUKBJV8GVHCKDM809JP6JK4LXYYMLPK7TTHR01ZP1T0A7D64XGTU1	5
261	M8LP7EJPJC	HH09NU7V4G6F0TEQ9IUAEZU3NT14YE60G9MA10NERFYUE2NNZGGK91PSW6W32D60JF81HEZI5QS8A9ZUGOES7V0PU4N5ETLOJ8K8	8
261	OE7G4D95TQ	VGVR8PTIQRXHCWO9O2YOTHM03ELFEZBZ00VISA9GHGDM0YC66P4FWTKO34X3DNE0P7QLBFQO3RHNDAAFBPIY56DGPGPXNFC3BM62	2
261	44GWYVQ941	0418QMEM7L34R1YFP5T3K6503AXONM0DH8LUR0PU93S5V35NOYVRN9649AFPYZ8VVZWTQDYZQ94QO9E9FJAZ0I0IBRURV95J47J5	2
261	WT1KWZC2VX	M7KA5ANEQP95FJOZJ4M9OR9TGEQDUVQ0J23MZZ4IMDUBUVPZQUVC76247131TJT49JWNQB9U9DXK689VY0WAAO2M98P85CYCU0CK	9
261	XA2SEDHKA5	CJPUAD3IS792ID3XT4VRJNSWBY6PV0G5YVWRHP9K8ERBPGX95PA5R3ZZ02SLGOX20DDWRLPD4KSE5RG5B7UGZKO5560O6YEURZKM	1
261	4UMCA9GGS5	BSU96BGKV3JWXKJ4QCPYI0UUAHGF7XGG429OAG3JHUKDR2JN50AX4X4L899Z4BM7XC14K43KJGQYPQDH72KHWTMH8YQAHDPGHNQO	1
261	OXSSA6KT74	ODB60NYGG5R611B1FKD0T5VO3CF0KQCAZGTZJK6FYB238EQMNPBCMXRSRWDXI75Z3RHUIMR4N8CSD2PZW2N4O9XBYAIWHJ60FD9Q	9
261	RF62QV59AC	5EA7HYOV9PZHOAQTBK44G6IE5XEBLMA2921YM6HKIPZUTP3JQHE2FV0966CTUNKWP6HWI2GECTW0GXVQ45VEIHXNB21Q4Y05FCFW	2
261	EXSGMP7BN4	HAYA90V9A2ILVZZ2FOHJ4UQA0JO31VES8JW56DIRBNB9TEJ8BD9X7NMWTXK0L2IOXZNMC35BG0HQTQQWAP1YVRVU6ALJ3SFIFWM3	7
261	DN5N8RS3G1	75HH7RGF6DCHYZ5BU2GE2PCSWIXV9L6EX5DUUQY9POA7JBF3JHV3FZ8R3ZVZ3VGVG7T2VLQEEHYNPFIUC4L1ZC977W0448G4IP0L	5
261	TRFU14BD1F	MH70QZ8BUCYQBW8JO5E8W59VWJFA4FAO7CZXOBINA6MTCO3LHU3TWN5RHMEHT7GOCJT96L5NW070SPSHQ33JMQ2TGIQB7B4DZ8R3	8
261	HDAKH5P9W5	4P6ZP75QF81360ZE7BVQ92Y43QU63AU8ZMWO6T7T7DBKYIAKE9276N5B0B69M8WEN3ETEKHNECT60NGVPK14HXBLRUX5X7G8Q664	1
261	FFWE8F8F46	QG42P3348KN5LTCG17012CTWL0G6UP4QLR8E7C24IRSJKAMOD1Y9GDKOWHQYW7JTQ6T3U8JZE6TKTKMLN12205KIGURZVDHLH93N	5
284	IQ0VP7I4EQ	S3FS94JTA4M5EL5ER2VWLW9QTDAZIDUR8448XJ1ABYG0F4Q2MG0GH1F53Y954TL6J57KQ6RHBVVXQJKZWINCMOJHZ8E9K5FRMJQK	9
284	HLAPWR5SVJ	GMPZTEWGSPUNKIWGJU5V0UR2S7GPDKG3A2P58M3JXAHTUV9WTLDZUZGW4WHW8GCHJ0NS30H61W8ZN8I67T62HRIKV3ALFHLR89K3	3
284	3122J53CUB	R32DG781RJ6OKZOJJA1SC69Z50UKQ1NYOXP0DYATJTEUE74R6HY9SKGV3DHPNYKZ5I9XJXFU9IJS1PV85COJCNFER36ARUFVJOY5	9
284	8OI9QT5AJF	HIIBDAJBX3ORJTLJAXSC5GQ1EDOCXIN0ZBY4FH9N6C39STHA4LJ1G2BB1R69VGNPQY1I5RE2YEG3MQJV5NIM9VU79WCXL91ZZOT3	7
284	8MD6C924TO	9FMGQCBVIYLILEI8AP4D4IJOQRZNRD87P46I5FTSTL070P95T0Y8YZ706708NYEE0O2RH9C56MUTRLYAR430PAJZ6FM7PUF5HVHM	6
284	QBAUG43EX0	SXUY3BMFNJUJZRT4NZZEDUCXEPMGZM5ELO8GJCV87UT61X0DVA36RHT8U6UNZFPBNQ8LSMVLE1HSAG5QZJUZS9WD49WMSHJ1FRSL	7
284	2UYP83OU7H	OUJOS109B8NBDYPU0SN35QSZJ36RPNTXU1KYLKAH6D3BILOT4HP8FR47CTFY5JUXO0RMN1IPSF71XQR7OMXI8URC6NW2ELMXTFWS	8
284	M8LP7EJPJC	BGC89QAUCKVCHJTVLZ4IOPAFQLG3KIS38DNFUJ8DRS3DA06B2BHP2KPWG7SYKHJ411DE6NBC0106V7EZOEAIACBXY09X0K3KI9LI	6
284	OE7G4D95TQ	2EPAFYAUTAJ23JFGA4ZZQPGNOLQ8QXWV5CWAVI4NBDF0047AXDHEWTGM8BW3ICD5NX70XFV29LYMKPXTOPKMQR9M6JBTWBF89JMD	9
284	44GWYVQ941	GMSRPFL44BTOCO211P5YU4OECG8FZNBCTWHC24AMYSCHSFTWNGI3RPMM8OPJHFERAQ4QHZ96OT9C1GW7WL2SEHVEJ4EOP1FSNVHB	3
284	WT1KWZC2VX	DPXHMP7PKV21SW5NVM35ZGMVUQWORYG9UWS6EL22XZ9JMW6EKF2INFU7CCW52T7WO2H6E8IKUBHAHDJ8USEM58VPBV4BY69E1M5T	4
284	XA2SEDHKA5	AAL6SYM8U093XLKPV0PG24TEHVXBDI4HZTUR2PNKIQR44HAVZYFWPMXFRGZ6AL5L61EE02WGMF7LMYJ9UBMOCH2M6OAV0QJ7VF8C	1
284	4UMCA9GGS5	646C9JJOL337ZL89QJY91IM2AP66AZHZG6YHPMC8S7UVHYBFK8E6KCLXSEBUNNOVVD02X1UEGZR3X1VMO1VBVLPDUBZKKSVET89D	9
284	OXSSA6KT74	IRTO9ZUVR90TZFW2NAKYWHWCJ3YEMKZ2RNGJCXVV4SDB81VN8MF7YPMA5QEFBQIGK8BL9NZ0PY4DEUDSHLFAF1DCBFNVSPUNJ60A	7
284	RF62QV59AC	KNVWPSAUI5KNW7ZLIBT49K39EI9DQ3I4D377TNZIDR2KCI5R4CB4HFZAUVSHT6EOXQK3A215MK1RRS76MSJO2NW7D7M75SZHNOWV	9
284	EXSGMP7BN4	BRCKGS6OISBYV4AWZVK3M0DQ394UUED6L8KBHEW50S5OKJJXYUX2M2VLNWQGXM4DPFMXU9PV9OD45YFU0G69QLUTN9XVXQHNY18F	9
284	DN5N8RS3G1	WDYEC27Y0QYQ6PRP4WEU2JUM48SHZGD09WEDH4OSW4WS8E1A083E4UEMSMKEKZ9UM8RJLNI9HW87XBO0GSR1M86OR1V5UKI75BG9	6
284	TRFU14BD1F	RZMZ37HWHYQ7U72IHHNCD1T2NP6NBBV5ODZ2EBTBY1KCE7ANQYY437T0FUMOA4VFDVTQI9DFYLNLQQXPPT7MN1BQT9XUZFB4GF9T	4
284	HDAKH5P9W5	TFRVSGRTIJY669Q6J1MTC6ILSPSKTELREB5NQ04UU7LZ9Y2GU77NXALW6FCCXHAD8H14DCQS718FVTM4WMZVH73E0JRKY17M6I12	9
284	FFWE8F8F46	8CRROQ6BGBN3IPKRO5ANXE4VF4G3WIN1T7YKIE2R7CUHERPLW4SM0OI3H6LUKCP7YVJK1AJKDSQVUWRYO4H10BAEY5CM2IH4XWTS	2
307	IQ0VP7I4EQ	EUWUIJI8XJVOXFP5XHXUEW677R4LV78D8QKKUGS12GAWR7ED299O68CSYYW0O6N0KRQG5FKQZ518VJQAN1TW7TH9O1V6T1N62KL9	5
307	HLAPWR5SVJ	8HWYTZBGD6OHWNXN021KQ2DTO77R5FK8RTOT68O3G2K4HY7O0SCRTY9GEDKV2TL7VQ0C8DR2O8EXRIMZ9S1MD3O2UIP3Y2BXRMJ1	9
307	3122J53CUB	5QWBJDVUMY51UWJ1842B7S0YXEV7RGF9U0ECFL4Z3IHTTCDG15TSQ0AM08NFRYCGT6G3RHWXADIZKGEVBPFVWWT4Z2LG7YHEFBAX	8
307	8OI9QT5AJF	JYTJ6SNRLCU41DCSRT6NLEZ6PZL5DUIFQ010WM0EGMO01MGVFVXSEKUF9X4GGRO13ONBML6F21H8Z9EDT00R60BGGW19SU8Y8X6M	9
307	8MD6C924TO	EI3ZS0MDVP9S0XQ174CNH5ZU7WI3SACC1EOR71NAYCVG1Q16R6B2490JSI25RTUUN71WI94FQCZFKT2Q5LLV9JI2NF8Y9RSESA34	7
307	QBAUG43EX0	FYSC5L1KV89PLAFH8VDY8ICAFF9UUWJZ810X3TD8RS2G8IXRM7TP0F06VR6ZMHZ8ZKRTJSOPREHQQ6C6SRHXD492B3CLWNVK23RY	7
307	2UYP83OU7H	DH4SE7V8KQYP9H49C54LYSPPC2ET7XWONFOJNE97N41NN6WF0K08XNCV2OQL2CBW3KB42VW856741CBGF82W7Y1AC3R8YXEK3ETD	8
307	M8LP7EJPJC	2NFY2C0PI3ZMJG4KOZFSB18DXJI2WBWT8MNVW7EWBU4A1VORKAOPOV2AOCBS482GHGO73IXQUSRQ78MB50RWWHENTMHU6W2C2Y2U	2
307	OE7G4D95TQ	RYBM845ELDPZ9XDQGTACBNQBDT80OYIG14OCPJYMJJHJ1479YWWE2SFDHAJO6EZX4J8EIAA64X22GHJJV8B1CENIYL4PAKPETUOS	9
307	44GWYVQ941	30XVZJE0N7A0927C7V05ZP7GV5UHXJW21N2IOGM4ISLO3YARRCV8YWGN3RA4Z7CELI9W9ZY1J5XGETM64CZVXXDEGPP6GRELQGCV	7
307	WT1KWZC2VX	NS2N3Y399IJED9XHQQXE5QUK1V11L07Q1HRU7I48KEGGF1CSREA0PQ378RVI7CYJL2N5SDJIWY40JNF9SJJH0HBKNTWQWWBIQ75M	4
307	XA2SEDHKA5	HAN41E0VDYUMVZY2QTE1DR8R3WAXWKMR2VLI5N8CKYK5BEA6NPAN1VLZB6BFED92MDUAOP6CUBROHDQYVDKGJ8ZGKVH9L38HYRT8	6
307	4UMCA9GGS5	AR7T720E6S8QMTA33SNNNZ2I611DKZZUREUVMXMF9CNDIT9J7O59FVHLYZWGBX4H2O8I8OQGGINKLZ9N2RF530O67J7XAGEMIGK4	6
307	OXSSA6KT74	0KS7Z27H699ZIOTR8NC9CLYR2F9EBCFOE3BHX8E7QZBK7722U5K2H5SPVBET33G34UVOMM49JFSMJOU5NHTG2MHJLVVV3UEXTHQM	4
307	RF62QV59AC	NPIAKTCMFFHRJGVJAARNLD01IGYA53C8HSA1LFS3E7GQNEUNSNTG89BKYR2E4BQLDJJ0G384SYIO6KNDVLSSK59HRZD4MO8DQ5ME	8
307	EXSGMP7BN4	3HYOYYK0WNNDZSTT8AHJCIQ0ESEZF7B7II2D3DWHYQ4MZ0X6PTS4F42U18KGUUVZLQ4Q0PZ5NAVVODBN4HKVPH2OPHM42QXE5FBJ	8
307	DN5N8RS3G1	GF94WQFJHGX76LMK9JEXQASD4C7NQZIC1RXCK120XEIAZ75EK3657VOGW69UT12R8VFPYK9HRNAM2SO7G2CX3MEGCRPO2IH5L1CD	7
307	TRFU14BD1F	QQA3YOTUCNESBN0ZFXVQ9MG5VPIGFAAPKF0LB3E7VVADK605QFGDQX2EKFIJGNPBNYH6WPYLTX5NLCUYYN09478WMVB5U51HG80V	7
307	HDAKH5P9W5	4IBR4U32P2HVUV2WQHP0UTAN20X5XHNM993EZS9MF4734KAJ9UZ1K5EKHXYD67FIP4WU1Y77HCU0WHSS0O6CRVBD5S6B45QHYYN9	7
307	FFWE8F8F46	QRKX2THKNYAEGNSAD033SYJ16DMWMB73T3J6VPYC32S466YS8GV7UGG2IT0ZHV7L0GVMEVPYC19ZFP4AP3YFQ9JNXRXBY95H4HDZ	3
319	IQ0VP7I4EQ	LOM1753GQW3Z0KN71407IZW7N9C6148LEZDPLOTDQGG54M8YRKCMM2CV1OO736OVXSUAG7WNLXRCT1DABNOR1W8MXSY79WKT1UHM	8
319	HLAPWR5SVJ	7STYZAZKAC9KN5PS73ATHNYIZNZM8K8U1ID543CVJCWPZWW05B30G3UU3K9LLNMZEPTF2TXE1OJF0JTC19Q7QHN8YTCT31K607LK	1
319	3122J53CUB	Q8MNZ91TP3U16TM6PI7BURIRDKAENP37J9KBET1HVPIZR27H89KYNIS9Z4KO9XFAAWS6IL25QZPFIS9KN2FOEEUARKLJINI8JIZ4	3
319	8OI9QT5AJF	A8XHOHY3N1H49AGR155CRP79SXDRQ592FAN4SGZ66GETDPJNBRRM322UAXY1EGMR1OZ9XM9UG8GLLO5DNZQ9NW9MI234R72Z3W1Z	7
319	8MD6C924TO	K0YS7G4WRIW1VNP0MDFPN14TECJGQRYWGND91RQQE00TGD6TN9RTWJMT5FN47XF9T9VHJP85WYLXAKMBGZ3RAFA6BUDVDWTQU1AH	5
319	QBAUG43EX0	YJ7AV678ZTV3MYI4Y9O8YGZMN1AF4CIKETRP6QOID8MBR217LW51VI3SUVX451DWKLY3G27HUF5Z3X4U9C4IHRY5Z85K3TNL4Z1G	2
319	2UYP83OU7H	70SYXGQNEY61D4275P3W2EI7XOB2U5E6XPCLMTTKISVJ8T0ZUN9K8TM3SUBJFX2IUADX2QVL5SOJT89DXLIG538EDI31SKEUZMY7	4
319	M8LP7EJPJC	D6D2YPPFCJTV7V3PWM1C9UTX32VN3THJBXUPENHOS8A9JFUYLED975QTNP854BLSCJUKAOLIENTATUOYI6CYQHMFGBBYPMTQWS69	6
319	OE7G4D95TQ	KX6354TMQ93BKW78XC47PD9NW323CNBXOD7IG4UN330BIWEZWS9PBCFGYTHCCZJC8FXGYY22RRDVM7E9YCHUOVVM81UXXSLDTYDD	9
319	44GWYVQ941	8A7ZG7U8T40OHO9SYYNTKI7DFF9F9BY4B9ZBJ5HXBNO63IPDLV5A0TYZD3UB7P8SG6MIY8J3RZS74BK6Z63OGYESKA8PKFZVO507	8
319	WT1KWZC2VX	HPNMBSAB15BTXLBVULS247Y93SL96T8KNBSQPCFFDQTE65X3Y94UIEAJ1OSSHAEI61GV2UGRGMYOOTC84RL6ZOBIAJZBUW7DLKHF	7
319	XA2SEDHKA5	BBD3MN5QW5HLTXZYITSZ8VT5F7UPVCDL7J3QIDMAG2OORZA8HOD1ZP0QRIYO3Q4U16NK4JQFGRTFGFNP6WHG8LWSSM8AO8HZ74WV	3
319	4UMCA9GGS5	ZD888UH6UKM4IRHIYVPK52SKP0IJ3IMS1DGSJIA0OV7CWFFQAQJIGLQ7VXSHM8CM73DFLY9QUY5J4QYKU2IM9DMPXJ7VZ2OPTVE2	1
319	OXSSA6KT74	AEMR3YRPGDE9IWTZZN3RYRC1N11KQ0IL5IUX65FP49RF2WQG403ILLNTCUDC6H9P43EAC624HOWYA681KVPZ7AAT4AUL1DTX9BK8	5
319	RF62QV59AC	PD878A7YZSGWM1K1KS43UGBLRDD49Y9V9I5SR289D5ESOZOMJ5ZSQF7IBXQ57CYATUWD52KRU4ZYBT71Y1VD9QF4LXQ4LCCAGE83	1
319	EXSGMP7BN4	LQRVH8VQIGRZZHFRVACP22ILQGR2YS7UDXMLES1STNCQ8EW56TVD6OLSHFFBQ310J7WB44MCJT6O02MLUW5E63YYM4D8N0BZWLGB	5
319	DN5N8RS3G1	VACHS4MR72P33R48W3QI7YA1OZSSG2PVK48W27N8LHPBXETJH19R02T69L23L4KFN4S8SIFZQR60J8DJFIKP274SKCWREUXR6KY2	6
319	TRFU14BD1F	U19VKBJ53XAHTXDT5MPAAYPVXU54P48KLXURL4S5UWROWKU6U7B7I2V6LN7ZGPQ8Y066CVIB3TPOGB9N98KR3ABTBXF863ZEFTZ5	4
319	HDAKH5P9W5	Y38ZAEYMH0KNTZHF8FXYM5PPKEA4LIXLD9LFL236MG475UMES9HNBGB2OSP5D4B8D8KUNC4GM1MGBSTZ26LLBJJ68S02M72RF537	3
319	FFWE8F8F46	20QEABK44169ZCHTZ74YNV4LB3O84AFYWPAF5HAH9CD033X5V8P89I6G5EDHXL94WHNKCBYS6WZLRDRIGTN6UHZNS4J0D3UXCJEW	5
334	IQ0VP7I4EQ	M3TK7CNSVY2W4AE8DJPS91H17OCBCIH9523Z4VXFM47FRDJ3QZ8AZDQVV1MT9LQNQ30CHOERVKGE4CK3FJUNJHJ2LHECIEFAOTYY	4
334	HLAPWR5SVJ	GVCUROP7M1SRTN00DDJT819JBJREF0KOVQ9XS222458QWVZ0PKKQOFOOW2TI7K1VQE5COCHLLRZD2SXPT1Z5P49QCUBZIU4TDN9S	7
334	3122J53CUB	XLMC9E7PKVDFEYGV6FWEP94BSC0WG9PSFZ6PM2QZCA187UE5Y7HHNNKXRLU6NLJLGUAP11JDZ6COI5D8848I2IE1OJ7AITL01Q2M	5
334	8OI9QT5AJF	ZE7YDRRL6OWHV8TNBS7PIAS3I5GULX1C1OJ0ATZ0XQR4L3WU2N0856LYVDQHL79JWTQHZ2MR2G21SXSPJV1773H4CVF7DSPZRIH1	4
334	8MD6C924TO	O5ABIFYEUF8VB80FBM3MVEEXPOK1CKKP1C4Z06YXS0SPHMBUYUP6OP1J1NW357BJ4S48DBPFXF34WYQCM0CS4NAMKU7NJ52UZIUY	5
334	QBAUG43EX0	DQXEJIJV6XD7TQF5SORRSXTDB62MJFND1UJJONVF10N64PZOWZG3DHAP7UCNQ6M1KAF8G5QF3L01JWJWGO0T8T9UU4M4KIZ4OWW3	3
334	2UYP83OU7H	1H1IBA2QIFKLQGCG220AVOMSW4VW6MXAPLPG8K7THDLZCT3BWXW353YM5IWGPFU6RK5E15HR5H3RCXQCAT9IZ3EWXCL0Y0DCTOH1	6
334	M8LP7EJPJC	YJ1PE8X9HJH1TG5FMGXFJRZTR3ED18XPYPLJI2U5QWP2D8EUI6HITVOGUH7L3TIIW2DE4V7TV2ZWC6PTYT541P5CAEZA5JB6OHGL	8
334	OE7G4D95TQ	90W9XW161EY1OWKYNRG6ADZ66YM02H4ZEYZ3J5D3EGJ9AIQW1IBZAP45AZC9JBETJ8X07QOSNM244Z6XHZ8TGFZZ333U2DTDBZ0C	6
334	44GWYVQ941	ZYL3TMXXABK2O2TCUMEI87EW4ZJ2Z2E93CRAXZX2CC21T1NLAAQMV3W2UY93C47I6K9MKSO5ZMG6FMDCM72YM2O9PZQ9030HEU5I	8
334	WT1KWZC2VX	BBRWVXJX0XHU6RECJ6E596UCOF5V81VR4KL5LB0FFMZCIO3MVF4X1N2EROHQ1XY8B00VFI1HF90XHR3ALTA377ZRSGO64KNSX0AR	7
334	XA2SEDHKA5	HGMOXS1WF79VHEHW4BEAJD944N4VIAQRLMEMYPKP84NJPLXGF52Z6RODHRTKXGOFQSJ4957O1ZCO0ZPTZYPMH1V47BEG6A11PI26	1
334	4UMCA9GGS5	2GK7N7GOAMSC9U80B7Z7O7811S17L9S7SR7RFP33OQ7YWE6P2ANKD9X4ISG5GJDA4UUSWRVWE5S8AKFWVLEKVI3S4CJWI7XEM64B	6
334	OXSSA6KT74	O3LP0GIQY47NTK5E3PV1BYTH8OGHOWEQDCHS244CVBFILIYX2ATQIJS0JERM9ACCZRKRCML9UTGASL5Z0SPNCXH3URIYNSCU8DS4	9
334	RF62QV59AC	HUPYU5YDSI8I1WRVZ9CJQ6VEXVCQWBO2B0S79ZS1T0CIKPV5V8JEQUSK9LA83IRQ3FHBDTW9QK004M3HAH5X1KLQII8YYU8KIVPF	3
334	EXSGMP7BN4	U1CMKXF42PWS37VN3ZS3035U7K5MPRJ7Y8QP2LRWGWP2MG5XM7P56LS16RO913PKGZ34QGURH6XENCI1OI9RCNANQZTL7R4NHEWW	4
334	DN5N8RS3G1	BGGN7YAXON3IWVT37I2ZQO1WIU0BJ7IQWPNC2DEZ9ZBMZDL6LUJ6475WPTEN89ORENWHHRA3DDZ1MP7FJ3ZZXMWYT0WI9119KUHM	5
334	TRFU14BD1F	DY4TP20HEJAW9DEJY3217XQ414LL0Q2HVYFE5GHU5QPRWW9XWZW0PVTQI91UQORXQ2BK8AOSVH5QH9HF4XZA4C2AFY66OXDQ82A4	6
334	HDAKH5P9W5	ZZWLEEHZCJI1WZ2ZR2O9AFJDRD8DPSO9NTF8CY08UKCPXE17L0Q9W4UUPS4AFDJU4JODU4W3CPPZC4QNMB2YBPMS9VSU403QBSVN	7
334	FFWE8F8F46	YMREX7GP4RVCQXDLVSP65E9LC9MW8YUJCWXZLUORGDED7RNCZFP9GR4UNGBXVTRF7L94AOABE7Z195NUWJ72JUDV1DLES06XW8GW	5
348	IQ0VP7I4EQ	TCKEO4I1DUS2RBLVY6MIOC6D5SOACFBY1CDHWX4043YS2MBYVB7B4NCRFHJ5PIY7T4BO8D9BBVNVNOKTR0OBI93N9WCPO9KVE198	3
348	HLAPWR5SVJ	XZSC6AJARD16ZOZ4XYTBYOMAUWCK2QVOMI4A68M9TNSSLSYUV1QCQ6VINRRJ88HBSMURUY7ZMURL64ZC8RZA9S8QXVXPQCBVFQ98	9
348	3122J53CUB	H963105OKLS1PLQIHB9OE39ASIJT6GP40E1R2GH2CBMJEXB1UM8PAU3NA6LTQMSD5YALT8QA4HLDRZ64HR8TIA4GLNQ65XLZSIOQ	6
348	8OI9QT5AJF	ZHW67U2I06L9RM8O955449GRTEG5WUILQHRKLWKPB7URF6OLNKTNTV20BEN3O7WFXATJ5YDMVP27OYMW05SLB524O1IGJRBEKP3E	4
348	8MD6C924TO	EPYHG2D25LM20CTOLE2IZ4EQ6DDNYW94HJWP3D4DYBTP5OTOR09KB6XJLILDY0EJLSUQQEUIKYUXLYUSUZ68WZ3LVMDV10P76KEN	8
348	QBAUG43EX0	C7NF19MLA7WX3T84GWVZI4DA9QUJW0BUHYR1S250Q9VOR78GQDZXSYUH3MFLOCZJ6CQEBHLO15IJJZTCRN3SBNBTDK7FWULNJLRO	5
348	2UYP83OU7H	3EJ2L6XPL7E3D3BJHITB7B1JF1GU597HEVXJU0ZQNE2M3MS0KECD8MT2NAWTZDTM97YSG1ZQSDY2IOQ3IQJ164J2B46TEF0KUQN5	6
348	M8LP7EJPJC	9USOWU5Y0T8U2KJ32PFY6RL5FMNMNI2BUGJ61MKKODKK79L4QQ2AHH0SIXJJHSKS169WBNCPF5K3GA7FBS56Q13NP0XDCAD522TA	9
348	OE7G4D95TQ	Y2DOM5M67MHZEIYWOC9DWHLZ8NE2OBNR6FNZ1SD6RQRNQO82OJO0U7NQROQ90US6802848458CVG07ITOMNFWX7826INCEG68VO0	6
348	44GWYVQ941	A7QOS2RMH0TF6UOHMJL23G8ZR346YHESS8NO71E5PWUGZHFT2ZWLD714906Z8VX9VAX8H9JVFQNHV1AKYKE8V2PUGTPH4P649VUZ	5
348	WT1KWZC2VX	HM2QAGWUUIHZWBXQYO2UC1XTC00TSH9HL0Q8LSUW3AWKIRHOJNKH1EQQZJNKQCCMI9O6UZFG3G1CEMLVTMKE72QHJAICEKG07KBI	1
348	XA2SEDHKA5	L3TIENVMNLM720D27PQTHWUQDBS9BE4KDRHS063P446Y6ELTC7A4VY6ZJDEC4VLIRB3KTVCAWBYMZ5U8Z97DE9ZPVSJW20UJTXH4	3
348	4UMCA9GGS5	BAR59IU9T9NTFN5YHERMOYALPI5QP2CYZXY8PHE0EPCT6DWMYVLT0S6MAFQ0NDU07Y3SY6IA90H8WRPLWT13RT8H0M8K0ONA5LWH	3
348	OXSSA6KT74	DX2NLU9K8ZSZFE4L0JN0V1M77JVMGDL5IBS59QG8972XQUVJTZECIRYLL4PB9WD4OXREV8MKCO0Y9ZRNYL3R8IX0MHTFAF9M37I2	1
348	RF62QV59AC	QYUM49309MWMCMX3V6FA01OPGK7PO4BQZKHWIEEI3AN47372MSIAC2MZKFFTCOLEKFX2EBVQ27G0NTRNMEC5WBN78SMC9UGPYIU2	2
348	EXSGMP7BN4	FYK71IFVVL0X2H7LQSJ104WYSRH00CF9ZHGQ1752ILMGVPGMIEH0KAPLBWPJAO4SG18UAQTSXQTORPDDK5RW4OYY15PFSV13Q394	5
348	DN5N8RS3G1	WM2VZD4RB3VTM8F6IY2CJ2EBNABY08YPIWYTZBFL4H0C3WFWW6IFH2H3H0HZBF0CFFK0KWHHTQHBBBI04PC40TIQP4L93QJZRX7X	4
348	TRFU14BD1F	PMAZAV0UF2FSR4WC6MW74KPKHNDHSUNEUOOCBEZ7R5JCGRLVWWULLZRE60RWSTBVOB7DQUA1XYQ8BND0CRV59C246JFLXCO73YXF	5
348	HDAKH5P9W5	IFCV3XWJSDTW1UB7GVLIDGGOZEVKSENZ8H3MTJGPFVOGWY6RMAXCM6QC8X6ZCL0NZ4YU1ZO6O6CR2A1AHD8SRKNB01N5NRM34AQ2	1
348	FFWE8F8F46	M0XV1YP38J866R8NI6ORW39MST7UIX1T995ML6ZW7I2RO9QANQWEBLOS1LCI15ULSP66VVCLG2TOBR7TC6G2AXRYVNV93R5CXQ98	1
377	IQ0VP7I4EQ	UP2NL7J29RJNTG4Y2K48ILHACRZ6Q0US8QRROOZ0H6V6MWKLBO5GEA4JH1L3HMLI61OCYNKNUE0MZLXQGO5C5ON8WIKWD5S4UM9V	2
377	HLAPWR5SVJ	HWYDRV9JRU5E4W3RJNSNQPQCYKZW52MMCJ91H8O2NYEYORIIZNK9QH11GVPH6NNZHTBVXBJL9091L1YGCQ7SSN54RHVWTH6AKPR5	4
377	3122J53CUB	WVXD8A0I9QO6IEQQ5H3XHDQPX2139R5K30P5JPTNEWS0HZKCQUPHXHISEIQGI6ISVDDSZUHQYQSVVZI7RZNPCXXVR60A8MEINAFD	6
377	8OI9QT5AJF	1M5N8THZX7P9SZSS3P7PSA24GRMLKHUUELZNSCDEQ649LBQXWZTUHXE1TAGRH5OPM45H9FA1M39VG3TFBYZUXAMQG83S5V6UROXQ	2
377	8MD6C924TO	IXQZ2HOYSV0QBPSG31LROAAMS606OE1GD93BI55282YNCB3FOOXWL81HXEG5QRKO4UNCWR885TTWMXJQDVS9QE4EIVNEYAMQRJTS	7
377	QBAUG43EX0	0S6QZ02PE4940258K7ZZI4BD4J5HCECE12MCVT0NCZD1OJ8IQRHL32P6R3WQ5UM925C8P3N1HMWT0KZUKX0V70K9MQU27KRRNE9T	2
377	2UYP83OU7H	A3XEQERF6FHECFI41BBUCV8IU364FGWLGMK3DQRV34QLMY5FJXVC78EP4OUWIXA0S68Z4O1KUP1IFX5681URUUNHI59Y65NG4Z2Q	7
377	M8LP7EJPJC	FK46LRSH5JHSYXQCSG7T0Q9PCOYBVOP4PG2RZVIC4AMV2GIH7DLT479ZKP463RVR4MCR49M675Y0ENW5GQERC6ASGDGJ1LJNO51P	1
377	OE7G4D95TQ	0N71PV9IJV6380MMEO8MUK12CFVVKLIWG2PDG0XKAJ7SJQ3V7AKR2DSPVEYJAN87MKWFLIGN0YLKMJTWMAYJB03DJ9SBBOJXLAF9	8
377	44GWYVQ941	XJY461E1ICMVC79YY6VQT6L0FLLOY9MDU2Z09PE9YLB7FP9QK8WDTSK088YUP0DJ0IBKIIZJ1W1I5OUZM4D0MITBR82A0UT8I2G7	4
377	WT1KWZC2VX	ZIBINL70C5UO9HUWM6RY92KQYSHC3ACHXKXWCR96WLPCIW1M9L55ZIP68VU4E57C3M1YU8U57UCXNIIB15DREHSP40XQ6F21NNJ5	8
377	XA2SEDHKA5	C1A1A8EF1T0MSCI1Q7V4M43KD812LK99NGZECZEINJCH7DNCU97QXASI7ZXCGM4RT19MMEZ03NRC1VNAUZILNTLMXRGMCCBBOVYF	2
377	4UMCA9GGS5	BZPKGXKTPQLMXRRESE9PXY58MY0LPXG7H6S92BG6B3HA4APUU66QZ0QN4R7S68D2KOE19SLR8CN4Q4DMIG0S1ZIRPFEKDXACZP0P	8
377	OXSSA6KT74	XVCVOSWMW69NVJZHUAUGXM3NANKBKEAEXQVVY7NHVF2IF6SNL5EPFJIL1ZUAHUBR65ZEYETWXNUSTVIE470PAV8OIJ39NMABDKMJ	2
377	RF62QV59AC	OZHLR22Y02GQQGK3VRL7L6OKTJKMTOII87QHTES2GZRRXS7GZHS3BM5RK61IRPFMT7STZCKR9S0VO7WBLEWL5PHWB87WMKL0UF8Z	1
377	EXSGMP7BN4	OQX7B4TVKDNK06M23QD05R0FXEYGAAJ97B7Y9O4VYB15UMWN980Z49E7ZSJ6FMUJ4NMZ8Y2PVSC305UKSKHCKUF86A8RE7QLQSBG	9
377	DN5N8RS3G1	6PLFLDL6LG478O4FS9JIO38ZLLXC0NH3OLV5679Q3BU3DUFTVG8T18VDQV39PJG88ASX28JV93OMIFW0GEQTOYCQZRPKD9AU5W4C	1
377	TRFU14BD1F	R0X7MT8TI5L9D3L2WTJ8C8KT8SA24RVKTYYN3WCFE6QWELAFZ2IDUE9SPE94SFZ1KAPOF89ARE4FSYPWR4DCJR0PZF7ZXHW8HZMD	9
377	HDAKH5P9W5	WA12IWQJ4A1ZMNYCXS2KAY9AKMJR572ML053MJA5JF5EGAK486UHT267B0S5M8O6IONWR40OR6A4344JCPS9NV2S382V0FSL1861	6
377	FFWE8F8F46	XMDFG0W2BDH5I26QOSWV42TCEXLNZD47DXOCO3H5F024V0RMV4MQKF243BBSOJC7JJ1VO4BUL0PEAYRNF8140OW74TJN2YQ6Y4VL	9
387	IQ0VP7I4EQ	58131ET0X4EUXMPRHG4W404VX2XKSQFDFPJ9AA9KDGHYE2FLBPQY0YDFEGF9RJHHZBOHDPRGHUTXTFQ4WLJD9QMRLE534933999D	4
387	HLAPWR5SVJ	7IV8JQGFQV9ZLNFAEIIY768UXLH1ZYUGNQYDXE0AGL5T6DTWX3510OQBKAK7IPP1A3M4YCM9RISVBOYT1VD633P89X3X32105DTC	7
387	3122J53CUB	Z7VQ5JR6595M1FXMT8GNN4BJZFYR1Z85V2CXRP7U8BEX7KCXDOMEMZN46M1ZUAFFBA18DA4DAWOM0NLOCBNMN3S5PH0FYH9869V6	5
387	8OI9QT5AJF	EUDUIDZLBESAMWSW31IR5T5JZP3WQQ02P48RK1EZ3UODHELURMCHNOYUY352KC4UN0URYALBXSYLF2CUEIFENTOBGN2Q6LP0Z3ZQ	5
387	8MD6C924TO	36QABU50NP61KYB70H4MTLKI5ELC7VMCVBKMYDL8TL386ZVWN38V4E9SWIF6J221D3GJOZIX563IRMLFSYYEW0IQB2ZQ8OZ0SC4C	5
387	QBAUG43EX0	MIYULZ8L1AJ69OUEXEMVZIV92ZQGCZPRJXGPAULBJFK1QT8AFW57SQ3EXY1WJ1IBV2WMIEDD3LLT83TJ0QBQ4R934C2M3Y2R7IGX	9
387	2UYP83OU7H	W2AS1EGEJG3ER6201GD33SGM1JET3WZX5MDXB8CN2YU59HL291FCD4DEWX1SAXKWQGJF2FZ3D0BE7KNU8LUCRXTBJ9BNHUMEO7P2	9
387	M8LP7EJPJC	GA3CL8M38GMKGTZDIF3WI52EMWTN6095UW2K0AFYGHL2ZCABXBG2VG0KHZZYP97HGR0U1OMH9FPAUAOJWS04UHJO6RCAKRJHKEVH	4
387	OE7G4D95TQ	PJIZ82Q0Z0HKQC7IDW8HLYJML6S5I0POH7HIREWP3XG1404OM8GRXAA096NBJUS8K3DT5Y08ATOXSSRVCDTJT81G6QIV1UGIFHQA	6
387	44GWYVQ941	KTXIIRDWMIRO28FBJPMC7WOPEHPMFSKBQ91T5AKQXTUH1H8VAH62E8ZYEHDBC0Q48P73GVFIE5PNCHY7I3M8VS7SJDPX7JO6CZJM	3
387	WT1KWZC2VX	FOOBYXITLV7TG2IOSIPRPTDGRK4RTKM7MXDP8774Z98SRE1QFRUR345VLHTN20ABIAHSZ3QVKV2PVUZNTOMBZ5DR2RD0OUB896JR	9
387	XA2SEDHKA5	I1LB9GIBPA1SF3OO9LN6Z0H0ZG0T3QYLIPKXA90Y4QMRMII0XU9V5UIRTVM2PYH8MQJZT1N9UZBJN0NR8A6JQCPXH3DOW8IGIOE6	9
387	4UMCA9GGS5	SH5H9BGS8D2H53P28RJAVS0X8NWQ5B9VRSQ3BCRBIFJZLH1E3NJ755MAQIIWO0X7EG0MNV06AI2QIAM1VRXR1C0WFPM234WSSLVE	5
387	OXSSA6KT74	O0HXM6WD61Q5QB6DFFCPDG7J8CGVJ87PHKG1P4OFESJY66M20PMFSYMH37YJ0B373AXG5FXK16LV7JNB0N44V16T787RFEOCZM45	3
387	RF62QV59AC	G7U1BOWM1KTUXTNG9LCDEI6HFEWRJ5UOR2TPKCTNKGGXN7SVB5ZA22E8AMW72ED6ZFD597671Y37CI3IWBQNFUWZXVO7PWVGDJ8I	8
387	EXSGMP7BN4	WVE92JD8G62SOK0XZ0FSNHOS9REDX42KVN9PMONKS0RZWOBM4SNT2ZQPHV9LFALMDR7AKKLLN5AW0Y5UP1JFQIS57UI0OBFSPEVF	5
387	DN5N8RS3G1	BBTGCG7Z3YS0P6N1G558CD0CV6L0SHVCZEO0Z8OCVFD5099F21II0GN8LRVG4HHVDPALRXBIR2N794LV6G709MLS0POHNHHO8R2K	9
387	TRFU14BD1F	YXEZA183Q8QF9JYJQW0ERUCI34JV99SCBWIT2B8VNZKR8CN8TFR4BGRDV65FRM4RQNDNBEQPXE02KUK1RLB4RXA5EE76F3DA53AU	9
387	HDAKH5P9W5	A6OYCH7PY3AWEYGL993MII6HTJ4BZ7RU03ROWFPQDPQK7KBE7Z54HH01AHF3M601MQ5LH1Y4TNJ22WJJH0D9BWNSDZOPAWDHZY7R	4
387	FFWE8F8F46	07GAAK4879N75VV20ZZDNHSNJ47JBCEY24R378BMSUF0AREARP98INBSO21GMU655ZEBE251YMU2C1M1061WDFQP38OEH4A8YK5L	4
403	IQ0VP7I4EQ	D6ZTIJ53IQXQAQP3K1ZIZHFO0U3MWE26AOXACC55UVUS1XGOUENSFCX50K3XPSHEX0QW3P1H63XDWXXCNP2R0J1701K1JHQCOQ4A	2
403	HLAPWR5SVJ	UVFNGVLOUICX0KAZ0NO8S6BE98ZNVZG2W524XDUYPTFTHDS6PNXDQBZYTANH5834CJB5RGBW2ZT90S76Q38IBCMUGEKX0M2RZLQ7	1
403	3122J53CUB	XOJLBK0SZ7BCR1CAV297QYN5O5Q7BJOB932PY6A2VBQGJUJV0RETRAV8AO6F43QPT9DX8XLY2GLPIGV3W4GUF5U9I4OK9482UBXK	5
403	8OI9QT5AJF	VWDFP0KYG042DT9W6JXPDOEJBZ8IT4GSLMAHDO0EJLCDTS6K9FY1A5NHS4E02CELTLQ0S1SSTSF2MAZS2XINGPSQ83ZJJAMGG1UI	1
403	8MD6C924TO	G2HWFHRZV5REV7F30ED291YBJITG8VUQQQW5B1AIB1N8IEXCHMPWQPCODFN6YL09KBYFLJ29D51IO03EVQ9VG89AOI15NET0ANYG	5
403	QBAUG43EX0	S17UPSVY49MMJLHLF3LBX0CS7V9MBIBCWXCZBB0POMUIOTE2LO5TMF31YPX4SJWV8KZWJSJDD5XKG4DORHAXNRZR3KBWO66F08KD	8
403	2UYP83OU7H	RS3E1QQSTU4LJMLI9IQVI28RWZH9RUIT9U9YHSVAJ9JZHLETV60Z3SUYULRBJRA9MKMYMWARXQLJTIKLUXNU4T0QAKE5BU118KN6	9
403	M8LP7EJPJC	QG85JCNGLFLBFRWDPF2T5YBSFQDYUKI4NMEQPYURMJYF245DEYSFUND2FQ039YWA7QX3MFY0ULHV96ZKUAU61CKAILL871RYXYHL	2
403	OE7G4D95TQ	B0891VIFS2I1QI9E0I4GXVB4Z324S8LYNDTJV69RB40SCHRTST6PNETQYEJ82OWTRTNMYZT3INF35S1SLIL9B5LIUCVQWBYWHGAT	8
403	44GWYVQ941	E43ACGA90VGM1XUDXSWHE2WECHHYTVYRIYGNR99YLJ4ROE5OESTYOMYMIZ759LPE6YECQGVYS7557EZ8L3TABAC5A3F2BDZA30VZ	9
403	WT1KWZC2VX	37875FRQ3PE99TF1PC5VIBWA3XPH5BHT99R5VDG5VPHOA2CTUIOXZE01L7DI0KU1IUA9BJGL6AA34H9AU5WWWT45I0UY98FK4PGQ	8
403	XA2SEDHKA5	CRKCC1YD76D7DX4X7EY0E1LYSM75Z8PBTISNMUU2F2L3R06KKX6KS0XKGVU033N8RCO4FRLNU5UMQSH1QXVCBFS3VHH0939LOMLO	4
403	4UMCA9GGS5	BF2MTZXFK4XN2JGIL7MTUJ7KUN05I7DG3PPR2ZSP5YKMTMGU3DDP9411IS1G816M0QUN4YQVO6Y69U0IGGCF4YH8XXIJ8MRD17WC	7
403	OXSSA6KT74	3ZEXSADF52X1T91Z0SCJVZHPGXCPVEC8YQNR7SMYE224VRPMZNBOT2FDSYR57YU00ZDCWK2IGOF37M4YI0ZIDXO5KJ8IBR0QIBE6	4
403	RF62QV59AC	M0OV2IFXMGF32XH8MXCKI1NLTHYXZU5H8K5AKXKOJI8C3PI4TR6NBVFUMDBVUR71K75S1HYZNYBA3KSE84EHYRGNELXHVY41KG15	5
403	EXSGMP7BN4	0CM3HANTE0CU7WZNZC31RNQTQDY3K0XSXUI12ORR239UUXYCEOUD8DCMW2MDMTJODU6NO8ULVM8XN593PWY6FUTTR5EABOEIUVRA	7
403	DN5N8RS3G1	KYG3JSWEO802TX05NJTAM5S3UJGH0D2O9CE7RC5B7PD7NHS0ONHL89NPGNJALPOKGM3QT2NKNRD71UPM1Q2M6RQ9YY1E250RA21B	4
403	TRFU14BD1F	BHWA68Q6QYV77I5WCOZ6314AISR1V783O70JGM9T9DIAGG4X558OBFUJMV1OQZKSZ1TASVQZPG70T33BX4509U1JMR6UVVCJ20LP	6
403	HDAKH5P9W5	4FJOI95H40T2Z0V3UTF9KXAY5E3DX72SOO2ZWL0V6BS1N254RPIGFQNHEUTEF2U67ANL76HI3UDJEJLDI9WIZWN7BVVB2WPDRW3N	4
403	FFWE8F8F46	U6UHANUNDC4JP5GGLHLXQJMLGPGE92SP7YYCBAYI2U7T01M1J6FOSZ8KUJBUGQNLTOL1GEFLSC55M3UOCP5DWD6IZNR28DBMHV9L	5
425	IQ0VP7I4EQ	VUE136Q4D81YXS1UKYPRDB2WMMOBTY13J8Q50L3HQNWP0DKVK166T3MU1SOQSPLOG7PZB5385IBZON6JC20114KPV6DI6MZBCII2	7
425	HLAPWR5SVJ	UUO87AK2WFOVFOZYTWMX9EE1UCST9XGEEURIM2339X81ZX18ANSV6EZQPWO5S1298KRV7QM13SYMFNC7KUTWEVH94A3ZO8LH482P	2
425	3122J53CUB	FBTA11OQNKCURU7IG5NCS06WWM5GRSGUX1FT9VM33TRZ0F7NO9XDPMXPE6OO6H84DR6ZPNIUSTJ8IG6RPR2R4DFKDZPCH76VUXVJ	3
425	8OI9QT5AJF	H7B0DU5CZG8A79PORAAMWW08GNUWXOVUWIIT111SJIOSRBK8RHDWV6WUHCUZ9IOKVNOY05XZIRCNIHREDWFQK89ZVXMYGBTA3D6D	6
425	8MD6C924TO	VHWTNND4IM9VPWND8AWOYCDS8TG8BUEKNRRPT67U55NLMC0PF74DJZ9SEDU4GF2XHYI8F8UBCCT2Z1F6212E0BAXR8KPLDNZDZDX	8
425	QBAUG43EX0	1KHM3AHGG3M7YBPMX7FYUQGXEZ9Y3ZAXRCARV16A3RLF8SXB8NP189JLDUIDBSNR3YPWB715BE4DFBYWC70PJIZS3ZNBT39KE4LK	1
425	2UYP83OU7H	BAAWT03EFFC5VBD27HU872LT0LHFU8LZOUA7Z3ZR6NXTLF816RHW1LEIYQ5ISYUH4MQBBGCDRDBUF2IUNQIC1Y8DP2IJ8R9I2QZ8	7
425	M8LP7EJPJC	600PDEXJUD6HL4CPSPFOMVJ73FAD31ZCK4Q0SXYUK44ZLBWX73KBUTMLR2W8ETQ2N47RNL641UES1TV2TNGAQYS0RFJZBZQ0OBLR	1
425	OE7G4D95TQ	FJV6PK9P4T7H3P0NPMZLH9ICH3BENEZIEYNDVDBOSKXVLSHKZN8ZVF5FBSYVI4BZ4YDFBW1MKL26MW0ZW0OAG9W82ICCOPFYJ70X	4
425	44GWYVQ941	BJCVWPKM82P298SPBT5BEM3UY75GEXO5DJVRMOUUMV3PXKPQWIHO5VKZQS7ZTEHKOTYZNBDW8LZSSN7ORPT6PA9S95B3R5AINTBD	6
425	WT1KWZC2VX	ZCVEVPU61GCVTHEVL5NUG0S9JEDKRE9M312M724UPWHY8I8Y6XCXXTP9UV4QMJOWH011O1XSA3EUS3BBGPO4BLZKM32L7NHGHVRI	5
425	XA2SEDHKA5	HJE9UX3O5Q1U3K74UU5BROV9LUXV7M6L3T8FK4RY55QMB1ECKMXAVHA2YFY9AHRSTP1JL1UZDHFV8I8UQUKVZ6ZWTGRFGRXXO82V	1
425	4UMCA9GGS5	41T177NBO4QGETQ652XZF0FKPTVTSHAPMTV21328LUEMA8C8H0SFF54EVIMOM3TG4A3U8XFCAZOUV3JQQXM1Z4KRYRHTQNWRB8RA	2
425	OXSSA6KT74	SAUVQFPRKT2957ZR1R90M5QPVVWC6SXLJM8X1GIZ4AO7PTVQ7AKQSJ2WTE95SNV15Q0T9C0VIK5MRSAC9GF5IG39ULDWGNGROWC8	8
425	RF62QV59AC	BQ5JZHINQFAE75MHZTZX09X8DO5DO74QBI8ZKWT9VVEGDSJS4KZCMLCC26GKME9TKTCZ7W6DAZBF4R5UFMIEH1D0F56NPIWQVV5T	5
425	EXSGMP7BN4	TVINWCXK7HKBVE964LTPMTBZSX1CUTJWLEV1A1VZQQIXVL4EWU1JLDDATS48LUZN8Y0QSI5D0496LODG3XPA2AKHBVHS6WN604Z7	6
425	DN5N8RS3G1	NVOZXTREHZFOXFYEYV7NSP7BNHDQCFQYFVPCBKEQ2C36BDJRZ1CJ1UC8XNMQQBBCIRICZWCNQRUQVB9J8V0LDG6VSQOY8Y91A0XU	8
425	TRFU14BD1F	G1DYY3K9WMVOCS5K09BUXTIHOP1R3P4OOP13XWONWW6E2J6GEQJ1V9HXS5JJC2FGRH9W1BXEUY8AWEPESVMMFD2OIDK1MFL3Q0WU	3
425	HDAKH5P9W5	KPD3FH6BGAOQF0QQ3AOPUNX061ONFT6S44IGJTA65NBD6KHP4NXZIF061M6N2T6XD5WKSKGJASTGMT4VU9T15HKYEMO6XWDMRO9A	6
425	FFWE8F8F46	66UGOZZVTUISK33AE16V7GG6JWNOHZ7T38XC8URRUDU1FOM3KMMXDO0Z0Y62LLO4WYZMF0BTJPB4WO05KUE5MJQOI7MKYZFIY0FR	7
446	IQ0VP7I4EQ	9XUK3NYN5DL7BS1GTRNILEIN05UJ2G5JIGK7TUT52BM3BMWGOCEI1JN5OGU72OUYICZ4H3W98RPK1OMNJO40BXR92OSNAVCNQYV8	6
446	HLAPWR5SVJ	18VPFJK3DEA4GYOU3XVUZC3KJ8NOB3D3N0RPJL6NHFYKSS46X3XAAO7ZFKFG651KAHRQH9KR0INUNS21EQ0IFC2922J9GZQLNOJK	1
446	3122J53CUB	OZYSFK1ANLXRNBQETE8OSXOZLLB1BG9IS000CZA2B8OQWR2Y9H4JL6S0K8H4JA9HLO9XK0C3EGNTI7D3SM24L07VHAPDSFTB9HFH	5
446	8OI9QT5AJF	FNJEBEET8RN5NL6HE5VRNPKK8K8XMUB26KN9SZKW2CJSCIF4W34LTZF0C9G0FRGNQU9C76ZOV9ZKF2I0FEAT0ZIGFX6TTTQL55BS	3
446	8MD6C924TO	C60DP0U94UK0PVBQXX1L27K9G5CSOOK00RCHKPK9XGKDW2D7P4IHKGQEW07UXCVQJUA8S3GIN1XVXGNO1EDUGCPTA8VUSZLVV43B	7
446	QBAUG43EX0	FPVY94TS4RPMS3T8BJGER7UIWZXPCA3NLXWZS5GI6AGQGH961WTUX7JH4MBJGDQ3XCA5H4QFC7IQ1ECO01XPQJZONO4F46C2TM2D	2
446	2UYP83OU7H	DZ7GORZZ2P0KXTPPAMOMWS29KLG5P6PL8IWC0JC1AZU9E5GNWNT9N1TV675CL3J5AOLO6NZ1KXL7834PE2ICNQ7GYBF2O9QGPY90	5
446	M8LP7EJPJC	1QJY1Y0PWXDCQ8SUHRTRE05H6NKGFRJ4E5MM8OW1G1COC07B8VIGPIOBUC1ONUKENI7UVFW251KNYRFFPJHTJCP5QK16WINWR7A3	8
446	OE7G4D95TQ	NP39PKX8BND7V8DM04K3BDLNZGXNX60QLNB4OU4217P7Y9AJKK0DZA0JEPKIXJLEXWVI6J7GASBEXNYZGODMGX1KX209JVESVKKC	4
446	44GWYVQ941	1MAMTCG8VV00UCJF88A5KVES86POTTMDWMOBCAWUULBGAIZS5MWMJGCGHSOXX2PCIWDIYIC8MPK8T8S0G6TH6A3PJH3UW961697N	2
446	WT1KWZC2VX	R4XJY936EWJAYQ1JIFI3X8QOSMNTTCUBFVZB67HB9TFUUU8SFSY3YTQSOI1MWKNBCH4C1ZNK7G3E3547O4NAN0MVEGXXF5PZGDSM	7
446	XA2SEDHKA5	51PEN5S0MYSO3817MYL5J7UC0FC1E70MRISD7695442REJL7X14OHQP7GNOI30WO7F6VPY9PYQBPFD8Q3FDMDMFB2U6TR0CDINT8	4
446	4UMCA9GGS5	0R91OZ1PA2DP7PXWJLVA5241Q78N7H1T9EDXEUZWOV223EULOR8C78R7XILQ1NS2ATQ3L9SZW9VKAB8LNW9QJZVAWGA6JI5BC92K	7
446	OXSSA6KT74	19O8IQ8NH6VKADEOCTK7PGF9WPNDTHAJXXWXURAJXXPJPVIF0X9PRMJU3PM2C5395MWMRR3VTAK106TAGIN6IV1KOB3EFHH14QND	9
446	RF62QV59AC	6YJ3O6RCR466LV3R71KUL8PXYQM3S7KTQAKUEC3YKI6H6I3VNK7ZCSY7IVE8UXUUUNPKLJN47VKCCI1QW0PIAUR7MNLT75EWYMXT	8
446	EXSGMP7BN4	SKE6C1QIV5A4YL3HMT96S87746CRXOZVHXDQLL73AZ0SLYJTLPM2XXKUMGCFZ9VHFOWAHM5BVG53IOWFXSFIC67UMTDFI2DADTM6	1
446	DN5N8RS3G1	IL8TLHR1RL7U7RG4MFIRCYXJ023C5ZYBZCPGHY1ZQ35HFULK7G0OEPAUYZ2SNO62X644C9WYNTBJ2PDFRTFY8K7KC5SS5IMB7DUJ	7
446	TRFU14BD1F	QH7TCAUN11IVXA3JH3M8U1HRE2FGALZ54QBMIE5KN7LEK6IHS1ZJILFYAPOJ4NNPBN1G9RBC8BVXQDGIU7YIWQWSKML2ZWP9T6C7	2
446	HDAKH5P9W5	BHB0XKG0SI7IGZ7ZE3V0I6XGIMMWVDUAJDSZXS9FP22DOTT6SJPDRG6FT5RK8UEPY69DGHCV3PKQEU1Y3PDMXQTCHNG2AYG5YNPR	6
446	FFWE8F8F46	Q0LH4JB6PA9D3RTQ21HM662BKVFIP21FKEMZ2E3HSG1MGYHHXO6VHEYU7K6JE2QXJ43ZE3YX894ZFP4VN7UB5F7FP21SIUDZ0DDL	8
475	IQ0VP7I4EQ	SC3ZJXHK9ORPL5GHP1D7XJLCGPN6E8BMTZ550LWSZ5QOKD6Y7RLL9OII11T3JLFAMF5VAKQDFVH2271DSZ8XX0MFRWD922IO0QBE	2
475	HLAPWR5SVJ	LYWAIGNGQP39QLUMSMW20DNHRKMN2CM6X5GAMWPU88BGJ9MRYCIDOMRHLPT73AOND7MUET957B31CG7S85YZ3IRKO9Z6DR07UXDM	6
475	3122J53CUB	2MEDMGNSZFESA98MYU4PCFF4C2PL5HODU6GSUWRCE2Z4UOCS1V5DI6TWGJAT1BWR0B7E3Q1CC2LKPLJY06TKML4YMTMKW7LCFIDT	5
475	8OI9QT5AJF	8ZL32AQUJG4AL34SMEOGI1JDRPERIEHHZH1HHQUKODCMRKKEQU2EYNIGPHMM68ME9XKECXK6UE2FZ7WGFAAYMDSM8V1ADHOP17M4	1
475	8MD6C924TO	GB3J6TUVDRSVFH57X26E7FR5K2N0MN1U1G98HOPT815DJO79SRDFQ0CAU79DG4IZZ749I60JMMFGKNW65NH4KVEAE8NJOMNESFNM	5
475	QBAUG43EX0	80W132DV60HLDI2XOPE334KSQ4A9BXE9JM6WUDQ3APIIG7LDUQE0JS0DQDK92ETJVIB1LFCL9K2NWBMTT6PUSOZ1V2GR2RA659W8	8
475	2UYP83OU7H	T2OO3080NRP01P5Z90GSKGS9VSSK5RXOOX9EAFYX0AIL00BBEH6IQPVNJO3KIY453AMDQ1Y3BT1K7HI4RQFYVP88CV4VMOOCFMR0	4
475	M8LP7EJPJC	7UNSCG7YKPBF831TGKOBOB47DRXEZEVZSRT62FSIBJ1F2PNUXS9BDY96ZPPUT29G4MXRJ51A2GAEJZEXDDRGFUW3RXGMZ7YIKVLQ	7
475	OE7G4D95TQ	6K108J6Y5WAL1QQL2BJZ49WZPL4R13YOX5H2ZQGL0EWBFA8RI7SUB076YBKXPO7B8WX5IXVL489ZNUUPNMJ4LDM67LDYFT6LHUCT	4
475	44GWYVQ941	CIULG0D1ISDR5KCFD04K087U7GKCYR3RBCKEYSENJFZ39HJJ3FE3IIVDKAO9PAC1ZVQ397QUWRAVJEUZ6BISN9J2QG3YEE8IC7EN	7
475	WT1KWZC2VX	QJ6YUH0IA4GQYDN2UNZMYM2D2PRS2SLAG8Q2M332SUQMXIQBVQSUOBCER26F0IPSTGJZWVP0U73E5QQT8Q7L90VE6LKU6YCKE82Q	9
475	XA2SEDHKA5	1O9A19RI8IBLNGKKDS3VE3LK5365S97YAUHB8KI1E67CJITR2AAQ9538DYF8CWZ8LNL29IM2KBRI5IBXKPDS9RYE1I7JFJYRG806	9
475	4UMCA9GGS5	1STYHF7OVC4XSYXTH94YGB0KCXAN9B7RFZS6T31L10FGDVXVB8986I001IVUFUPTFNS2F09OHT6Q5UHRAOMAC8V792FKHHFHKWAZ	1
475	OXSSA6KT74	4QK9U1NLK4HBET1IOQH2V3NVYG9NZFJTROF8BBRGIVZ77JDYO85F37RBDYKO19VEVXT0O3GN9AU9EPXOCL91JE0U6E4M0DPI9UMK	7
475	RF62QV59AC	NJV1SF3NR7YB6LP944Q793J83X6ULATCNXZBO9187GOHGL41AIFZ6M1TAW85JICRNWYIVNV5DSA2PC1S2EUC53GA6GB2A6YYD63U	6
475	EXSGMP7BN4	WFWXJWNM8D74PCFX9WUPXMPL34G3LYSJH4G87OVH2Y7CE7U4SADKJEAJ0L4OPTAKVXXV5G0VAMX8OMG5JMLLUIAC46IWUH1IYXRQ	3
475	DN5N8RS3G1	98MKSJ6QB5OE8ECIZZNXU188EA3VPK14ZVKN8AB8EW2B3RWCZ987D30IANFSPKB0DTON3YJYXOS886FWO06PL3065CNV5TS3UC8K	1
475	TRFU14BD1F	IIAZKKZL2KDITDZOWOJ2SR1KY3D5ZN585TFR5ZBTBUD1KNLP3O8XZRU1QZBRH3VOOFN98HS6N007OAALRYCKPIIN8OAGYUMI9YNF	1
475	HDAKH5P9W5	MRV6BK90XMQY09S0L8G69ATGMI2OS80W5LFGQOO7JXLCTR8U3RXZGIAL7OT3RUIYW33O4LJ6UIWMZRW4JIUAKAQWK4JB4UQYPWQ0	7
475	FFWE8F8F46	T0RH1F8WYVP1ZTJAHOVNHEACHCA177CB6F0RD2T5R9VI4KEBHYHI4MRO0PAYEGZ1SN5T216O406HS1H779UIZ4GUYL1Y240KK4ZQ	4
490	IQ0VP7I4EQ	VIQ22NDQK58HC1FWQCYHK5Q9HWAAV6YC1SM0DQ6RCEOQ3Q0DUY42BJEZ1RUGND5NH6QTOOSAFGEGQAF066P6C6AROW9W50D9IAI7	1
490	HLAPWR5SVJ	GZFF3W4F7J0L3KRX8LK58F1P6EOCE7P2I0ZGK1IJGMRNJLCQWLKZ8CBB70JZI1A938CDUKNHCAZWXOFUC8P3X03GYYJTSTBOLRUL	3
490	3122J53CUB	86M8DW7MPNTUYWKLHMCE6P5A3ZT9KKG44MDBD4UD63IKZ9361CDFRGMTALEND7BEHZ0LSIIM19HDGVK45WIIHBNXAUB10GA81DDA	3
490	8OI9QT5AJF	RNS30NS9JNPBKSQZ37FLDL8GRWU8JLCRJVNIZOQX5Y1GW0QYUJ7G7ZFGPMME2TZ7K71YEH9PRSQOU1T1G6N9N6TUQH3NCL4L835Y	9
490	8MD6C924TO	2TNKSYPI0VX2U76G0TOOGH7NWNFXFQ0552OMAZ4HDMZVFURO8EHJRJ2UW9XFT1CK5272TTGBZHK3SLIB51ZAIQOV930ABZYLJO0N	6
490	QBAUG43EX0	Y5P8GUJ98CL1WJ1CBCONL2Z3F9AS8TDU4OH6KCC5EWB1OJPP6JIML9M6FV3GU0AO806HC529ASJZ17O6UUWZL0I4CK0YJ5LNWW2X	4
490	2UYP83OU7H	HMBQIM20WEIH7WAEKDIRCF2EE0EH5DFE0TMIVJDNPEPFSQMJLJLTUFKBU6LSIV5T9DQNJ1TB94B70WWXO56W1WUUIKXZ7VF4J6GO	1
490	M8LP7EJPJC	89TZKTZEML8JYEMYI1NS5E8E4EOZHY4QHXP5N6RD5Q69ZPJR2GAE26E3BP5FEA6XRSBAYRKLJKXOI9OO576AYZXLTV48BM84TISH	4
490	OE7G4D95TQ	I2L5Y4SIZVCARKHD6914ZRCWMK7M259QHAWEVF95ED3A27UB01XJ0MY10YSN6GP4VV3QXDS0960WXC4O05VBH004M4O6WW87Y9OH	2
490	44GWYVQ941	DOXI7K4WBEX4DXBUNW549E2YWDN827XXXKXR83KP5HK00CS87MKMSME8V8W3764EQ9G39TWUMP914C8UUOAPXLELGY69GQS9NGJ0	8
490	WT1KWZC2VX	Z8O009DMNESACIS5ORE55XLWXN56AOY2HY5PWZ6LB82UO9EI9D8YE59CX1DNDGM8P03NNDIZU33740IYIX66P9XLZ214VTH4V4EX	2
490	XA2SEDHKA5	1564IELCBI6TPEQJQTPCRXVLNDBV8MAWUSR1ABH5LJXT5LGO1VFKYUYDKUQEC0DZIK97WZIOLU1H9BQC7W4NGZ793ORQUC2UG8KU	4
490	4UMCA9GGS5	J2CM08E3RDIEOHP60STN9DIH23J1GBB150X42BP02FMKJMG5NYQP0HMGU4T7ZMXPCRIXUVEYD3U3178QWOORVVAXNRK7RSAQS6I2	1
490	OXSSA6KT74	SL1T1M7XTOW6DKL7F4QQUKCKHHU2EL5YFMEDW74JCA4CXBOHZSMB2LSIIQMT1ESIT700GILHAGOUQ9XF3NDW8364364GUKS7RWTZ	3
490	RF62QV59AC	XBQHEBV781I3G0OB6JZB56KNEWZYQC4P85FMWP31L75EVMNUE6VM4YO00DCRM7R5725LUBORQ8Z8BG22IFUTRRVJQOVTMLPOQ9G2	5
490	EXSGMP7BN4	C9CRD668QZUKKIHM7OQHV5FP5EETLSBA9KGFRCNVZLAZBICCHBSV0V6G3WW82MW7XUL9CB55A5RJ5QNWCBLK9QKON9L4PO2MZCBR	9
490	DN5N8RS3G1	CAFGXU4DXLMI960BM8HJ7WC0APVCEU2O6Z9BFEL5PK0Y8WPRCLMD4HAQ8PFH828CS8MK7Z5IWL4W5O1O9D93HZUYYSD08E7WLYFA	3
490	TRFU14BD1F	FUNPERTNNVTY1I42F43NYVOWFJSNILHI0E4TWODHALL7TBG5C3F3LXVTF1J49FFBNL8WNLG11WMNKRCEDWLOFO7DTLO4EII5GKTI	1
490	HDAKH5P9W5	TS1XOBZKIJXYF1M4059N5DC7LWTNRGA84BTET10MH2LC0G9R5BPOT4HQQ4L2SL2BJZ3DHIK9EWGC29GFWBRQ1VOA3DXZQ845AJ3A	4
490	FFWE8F8F46	5JX0PJ6YFYQXGFQ4MJXL2KDVUTG2KCSGG1124ZLMRMXPGBJ3OBXAFZUVGCG6DENDFKROOY9X7L3QWYOSJNNIOSAQHGV2TPIN8UJ6	6
499	IQ0VP7I4EQ	5O0B9C46D8RYXWZ1FYXJAHICHESCPRCPR8O8WGOPGUDHEE62TW35VXTYGY45T2QV6CGYI1E8JHDQDA7DHZT3YH33O017MS6NERLC	9
499	HLAPWR5SVJ	HU1R5VNTDUG11Y3JW7YIMKS9GV0LZMVZ5FAF1M3VPKKFVGV4CERUW3U7C2KJ4C319R5VXXSKDD2C9MO9A6IV4ACCVCD8BU1NQTFE	3
499	3122J53CUB	9HOWGQTAR8ZNKI83I68O39VUTITLOWPGKYAY39XUTBDEOU0L2UHWHZS9V4C87HV5TSDWHJ9JIO416RF8SIS4O29UGBC96ZWMPIU6	5
499	8OI9QT5AJF	EDTU8O350DEYEPYY1R0STPGGAMS1SMX6JRNE9JPOGZP77K1J7XY14N7Y7MUW5BMOQIOXCUYRBMM49JIZUJ34X6B6TYHWY3TEMBRZ	9
499	8MD6C924TO	EHN8GZSADYYD5BVIS0THSENNC2I2HS81T3QBQ5QGT5PASS31764L7SOA396NRZ3V06UCVU2WJMXWYN4T9Q5LXX3BPQHQ9CZ4C4JW	9
499	QBAUG43EX0	1GNEHBU41LQFNOA3R7DCTWFMMXGX3T4DIUIKSGPVJGXE1KVYZAU6GTPEBA2U47AIRM73F0KLRR3M8AUBBS83877YEDIRO51LFPXO	4
499	2UYP83OU7H	2S8ZJPY0DFAQ0SM8HJTPIYCR36WZRGTNGXJ99DZSI8B7IBXMPM7GD8FDQR6N29I6WWJDJN9EUBHJWEI1IJKEINKHSGSRHMZJ0ELV	8
499	M8LP7EJPJC	UDCN3WC15QMIEESYDYIMBUC4R7HL7TS2X9YGI1P1IQWZFICIGUWQDI09AH56O03M8UVFPMQLJREV8NYI49EN6CZOJZFA5SNRWK0V	6
499	OE7G4D95TQ	724DKGVEEBWSWBOVQP64H50GQQ0EW9XWDV7HKJW5DKEXSSJQ85G541QBCXX4QRRFNAPBEHLH2A070CX8GKF1311MF5EXV1PW29KS	1
499	44GWYVQ941	HL1U8C3ASL99ZXGL0MVID5JCYVAVEE12F598OH4Z8LWUFX6EIKCXYK9LCY5NBH5OTH43YH6TS6K1JZ7BZ6M3BDE46X60LQX0QHA7	8
499	WT1KWZC2VX	CPBOTF1AICM04YF4BMQDA7ALGHBJTKBZ9IWQLPR8M3XVT9Q2S5O4U42EPZHLDRQ7AX0WBYTV4R0GKP2G1J1Y6GEFQSBWIG54N0V5	3
499	XA2SEDHKA5	303M29DEV4A7AU302A3SVGTW6NYV53T3687T7LDGBB4YBZHWBEUZ1MXXHHPPLRI2KGACWK2Q7XQUM4VHGCT0I3CTLKM06Y5U2BN4	7
499	4UMCA9GGS5	F91LD2E5CLMWIJI7RTRDQ1M8CUI161KR0RAD2OEA8XI8AEXPXXKR51IOX3JTTM9LA450IFFDOQF2SN8873EJR2W9JWP8FVRVY77F	3
499	OXSSA6KT74	6HRSHDPVP5J5KW0I03II6RVZG739TEVP20AWW1JZGN31GD580N7DZ7LPV2LKJPCLK3DUVEV9USBTX4TDB4IGGS05OVB4P9P1KSQM	1
499	RF62QV59AC	LNW18TG5210JIIPG5E1DHFAD1TVDKIFNGC0RWOH9U9V4KVG0AUONZJ2FMT9P7DVTVMCFR8UR62SITG2GM4DZ32Y7KVEDP2BQOCI8	5
499	EXSGMP7BN4	BJCA7Q60TVF03CD95Z3XE553RBD1B4R74XLUBZ6L2G0A9MV07RSMPKOFNIS5NEYZDI6G0S8F3S48E54FQM4ULFSTJFH2HA7YSB70	4
499	DN5N8RS3G1	PAOSNS7PPBRONPAJDO7ZN6ULG83UGPD8DZAMQC7XVD3EZN3U7OOW9BBSQCLPYNJ98TLXOY3BQKEKDQV2EJW2BQ8CYS5N0S9H43FG	1
499	TRFU14BD1F	FFIUNFZ61OARTKP0Q8SUJ962QK8K6PKKP09DNHYKJF6D55HHTRN5XV2FJQDCGO9MEZB2LLMIKHLDD27UD11PBOX47347DVD4FU8F	8
499	HDAKH5P9W5	P6HEEUPKYCQST9PXUKZCH4RRPFYDQ8S420X5TK64HTI1NOUVYHUKICWUOZZ96M30TW02LUDKN55XV0EAUDPINIVZDDQ4U7750SH1	7
499	FFWE8F8F46	2JDEK7NH98XVZP36UNLBBYIDJZQ7A7DTNL13MECLHSEE3I5RE8FE50XDB94VRPGB5DINX9UQLA3STDKA383B29XWYX1MJR42LDIZ	1
500	IQ0VP7I4EQ	R3EOY356ET7Z41SVFJ6PVZ9IHG3FAHQ4UAMEYXDF1ZTE4XPZLGG4MKO236HS9067DCE3PO7RF0X5G5NT1D43BWSKVUK2QVGB3WA1	5
500	HLAPWR5SVJ	VK7JYYWWTV8SX155C6QU4I4DFBUTWCU5WAF36UM86YC8MJ23LG0ZTHYNQ3DWDCARBD6XVC9STSYGF605J0IQL4LPL1MCQ043YV6J	4
500	3122J53CUB	EIIGIGBSSITDIMM3UFH1RM3Z6B3X4RT9RSFS9JCXJ62T39INS9EPYR61OTKHMOYAYTVZH43KDTSUUK663QF4NEL9WODQ84L5H15J	4
500	8OI9QT5AJF	SGXG3LF9LGEXOO6I3WTIVC20MMIIXN3OWSKKRYU2FALI93UQPWOELB2QN73QD6M8MZA6EV1EC1CU1U0T213A8ZDVZ46T5EZJYN5K	8
500	8MD6C924TO	YM35KCU8IY3GJYLDL9XVPGJYHI8B35OYQZEP9FXWTWRFDMWPOFNNHYORCEXCDSFMKE0TU6DGMBC2ZEU4WSXXSBR1LWM4SVTARE59	6
500	QBAUG43EX0	C5SBHBGWV28T2QV4R3JW9H7TJY0SBLUIVJTWFVL9LF04NKZF7G9KWMW4882TKYUKH08T68Z5SJL3RCG88VU5LJVIWZYH32ZWVPWX	4
500	2UYP83OU7H	GJ9QD2NB3M514UZDY88EZ7GKRC0TYIBQTV1LVOHRIH2M3P9H9T6RYTWJCY8BC3MVKPII2NSJ0R5SE3QCDSUFLU198SJ6PGOP4HBN	2
500	M8LP7EJPJC	0OVAW0HXEEII67UJHJ0XJKKEV4UCQX71C5MD8EY4UL3NAYTI4FX7L07QERO2GEHRHQFBVQKCU6D7Q7E7KLHK99QM769R06XPELFT	5
500	OE7G4D95TQ	RXO5VMPWAAHMQR476SIA2EYQ3LYIY2E1UO3X3PNWB0662EJP3SI37T0N97CJYG8I5P2CYGDQEW9CI2YYCJPGTK4BXPY6ND741XAM	3
500	44GWYVQ941	G0WO1YKTYFHJNHP11YVV1OIRHDAYFKU1LM5S212WTR9KRW96RC98P1U2SEHXXWONUP7BL79A68CKP7AUEEGDKVLU2D9XUE87CVZC	7
500	WT1KWZC2VX	8VUC9CQYJMVEWTTPLD9DNIH7LP1AFI3I75FSVAKT55S1OT8UOR0S08LZNX1UKQTBSNG0NA3K2PIS0QS2RGVXRLR9UQE8J0JOLQIB	4
500	XA2SEDHKA5	HHOYQ0K0387E9DD46UH5HF754BBF3GKIRPJ9H8AUGJ1RH3KXGTP5AGFCJS3OYF6XYYXT4DX7TWY8OQYA1O9J0PHKJG0ZFW6BME2S	2
500	4UMCA9GGS5	02D6RLNRHY242WKFX6JRMJXM8270XVJXF4AV6NID33CS85M9W5YITB3QF07ZOX4VOEY8WYJKXFXTHFODP7E17BEDAUQFPTZG9QE3	2
500	OXSSA6KT74	ON8WOUOOKIAM4JQTCYMAV7BHE5EPRU1AU7BTFESR0Y0LQ2UJJW6113UQM1SSQ87ZQ917H6N8F5J7GZ0LL4G4XAJ1MVHOWAA21A4R	1
500	RF62QV59AC	WCMJ8W5TXKWAGHW1DCQZAVWY8LF4RFF5IKY14UZONHZKVNP2OAY8O2ABPXKWQBBRE126T47SMCM25LDU6NPRRHQQKWMGKD7MGHG4	6
500	EXSGMP7BN4	TJUCGWLQHFDU00DVTA6KMV6R1HJF9WYEI9NE5OLVFADQIWTM40WHKUI7MDL8MFQVR9L0N90FYLEMSPJFY6LJ9Q4Y0P11DNIAUS9J	3
500	DN5N8RS3G1	294ARS8P6P63GKP4GVAEXA7H8CLCE2AQ9456QIS86I39586C2FN68FX2BXBPG5LEPP4LOTN7DCIOG8MAFIJ8ODS4HC53HD1A7ZUP	2
500	TRFU14BD1F	UYJ1P367IVDKBJ7WMZL79EMXU0AKHRRO76VU9H9KV78Q1SF34OU9IREPLVHY3VZ1EZNEXMWF0BLBG56BUGQ37SFP1FIN9KRAIGMC	2
500	HDAKH5P9W5	AFR1OIHFDJQZFDWF54VT7NSEIFPTL39S46TA9CSJ8KY52Y4G44NM0SHXXNTI3X3JK75JUWG3LLVXYWLULIZRQW2LY6MVSKQLQOV5	8
500	FFWE8F8F46	UWHXTBP7U8BB86U7L3YFUUYKUKB5JGKBQ11VR36UMNE7LUTN5NEU7ZI987DJATXNYAVHF8PS7D2GQ08A0X96BZD0S1XU0XU2Z1IL	9
521	IQ0VP7I4EQ	MI67WX47CTH9CSMU1L965YNL51KS9QZRXBOPC8PBJ2QIPVXEHI8PJPDX4VC4NL8W40LBE7S367WCIF6KDFK0SJHH70UR6UY843OZ	3
521	HLAPWR5SVJ	WAJ0ETM2BPZZ11HAHEVSDDONA7LIYHO0GBRFAANZ5P6L41E3Q7XZ3HFTV6ZGIEE3A9S0JCAG05WYGCTJ3S10TZ7968TEKGR1KCK5	3
521	3122J53CUB	NTO7R87UQMSNQNZMOJKBS4LS55TO5OD2XAP9M3C0APPVA1431O63930TH6BVPSYBI0ZQ809UGUBDOZREA0WRSK24J51Q1RLR1ONJ	1
521	8OI9QT5AJF	O4BPLWP2XESO7UY5HT885GC9S2ZJTLAMHCW6VBGXMBW0IC47XVT4PLHH1B6T7GILEGG482JFMKV3UM0Q71W82F665OETFX0G2KWC	8
521	8MD6C924TO	A94LOSEZNXPLPVFUKT8JK9TX09ZUPAJZYV721WNX1GR0YI0CUWS1X2VAPHVO3UKMNZX4XN2YFLRDS29RJWA2SSC5A7MUA94H6EM9	6
521	QBAUG43EX0	5OG34WLLRSWHEEGUR45W140AIXGRKGNPA5NI38Y50USP0M64XWPKRM3BYGVGQ4ALEHHI081SG96HLLK60L3X1D8YBMTWNRP6THKT	2
521	2UYP83OU7H	YDZ56ERQW0N6YQEBNTBITGOOEEYU9YDA11CID159RIPVG0YAL5FYJKVRYL11P7Q7WME7N57VYB1L02HNPXIESP0QFUT1ADTU1S93	6
521	M8LP7EJPJC	1XP7U9HTK05EOL1YLOHWY12MGVVRGTI3N1YA2H8PT754XXV125PD2H794D18OZM0RC0WX15EQ1C158YS93ZLDFBF3YGYPAB3UFMV	9
521	OE7G4D95TQ	8EB9LWBEGE5PI8V9BWMBV38UHZPZJG0WDWAYYL2SAAXULJHBQ3TS9ULFGQ2WHL59NIMV76L043AUFNJ7ROJPXHWSL5RHSGLYFXGC	9
521	44GWYVQ941	VDTS2YGT0A3H5E2CPMGW3KCODHXRMOSGHA5K074TQ9U5YAXCTWZKAPDLAEOVAYGLRW94IRLRRWG3ZH0CUV8ZZHF16TKVTJS12INB	1
521	WT1KWZC2VX	33BKI3NJKW3OLBPZRWKQI7YH08IEOAQ4YB027PQO1RW7QHHIDCLVCU25E3UJUJ5JF8ZJKX2CF6Z0L10S1ABMZ41DJ5XD4H3SWN1R	5
521	XA2SEDHKA5	77PJJQG5CUNDBSUITULHWAO9YH8CHE79JB3CVCPOUHGKKA2YJJD2QK46SPUBREY8WN4AYRXRE6WP3EZYPJ27AFT8G6TFRO6QSIY7	2
521	4UMCA9GGS5	1A2WVYTXPCO06WIL17R35427R909G6VP2SXJAKPQAL03EOU1YE1LGDL7I4EW8TQTR88O98KQSA3TD82CO8KBEKJYH0BFF3SQ5HMG	5
521	OXSSA6KT74	G204L2FK13JCCH9IPOHZKGJ7EKZSMY6VWWIGUH3RDNP61DDVTIP3EQF9S2ZADX8C6YPP82XHU0W71MGAGD8EIDRGQIX2S2NPOM9D	7
521	RF62QV59AC	YW0UIIO3IIGVY4AZ443GJ80E4Z2MHSOMDMRQITA4CMH9RG38M0TSF6PZ6VZSQBW043SLMTQL38E611XY539R85GH72UW4ROB0REX	7
521	EXSGMP7BN4	SV3JIYH1T8E8BXWBE19WLOT94QMTDFJW99NIGHZG9PN4PY2429W0FBNDB3O1MXYNYS8BJO47B2X6AZUGYS1DTTR8WKGN274M0AF7	7
521	DN5N8RS3G1	0UOEYYMORCMJID36V4FAAP9HRED8KFATWQ78M944EUFH3EU4AQFFA6ZLUGXUVODLB2W2F5TW9K6PK1ONUJ74A4S01WNGLJJ0R3GB	5
521	TRFU14BD1F	2YE7TF09JB32KALQIKHJ5ATSNK0AF8QVM51U27RY20RVTNBI7KIS81V1FWTIPZ4LUIPOI1XL3SRFT889JRD507WVJAPGNIJC6FAL	9
521	HDAKH5P9W5	W9GW6ZQKQHGXT98W8VXV4FIMQ7UJOIN7XBWR6I3IFK22IS3JLQ7UN0DQ14G8EH6H3JASMQZ01OPTMPD7EL78L3U78G0CC5D8OU99	5
521	FFWE8F8F46	L640H38KTDM0I43J86AYDTG0XX6KRF2QEP2ODHD9VWPCOM4AKYQY8KP20EDT7X2OL5W2BPG02BDQEEMK35A3ZDR39AX8EUC73B0S	7
536	IQ0VP7I4EQ	B95RZ57G9XV220CX9YHO22B1HWI8FWDO4V16FL9IUWAMBGM49K4MSD7I8EKDX8BMUH8G8GSYY94F2YZAJN942050YS7AB6UVVY24	3
536	HLAPWR5SVJ	F532FXSJ1QKPJ3J9GU3LHSPIRX2OIUE541ESFCWDNQ7CXV1CLVPD9SAWPVLS5DAGMOURY14D7081VNU55ZDXFA5M0SCT0DHJP00J	1
536	3122J53CUB	JNU1LGJTJBCBQWFANBLSH1GYKM3SZM5WL3WLT544W2RR9SKRCIBYO04SH5Q8M147FPZXA3RSHR6PJZZ2CMPQKHHU9EEXP6R57ULT	8
536	8OI9QT5AJF	XRI1TQ74OIRGY5ALOW8HFY5Z3DL9ARYNF9O5HZ10K0U5WR0ARTT7NMX9VT7QF737TDBYQEEY5I7OEACMMKSR80A2MPJX2KUM7WLS	5
536	8MD6C924TO	BTMO4CFOI5VQUD5PL92DIMB4Q6UXURRYT6K0FCDY5ODTYHHGZ7VXSPHZSR87RR41N66Y3EKJ5EH4JRGJZN8W53GEYVIXEGHNTLF1	3
536	QBAUG43EX0	SNUXM2OHNQALYHDSH6U02AI5WEY74K7LO9HAN9SB16KEIMP8D4MOVBRRFZAIDRNDSY6ZADFHOS860DXKY0398T0NRZ4Y8K7KTGVT	4
536	2UYP83OU7H	07AZEACCV1BB0TNXOF98TILIQJDVYMTRD4823J3SXL572XH1UXEBWV6RW2J57ROIIU76UU4FLRLHMNP3BMBAIR5S7RFA98VF7XZI	7
536	M8LP7EJPJC	LG929ZEJYFJMQ3UQNA0ZP8DO3FN6FKZXHDZFBII10JJL6YTEAZUW8TKNDU83MIDOPVFMEPOE298FZ1SFWI5Q0CZX3MCRJOPRF46K	5
536	OE7G4D95TQ	GAVKP49UEYLC3HDNWYM6RS1M75NURA45HVPIKGKI0CZX0OPHLESGTOBYIIMURODD3Q4I15CQNEGO2DWTPGJNSYM3U19C401L9V4K	6
536	44GWYVQ941	HPPBC2PHW5EW3EKF0VFEBX96AVWM5PHJL8I03LP56V764PBWQFJAZGTTQSAQGCMHX5K46ULOFJHP0CCUTA6ZFGUFPYKLK8Z4I0I8	2
536	WT1KWZC2VX	HZ6344P8D3NPQ6FGXBRLEPHJADGUMHA3DPMK95KMEGL5654CTYVY1XA2RW31X5V62TMAU5G10EG8DMNEIEBYVLCQOU3NCTYJUPCN	5
536	XA2SEDHKA5	3RYS37WQCZEJZSS47KRR5V9B2ZGQ7NXK9VOXMG2OP9M5YENBFPXFV5XIRWZE0GTYB4JED5R0SCC6JENYMFKS0RZE7GF0RXXIQY34	8
536	4UMCA9GGS5	I7K76XS218NIA2V6B8TEEG600J4P4PUKT3DH9U34GLFI1RQ4CLPZJZ0CBTHX2D8LNCZHZN6QEZ73BY9J3AMSA5B3DAGQMGBDN44Z	7
536	OXSSA6KT74	IFYO8VT16BMU8320PKSB5EYHQE8X4QG4JRU5XDCJRCG935OMJN7TLX6EQR83W67Q4SKRI7CMHIT37YNUZVOQTXTWUQOFFJXVEZFL	6
536	RF62QV59AC	7EMKULCECH1ENEBRQ7G8Y62S6G8V8YHTB92RBG8LQSRJWB1EWDY28M6AL3NOMQFO9ICOMTPK94SGOT55P495APUZC1GI2T89MDJO	9
536	EXSGMP7BN4	M2CXN2E40W18S8SRKNTYMMVNHRP5S3KJR6CB7HWXQ5LEOJKUQSCZZ0W9HYP6MIM6LRQW6RUC16HRBQ97H5P91UU0KC4I10KHSO26	8
536	DN5N8RS3G1	XY88983SE80ZSYR2MF07ZM3WMLAW98WXCETGRB1W1IFEDSJB3PGJC8DL5MVY7GSFMDXNFKLLNEGRGZT3B93U2MVDBHLEPDYU0A1A	8
536	TRFU14BD1F	55SE4572VFF31W8N8M9STM79G6KPW1F7S9GDLP7RXLPBFLXR0G1Y2SLT8S78VSF4AHK2Q4CSOS4H6534I3ZP9RFAXWF2R85FGUB8	1
536	HDAKH5P9W5	4A6EJJJXDWCZD02305TCJF3YKAPWZBM452O22KZH5MUADCOIDMPZS51ZHH4J3X8BKI4KL9APFLG7U2VHVHSNVWL9AZUVQQOIOS04	3
536	FFWE8F8F46	D6DLAUHZ4EOVWXWEUPX65JWPP8Y67SBC09SKOBVCEJGUF9331D3DC8M3KY6C5K1MCL4XEMZT4U2VDBJPE4F4Y8A2WZ90FSH3S4S3	2
537	IQ0VP7I4EQ	GYPOKISG1ZIPR7AF7XDLCAPM9OLN8DJTPK8G0POZSW591KXVGYUHOSCFJCO66FHYQZ9G94PRIN3QFQVY00GKSCE7H26XBR3NOHSC	3
537	HLAPWR5SVJ	RVMJD8BYWA3QZGF87GOUC9H71P1UQB87TNJF4AODDIU1DHLLXORAERIROOSXHQIVC57L7AE61KR4OP3UDQ7BT73BF10PS16W99YI	3
537	3122J53CUB	ANWKVJ3AOD8U8T0TGBFB5GGJYNAO44O0VKDCK18XAB0Y15UHFC38TGN3HMWHJOFTYI9XPYJODRB4PRS222I2AQHO6K47F0OV6GAT	9
537	8OI9QT5AJF	71R3O5BFTNZ43PQGMTHAU0F3LJMDQ7JR865A19WVFJN7ECML7OTX2SMGWXRFS7YVEI56TPPN6V5KNIYJ7BGBOVYQUYODRQDHV126	2
537	8MD6C924TO	P1R9F0HXC2O8IIQ1XHSTPM4BL6QSXYWP2CSKZBJ4R2R6AEJIWQ7UKM1C6QXJKY9NG8GG0GCV8XCW58AGWH6H1CEQLPNJO9U23EZB	9
537	QBAUG43EX0	DSPNLVWJEH7PQWD21VE3Z4K22H8DJ30J8HSYQ3PQSGGIQ37MQABSUHJIIWUEXSAKQYQIEOL7GYLTXBM9JWXI1IY08KQ4IL2AG621	4
537	2UYP83OU7H	YICZDM660UGJV4B51TIAZK38QY55LM1JVWVNUSX514IZJUXQ1EPNU1XOODJORAVN27Y9JXKI5MI5BDY5BOEG7OZ39G8RJIO1I56M	9
537	M8LP7EJPJC	YGD4GRIT1MLPNNC6PPOI49DZ38W7QWGGM8NIAL06RKH3XC65L43PSECYDOBI4KCFGEDO945DYR1T1JC1C1VV20YH6ZEWKSBGHCWT	9
537	OE7G4D95TQ	R5R900ANS63MKFDYQMQP5SKZJ2GPULZWT2U5EWB9X4N2LJAM8R00GDD9V1Z8UV2GHG3RVHU4KQ2BERO913RCV8QPYUKM7DPCBHVE	5
537	44GWYVQ941	S1176P0KC5DMZG0D0VI0N3A6H6HBZA76KSIC0FYS0EWZHAH6Y8LVMODZ04ZAIYVC8HCG7YNU709IHLZHYKM0ZLT5PTL5PXKBTU19	9
537	WT1KWZC2VX	B89V0XWO5SPFSL7M4MWYH1ONREJP8YXUZKXMNF8Y6RUB607MMZZHEL0JUWDVNGPG54PIXV8YO81ZGNQ1H7DJ8PPOTN21CMKZBNGB	3
537	XA2SEDHKA5	YY00B2GUADHFMNQDFHPPBYK3HWBXBX2HPPTJMT7XI3TKUV094W5G0VKAO7SP1TSMK9Z64G1WJ2HHF9IW5C3O1WQ3FT4OBS5ZLGAU	8
537	4UMCA9GGS5	4EX5J68OC5PY5TZZDVXT60LMMV16S688X0B7GTS0RPCYPZF9G9HVNB9D2LTYFC6G6QBFR1TUD7CQXX6WP1ZSYNVW08F5A4UPT619	7
537	OXSSA6KT74	9SPQXSQ9TQFO6INMNSS4POTWXTIMW71567PJJCB5FXHR9QDVGCFNIEJV832DJDMVYJS82EDLQXZ1GBWHPXFU2NX1Y4KQJ8WBKW20	9
537	RF62QV59AC	E3C937VPRO7HUXW813LW0K74XBSBYRUI5JK3DV8PBMGPNIYK9DT2REH45IM2PU0A4YMLM25G55UNERQOMHBU7100CQ75JFARVFVY	9
537	EXSGMP7BN4	N7HHN7WU3ZO17PHSFCC7VJ6596Z4D1861S8K4NU3EGI0TDL038PDT1KEBLHQI1QC1S9PQ6Y2RI2PBFM6U9BEL5MAI4JSFEVNZF9B	2
537	DN5N8RS3G1	6J6JXVK85D59L5J0L05F9GWXGXNXPZ5FK2XZE5YKBBN1NS3ILWOPE5EZXJC9HXSFHZZTHTVQBVD734JY4EL2LPBOX7C52ZCOSHTX	8
537	TRFU14BD1F	JA1A8NT2H529OECL041YK6KR0XMSZOWLV5UET1MCSWPBK6OUAC2M19SN0KKKAAD2JQNTU818RZFYQIH4I1SWVKTWMHNJRCBRTW23	5
537	HDAKH5P9W5	4ABK44C346SDQBJSQG961HMVSQPXYF3PNMO1QM1PR2RK4GBA28CP360XXQ2NOOFZCDZEXRCEPTP9ZB0MPP5ZCNVRV0DAUNADW1I1	5
537	FFWE8F8F46	7MK68AKR17W0P88TQWYRIS7OCTCSLM7385RDU2ENLA32RJEOBUGFTKIOO64O81FPA21UQ59XSLFHYF62PXQ1F2JXWDYX8ZOT4O2Y	5
548	IQ0VP7I4EQ	T7GUSWIFAZJ9C8LLNJHTD8NGLZ26VNKMIJ6ZJGXGBSVNPX50DIQFUFOUU9J23MTXP612CVBHWBSVNA1Y3B2N6F1C5LEJ74MY877S	8
548	HLAPWR5SVJ	DYRGJSTX3HUIV81TG0KFY61Q2J1Z3WPCJ20NKHWWIPCDUBM5UF2GXNGH6AOA144G1R92INI8EX6J4X6075EX4IP6VSRJ3W4OU6LD	1
548	3122J53CUB	TWG63C9Q7MIEXD50GLTCDHZ69FR2SY8M2YNI71AGPPXGIFFT9YOU2A8L6K7YVG7IO6L8ZW2PLNWXTTX49734KNT10BLX3MUIRP2M	8
548	8OI9QT5AJF	G4M58JPOK2NWDYXMD8AMUIXKFV82NGE1LA2DR8LEENPJ8A0Y76OQ19J8GB0NKWAEXWLC5T5EW6IG3OME4K5R2X9L147PI83RNKWM	7
548	8MD6C924TO	Y2NAJ450CE2YVSA1SM9WAKAWP6XC12T1AQGRSRS3EVY0F0WQ3057X0YN20UMG39KUAYFLSJB3FSOVJRYJHJB6VEK22Z16FXKVOFF	1
548	QBAUG43EX0	REKR4DRHJ2SJ6C9T8N95ONT3REYSH3HEMW2C9TCRXCSAGSACX1XAGJXEVQ9ZP9AQUO7JK6UOKRIM4SW9EV4PGG8C9YRSUMCYBCP2	6
548	2UYP83OU7H	021GIZYBKJC4AV4EUJOQ4KVOB48PUL1C3ON2CJ7QJBYOOYT1HTQ2BM0QGMFO1JQ9S9AWHCBLM8G3WHANKGHA49BQX7V0DSY9UY6O	6
548	M8LP7EJPJC	7TESEQCF739M1EVBQET8T8KQLH4JHI7KVZMXCS0S8L0DVNMND8ETNQE9JYG6V28Y5Z1C2887OA9IHH575QGIEO6EVMOOL36FMBH6	6
548	OE7G4D95TQ	KVF9GFNR52B2JBFW0UR2WQQUTWVD36FA9KV4BI8JTWZUMWC11TWRZDA3FVQUTKY9WB39PLVRWII915H7T3LJJYK5K2ZQ2OZJ8Z7K	8
548	44GWYVQ941	DMQ8F4Q4ACJNSA08OZ718YXVEYIT9BB87EQR5KE33AJZPCJN9KTA9T4OY43QW749BLQOTJCDVE77P8FCO4UZRA8NKC2BRXG6FKYE	6
548	WT1KWZC2VX	540IPP5W690Y1C2NFRAMDDRQAW77A2EJBQSA4QCVC0NDCN0VOT92Y1S1MJH2R8VE4QWKT1SYPOKM0OOX6MSR2LVJ71XUJJEEFJJV	7
548	XA2SEDHKA5	PBWAKNJRGB85U6FPELS5NN2E8PGJFHQE26RK5QR8L110YYZM9YA700NCJSC5H9L9U3CXP4UX4UTVVCPJ03KRGTOCTOAMOW0MQ1F4	6
548	4UMCA9GGS5	C7EEMDGG1QHC2FOZ42BPADA3HJH3HF46VXX5GN3PH5283KWRLWV9DPV86K6D5M9VWKRERSTR8WHELCA7W0RUT42FBZ85QZT56GLS	8
548	OXSSA6KT74	R93DEARHRX4K9RF4PB1RLC2UXAJCMIE0REF1YQP4L8UBEURIOAQEUAQOHIQE1P5ISE34LOF8W6GNS0QCTAXL1AGQY0TPAKD5CLT9	7
548	RF62QV59AC	W6A4SRX4C6R2NV11TRS8MFV4Z8L3KKGHQL6DXQJSSWV4CWXZMET4ABPQLFETG4T1ZKMBYXECIAP0T12DLVQG1MGO5P1RMZLYC4E2	3
548	EXSGMP7BN4	VAY9QVAWZ7TNBIUNNAMD8FJ6X0SY1XZX92ZV1HL0F2GSIDKQ1KZ31YLP12MZDM4BH6NIT9WGZV8G91YTQC6R855LRK395VX37FLL	7
548	DN5N8RS3G1	B72YTEG0FQAE2JAPMDLBC1IFWLE7FI4QM4OEE3P1ZUM334CLXNUB9JWKYWBIAIV6WU1845KTYTMSPOL2I2K1X2QCHEQR2G1Q9PHJ	1
548	TRFU14BD1F	ER1CBNQ7E4JLJ9I73I3DZ00P31R25S9HCZDLSYWOAFCJHGTHTSFGNFNN1MJJ6XBW4CJT57OFWPDTYQIWIKJMN336L0TGPMSMDQPE	9
548	HDAKH5P9W5	9LVDAU8C3ZKDWBWOZIBJMHFNIZJ71QHBDYI8XINI44SBJC2K58OHN5U2FI5KLBKNRJA83X0Q52OSZEDF78B3CAXIDQ3OMC73TET9	1
548	FFWE8F8F46	4RIH7LUQCCAE0MM9RLQV24M3MD25V9UUECDQ3VEYD1BN2JW0U3B3CNK9EO43TZ5DSPAXJ6F5G2SA29ACRCK171R02DLP1KFN685N	3
549	IQ0VP7I4EQ	8QYYGWK5JHFN2MQOEG17J4FU0E5WEE4EX3SVVD0EH5S6GB88Z911EP9DKE7B0Y0FMAZ8343APW0OLJNYF77FMCAH4OKQFZNTENUF	3
549	HLAPWR5SVJ	9E4G1MRZU1B1J530V2JAREOTM5ZIHK8ZHMF2C9V0SSJXJZ63U2TVKF35ZL45WIRK3LT6ZAXWGTR941KW96YO0MOCSKC1F0DKB937	2
549	3122J53CUB	ADTE7O1X4A8BH60TCTQ7QNP76RQPH758MQ92FK38XOYKE073N08PMAZWYVIQ7LQ7EAY177O2ZSJCZF3GTXCR9PVM0METCNAL80FE	1
549	8OI9QT5AJF	G6PLFZ40X7T2B6KJ87YOMAU350MR8D89ZEN1WG301VDPV1AQ0BA3QZYFLWPONM2U8TC6TTX2D8X16FIE0506CFTAPHPA0PMO2TQB	7
549	8MD6C924TO	D7HOHZRB7IGNLYSV6R39CQLDWCYWJ8NYGQW7TR5PB8S9JWP0426CXBVXWE2FB5295RH5CUCOWO8D8L39X81QBKAE49KPZZNGGSD1	4
549	QBAUG43EX0	UXJ0SQIDSYKK2SDDL7UQCADJXY6A17PIBUCKS0T41AMK9E6HKD5VTLMTU9D3TIMVICIIP2VUOZYBY2KS1YZYB4Z0HT0SXZKTY1C6	8
549	2UYP83OU7H	Y2SSKG3WK41ZUB5SXTNNSA5BC7YOFN70NWD5HF0Y5E6Y92CXPBAHYTNX6RPNROR77AM889KS2ZROEGBJ4B9DMZB3JP800NGRW918	5
549	M8LP7EJPJC	EZP0SO9B8T0PFTQONUH9SYSAU1PS91FOD2ZLUN4LC2K6IKU30CJOU98QHOF09QCHOLMN3F4A0660NV2JHV26S04D4JEFHDMVZDS6	9
549	OE7G4D95TQ	HAVIJXYDICVW6TNYFZXRISTAY2XTLAKC5KAUHYICFAWHSTLT86UN4P0YRUTQAE1I1S0VT2RQQVMI6LSFRDUOP6IQULDWE2BAIOP9	8
549	44GWYVQ941	0AGPE7JDR1FBO97TN25KKAHY4LYTL9S6SM0DO8L98MDT7V02ER4VUYSZ3RU2J01RJJSBI4FOR6M77X0JV5O4F7L33BK6NT0HUVKY	1
549	WT1KWZC2VX	YTKLPEYMV2F0LHNL7MM7YIHTIA7GEMMNCG6LDSZ2XRIIEFCMM5XI81NQM0COGSHIQ2YFKBIPWTJHA8PD8V3IZDOL2P9MPLWFJ92M	5
549	XA2SEDHKA5	7BLXIWORGQNL9PUY9TNNNM5B59L7D7AGCVBURVRQA3V9WBQ5BRKQP9EUFJ1ILROJQHJNO9GNC6NT06P4TQ6WWU1DRQPH3IFTPMSP	8
549	4UMCA9GGS5	CQBK6NTWU4J47Z5U1W5PF57U9U303ENNACQ94MZGIQ7WFN5SK8X0X9WGSRLMU22PQ544J50O6ZHZ8LOVYLP5QXZBQKQNBNWPYSGK	5
549	OXSSA6KT74	AJPHI3816IHCZXJM682F2O9ONNSC2BPFECXBAYH41JTBJKLZND1TNE0WKA45K5952C8XAHLI08OT57FCB3ZYJ61ALB1A3MT6KXJH	4
549	RF62QV59AC	YZF1T2P0H1M423RFKW6K7L9PKOOOSIHY8ZNDT70DLKEKPGBSB0ABM6PM00REOAH9TX6CQNWM529XHYAEM5N1HGLBKAN3PVZKCF01	3
549	EXSGMP7BN4	8CXEXFU71FB0M1SXQ2NM42PA26KCYVC8I4O2ZXTA0DS5MDC3HXWMNPPGXXL05SJFDDRSNZ82IMV1JUXZ4Q5A9ZU3PHFBL2EI4M2J	6
549	DN5N8RS3G1	UQRZ3EB3X6CAV6PWIGNSXDGT6QQHM662NDJAOLFVT91KDB05ZWVGO07QJ72MX3R1AKWSXPI6A29XM5Q40US0K0OXF30QT37ZSAK2	4
549	TRFU14BD1F	HIKNZFV1KEOQ7WCL0QJ69M4Z1NH4JFMUXPSMIMVU255YL9VG4O1TB6Q5OVVL70SE142SD0DO4YDDQFN12AA4N2T09X8X0JXBM07Q	2
549	HDAKH5P9W5	CDELNZM3MPJH4T60X19LCSQ1QXUBB0ZI6UZ75S9DG7XHZP600KZ87FEUWN50EK1VZBKJ395E26EE5ICA03L0B0K1QFKSXI85FBSY	2
549	FFWE8F8F46	X60PUGBA9YOK5AK9AT80S3YYNRT7I830O5C7ULRUI1QQ6H2IX6FST7W4ICCCXE1A4Y697NOZCOS1MH2FZKJM3LGRJIYSIO6E9PVI	3
553	IQ0VP7I4EQ	2LJSQPFO4RAK6NM4PHTRO0YZ6QYRO27WT47894N5ACO0YIMATJUHC06BWUV91XACTN0CQN4U3XRMM8AYEX7EHZU375MOINENBMHK	5
553	HLAPWR5SVJ	JUGP9OOJUZYU75EZ64337FUBPMPTEK90ZG4C1YHLFTNGX4KSAXFRNQUEAE9X85FJZ741AB8HXSYO1NNVB7TQESNJW0CXZUNKNDRZ	9
553	3122J53CUB	TR8Z7452GMW0NVALYEGUVEK8KSCENAX5YVRQU1HYSQPNP6L9M8Z9KFOOH9OP10PGZ1C2DT167SBEY6TNGD1OKYUSHCJUN162BJYY	8
553	8OI9QT5AJF	T52H2B2EJZLQAIY8A5AGUUAKGTFWJDPH4TXI9GSX2O7N8ENSH3AOYSK84SBI5F4FKDVQVQ93MNNFXXMCGXOPDATMIYOQFJ1XT2C4	5
553	8MD6C924TO	6714GCKFELGF9CI0PCKUJH6CSYCV0W4VSUJ0XV68IGENHLGGT6EZ2JIYAZMR9ZPRQUWO2SD3GMMCDT4GS5C3SF3JLVZ8IO8S1W6W	7
553	QBAUG43EX0	1NA2KTP6FUQ4F9DWV9K1NDH2EU1N3KQWHS1RCBHWNMGAJDDP56GWV5KXGIXZ1CC4D3XWHVUT2YOB6GTBRMR7D4AMHDL3NR5LJL6P	5
553	2UYP83OU7H	QIKLW47RJ19YWIPUE0J3KPDJ0GK3C1VKDUADHVQAD58MME0JP0EUXWGBEAVQTEOSFZVCHLMTJJZPR07VPANMWAXRO89HAAQ8QPHX	5
553	M8LP7EJPJC	YBENVKN60UOC9AT1B5EBEXJMFSJ218BTKC18I8AZJUXOVEBA7GPUCVPA22IDBVE1S427JUTC5O2T941ARJ5UTRRZW0GP06YYP650	4
553	OE7G4D95TQ	E1NXMYX25A7BHW2ZUIBNCKSNDM80EDD9AXMSR7H24700IOSK685X4NK4I9U906X268BTJKHWBITFT1EY3Y4GIQFWNSJSNHC7J83K	4
553	44GWYVQ941	8AW0IWV4EKR55FCCQTQ3OG1AZJ3GV5U84L5XIQ93T2IH2XRCA42PMR92JVA83PIJ0SAUKO4ATXJV7TIC21F0DFVMLCOXPA9ET9RJ	6
553	WT1KWZC2VX	61VA15ZIN50M8GCJRGV7XIHAGVTXEB7B9Q59UZLJ6E7HYLR475B36L8XTV4GMBDL7YMSKCZ14LASKAM5EY0JAEFXRHQ95E75BVK9	9
553	XA2SEDHKA5	8T5FJ8ULPNSI8CXL3L3TYADV060OFRY0M6FF5D0FUMB4707CJUIKQQK8QJPNIGF8Y25B6SPZVX8L8IY98XEVIOJ6WGZVYM6NHDGE	8
553	4UMCA9GGS5	6F1ESY3R89HUPPVCUZJT8PZ34BJ1UE5CTECRMRZ0QPXHRBI6LLWN7V5RQ8KROC64EFBKNEZDASCT1SL32MPJRSE7IVBOHILOS3DL	9
553	OXSSA6KT74	7THWTNOSMZ7WRZBWXMVADC1DL52GYB8P9353IW7F0O65D10SJ14QRL652ELXVH3L1SWX3INAOQKYF59TFJ67GR7Y69AELKUSVVEU	2
553	RF62QV59AC	CZBN4BBAI06E1RML6EJV814HIYE62DT1OODT5TLQ6XYJEAU2HHYQ49HK43FF6EIEGEZNN2PN23YKCUDIEMYUOC6PH3ZCOGT1PTD9	3
553	EXSGMP7BN4	GOP1LXBK6HK06BUQXZDIKGUCM8WJ75SRD778I3DP5EKVOMRF9L14A1A93MPMB1NBY3W9DVH4WYMF69YARRKVDYRL68E5O1ND0I6V	7
553	DN5N8RS3G1	SCNE6HLP5D3YO5UR27AMLCFQLQ5KIPXDCK8P6RHRF6B4LH963W8L6JOQ762QMAGQQ0WE6EUK0SGPAKFER8RWQLH36SSAZ1EEZVNU	6
553	TRFU14BD1F	49YCXVNC8PW0Y8NTU9ET2HOWUV9OCZP7VTW92T30307C5JA20UFWJB2XVBSBV9AIAZFEMO1AGNZCKL1KUHXRU3XT19N0B1E4ZYCG	1
553	HDAKH5P9W5	6PM3FP5MZNKKHROLTYHBVNNBA9PJ4NVIUHY1LXPN2GBWDQ4JZTF95FRSCL3FAWSL1B0A2XA5J3IPM18UFFTKHVNPZGY94JMGYZ4B	7
553	FFWE8F8F46	3RCSJZB6CFLNIA5CHEGYKLV8ABARC0W664LXR175MTWANWVIRDQVYNOS5DSIZU3MTOQOZHVPGKM1YVVNP299JAISP21OJZG1ZKR8	2
574	IQ0VP7I4EQ	HSKSAPNBX3KRE36U4CSG786PGGREUCOEXHHKZQJV5R29R6F5KH5H82IIV4L48IRUOG47VV5N37KQG78KBV4NHGF499Y4FOXWAHUK	1
574	HLAPWR5SVJ	IKYLROBS2CX6B3MOENHAA8W7AIOJXQ8NXH3LGB02EMG6B8EUKI64MJCJY0LJA14MDKI3ABHCXP5X1Z6BE38OTDBOFTWPZQ2NR430	7
574	3122J53CUB	KUJB3H6NOS84KEG2Q2AI3XRO2MGXSG66FK3JZN06EA1AXUPMVVBC2S7WC4IQBJ5IWCZ9K7CCBEE36R0H73C7E4DXNHG5EJ45FSOV	8
574	8OI9QT5AJF	PBXS8AYNDZVDATHG8D19CWD1H72JIYOCFMR2OOF3OJJRU2EZXYGPWV2276LBIPFPLT7YCO2T78U3NWHO3CWTR9QUUY5RCEV9D4GA	8
574	8MD6C924TO	PXI6XRYA9PLZ6IF2V7MDMENTKQ3MVZSQGUNPNX4S1UUIU2G6QGS637RLJZVGXLPJ75TM4ZO7D4L2TE9SK76OHVWICCFYCY4PFLLY	3
574	QBAUG43EX0	3B02U39WZ2FZC50PACLIKK2UZ5O95XI2KJQ5FWW1WWNKA992EAEIAQ9TJGCZPA0BTMP3P4KOPTWX6SU05W55T924J6V9U7MW6L0X	5
574	2UYP83OU7H	FMJZ03Q3LX1VL32E4STTUTSIK3SGA1U16HZJVF2GLA8J4NIDURB3GD8W4BO6KK3TC9YEETTYZMIUVJO7UOWS01V3IDPU155BHOH5	7
574	M8LP7EJPJC	E9B8MD35OAUXRL6XL3KO55AD873RGMGCTIQPVTNX173C47JU9N6U6Q3J87APJMYB3SEJ5RC1QWX8B8IBXJR2QWFCPGQXT8OOI1JL	8
574	OE7G4D95TQ	AYRLEEJ34HAY81956VHNB4YAOIRIIZKY7HXV9RMR5JU9Q8UHOTMGB81F9R66WBUF7L11DN5OJ0R2KZUQXK4ZNDX8PRWSVP44YOCE	2
574	44GWYVQ941	3DAX87LQ95J7QIMH423Y3LV1N335XD5XPI4G3BPFMRQWMVFHSX4WIQORSJKFEP369WSHOFN3NXML58O1XVNAIJO84MYU0JB6YTW0	1
574	WT1KWZC2VX	73MJBJVECWT4SRSC2X0ITNBR2CDWPWLMYY02A0H93310E0H2S4665RTU14R8G8ZQLHF300BCP1PZVLNC4KDV0OQHFFAGIJ34ELP7	6
574	XA2SEDHKA5	NC223QEC39QRPD55DZ608YUZ53G7UUK6PRQIL268LEMGUY3F89BVSGVZRC7AKHRIYUB8WXTL38P4MOFG9B9VTYNJ511I46XEWDR9	6
574	4UMCA9GGS5	5SKPZ2U11ND70AJI6YAH2C56LQ7KKHI6FUESYF462RDOXKE5O60OR232WOEJ5KQUEH2G60T14EOL8QIAMB6OQ4OM0L5KAUBSASKQ	5
574	OXSSA6KT74	79XM8TNOS4GGE63NCEJ2QPU4J1KC6KPG1ROCIBSKB7IRZD5YHE8OAYCSO3DHJKSIO9OWR1FAV91SHDEF5V51LAFDP6XP8KA0P9D0	7
574	RF62QV59AC	JGP872B6UKLY8MXO06N3LHVE0CL8BCHAOPVPQ2OIDG5VM098NLZDZ6OCULI5RD5RDLKS0H87SF0EL92ACNUZMDKSBT5EUS0AKNSA	4
574	EXSGMP7BN4	RIFM2VUGJ0VTI2ESGF9B2QGM4N9OZ38R1UVEPMUSZM23KULZVREIS9XBB2SPVFQP2D2YH9D3URLQXNCJBJ2IZ0816TDW4E6T5NAG	8
574	DN5N8RS3G1	XRWOLXBXHNY0JOMNI0CEA1X6Q9PV2UKM5QN2G3ND7EZGO6U0UGXW8B263Z8LHP5WCL42ATGOM9H6CRRTOZBW7YO4YR8Q4C6SICED	1
574	TRFU14BD1F	20A9IJ9453MIP7ROJZN79ESV0TKCZX9MNRW8AWZOO92XVIPEOD9N0GCYHOJY96FI3A47LTNWA9SAL4AREFYVXWVHO71VNAPS4T3V	4
574	HDAKH5P9W5	R34ZNM1YCMMO1U3HTUHOWTN22I9TAF1AODWM45KK4TMVOGWQVKK9WG18QC7ENHX6UL9X8RNYK7UDG1NVWT7Z52OIMX518F6W5PAD	2
574	FFWE8F8F46	8SE6WYZWY2YZMS3J7B171LKVWZFA7H01KOXA33IEYWX5GBVWCN7OIFPWHSK6TZYQB7O843QE2XJFXPPUDS7UJMSE8B3KSLV87H4I	6
596	IQ0VP7I4EQ	X2J63VV6K91DZ2B2EHYPK939FWRCKHQVG7QZXXQ06IYCBH3STF3AF3MY8J1GETVCSG61MLFQ08TBK18728SFNQQNU11N6JWNXWT4	3
596	HLAPWR5SVJ	BGIANJHJLNHL3OGAQYC0TGUU2UQLGNYHDX12JFAGJDJOTCC5QMH7QE14VYI235D7Y9HGWO1LY6RP7GA0RV54G11957GU6HMNALZU	8
596	3122J53CUB	6JCU6IUXL6OYRLI9J07IIKZHGORTDPVQQ5VL3JKSGMUA26P6EN0V1LWWT5OR1AT5L7IWZ6GAQOB6ZZOJ9UO0ZAZEJ928521F2YY4	7
596	8OI9QT5AJF	2GIH0ENKZ64QESGW3GLIDM0EHEXX5DBAUVGOGS85L3TC7S0JUT9RNVUQPE9VRZOW445SM2QKIP7J2YGZNNDMETW9AZ8BSMOWP7HC	6
596	8MD6C924TO	I71DYJ8YLX17KIDWCRLH6SW3O16BK44QECFPLIPKYLZCHEIEK9MQ640ZK8Z7M6NQ3L3HCXK4CATU3UVJS11KSOTJLQFNTS727IJ6	3
596	QBAUG43EX0	ABWZSN6LF50MPOVFC8O1U6WS7KTC0XULZ9RZFV9AX7FUOAEEMW4K4F0EPD1H43USLPXQ65AR9NEW0BE7GP0E2KQUIMKB41G3MXJ9	4
596	2UYP83OU7H	XIRWNLQADOO94BODQZA8DHTU8WHHKKC2ETSHIRO9ATE86CA01057JBKQY6Y0DJ03LV4KSH49LA8UDVY5WQPUOFTDJCSM3X602LWK	3
596	M8LP7EJPJC	ZHU56WIC0MDH2EX3GOGC1BQYSFXEH128OX7I5YSTKATZOEATJ6W6QIRY15M09E58UF3EGO8R6X10R0JOED5KF5SFGJQ9L1TGFUFJ	3
596	OE7G4D95TQ	6M48EA3R0GBW8V5IU3YWY8779GEDUV7UADI0AMB5ZXQCPNNGY7U1RWW7O7986Z6EJRW4MEII127AS5SV37PWBFCNRKMDMD990L37	7
596	44GWYVQ941	S3TZL9YZVPTPNF8KKDDPINB2F5Y38JGBU4KE57ZFNY552Y98AYQIZSSE10UQL50MJS4S44OMN8BUSGAR603K28LCMGMFNJ4S7TWK	8
596	WT1KWZC2VX	QEFJD41R7WV0DUUBQTKG1GXRJ9EDSX8UZXPWXAYDUVOT1OJZKRR9LDCJQX9E0X8KXAAPE7NQ4HWG2D05ZO3BF9IVVFGAAUM6WD60	4
596	XA2SEDHKA5	4UMDBEER6RM7EOL47EX2O481NPK4ZTZH9R54R8E5EDYY3C6GBBZ8I889WUZV4J2N2F7WSRN9A2XKFK7KSD3X308BS6H6ITA4LL6Y	2
596	4UMCA9GGS5	JYTY08PLY3LWPC0QETBG6DWJR0R2294NJFJPJ9C2TZ4C5J3QKOH15SIFBJGARXSY98NJ3KHERIXGJTNH7ARO1CS16DN93CL5HFD7	9
596	OXSSA6KT74	TW9GDKW4B6S69CQFD76PWM07ILP718DPQLOOSIY2565G5D394ZEIHRJH5C814YDD2CQXYCW5IEU0RTBERPDB45I8BGSQJ67H22N3	6
596	RF62QV59AC	FL2DJ9C7TZMA3KPVBI73RWRTFVLGN7ZFISLDK8V5FARRGQQWRV1TQ9FT4I7XX6UWAG1L8LKDWCXREANZFZY1GFZJN2JCB8HJP5R9	7
596	EXSGMP7BN4	EYFKY6NLXO44HR8H3P4QS8FCIBY4OBISOBBASQRJL7ZNPI3QJCWPXTFFSDCWHT7WFLQGQ7YM8UEVJ1W9IIVLO35555SPN5B2ACIE	7
596	DN5N8RS3G1	X9LNKRCOU60QCN98VIMPVKVPJ8CTMVGTSIVJK7DL3RL818LSB4O45YGMN5EMPSB90G7420XYEBWE9XYKXURSGLY4BI5O215KPLHU	1
596	TRFU14BD1F	QZLG004BCN0G4Y5AS2PSD3T5I5MFLYXPDJH4GMQU4285EI8DAK6T2C7WGQ75OY0OZKCVRB4GM4XK4X0A6IEB1EWBLUX0PVGFCUF3	2
596	HDAKH5P9W5	MW9P0G8OX1SZ68FTZWVYBJ6NE11YRHKR65UWFVB7YWY2EASXAVN8UFDDZVL9PJ6PRA3AOTODVY9PVDIDIEY64M701R6TJBROZILE	2
596	FFWE8F8F46	SIQHJM5GYRVNI1LVAVFCCI7W43THUZN2E605HYU9CUD9LGBKF3YXFBFJL4NP3YV9E3ILBQOMAGARF7LX2IB1A0WD0QTMKEFO9E5R	9
612	IQ0VP7I4EQ	ZJZOMW9AXDOT0XUW38NHFUU7BB5AVSAB3ZC9MNXDWCDME2URU2FFRK1FZ1ML19OFCMZAVVJQKKUDRH2IQOP3M5UT76JUAMMWX7J2	1
612	HLAPWR5SVJ	U59SZ5GZYXR9E4MUV3H2GCYMYQ888QT7AF6TQLWAN4JJ2V5S9CCEC97RHX3J6I1IDT9883EKGHPL3PTDUP96NP5AIOL3RNDEDAFI	6
612	3122J53CUB	7UG7284TVX1DZZQJ54YX80TRL22EKI2JKSW528VQBQW0UZ1YW5HFQVWGAYW9F0JM5R2HCUQ6JIWSD27VADRPAW3Z5P5ELVLLHK5C	9
612	8OI9QT5AJF	UWBPK6I8EDI0A9BI3LIYDLWZLVX6LK365YQRQAZ0V01MWNKWJCN8XN4IALDZJLX3KL5MTU23VSDMUJD8KAXI74IR4HQE7AQJC8BK	5
612	8MD6C924TO	8DYKUMFKRY0IEPJXO5PDOSLDX6VB3JVH2QM688NSDGMS062UHWXCWHDP1VWX0DRHDSPXDMZQS79HF3M1DB4HVTVVN6FNMZ19ZEPH	5
612	QBAUG43EX0	ER47HTYH6K8I4TZJKVU64KGHMD3FARANFK9T9KO97NQWGERFBZPS5KW3KXVD0SHOJUDUUGJAHU9Q4UAHWXDKCRS4XFJLZKIOGCMW	1
612	2UYP83OU7H	7U5QOLKLG9ZXNRDO6L1BI6P78L7MVK2IOGYCI4XGITRFTYL2F9J0UU1AF8SDO805HRIG2AGCXV3ZPKNJ9EHVABX4OY7JMT2J2V8B	4
612	M8LP7EJPJC	F9E3HC90CV5UIEJ1F5F4O1EC7ZE3U63LM34EC229XEMDCYDPSSX02GBN5B6S8GGF1TIPJFYMCFGKPBAIVYKBICSF1RJA5KBR7HLT	5
612	OE7G4D95TQ	YFN4KYXA184BX6J5E6YACX25XR1EZMHZR27S7H8O5FASP9IO1V3KWSNBNRG36SKO0EU591878KE7XJQYINMET6C8O6FPBERN5V2K	4
612	44GWYVQ941	MPAX5MMOPNDBRVTFG53CVQDVS6331CBRGJ58MRXU0U9SCOTT7HYZ9I36LOE9SSWNMW4IZV3ZIILBRVTENK5UNLR8P9W8MYBH7VFQ	5
612	WT1KWZC2VX	K3LO9R062P049WIXCAAE63094MUHED5PDUCQTFN41BWU5ENC3U4VFLXRDMTX7T2ZTL0OT1D7WGM4GGE09SNTIKK27VMHW06IJ7AT	4
612	XA2SEDHKA5	8SCQ78882L7H3YPFIQIB8R8O5K6JEVIFUMB9LCKML3FJP92CRDAQ2SPRUXVWBZ4HC2XRWP3FF60FLY95S42BU1MC7UPXRYKW97HW	4
612	4UMCA9GGS5	LPBJ4L62JF5YZEH62WKPVTCAFYRVDGNQNTHP010QQKXOT91TCZGL7G11MADG3KYD1OLG72GB639K6XQG77SOACTG1PCZXUXFWTXF	6
612	OXSSA6KT74	UWKTEPDGQ4YU7I52JDY5EPRZQNMG4YMALTMLH55XQ9LUOF0L1NMQ9KSFEVD1C6M1SYIO6UUOIBOEE6KKWBPRM6BBAGGW2DUTXTC0	9
612	RF62QV59AC	MOG28H85NBIK2FBR5PVWHNZN8WEQ5RU4UNJWIYOYDFWF8L98TB2DRDY9Z34LCR96QN0O5PJGB6TB1TPWWG64YQNQZK7P3CVVGZYU	6
612	EXSGMP7BN4	UCE2VCUTXHFNIY6VFH9AKZVR3N9L85B54BCE2BDO26BC2BVNZABSYTK5RW8IDJV1GKSGW12DEVINXSZ21VV83TGK0GWGD4KTLK6R	5
612	DN5N8RS3G1	O07H8NDL7H96FQRXW8WEHQQFV9JLYBNVHKM5X05FD938XJ7N25YMKNK8K2V8E1W54OY5EW95CRAIWRRMC5S3NBL39OV5E6BLM7EJ	6
612	TRFU14BD1F	BJG52J3NBL2KJ6II3S2C56ZBE1FPZ6ZMI1AVM7U1RQ7C2U5A2CSPLGZFTF1BENXFWQCS6X657BVO8XIT5FXWNJABB4BHGSXE32QL	5
612	HDAKH5P9W5	NDFGXRKVLH66HG8ZA2NPBQCVZZPNQVGG6CSBSQ01ZQZWEK8MYO29C6Q6BTQ7C7E0B09EX7HUCVZV1PQO0CYB2GEAWW98A2Y2L8UO	3
612	FFWE8F8F46	3Y0HI7QG4EVDBG9ID85V8SA8ITJ77K24BE6N74UJX41RN58VYUHAZ2LLX28YXTJUM0B7JWKJNV8E0TUNVYIMC1FI2VZF55WDVHFX	8
629	IQ0VP7I4EQ	BLCJ8WD4HUEIVD9K6RUV2FY6FNS95TTN6TUMGCDEBOUAV6J2W2ZZUBA5XGEUEE8YB1LBSWE3NPUOUXLJEZMC4325TYZ98TA6P694	6
629	HLAPWR5SVJ	IJAY5LFQWL955QP164H8QS47E44PX8YYRY5PMN8RXP6NZECCUFTC15EZPCTBQZ2YWLOGU9OS6ZKBWRIA124RPV6VUGAK46A8WH0O	7
629	3122J53CUB	6RV1AGCUCD84TJY4KJAP2WO8DY9YMOO03K5KJ0OP4ARCCQLXMDL8Z97JCXYLHNIXYHAJNOVU4UV2EM5XMLMIDPA4MWHWCDIQ23N5	5
629	8OI9QT5AJF	CK8S0EEOFF01A85A9UJGF61G9S1ME9K8AHKAOZNL5QHQQ4BENQ3JEYKFT2THN2JF4203Y4WJH8KYYKZERX9YGB3M6ERWGF7DGBVY	1
629	8MD6C924TO	HPS3TCGNVQICP003V938O7TNADBAHRXYABJHQ4W8X8KXIT1OHJVB1ZYK6E3QAFGE3TBOQTM1N5LQW5ERMX376V6LM9KLBF8R2G4Y	5
629	QBAUG43EX0	M8Y73X6NIXBAMENMIHHX0BRIAZI64XQAQ99ZFAC797DLJLZAVEU8WB0KRP6EPATVHAUMFXHHFKX38F9YAHLZDROOJYIZE8S9NSDI	7
629	2UYP83OU7H	M576M3MO7MLPHDHY4S0WFDQPRDG1XPQB07XMN20XBALL6K75KKT9NWWJOROIXU1S6KYKP5LB1CUF1ETHGLRM6QXEKO76NRARJ3PV	6
629	M8LP7EJPJC	XPP9RIKCQRJ7HCLDOVPWU9B7OXJCD68Y7WT5BNOINB37Y8GPYO4HA9AXOSU48I9USUAUTPBBHHJTFDIQQ4OYB1Y8V5RT2TJFCJOD	9
629	OE7G4D95TQ	V6IM393ZRSKJENE3KS16B9Y8RIY7EQ5ZFS48FMI15IEMGJYFFL20XH6WHJ5UL5VAWVEVTGY8K9B34L1HUS23YEC7VH05QXQ9XDZV	2
629	44GWYVQ941	CW8X4QXGD26SXA2D2MSSGALQ2RXSCG0VGCS53G3YP1SP3N3WX540HD8CLS4M2EE7BKMUS7JWT3DPR5WOXA5GL9OCDPTLLQ5KXUNT	1
629	WT1KWZC2VX	IE0VIHO9TUQ5QY2J7WB6JRCN8LC7316RDNP5FUC2ADT5DQ51DBZ8LW21CMX7FQG2X81DJ6DMTJ6F7GKRQK41B7GQUY337FWT61IF	7
629	XA2SEDHKA5	1SG7NPC0W35CFR4WO0Z2KSUCKPNWMIF8E3Y2X4YSE074711Y26SBTNNJ7EW7CPOOX77M3C9UCHXUUZFTYY4P0EO1QO4TH0PZMTGA	8
629	4UMCA9GGS5	O50779LZ2YH8DJNU8XTSG6OHQNL18IBSEZJ3ES2FDBX0XUDRBEN5XRXSRTRUXU0UWY4N9UQQ4OPEIXT6J3044F5XC0MVAIRSLDD8	7
629	OXSSA6KT74	0SRY7BJCSK39VK446ZR3HKII5PV663FUVGTLIG7EWUTQTVP8WYOOWFSPJI3RPMFZEINO1TV01MHW12ZJ9XKIO08QXDBAMPYJP3LK	3
629	RF62QV59AC	AHCDYWJ76XRTUR2C7LNK71XSVNMY7H7QPA9PHFZEYS1PUQ276HSS79LJTURLKVAZ0AETSM42VJWOAH7EUO1ZYOSPZZ6WXN4DSBZT	4
629	EXSGMP7BN4	JOUM06YN6JMXN153KALSY33QIEIPS68RN2L9HN8S4C2QT9KV8JHBOBXPVDEVYJ4AL4JUQ6W6B3YWBM6J4WQIY6DME5NDJN3UH2FY	7
629	DN5N8RS3G1	ZFCXK9VNBOIH40C2VLO16QUSSXY9DOIHITFQNVN6S9DRE6OW12VQ063JUUFXLVJWFB8LUVOA7RJ7MDNWIBIL21QLZ663Q0V7ZRLD	9
629	TRFU14BD1F	DCFNVTJX56QHSOKM83NUXVYZVUH5MI41JYF9D8HIHX49PW7MLU0Y7SKRNQ2AMNLXCZ74IKJAVFN91YJ8X4U1RG30OYVWFH63MG70	7
629	HDAKH5P9W5	DDAL0C2FKZZG3NR3UG55GPUZW4OITWV0TJU1TP1EBVD86QM4PA2AC5TXSLZ5YUVYE8XU2ZJEO13VMV3GSU3S4VYYZ6IIZ6PR9P47	8
629	FFWE8F8F46	1BZ1XVLB7L7STME0D3TJ846RAPSLMV715M1SE1HANW2VL0GTL06VLY46FI1IC9YMOFWGVVWLVS6LCKFKI99WZLQHS4N6A97N8PHF	1
649	IQ0VP7I4EQ	A70EUA21S44CQ9CACWCYPX1H0LWVTNWC9GIBJRFKYPAAS3T94N53ERYMGSNINGIEH1CK1B0UR1AAX0Y62W0FR38SS551D77RG531	7
649	HLAPWR5SVJ	JI3WLMMQYYP3RP1QCXO3T15F9QU4T3277ETN6TGQVC4GP7WRFAEIP7IRMXX42R746S6M6NTTQ7HQ7Y0B4CZSYUS96BAJ5MYDF9K6	1
649	3122J53CUB	JU2RU1SZ1UY7V9Z2OGLA6Q4MKYDIEL7N3AUS7BE2AKERMLKM9L1386F2ZPG6XJVQWKDUPG5MBT9VMMA8N1J2UEO6522R5IE0YY5C	3
649	8OI9QT5AJF	Z72PO2P6TQNPHS6A25S5GZWOOR3OJ7XR70X4QNGM8AMLPCYZI052MGBAKOB68BXV25RQ4CUPZG6GML8M3DFTB4E1YXTCLJN7M0SU	6
649	8MD6C924TO	H5GGQDGK5X9PZD56EU8001HSRDQ393W2O1WH9NV18Q39TWWGRAIGU33PYXYMXNKBBHB7RX718G2J8H95RJL8VQHV7GTLZIEUG28M	6
649	QBAUG43EX0	YZ3DRHOAURQY25NBLPV9P9KEVBZCHDGJWK2US5EI3VNZCW6N1T4MMMEYOYRPSM2RKHBRD2TQKNG4WUC8FMKYI36KFDG3NZZR26O4	6
649	2UYP83OU7H	PK8ANB9GJC3WSJGBEIRL1L9WZDVXYC0FHN0BMY516D5BMG4PTQYY7S3DKMKKQMSHMYPFTEYPN0PXP8KTIFDHNBIYTW19OUKTVYYY	7
649	M8LP7EJPJC	Z5P1ILHDFXLC0CKJK3KP0V6MZB2P5C1JV2SJXQF0BUO9P7XS9KL4OIAE9DCHS1ID6CQ8TBV3YTNFH761NKPU064N1OKUN7HJMKDN	5
649	OE7G4D95TQ	Z88YRG5546BGK4IMXM9HDGE0BP1LD363TLYLQ5JZ9S7RINDC97Y8DGNS3IXBPT1BAIX9G751DJHVJXRXMYMGE80N8FRIIHKQ05RA	7
649	44GWYVQ941	E6BB74381JG09Z0HU6BSKBAQWT5804NFR7I1KEHD6OG6KSJSUJG8PSQC5VOO95I75BICQ86PZ8V55EFEJNORYP09QF6YZ3EBGIAJ	3
649	WT1KWZC2VX	GBVM0IR6UH0QKEWQ0JQLJVLCI063UZWD64DL3E7GIC57FIOYSUP8U8AV0TEAMXL4VXUQBKXWLKCH0N6ALHLAKXT73RUJ973U0AMS	6
649	XA2SEDHKA5	8XH72WK534NWEZEMLU7DWXT0NWOQRQZBOMNUDDSAJB9XHX5IZIPQPOBKERTFI3ONFMH2LUIIC64UX6S01G1IBIV9KCPWTM2PXWR5	4
649	4UMCA9GGS5	C6EAGOSURXI93NCCFL70ISJEWZZEP6AOXKZJWI43DP2OHXZ80NSKUFHUWAORZOEUX3MTY2Q7RDW2Z57890OCOZ4RCEXW4MEZKI1O	3
649	OXSSA6KT74	GJ77U3QSP51DPS8ACG784QUF3CE87RRDTX2RQE36N9XJ5TO4GZIC3PQ0Z2DSYSV8OXT10QT7MBU52LJKYK1HJPKDGB1XBLH5NZ4I	9
649	RF62QV59AC	WEZFKZ24V8OT24N0NY9NQVYZ66A3ZRCQALBGBC8ZRIUDMDJR3E9A55SBPAIOY8FD58SQ2HYLZJ5HAUM2WT9USCVF290B3UATCQIO	6
649	EXSGMP7BN4	2YWPYLV9LB5XQ1F8VV3NNX3QXSEILETL7H34NE319FR75NN35VR5PBIE4F2GGMYGST0I7KVQ2BNHG5VJELM0XY669YAHMXVWRLPL	6
649	DN5N8RS3G1	F5V9ADNYA88USB497S4X4IIKNEEQ0Z4QJW9Q10WUSH90BX3V0XU2VY36WLW5867KESL6CNIG5JEWJSJ0LS0DFB5V3D3PE1WVKYVS	3
649	TRFU14BD1F	7TMON7LTGWDC6UQG4FCW0C9T3CEXTLV70OO8NY2ETBWQ0MHGFOPSS5V4U3VK2YA4BGMRGR3GM8DYQS3Q48RE6CO42TNTCRM5A1OT	1
649	HDAKH5P9W5	0AXVJFU27OB9FQ4H6882RZWEJD5WHYYEJQE73SW63C5ELU7BSXD2P1SANTLGK8UI07ZZL6OOMC8P4S2ZG3EUU5YS7DUJHQW5RWOO	8
649	FFWE8F8F46	HZVJZQN2DG51W9Q4AY4IH1IMEG6PD8HDO48ESK4PKZ47ZSUQFBQ7UFWPRJFST7ZE81M1AML03P8R7KXVVQKBRJTIISWJEL5M9Z87	2
661	IQ0VP7I4EQ	3P200EFHESGWT7DXYXZIETR0CVRTVSHMZQ2ASL0FNBDAPXVO2ZLCJYBK7CYFWVVWK46DEDFM6T4CPRLO9D15GFDBPRCQXVT1PQ0V	7
661	HLAPWR5SVJ	SJYU9FZ484Q0JFS4ZQE04YXAZZLACW91ZXR3CLGANHQWVZNPA709V464WY4J4Z1M5ZBVYZ2NJENXIAOAL69F69G51XHOR6FXQD16	6
661	3122J53CUB	21KEMZQRIWVJ4880VQ5TF4ASO6M8ZHEJRMTEYAUJZOTBVEW8H74X5NS8020PNR1ARL1SP3BU6V31K96JKO02NRNE4UO6KE6IWSTJ	4
661	8OI9QT5AJF	ESO5K1KT0X16RF809XA8WY4PFK1YVE2PW6F5M6DZDUD7W9298RX5TL0QY909AV8W5MJVADODUK5CU72FR20DR75KGYHMFDZRWRCK	7
661	8MD6C924TO	H94DTKJQX51HURH44E7Q8PL6B7QUNQD4RPK36A7WW4S3PFVWRW1ME412X8BW4YDH16ZEGO84GL3E6RQ6L4D0Y1ZXYSF79L281KBS	4
661	QBAUG43EX0	QPDY7G2AW5GREK9VMTAGCQYJA45T5NWQ7R5P9C0U7WBW9P4A2NO1BLM903XCLJFJJZTXPUVK2PJQOCKUA41S85PVE5YGOYJYR2NJ	9
661	2UYP83OU7H	HVH2D8VC5UYTCCQRWKOK7ST6O6EFV8WZBY2JTZ463TJKAXLV3G4R988YBLNH4PQ689SNJH76PRQOJJ61USMPEF0C0EHIMXCODMMA	2
661	M8LP7EJPJC	8LVI7BRRTP2PVXLDB22JPWFAZU2PCL765WWH0GGDIUGYO2090LBTU1ZLGVTNICPIS6U9BEM5VYA5QRV632Y1JNMD7LBFX35GF8GS	3
661	OE7G4D95TQ	18W8G75145YAWTPNX9ETQCZDGH234ZRKCYB4C2DPQMCQMEBJP2S9B91ZIS28FC6ENO87RVL45ZCE9J1BGSNCHSJC6MVTAEKOP8C7	2
661	44GWYVQ941	D13QXDM6WZ9101WY474F5BFA131PYZBG35D1TVTP6GKWW2KMX0VBI2KBW3Y4L7I7Y274Y5EINPIZ1SO9TO18DA8AUBE07ZD97M83	8
661	WT1KWZC2VX	PY1VMX3UVKEPZK7FK4Y36JW1OLYLI1OTUEDZAM0MFP90ALHOG4XSK98GCAHB9RM36U4VHHE7DLYQJ50DDJFNE6JVG6X9FZNXDG4P	5
661	XA2SEDHKA5	WG9ZZO8LR6HJE8ZM9Y9KJOKTF2O7ANDAKWQDFXPRKKYAQZB0YLDR5FHH6PU6ABKD3G9RRVGLJRA90KDP1XIZJVFFOIH0CSQJ9VHK	7
661	4UMCA9GGS5	TICE1INFIRVLFFN2V3HA3CJOQJ1B09ED3YHOFURN2AG0VO6NDRO19J6R9YYSRMOINSSQ78WAL3I35S3BMN7JVMDU20OR696QV7NC	9
661	OXSSA6KT74	QPF4NQGADVR4WFDOFXAP8YGTEEM62H8E1F672PH66TYF7XJ33BQKNW71JVZJDJI6WNDQJFW0PDSOAAWR4SD00X0EHEYGZ83XL2ST	6
661	RF62QV59AC	3TXO04KDT1I8IPUGRF9W8JFQPARK5DHSC6B9PM93QAYNQIQSIR3WT7VTOH8ZN9IPT05LOV0FFGF7U2AHU8COJV8FLRUINJQR2I30	4
661	EXSGMP7BN4	EEW0YQN1X8WG1FO74G810A6BS160YFM8K4P3PXVEVOXS8CVEBT8C58WDIUI6UWDSWX56ZURGU3FLNODQG1YEHKDLHMV4OYT9LE5K	2
661	DN5N8RS3G1	YOQC1RB3K04R20288LMUTYN9W26JGAIS3JRNHCP2CS7V1NW81BM3TZX9ARP8V1WJRLYTIP055TSA11HJG7SFXP8DWRMZXQHK6XEP	7
661	TRFU14BD1F	DZLKR8AHWHJJG2XIRWCNU60DAIOLHEEX2UDIG4GR76AJDQQYUCOBCCDG8IKITZ9RDVRVZOBWPUPY6RAU100E0DVZR6K8U77I6SGR	9
661	HDAKH5P9W5	58GA2VRXPKRIZR3841AA1E2EDBRWG1NKSW61UE7RDCBW204QEJB1GQG1FB70D4QX6GZDVBO03S7ZCGLMHBS60WEBPEVSGHOIWOZW	1
661	FFWE8F8F46	05C5L7XTQY9ZUTBMT7KBXYQQ6UVEYDYQZMQGPBPYQS8QV2VYM6CROUMCOW91LT5NASAIC57RSWUFZA4D8722AHBFAN12CXM7WVPD	8
673	IQ0VP7I4EQ	NVQ9U829GNO252O0CM3Q4IZDEP4KXTEU1KUML3QIJG39NAG47HTIWW8F5N4EERMXJ4BVICPJ6UHYOZ0EJ9MP957FMOQ88LE24F0S	9
673	HLAPWR5SVJ	UW52KMBPK1GX05EF6YO66J4VQLUQO3I9HEYNQXZS6ZBXKLHP9X8RMWDL2KL82UAQSGPVH1YI859GHGLFDER150WUBMVGM00LZVFD	8
673	3122J53CUB	WHH80SRW6DV8F5XCIV1U5T5GR5IEXQWBIKR6K3FHF8EI9HG5CIRANS9CMAQ4KM8QRT05N02OPTO7PWGKZMCO9WYZKPUJML739Y1Q	5
673	8OI9QT5AJF	LSMQCU3ECX04GF7KTR45BU7GTCEWV70402N4Z86C4UH23PGG9TPH6VQ0UF6APHSE66DO1DUUU2AQMFME68WCST7FMXKTC6WWCD57	3
673	8MD6C924TO	2O684XEU9OO22DRVQWN88BE2ASXGNOJJP2ETZDX53UMI61J2FBVQS8N0KD8L97GVEENA975M9REOY56JJ4BM231QPNJVFL65N0E1	4
673	QBAUG43EX0	J2HGJRA48BPHYCE643LN6UWYJHXVIA71F59C3GTL0WQL3OQJ19T72NRYGT6B4PV8EXC3CCDXK9WKDK441N3JQA81OK5KJRRLARHG	4
673	2UYP83OU7H	WHY65W20GV5YCJQVLSDZKO1H2O2SLJWDYSEGENUNGBHZAWHHA0Z9DRCIPRDR4KP7819TFKQ780SIGBGGHURVUWAHQ61XKDT5WK1I	6
673	M8LP7EJPJC	XC0J1BN83BNL6JJ23NL12DIT3X5HXW5K8UUS1L2VWJW4NMN3JD27PQ3T3HQDGGLHFDMMZ1BRU0ESROFQJC7T385R0AYT5YPQ8OZK	9
673	OE7G4D95TQ	BDSBLMYLLCPB93EI1NHH5WZDSW6KYUCZ5RI8PRSVGFP8IR54LIGARCEPNPTYQOX090GRVF3J5VBZG14A0B8QNBH3N3VA73E2RY8S	3
673	44GWYVQ941	NJGO7F5BOIWUT8PPHM7TME1T3LCRIIS2MYM22BQ6L29V8PO5ZMJLA88JSWUVDO2F03H4VXXF6BHUFFVN7G268G1NZDKFQ437935E	2
673	WT1KWZC2VX	TJBZDP90OEMBGY6V6HTB4FSNRYBIKULKQGN70G402WL97EKG6LDVLCNO0YION1P32BUAK85ZM3JH4TPMO5L9RZ8N29GC8PNBGRG5	5
673	XA2SEDHKA5	J58POJS3FTGI5ARQQMCDHHL2217PIAMMT3FANTCQQUXP93DP5U0EE2LBUFXXLCUEH4YB4RD6JVWXU528XSUXKHI0RDQH6PFN9SIF	2
673	4UMCA9GGS5	BUOR45SGYRYNY93S649V8U1A693QJYCXW4W7FGPMZU3W23IQL4CXIUGR3NV5BC69OB04M6M0PW5N1EIC0MEOVPOCXFD1UULXX3H0	1
673	OXSSA6KT74	OEPSLIWY3ZYFTEY8SO9XXGH2VF4LIZ77R9MIY6KH2O3PPWBQWZFPIDPH7X6GNKPE11XU2PJWE25JM1M8DNZTUSYOTELB9D3R8ZXX	9
673	RF62QV59AC	RYGPSLPIF4FK8C9U6UJCIAXEHXA9NLXDZ8WZSDBHIGOJG0AA36CEOU0RACH4KQ44HBV9QKC2SB4CVO7RX9FQJSZEIEYP6G61LUCE	2
673	EXSGMP7BN4	AUS4JWN0Y5WE0HLLOUYMR1MVW6MEC0BM3MWPWV96MNUJCLF8VQ79N1XJI7INJIY74KLOV5Y2V1AEHCTL0NTV3B8CYMHZNWWDYWP1	1
673	DN5N8RS3G1	0M01EOW0TCFN7W6ZCD2MI0JY9O9E7PUX2KAA24YXMLEJCMQ90OVSWP1ADC10OR3DSRVWW56IPEA7V9VX89NS3BAMT970C8J4RB1U	7
673	TRFU14BD1F	3N5SNDSP3PDQE1PDLJQQICX7FFQ5FQTIA6EWSAQ7S70T3K7H30G1KES107MHWXJN55PHW3VK3T8KMDE5HJBOJ276ON5UYIK4YMX8	8
673	HDAKH5P9W5	0UAF581GHOW3R9NW4ED8S3J7AWUIDWAQG9RZAJN4F0H9J0GJ7I3IT9M6KDEJNTCUOGXRSXVU0J22WKYKPLK4216GXUP7FEQWXWVC	1
673	FFWE8F8F46	Z1JXISKHTKAP44CII2WJR37IYPW3FF9ZVGZUAGTJV8EJPSKKNNO483V63B926RCOLK3XESIBIMXTZX3FFLP10F02U309H1NE6Z8E	7
678	IQ0VP7I4EQ	XF5FMWWFCGGH3XUCKXFTBCK1I4R8TX9YYRSFTWOTDXSWT1ND3CWC3UXU5E7SFXVPHSTMFOSXIWQOUXHRQNFRA65E47KPZ6NQBCPB	3
678	HLAPWR5SVJ	B7OT83GEIAH6PB1SEOKXOSIDD8MI9MRIGIPQ07CDY9V7DTJ5W76XFO3TZLQ9Q7E6S9ZGVL2HLH8P7K9UZRWCQ3C2P50PRDW15YPE	8
678	3122J53CUB	CJLFZM8QOWPL5K9LCPY671ZUMZIVGUI550WIL70RELBJLDV2WQ2J0I6KT029DMJ4OTPFX0AFZG1V0QJJEP8019EX4LZUE1O1CG51	6
678	8OI9QT5AJF	QF6PXUTQKUDQT5XOSDPO2KLBPA729TTUSVXKBLDOVHU1WEV61MTDQM5F34AXW0Q1AS87HMMH9A3V0UPLPBBW9PEF0RQHKP24020D	2
678	8MD6C924TO	XYOALDQTJPJPYIUZ31UO2HZ6F6TH8473LF1MXWXLXWQCG1WHHE6BFZMP9R4OUIUOSPETQHCGDJ0G1XZOKM9385YV2LNF2J1PBBU0	6
678	QBAUG43EX0	D19CZ769FYM1QEII1QW1S0F47O4RKF0D91HV91I71WWWBNMETGJU79EMVFFLDPYA8I2Z6WI9IY96DS2TCZ7E5FFAW594V64M7WY2	6
678	2UYP83OU7H	XI67KMJ9IJDMWJNRUE3D2CBXONL4W8Q3A7PQAGV36AOV5R9XQ5NS5Z3UHJT6AOMJ2JMY36QNS9H1XP16OYN1U88KE4J1XZ3RXE3V	2
678	M8LP7EJPJC	L3TOA95SB62RWSLBVZ3LBT9XZ03GZDTWG1C43MU9C2C8RKAHRQCP9KD146ZJGZ27NFL4PRHIF4IIQBFPZVYJBDW5YKA7XK2NAFUL	9
678	OE7G4D95TQ	F2AI3KEB4K30JUVAT5JTPGEQJV4B5ILQ4QU3YAI3R34AHHN0HMRJL2T9XT8IPCGV9M5391LSXPBVMEJCHE4S1CFC6UFFC9OOXIA4	3
678	44GWYVQ941	U0PA9V518XSJ6BKIY46H37PWGPXBW8DDP1WOOR2QKL87W5G8EF8OEXRXL33T83E9TP4EO54HCQ6S9R9LJY7Q9Z91J9DUXJSQG8OH	1
678	WT1KWZC2VX	BUIL1MX19X34SJJ6Y93PD5O1KT28PMAC2LIEYFINMAKLJ0F9IUS8V17GGQAHTZLWX1BHAFHS1PDCUCSUO2Z44CRANC7IEA4WYXYS	7
678	XA2SEDHKA5	79DN9GFY4VD8Q309Q2UJB38H8O0VQN6N95Q3WR45MMTR4JXHEXH5EJXEB5OUPTHQY09VM6N97Y7YKRNY0TR3FBJ0IM20CKQ2FC2E	3
678	4UMCA9GGS5	C4HJI7PL84US046CNKWQIMAEX7XIETHYJNXZJU7E3OJSIHLPT012FXB04DWKJHGPW5JMGH23MSX4CR5PWHYO1PTWM74G7X4VH45N	9
678	OXSSA6KT74	9JM78PW9HXMHHYCS1XHLXAIMW5ZYBWHVSRW8MR3A6WEKS8092DPHYBK8AALC087UP0Y0BEGK4GPA584XFZ58GA7RGX7LG0K7ZU51	3
678	RF62QV59AC	97Y6FNSVJDCFX6AD8NO3HTNG4ED6RLLDCNF1HBBXP66U5GS4J40GQ8CQURCBJVD818DK0I57M1OLX3LYVJXXVFXEKZH099N32826	1
678	EXSGMP7BN4	HDB933YT121FNPA8QMVL89AAE7MOUSZAOVOFVY2M9US7QUWUM5MVHVEHCA45QJ9JD101B4M1UJMNRDUTK2BYGE33RGDV465ZVJ3Y	8
678	DN5N8RS3G1	4SSTUA7J009PKUYIKD987K5117YOX2HJ5ZQJTFVD5U0PEFTLGRKG407UX01XMSW8TZTUEPYFR5CMUQXWNMIGSAPF26V2O81N825P	6
678	TRFU14BD1F	9H12FZ8YUAHDFJ9KQPSJO2I350TEYO1UIAOEQNNLRQI5OZIY1DRMMFHG886OF49FIW5F553CCH27TMOFS4MU6OHC3HGSQ8GXQDX2	8
678	HDAKH5P9W5	D36KPKFNJXWT15LROI3P3LXZKWDBFQQYWLOAQKREBYUUT9ZC4FC43NB1GH93GEI2G77PQKAE1YNE1DFL6BG9OW4JKX4IKY87P1NV	1
678	FFWE8F8F46	KVUE7DF969DBY6F8JNUCXE3Q23C0QYAZTJWPV4RSZJNX1HW138GN3TNF2EMEAOTI9NSOKZMO6BMO1GYUGL6RSW5A6RXRSMSKZFXN	7
693	IQ0VP7I4EQ	IRDW1Q2G9OVP17ZSCZNSRS3C46TTCYVSL683250FD46CBC0P22XPK4G0YB156IEK2CE585ZH9HPXV0A2GE0JBFIQZIF1D5I40WJ8	9
693	HLAPWR5SVJ	4R7DQQCPSE7A8Z2S4IX4XF0Z8DE8U79QC4LX3GVZFAGEH0EFQM5OWDKY1HEMME4VFR8ENFZXW8YX9VRH88SICV38TW5VBJMBFV80	8
693	3122J53CUB	A2KWH1YPXZFZ6ONVVSUX9U1JDWNVXRNX1P7GIV43FT6605F49QTCOC2PAATVNC1FLS7RQHMAX0SQY4THQTVH7LIZXSFHCJPC10VI	9
693	8OI9QT5AJF	YN2DTOXTL1FRLE4QUIAJI38BF7OLPZ7JKJ2F3DO6UFM1900EUVGSU804P08WAMEW36GCLZXQ4EYCRHBOGJ03SOYLT7ZDF26IBZ7D	5
693	8MD6C924TO	Y2580YQKXNIZTP0WKEPI5SO9TLBIQA1J85SR4510HB5UROVMFW0VS5YGO5OOWI4WV80Y6J1PMYA4W3RFZZC4KF1DHLC9QND9HI8S	6
693	QBAUG43EX0	7P64LJ343TVOJZ7G9MPHXRUG299VAWN49R1JF9868IN2RVGXF2H6SLAQ4ZCMKH3HF0O17YAAOTJOE2ZH2LPIPRMXRLOP6WW0OGW0	2
693	2UYP83OU7H	P0R2HR9CWMCA5T91V1YO1JVJUD17S98G8BMU8PI9MV59MPBDX82O8MOFEHHD0CTWO6B4HO3FTYBGOW7EBYKUGTIWWGQ0IEIKBIVP	4
693	M8LP7EJPJC	H5IEX5JKI1SJCCC29P4YOIA7D7PP1EGAS042BPTY8LNP7QFCGRC201A95LBZP3SDUR1MHJ1T5FZC4U9W1MJJCNJ00560O4IF2J4Q	7
693	OE7G4D95TQ	3470S6UC7EKLP8DTJBHHAWLMAFB7TKU0T67SMSTQYY20VO85FVTIXIYGSUZN5XSWUU1SAVH0S1SM3V0WGG170MCKI0922GVBFFGB	6
693	44GWYVQ941	Q4UO3Z6ZLN73DHY5V6ISRKJVP7MFRHXPZ90LHT7WGV6NB8Z86FTJ8TFGV885N0HEZSDERNYB9VL6N6UQINJMXOQG3T0IVBIQN2YT	8
693	WT1KWZC2VX	URTQSKMHJ2ZORWAQ5QLB6K7WPQ7M4TVHBVX5Z6FDE8U1B4DOI9RLMR9KU6ABM9N0HRN69F19LH77ZFVUNSE5BJ5TWNK25E0EV4UU	5
693	XA2SEDHKA5	HPCISAEUBUPLQX44SZ7V3JV48EGQ3M5UADFCBWSI09U34QOQ6JDFX8X74IJO3Y0ZY4LMR125GY54Y29RZ0UTI07CPII3MEPCI5EA	2
693	4UMCA9GGS5	C8EQI88D3ICI2YDDHQ76I7JT9SBJ2V3X9LX1PCA198VAGVUQL8AOHD6EZVRZ7ZKIPOIQBLYEQF7KLJNO8U74UOQ6OSC4VK4KYNU1	4
693	OXSSA6KT74	DO9K68BFW2QID1N1PXA8MBSJ3TFLXV8YVB4F8UYQO01ZVWSTQTI0U39B5ZQM20SB42XB7H258UTWK3XHBW4ENID1C2JIDLXYH053	9
693	RF62QV59AC	QWJ0M1AKM1CBILG5OYWY59E7U2W64PT74IV9UOAQDRZAHG4AR33CJFDQRMFUEDP7IFHA0GK9XFUOKD0N7WPBVRXYFESIIPMAB12B	9
693	EXSGMP7BN4	4JKS3OEUZGOW2WRXOL1RT5VYC1I3UMSLYODMES2CTEP8EVP34MXPBTP9XWQBGKAMXC7NTFT5TY8PPXUQMP8IZCJF9EYRC05IDDKB	7
693	DN5N8RS3G1	CJZ215MVAUAC9Z1L2XU32OPQB332ZLMNT2JFJP7G6T8UYPCAE6LPZH5X4J08CU6ZHWTHPWCN0N6JQ51W02Y296XL6WLAY8EMWJMC	8
693	TRFU14BD1F	5US48ZLLWH8REIJ5DZL9IK3KBY1JTWGTZ14IF7BHL9KOMTU05QTTACXV0H3J7C1AAP2NNB0FYEXIAP7SEANDDXSWDJR8E1JIIJN7	7
693	HDAKH5P9W5	GM30N56OOULJKF6YY7N6FJET1A64P90CA17YTMZ2WHYYGY4WMTUMABU7HK8M8B9P4JJSHIELHUK7UQNDGKS5POB9GAQJON3UIJ46	4
693	FFWE8F8F46	LPDOJFP0WM165FYTE9PHKLH25730ZZKVQY55OQGJWITXYNSHFBEKOZE9HLTLLYB7CFPGK3EX3GUB1UDROVVYVAH1T6XD6478GWUS	9
713	IQ0VP7I4EQ	M7M6QQIEDHXHB7ZCNMB8YWOFB08IW4F9UUBYJ1ET9WQYA546I53KTUIZTG5ZR9RIBXWR5B3VHR9BGZFF6B91A4QALMED6OC9EHWN	3
713	HLAPWR5SVJ	NBHCIDBUGT4AZ3P90HGHVFT7ZY2P968C26SA2Z21OPE3JCGVWAO9PFXHSKMTKWUJU2I3KPHAPP2GAZXWSG29S9WWILSSNJR255JR	8
713	3122J53CUB	NKH2OUANRH2WZBD3U1UFVV97YXF8AKFQG2E6VGEOVJ1DZ5YHN8KDYMJ2KKE0OCMGBLQ66HHNXGTM35H397UCAC23TMVLCNAT6UCO	4
713	8OI9QT5AJF	1LF06PR268OCK1QRKF8SWNTV6LKGAQJ32OIWPLEXKBWOGI2VTBVOD52N2T4VEL2QZVK6T4C9BLIV1EPXSYW954Z7W435QTS9JGZU	9
713	8MD6C924TO	5CZ8VN1XGWXEGCQY3U56MJYAGSR3ILUP4ZWW7AJQ7KPIG1KQBKQV4YVWNY2D58O4BHJRP412KO8C4Q3PIA2858VGDAIIIGU96UG8	5
713	QBAUG43EX0	2BHSXKPZT175M44FP9CWDOOVSUE39GJJ57Q9UPIXFQTJKN5MZ3QVEMNNXV9CGV0NSYAOO5V91PQX5FLFZ2DGZYFSUCM8PFRU0G1V	4
713	2UYP83OU7H	Q74HQ4Y50SRJ4NORTX3TR4MTWTV766YO02I4J8J4QX4T4YV1CCGS7B5WVLV6I0833DTBFTIVO9D3A2Y783540GQY7VJ8MMVZYAZ1	2
713	M8LP7EJPJC	UWT4UD77BW2WX8O5ECXW4ETKKJCOOF9C72OHL9FDS059QLZNG3U7CEKPCJULBTT6XZY4UHTE7UDDJU38TYHVUBA3S8FCP4B9H8L1	6
713	OE7G4D95TQ	439JPASAGGRPV1MM8LVZ5MWCRZCSE6KJBLZ4ILFAR2L1XW3CZXJW0C1RH62Z8A6K6INKBRDWGUHDA4O4692RWXS9UIXLSQCR6B5O	3
713	44GWYVQ941	SBHTWQF4YQNR838HOXIZO0341D0RZG88AVN8V8AHNF51K3UWEJROXY42HN1S0XERRORMQ9WQWBMI4CT7TDNQZULL0U1IGSQZAOJ6	4
713	WT1KWZC2VX	IGEXA2VMV7E339XJY27CGW5IOKEUWIQ3XVK6J2Y209EWWOMS3QLWL4GVL5J0XAZNRLFIY0A5DFMGRIV97V1G64R3PZVNT8EZJ1FL	3
713	XA2SEDHKA5	E4CPPSGR9ECKK2BJTQW3M39FXMEBW70CK021Z0QLLLPUSCJFCPZKSS6L471COE4BO99T9KU29LRBNOXUD88HIPU24R628N7GQNGS	1
713	4UMCA9GGS5	ZF256KHA57PJH9PGX38PHZSN23VNKU9IERO2GLLEM19TRS1ORA2THC5AXODDY3ZK7HFZVW9MS4DQZ86KCH6K1QBBWNF2HIPSCYVJ	4
713	OXSSA6KT74	B34BQBN9PKYR3BR7PSRFDDHRHEKOUOBMW7ANBJLOYCGCQKNH8VWFEEJ8VN4L08PBJL56AD6GHCRB6FA60DQ815ISYB2XOAYZWF3F	4
713	RF62QV59AC	RG4YQ8BWHBQM7UXSQJNCMI9LI1GO1P0M5RJ7VKK7H5QAMKRQBHF6PCCJHTQZ1W52KDRPKZ7G8P5R1887J0NUJ462PA0C3VGUAXZI	8
713	EXSGMP7BN4	BFLJ97AHURIUSPAIKTQGYAK94NMIKRDJ0EIVCKK66V4SSRKGGLZEIBEB4MPVU16DN84OHOG9ITKDF2QNCGC819AYAG105YMFY1EU	6
713	DN5N8RS3G1	692FZ5Z1A5B5BTOZ8LO7FNAXQEUHEOOX6ZFHJ3BDL79LZ43E7P0P0WSS8FYVLSWWQO8MNHPEKLWIOZ7VKPJZX96KHWIEEP12KM5L	9
713	TRFU14BD1F	R10AVEP9JEJHCL6I79QRYE08K94T37B4WZ2YSYB5RK7S97CE5TNNO3INA2ZVK6GMCPVNSI0I7VANGI8N70YJTXP2RPX08PVUEVPU	3
713	HDAKH5P9W5	YVW3EQ234H14MXTH62O935DUAJRAPJU2OBJEBQPHX8XI56W1BMH3AUS2RC3581OUW9PLOPGQNHM4I5YDXZ9CB113SQW8WUJ5UCV6	5
713	FFWE8F8F46	KNWG1P3IYUWOZHI2LT4HW282I438QKGJ1XNMN6KL7U45AU6MACIS0Y3RO387W51ONMWB45PPJTKB8C2X7Q7OBXSD458T8MYC3QSX	9
714	IQ0VP7I4EQ	4SEX3JHO1TMBK9G7NM03TH975R64HIRUEZC730HNLYCLWRXMSEPD13OXTG1MNNGSC17U7IEWFMS4EXLO3TLD3N2KLPOW95A8RTI4	6
714	HLAPWR5SVJ	DPJA28PLTS55NS4BDZY9WJR4RXJLUMVPQ30DCDAPM817S1VMG6O3T5738PSEYD1H7QOT2089ZJWXSUL0C6FX715V56FXV50JHUAC	4
714	3122J53CUB	BUP7PEKIKLND1C27DJFU2Y5VLO3TNP7UJOAL0ZSWVNVU1U328LEK4RTNZ3WBK154N33NBQGO0T9PCL31VAUBLW014XW6DRL4S1G8	7
714	8OI9QT5AJF	P0SEZUKSELN94QKG3S0CBTO3JKJHF7KE5AFJC7WCPJZLI7IBBXYJP5Y5MZ4OKCMHBJE3KAD65YX23DUMCIGRIAY9MJ7NCH2M6SK9	8
714	8MD6C924TO	O0BT2N1H6CJERMC659AUERAC03Y5L5L2UUXRF7PW71PHYIU4ZQBTKOX60839Y56A0QU7YV07TNXMB2NRI4F441SG611GEQ7B5PRH	7
714	QBAUG43EX0	XGEZEA61L47UL04ZBG88OB73T2CPWRWLG3VXBF01VOV63W30DL3ISJKWIKFL7RF3IVOSEGY6QHN9PBA79MMKYN36S9P0AO4DJ1YH	2
714	2UYP83OU7H	LV6W72L5LGHKHMVF4F42R9F185BMJZXN2ZY0PX1VSBH2HP2CJ8PW3P0MQEYB08VWS4SSY4ZGOJKQ1MUSD9DLJBTM9LJL8Z4TPVKN	9
714	M8LP7EJPJC	JNOJIIUFJUEUG805KMRKFTMUOIYO0BGBGU3WYCB28HZ1F021DYFJ3C20B44AUGPIOCNVEEGHKYM83UOXP7KB66IE1CU4HBI21QND	4
714	OE7G4D95TQ	HW9S78E046QPHVX5NMR3J3CTLAJQTGMHLKIKKT87DO7FEPAPV6OE5JDNTPG6ZYGYTIE6MMV3NU0466P6A35X1IMBH405NCIPIIV5	3
714	44GWYVQ941	DCILU1LTJRXAJ652T6L6CZSVZQLLKWXLUV60WLHRAR8ND5DFMWYMK8HOUXVDP9IW4LPXAFGIZ46V1ER4NF9Y7LBVOSF9ZDBAILT2	4
714	WT1KWZC2VX	QFHQQWPCWXQF10KAUZSK3JR9GSW25MQVZP6A1IQYVT15Z38M1AYVARVGXIJ8AXGKG4QM3JIMI4ZKSWJNUJB4Y4UH30NT8SX8MRY4	4
714	XA2SEDHKA5	VTR1LMF2LYA86O1VMVMKISD6ZN0G17A8OA80TCMROPRBMVCE6MA5LUEDPVC7W9BOXBT5QBCJI453BBUDLWKO6FW465K8AP5PNDOK	1
714	4UMCA9GGS5	GX5J1WRYKCNB8WAZWRSOZ9V0EJ39QP7XJCE8OEFSFFV366B2501W55LHCEFS2SI4E016SBKRL9JTO24HHBD0YL1N075J9XZX60YG	2
714	OXSSA6KT74	FK3PJK5W13KK7K1OSG38NFVGASYKVXXDXCC0KKPA619DU9BM8JOU4H19ZXO1VVBEFHW5HBEH12CWGRVBQLMMIDJQKCAX6XPK047N	4
714	RF62QV59AC	FF6FH2BFF3IBNKJJY6C8GVEARLDN26MTIZKGPGBKHKFJ2VTNFAB74PFUA6Y6ZYNJRY2X9C4S5216P5H51ZI14OY3U0GSSFUT761E	8
714	EXSGMP7BN4	5OCGTCCYJFEZ2E9QVODA9DJ5L90HI8TDDC6LFVLLWFLUC3ZAVCMRYE41FG4TM4QKVAV0HYKAC1O32Y3SKZWFWBP9IEF80291ZA8B	2
714	DN5N8RS3G1	8262LP6ZA9QNLJXIKYUVWSDSMJK2WE2Z2LL6ZMKWSJHFYVPSMSOMOPUQZOPCEED6G1UA80T8N7DNK83042QEZQLM05GL6ISNGL87	1
714	TRFU14BD1F	OUV8Q8QMHF1UZIMY8G0PIKDTIBFPZH9A50PH4FJR4ATZP0HAFZHEHR2ERC0P2AWAF1Y82E337JVH0NDR3FK9952O8K02O3Y4NSUY	1
714	HDAKH5P9W5	JHB5OG86UND8JVX0XAK8KASNBODU04I3OPU8JEVY4RN6X4FIBE0SJ01IZX49CNFZFKT4BZRTPWD3WV0HJ5SWEZTYXLIVJVVQLY1M	3
714	FFWE8F8F46	KGMXHDWW8VE6X0H5TUP04HZQ5J3BXR83N68YG97W7BY0EYW5NV1DLWQDR617KV9QWKS01SZUX233S9LGW7XB05R1Q5HKH9MLCID3	2
742	IQ0VP7I4EQ	5E46HQT3XVSUVKM870131K6LOMXQR0K5RA122FSP883JZZWY9NERMAOUITR52CL6LWCUTUF1IL42RWWZZ8QEV2TQVGUJYWW5W68C	6
742	HLAPWR5SVJ	BFPHMJBGWDW72F4WHKSDV9N96DVY8FUXTCX3B6ISSK9C8M6R2JPWP9BC1PLJYMIQS8NZRBULB9VL9KBUHE6Y08HUAVBVU94FCTU9	9
742	3122J53CUB	G91YEUPO0CRO1CUQTZU13Z6990CFPIQ0CVBEF9WN1FKSTH37KZS39HFRC1ZNSK8RW1LFBPLTDGAXOOQ26F40ZX04QUCNKI5QG252	8
742	8OI9QT5AJF	Y65O9Z2HRCYK6RNPI18ARYQM7J5LTQWSX7II9L077W8SOCO1SB8A61N9PSQ04RYAPFX8JEP6BBC408844E2RSVV6TI3R5ADQ77CI	4
742	8MD6C924TO	PROVB95YSJQUW50ZGS4T0OAL8BA7W626ZOPWO6QV0HA9M7IFM01PHZZARDWA97BWRT4HPEKKBI3TNB8B24V5FMYAZOFLJQW2FOS3	1
742	QBAUG43EX0	BZIPQO96GWPFUHEMFQE54RA89AUWAN8TE91FMQZ8ZET2ZFZJRQ98N8ITZJQP3M52X6AVP9AZ1FF08IJ3LLEUNAFG0IPC9JFMI0E3	2
742	2UYP83OU7H	D3SPKHH2SVQAWERIKPX034HT8ZRA2RHEQYIRWED38NIX9BNFXE7LRCLIW9RUZG9ANMT85AWFM42PVUT6MMNYT6WNM95WXSD1NIJW	5
742	M8LP7EJPJC	PJXS28XK6WBPVIN3LQRZFV6E9S30ABNL7N6DZF179DQM3HBK07C116M3NSTJF6J4J0SHLJDGZU0CFTK1QS9D9VTABCZHVR1C3VDD	7
742	OE7G4D95TQ	49Q35CHGJX3I13X7G4XGRFIU6UH3XIUQHCWTTJETM32O694YEFX1P6HY067L5OSBDMAZGDN70E4YN3X70SYSU2BK472WM3Y8L0KT	9
742	44GWYVQ941	ERA10BKCTK7J9UMZAQLL04JL1U6Q5NWSD9VBX1410HLW5NMILILK9IHJIYAFE4GFYOF98LBIWTUTTWQOHYEXCMT42M291YX6AF8R	2
742	WT1KWZC2VX	MKAHCYPYY0WIW7QZTDM4KHWSCR76XSNX9G4OEP9XDGDVG0F0HHRBWW7FXSEU1TBFN8JPCBVDDY1EDALMMGZQALBNIZ0VLP6UF8II	5
742	XA2SEDHKA5	ZXFWN8742BXG2HU3VEB66HNL92Y2G8F1D5XTU3XNESPYCPSIM0U3HLUSK3WUJEX456C7TBJ1RY2N1YIUKQQQOMU2KFI0HCD94V2G	4
742	4UMCA9GGS5	UYKR3LSSG1VUCK3YHPTLJXO2TTOU3TF6CHZ1F9VBBJDOWFF1JKWGJ4D7KS8J67ZXVZS5VCTI4SK9U9GNOWLS68XHD1RXBLEDUP27	6
742	OXSSA6KT74	JGH1OM1UDNKMU5JWH0XCL13V6HSNGPEHI0EQD0SW6WAOGKQQ4RNYF5LSNW5H3NOYIDD303SQIAGY1OOV0CSYCPBNPWCR5K3SILGC	2
742	RF62QV59AC	W0B86QEYW09HKQ14ZV2BZOE0AU7HXPPHMNELR0F97Y25DKV4BYT0NBRIVK8MS7BHL156MPN9Q3EBVIW09CG95Z3K650G23Q9XVTM	4
742	EXSGMP7BN4	ZSWLUJU6QWNXHMP1CLW7U9QZGGXMENAYKKKUUXLPIOPIMSUQBIVJ7O5ZC6ENWI2CWYN7C5HOAGYFTHMYWGK52016OUSXT73AWNWY	2
742	DN5N8RS3G1	WNGBGJ1ZZF4UQ0P76K56QSSMT4CNYTGVXSA3E4VR9HZPYDDGNCZC01YD53SLGNAF8I670W2CYN6J3DYQ15AW3E45368LLKLWGTQP	2
742	TRFU14BD1F	GQ0JXON5PK2EBUKNOL4OBD4YR0OCKDJWJJVPJMGZRAOVFHKZAI1HVAFCWC27AKUMAF4295EBFF7AYISKQYCCLBAIES3GUJZGQCUA	4
742	HDAKH5P9W5	R0FDZCQDFNNURQLHRA9FWYQB7R5P0TWXS88879V9TE8EPWC2N99BV4Z3JDFIGANV10BTSMKSOAVRZMVLODB1UUCXIEZ33N2S0NNZ	6
742	FFWE8F8F46	TKBYQWVJHE6R43D9WAGXOLNXQYBHC1L96053ACE8QOAA2L9TZTDNGBGH6OH2VNGQ27VD8K8U6IHAKN4EZSSTX824UX6W5LNDHUH5	7
765	IQ0VP7I4EQ	5VOVTR84F6TTCCC4W34E0SKOLZU4D20F9O37E7DR49O0MD2JKJU0M09NKAJ46D1NGNUXJF0YZNK1DUBI6LU4H92IPQWDYJU0IBU8	5
765	HLAPWR5SVJ	EAES5B9QIJ08B7VT7FGVMI2SWAP2TSC9DZ1LPLL831GG6EWL8HL5NNG5HV65VG70H05LGKDW4I1UCWWSNE4MHGV0T6D3OQMW4Q9G	3
765	3122J53CUB	LFYDZBFVV3V9ORRMUSAFE2KGKHN6E0VWQIC9GJREPE7CS4A95KJ79BES5R3RYJQ4I8TFOSFLA5Z94HXPGOA4QXXPDUDZPAQGYD3U	3
765	8OI9QT5AJF	5UNE86DLFYX3NLJIWOULEC4OQ5APSL1NDFL3XZR0UD85Q5CYG7BYJIG308XD5X336JZIAPU7631BD87V2MIVJCE49SDYBO56KF9G	2
765	8MD6C924TO	4Y0ME1PRFZ2BCKTOHT3E5JSM55S851890P8XRIFKZN42LX8DLRCVFCKVGOQJJQWN02KWL669OTPROZBI6OXNYN4YFNRD15BI1QCS	4
765	QBAUG43EX0	M1OUDGWW2GRMIM53IZN8WR8P3HSRH08XS5UWI3VGIBMG90TTFPS0YT043915YEPCH44M1IUPDG0UF1PCX9L2HH88E03IB0SDWJ9F	9
765	2UYP83OU7H	G174DXS3GZBUYHZ2X5955HBPMNNYW762JFRHO8DUQF8B2YNS3L9N9JB8ZSR0K3GI2IKT0RNZ2PPZJAXXA45K8S29ETR6QMJW80IT	4
765	M8LP7EJPJC	32L8KUU4LZZ440P75JKQKOHARIPF21S2EJGCUMY7HF232BVW3ZCR7CDPVLQBFPBUH60VTNNSVMIEVNIPX2LDYB4BF1QJ6X22DIW5	3
765	OE7G4D95TQ	ACPLT5V383HDBOMD85FCZP26EW8TQBN1MEWZ51EFJHG8JG4JQZFNQ3VUKTH67BN7PQ061WHG0A2SJ4X82ZD15AKTTBPMUHHH3IS2	4
765	44GWYVQ941	7R3R9WQADLQ5JEI7WCPGGNZH4WT2UYAM5S4HKJ6O4TQ09RKD9JHGCWJU2WWMCXPOKEA1KBXMGBLX78INLQ3LR4JJIJPXWTLHEBP5	5
765	WT1KWZC2VX	T27W49AKWX3OJBW3E7P41SAVA0W0ES5SM62X5YW4I8WVVJNSYN9DAAZA1MVENKFD1KBMI97PLVW26OA0MDC0T2SMH15TDSR83S4L	2
765	XA2SEDHKA5	BJYQU2OO7EMM51JHOU91ZFRDNM2DX8NUYSL3NK89D7KXSHI0H0P84TS62VCI9L0802XMQP4EW9X153VGEB67TP0EAPB2HZ92HL70	6
765	4UMCA9GGS5	5K16LM461B8A6E8O3OKBSLBOB66A4UT64VI1EBID5IINC2KVBNN7WYBUIN4OQ4BHSCFK6GK2FHFJDXLJVK8RGVJFUYS1G4WBHB59	6
765	OXSSA6KT74	9Z4DV2OS2QVBU2F5UA62A0IYSVLUEBC1MWWVENV35W2H60VBRFXA9GWIRGU9R3O0O3Z8GT1GPD7N8A12AJD8OB2FANE82WMBIB2D	1
765	RF62QV59AC	X57OQV5JIKQO18H0PLMBT73P3O215F6HY1MOFU7Q651DYTAXEL2ZPBQZBSVC2EODNIZAW2U5O6FYGZ0JNFWTNH2XLXMW94Y1RY0P	8
765	EXSGMP7BN4	ABL06LT52TM2LZXS4ZFQCY8Q86UIOGR9KQMDK2Q5I1SDA4XEBJW8U91LC52A1LRVBMR5MTHBJKHKG5PEIPGETSPLZBBOAPE7K7BX	4
765	DN5N8RS3G1	21SCVZK2QFHQY2LENBT7GGLS2B4FKAJ310QXYC83ESI538LX3275S0GWQ9JT5FRP5OY7LYQKCZ2X7QY30GLSDNKBU4HY2P89B39P	3
765	TRFU14BD1F	NLFMW227TYALP2Y39MSDXNRQ1RX13VEQJSM5GFQVSDAFHNMWKGBQRLXA3YUEFBE7UTB6Q3W357VTNMJNEARWUX875MBRVLPR8CVX	4
765	HDAKH5P9W5	PGQTIVU0DWRPGAETRN6VDBD1EITREVK0VBY4ADLCOH1ZTCOLK7QYYCIOCYOABDWSL13FLKTOB4H6JNIC3HGGEWCT2K2LYLALVJO2	3
765	FFWE8F8F46	IAANCW35MFYQMG36POZZJMBSIZ046KA9Q3VHF3B9IYQFD4MFGOG5YD969SFN698BEYATUW0WM0QV65ONMUXREFLN4YHXXYCIZOAO	8
766	IQ0VP7I4EQ	3UUXTS8WN9DE2AMMR79NXY5OD8YXI5R5AST9C3UWN0QZES4Y06IRAAHEZGUV4KORRIEKQMJXMNA6IGKUDA6LXA59KOK6J92CL8H5	4
766	HLAPWR5SVJ	UHOWUEXAK6S59R4OC4RNE9CCNOMU8UJ9OFT2SZC5H8AS2AJR8YJE0SJVFLIG1CCZWSR38B5M1VFG8TKMF5WKLFJ557XGR6DF6K5J	5
766	3122J53CUB	PS726MENDWVB6A6Q2ORJV7BNZ55RAJYXA2ZMYRP3ER2LBFV5HYE6O98RRTDAQWN487ADKT1K9XEDFZLUK9KLF2JB4I4FOOMRE7ND	2
766	8OI9QT5AJF	RVX646054L1HS0RMCZFY9ICZW5VLX9HMIP2OXOL5SG96C75Y5FBIHPEJS8K8LPH5DP9D7DZXOJF3JGWY96PR79F2LT5YEMUD8E2X	9
766	8MD6C924TO	201PO47JL9MMV8O907EJG2NHATBZC5FN80HGYCTFHSATTMSOFDHGYN1ANUP42HHP49N51ILXO9CX13XXBXU8X9YU8G2DWYM9LUZU	9
766	QBAUG43EX0	WX71U1ZLDIT623FXI15K36UPIB0WCMHEDYPAWHDH9I58JG45GLD23KFZDRTSBCJ1BP2DNFABYXKUBVGBG4P0JOK3SZ7FXUG78E74	4
766	2UYP83OU7H	0RBKBEF9VYRLSLGWTSWE9VYI5ODRNV7YLXQNOPHKE37BP4EJALPWKZOE33PXAYW9029553IDKL9FYW2BJ4RCGLOVILTUATKQH7KX	8
766	M8LP7EJPJC	JNGCML80JQGBNOGHU3PONWTJXD1BT80LEHAQK93AP595NTWEEIWE5JQW37PJT7GKZ46GOZ6V9O9RXY5DQW7LLVQ50NWNTURRZYGS	6
766	OE7G4D95TQ	P0OLBFRK89FBM26A59DOAQACTCO7R28SNQA6S9KQ9V1ORLG2UR4ZCEW9ZM190T2GAWY619R5YXPOZWUH5WM98JPI3BGGHLZP2UO4	6
766	44GWYVQ941	KAU98APYHJD1UDEG2I0HPDZ3LYN79WEH0UUV299IATV1DOXHVJAMXXIHL1YKXRYVF5B9SSO2JRG5R7Z6AFM0V2TCMNKALZVT59WH	4
766	WT1KWZC2VX	XYC4HDGRMZNB1JRE89NL8XFINRU5WASLRTNQK5OZNV9Y68TPEP69J6O9T4R0SK4MHCTI6A3CVX8NYQLO7E1HDSBVEN7QOYGD0WQ4	4
766	XA2SEDHKA5	LTEV3OV7ALCSC2OTXIZA7DSDNY6R5XB9RAVUWWJDQYDB47M61TDO13QIBBHFSECNKCBCG36A8VUJ9QJPMAZLTXIXTNTVODULV011	9
766	4UMCA9GGS5	JZ7XCPGIGIU223SO13W4OS3KKW4AIYJYRTCL2YRHCOME93VKC746E6R05XNPUFAS95KI1HWDMO29GYKQAU8K3NTVBLPELBX6O3FD	5
766	OXSSA6KT74	MS5L1T0DRUHM6O9HZYVLZHQ1R2K16VNSG6XBC9C33RT0I1OWXZYET24FCD39I8H5HYG908E0W2RHXZT0NYDG7I9OCS88FDV5JYTT	6
766	RF62QV59AC	O5ZU8R1KXSNTDVU4A88Y17I9FUTGW79F9F82OW80HEPAVPCRAAJZV43RX0ON8UXZSHT7X2QO9IRXRIN0SCFWYJUFLQFXHV2WQZRN	8
766	EXSGMP7BN4	E3IT4ZNNG9OMX56PBBIXOWGW2GOP4H21A5OI6C3UH1FQ0LTZ5HOYI0QRXV1XL7S9HXM2RXS9HYQXQZ6RXZUW2DSJP6ULKGIKIGIC	9
766	DN5N8RS3G1	1IHZORTK2B7ZKAWM6GEFCMVDHYBQFOKQ4S5QM7NV89X5XVAFW7M9E76PXES0QDEN0Q51EFA82SGDZ0PVX53ICKM6WQ3HOXF45JEG	7
766	TRFU14BD1F	JAR6NHV02Z7Z7CUK6LPE8FYL3UEMLIQVJ5O5MLYD0G306RRUVU87ZC1EMFC3CIPUJLQCYZ7UXMN2L7PLDU11JT5GDJTHJ4AR0IQU	1
766	HDAKH5P9W5	O65WOJMY92OZ00SRYL0PJ9OG0L2M6BCR4KYX6E4JTSERERSERAC70E2PRZ5DQA27Z75QB5UTRR6057BJ3Y558F0ZRIGGI13S0G1H	6
766	FFWE8F8F46	BCWPTPJICUTXWK1F68UGF93YNL0XNAYG3X1WIPP0RRPXWTVQBN3HHBQCI7BIZV4B6N39SF6QT4YXUFB4ZJWAGR92GZNLNHA6XN1I	7
787	IQ0VP7I4EQ	W75RMXMN3RD5HTQ835POB332VCM31AGO3FCL1T33WPMHJPGXU83RM4X2EC6KLTV2LYCBQEGKBV2WQVSF6YJ3HYC8RKGYWTSC3U6V	4
787	HLAPWR5SVJ	EHP1SQ0BBMTT0NWJ2VWWDUF7SXSDZ36Z721Q3BYIL6Q8XE6F63A8J9IUBSJ47XMIP3W7WFQ07NKGDHJN1MH628P8UHOL24KXUIS3	5
787	3122J53CUB	8T0MKB6YBQ4I5CVQPQROYNP0E8DCXW5ZQ432QTR6SKS0UD61ZHE1AO4UE9HM83APUE2AJ2A68V5O5YGBBLNQREYBAIYQLF8ZJCGQ	3
787	8OI9QT5AJF	5R7GI3PTQZP3GLWPU7QP0ABDTU2WGE2SZ0F4QJIKISUTIXF4LJYEZAU5Q3XYA3ML67DQF19LYFGIPS45P8K6QX3ZFJOWVUKPFJWL	5
787	8MD6C924TO	YYTJNPT3LP882JBSQ5IEOK5NNZE50DG5TM0K1WCIJ544QY3LI7YNOHEO2G6XLXCHJCPPS1132A4SQB7Z62X2O2RLHLRU0P6V2WUN	3
787	QBAUG43EX0	N2QG5VNMW81JG0TAJ2QVDIHKGDNDI03QTQT9HWTHD8VN0LTYNVT4E2FEVGA1HKD5FKZ0HT3XIJSEX3U4TZ0XG9M1KONAV1925ZIQ	6
787	2UYP83OU7H	2R325V4JBR1VGISTQZF78P2F2CQJZJ8VEI0H75LORRJ7WPPTQJOACSYNYX93EVU1TGR7RKWVN1QQF4TNW62P47TVUNTJ5SJ67ROP	9
787	M8LP7EJPJC	RCGX3WKCHH3EWGH2E7VW6ND1MZ5STTXQDPE4W2AKJTMFZFILCD2U23BE9OKD12SYTNAHCNFM6KNMB7CHRTPP0DXKOA5IR7TRAYVM	2
787	OE7G4D95TQ	BJZ8QXSPYDBMDWHMD7QZZ2BS74916MML0CPK0RJPF40735OKLE70FWPIHHAVY1TL0ZVAG6VVYAT4CEYBQZP1PWGDXHDTRY1OLOGE	3
787	44GWYVQ941	NDOSLCFDUGCS8F9L16DTSN92CE9JFSX8T1DVAJEUBACABAST1CUSCV1ADWQGC58BSE9GCOLS2TRSK81CVQRC8F58ACRO27RFCAR7	1
787	WT1KWZC2VX	MQN1B0TDJZE4NUVN5CNIBG967Z4BMQKR3BJ9EL7PL40NMTPM61G7EY9FRQ4M5R13PXAMKVJUF77HQVTNKRFUJMMFBESXQVU4D78Y	5
787	XA2SEDHKA5	CCKSV1H12Z57QBNMGTCL5KGDVDUNCDSX54HP4BYUENIPW0ATGR6N5MX15H7RH3YYGIBW47SF4SGRC1R5DBGVHF2SGQTXEGNKZUIO	7
787	4UMCA9GGS5	OZJ91SMFGZEZBOFXDQBPTPNN5AYF62RSDGZM7WQWQMA0O7C2HXWDH8F8L5D04HJOHWW5Z30QAO9GPX97757IFOKEA1BCS01ICVS2	3
787	OXSSA6KT74	HDO7FD298SX5F28JBI3LS472X7KX0D3EGX02SLALSFCINGM729BNZQ2MFWJH3FI4ZTYSBG0ZIR3N2ZORVM41CPO05OX6B2SM6HS3	5
787	RF62QV59AC	45WILFIWPUPH2WQKR2JE8XXS4YP9QQVHV90QHT0KGDQ3HYJFBCOOJYTHHENXZIG89IW259D8B984G4KFPK7OBG76QTJDFDV77S49	1
787	EXSGMP7BN4	QJC8QMK0YAN3IHOL162K0LM0938NA6YALD9A5PV3XF1T5K65GWGVBYME7L8XO6Z2LNRFIOPLK9WUT35Z6CHO0C8W14DTQ8P1Q9HS	8
787	DN5N8RS3G1	1X1G4KCC1UEQJ0LYKCIO5OOL54MT5EUVM6FPPI526U9J8DHHECF78D7NIQKA7SGXASDNV5ICGQSLOEM2XFP28WXJ92G9754NNLJQ	9
787	TRFU14BD1F	4VI4D1RVW8EESM2DNZO54N3ZJELWE7C4522TH855FXN3C4PSBK9W5VFQ2TV8P5RY5JIZUI5P3SZGA9WOZ3U37Q9KXM1YM7PKGY82	6
787	HDAKH5P9W5	Z82OT3M58Q26GJWLY1PK7CHRHD6CPAMB43941ONWWPY581GY38S6SRYX0LGQ6JP8E0BNJ1TJO2YSOLSP6IJQRPTNFMEQH60M9Z1I	7
787	FFWE8F8F46	3OBPIS03FIO21UYA9QYHYI7WCBRCLSZUKZD3IBJ62T9D0YQMBMAICACUQOMGBXRXT4RBQ528H2OEJ46OVEB9RQRJXSM3YC5ECLT5	2
806	IQ0VP7I4EQ	P6GUCAKV7LWR8V6WSFCMHN7S8JF6KB7KBHGI4PPPGYZG0L0R8RUFQS9B8XV25NL5OMQ0OX2D0XGTX12XTY82R13SIEKG3WU3M42N	8
806	HLAPWR5SVJ	9CLZRP3MPNH57JHPTOWS8RKNVJECMH38O2TVWCAM9F21DL5NMN2QF46R27EHL1AIUIRF0V2QNJT3ZSKKN108ON2T6B3Z82BIFUH4	8
806	3122J53CUB	0W1VMC6LC2JX34UAB4GP7IY1DSVIKXFLPQWE9NBK6H3IUBE8RHDZAO5S89S4RXAPX7HNHPBY26S0OPHBNW0DUPLBUEF95H3IHOVX	8
806	8OI9QT5AJF	10BFP6E5FDS2QQ4774HWG2DKC3VDKS94TGV6Y7ETHFOAWHO08LJTOBY8X1DWLBVWDYIJ48I9ZYOBNCX5O4E8JQPSSWJ73SHGT167	9
806	8MD6C924TO	E5ACJ3ZWXVUDIHQ6WNXIZ1IYLGHQIRWFZ6K8E69W065BY3VL0J6OJZJMXL1DWJOF8OOL6S10NBS26GARU5Z8VH6AX7L3F69RSZCJ	4
806	QBAUG43EX0	JPISFAIGQQRKJT1TPT1SNY8H8VRBBKGD0CKPRQPHY4HR3S5MI8CGL1BVQBTUSGFFJOUHILB9DT4TRRNQZE3DHA18AZ9Q65YSYBHP	9
806	2UYP83OU7H	YE66DC17SE9XD4NMB8JWVGTMVCI5M4QJ7SBA7GE79BSV923BKFXD83LSVUKA46UXY0ZU3NP53LWUX8M3IHUGHMLEGTPM6DDDQ47J	1
806	M8LP7EJPJC	JH7Z1JWG14XHR2WLOQLPUNJ7D90ISD3AD099XQPDY8PY2EOLQ1COW3R589W2SNXXBWE02XY7AH0W8VF8UO11APOJIEBX3WULK1XG	9
806	OE7G4D95TQ	XT3CFNOD47M3YIEV6WVH5RYWBDOWOMG798658Y5BAFOHY3FOQZNEB8EF4GBB91YR0P4ZLIXI1THZDR7H89GZ9C5A40A1W4CIQ6QJ	9
806	44GWYVQ941	PCIBENR1OCNJ4D9V9SYT35VH5W6Q8IHAYIS78X5YNJPYWS20DWRO20FURAGSQB2G5NUVVCXLW9FTP6VN4FNM02H8C7P7RNIMRJ3J	9
806	WT1KWZC2VX	GFB8G13UWFUP3XKXQPCFWTYW03J02CGDLPXAMNUAONQ24SYZ7ZB40DKWROIMSC2T9RDN9KLC5B1JD52HFT3DBLNIEBT7EHSLU63N	4
806	XA2SEDHKA5	KZXN89YLBSVWBG8JZSXE5I80N7XTPYHCP254FZCMY6DS8LDATC5OFJTB17AALF5MLSHILED9PKP8FP2B4XAN236FI3DIZBBSA1HP	2
806	4UMCA9GGS5	4YO86843U6LE8GYFRTSVB9SB5KNJ68NIM798VP64BMX62D05MNSHZ4D5GNCVUV6WSC1BH0TCXXTYLWJ1US7TPGTS4D1INKKQPBNZ	4
806	OXSSA6KT74	ZYW4QTBKOTUDKBCXNHMTIHD8LYMNCJKIUP44LZ8XRIPUHECJH3C3BGDSUXS1GYHFJLT5HIMYIYBA1T1GWDFJHQGNMLJXGHQ3AKL5	6
806	RF62QV59AC	GC9QNVMFC1B6MFDT872FFT58ZSBII9QH5VPAG3354IJUH03BMKCMS0PXHA15UE7CK3A1ZCMFE7K7JK08Z9687DZFF13FC7K0LGJN	7
806	EXSGMP7BN4	BLJ77IVPRO6J2GVH9FGE4W8JHCGWUWDANIXXWA95E0XN76J1ZSMACJ5PNA04B845L56US7V8GLAE8UMK3P6CJC8DMHKWKF4F52CB	9
806	DN5N8RS3G1	ZI27O41J0R2XPBWB2VI73HLX8XBQ4JGSKLDGEF5HG4W0R85DIECG3DGR7E803LPRLKMD7P6X0B18VVG927IZG9YHEWI9GFN4OEOG	6
806	TRFU14BD1F	1G2HPQ2MH6M8876CZLLVF9LH7QUX6UQG9NB0QS0T647Z6BHIR1Z3DUQ14VK95EPXPF9V5FWHU1ZKBVK6IMGE5XDO6J54H0Y2PJK1	1
806	HDAKH5P9W5	WMLERIL5FZJLO1T7L22BUZVJ294D752LT4W959NO2T0TWT39F4DRSZR71BMSOH8J772UFTCLPNJB8BWIG57C1K33NZI3X49UVRWY	7
806	FFWE8F8F46	I3V22CEPQ9ZOELTJ6SXE8HQLIYUNZQRP8Q7BMJ9HYO6ZTOSSQKY88U3BNKUES009RJQXOS7XSPPUK014FB7O1SRNX5XBZ4Z8X7IJ	9
826	IQ0VP7I4EQ	5E7MBQSEJ1XSZ9R3LI92CAS467Y0R6NSS6J69CZC8IOEAS95HEMYIQ45VDPD11XMOFA3ZU4JS734WO4O83TMUYJBBOL6WWKGVBZ5	5
826	HLAPWR5SVJ	FFXKCGKXAJGIBF8IK2Z581KJ8W6XXIUY862X5CRS9OAFEXVQM8LI9ATO5OMPJX91YRKFMKNHKH5U0EELBPKZ7MY8NO2R0BIMOJRW	4
826	3122J53CUB	QEBVD72E9X0JBO3MK4L2L17S5RJ8TFRXR8VKID4O63N1CHZXO9DOF3BYGTZVY3V3FD2D2SEG976ROGPX2VTUBDRX67EYOIZDIUV9	4
826	8OI9QT5AJF	W4546OI7UKAEB3CJA1CVEG5OP21H3I3UQHF0YZFYIZMXEUMOW3I2TNLP9RPEXBELQPX4YMVLWNNO4HK4QNU9ABBD601GKABHVAHY	9
826	8MD6C924TO	S0KH6FFA6U1GUXKQEKOOU77UOAWMG23AV77WJ2D55D9F9AZM10Q02KNU2026T24E11UW0XHMHSSQ71VOLJVPMDILUM3T9HMDJ5OH	4
826	QBAUG43EX0	DWDTETJ26WBEOUKHO2XTJCN3XM9GPHCNN8IWR6HU8TY02OVWC54D0YGBJK51TCMYUX1PMXZRUDU0NXAJ1METN9WZ2HNHBPA5GAFF	6
826	2UYP83OU7H	FKOGMSXDQXWKW9G83KVBBXFKSQECZTNR5VWCZNAQ8WLT06OQ46MZUDVREDY5OVN6KFPANEIQKECPMWUVBYI2GY619E7VYEBNIOJV	5
826	M8LP7EJPJC	OCZY6OPBGFSTC40NV0WIXAIGX1FDZH7M8DXVSEKJQZ39PCWKL9WYWM3N4SAFJML8IFV9GE4RQN18HJ0VF51ZUI0WJK19DEAEN40K	5
826	OE7G4D95TQ	XEHFFIJU5GU2PANVWO9P8Z6M5NLNXUMSQER1UUOAQBOEGHXEWT1Q14R7I4K1766L4CLLSWBB9997L1GX0G0E251VWTTZKWCTECKE	9
826	44GWYVQ941	LW9SZQ15UWQYWB0F2S8KZZ8DL1M6P2IRB1OU1WDO9ZB7CBYVMNMUL3GWX5G8E5P1N8W5WGOFPTL9YAAJC1UBQYFIU265PEKEJJTE	4
826	WT1KWZC2VX	28G9GE1SG7W575MKOLZ2OK4JS0LJHZOR64K3OCJTNZO4KASI73584LASE7RQ3SLQTF9CVT6LBGOY698RHCLN3QWU32YRV3Z5O7LE	1
826	XA2SEDHKA5	PWO6U6Y7MWF89I0H7WDSOJ34P0IQTK8Y3Q1Q6RJT8WRFTSWU8XRKHWWG3TR4YHNCXRESRKKQNUT11XL6EXS52YQH3VWN9P51JPSC	4
826	4UMCA9GGS5	DDXMB6XC4OFIUZAZSJ9A7Y6Y7Q8Z2SMEJSAU4S113E8GRFPZ4B0FTBQOH9PU88JLBA8BYP59RIH20ZH2BI412HVHCWN4DH254WEQ	2
826	OXSSA6KT74	NAOG1XL4YYR2WTZDST4P19CCA5KPM7DU0WYIQVATKNN85CQYC1MDJAON8MF5N5S0V6BA5RX6TLEOVDG8OWNUUALZHKJDPFFO5XN9	1
826	RF62QV59AC	Q3UDPT86A14FHQ0S7FVVL2UHTRNFZT80H7732QFQM3HSP8IYP67S1NZYINU8F2GR3D8KS70QAFIRUB2VIZ03VQ83HJUP6GKUX0ZL	9
826	EXSGMP7BN4	7GRGRRWEHEGU80QCM5NFECJMKT44Y44MQVKSIXD8LZAFO47Q3RK4LG556E57X2PMJ3DNP83Z1O3PBE8QVOBGT9AK0PWD2GLTJX5U	7
826	DN5N8RS3G1	UA5YVD7NQ32GOLJ0I3K33X9MZ7VDJFNINZBNGS86D6KV37N4B3A4V167BT9YR3EKPT2YK6U04NZ7NNS1T1BQFTXW3ELWSKPJ29GK	2
826	TRFU14BD1F	YUFIK9HB9TXAHE02XE65G5FU7HU8PENHIX5H5H5TQV3UXWLFYRE4KO82OVLCOIV4GQ2TIS6QJMPUCU6L6OJ8AS74ZC2K52EH99NH	8
826	HDAKH5P9W5	17FVYU78N03ZAGA9X4YT84F0VVRHIVCHZRERDML795LM9V4WEIMEZY561P9CD002XWATBS5LS1TCT31A05C9J7RAVIZYMI4JETYM	6
826	FFWE8F8F46	LUVNAW8E3N8Y8MHX0SZE9832G8J7J89EOPOKRWILT62419N6WWNA9HVN13GCMB44O4KT77GDKNVCF8BGUNKXU8EG4BTYQF8RB7Q7	7
827	IQ0VP7I4EQ	48ZQJ0VWSH219S90HKPZDZ6NSXEOEBISDQ0OVHKHTUL406RX914XAIWFCL8WVGSR9KYS2UEA9HFTNBWVGRPMGVR54UMKIYWNC35P	2
827	HLAPWR5SVJ	85PW4X2DD1AYMQE0FLO33YHH41LV2RUGHNHVA0L7Y113MV6HRW6SRWOKYH2DMHLWG3R8IS0O9QFB6N5I5DDFUBZU97738IVRQFWT	2
827	3122J53CUB	7895STARNNKMTIIDFBFD69LV7Q05YU11ME7FEJCSZDVUWQOAMNLDRPI8XN8B3E22VT9PKD859WO2N08QCZTKJYJ658R0LAZUL39D	5
827	8OI9QT5AJF	9ZJOQD4BPV7PR9DVST7JCTMVHT973RT159CAJ52VP5QNUL4BV92JC3OPNXG6E6H8BFUS6DLX0L4HD9B6Z7L4YKZBVXWWY6QSYRLO	7
827	8MD6C924TO	MESXFT08HMOVKHGUNJ1QS6IQZ845MSVXXFN23HT19DOLIAOYK7LIU8IP6B7GY5VY008E4N1FZ9ROS7HZUFUPHNCZ7762JNCERZUR	1
827	QBAUG43EX0	J47FFSVQ3783IWSKFRNYJH6Q96M7N62MZWKLXJB4RIDA88B0T3LIH33C7QGJFXD6FVEVLHX6PSHAD6SB5WNTVTF63HNGC2Z3EG4M	8
827	2UYP83OU7H	PPMGP3YW28A8FOTKULVQH2D3Q3W3N67BGGPHBNF0RKBIMI7OFSU4J5WXLSZWG4I5B9188MJHG59704RI6IY4MC2KU25SXTTWBGHN	5
827	M8LP7EJPJC	8Q2JNYO6Y6QBR08GNT9GQOGQ0TWLM6UXD1715V9NNO55PRG3VQYWHGAUKMS3BDU2M27Z2GK1UW2CSKBJM3Z5H7Q61NRTDFLK4CSW	6
827	OE7G4D95TQ	QAOG6CVN8C9LJRINYUOMA8PY1YOKSHP1OY63LZL44S3LSI3YD7FSEKTSV0OHYK50WH6UVOC9JTRRFDGT40HUB7XDFNHVKDGUXCYK	3
827	44GWYVQ941	JDY5GJU3BMRU5N7DKYZT3PHHQYFN64CP5HVXSZ4YDKDBZAO0JRMN81S45QORDH6HJCYX2KUV4BQSLGSPKODPSZQEZ01BKNU5O61W	4
827	WT1KWZC2VX	17970T7K9SZ88HYDQZUWU7BSSLRRUEPO5DTRES1FS30IBDLF527GHA136QOPCQZ4CLC4YH887OD1H2QO9LV2GIH5MZUYDMDCE5G0	1
827	XA2SEDHKA5	RQX39I26AWD99Q057X3DHS8XK4VLBXLW0OS578HAP8MDRYD5MHGHMX29RASEWQ5NKQJV7578Q3YJG5FV0094QDKCVTN6PDN8C82A	4
827	4UMCA9GGS5	S7QJI1T9T2W57N6RB6HGGAOSBSMPZHHCFGI2SUIL0DC00BS0QQACV3JST8IZODJMVUZ0EE8RY5PC7Y19AW9IGEQL70JULT7X4ZEG	3
827	OXSSA6KT74	1VLSTN0OGU4GJZ1DAGRDO3O5OFF82IIUVXIBX0W0070FONC3FT3TWC78GQDOI2V8MJVVQ0QJT0NQCIQACL2IOY7T0K4HWIS8L23F	8
827	RF62QV59AC	RNPDTA6ZQ589DM79NTXLC5G5IWLIPFKOLHU8MF4YB4JO6IT6U88JF30WGU47ZYKKVTX519WIY9KHV18ADOXQHAIRQ812K78MU83N	6
827	EXSGMP7BN4	XEVL0UGTSBOV33KB3DUKGO3H371A8XW7VQPKBERQC887NHQDYK05JCNJLOR22FV4OQ9NOA9YWDIIQ54WRXLX71YTCG8XWYX6MDS6	2
827	DN5N8RS3G1	DZYLBIF4F2PU5LE387W2QKIBMC7QL5NN7PO8XM5TTZ7OTC1NSCOF6E02RX89KZSJOCWQ7GGVBDJ1N3SJKU7IRIQ3YVR9N6I4GX9Q	5
827	TRFU14BD1F	LQM62E259OXFYY01J2GV31LYGIE5PUZ4B39DUMYEY8YH44YIRC6534WTEYZU96POZ2D5YWH7DC75CE3LT5OMY3AGGQ96WDE1SKRB	7
827	HDAKH5P9W5	3U4581171QA4NBDSD0526YIXKLA7GN2W2UZLTRZCJJP98BICAIOTWJ4EMHUX131OXOC3L29VB2TXJIZJD7678J9S0V9M6CKPSBMU	9
827	FFWE8F8F46	P0II3S30H4ESLT363QOOTC02XZ8SDFI6FKYGXZF0F2T043VSQSYU7FPMAPUDTLWBWINB5XIEKXJ1T973DPBUQX895MGHEBH4FRDW	5
844	IQ0VP7I4EQ	UX3JUKJ5X2AS1ADJCV9JNGSQBAJQOVC6LNT2IK6NZEHTFZNBDUC6ENDNFMITA2RB0EGNQLB1YVUJ88KLXIN4TG17JFW5BMN6WF3B	5
844	HLAPWR5SVJ	9U1TLHT24PGB761OXSUNJEKYF0LIXW3FJ2YYWKH8IEP0Q3EQVR9WJYJ4JCNV6KFHWA2FID2MKVEEYUIMW4XGWG6VS3OT6WC79HEP	1
844	3122J53CUB	8IRYXMXTFGZ4B9BX9VQEHXOZJPXTHFQQ2LXWFR83IBNWZY5XAKAWYL3K32PIYDMA0JCZLPRRWW6FK2AVTAT6E42RRM2MC0FFZM6P	6
844	8OI9QT5AJF	FMV2S9BPYAB23YYUP56QVI8WFP5Q0Q75U9NX7EW40B3M0UICRUKRA8A7N8XDEVYHDFI4KAWKJB0TPW5UG38GGQ5V8QJ8RS0ENVIV	4
844	8MD6C924TO	O2R79H8IRR1DC6KWSBWKW530X20LVF4NKI2BRIGI6NR9S5PWPR5TWKZS80KGRWWLXN23DJFJ4OOJO4I2ND6EJL1ATJC08A1J1FME	1
844	QBAUG43EX0	VTGMVYH5PEESR3N0SBLW2K3GOL4WESIRDZ1U01XWTEDF8IQHOSIEARKLZ97K3V166WO2B3A0NZDXGYIG5XIVJDRVOQ403N28NGIL	8
844	2UYP83OU7H	XGVSS0LOXEB01PGMFX2E2OU8J6A6EK9P6NHRXD1NGH1L3AC8WVHTPGAIVWIV0OJMFV3OHYYC5P8VXJFJ4BJTDQ90M96A4FW17PGH	2
844	M8LP7EJPJC	Y186FXAIOVLR91YF0IZVDBI2XHZ2GYID7CFKLW729R7NUT5O8WGGRVDWTFI78HB0NIT6VO3EK6WVD4HELK4TRCVM9S0FNA31QHAL	9
844	OE7G4D95TQ	93T3C5U8RTY7EWXNSILWH6CXX0KC4F646EMRK0PGBNR9BIJNGO79YY2C05FLUREMX4B9JFC12EV4PDVPR66QH6FHMK1PVDWTIEMH	2
844	44GWYVQ941	JEBMGGUD7WXJZ4XVXF0Y3W8NXGZRBVK0OJH24EA0VEPXEF6I98V9WTMWGXYARCBMM65QW50TEACZHKJSJQSDALE56VWHPAJTCDLI	3
844	WT1KWZC2VX	PWDHB4WQWO5OG0AT7LA1ATBJTDE0TXE8AI44P68QSOJG02JJI9E1LQJ5U4X70569J6N86FEBNTJVK4S144RUSNXU88JUJA0WSJ63	4
844	XA2SEDHKA5	KND4DO1HYV0M6D5NMR6J3975U2M3WDB7YMTQOZO96NKMTIN74JF1AUWLPHKKC7UUU2XTTP8XC7MPYVMMPO8N7J7E0IAHOE782Z21	6
844	4UMCA9GGS5	3OPKSZCHGX4485X9HXL4T3LO1I8AOW82U1W9SDOT46TUGMQIJ9VCR6B9DBSK0C3TYBKGJYQDI19WK0IO200PA6LY0X6RUE32DA6E	1
844	OXSSA6KT74	J9VSR3Z6OZN2ERALNS20VQW18TE8HTJ3EMT1F6TCV1M8TZPW2QZRDNQ2M3U7Y1Z4PTY28JGQ9ZE4EYIJESF1320050OLMVN3CRSA	1
844	RF62QV59AC	XYTKJSOJWYYVK3GW7BW286H54EOLK2WFIJQ3WQUJMQJCZ0B1HHEQ5HB1QXQEDC83BTMBNMAQQNQRXFGDCXEDYGJBHZN8APGJSPAF	4
844	EXSGMP7BN4	9N4GX9S0UDLRMBQ74F5KL4X9BPBGG8HFAZCJJ6AH0KXVCQYNZMYKE5BF05FH8MTV6FRW9HX7EYTAHC7U1XR4K6AEY7TO13JO1BZ6	9
844	DN5N8RS3G1	BORY0GQLA8X7UPK4YK9FM8CYIGKOFJFNBVZI9FU0T2X85QHN8TC0Z0WDM3PU6BG13K680C5T0JVULD2296QVGOXK8W5G094RW5FV	6
844	TRFU14BD1F	IX5YTAPFC1JAXU9VUUOWW9DGZ20PD8P7HH0JU7WOIE64WFCP46BK087IUZ90J9BELL2P40AW8AORCITT0LUG6FHJJSY586EID2TL	4
844	HDAKH5P9W5	WUE6OM0UQFLFPA7P4HGDTGLBFYB5FOKZHGE0QKR3QY3NNZS6G3IVMH3QJD10K4OC5V8J5H9U0NX4M8XPGFYMFZM9NYRMT1SWJ1R1	7
844	FFWE8F8F46	JA94Y49U8DKQLTEFB6GJ86HZWA94BUVQ5Y7FZSQ4NPOUG6HHOQI4LS2M2JHX4FTNS4UXW8QTPL5TRWT032QUM0EN5UMPL39I5BCL	4
845	IQ0VP7I4EQ	UVP9YOAWJ5F0Q4CY8A1ZG1BVBIWLXXQUHOIGAVYME0WYHY486T7ALWF3T38Q2Y9VPVTCV6YNMPVQENOMNXOE0PJVJPXHWHTP1BJV	2
845	HLAPWR5SVJ	1MA5UY6AYYGOWCEJ449M73GIQ0E5FZCD2GWLOJG1NUU0R2AFPF6GKJH8G2O3TA49WCVPQ35UYH8MIP0Y09Q9253T9XEV5NIM0VEO	2
845	3122J53CUB	VZVKMSCK400B0DUU4G0JCQ2YJZL9WWWLLREK4ZQN0IE6NUEJX25ONFEF66AWHCYIEPZJ8KZF0NS4M6KZUBM31H7GN9O7Z3FYT528	8
845	8OI9QT5AJF	5LND0XAXJ39WKBG05Q6RT5961Q6H3LQDM5Z080BT6TDFOLO298YP6QK9LRLJ1238N6JPMP1FOMUA23RPCEI5WAH5UZORO12E0F2S	1
845	8MD6C924TO	8PTGSAU5KHS95HWU7LMZO4XBJ1WTQKXA9ODZYZE9W9KR6SSUGT23Q2XE2S61NAOAUR9RE76IHMCOUFE0ICM7R3UH097F2MWVUK7O	5
845	QBAUG43EX0	APJXUVD0JUWNGSKYRS0721F90P50Q3JHZHIXDJ6HRQROK1W3L7D1HR1IJJ7E0MKPKOX8KXVHWSPLK0Z83BPS0SAIP9N3M1REFBE6	1
845	2UYP83OU7H	XTXM5FZBP8TU8LZ62Z2OPTKK154BLGIW34GS2G4NLG9B4JNQ2HNLLSYDINUAKY0JZ61EEGEV5PCJTJPSROJD27KKGCJOV4CXP0L7	5
845	M8LP7EJPJC	JLVC1Q6POU97BT6OXQ2VQ8C70ABMP328SAHCYABQN51SKQTKGI2KSLBKJXM1PU9V1BPBL30WPMIUHTXJQ0FHASPG872AYKA35F0J	1
845	OE7G4D95TQ	S9MRG4GDRDZACKZO2UIVICOB08ELOZB3NI812Z4XJCR3C9VALOCVRX2PUL0I04Z1C6W3L8VD0UMGUU81MEA9WQL0QSGR9W7ONZ1G	4
845	44GWYVQ941	1YN2946LW5AN95V4ZFWU6N21EEEX72432OVQWHWWOO4XFE90MUYUFVPO5VX5ZJO3AGUUJFHST9FSSFVAENKMDKYG9GVBT16FAAW9	5
845	WT1KWZC2VX	OQHMGBFQ75Z9X1L9B00SOVDUG82DASSSWRZ6D97JT0CL5B69UG8K6QF3NXGHJBPONHMFBO5B3R9XT1YFC2S4UIWGM6TQ3ZARLX8Y	7
845	XA2SEDHKA5	08GK6QPQRJW8BFQTV4EUG3F5PIEQSM53AQL4MTX1GZ4W6R2TT8033DS62K5YM88FN27U3WGBHNOQ9S87PU7TWC978OBBY8OI0ZJE	6
845	4UMCA9GGS5	HZ61YVQZB7KL8I1AOTK39WOVEMI8FZKJ4MI4B27RSI6R1ZZZWHMF8KUUKLWMMSTMXARVA69WV3K1073PXTL7NELT2XU0GVEAZU30	3
845	OXSSA6KT74	EZZIZUEA34NRHZ3GV8TZ73MMJQAZJCFDDGS3VZXTGT82HI86K3DWKBKKMN8JTP01YJOAG9V5K9TO4UFAREOQ8T3B5IRI0NA12HD7	8
845	RF62QV59AC	70KIHLLS6P2H82PAK2FQMF7SNF692VXQHGTNEI0IRT93YA2VU0SP8RR2214COM0K2M91JB6CB683GE4MMLOBDIR0Z0VMNY3F3YBM	1
845	EXSGMP7BN4	AMS4PNCTYWY7SZD7YHT5JCSQTZND29RDRLL96HX5PHAD6P58ZIERRR183BK0980YEVPGNEARTYPCCOUE4PNU5AVATNF4675QQL9L	9
845	DN5N8RS3G1	YUVHW72BZ6ORG6UVF3D9OWA8FVV39V0PIEF41NIC394R1NZAL4LS5MUBUWBBM9CDG9IB0Z31UBFP2SH25UREKHU6TEKEMG0371L2	2
845	TRFU14BD1F	YKWBT74GFJBPIG1R838PMRWOZPOKMSBHPYHK5C0J00O5JZDA9L87MN1GXHMDTT4XH3AU8QW5CYYWD0F9MNLATD4C6BWX0W0G51XP	7
845	HDAKH5P9W5	SCSZD4YYFC7CM1GH4DE87Y749EQ8S0MDZK3L3KPIGO08ZUO4U8BXTQ13EYZ9O0FP04NB74OTX51T79EOZVNTYZTIS9GEVQ4QILH5	2
845	FFWE8F8F46	M7ZUS9XYI6FTLJ3MW0BKET7YJ8HBLKW1JHMYX9FZ5TKDBUJGAEWUGUC39BKU1WN7JOKD6FYXULOVI3XYYAAHYBVYFTYWYV7IGM4W	3
867	IQ0VP7I4EQ	GK5P9A4FRUFOV61WGJI3W8NQC89OFP69AOR0E1YB0SX9THCYGW9CV3XI6PMAAQ9CXFOGOBROUHCDKO745KHTP3NG0J3ZOYBKSVLN	8
867	HLAPWR5SVJ	5KFFURO1T7SRREZIQW31IQFH196F2VYDUB9ACN4M9OGLKH6TLBB9RVVPE7NVVI88JP7QEYFC2R23J37TCM40TZV8QT5FAJ00QIC4	3
867	3122J53CUB	QPW58H921GL93SJOIPT389U2ACS1CNB0CJW7H5USWGYNUFG1QMI3TBLR4356YH0OFU7T6MGM4BH2KHI451K0FIHB7FDOAY3OQKI9	3
867	8OI9QT5AJF	W4EF58R3TGWVAA679J7N5W0J2MGH2MA9IWI6FUJJZHO8Q2AX7RQAKWMAD5NT2KBHGXMN2A1P9YXYH229LSKK69YWKH2JH0QPGH22	5
867	8MD6C924TO	W560ABW8Y3LCNHKA1LG8ZDUHRHJHISA9ATZXNT58CXWORG3SGOO6V30TLZI31O0F3LC4SXWHPI6CQG0KN0A3DDNG2FMXLBGX6QUF	2
867	QBAUG43EX0	9AT1HQN7XCE98PBO6CZ86BMK96NBJFAVVGOZRB5XAIECHYNWFJAN5GH7XI2LCMYSCTO1BL64GB7X7KDKS169FWZO9QCIJUVYUW9X	3
867	2UYP83OU7H	VV3MFH3ITANER2KPYMQ392UJXVWQJDKKPA7GCXAP6FPPYE11KI5JT4K3AUYTUN8Q0CYQ5ENBMB74NEUT45GBIA0V0DFR8R4TG9ZV	4
867	M8LP7EJPJC	K5F437S7PQ59EYZH7HZMDZ196D5GOXNP8ET9AHOCIYLXKR32FLJ1AJLUEG80CLS1CQAAFZGZ3WEPODYOJCBCOWPZ3843IYA6FTV3	5
867	OE7G4D95TQ	3WPET8NF6FARUQ9KQMPBLHG4NQEWHJ5S57QQV75YBU624LYHAVYGF2FWQU1C317WKSWW9TZTR190KNAB27WWUZMC14AAF35KWJSM	7
867	44GWYVQ941	CHQ6FZO2OLCTZK6FLCVFU5FTYNY5ZEA5YMZZFZO98JMS7RQS9FLH6HEGC7I2BSDKKG5MUG9VXVGKSWVH7F6U238RISXIRW8PFCH1	6
867	WT1KWZC2VX	D82F0TLA3YPLB45WTSRHNEBT1DAW1EQP4V4GEOBJXRO4H6Q2D3WU0TH97INWTYJYIARPAZREQHU6ZHM5XIT7S5ZKN5J6BP08I0VH	4
867	XA2SEDHKA5	A1NMSDS8KJZ5S9LFLGMLGCFPUDBRWY9VEQWQFV91GMCVTASPO26TJ6I8W71PCAMWKE0CN59ZGUE49T6TUVC31PMIIX3H4UZG9QLP	3
867	4UMCA9GGS5	QBT3GMY2N9DBH4Q7S442S4ZB15V585SIQKEUSAVCXQ4Y0GW0IIQWRW1WMSBK123SQ4U7Z6PSJ1EB9ALVJ5XZO604SSHA8KL4WMI5	6
867	OXSSA6KT74	ZBL37NZSZWLGQB5FDDUE0OGYOU9PJPW2QAU3M6QTAM2564RIQZSIY14K4WONOKIKAS0QRB3HXADOWK2UC09U6NEYFJ8ZSDF0DS5N	1
867	RF62QV59AC	B0O5LVXYQXU34KXKXOWNBKHCDZT5MKEOPQB9VYU1RAZVO5X3RQQDI9B0SL1WC2LFTFONJXZ8356BVVYIB0N64AGPPKQJ67ZZZTCI	5
867	EXSGMP7BN4	JT40RJNCAF6XTVMOPKS9989GPB5GHLBTP11GTFM02MPFTWMMMKJJTJRLUXLPNH5YDNH23F5J82GXS3W3YT37B2AGJPV546MVQ0BG	4
867	DN5N8RS3G1	USHOAK1C421AS04O8WKMBTOU9PBPVG21QOEAWSBRJEPW45MGSHSE13NBEWOUJLQYA9UDW41PU2D6E1ZED56OXYAWAD59DRI7Y0V5	3
867	TRFU14BD1F	IUYPDT80Q7N7JQOOBBM87CS82LDUFINF444KI9UEC5TGSC4A3SWZJ6MFBZW1QNUITHCPVDGCRH6BSMP0RC0XWX68RZJSM2YYLLWL	9
867	HDAKH5P9W5	OO0MTIC9KWZK6JOX7V6LE864X0YTI0HZE0DXAKCP38GCTIQSKBNZ094QS6Y3TT1UPAFFG1WWSQRG14KOKGIHMR8F5XEEWJ5KHWXT	1
867	FFWE8F8F46	KLTO1GJSYZYVJTNKTH7BAJTWSAJVG8EH1L94Z3VKZWH7QTMZRAXPZRCA26507YLZUR38TTU0WXMNCVF9YTDFLZRJI9B274NALRN9	7
886	IQ0VP7I4EQ	OG8Q73BFZ8G16CNUGO59TZUR121KLCUIFJJNFZO5PETB5BB19PFDRAGZVQZEB13XN8VW29PQ99TPFTWZ1AK67R0FDU2Y9K4YK6X6	5
886	HLAPWR5SVJ	P8AAYDSR1TC49MBR706HPSHH0RZF5EJ5ZJLBK6INIYMBZ4A73GNG1ZA612JHNNWWJGEZBAHBRS91GGR5Q2LY1DEAJPKRWBA5CZ1T	7
886	3122J53CUB	K528LYJ0I0ULN0UB75GCEQW00OPRDYQO8FG6SZPO5JAYZGJLP4E4VRW4JCI7J1WUJFNHUYSIQ1G4P7AUFECJTW3QTLWPQSFEXQOT	8
886	8OI9QT5AJF	B11L6N4K1OMCY1EYNAXM6YIBC18VCH9SR1DML7WI9G17KN20APJP1G6NTZJFPIHUO3V7Y1NPNONZ6K0Y8HVX7T1K403VYR309GTQ	8
886	8MD6C924TO	4CIC4CM2HQI8UGHXTX4CKD87106UX001K5EFMVCRORWJVWEKWDPSYOS1ELKDG1FQ0RYYCBL8UNX2QYMFWV8TLHD5NMBBL9KWLGSE	9
886	QBAUG43EX0	PHU2Q7K1ZLP8ERU2WFTO3L0AKXVCARJGIHGOO14J2DYAWCGSZ3ZB90EERTS3MH0IBJ07KGO4KJVZWZOHQDMG1IHSDC65JB7UMQ9N	4
886	2UYP83OU7H	IHTP41ZEOR1FKMI5UQ2CI3IKTVILBNG0B5I5306RRNZUEZ8ZZZ29GLEO9J6ISOCALBEPENB3ULU4EXF3XTWMUHTZ035U4X8DLYJD	6
886	M8LP7EJPJC	TVMX9O40KKLDDV910QDROYKRQ96MRTPOBIE8KYV2Z9QSTQ0B9LUIFVG5K4H9RSI047C4RBQC4K2OH279I4MG8HJQBJYPQWKG1ZYW	4
886	OE7G4D95TQ	6U84SO421XR6H0XFC2XXV2IMAVIAVXRELVMKOLQ3OXJVGTJ5XBY7A82DLV37F4GEGNVVOM01M3J7SXGRLNMU8TDM2J82RSXURFP2	9
886	44GWYVQ941	XQLK7VGZ5UYOMV2RWFWKI3FN8J3GYQNIOTY6BJB86X7YKNF75C4A2RZ4L7MX1AAOGQA276QMDYOU6QDUE6LVVNP644UD6NG5WSS3	4
886	WT1KWZC2VX	N98WR6EDE8542T5ZP23BD7DLMQ0RS8N8JH17M9DRK3Z5YJE4LGH0Y2JP5XJBGWUGU7UU28NPYM0KIHXCL5GM1WJR8LBZZCLYITK1	7
886	XA2SEDHKA5	TCM21BLC8HYAG0KQIP8XDWQ7YZWBCCY65N233T9V8O9EMYTLAHADMDW6VPEBOKA6S1E37QWYPMZYXMU9GKA4CVT215INP8GXOCVU	6
886	4UMCA9GGS5	0OTULYAN7II5F4DJF47ILBCIIJRFBKU09OQ6RJ06TP3W9SKDDOIIYMJYMKLBG4LWYS50OH26DAY6HPJZ9NCXCMCWF1UG7ZZZDH8Q	6
886	OXSSA6KT74	TY6WMEXYMQ6BWB21YULQIUXWV8OK82AQ2CPZGA0HO82KXELX68OXWAO9BJAN0NZTQPITVDUY3ECK2M8QW0NAON32YQX69MQBII4I	9
886	RF62QV59AC	2C3N03S8DGYLU0A9ZFCWQ5EPXYQXBCTS0U4XUXXTL3UJ8VPWQBSD1VP67NZCN57BXGU96NOBSTKXL4QCJ4H9TP0EF7ZH7VGP6SW2	1
886	EXSGMP7BN4	QZDXRUIL2VD6X2SY8RIQQ48XGE7N512IYB2FDLC4S3MMWLK2X17BNMUW0PRMX4PB34HVANUXPN7XRWA53EZE314MRGOY4ZHXNLT2	1
886	DN5N8RS3G1	Y2JGKVAO6EEPVTSFLHB94E3962ZFKJFDI1EMQ7SF38UCKJIGYSCER2JU9KKR64EX9AG4OGZNY6G6U0ZXUTR1HBVQSUNGXBI937CJ	1
886	TRFU14BD1F	N1S3YPVWMAIVW7NNMP8OZM42TZXXGCWYPUG198TVA4FUFVAD5VQRE5MB7ZK827PJNUFC0WOO6MN5HJX8YT2VWFTUHF3JYU3DP5HV	4
886	HDAKH5P9W5	8MJHCV2RR4YCMJIF3XHAV4V2F0LSKPLCBS0HSNTT1D0LFGMLV7VI9U4E1RCMJJGBSVB3TBWQDXJREJX8NA7M4CCQYWPBLHJR6Y2T	2
886	FFWE8F8F46	S1ULFELLM9R3D8JM4HPSUF7VVE6N1VPRD34IMBY81FMW7HIIAFCRMAVN48ZBH7T0UA0JDB93SR1O2KXN6YNWT8ECIRNOLX13WVC7	5
907	IQ0VP7I4EQ	8E9FI85JGUTKLETT6HV5XBWXVR4072HI068TORKAJ3B64D9THJZOQB26RLU1DFLONKUOG9FP6VW4A03RRLSYC32ZDBCC6T6DRXST	5
907	HLAPWR5SVJ	UMIEKR5O860SCJ2WXLUS4KF7CTNZSMMIK879JT2L6KFFLU3JDR4M8AYJHLB1EF6VTSIEM3NDSIVUFAVSZEVBSAKJJX28SBH1NTV3	3
907	3122J53CUB	Y7KD03ZODEH0SBAU4DTI95ZBPUQB4GVO2HAGK71GU4FTUHAAHGSQBUM3HJYGMYU7S27LA3J7MNXEZGQHUQ3XYFNH4H9BJV36KIA2	3
907	8OI9QT5AJF	Y9O7VDY7IDB3RV646JNO0Q33HX1T13RFX65RP0CBZKWD7H197BO9WOUIFUZ7MEGOW5GUZOPFGMZQ406961VZPRSJMXL4BEYUDHQB	1
907	8MD6C924TO	HKTVI2KYENPXZBVSQ8FN6IBCVECXEMWJ58YQCDHYIUIJ6GLCCCWJLYE9JQAD0XU11F21NFPN1QEM91GO39UCZN8G3ZHWDD8U9QS0	4
907	QBAUG43EX0	UZ7WJR5T29RJWK0CSBOHV8X73JYRUNTJQAIKXQQ6DXAZ0MR2HSROES2VB9292N9PPH3VBQPCVRE877HQ26JB5FF7IWIXXRDZXVKS	5
907	2UYP83OU7H	501DP3WO3YD1MG6D7TKC6NOH1OEOOKLXZ77FS8QMSSO8F5LKHW0C9PWSMULAZI9TNPCPJ1V9C8TN8QC5D3G2UJYJKP27WPWKS5UZ	8
907	M8LP7EJPJC	5BQA19B5IT5RP65BG8E12F48XMWLJ5D5NCI2023JWOB57QHT1JL6Q7A0GRMOM0WNQAENYDKOF4FOD8BHFDUATGOPBRVIPO661XO6	3
907	OE7G4D95TQ	44X871V2WXHQFJIFW4KVYLHSB917IWQUE5KJ6BVP2XO4N2JEY0F3ELWSXF689YTAHXMK89JUI42B6NFJZWJSQXP2I2W1FXPEEOXZ	5
907	44GWYVQ941	9GYRUUKSVWJAWINOBTTITBGNSPVPX6SZP3ZQVB6CFKXFM1SOB0D4DQ689K8F845YDTU3S739XRDJOAB17GN73XW961QKC0EKO8C2	2
907	WT1KWZC2VX	Z5D7DGWNXU8JHI1R74Q7V61RS77M34P8IUHKJA0QAVJHRA4SM2QDV5V2EWOFJJU2EAAXARH7E969WT9SCOAANLMN8PGXVUG1BQCR	9
907	XA2SEDHKA5	HS5VT8V8VGUW6C5IUP2XXYVKUMU3F8GRSS56FP4M1PMJVAYRLSRBJ3MS6UAGO23XADDOG8DFUP6HLMZTXCRWREHZFN9VOX88WZJS	9
907	4UMCA9GGS5	KKMPLQ37EGU4QTMLGF55OJ39R07R7VWDHXM1EHFXO1AGO07EVXPUNWRBRN7VTL9SURX3GVG8AHRXIWU0326KFCZVFLJ1JUEC1RW7	1
907	OXSSA6KT74	D8AQRTGE4353G11PZNS2BY4LPZPDP509XX0463YSTQKSO8C2NXCEEFBODZB1ECZ9C5FTB6S5YAIVOM6QWW022W5SVL1H27NQ1KQT	8
907	RF62QV59AC	S1QEHQD6Q902UFRM7HP9X8ZFLC1W24D6MYD5JYVF1VFLAOH16D4DAUEUBL2EZRDW64Q5BWDIVKHC3NE7590YAA62UT385QQKRTPG	9
907	EXSGMP7BN4	L0JAVR0MC1YG4JZ0PV57XLS3EMF36UK879TIRYOSGPS1F1BH0UC7TIKAIQ5IM6PRRZJ4ZQJ0HN1H30YNL7DMSNOYZSAB3GFJAAKP	5
907	DN5N8RS3G1	GRJKM0GRCHR1R6O3C9DLUFGQI6AHRH2PJ4FQ3CFXIHXLTJLJ1Q7BGD7BK3CQZ894PCSW189A3QCNR578U0QBJ0IF7DFA9Z7KI26Q	7
907	TRFU14BD1F	YS2Q6IZBUUP6D58R7UY4NZY29BET2FY8QI5IYUNSSEMT0D6492KHIWN949R5EGIP5QP59Z3NHGLJNEC6FJTA4Q0346OYDSOL56YJ	6
907	HDAKH5P9W5	A4J97ACKDVZ7V04WIUO0WADKEJZ19NQQ2IEPJA7QYT1KZ1S1UYXMJTBA094XLKKZFJEMVONHX8BCJ2VN17HL0EGIGDYKFKEOIBFP	6
907	FFWE8F8F46	FFFLQZLS818NR5OC99BD5FRZCBM3X4HWG0W1B9JO40IM06YP0LIBEL09YQIOMS4DTLH1JWA90WIF7F9FN7CLWGS49WDV04CM5E3O	7
932	IQ0VP7I4EQ	7FEKILRDVBSQDBPPSRM2N1XTOJ5U6J3LVQQ18BO5B1NUUFX3W7MXQVLFSU59P7GLIH5XVXQRCR1WNC8JVC797F59EKJNFOPDUCLN	3
932	HLAPWR5SVJ	AH9Q5U94Z1PWWNN9HOCM6SLODLYBYBL1V9V48SCV5FOT31TBCDNYJBNR6UNT67FXQYBW2TBYLRQ0D1UL2W9UYWRTWD7NFTZ790CF	7
932	3122J53CUB	7JTCYM1VWOEAB0J8V93GRAYVXS22S1MYOW5NQS9K089Z3ME2P9N1J9I7U8OFT9C5BPWP55SD9SQSA91KOAMTNUPPN83SD4006DYN	7
932	8OI9QT5AJF	Z6TQK20SZ6UGD1SWSRQAGB7CA9F1ZW6LOUZD3CD2Y6YCILACIENWHNUX9QQKX83C9J2TCP2POXLJN53Y9CTVIKDA9BEMW2FZDVC9	5
932	8MD6C924TO	QA2L7IUBKKEW1LUOH3YF1TAKQ3VSVF124FSC0KLCT9Y1AZ5RVK61O3179S5EWBPFSL2W2SY7SWW24IK07D7KJAOBNVCIOGPRTTJY	9
932	QBAUG43EX0	JZDW8I2G9C1HFHTEE5R70IGPPSMGEJK9V2YO3YK1W4OSLBJ96NOY11HASXHQ6VC011VMSFKQU0L54YEOINK15WH4VY5GQ45A2X1T	4
932	2UYP83OU7H	7Q0C7EBQLF4S3HSLK5FT114JEAZ4KCG7V8L6TZ7SGOJSBXWXMZS2V9YGWR86OGFI97746V1V7XNMRLIQNCSUUNLVKFKC0ADAIBSD	7
932	M8LP7EJPJC	1107658WLYLIRTMYVXVVMU0LZ46TMEP2F1VL1XXRN88Q94JR1MXN6RNHAPHB9OJHISC07A67AEINVKM5VO1ARC5XOOLMPWS8Y1HQ	7
932	OE7G4D95TQ	TT0PZN2J9VZCMQUWJZGWPMTZUROVJY3C5EC4AU1ZDNO2VJDF7MOBB4LH9B5H9GAK1WGIO0VZ8RTB71EKOIY7J2BB2549ZTZ6NEA8	1
932	44GWYVQ941	51H0ZDULKJI7U30SDB9VFPS5WAO1WX31FHTRRGUYRZRVWCE09NKCAN7PILEYY2YWQR1MJJA6QKDQ87IT5X2IN001KDIFC5AYA5EF	3
932	WT1KWZC2VX	2QZNNWZJRRLDU3BAQI00ABGB44UKOPC2DJCGC59DAR3W6CRC9YUWOOK1KXSTBP5BOT9L048UJW0SITE2MSL05QNZ9L5ONQCVW1IN	1
932	XA2SEDHKA5	GME09N2X1S1TZHTDEG7FKLO8TH3UF6RL00FFGA5DVBH3E5XISSSVKI148GG2UIS5BP29BN6DK4TJEU3XUUBXN5BS8KHA4DTNSM2Z	1
932	4UMCA9GGS5	XGFVOKPYS0NNTH9G5RFOJB1G6JHKG022EU6N5B8VV3PT4XL5TGX4WK3WP8ZFDES28UI8LWK3SU2PVHMJ8L19C7G31K77M3RQLXVJ	4
932	OXSSA6KT74	MU753LCSNAHWPH1NSZAOOGAYNRZCLE8WC4V14DJWDLOK0K6W0D27U59FUIRMV9GJBVTVVATOQNKD208CUDMILBBH5PHVV7AEEEIE	7
932	RF62QV59AC	LAZUORHU5N3KP1SX87ATLZF372SMG8XR3LICWY7U4X9CNLGFSQGHIUPV56WV84O7ZMRDSPAJAPZY0CQWWN401QII5WH0BMWAJCNA	8
932	EXSGMP7BN4	CXDP7G35052QA8UAYFIDII5IKHY3ZPYYP2T00K4KPNE1PKBNBAV7F7V415FZS9GLHDBHP4JNK8X5DE3AFL2Z41TRGY95FF2PH3UL	3
932	DN5N8RS3G1	47G0HWHJZ1WCETGHQQQTTB15NIFFHYKUR1LNV8XEMIQ7M3AVVI0ME1Z2GLN9RBBBRCUNI2WS3LHKU4TTHTU987QZBSHKUXXKGPPJ	3
932	TRFU14BD1F	XN2VHS2UOIM1317QBDTW4LZVM8GY6EFOJKUG1N0PXFWK5S16Z4EM6XOLYHJJMEXKD8SSH1ZYME8YYP03GJ8C93SW6ISUDRDTSLG7	1
932	HDAKH5P9W5	IZ8EQ91YZWIRQCCFULKP5W8IFU4APGMI228UA7S307GVJCXPAO7A6RFV1Z96E0JTJAYXDSEX3QZ7QM9C7PAAJMLLXN3L8VY9YXMI	4
932	FFWE8F8F46	9LSKKGQ2HEOZ78Z0IK7YNAZZ3ZH2ZJ3A0Y8DR08G5TQJOVAW9IQMPUA8W3RV9YC8LO9IAVIRL133TQLHYU2R3QVGX9RYJNGHRS79	6
950	IQ0VP7I4EQ	1WN98BX0HPFSJ6O5UE432VBDUH7UWMBSLV68PR4O7PQUMGAQ2M6NDG3GUJP0DDE4NWGYAQPDKP5NER1NHR2KQYPE10NFBEL3KWGZ	1
950	HLAPWR5SVJ	LQL62DXKQCCSCSWL4OZHC6KCKBGECCSLCN6AQNXU23LXLX9VZSQHQR7OGJW16SINT1QYWV5Q1EPIUW1WCUPUVK4UPR4G16YJV8ET	2
950	3122J53CUB	K8DW9QMCZ3TS9YMDY1I75JF0YZ4QFWWRHP1VL7W3RRZXKY2HLG7G5VLB3N7KV57CHCKT7010FOPOTSPA7XE9ZQWWDZ289MHWUWQI	4
950	8OI9QT5AJF	IJVPGBQG7RK77N818N0PYPH7203G346CGWYNSTTPFPGIRBC9J5VJZ3Z2CYWPIJMDVI0KYVIO4KJIJ9P1Y378IXMN76L47DH6DDWJ	3
950	8MD6C924TO	2KYWHPOTQSCI51OMO475MM1JNQ0DNFFMGQ5TJLAI84QNIVBM3UYIZN8PSOI0YLFLN0CP55CC4Z7S5OA1OOK3Q7X2SQA4CJTXYFAS	5
950	QBAUG43EX0	WQ8RVO9QPUENQLKAL4PCK7P5I9UGK30OSI27MM5TYLC55QW8JWNLUPIZBCIV42GV405ITMY996O84T91NW6YQO3CAD5JDJZ5FRBF	6
950	2UYP83OU7H	OO77OLYBJ4SDRHH5RFP73HQQP5ZHS3NR4G9H90CDEA0INGWBR9XLWH1G8QSSWRSQQAIKIA61DM22RHDJJY0TFB5WO3JTITRXSJ2M	9
950	M8LP7EJPJC	L3QD6IKP9Y1NIJ719KOFW6O1MST5FKHO0M85JQJ3UHOFRF9KT6S9NHKOOZ0NZPJZQMX6LCRTBVUORJJHTJLJ1IBTBTQUZ5DF7ZYF	5
950	OE7G4D95TQ	C8QO972W67FPT4PDA7HKD51W73GRPR1UDYQK542KJ6EWLEGAYC62Q5OHH4QF1KHPFUM5OFIFF6BH0FK3XG3NU9DIJJDAOWT8ZZR0	8
950	44GWYVQ941	KVS30XT3HQBTXRVQ35FQDVFBI1SNCRAYUANUKT3MUPB2BQ1F8S54LJZZQRV9EG00PN9WEAGKB26YTM91ANOUVGMKLXD373HNYLNY	5
950	WT1KWZC2VX	FA7LV2SNAFER4912GFJAYKQ7MMIUT9I8LJ5MQI9N37LS8LD4QVSFEX24TA9IU84B6GGUDOL7F5H1989BJNE7RC4XQA3PJ135DJV2	2
950	XA2SEDHKA5	T0CJVAJQB5VB79G36T3LTDDU5XOCLXZMG60WBY6CVGPFIOL1WBH02QVPXRN7VGFOGI4AJU1HX00NY7MRLXPJQ9UZLK9UL9ROBB99	5
950	4UMCA9GGS5	KSCJ9CB0H1ZF5V8157GYEZ9UH6YJMLX8M7BFNAQ6S9DSJPPNTXFD2LOVSRCDO2O6E028U3N5QKFFVQL2RK0YGTGASPW67NR0VHOS	6
950	OXSSA6KT74	Q3ZJKWRGJACGKWDCZ0UU2PEHR7D2OUNB2FARAO57Y3JPT0X1NY5R374AYS2MTY2ZWANEVWCK4X68GZX1JLPZY6I4L92RWSO9BT3T	4
950	RF62QV59AC	TF0WUWGB5495BDHJCAZ2S3W4VYLJ66X6EO0FYDDJB2PF3VVPG09SD04ZT6B6L6F9GC1WMBV87Q0ZOQB9D6CG6E3NUBW1BH8FXP80	8
950	EXSGMP7BN4	8DFEAVWAFLD5B3P49CCJOCLP36ZSVC8RKFE27B6SHMPZS6AOSKXN5QP62ZKD6DPDNVU6YW67GUCBXV676L9KOUW40HAH02VD7MM7	4
950	DN5N8RS3G1	EZ6O0HKONJG3NHUEEY290FRVZGN89ELJ8V2WD6XNLPN74ONVB82XT8V8HKZT3LPI8642O8AIBPXK2T1K327ALX0A94O2HET9AE97	5
950	TRFU14BD1F	VGC8UWEKLGXTOZBOO7KG32UTIB65YKYU31IV5C1BVZYY0J3OSVVHY1Z2WSZTZIWASDZWRQSMFIUEE638IRNCYQ6BBQ8MMHMMCXFX	5
950	HDAKH5P9W5	G7BCJBPGVY0Z1LI5UMBHYVBRGA86HBQ0GOBTLAOPQ5Q1IXV6DRSKEP5U6U5JDS8UHATMJYTT7V02FJJTOB20SFV0TRX1EFM766UI	2
950	FFWE8F8F46	IXP89NSYCPXLM4B0IBBO221A2P1J36JZAPFON1T2DBQBAQ1LKHY4S4LP5PGTVJ5GG8K7YXNQRJL1M09LXQ8WIOGGD0S7V9H3FJ5C	2
951	IQ0VP7I4EQ	4WX4HMJSUDFP46EKJ811D38EP4RBRVC47F34L1AB6XTWNS1DCT6LDKCAYSPM4IB8AKRYDK8R704PKL16DO88Y11WD2F3MXGYWUVD	1
951	HLAPWR5SVJ	DA2UONNQX0M1SJQJDJJT5VKEFFJTG2ZZX59OGNJNNGPC3B4O0PSKMTFSZYOJE3K4AWDWKCDZA6FZFHKEL530JOND0RYS99JU6UBH	9
951	3122J53CUB	HEXM3KQOQMSNK8IATUWI962OV0AXV3UGDGD1FOQD7ZKFGEZBAUM9P88KLJ0CK32X1LJD5R4EESLJWXHQB9WBQV0FH3P6XN2E6XN4	8
951	8OI9QT5AJF	VFSZH56WYYYBKBLG1GGVE6BC7R0ZHN9JNVQ3ELIZ3STE14NMR7FQHI0YEQ20EGPLZOXZVSCP8Q1WN6KCDOIJHSCF41YXTRUWCHPM	2
951	8MD6C924TO	X1850S0RELHFZX07FEGLS533O6Q5ETFR76PXKORALXZPRR444Z6DIBY27EQ3B5MVGZI3HDX1WGA4GNL7CVBPWBI6HXZF7X8QLDJ2	3
951	QBAUG43EX0	AX1BFQCA3WT3T1Q368ERLVUNS49HTTCDTXB8KORVG5OAFMN5SWOFFK8PDNTKR4RKUPJ60RTSRSLPGTHGRDZ6E68IZV574HDLOEQZ	1
951	2UYP83OU7H	RFAD5XW9SITFN3OFUFXRAGFWWYKP9ACDSDA7Y3IJLIGML1RNYF482HBKANRHNH9RFPXJ3RQ07OG292K4G613FEKKCZ7LMA5EIYH5	2
951	M8LP7EJPJC	HUHZDBOBJKHDWBRPGMBFMHDTFO6SCTKVPZ8LTECC6I2OZHZ9OYCMF01ARXUZF580AWY6CF5BJ8IDOZ37Y6EOQ7PY8846TM7AKCOC	5
951	OE7G4D95TQ	37I2BDGRXV23WAI0UJCG98DL9R6BH3MK1N585VP4JGKNCC7MYKZ3L6U4472TGFJ4JRCJEK584I72YZJ7UUM7ET943BE836YD7QEU	9
951	44GWYVQ941	XHOO08D81FEY48V2LZ0RHQDF7F8T35IVY87M8SNU66B59J87CLV0OC1HEIRVATE57TA6BI43MFVLOHGXGARSKSGVG0I0A1TM2F8P	3
951	WT1KWZC2VX	C63R1NIRQ26B4PACVVPNP0LAE2VWITJJ0OEDXBSF7DZ7MYGLSKGUSC3LV3M91WI7TWKPL7OUCKPLANYPVJD7MY1YU2R3YTNL52OZ	4
951	XA2SEDHKA5	0AV6WSIXSLIF7NSSKU45W5SPV5S6DQH88C4JSB0GSABQJX1F52UIU305SFK09LTCDKG4TIAJ3YNV3BG7ENBK69OFM80M1AGGR9N8	5
951	4UMCA9GGS5	7WW2KO6QECQ9NWVJJGE6BSUSYS3RGE4YHQH1PSVVRYH6KMNNV6I2ICPOBEE2UOJAI217P340VSOMLXHLEP6J6BPEA2ZLO2BDOGYS	6
951	OXSSA6KT74	Q81CRHZYCDN62YESAEHMW6WDTM2RL8E9ZZYREHO3ZQ8YLOVE6UOCQF8TLXTFPINE9OGCAWN3ZOWG881E0YV0TBST1EGRXJORD4Z7	3
951	RF62QV59AC	SEJGVNCT2VN5PO0WWU75WL5Q6FQAEDEI45IULU8YQA9T2WI4X5QJ1CVHI2JP6CPYREATGGLBVJPWLMYK6VMJW4R2JALTKT1NVKBY	6
951	EXSGMP7BN4	ZYRUOXSW956E9SL0FCWXIJF421CRCABKAZH75ZHG8FKEPOLAQXPIOAMQSX2XVAU94VEKLN4Q4QYC9AONPCAOU259M0PI7TV7VKK4	3
951	DN5N8RS3G1	BYC29O8LJQRIOIT9FOBZE7U8WTK40RY0UDON7WVO7YDK7ASLC8P6IEFDEEGPDEU120XL3FBT3X2Q3KAWB912C2RQ7KI3PGK2DLRH	4
951	TRFU14BD1F	GR666DVLZJ3ETOEM1Z9JHOS7IDWM9MS23K4R56FZ6EHAOZ62GQMVS7E299X2QILN1BKJTXR4TKMCHRSTH4FTA6K5FCS5JNJX24JN	4
951	HDAKH5P9W5	WIT8RBHVBVRREVVC1M40PERFWVGAZKMIEEVWWVT4CKDRBNE2XUARPX9R1OM55H61IIN9A9QG39XFB9DIQOMEJ43QFD4IIX95OLI2	1
951	FFWE8F8F46	F2YE3YP93Q1KEPQ41SNP636EI8FA11Z0LHLWYAPGOQMWC7EISBW35NDL5T65SOHC0B86E4G1CGBPRJCK47R0E658E91EDTX9IJ6B	9
975	IQ0VP7I4EQ	HEY550YLX4VRWBV7R84GA2EDBXSTCGINBLW334JFGWQFFWRSCB1LB58P9V3HIFJQVIQKP2EWYY9OL97OFAQAP6LFMG3IAB7AM9T7	2
975	HLAPWR5SVJ	GCK7EWM5UD9XPCHYJBZ6K8I85VW18BMQAI87GCLJ8K2C3VV9ZLD83A5I4LBSAV6T1TWGDKSG0P7AFFEK9XBX8OWAMZD4A2JNNJLK	9
975	3122J53CUB	P6P36HOC5CYH1SMTJUN6W4NHXG7FUW643MU0W3BGH7RWOXJJ63EY7NMUSIF0JISIG4NP7W7PSHYZN02A6XJ0SI7Q9AIOXL69OIQU	3
975	8OI9QT5AJF	4MK6YFZYWH2PF3W92Z877P7OS1GLZKEJI0CL834CH1N3Q9SSK9WSSXMOO6N68O9LCSGP0KB855ZFCE8TJYAZYW1VNX6CP8D22B07	8
975	8MD6C924TO	D298XXX7GMK84WKOJWQ0UCCN8T717NANA1G6A1B9EYGLVDVL3OTOKHIAZW9E0593M78CQONRVQW551157V8S4WC3SFGO17JIYM9Y	2
975	QBAUG43EX0	S4PBB33UMF74EGE7R9Z4FULH80YHOHT2DZP1TR23IIFAJUX1ELHNJ3A8THCLFWGFWF0O1NN9G6W6OK8NC6DC9FTKYQHLPRYWCAOD	8
975	2UYP83OU7H	I917IHMHETIJYIISDFQWQ0KFCTZI93O64T47LF18GCU78B0IPD947RNSZV5YSDHLFMOEOKH8OSPNFNHA3Q253T8MGMHZKCQD4J1W	6
975	M8LP7EJPJC	W4F6BPPCAMMO45BKMRWNB8BDRYMCLS6VUNGVX92DTKF94LPGO2S1FJUX2BONDN0RQ13QYPWMZS313CIGIFXS9EQL2T2WUOAGTXTD	5
975	OE7G4D95TQ	8S9FFBWP3402IE80HRLKSYFWA2KSXHFSFZJXYN4D369ZC3MJCQMFI28KMMFN1E1VZIXS5KB4XIRVYQUGPAPH59KM08KLHQLYEN93	2
975	44GWYVQ941	3O1ORSALMW61880YU0Z7L26AZXH62RLQ0AVWY3ORKANMOUJSV9UWK54BS1Y4LDT5KQB7MEA0MIXKOTVFOYK26YG4GTD6ETFGRRC8	5
975	WT1KWZC2VX	LFR83KBITW8FSQW309VJG12AEW2CR37RXWCT33COEWW6F0WDTN0SQYMTMR4HR810ZRR5ND966HETF65N9ZTDDOA9KTGL946F56HX	3
975	XA2SEDHKA5	00PN3VJT3NQWQH2PXWLQSV37X7BK8YJYHEI8DZJ31QRFZZSWE0HJ5H0F6SZ6T9UEE1PL93M7NRZBEXH8PPFIR929ODCUANJ25MB8	3
975	4UMCA9GGS5	GXKOJ5OSYAIL1RE3LXE8P75117AI6F1WIXI144HEORZC3II5F8UZ695I2TWL4FVSIWCDIN8RPAT8I27SYEC8VCZJ298KH5JI5G3H	2
975	OXSSA6KT74	FX19CJ6P6A9WEX0CX7G63LJOYKT1KCC8ZMTRL8T333598XDITFIJXLM3ONL20FE47B71DI1YNNCAPJPAGKHF33KNAZD8X0CYYAB7	7
975	RF62QV59AC	LFKOU5KJMNE7LVP79AE0U1NF3AXKOLPHSK4F70J7AEXM8AMEX0YA7HFU1FUTIA4A87PB1JAI1GZPDBG2YSWXWOJKEKN1GZZ9JWNB	6
975	EXSGMP7BN4	LNN0PJ0RZQ09150NHOUXE6R6ICBR0GRYFGNEI7HFT3O3X2O49WCI3NRO6RRNHJ1T9B3URVEJHOELSXIQXHSEDI51Z8I1P38JB43V	9
975	DN5N8RS3G1	3MNR2BOJG6IIBZA1XQ1GC5SMN4NQ4JX3XR44EWKGQSTC9SNE8SOOCP683BD7Y8O6IOVU5FWAFUZTMQN4RISM5J1HU5BDTMSSDW4U	9
975	TRFU14BD1F	2J25NIRZMVNXJQPPCA8XN99DTR3CHQZV26Y9ZQSBJSIJYPJ6CDBV57T3JYM6PPS6615M1QZWS7O51ZPEH6AEOD04N5ZAEVV3ALN6	5
975	HDAKH5P9W5	7FVNOD8TYBTJHYSPNR2BB950ZS6LU5PMTUK1O19A1LZ3F167DOW3U5S8J5X6GW92WHZWO1BWR2JZJBU7V9IFIV1YCLRTDD4FM6H8	1
975	FFWE8F8F46	JSLN9M1V2YIK0KGN3TAPBUCJSTO8ENN4W5MR62JJACJXJIN2X1TMGSAZPC5P73RPKNY48ZRAK1P8KPAJGWKM4BXD5WB473LGV3M5	5
994	IQ0VP7I4EQ	S38KSCODBOABVJLSEVJ0U8MXWDQPJMQDEZX2MCL9IA3IB2LU9YQICF8URKXOV93Y7675VTGCKKRUFDW316PU6IA91DKBO6NJGEKE	8
994	HLAPWR5SVJ	Q8QRO82YOPNY3WZTJ2Y67ESIEXN6HNA3S7L79DRKHLMY7NVJY07LVH7LQIN1U5QAOTF5L2UFLOYW24K0BDIQQYIKA9Q00ZZL4LJN	2
994	3122J53CUB	Z85G1AHSLTW7WZRX9U0L55LL3PVYN2QV7TMEMKYYB1YP42EAIY41TBM3WUMMOSFSDBACMNKZ5BKDG5RALUQY8YB5GTR27MJSWGM2	8
994	8OI9QT5AJF	BX4NF6R0JW0CMA4CQUP9E635S1T22RATYHK7VL32UE760ZVLPQFW73YE394NNY82WHNE06QF1WO997E3GHMMLOW5TFDVQPP5GFJT	3
994	8MD6C924TO	QVS9A4KOYF65BGFMWQIVSUU34YLHS33XURZV4MLTMQ49H0OJJTTYB835BZELTC55LIKUQURKFYIB0UWEJC89JEVWY3UFH99JV9X8	4
994	QBAUG43EX0	42YBJTNZ1FQC9CRD6VHWY6WAMCFZ8Q06YZOJJ7AVI66YDCI7SGYOQL08FYZHNX0LPTOKXH38VVO1986K4IH21MPM8QEVI3HUGVIU	6
994	2UYP83OU7H	7KKMZ35798G1OMFQ7TCDBLGDI01O3VO0LW686QBTUP8S733QBEICFQWVDGE9BQEOTQQ2QHTRRTSWMYFO6LMYMMU5AK40MCSELU8R	4
994	M8LP7EJPJC	BA4U0UW8AIPBZC0DPBH6V2FN3FPBOK2ZXA5KSEV1769BOZW91A6S1V2I4R0VFVTZQZNYHPVKPP8Y2D8ESPJOOK8CIWQBNAWMNKVZ	3
994	OE7G4D95TQ	82MPVCLXEQ0SWD0LFLG1LQU9T7P2VKSSJ2TX792HWODGZS066BI8P7ASHM5YXSB47IJ4TCNGT8E6MOKAGS6UCUDL1BQUDDUDNJIQ	3
994	44GWYVQ941	6N3XCOQ2EF2C4SEWQ1NF8CSW3CQOBSCF31JFC7AFWSW6XSJUPR6R5LK45H498C1VCWJCJ9TT1HSPQV9K358UWVKRRPK5DAGU1A3A	3
994	WT1KWZC2VX	GLQ7N0X25NJHTGDDH9RL2V4ZXP0B8YP28CXURWJ4XYWBAXU4DQUBLYQUQ1K79V4G8QJQTTVUZXYD92Y9568SDNRKWCD0MM5B4PCU	4
994	XA2SEDHKA5	DLT49LYAMVXDKBCXMDV994QQ5IN1WJU0EV1VOXDB2JKRPXBK2NRLRUPJ4D9186NCA79YJRJZ9THZU9AIGC9I2IJTGS0KXMD56HQR	6
994	4UMCA9GGS5	MAKE2M7NZZ5D0U57EJ2YPS109BWPL3MSSU3CYE95LFQ35H61I818Y3I4JUE10RC6MMUG13IAK6MJC752E4HMBO3ZM92EAIF3DTQS	6
994	OXSSA6KT74	0APZ1X2R81MYLW5KZ58T531AE9B0SGTQMFN42WK0BHOIQPYVKTOYS916JOV1WC92I5MFJARDUIRXPSUYKQP8248NORUOASE9IVAU	1
994	RF62QV59AC	SMKCLDKRDQ036QFWAAN7811PCCBDSP3SAV1DF6R0X5KA4VEC8MHVWXE1U49ICG9YXH3LYCRETWJDR1VR89FFHH6MQATL6IYR5VNX	7
994	EXSGMP7BN4	2N65DC9OBK2JRKDA3QPLQ4YSFIL81H5O70FVJJEF68P00BO7VQCE8MK7ZNZ51BW3POL1FR1TMKOSP82E3NMKF0QVPH66UJN5LVKL	7
994	DN5N8RS3G1	X1DZS2X72S1VVBNYLYY8ZL7V59D6TG3XQNGWJUX72XXZEK8H9GA7WNAL4S4SZ1OVZEFH51P0B1GBYIQUB57MG6BDN4100EIBJBAA	2
994	TRFU14BD1F	0MH1J54H8WVBKQ43BP2CC4AAZA6SE2XIQPKSZV7AG6OIGYPXOHIVH7D6LHCI9MCG9NV5GLDPS16FP23AVIE7UBASLOGSTYB43II3	1
994	HDAKH5P9W5	URCD2DPA7QTNBX0HEW8MDT1EV630CMHUA7A0B317VRO8XERBKWZVJQABZ8S5JZ8VJ9MEW9FL4A0VF3QQO2PPWVKT79ADK6X6T2YY	8
994	FFWE8F8F46	NOLQN1J0O56RCRRJS8XZ3GX8CB8M4BME2YANE9J4B3SDEVIOGWA4B89G1MOM265MT1YOQEFTZ2Y9YU4Q2TGIBRD4Z4W1U6BE8FTN	9
995	IQ0VP7I4EQ	38BQRFIK9SGS7TJZXLBY4ZWSN820TBSAQT9VE1TM4TZLPJWN2PK4RYCEMTDSMR18AFBOUXU62Z4L9KCEMP8E0YT2R4JVYA9M10LJ	2
995	HLAPWR5SVJ	I2F4OC240FBR8G7TXIMWJ60O9I1ZRTI827DW3JMW170ZHDZ3C2ES9X7LC04GKCMH6DYACK0N505LGAG5S8WZOZ8E92UCPGLYVS2E	4
995	3122J53CUB	Z02C0WJ2WEBT8XLPX2GETBK0Y8ZOG0XICQ3H4XYDZMNXSSQSAI70WA5XQBN275W5R3RS4EVAEDOHXWHFSHN727WCUF03J5G30RGZ	1
995	8OI9QT5AJF	7X5X7VSVYA43IJZRYCTHP7ZN10I7VQFQSDUTSK5LDQ6F69AWQLCPWRWA8R5GMVAH4OLFZG9OHIE8AUR20WRJO03ARUUAOY9RQZKR	7
995	8MD6C924TO	57JMXIONX9OADQ0E02DUKYEV8ASJWSLJ9E4ZH71SPX3UGALIIN06H7NH2YNXZF1FYEA8VB73BVFX4UO8YKAJ1OCC0X7STD2K5X6C	9
995	QBAUG43EX0	MWHP65W10MHKO8PERNJC8H8DOJ7251HYM9MX235TQKAKZIEENFNJWAAFXDBW7368FT8PW1MYS0WYHYOGF3P0N8BL9HAY2IVWNBFG	3
995	2UYP83OU7H	ZRV2Z06OM79Z4REOGUHRWQP1X5KEAKFSI5PL37YHF7WJA970RHHQ8YYJC3E3Q1NB2QR8C2VI6AMY3G0Y8TX2DYUTHGI9240NTVQU	5
995	M8LP7EJPJC	8YYV8U8LAQ6DQ57EV8D6716TVQBJ9EHZGG958GEEWIHZM6M93I8XNYUH2FASSYM5IH7J6CGO39JZUGHZDCQ0FULRW1C2GWV75LRF	9
995	OE7G4D95TQ	CD1CU3OO5XW7LOQHW0X5PXE9NHHNM3IYBZB9ZYV17D0EQ55HFZJV3JTO81YMWACCO75VNQS8F67M69SSMAHWTW41GWA79IF6BYZS	9
995	44GWYVQ941	J3YHLQ7MHS9JGAV3PS1CEP1QU861AKIJ9TCGSPHG7P8DBY3ITDWF7Q54BIWMTGL6JZJW7OK9KVFYQXP5FYH7YCLTYHFJ25W0EB4L	4
995	WT1KWZC2VX	GLE2W5MKGON30H59NIHNZ8ZJAHP8PUO3DQ8MCECG9JR31QBX0103W80IV51PPN5W9U0KJS6IFAOPQ5RUF2IY3VHF0Z1HNX1VO54H	7
995	XA2SEDHKA5	1NH4RXVTK2ZNHJXFG2NNVUT1Z5SJ3BVBK4OOA3M8VVQ7B3GNEPHCQ3EG4QEVEM0IGYCM5IFNPP1AEW05ZEFN3SVR0HUTY13I4H0M	7
995	4UMCA9GGS5	3S5K4XBCECIZI59HMOYDVWXXVYYVSF65NE5WJD94TPVFM3P53BR2CJFH5HYF8QT9FMMEAN7JP3TGASL1I31RXD3D9Y0BP36D6W99	5
995	OXSSA6KT74	L5QDINI09GN667FYBMBTIELX64V7PKOSLK78LOO0UN9RNFS60O4J7QIGT3HN2KKZ24UV9GNX7L85E4J0LYGAPEV5B0PSGA7KCKYT	6
995	RF62QV59AC	66UBHMVRNBZTQBDEJJYIZTJ15Q6OY24FZFO1W9I19NYYZ8093G3AAK5NX2F0PH3VHT3KWLRKB6JL5VC707US93FPKBE43RM1UDQF	2
995	EXSGMP7BN4	PMRYS9DATRC0I9RXKVNOOAVHXQTUR12E62LVC4Q4BO0UBEUR4EKRD10O1KBCPTT2Z83QY6VQFTM9KAFS6BZNRKAFC7412OPS574D	3
995	DN5N8RS3G1	D38T3LUO0D0ESFN3FLO7YO1B3X1D4ENFCI2I14X9Q1L3EXKIBYZVQFWZC6ZFUQTW0UCJNFCLYPR7C77GNTCFP1Z6VCG4ERPAHZCT	6
995	TRFU14BD1F	A56VN7BYZWE8T2BNOG84GXK8HHGAQZN4NVMXFTB4YH6QB6UYOW2SEYOMV7OF0BI9JJU8QNI4EEG8137LXSW4740YG9CIF6EX97H2	3
995	HDAKH5P9W5	VIAO7N9SQV1ACSHONCOS51QK9ZI9T94WEABJVP9Q0G0OKHDO6IV42JP32ZOIF98R1E5CQ838D71ZBB91W4DLN934UIR5A0L1HJXG	4
995	FFWE8F8F46	B78OX15S020ZXWK6XD1LBRIQ87MVAR2O3PU6F60H8M4P1FNDA4UG55KTZRQZOJRJAM5HBO10MUMYW2Z2TIUF6VT8EAGXQA2Z4VPO	3
\.


--
-- Name: _cast _cast_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT _cast_pk PRIMARY KEY ("character", person_id, movie_id);


--
-- Name: country_of_origin country_of_origin_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country_of_origin
    ADD CONSTRAINT country_of_origin_pk PRIMARY KEY (country_of_origin_id);


--
-- Name: country country_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pk PRIMARY KEY (country_id);


--
-- Name: crew crew_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT crew_pk PRIMARY KEY (person_id, movie_id, job_name);


--
-- Name: department department_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pk PRIMARY KEY (department_id);


--
-- Name: genre genre_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY genre
    ADD CONSTRAINT genre_pk PRIMARY KEY (genre_id);


--
-- Name: job job_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pk PRIMARY KEY (job_name);


--
-- Name: member member_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pk PRIMARY KEY (member_login);


--
-- Name: movie_genre movie_genre_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT movie_genre_pk PRIMARY KEY (movie_id, genre_id);


--
-- Name: movie movie_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie
    ADD CONSTRAINT movie_pk PRIMARY KEY (movie_id);


--
-- Name: movie_productioncountry movie_productioncountry_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT movie_productioncountry_pk PRIMARY KEY (movie_productioncountry_id);


--
-- Name: person person_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pk PRIMARY KEY (person_id);


--
-- Name: review review_pk; Type: CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT review_pk PRIMARY KEY (movie_id, member_login);


--
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
-- Name: review on_insert_into_review; Type: TRIGGER; Schema: moviedb; Owner: postgres
--

CREATE TRIGGER on_insert_into_review AFTER INSERT ON review FOR EACH ROW EXECUTE PROCEDURE vote_average();


--
-- Name: crew czlowiek_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT czlowiek_ekipa_fk FOREIGN KEY (person_id) REFERENCES person(person_id);


--
-- Name: country_of_origin czlowiek_kraj_pochodzenia_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country_of_origin
    ADD CONSTRAINT czlowiek_kraj_pochodzenia_fk FOREIGN KEY (person_id) REFERENCES person(person_id);


--
-- Name: _cast czlowiek_obsada_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT czlowiek_obsada_fk FOREIGN KEY (person_id) REFERENCES person(person_id);


--
-- Name: job dzial_praca_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY job
    ADD CONSTRAINT dzial_praca_fk FOREIGN KEY (department_id) REFERENCES department(department_id);


--
-- Name: crew film_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT film_ekipa_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- Name: movie_genre film_film_gatunek_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT film_film_gatunek_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- Name: movie_productioncountry film_film_krajprodukcji_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT film_film_krajprodukcji_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- Name: _cast film_obsada_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY _cast
    ADD CONSTRAINT film_obsada_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- Name: review film_recenzja_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT film_recenzja_fk FOREIGN KEY (movie_id) REFERENCES movie(movie_id);


--
-- Name: movie_genre gatunek_film_gatunek_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_genre
    ADD CONSTRAINT gatunek_film_gatunek_fk FOREIGN KEY (genre_id) REFERENCES genre(genre_id);


--
-- Name: movie_productioncountry kraj_film_krajprodukcji_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY movie_productioncountry
    ADD CONSTRAINT kraj_film_krajprodukcji_fk FOREIGN KEY (country_id) REFERENCES country(country_id);


--
-- Name: country_of_origin kraj_kraj_pochodzenia_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY country_of_origin
    ADD CONSTRAINT kraj_kraj_pochodzenia_fk FOREIGN KEY (country_id) REFERENCES country(country_id);


--
-- Name: crew praca_ekipa_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY crew
    ADD CONSTRAINT praca_ekipa_fk FOREIGN KEY (job_name) REFERENCES job(job_name);


--
-- Name: review uzytkownik_recenzja_fk; Type: FK CONSTRAINT; Schema: moviedb; Owner: postgres
--

ALTER TABLE ONLY review
    ADD CONSTRAINT uzytkownik_recenzja_fk FOREIGN KEY (member_login) REFERENCES member(member_login);


--
-- PostgreSQL database dump complete
--

