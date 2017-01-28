CREATE OR REPLACE FUNCTION moviedb.vote_average()
  RETURNS TRIGGER AS
$$
DECLARE
average float;
BEGIN
SELECT AVG(r.vote) INTO average
FROM moviedb.movie m JOIN moviedb.review r ON m.movie_id = r.movie_id
WHERE m.movie_id = NEW.movie_id;
UPDATE moviedb.movie SET vote_average = average
WHERE movie_id = NEW.movie_id;
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql'; 

drop trigger on_insert_into_review on moviedb.review;

CREATE TRIGGER on_insert_into_review
  AFTER INSERT
  ON moviedb.review
  FOR EACH ROW
  EXECUTE PROCEDURE moviedb.vote_average(); 
