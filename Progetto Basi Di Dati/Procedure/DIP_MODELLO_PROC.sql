CREATE OR REPLACE PROCEDURE Dip_Modello(Quart_Neg VARCHAR2)
IS
Codf CHAR(16);

BEGIN

FOR x IN(select nome_dip as nome, cognome_dip as cognome, cf_dip as cf, ore
from
    (select * 
    from dipendente join lavora_in on cf_dip = cf_lavin
    where quartiere_lavin in (Quart_Neg)) join (select 24 * (data_fine_pres - data_inizio_pres) as ore, cf_pres from presenze) on cf_lavin = cf_pres
    where ore = (select max(ore) from(select * 
    from dipendente join lavora_in on cf_dip = cf_lavin
    where quartiere_lavin in (Quart_Neg)) join (select 24 * (data_fine_pres - data_inizio_pres) as ore, cf_pres from presenze) on cf_lavin = cf_pres) AND
    cf_dip not in (select cf_ric from richiamo))
LOOP
Codf := x.cf;
INSERT INTO STIPENDIO(CF_STIP,IMPORTO,TRATTENUTE,DATA_STIP) VALUES (Codf,1000,0,to_date(SYSDATE));
END LOOP;

END Dip_Modello;