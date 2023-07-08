CREATE OR REPLACE PROCEDURE Acquista (Tex NUMBER, Codprod CHAR, Qtity NUMBER, Cartid NUMBER, Discount NUMBER)
IS
Cart_max NUMBER;
Nomeprod VARCHAR2(30);
BEGIN
SELECT ID_CARRELLO INTO Cart_max FROM CARRELLO WHERE ID_CARRELLO = (SELECT MAX(ID_CARRELLO) FROM CARRELLO);
Cart_Max := Cart_max +1;
IF Cartid = 0 THEN
	IF Tex = 0 THEN
		INSERT INTO CARRELLO (ID_CARRELLO, ID_TESSERA_CARRELLO) VALUES(Cart_max,NULL);
	ELSE
		INSERT INTO CARRELLO (ID_CARRELLO, ID_TESSERA_CARRELLO) VALUES(Cart_max,Tex);
	
	END IF;
    dbms_output.put_line('CARRELLO NUMERO ' ||TO_CHAR(Cart_Max)|| ' CREATO');
END IF;

IF Cartid = 0 THEN
INSERT INTO INCLUDE (ID_INCLUDE,CODICE_INCLUDE,SCONTO_INCLUDE,QUANTITY_INCLUDE) VALUES(Cart_max,Codprod,Discount,Qtity);
ELSE
INSERT INTO INCLUDE (ID_INCLUDE,CODICE_INCLUDE,SCONTO_INCLUDE,QUANTITY_INCLUDE) VALUES(Cartid,Codprod,Discount,Qtity);
END IF;

SELECT NOME_PRODOTTO INTO Nomeprod FROM INCLUDE JOIN PRODOTTO ON CODICE_INCLUDE = CODICE_PRODOTTO WHERE CODICE_PRODOTTO = Codprod GROUP BY NOME_PRODOTTO;
dbms_output.put_line('PRODOTTO ' ||TO_CHAR(Nomeprod)|| ' INSERITO NEL CARRELLO!');

END Acquista;