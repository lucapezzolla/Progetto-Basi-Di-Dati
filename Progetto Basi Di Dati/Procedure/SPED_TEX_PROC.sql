CREATE OR REPLACE PROCEDURE Sped_Tex (Cartid NUMBER, Datasped DATE, Cap VARCHAR2, City VARCHAR2, Via VARCHAR2, Piva VARCHAR2, Track VARCHAR2)
IS
Cart_Price NUMBER;

BEGIN
SELECT 0 INTO Cart_Price FROM dual;

FOR x IN(
SELECT NOME_PRODOTTO, MAX(PREZZO_PRODOTTO) AS PREZZO_PRODOTTO, MAX(QUANTITY_INCLUDE) AS QUANTITY_INCLUDE
FROM (SELECT *
FROM
(SELECT * 
FROM CARRELLO JOIN TESSERA ON ID_TESSERA_CARRELLO = ID_TESSERA) JOIN INCLUDE ON ID_INCLUDE = ID_CARRELLO) JOIN PRODOTTO ON CODICE_INCLUDE = CODICE_PRODOTTO
WHERE ID_CARRELLO = Cartid
GROUP BY NOME_PRODOTTO)
LOOP
Cart_Price:= Cart_Price + (x.PREZZO_PRODOTTO * x.QUANTITY_INCLUDE);
END LOOP;

IF Cart_Price < 100 THEN
INSERT INTO SPEDIZIONE (ID_CARRELLO_SPEDIZIONE,DATA_SPEDIZIONE,TRACKING_SPEDIZIONE,CAP_SPEDIZIONE,CITTA_SPEDIZIONE,VIA_SPEDIZIONE,COSTO_SPEDIZIONE,PIVA_SPEDIZIONE) VALUES(Cartid,Datasped,Track,Cap,City,Via,5,Piva);
ELSE
INSERT INTO SPEDIZIONE (ID_CARRELLO_SPEDIZIONE,DATA_SPEDIZIONE,TRACKING_SPEDIZIONE,CAP_SPEDIZIONE,CITTA_SPEDIZIONE,VIA_SPEDIZIONE,COSTO_SPEDIZIONE,PIVA_SPEDIZIONE) VALUES(Cartid,Datasped,Track,Cap,City,Via,0,Piva);
END IF;

END Sped_Tex;
