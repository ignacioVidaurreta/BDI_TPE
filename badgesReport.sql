CREATE OR REPLACE FUNCTION BadgesReport
(
        usuarioDesde IN UserTP.Id%type,
        usuarioHasta IN UserTP.Id%type
) RETURNS VOID AS $$

DECLARE
        userIdVar       UserTP.id%type;
        userDisplayName UserTP.displayName%type;
        userReputation  UserTP.reputation%type DEFAULT 0;
        badgeName       badges.badgeName%type;
        badgeQty        INT;
        badgeClass      badges.badgeClass%type;
        goldBadges      INT DEFAULT 0;
        silverBadges    INT DEFAULT 0;
        bronzeBadges    INT DEFAULT 0;
        headerFlag      BOOLEAN DEFAULT TRUE;
        firstLine       BOOLEAN DEFAULT TRUE;
        idLength        INT;
        displayNameLength       INT;
        reputationLength        INT;
        badgeNameLength INT;

        userCursor      CURSOR FOR
                                SELECT Id, displayName, reputation
                                FROM UserTP
                                WHERE Id >= usuarioDesde AND Id <= usuarioHasta;
        badgeCursor     CURSOR FOR
                                SELECT DISTINCT b1.badgeName, aux.qty, b1.badgeClass
                                FROM badges b1 JOIN (SELECT b2.badgeName, COUNT(b2.badgeName) qty
                                        FROM badges b2 WHERE b2.userId = userIdVar GROUP BY b2.badgeName) aux ON b1.badgeName = aux.badgeName
                                WHERE b1.userid = userIdVar
                                ORDER BY b1.badgeName;

BEGIN
        IF (usuarioDesde > usuarioHasta)
                THEN RAISE EXCEPTION 'El primer parametro debe ser menor o igual al segundo.' USING ERRCODE = 'ERR01';
        END IF;
        
        OPEN userCursor;
        
        PERFORM DBMS_OUTPUT.DISABLE();
        PERFORM DBMS_OUTPUT.ENABLE();
        PERFORM DBMS_OUTPUT.SERVEROUTPUT ('t');
        
        idLength = 8; displayNameLength = 21; reputationLength = 24;  badgeNameLength = 20;
        
        LOOP
                FETCH userCursor INTO userIdVar, userDisplayName, userReputation;
                EXIT WHEN NOT FOUND;
                
                IF (userReputation IS NULL) THEN
                        userReputation = 0;
                END IF;
                
                IF (headerFlag) THEN
                        PERFORM DBMS_OUTPUT.PUT_LINE ('.                                      BADGES REPORT                                      .');
                        PERFORM DBMS_OUTPUT.PUT_LINE (repeat('-', 103));
                        PERFORM DBMS_OUTPUT.PUT_LINE (format('%-8s%-20s%-20s%-20s%s', 'ID', 'Display Name', 'Reputation', 'Badge Name', 'Qtty'));
                        PERFORM DBMS_OUTPUT.PUT_LINE (repeat('-', 103));
                        headerFlag = FALSE;
                END IF;
                
                goldBadges = 0;
                silverBadges = 0;
                bronzeBadges = 0;
                
                PERFORM DBMS_OUTPUT.PUT (userIdVar || repeat('.', idLength - length(to_char(userIdVar))));
                PERFORM DBMS_OUTPUT.PUT (userDisplayName || repeat('.', displayNameLength - length(userDisplayName)));
                PERFORM DBMS_OUTPUT.PUT (userReputation || repeat('.', reputationLength - length(to_char(userReputation))));

                OPEN badgeCursor;
                
                LOOP
                        FETCH badgeCursor INTO badgeName, badgeQty, badgeClass;
                        EXIT WHEN NOT FOUND;
                        
                        CASE badgeClass
                                WHEN 1 THEN goldBadges = goldBadges + 1;
                                WHEN 2 THEN silverBadges = silverBadges + 1;
                                WHEN 3 THEN bronzeBadges = bronzeBadges + 1;
                        END CASE;
                        
                        IF (firstLine) THEN
                                PERFORM DBMS_OUTPUT.PUT_LINE (badgeName || repeat('.', badgeNameLength - length(badgeName)) || badgeQty);
                                firstLine = FALSE;
                        ELSE
                                PERFORM DBMS_OUTPUT.PUT_LINE (repeat('.', idLength + displayNameLength + reputationLength + 12) || badgeName || repeat('.', badgeNameLength - length(badgeName)) || badgeQty);
                        END IF;
                END LOOP;
                
                PERFORM DBMS_OUTPUT.PUT_LINE (repeat('.', 65) || 'GOLD Badges:' || repeat('.', 9) || goldBadges);
                PERFORM DBMS_OUTPUT.PUT_LINE (repeat('.', 65) || 'SILVER Badges:' || repeat('.', 7) || silverBadges);
                PERFORM DBMS_OUTPUT.PUT_LINE (repeat('.', 65) || 'BRONZE Badges:' || repeat('.', 5) || bronzeBadges);
                
                firstLine = TRUE;
                
                CLOSE badgeCursor;
        END LOOP;
        
        CLOSE userCursor;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
        PERFORM BadgesReport(2, 15);
        EXCEPTION
        WHEN SQLSTATE 'ERR01' THEN RAISE NOTICE '% %', SQLSTATE, SQLERRM;
END;
$$;