CREATE OR REPLACE VIEW moviedb.top100 AS
SELECT * FROM moviedb.movie WHERE movie_id IN
(SELECT r.movie_id
FROM   moviedb.movie m
       JOIN moviedb.review r
         ON r.movie_id = m.movie_id
GROUP  BY r.movie_id
HAVING count(r.movie_id) >= 10)
ORDER BY vote_average DESC
LIMIT 100