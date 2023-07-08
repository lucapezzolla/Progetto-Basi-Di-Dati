CREATE OR REPLACE TRIGGER Max_Tessere
BEFORE INSERT ON TESSERA
FOR EACH ROW

DECLARE
Troppe_Tessere EXCEPTION;
Last_tessera DATE;

BEGIN
SELECT MAX(DATA_EMISSIONE_TESSERA) INTO Last_tessera FROM TESSERA WHERE :new.NUMERO_TEL_TESSERA = NUMERO_TEL_TESSERA;

IF :new.DATA_EMISSIONE_TESSERA - Last_tessera < 365 THEN RAISE Troppe_Tessere;
END IF;

EXCEPTION
WHEN Troppe_Tessere THEN RAISE_APPLICATION_ERROR(-20003,'TOO MANY CARDS!');

END;