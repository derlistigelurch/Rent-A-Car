-- Kunden anlegen
--------------------------------------
/*
 * 1. Neuer PLZ, wenn ja einfügen?
 * 2. Gibt es die Adresse bereits, wenn nein einfügen?
 * 3. VORNAME, NACHNAME, GEBURTSDATUM, ADDRESS_ID in Personen Tabelle einfügen
 * 4. Verweis in Kunden Tabelle anlegen
*/

SELECT * FROM KUNDE;
SELECT * FROM PERSON;
SELECT * FROM ADRESSE;
SELECT * FROM POSTLEITZAHL;

-- 1. Neuer PLZ, wenn ja einfügen?
SELECT COUNT(*)
FROM POSTLEITZAHL
WHERE PLZ = '7540';

INSERT INTO POSTLEITZAHL ("PLZ", "ORTSNAME") VALUES (7540, 'Güssing');

-- 2. Gibt es die Adresse bereits, wenn nein einfügen?
SELECT COUNT(*)
FROM ADRESSE
WHERE STRASSE = 'Burggasse' AND
      HAUSNUMMER = 3;
      
INSERT INTO ADRESSE (ADRESS_ID, STRASSE, HAUSNUMMER, PLZ) VALUES (adresse_seq.NEXTVAL, 'Burggasse', 3, 7540);

-- 3. VORNAME, NACHNAME, GEBURTSDATUM, ADDRESS_ID in Personen Tabelle einfügen
INSERT INTO PERSON (PERSON_ID, VORNAME, NACHNAME, GEBURTSTDATUM, ADRESS_ID) VALUES (person_seq.NEXTVAL, 'Franz', 'Wilfinger', TO_DATE( '23/04/1987 07:35', 'DD/MM/YYYY HH24:MI' ), 7);

-- 4. Verweis in Kunden Tabelle anlegen
INSERT INTO  KUNDE (KUNDE_ID, PERSON_ID) VALUES (kunden_seq.NEXTVAL, 9);

-------------------------------------
-- Überprüfen ob alles funktioniert
SELECT KUNDE.KUNDE_ID, PERSON.VORNAME, PERSON.NACHNAME, PERSON.GEBURTSTDATUM, ADRESSE.STRASSE || ' ' || ADRESSE.HAUSNUMMER || '/' ||ADRESSE.TUERNUMMER AS Adresse, POSTLEITZAHL.PLZ || ' ' ||POSTLEITZAHL.ORTSNAME AS Ort
FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
            JOIN ADRESSE ON ADRESSE.ADRESS_ID = PERSON.ADRESS_ID
            JOIN POSTLEITZAHL ON ADRESSE.PLZ = POSTLEITZAHL.PLZ;

