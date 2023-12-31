CREATE OR REPLACE PROCEDURE Rifornimento(Track VARCHAR2, Data DATE, Prodotto VARCHAR2, Quantity NUMBER, Euros NUMBER, Quarter VARCHAR2, Piva VARCHAR2)
IS
prod_name VARCHAR2(30);
Flag NUMBER;
Flag_2 NUMBER;
Flag_3 NUMBER;
Flag_4 NUMBER;
Data_forn DATE;
Wrong_P EXCEPTION;
Wrong_Q EXCEPTION;
Wrong_E EXCEPTION;
Wrong_Quart EXCEPTION;
Wrong_Piva EXCEPTION;

BEGIN

SELECT COUNT(*) INTO Flag_2 FROM PRODOTTO WHERE CODICE_PRODOTTO = Prodotto;
IF Flag_2 < 1 THEN
RAISE Wrong_P;
END IF;

SELECT COUNT(*) INTO Flag_3 FROM NEGOZIO WHERE QUARTIERE_NEG = Quarter;
IF Flag_3 < 1 THEN
RAISE Wrong_Quart;
END IF;

SELECT COUNT(*) INTO Flag_4 FROM FORNITORE WHERE PIVA_FORNITORE = Piva;
IF Flag_4 < 1 THEN
RAISE Wrong_Piva;
END IF;

IF Quantity < 0 THEN
RAISE Wrong_Q;
END IF;

IF Euros < 0 THEN
RAISE Wrong_E;
END IF;

SELECT COUNT(*) INTO Flag FROM FORNITURA WHERE TRACKING_FORNITURA = Track;
IF Flag > 0 THEN
SELECT DATA_FORNITURA INTO Data_forn FROM FORNITURA WHERE TRACKING_FORNITURA = Track;
INSERT INTO CONTENUTO_FORN(CODICE_CONTFORN, DATA_FORNITURA_CONTFORN, TRACKING_CONTFORN, COSTO_CONTFORN, QUANTITY_CONTFORN) VALUES (Prodotto, Data_forn, Track, Euros, Quantity);
COMMIT;

ELSE
INSERT INTO FORNITURA(TRACKING_FORNITURA, DATA_FORNITURA, PIVA_FORNITURA, QUARTIERE_FORNITURA) VALUES (Track, Data, Piva, Quarter);
COMMIT;
INSERT INTO CONTENUTO_FORN(CODICE_CONTFORN, DATA_FORNITURA_CONTFORN, TRACKING_CONTFORN, COSTO_CONTFORN, QUANTITY_CONTFORN) VALUES (Prodotto, Data, Track, Euros, Quantity);
COMMIT;
END IF;

SELECT NOME_PRODOTTO INTO prod_name FROM PRODOTTO WHERE CODICE_PRODOTTO = Prodotto;

IF Flag > 0 THEN
dbms_output.put_line('PRODOTTO ' ||TO_CHAR(prod_name)|| ' INSERITO NELLA FORNITURA ' ||TO_CHAR(Track)|| '!');
ELSE
dbms_output.put_line('FORNITURA ' ||TO_CHAR(Track)|| ' CREATA! PRODOTTO '||TO_CHAR(prod_name)|| ' INSERITO!');
END IF;

EXCEPTION
WHEN Wrong_P THEN
RAISE_APPLICATION_ERROR(-20029, 'THIS PRODUCT DOESNT EXIST IN THE DB');

WHEN Wrong_Quart THEN
RAISE_APPLICATION_ERROR(-20040, 'INVALID STORE');

WHEN Wrong_Piva THEN
RAISE_APPLICATION_ERROR(-20050, 'INVALID MARIEUL');

WHEN Wrong_Q THEN
RAISE_APPLICATION_ERROR(-20031, 'QUANTITY MUST BE GR8R THAN 0');

WHEN Wrong_E THEN
RAISE_APPLICATION_ERROR(-20051, 'EUROS MUST BE GR8R THAN 0');


End Rifornimento;