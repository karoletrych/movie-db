CREATE OR REPLACE VIEW moviedb.top100 AS
SELECT * FROM moviedb.movie WHERE movie_id IN
(SELECT r.movie_id
FROM   moviedb.movie m
       JOIN moviedb.review r
         ON r.movie_id = m.movie_id
GROUP  BY r.movie_id
HAVING count(r.movie_id) >= 10)
ORDER BY vote_average DESC
LIMIT 100;

CREATE OR REPLACE VIEW moviedb.top100director AS
SELECT p.person_id, p.name, Avg(m.vote_average) AS vote_average FROM moviedb.person p
	JOIN moviedb.crew c
	  ON p.person_id = c.person_id
	JOIN moviedb.movie m
	  ON c.movie_id = m.movie_id
	JOIN moviedb.job j
	  ON j.job_name = c.job_name
	WHERE j.job_name = 'Director'
GROUP BY p.person_id
ORDER BY Avg(m.vote_average) DESC
LIMIT 100;