CREATE OR REPLACE FUNCTION updateRep() RETURNS TRIGGER AS $updateRep$
DECLARE
    upvotes INT;
    downvotes INT;
    newRep INT;
BEGIN
    SELECT UpVotes INTO upvotes FROM UserTP WHERE Id == new.Id;
    SELECT DownVotes INTO downvotes FROM UserTP WHERE Id == new.Id;

    IF (upvotes < 0) THEN
        upvotes:=0;
    END IF;

    IF (downvotes <0) THEN
        downvotes:=0;
    END IF;

    newRep :=
        CAST((SELECT Reputation FROM UserTP WHERE Id == new.Id) + 
            (5 * upvotes) -
            (2 * downvotes) 
            AS INT);
    IF (newRep < 1) THEN
        newRep:=1;
    END IF;
    UPDATE UserTP SET Reputation = newRep;
    return NEW;

END;
$updateRep$ LANGUAGE plpgsql;

CREATE TRIGGER updateRep BEFORE INSERT OR UPDATE ON UserTP
FOR EACH ROW
    EXECUTE PROCEDURE updateRep();
