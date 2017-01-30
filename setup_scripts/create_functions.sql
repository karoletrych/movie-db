CREATE OR replace FUNCTION moviedb.vote_average ()
RETURNS TRIGGER AS $$ DECLARE average FLOAT;
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
$$ LANGUAGE 'plpgsql';



CREATE OR replace FUNCTION moviedb.create_member (new_login varchar, email varchar, password varchar) RETURNS void AS
 $$ 
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION moviedb.login_member(login varchar,password varchar) RETURNS varchar AS 
$$
    DECLARE
        logged_user varchar;
    BEGIN
        SELECT member_login FROM moviedb.member  WHERE member_login=login AND password_hash=MD5(password) INTO logged_user;
        RETURN logged_user ;
    END;
$$ 
LANGUAGE plpgsql;


-- triggers

drop trigger on_insert_into_review on moviedb.review;

CREATE TRIGGER on_insert_into_review
  AFTER INSERT
  ON moviedb.review
  FOR EACH ROW
  EXECUTE PROCEDURE moviedb.vote_average(); 
