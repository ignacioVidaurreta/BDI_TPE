CREATE OR REPLACE FUNCTION updateRep() RETURNS TRIGGER AS $updateRep$
DECLARE
    aux_upvotes INT;
    aux_downvotes INT;
    newRep INT;
BEGIN
	SELECT upvotes INTO aux_upvotes FROM UserTP WHERE Id = new.Id;
	SELECT downvotes INTO aux_downvotes FROM UserTP WHERE Id = new.Id;

	IF(TG_OP='UPDATE') THEN	
		newRep :=
		    CAST((SELECT Reputation FROM UserTP WHERE Id = new.Id) + 
		        (5 * (aux_upvotes - COALESCE(old.upvotes, 0))) -
		        (2 * (aux_downvotes - COALESCE(old.downvotes, 0))) 
		        AS INT);
	ELSE
		newRep :=
		    CAST((SELECT Reputation FROM UserTP WHERE Id = new.Id) + 
		        (5 * aux_upvotes) -
		        (2 * aux_downvotes) 
		        AS INT);
	END IF;
	
	IF (newRep < 1) THEN
	    newRep:=1;
	END IF;
	UPDATE UserTP SET Reputation = newRep;
	return NEW;

END;
$updateRep$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION checkVotes() RETURNS TRIGGER AS $checkVotes$
DECLARE 
        aux_up INT;
        aux_dow INT;
BEGIN
        SELECT upvotes INTO aux_up FROM UserTP WHERE Id = new.Id;
        SELECT downvotes INTO aux_dow FROM UserTP WHERE Id = new.Id;

        IF(TG_OP = 'UPDATE') THEN
                IF(new.upvotes < 0) THEN
                       new.upvotes:=aux_up;
                END IF;
                
                IF(new.downvotes <0) THEN
                       new.downvotes:=aux_dow;
                END IF;
        ELSE
                IF(new.upvotes < 0) THEN
                        new.upvotes:=0;
                END IF;
                IF(new.downvotes <0) THEN
                        new.downvotes:=0;
                END IF;
        END IF;
        return NEW;

END;
$checkVotes$ LANGUAGE plpgsql;


CREATE TRIGGER checkVotes BEFORE INSERT OR UPDATE OF upvotes, downvotes ON UserTP
FOR EACH ROW
        EXECUTE PROCEDURE checkVotes();


CREATE TRIGGER updateRep AFTER INSERT OR UPDATE OF upvotes, downvotes ON UserTP
FOR EACH ROW
    EXECUTE PROCEDURE updateRep();
