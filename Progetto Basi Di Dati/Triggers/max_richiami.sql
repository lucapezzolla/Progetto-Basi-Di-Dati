CREATE OR REPLACE trigger Max_Richiami
BEFORE insert on RICHIAMO
FOR EACH ROW

DECLARE
Max_R EXCEPTION;
Richiami NUMBER;

BEGIN
SELECT COUNT(*) INTO Richiami FROM RICHIAMO WHERE :new.cf_ric = cf_ric;
IF Richiami > 9 THEN RAISE Max_R;
END IF;

EXCEPTION
WHEN Max_R THEN 
RAISE_APPLICATION_ERROR(-20002,'TOO MANY WARNINGS! NEED TO FIRE HIM?');

END;