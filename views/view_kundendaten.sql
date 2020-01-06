/*********************************************************************
/**
/** Table: kundendaten_view
/** Developer: 
/** Description: Zeigt Kundendate an
/**
/*********************************************************************/
CREATE OR REPLACE VIEW kundendaten_view
AS
SELECT KUNDE.KUNDE_ID AS KUNDENNUMMER, 
       PERSON.VORNAME, 
       PERSON.NACHNAME, 
       PERSON.GEBURTSDATUM, 
       ADRESSE.STRASSE, 
       ADRESSE.HAUSNUMMER, 
       ADRESSE.TUERNUMMER, 
       POSTLEITZAHL.PLZ, 
       POSTLEITZAHL.ORTSNAME
FROM KUNDE JOIN PERSON ON KUNDE.PERSON_ID = PERSON.PERSON_ID
           JOIN ADRESSE ON ADRESSE.ADRESS_ID = PERSON.ADRESS_ID
           JOIN POSTLEITZAHL ON ADRESSE.PLZ = POSTLEITZAHL.PLZ;

COMMIT;