/*********************************************************************
/**
/** Table: autos_hauptstandort_view
/** Developer: 
/** Description: Gibt alle verfügbaren Autos am Hauptstandort aus
/**
/*********************************************************************/
CREATE OR REPLACE VIEW autos_hauptstandort_view
AS
SELECT EXEMPLAR.EXEMPLAR_ID, 
       EXEMPLAR.FARBE, 
       EXEMPLAR.ERSTZULASSUNG, 
       HERSTELLER.BEZEICHNUNG, 
       AUTO_DETAILS.MODELL_BESCHREIBUNG, 
       AUTO_DETAILS.PS, 
       AUTO_DETAILS.VERBRAUCH, 
       AUTO_DETAILS.SITZPLAETZE, 
       PREISLISTE.KOSTEN_PRO_TAG
FROM EXEMPLAR JOIN AUTO_DETAILS ON AUTO_DETAILS.DETAIL_ID = EXEMPLAR.AUTO_DETAILS_ID
              JOIN HERSTELLER ON HERSTELLER.HERSTELLER_ID = AUTO_DETAILS.HERSTELLER_ID
              JOIN PREISLISTE ON PREISLISTE.PREIS_ID = AUTO_DETAILS.PREIS_ID
WHERE STANDORT_ID = 1 AND
      EXEMPLAR.SCHAEDEN_ID IS NULL AND
      EXEMPLAR.STATUS_ID = 2;

COMMIT;