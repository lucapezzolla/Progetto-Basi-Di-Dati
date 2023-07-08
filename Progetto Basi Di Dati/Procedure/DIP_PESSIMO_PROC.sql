CREATE OR REPLACE PROCEDURE Dip_Pessimo(Quart_Neg VARCHAR2)
IS
Codf CHAR(16);
Last_Stip DATE;


BEGIN

FOR x IN(select nome_dip as nome, cognome_dip as cognome, cf_dip as cf, ore
from
    (select * 
    from dipendente join lavora_in on cf_dip = cf_lavin
    where quartiere_lavin in (Quart_Neg)) join (select 24 * (data_fine_pres - data_inizio_pres) as ore, cf_pres from presenze) on cf_lavin = cf_pres
    where ore = (select min(ore) from(select * 
    from dipendente join lavora_in on cf_dip = cf_lavin
    where quartiere_lavin in (Quart_Neg)) join (select 24 * (data_fine_pres - data_inizio_pres) as ore, cf_pres from presenze) on cf_lavin = cf_pres) AND
    cf_dip in (select cf_ric from richiamo))
LOOP
Codf := x.cf;
SELECT MAX(DATA_STIP) INTO Last_Stip FROM STIPENDIO WHERE CF_STIP = x.cf;
INSERT INTO RICHIAMO (CF_RIC, MOTIVAZIONE,DATA_RIC,ENTITA) VALUES (x.cf, 'LOW_HOURS',to_date(SYSDATE),1);
UPDATE STIPENDIO 
SET TRATTENUTE = TRATTENUTE + 300 
WHERE DATA_STIP = Last_Stip AND CF_STIP = Codf;
END LOOP;

END Dip_Pessimo;