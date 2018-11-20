CREATE OR REPLACE FUNCTION updateRep() RETURNS TRIGGER AS $updateRep$
DECLARE
    aux_upvotes INT;
    aux_downvotes INT;
    newRep INT;
BEGIN
    SELECT upvotes INTO aux_upvotes FROM UserTP WHERE Id = new.Id;
    SELECT downvotes INTO aux_downvotes FROM UserTP WHERE Id = new.Id;

    IF (aux_upvotes < 0) THEN
        aux_upvotes:=0;
    END IF;

    IF (aux_downvotes <0) THEN
        aux_downvotes:=0;
    END IF;

    newRep :=
        CAST((SELECT Reputation FROM UserTP WHERE Id = new.Id) + 
            (5 * (aux_upvotes - COALESCE(old.upvotes, 0))) -
            (2 * (aux_downvotes - COALESCE(old.downvotes, 0))) 
            AS INT);
    IF (newRep < 1) THEN
        newRep:=1;
    END IF;
    UPDATE UserTP SET Reputation = newRep;
    return NEW;

END;
$updateRep$ LANGUAGE plpgsql;

CREATE TRIGGER updateRep AFTER INSERT OR UPDATE OF upvotes, downvotes ON UserTP
FOR EACH ROW
    EXECUTE PROCEDURE updateRep();
